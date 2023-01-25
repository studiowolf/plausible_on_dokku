# Pull upstream changes
echo -e "\033[0;32m====>\033[0m Pull origin..."
git pull

# Get current release name
CURRENT_RELEASE=$(git tag | tail -1)

# Get lastest release name
RELEASE=$(curl -s https://api.github.com/repos/plausible/analytics/tags | jq | grep -o '"v[0-9]*\.[0-9]*\.[0-9]*"'| head -1 | sed 's/v//g; s/\"//g')

# Exit script if already up to date
if [ "v${RELEASE}" = $CURRENT_RELEASE ]; then
  echo -e "\033[0;32m=>\033[0m Already up to date..."
  exit 0
fi

# Replace "from" line in dockerfile with the new release
sed -i "s#ARG PLAUSIBLE_VERSION.*#ARG PLAUSIBLE_VERSION=\"v${RELEASE}\"#" Dockerfile

# Replace README link to plausible release
PLAUSIBLE_BADGE="[![Plausible](https://img.shields.io/badge/Plausible-${RELEASE}-blue.svg)](https://github.com/plausible/analytics/releases/tag/v${RELEASE})"
sed -i "s#\[\!\[Plausible\].*#${PLAUSIBLE_BADGE}#" README.md

# Push changes
git add Dockerfile README.md
git commit -m "Update to plausible version v${RELEASE}"
git push origin master

# Create tag
git tag "v${RELEASE}"
git push --tags