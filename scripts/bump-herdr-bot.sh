#!/bin/sh
# Points Casks/herdr-bot.rb at the latest herdr-bot release: its version and the two DMGs' SHA-256
# from the release's SHA256SUMS.txt. Prints the new version, or nothing when the cask is already current.
set -eu

repo="speardragon/herdr-bot"
cask="Casks/herdr-bot.rb"

tag="$(gh release view --repo "$repo" --json tagName --jq .tagName)"
version="${tag#v}"
current="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")"
[ "$version" = "$current" ] && exit 0

sums="$(gh release download "$tag" --repo "$repo" --pattern SHA256SUMS.txt --output -)"
arm="$(printf '%s\n' "$sums" | awk -v f="herdr-bot-$version-arm64.dmg" '$2 == f { print $1 }')"
intel="$(printf '%s\n' "$sums" | awk -v f="herdr-bot-$version-x64.dmg" '$2 == f { print $1 }')"
if [ -z "$arm" ] || [ -z "$intel" ]; then
  echo "SHA256SUMS.txt of $tag does not list both DMGs" >&2
  exit 1
fi

sed -i.bak \
  -e "s/^  version \".*\"$/  version \"$version\"/" \
  -e "s/^  sha256 arm:   \".*\",$/  sha256 arm:   \"$arm\",/" \
  -e "s/^         intel: \".*\"$/         intel: \"$intel\"/" \
  "$cask"
rm -f "$cask.bak"
echo "$version"
