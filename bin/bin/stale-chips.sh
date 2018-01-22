#!/usr/bin/env bash

# If git branch -d fails its due to the default branch being set to master
# instead of develop.
# To check:
#   git symbolic-ref HEAD
# To set to develop locally:
#   git symbolic-ref HEAD refs/heads/develop

#####
#
# Main
#
#####

MERGE_BRANCH='master'
GIT_REMOTE='upstream'
ME=$(git config user.email)

while getopts "b:r:m:" opt; do
    case $opt in
        b) MERGE_BRANCH="$OPTARG";;
        r) GIT_REMOTE="$OPTARG";;
        m) ME="$OPTARG";;
    esac
done
shift $((OPTIND -1))

for branch in $(git branch -r --merged ${MERGE_BRANCH} | grep -v HEAD); do
  if [[ $branch == *develop ]] || [[ $branch == master* ]]; then
    echo "skipping special branches: $branch"
    continue
  fi

  if [ ! $ME == $(git show --format="%ae" $branch | head -n 1) ]; then
    continue
  fi

  echo -e $(git show --format="%ci %cr %ae" $branch | head -n 1) \\t$branch
  echo
  short_branch=$(echo $branch | sed -e "s/${GIT_REMOTE}\/\(.*\)/\1/")
  read -p "Do you want to delete $short_branch? [y/n] " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "will delete $short_branch"
    git branch -d $short_branch
    git push ${GIT_REMOTE} :$short_branch
  fi
done

# Make sure we are in sync with the rest of the remote branches
git remote prune $GIT_REMOTE
