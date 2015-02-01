#!/usr/bin/env sh

hookdir="~/scripts/git/hooks"

if [[ (-n $1) ]]; then
  
  repodir="$1/repo"

  mkdir -p $repodir
  cd $repodir
  git init --bare
  echo "source $hookdir/post-receive.sh $1" > hooks/post-receive
  chmod +x hooks/post-receive

else
  echo "You must pass the domain name"
  exit 0
fi


