#!/bin/bash
set -e

REMOTE_TOKEN_URL="https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
if ! git remote | grep "origin" > /dev/null 2>&1
then 
  echo "### Adding git remote..."
  git remote add origin $REMOTE_TOKEN_URL
  echo "### git fetch..."
  git fetch
fi

git remote set-url --push origin $REMOTE_TOKEN_URL

BRANCH="$GITHUB_REF"
echo "### Branch: $BRANCH"
git checkout $BRANCH

echo "## Login into git..."
git config --global user.name "Black Code Formatter"

echo "## Running Black Code Formatter"
black $BLACK_ARGS

echo "## Staging changes..."
git add .
echo "## Commiting files..."
git commit -m "Black Automatically Formatted Code" || true
echo "## Pushing to $BRANCH"
git push -u origin $BRANCH
