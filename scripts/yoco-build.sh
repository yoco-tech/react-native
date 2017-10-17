#! /bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;35m"
ENDCOLOR="\033[0m"

error() {
    echo $RED"$@"$ENDCOLOR
    exit 1
}

success() {
    echo $GREEN"$@"$ENDCOLOR
}

info() {
    echo $BLUE"$@"$ENDCOLOR
}

if [ ! -f package.json ]
then
  error There is no package.json in this directory $(cwd)
fi

PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

success "Preparing version $PACKAGE_VERSION"

info Starting build of react-native at `date`...
rm -rf android

./gradlew :ReactAndroid:installArchives || error "Couldn't generate artifacts"

npm pack

PACKAGE=$(pwd)/react-native-$PACKAGE_VERSION.tgz
success "Update your yoco-register package.json to use $PACKAGE"