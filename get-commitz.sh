#!/bin/bash
#
#   USAGE:
#     ./get-commitz.sh '\(Name\sIsh\)|\email@ish.com\' path/to/repo path/to/repo2
#
#   ARGS:
#     - author: (optional) filter by author regex string
#     - repo path:
#
#   OUTPUT:
#     All commits from current directory git repo in csv form:
#     -  author name, commit hash short, author timestamp, commit timestamp, files changed, additions, deletions
#
#
function get_commits() {
  #  store repo title extracted from folder name
  local PWD=$(pwd)
  local repo=${PWD//\// }
  repo=$(echo $repo | awk '{print $NF}')

  #  the command
  git log --author="$1" --format=format:"%an, %H, %at, %ct, \"%D\", \"%s\"" --shortstat --no-merges | sed -E \
  '/./{H;$!d;} ;
  x ;
  s/ ([0-9]+) files* changed, ([0-9]+) insertions*\(\+\), ([0-9]+) deletions*\(-\)/, \1, \2, \3, '$repo'/ ;
  /insertion/!s/ ([0-9]+) files* changed, ([0-9]+) deletions*\(-\)/, \1, 0, \2, '$repo'/;
  /deletion/!s/ ([0-9]+) files* changed, ([0-9]+) insertions*\(\+\)/, \1, \2, 0, '$repo'/;
  s/\n//g'
}

if [ ! -d "$1" ];  then
  AUTHOR="$1"
  shift
else
  AUTHOR=".*"
fi

#   Save Directory
PWD=$(pwd)

#  Cycle through all git repo dirs and add rows
for var in "$@"
do
  cd $var
  get_commits "$AUTHOR"
done

#  Return to initial directory
cd $PWD
