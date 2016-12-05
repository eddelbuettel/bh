#!/bin/bash
# Remove and purge old mistakes and/or unwanted big files from git history
# author: Iñaki Ucar <i.ucar86@gmail.com>
# based on: http://blog.ostermiller.org/git-remove-from-history

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <repo-URL> <pattern>"
  exit 1
fi

URL=$1
EXT=$2

confirm () {
  read -r -p "${1:-Are you sure? [y/N]} " response
  case $response in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

clean () { rm -rf /tmp/workingrepo; }

# Create a clone of the repository
cd /tmp
git clone $URL workingrepo
if [ "$?" -ne 0 ]; then
  echo ""
  echo "ooops! something went wrong cloning the repo!"
  clean
  exit 2
fi
cd workingrepo
for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master`; do
    git branch --track ${branch##*/} $branch
done

# Find the files you want to remove
FILE_LIST=$(git rev-list master | \
  while read rev; do
    git ls-tree -lr $rev | cut -c54- | sed -r 's/^ +//g;'
  done | sort -u | perl -e 'while (<>) {
    chomp; @stuff=split("\t");$sums{$stuff[1]} += $stuff[0];
  } print "$sums{$_} $_\n" for (keys %sums);' | \
  sort -rn | grep $EXT)
echo ""
echo "You're going to remove the following files:"
echo ""
echo "$FILE_LIST"
echo ""
! confirm && clean && exit 0
FILE_LIST=$(echo "$FILE_LIST" | cut -d" " -f2)
echo ""

# Rewrite history and remove the old files
git filter-branch --tag-name-filter cat --index-filter \
  "git rm -r --cached --ignore-unmatch ${FILE_LIST//$'\n'/ }" \
  --prune-empty -f -- --all

# Prune all references with garbage collection and reclaim space
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --aggressive --prune=now

# Verify they have been removed
FILE_N=$(git rev-list master | \
  while read rev; do
    git ls-tree -lr $rev | cut -c54- | sed -r 's/^ +//g;'
  done | sort -u | perl -e 'while (<>) {
    chomp; @stuff=split("\t");$sums{$stuff[1]} += $stuff[0];
  } print "$sums{$_} $_\n" for (keys %sums);' | \
  sort -rn | grep $EXT | wc -l)
if [ "$FILE_N" -ne 0 ]; then
  echo ""
  echo "ooops! something went wrong removing the files!"
  clean
  exit 3
fi

# Push the history changes
echo ""
echo "Files successfully removed! Let's push the changes..."
echo ""
! confirm && exit 0
echo ""
git push origin --force --all
git push origin --force --tags
clean

# Done
echo ""
echo "Done! Now, you should tell your collaborators to rebase and prune their local copies with"
echo ""
echo "  cd MY_LOCAL_GIT_REPO"
echo "  git fetch origin"
echo "  git rebase"
echo "  git reflog expire --expire=now --all"
echo "  git gc --aggressive --prune=now"
echo ""
echo "or to clone a fresh copy. And don't push that again! ;-)"
echo ""
