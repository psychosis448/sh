#!/bin/bash
# file: backup.sh
# description: wrapper for rsync
# author: psychosis448
# date: 2020-04-04
# version: 0.1
# bash_version: 5.0.16

# rsync options:
# a - archive mode; equals -rlptgoD
#     if --files-from is specified, -r is not implied
# A - preserve ACLs (implies -p)
# h - human readable
# n - dry run
# r - recurse into directories
# P - progress
# R - use relative path names
# v - increase verbosity
# X - preserve extended attributes

if ! command -v rsync > /dev/null; then
  echo "error: rsync is not installed" >&2
  exit 1
fi

__usage="
Usage: $(basename $0) [OPTIONS]

Expects: .rsyncinclude and .rsyncexclude in \$HOME

Options:
  -s, specify source
  -t, specify target
  -i, include file
  -e, exclude file
  -h, print help
"
__source="$HOME/"
__target="/mnt/backup"
__include_file="$HOME/.rsyncinclude"
__exclude_file="$HOME/.rsyncexclude"

check_target(){
  if ! grep -qs "$__target" /proc/mounts; then
    echo "error: target not mounted" >&2
    exit 1
  fi
}

backup(){
  check_target
  rsync \
  -aAPrRvX \
  $1 \
  --delete \
  --files-from="$__include_file" \
  --exclude-from="$__exclude_file" \
  "$__source" \
  "$__target"
}

while getopts hs:t:i:e: option; do
  case "$option" in
    h)	echo "$__usage"
      exit 0
      ;;
    s)	__source="$OPTARG"
      ;;
    t)	__target="$OPTARG"
      ;;
    i)	__include_file="$OPTARG"
      ;;
    e)	__exclude_file="$OPTARG"
      ;;
    [?])
      echo "$__usage"
      exit 0
      ;;
  esac
done

backup "-n"

read -p $'\n'"perform backup? [y/n] " __execute

if [ "$__execute" = "y" ]; then
  echo "backing up..."
  backup ""
  echo "...done"
else
  echo "...aborting"
fi

exit 0
