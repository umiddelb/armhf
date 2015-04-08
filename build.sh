#!/bin/bash

set -e

ARM=5
VERSION=$1
OUTPUT_DIR=${2:-$PWD}

if [ "$VERSION" == "--arm" ]; then
	ARM=$2
	VERSION=$3
	OUTPUT_DIR=${4:-$PWD}
fi

if [ -z "$VERSION" ]; then
	echo "$0 [--arm <arm version>] <version> [<output directory>]"
	exit -1
fi

CURRENT_DIR=$PWD
BUILD_DIR="$CURRENT_DIR/docker-$VERSION-arm$ARM-build"
OUTPUT_DIR=`/usr/bin/realpath $OUTPUT_DIR`

# Get Docker code
git clone --branch "v$VERSION" --single-branch https://github.com/docker/docker.git $BUILD_DIR

# Use ARM Ubuntu base
sed --in-place --regexp-extended "s/FROM[[:space:]]+ubuntu:14.04/FROM armv7\/armhf-ubuntu:14.04/" $BUILD_DIR/Dockerfile

# Don't cross-compile
sed --in-place --regexp-extended "/ENV[[:space:]]+DOCKER_CROSSPLATFORMS/s/^.*$/ENV DOCKER_CROSSPLATFORMS/" $BUILD_DIR/Dockerfile

for ARCH in "linux\/386" "linux\/arm" "darwin\/amd64" "darwin\/386" "freebsd\/amd64" "freebsd\/386" "freebsd\/arm" "WINDOWS\/AMD64"; do
    sed --in-place "/$ARCH/d" $BUILD_DIR/Dockerfile
done

sed --in-place "/ENV DOCKER_CROSSPLATFORMS/s/^.*$/ENV DOCKER_CROSSPLATFORMS linux\/arm/" $BUILD_DIR/Dockerfile

# ARM version to compile for
sed --in-place --regexp-extended "s/ENV[[:space:]]+GOARM[[:space:]]+5/ENV GOARM $ARM/" $BUILD_DIR/Dockerfile

# Comment out GOFMT lines
sed --in-place "/GOFMT_VERSION/s/^/# /" $BUILD_DIR/Dockerfile

# Set image name
sed --in-place --regexp-extended "/GIT_BRANCH[[:space:]]+:=/s/^.*$/GIT_BRANCH := $VERSION-arm$ARM/" $BUILD_DIR/Makefile

# Build docker
cd $BUILD_DIR
make build
make binary

# Copy binary to current directory
cp $BUILD_DIR/bundles/$VERSION/binary/docker-$VERSION $OUTPUT_DIR

# Tidy up
cd $CURRENT_DIR
rm --force --recursive $BUILD_DIR
docker rmi docker:$VERSION-arm$ARM
