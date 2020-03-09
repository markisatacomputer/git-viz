#!/bin/bash
#
#   Vacuum up all the commits
#
#    - repoz.csv lists git repo paths and author args, one entry per line
#         eg.
#             Mark N, $HOME/repos/my-project     ### This will output commits with arg --author="Mark N"
#             , $HOME/repos/my-solo-project      ### This will output all commits
#
#
#
EXPORT_PATH="$(pwd)/$1"
EXPORT_PATH_SORTED=$( echo "$EXPORT_PATH" | sed -E 's/\.csv/.sorted.csv/' )

#  init header row
echo "author, commit hash, author time, commit time, ref name, subject, files changed, insertions, deletions, repository" > $EXPORT_PATH

#  loop through all lines
echo "capturing commits:"
cat repoz.csv | while IFS=, read col1 col2
do
  echo "- $col2"
  ./get-commitz.sh "$col1" "$col2" >> $EXPORT_PATH
done
echo "Commits exported to csv file: $EXPORT_PATH"

#  sort file
sort -bn --field-separator=, --key=3 $EXPORT_PATH > $EXPORT_PATH_SORTED
echo "Commits sorted in file: $EXPORT_PATH"
