#!/bin/bash

# credits: http://stackoverflow.com/questions/8653126/how-to-increment-version-number-in-a-shell-script
# increments minor version and zerorifies minor, i.e. 0.17.1 => 0.18.0

# Function to increment patch version (e.g., 1.2.3 => 1.2.4)
increment_patch_version() {
    declare -a part=( ${1//\./ } )
    part[2]=$((part[2] + 1))
    echo "${part[0]}.${part[1]}.${part[2]}"
}

# Function to increment minor version and zero patch (e.g., 1.2.3 => 1.3.0)
increment_minor_version() {
    declare -a part=( ${1//\./ } )
    declare    new
    declare -i carry=1

    for (( CNTR=${#part[@]}-2; CNTR>=0; CNTR-=1 )); do
        len=${#part[CNTR]}
        new=$((part[CNTR]+carry))
        [ ${#new} -gt $len ] && carry=1 || carry=0
        [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
    done
    part[2]=0 #zerorify patch version
    new="${part[*]}"
    echo -e "${new// /.}"
}

# Function to generate date-based version (e.g., 2026.1.28 - no leading zeros)
generate_date_version() {
    local year=$(date +%Y)
    local month=$(date +%-m)  # %-m removes leading zero
    local day=$(date +%-d)    # %-d removes leading zero
    echo "${year}.${month}.${day}"
}

# Get version type parameter (default: minor)
VERSION_TYPE=${1:-minor}

# Validate version type
case "$VERSION_TYPE" in
    patch|minor|date)
        ;;
    *)
        echo "Error: Invalid version type '$VERSION_TYPE'. Use 'patch', 'minor', or 'date'." >&2
        exit 1
        ;;
esac

# Handle date mode (doesn't need version.txt)
if [ "$VERSION_TYPE" = "date" ]; then
    generate_date_version
    exit 0
fi

# Read current version from version.txt
if [ ! -f "version.txt" ]; then
    echo "Error: version.txt not found. Required for patch/minor version types." >&2
    exit 1
fi

VERSION=$(cat version.txt)

# Validate version format (should be x.y.z)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format in version.txt. Expected format: x.y.z" >&2
    exit 1
fi

# Increment version based on type
case "$VERSION_TYPE" in
    patch)
        increment_patch_version "$VERSION"
        ;;
    minor)
        increment_minor_version "$VERSION"
        ;;
esac
