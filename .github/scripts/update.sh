#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://raw.githubusercontent.com/monperrus/crawler-user-agents/master/crawler-user-agents.json \
  -o data/crawler-user-agents.json
git diff --quiet && exit 0

cargo set-version --bump minor
cargo test

version=$(cargo pkgid | sed 's/.*[#@]//')
git commit -am "chore: update crawler list"
git tag "v$version"
git push origin HEAD "v$version"
echo "tag=v$version" >>"$GITHUB_OUTPUT"
