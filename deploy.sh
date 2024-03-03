#!/bin/bash

#https://blog.dockbit.com/templating-your-dockerfile-like-a-boss-2a84a67d28e9

deploy() {
	str="
  s!%%TAG%%!$TAG!g;
"

	sed -r "$str" "$1"
}

TAGS=(
	#  7.4
	8.0
	8.1
	8.2
	8.3
)

ENTRYPOINT=entrypoint-after.sh

IFS='
'
# shellcheck disable=SC2048
for TAG in ${TAGS[*]}; do

	if [ -d "$TAG" ]; then
		rm -Rf "$TAG"
	fi

	mkdir "$TAG"
	deploy Dockerfile.template >"$TAG"/Dockerfile

	if [ -f "$ENTRYPOINT" ]; then
		cp $ENTRYPOINT "$TAG"
	fi

done
