#!/bin/bash
# shellcheck disable=SC2034

# This file will be sourced by scripts/build.sh to customize the build process


IMG_NAME="hetsh/php84-fpm"
function test_image {
	docker run \
		--rm \
		--tty \
		--publish 9000:9000/tcp \
		--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
		"$IMG_ID"
}
