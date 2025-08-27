#!/bin/bash

# Bash Strict Mode:
# -e  / -o errexit    :: Exit immediately if a command exits with a non-zero status.
# -E  / -o errtrace   :: Inherit ERR trap in functions, subshells, and substitutions (older shells may require -o errtrace instead of -E).
# -u  / -o nounset    :: Treat unset variables as an error and exit immediately.
# -o pipefail         :: Exit on error in pipeline.
# -x  / -o xtrace     :: Print each command and its arguments as they are executed (useful for debugging).
# -T  / -o functrace  :: Allow function tracing (used for DEBUG and RETURN traps within functions and sourced files).
#
# Optional:
# shopt -s inherit_errexit  :: Bash >= 4.4: ensures ERR trap inheritance in all cases
#
# Common practice:
# set -eEuo pipefail  # Strict mode (recommended)
set -eEuo pipefail

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
