#!/usr/bin/env sh

domainroot=".."
repodir="$domainroot/repo"
shareddir="$domainroot/shared"
php="php5.5"
shareds=( "wp-content/uploads" )

echo "Initiating post-receive hook"

while read oldrev newrev refname
do
  branch=$(git rev-parse --symbolic --abbrev-ref $refname) 
  echo "... Received $branch branch"

  releasedir="$domainroot/$branch" 

  ( mkdir -p "$releasedir" \
    && echo "... Releasing to $releasedir" \
  )

  unset GIT_DIR 
  cd "$releasedir"

  if find . -maxdepth 0 -empty | read; then
    
    echo "...... New: $PWD"
    ( git clone $repodir -b $branch . \
      && touch ./.created  \
      && echo "...... Cloned origin/$branch branch from $repodir"  \
    )

  else
    
    echo "...... Existing: $PWD"
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [ "$branch" == "$current_branch" ]; then
      
      ( git pull origin $branch \
        && echo "...... Pulled origin/$branch into $branch branch" \
      )

    else
      
      ( git fetch origin \
        && echo "...... Fetched changes from origin"  \
      )

      ( git checkout $branch  \
        && echo "...... Checked out origin/$branch into $branch branch" \
      )
    fi
  fi


  if [ -f ./composer.json ]; then

    if [ ! -f ./composer.phar ]; then
      echo "... Installing composer"
      curl -sS https://getcomposer.org/installer | $php 
    fi

    echo "... Installing wordpress and dependencies via composer"
    $php composer.phar install  

  fi


  for shared in "${shareds[@]}"
  do
    echo "... Checking $shared shared directory"

    if [ -f "public/$shared" ] && [ ! -L "public/$shared" ]; then
      
      ( mv "public/$shared" "public/$shared.saved" \
        && echo "...... Archived public/$shared --> public/$shared.saved" \
      )
    fi

    if [ ! -f "public/$shared" ] && [ ! -L "public/$shared" ]; then
      
      ( mkdir -p "$shareddir/$shared" \
        && ln -s "$shareddir/$shared" "public/$shared" \
        && echo "...... Created link public/$shared --> $shareddir/$shared" \
      )
    fi
  done

done

