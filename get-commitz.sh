#!/bin/bash
#
#  Parse author arg
AUTHOR=$1
shift

PWD=$(pwd)


#   get it all in csv form:
#     -  author name, commit hash short, author timestamp, commit timestamp, files changed, additions, deletions
#
function get_commits() {
  local PWD=$(pwd)
  local repo=${PWD//\// }
  repo=$(echo $repo | awk '{print $NF}')
  git log --author=$AUTHOR --format=format:"%an, %h, %at, %ct" --shortstat --no-merges -n 10 | sed -E \
  '/./{H;$!d;} ;
  x ;
  s/ ([0-9]+) files* changed, ([0-9]+) insertions*\(\+\), ([0-9]+) deletions*\(-\)/, \1, \2, \3, '$repo'/ ;
  /insertion/!s/ ([0-9]+) files* changed, ([0-9]+) deletions*\(-\)/, \1, 0, \2, '$repo'/;
  /deletion/!s/ ([0-9]+) files* changed, ([0-9]+) insertions*\(\+\)/, \1, \2, 0, '$repo'/;
  s/\n//g'
}

#  Init header row
echo "author, commit hash, author time, commit time, files changed, insertions, deletions, repository"

#  Go to all
for var in "$@"
do
  cd $var
  get_commits
done

cd $PWD

echo $AllCommits