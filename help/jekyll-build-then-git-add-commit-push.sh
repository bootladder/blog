#!/bin/bash
if [ -z "$1" ]
  then
    echo "Need a commit message"
    exit
fi

echo jekyll build
jekyll build;
echo git add 
git add .;
git commit -m "$1";
git push prod;

