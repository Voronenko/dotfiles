#!/bin/bash

# This script cleans all cache for Microsoft Teams on Linux

# clear_cache_msteams.sh ( deb-stable | deb-insider | snap )

# Variable process name is defined on case statement.

case $1 in
  deb-stable)
    export TEAMS_PROCESS_NAME=teams
    cd "$HOME"/.config/Microsoft/Microsoft\ Teams || exit 1
  ;;
  deb-insider)
    export TEAMS_PROCESS_NAME=teams-insiders
    cd "$HOME"/.config/Microsoft/Microsoft\ Teams\ -\ Insiders || exit 1
  ;;
  snap)
    export TEAMS_PROCESS_NAME=teams
    cd "$HOME"/snap/teams/current/.config/Microsoft/Microsoft\ Teams || exit 1
  ;;
  *)
    echo "Use $0 ( deb-stable | deb-insider | snap) as parameter."
    exit 1
  ;;
esac

# Test if Microsoft Teams is running
if [ "$(pgrep ${TEAMS_PROCESS_NAME} | wc -l)" -gt 1 ]
then
  rm -rf Application\ Cache/Cache/*
  rm -rf blob_storage/*
  rm -rf Cache/* # Main cache
  rm -rf Code\ Cache/js/*
  rm -rf databases/*
  rm -rf GPUCache/*
  rm -rf IndexedDB/*
  rm -rf Local\ Storage/*
  #rm -rf backgrounds/* # Background function presents on Teams for Windows only.
  find ./ -maxdepth 1 -type f -name "*log*" -exec rm {} \;
  sleep 5
  killall ${TEAMS_PROCESS_NAME}
  # After this, MS Teams will open again.
else
  echo "Microsoft Teams is not running."
  exit
fi
