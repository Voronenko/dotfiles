#!/usr/bin/env bash
# =============================================================================
# Environment Variable Sync Script
# =============================================================================
#
# Syncs environment variable values across multiple .env files based on
# a declarative configuration file.
#
# USAGE:
#   ./sync-env.sh [options] [variable=value ...]
#
# OPTIONS:
#   --dry-run       Show what would change without modifying files
#   --verbose       Show detailed output
#   --list          List all configured sync mappings
#   --config FILE   Use custom config file (default: ./sync-vars.conf)
#   --interactive   Prompt for missing values interactively
#   --show VALUE    Show current value of a variable across all files
#   --validate      Validate that synced values are consistent
#   --backup        Backup all env files to $HOME/tmp/repo-name-yyyymmdd-hhmm/
#   --help          Show this help message
#
# ENVIRONMENT VARIABLES:
#   ENV_SYNC_REPO_ROOT   Override repository root detection (supports worktrees)
#
# EXAMPLES:
#   # Sync a specific value to all configured files
#   ./sync-env.sh LINKED_ACCOUNT_OWNER_ID=5bdd6f89...
#
#   # Interactive mode - prompts for all undefined values
#   ./sync-env.sh --interactive
#
#   # Dry run to see what would change
#   ./sync-env.sh --dry-run JWT_SECRET=new-secret
#
#   # Validate consistency of synced values
#   ./sync-env.sh --validate
#
#   # Show current value of a variable across all files
#   ./sync-env.sh --show JWT_SECRET
#
#   # Backup all configured env files
#   ./sync-env.sh --backup
#
# =============================================================================

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/sync-env.conf"

# Discover repository root:
# 1. Use ENV_SYNC_REPO_ROOT environment variable if set
# 2. Otherwise, discover via git (supports worktrees)
discover_repo_root() {
    # Check if environment variable is set
    if [[ -n "${ENV_SYNC_REPO_ROOT:-}" ]]; then
        if [[ -d "$ENV_SYNC_REPO_ROOT" ]]; then
            echo "$ENV_SYNC_REPO_ROOT"
            return 0
        else
            echo "Warning: ENV_SYNC_REPO_ROOT is set but directory does not exist: $ENV_SYNC_REPO_ROOT" >&2
        fi
    fi

    # Discover via git
    if command -v git >/dev/null 2>&1; then
        # git rev-parse --show-toplevel works for both regular repos and worktrees
        local git_root
        git_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
        if [[ -n "$git_root" && -d "$git_root" ]]; then
            echo "$git_root"
            return 0
        fi
    fi

    # Fallback: assume script is in scripts/env-sync/ within repo
    local fallback_root
    fallback_root="$(cd "$SCRIPT_DIR/../.." && pwd)"
    echo "$fallback_root"
    return 0
}

REPO_ROOT="$(discover_repo_root)"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly GRAY='\033[0;90m'
readonly NC='\033[0m' # No Color

# =============================================================================
# Logging Functions
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

log_debug() {
    if [[ "${VERBOSE:-0}" == "1" ]]; then
        echo -e "${GRAY}[DEBUG]${NC} $*" >&2
    fi
}

log_var() {
    echo -e "${CYAN}[VAR]${NC} $*"
}

# =============================================================================
# Help Function
# =============================================================================

show_help() {
    sed -n '/^# USAGE/,/^# \*\*\*\**/p' "${BASH_SOURCE[0]}" | sed 's/^# //' | sed 's/^#//'
    exit 0
}

# =============================================================================
# Parse Configuration File
# =============================================================================

# Array to store sync rules
declare -a SYNC_RULES=()
declare -a VAR_NAMES=()

parse_config() {
    local config_file="$1"

    if [[ ! -f "$config_file" ]]; then
        log_error "Config file not found: $config_file"
        exit 1
    fi

    log_debug "Parsing config file: $config_file"

    while IFS='|' read -r source_var target_file target_var; do
        # Skip comments and empty lines
        [[ "$source_var" =~ ^#.*$ ]] && continue
        [[ -z "$source_var" ]] && continue

        # Trim whitespace
        source_var=$(echo "$source_var" | xargs)
        target_file=$(echo "$target_file" | xargs)
        target_var=$(echo "${target_var:-$source_var}" | xargs)

        # Resolve relative path
        if [[ "$target_file" != /* ]]; then
            target_file="${REPO_ROOT}/${target_file}"
        fi

        SYNC_RULES+=("${source_var}|${target_file}|${target_var}")

        # Track unique variable names
        if [[ ! " ${VAR_NAMES[*]} " =~ " ${source_var} " ]]; then
            VAR_NAMES+=("$source_var")
        fi

        log_debug "Rule: $source_var -> $target_file:$target_var"
    done < "$config_file"

    log_info "Loaded ${#SYNC_RULES[@]} sync rules for ${#VAR_NAMES[@]} unique variables"
}

# =============================================================================
# Get/Set Variable Values
# =============================================================================

get_value_from_env() {
    local var_name="$1"
    local env_file="$2"

    if [[ ! -f "$env_file" ]]; then
        return 1
    fi

    # Try to get the value (handle both quoted and unquoted values)
    local value
    value=$(grep -E "^${var_name}=" "$env_file" 2>/dev/null | head -n1 | cut -d'=' -f2- || true)

    if [[ -n "$value" ]]; then
        # Remove leading/trailing whitespace and quotes
        value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/^["'\'']\|["'\'']$//g')
        echo "$value"
        return 0
    fi

    return 1
}

get_value_for_var() {
    local var_name="$1"

    # Check environment variable first
    if [[ -n "${!var_name:-}" ]]; then
        echo "${!var_name}"
        return 0
    fi

    # Search in configured files for this variable
    for rule in "${SYNC_RULES[@]}"; do
        IFS='|' read -r source_var target_file target_var <<< "$rule"

        if [[ "$source_var" == "$var_name" ]]; then
            local value
            value=$(get_value_from_env "$source_var" "$target_file" 2>/dev/null || true)
            if [[ -n "$value" ]]; then
                echo "$value"
                return 0
            fi
        fi
    done

    return 1
}

set_value_in_env() {
    local var_name="$1"
    local value="$2"
    local env_file="$3"
    local dry_run="${4:-0}"

    # Create directory if it doesn't exist
    local env_dir
    env_dir="$(dirname "$env_file")"
    if [[ ! -d "$env_dir" ]]; then
        log_debug "Creating directory: $env_dir"
        if [[ "$dry_run" == "0" ]]; then
            mkdir -p "$env_dir"
        fi
    fi

    # Check if file exists and if variable exists
    if [[ -f "$env_file" ]]; then
        if grep -q "^${var_name}=" "$env_file" 2>/dev/null; then
            # Update existing variable
            local current_value
            current_value=$(get_value_from_env "$var_name" "$env_file" 2>/dev/null || echo "")

            if [[ "$current_value" == "$value" ]]; then
                log_debug "  $env_file:$var_name already set to $value"
                return 0
            fi

            log_info "  Updating $env_file:$var_name"
            if [[ "$dry_run" == "0" ]]; then
                # Use sed for in-place update (works on Linux and macOS with gsed)
                if sed --version 2>/dev/null | grep -q GNU; then
                    sed -i "s/^${var_name}=.*/${var_name}=${value}/" "$env_file"
                else
                    # macOS requires -i ''
                    sed -i '' "s/^${var_name}=.*/${var_name}=${value}/" "$env_file"
                fi
            else
                echo "  Would update: $env_file:$var_name=$value"
            fi
        else
            # Append new variable
            log_info "  Adding $env_file:$var_name"
            if [[ "$dry_run" == "0" ]]; then
                echo "${var_name}=${value}" >> "$env_file"
            else
                echo "  Would add: $env_file:$var_name=$value"
            fi
        fi
    else
        # Create new file
        log_info "  Creating $env_file with $var_name"
        if [[ "$dry_run" == "0" ]]; then
            echo "${var_name}=${value}" > "$env_file"
        else
            echo "  Would create: $env_file with $var_name=$value"
        fi
    fi
}

# =============================================================================
# Sync Functions
# =============================================================================

sync_variable() {
    local var_name="$1"
    local value="${2:-}"
    local dry_run="${DRY_RUN:-0}"

    log_info "Syncing: $var_name"

    # Get value if not provided
    if [[ -z "$value" ]]; then
        value=$(get_value_for_var "$var_name" || true)
        if [[ -z "$value" ]]; then
            log_warning "No value found for $var_name (use $var_name=value to set)"
            return 1
        fi
    fi

    log_var "$var_name=$value"

    # Apply to all matching rules
    for rule in "${SYNC_RULES[@]}"; do
        IFS='|' read -r source_var target_file target_var <<< "$rule"

        if [[ "$source_var" == "$var_name" ]]; then
            set_value_in_env "$target_var" "$value" "$target_file" "$dry_run"
        fi
    done

    log_success "Synced $var_name"
}

show_variable() {
    local var_name="$1"
    local found=0

    echo ""
    echo -e "${CYAN}Current values for: $var_name${NC}"
    echo "─────────────────────────────────────────────"

    for rule in "${SYNC_RULES[@]}"; do
        IFS='|' read -r source_var target_file target_var <<< "$rule"

        if [[ "$source_var" == "$var_name" || "$target_var" == "$var_name" ]]; then
            local rel_file="${target_file#$REPO_ROOT/}"
            local value
            value=$(get_value_from_env "$target_var" "$target_file" 2>/dev/null || echo "<not set>")

            if [[ "$value" != "<not set>" ]]; then
                echo -e "  ${GREEN}✓${NC} ${rel_file}:${target_var}"
                echo "     ${GRAY}${value}${NC}"
            else
                echo -e "  ${YELLOW}○${NC} ${rel_file}:${target_var} ${GRAY}(not set)${NC}"
            fi
            found=1
        fi
    done

    if [[ "$found" == "0" ]]; then
        log_warning "No configuration found for: $var_name"
    fi

    echo ""
}

validate_sync() {
    local errors=0

    echo ""
    echo -e "${CYAN}Validating synced variables...${NC}"
    echo "─────────────────────────────────────────────"

    for var_name in "${VAR_NAMES[@]}"; do
        local -A file_values=()
        local mismatch=0

        # Collect all values for this variable
        for rule in "${SYNC_RULES[@]}"; do
            IFS='|' read -r source_var target_file target_var <<< "$rule"

            if [[ "$source_var" == "$var_name" ]]; then
                local rel_file="${target_file#$REPO_ROOT/}"
                local value
                value=$(get_value_from_env "$target_var" "$target_file" 2>/dev/null || echo "")

                if [[ -n "$value" ]]; then
                    file_values["$rel_file"]="$value"
                fi
            fi
        done

        # Check for mismatches
        if [[ ${#file_values[@]} -gt 1 ]]; then
            local first_value
            first_value=""
            for file in "${!file_values[@]}"; do
                if [[ -z "$first_value" ]]; then
                    first_value="${file_values[$file]}"
                elif [[ "${file_values[$file]}" != "$first_value" ]]; then
                    log_error "Mismatch for $var_name:"
                    for f in "${!file_values[@]}"; do
                        echo "  $f: ${file_values[$f]}"
                    done
                    echo ""
                    mismatch=1
                    break
                fi
            done

            if [[ "$mismatch" == "1" ]]; then
                ((errors++))
            fi
        fi
    done

    echo "─────────────────────────────────────────────"
    if [[ $errors -eq 0 ]]; then
        log_success "All synced variables are consistent!"
        return 0
    else
        log_error "Found $errors mismatched variable(s)"
        return 1
    fi
}

list_mappings() {
    echo ""
    echo -e "${CYAN}Configured Sync Mappings${NC}"
    echo "════════════════════════════════════════════"

    for var_name in "${VAR_NAMES[@]}"; do
        echo ""
        echo -e "${GREEN}$var_name${NC}"
        for rule in "${SYNC_RULES[@]}"; do
            IFS='|' read -r source_var target_file target_var <<< "$rule"

            if [[ "$source_var" == "$var_name" ]]; then
                local rel_file="${target_file#$REPO_ROOT/}"
                local current_value
                current_value=$(get_value_from_env "$target_var" "$target_file" 2>/dev/null || echo "")

                if [[ "$target_var" != "$source_var" ]]; then
                    echo "  → $rel_file:${YELLOW}${target_var}${NC} (mapped from $source_var)"
                else
                    echo "  → $rel_file"
                fi

                if [[ -n "$current_value" ]]; then
                    local display_value="$current_value"
                    if [[ ${#current_value} -gt 50 ]]; then
                        display_value="${current_value:0:50}..."
                    fi
                    echo "    ${GRAY}Current: ${display_value}${NC}"
                fi
            fi
        done
    done
    echo ""
}

# =============================================================================
# Interactive Mode
# =============================================================================

interactive_mode() {
    log_info "Interactive mode - prompting for undefined values"
    echo ""

    for var_name in "${VAR_NAMES[@]}"; do
        local current_value
        current_value=$(get_value_for_var "$var_name" 2>/dev/null || echo "")

        if [[ -n "$current_value" ]]; then
            log_debug "Skipping $var_name (already set)"
            continue
        fi

        # Determine if sensitive (contains SECRET, KEY, TOKEN, PASSWORD)
        local is_sensitive=0
        if [[ "$var_name" =~ (SECRET|KEY|TOKEN|PASSWORD) ]]; then
            is_sensitive=1
        fi

        # Prompt for value
        local prompt_text="$var_name"
        if [[ "$is_sensitive" == "1" ]]; then
            read -sp "Enter value for $prompt_text: " input_value
            echo ""
        else
            read -p "Enter value for $prompt_text: " input_value
        fi

        if [[ -n "$input_value" ]]; then
            sync_variable "$var_name" "$input_value"
        else
            log_warning "Skipping $var_name (no value provided)"
        fi
    done
}

# =============================================================================
# Backup Mode
# =============================================================================

backup_env_files() {
    log_info "Backing up all configured env files..."

    # Ensure tmp directory exists
    local tmp_dir="${HOME}/tmp"
    if [[ ! -d "$tmp_dir" ]]; then
        log_debug "Creating directory: $tmp_dir"
        mkdir -p "$tmp_dir"
    fi

    # Get repository name for backup folder
    local repo_name
    repo_name="$(basename "$REPO_ROOT")"

    # Create backup directory with timestamp
    local timestamp
    timestamp="$(date +%Y%m%d-%H%M)"
    local backup_dir="${tmp_dir}/${repo_name}-${timestamp}"

    if [[ -d "$backup_dir" ]]; then
        log_error "Backup directory already exists: $backup_dir"
        return 1
    fi

    mkdir -p "$backup_dir"
    log_success "Created backup directory: $backup_dir"

    # Track unique env files
    declare -A env_files=()

    # Collect all unique env files from sync rules
    for rule in "${SYNC_RULES[@]}"; do
        IFS='|' read -r source_var target_file target_var <<< "$rule"

        if [[ -f "$target_file" ]]; then
            # Get relative path from repo root
            local rel_path="${target_file#$REPO_ROOT/}"
            env_files["$target_file"]="$rel_path"
        fi
    done

    # Copy each env file preserving structure
    local copied_count=0
    for target_file in "${!env_files[@]}"; do
        local rel_path="${env_files[$target_file]}"
        local backup_file="${backup_dir}/${rel_path}"

        # Create parent directory if needed
        local backup_parent
        backup_parent="$(dirname "$backup_file")"
        if [[ ! -d "$backup_parent" ]]; then
            mkdir -p "$backup_parent"
        fi

        # Copy the file
        cp "$target_file" "$backup_file"
        log_info "  Copied: $rel_path"
        copied_count=$((copied_count + 1))
    done

    echo ""
    log_success "Backup complete! Copied $copied_count file(s) to: $backup_dir"
    echo ""

    # Show backup structure with tree (if available) or find
    if command -v tree >/dev/null 2>&1; then
        echo -e "${CYAN}Backup structure:${NC}"
        tree -a -L 3 "$backup_dir" 2>/dev/null || find "$backup_dir" -type f | sort
    else
        echo -e "${CYAN}Backup structure:${NC}"
        find "$backup_dir" -type f | sort | sed "s|$backup_dir||"
    fi

    echo ""
    log_info "To restore from backup, copy files back:"
    echo "  cp -r ${backup_dir}/* ${REPO_ROOT}/"
}

# =============================================================================
# Main
# =============================================================================

main() {
    local dry_run=0
    local interactive=0
    local show_var=""
    local validate_only=0
    local list_only=0
    local backup_only=0
    declare -a vars_to_sync=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                dry_run=1
                shift
                ;;
            --verbose|-v)
                VERBOSE=1
                shift
                ;;
            --config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            --list)
                list_only=1
                shift
                ;;
            --interactive|-i)
                interactive=1
                shift
                ;;
            --show)
                show_var="$2"
                shift 2
                ;;
            --validate)
                validate_only=1
                shift
                ;;
            --backup)
                backup_only=1
                shift
                ;;
            --help|-h)
                show_help
                ;;
            -*)
                log_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
            *=*)
                vars_to_sync+=("$1")
                shift
                ;;
            *)
                log_error "Unknown argument: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Parse configuration
    parse_config "$CONFIG_FILE"

    # Handle special modes
    if [[ "$list_only" == "1" ]]; then
        list_mappings
        exit 0
    fi

    if [[ -n "$show_var" ]]; then
        show_variable "$show_var"
        exit 0
    fi

    if [[ "$validate_only" == "1" ]]; then
        validate_sync
        exit $?
    fi

    if [[ "$interactive" == "1" ]]; then
        interactive_mode
        exit 0
    fi

    if [[ "$backup_only" == "1" ]]; then
        backup_env_files
        exit 0
    fi

    # Sync specified variables
    if [[ ${#vars_to_sync[@]} -eq 0 ]]; then
        log_info "No variables specified. Use --list to see configured mappings."
        log_info "Example: $0 LINKED_ACCOUNT_OWNER_ID=your-value-here"
        exit 0
    fi

    for var_spec in "${vars_to_sync[@]}"; do
        local var_name="${var_spec%%=*}"
        local var_value="${var_spec#*=}"

        if [[ "$var_value" == "$var_spec" ]]; then
            # No = provided, try to get existing value
            sync_variable "$var_name" ""
        else
            # Export as environment variable for get_value_for_var
            export "$var_name=$var_value"
            sync_variable "$var_name" "$var_value"
        fi
    done

    if [[ "$dry_run" == "1" ]]; then
        log_info "Dry run complete. No files were modified."
    else
        log_success "Sync complete!"
    fi
}

main "$@"
