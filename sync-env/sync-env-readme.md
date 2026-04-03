# Environment Variable Sync Tool

Synchronizes environment variable values across multiple `.env` files in the project.

## Features

- **Declarative configuration** - Define sync rules once in `sync-env.conf`
- **Variable name mapping** - Same value, different names across services
- **Dry-run mode** - Preview changes before applying
- **Validation** - Check consistency of synced values
- **Backup support** - Backup all env files before making changes
- **Interactive mode** - Prompt for missing values
- **Git worktree support** - Works with git worktrees

## Repository Discovery

The script automatically discovers the repository root:
1. **ENV_SYNC_REPO_ROOT** environment variable (highest priority)
2. **git rev-parse --show-toplevel** (supports worktrees)
3. Fallback to relative path from script location

Example:
```bash
# Set custom repo root (useful for worktrees or non-standard layouts)
export ENV_SYNC_REPO_ROOT=/path/to/your/repo
./sync-env.sh --list
```

## Why This Tool Exists

In a multi-service project, the same value often needs to be set in multiple `.env` files, sometimes with different variable names. For example:

- `JWT_SECRET` in `agents/.env`
- `SERVER_SIGNING_KEY` in `backend/.env.local`

These **must have the same value** for JWT verification to work, but they have different names.

This tool provides a declarative way to define which values should be synchronized across services.

## Quick Start

```bash
# Sync a specific value to all configured files
./sync-env.sh LINKED_ACCOUNT_OWNER_ID=your-id-here

# Dry run to see what would change
./sync-env.sh --dry-run JWT_SECRET=my-secret-value

# Show current value of a variable across all files
./sync-env.sh --show JWT_SECRET

# Validate that synced values are consistent
./sync-env.sh --validate

# List all configured sync mappings
./sync-env.sh --list

# Backup all configured env files
./sync-env.sh --backup

# Interactive mode - prompts for all undefined values
./sync-env.sh --interactive
```

## Configuration

Edit `sync-env.conf` to define sync rules.

### Format

```
# Comment lines start with #
variable_name | target_file_path | target_variable_name
```

- `variable_name`: Canonical name (used as source)
- `target_file_path`: Path to `.env` file (relative to repo root)
- `target_variable_name`: Variable name in target file (optional, defaults to `variable_name`)

### Examples

```
# Same variable name across files
LINKED_ACCOUNT_OWNER_ID | agents/.env
LINKED_ACCOUNT_OWNER_ID | agents/dev-harness/.env.local
LINKED_ACCOUNT_OWNER_ID | bot/.env.local

# Same value, different variable names (JWT secret must match)
JWT_SECRET | agents/.env
JWT_SECRET | bot/.env.local
SERVER_SIGNING_KEY | backend/.env.local | JWT_SECRET
```

### Complete Example: Multi-Service Application

Consider a project with three services: **api**, **frontend**, **worker**. Some values need to be shared across services with consistent values.

#### sync-env.conf

```bash
# =============================================================================
# Example Configuration for Multi-Service Application
# =============================================================================

# -----------------------------------------------------------------------------
# Section: Authentication
# -----------------------------------------------------------------------------
# JWT secret used by API and worker for token verification
# Same value, different variable names across services
JWT_SHARED_SECRET | api/.env
JWT_SHARED_SECRET | worker/.env | JWT_SECRET

# -----------------------------------------------------------------------------
# Section: API Configuration
# -----------------------------------------------------------------------------
# API URL that worker and frontend both need to connect
API_BASE_URL | frontend/.env
API_BASE_URL | worker/.env | WORKER_API_URL

# API key for internal service communication
INTERNAL_API_KEY | api/.env
INTERNAL_API_KEY | worker/.env | SERVICE_API_KEY
INTERNAL_API_KEY | frontend/.env | SERVICE_API_KEY

# -----------------------------------------------------------------------------
# Section: Database Configuration
# -----------------------------------------------------------------------------
# Database connection string (only api and worker need it)
DATABASE_URL | api/.env
DATABASE_URL | worker/.env

# -----------------------------------------------------------------------------
# Section: Feature Flags
# -----------------------------------------------------------------------------
# Feature flags that should be consistent across all services
ENABLE_FEATURE_X | frontend/.env
ENABLE_FEATURE_X | worker/.env
ENABLE_FEATURE_X | api/.env
```

#### Running the Sync Tool

```bash
# Set the JWT secret (syncs to api/.env as JWT_SHARED_SECRET and worker/.env as JWT_SECRET)
./sync-env.sh JWT_SHARED_SECRET=super-secret-key-12345

# Set the API URL (syncs to frontend/.env as API_BASE_URL and worker/.env as WORKER_API_URL)
./sync-env.sh API_BASE_URL=https://api.example.com

# Set the internal API key (syncs with different names to each service)
./sync-env.sh INTERNAL_API_KEY=sk-live-abc123xyz
```

#### Resulting .env Files

After running the sync commands, your environment files would look like:

**api/.env**
```env
JWT_SHARED_SECRET=super-secret-key-12345
INTERNAL_API_KEY=sk-live-abc123xyz
SERVICE_API_KEY=sk-live-abc123xyz
DATABASE_URL=postgresql://localhost/mydb
ENABLE_FEATURE_X=true
```

**frontend/.env**
```env
API_BASE_URL=https://api.example.com
SERVICE_API_KEY=sk-live-abc123xyz
ENABLE_FEATURE_X=true
```

**worker/.env**
```env
JWT_SECRET=super-secret-key-12345
WORKER_API_URL=https://api.example.com
SERVICE_API_KEY=sk-live-abc123xyz
DATABASE_URL=postgresql://localhost/mydb
ENABLE_FEATURE_X=true
```

#### Key Points

1. **Variable Name Mapping**: `JWT_SHARED_SECRET` → api, but `JWT_SECRET` → worker (same value)
2. **API URL Mapping**: `API_BASE_URL` → frontend, but `WORKER_API_URL` → worker
3. **Consistent Values**: `INTERNAL_API_KEY` has the same value across all three files
4. **Selective Sync**: `DATABASE_URL` only goes to api and worker (frontend doesn't need it)
5. **Feature Flags**: `ENABLE_FEATURE_X` is consistent across all services

## Use Cases

### Sync JWT Secret Across Services

```bash
# Generate a new secret and sync everywhere
openssl rand -base64 32 | xargs ./sync-env.sh JWT_SECRET
```

### Backup Before Making Changes

```bash
# Backup all configured env files
./sync-env.sh --backup

# Creates: $HOME/tmp/repo-name-yyyymmdd-hhmm/
# With directory structure preserved
```

### Validate Configuration

```bash
# Check that all synced values are consistent
./sync-env.sh --validate
```

## Options

| Option | Description |
|--------|-------------|
| `--dry-run` | Show what would change without modifying files |
| `--verbose` | Show detailed output |
| `--list` | List all configured sync mappings |
| `--show VAR` | Show current value of VAR across all files |
| `--validate` | Validate that synced values are consistent |
| `--interactive` | Prompt for missing values interactively |
| `--backup` | Backup all configured env files to `$HOME/tmp/` |
| `--config FILE` | Use custom config file |
| `--help` | Show help message |

## Adding New Sync Rules

1. Edit `sync-env.conf`
2. Add your rule following the format
3. Use `--list` to verify it's loaded

Example:

```
# Add to sync-env.conf
MY_NEW_VALUE | agents/.env
MY_NEW_VALUE | backend/.env.local | DIFFERENT_NAME_HERE
```
