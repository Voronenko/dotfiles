#!/bin/sh

set -e

# PREVENT INTERACTIVE MERGE MESSAGE PROMPT AT A FINAL STEP
GIT_MERGE_AUTOEDIT=no
export GIT_MERGE_AUTOEDIT

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

GITBRANCHFULL=`git rev-parse --abbrev-ref HEAD`
GITBRANCH=`echo "$GITBRANCHFULL" | cut -d "/" -f 1`
RELEASETAG=`echo "$GITBRANCHFULL" | cut -d "/" -f 2`

print_info "Current branch: ${COLOR_BLUE}${GITBRANCHFULL}${COLOR_RESET}"
print_info "Release tag: ${COLOR_GREEN}${RELEASETAG}${COLOR_RESET}"

if [ $GITBRANCH != "release" ] ; then
   print_error "Release can be finished only on release branch!"
   return 1
fi

if [ -z $RELEASETAG ]
then
  print_error "We expect gitflow to be followed, make sure release branch called release/x.x.x.x"
  exit 1
fi

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

# Ensure you are on latest development branch and return back
print_info "Switching to ${DEVELOP_BRANCH} (development branch)..."
git checkout ${DEVELOP_BRANCH}
git pull origin ${DEVELOP_BRANCH}
git checkout -

# Ensure you are on latest production branch and return back
print_info "Switching to ${MASTER_BRANCH} (production branch)..."
git checkout ${MASTER_BRANCH}
git pull origin ${MASTER_BRANCH}
git checkout -

# UNCOMMENT THESE TWO LINES IF YOU BUMP VERSION AT THE END
#./bump-version.sh $RELEASETAG
#git commit -am "Bumps version to $RELEASETAG"

print_success "Finishing release ${RELEASETAG}..."
git flow release finish -m "release $RELEASETAG" $RELEASETAG

print_info "Pushing changes to remote..."
git push origin ${DEVELOP_BRANCH} && git push origin ${MASTER_BRANCH} --tags

print_success "Release ${RELEASETAG} finished successfully!"
