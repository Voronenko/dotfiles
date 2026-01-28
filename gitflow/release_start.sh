#!/bin/sh

set -e

# Color definitions
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[0;33m'
COLOR_RED='\033[0;31m'

# Print functions
print_info() {
    echo -e "${COLOR_BLUE}ℹ️  $1${COLOR_RESET}"
}

print_success() {
    echo -e "${COLOR_GREEN}✓ $1${COLOR_RESET}"
}

print_warning() {
    echo -e "${COLOR_YELLOW}⚠️  $1${COLOR_RESET}"
}

print_error() {
    echo -e "${COLOR_RED}✗ $1${COLOR_RESET}"
}

# Parse arguments
# Usage: gitflow-release-start [patch|minor|date]
# Examples:
#   gitflow-release-start          # Auto-calculate next minor version (default)
#   gitflow-release-start patch     # Auto-calculate next patch version
#   gitflow-release-start minor     # Auto-calculate next minor version (explicit)
#   gitflow-release-start date      # Use date-based version

VERSION_TYPE=$1

# Default to minor if no version type specified
if [ -z "$VERSION_TYPE" ]; then
    VERSION_TYPE="minor"
fi

# Validate version type
case "$VERSION_TYPE" in
    patch|minor|date)
        ;;
    *)
        print_error "Invalid version type '$VERSION_TYPE'. Use 'patch', 'minor', or 'date'."
        exit 1
        ;;
esac

# Calculate version from version.txt based on version type
VERSION=`~/dotfiles/gitflow/bump-version-drynext.sh $VERSION_TYPE`

print_info "Version type: ${COLOR_BLUE}${VERSION_TYPE}${COLOR_RESET}"
print_info "Version to release: ${COLOR_GREEN}${VERSION}${COLOR_RESET}"

if [ ! -d ".git" ]; then
  cd $(git rev-parse --show-cdup)
fi

# Function to get gitflow branch configuration
get_gitflow_branch() {
    local branch_type=$1
    local default_value=$2
    local config_value=$(git config --get "gitflow.branch.$branch_type" 2>/dev/null || echo "")

    if [ -n "$config_value" ]; then
        echo "$config_value"
    else
        echo "$default_value"
    fi
}

# Get branch names from gitflow config or use defaults
MASTER_BRANCH=$(get_gitflow_branch "master" "master")
DEVELOP_BRANCH=$(get_gitflow_branch "develop" "develop")

print_info "Using production branch: ${COLOR_BLUE}${MASTER_BRANCH}${COLOR_RESET}"
print_info "Using development branch: ${COLOR_BLUE}${DEVELOP_BRANCH}${COLOR_RESET}"

# Initialize gitflow only if not already configured
if ! git config --get gitflow.branch.master >/dev/null 2>&1; then
    print_info "Gitflow not configured. Initializing with defaults..."
    git flow init -d
else
    print_success "Gitflow already configured. Using existing settings."
fi

# Ensure you are on latest development branch
print_info "Switching to ${DEVELOP_BRANCH} (development branch)..."
git checkout ${DEVELOP_BRANCH}
git pull origin ${DEVELOP_BRANCH}

# Ensure you are on latest production branch
print_info "Switching to ${MASTER_BRANCH} (production branch)..."
git checkout ${MASTER_BRANCH}
git pull origin ${MASTER_BRANCH}

# Return to development branch
git checkout ${DEVELOP_BRANCH}

# Ensure production branch has no conflicts with development branch
print_info "Merging ${MASTER_BRANCH} into ${DEVELOP_BRANCH} to ensure no conflicts..."
git merge ${MASTER_BRANCH}

print_success "Starting release branch for version: ${VERSION}"
git flow release start ${VERSION}

print_info "Bumping version to ${VERSION}..."
~/dotfiles/gitflow/bump-version.sh ${VERSION}
git commit -am "Bumps version to ${VERSION}"

print_info "Pushing changes to remote..."
git push

#git checkout develop

# COMMENT LINES BELOW IF YOU BUMP VERSION AT THE END
#NEXTVERSION=`~/dotfiles/gitflow/bump-version-drynext.sh`
#~/dotfiles/gitflow/bump-version.sh $NEXTVERSION
#git commit -am "Bumps version to $NEXTVERSION"
#git push origin develop
