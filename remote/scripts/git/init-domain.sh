#!/usr/bin/env sh

hookdir="~/scripts/git/hooks"

if [[ (-n $1) ]]; then
  
  repodir="$1/repo"

  mkdir -p $repodir
  cd $repodir

  if [ ! -f hooks/post-receive ]; then
    git init --bare
    echo "source $hookdir/post-receive.sh $1" > hooks/post-receive
  fi
  chmod +x hooks/post-receive

else
  echo "You must pass the sub-domain name (top level dir)"
  exit 0
fi


