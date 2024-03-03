#!/bin/bash

set -e
#set -o errexit
#set -o nounset
#set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

GCLOUD_CMD=$(which gcloud)

if [ -n "${GCLOUD_EMAIL:-}" ] && [ -n "${GCLOUD_AUTH_FILE:-}" ]; then
	echo "running 'gcloud auth activate-service-account'..."
	runuser -l daemon -c "${GCLOUD_CMD} auth activate-service-account ${GCLOUD_EMAIL} --key-file=${GCLOUD_AUTH_FILE};"
	runuser -l daemon -c "${GCLOUD_CMD} config set project ${GCLOUD_PROJECT_ID};"
fi

if [ -n "${FATCONTROLLER_CONFIG:-}" ]; then
	echo "running 'fatcontrollerd start'..."
	/etc/init.d/fatcontrollerd start "${FATCONTROLLER_CONFIG}"
fi
