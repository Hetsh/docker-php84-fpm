#!/bin/bash
# shellcheck disable=SC2034

# This file will be sourced by scripts/update.sh to customize the update process


IMG_NAME="hetsh/php84-fpm"
GIT_VERSION="$(git describe --tags --first-parent --abbrev=0)"
BASE_IMAGE_VERSION_REGEX="\\d{8}"
MAIN_ITEM="php84-fpm"
