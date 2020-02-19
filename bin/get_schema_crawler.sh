#!/bin/sh

########################
# Variables and defaults
########################

# Modify this for whatever version you're trying to download
_SCH_VERSION='16.4.1'

# Pick your own temp dir
# Note that the zip archive by default creates and unzips into a subdir,
#   e.g. `schemacrawler-15.06.01-distribution`
_TEMPDIR=/tmp

# Pick the path to store the app and the shell script
# NOTE: The parent dir – e.g. /usr/local/opt – must be writable
_INSTALL_DIR=~/apps/schemacrawler

# Pick the symlink for the path; ideally, it's a path that is in your system's executable PATH
# NOTE: The executable PATH – e.g. /usr/local/bin – must be writable
_SCH_SYMLINK=~/dotfiles/bin/schemacrawler


#####
# These defaults are derived from above

# The filename stem for the downloadable zip, as it exists on the Github filesystem,
#   and the subdir it creates when unzipped
_SCH_FNAME="schemacrawler-${_SCH_VERSION}-distribution"
_SCH_URL="https://github.com/schemacrawler/SchemaCrawler/releases/download/v${_SCH_VERSION}/${_SCH_FNAME}.zip"
_SCH_ZNAME="${_TEMPDIR}/${_SCH_FNAME}.zip"
# `schema-launcher.sh` is just the arbitrary name from which the symlink will be based
_SCH_SCRIPT_NAME="${_INSTALL_DIR}/schema-launcher.sh"


#########
# Actions
#########

# Download and unzip into $_TEMPDIR
mkdir -p ${_TEMPDIR}
printf "\nDownloading\n\t ${_SCH_URL} \n\tinto temporary directory: ${_TEMPDIR}\n\n"
curl -Lo ${_SCH_ZNAME} ${_SCH_URL}
unzip ${_SCH_ZNAME} -d ${_TEMPDIR}
printf "\n\n"

# Move subdir from release package into /usr/local/opt
printf "\nMoving contents of /tmp/${_SCH_FNAME}/_schemacrawler/ \n\tinto ${_INSTALL_DIR}"
mkdir -p ${_INSTALL_DIR}
cp -r /tmp/${_SCH_FNAME}/_schemacrawler/ ${_INSTALL_DIR}

# create the shell script manually
# https://stackoverflow.com/questions/2953081/how-can-i-write-a-heredoc-to-a-file-in-bash-script
printf "\n\nCreating ${_SCH_SCRIPT_NAME}"

# The shell code below is a variation of what's found at:
# https://github.com/schemacrawler/SchemaCrawler/blob/a3fea8be74ae28d6e8318c14f2c3f4be314efe2a/schemacrawler-distrib/src/assembly/schemacrawler.sh
cat << SCSCRIPT > ${_SCH_SCRIPT_NAME}
#!/usr/bin/env bash
SCHEMACRAWL_DIR=${_INSTALL_DIR}
java -cp \$(echo \${SCHEMACRAWL_DIR}/lib/*.jar | tr ' ' ':'):\${SCHEMACRAWL_DIR}/config schemacrawler.Main "\$@"
SCSCRIPT

# make the shell script executable and symlink it
printf "\n\nSymlinking ${_SCH_SCRIPT_NAME} \n\tto ${_SCH_SYMLINK}\n\n"
chmod +x ${_SCH_SCRIPT_NAME}
ln -sf ${_SCH_SCRIPT_NAME} ${_SCH_SYMLINK}
