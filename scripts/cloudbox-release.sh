#!/bin/sh

. `dirname $0`/common.sh

curl ${CURL_ARGS} --header "${AUTH_HEADER}" --request PUT \
     ${BASE_URL}/box/${CLOUD_USER}/${BOX_NAME}/version/${BOX_VERSION}/release | \
     checkerrors || exit 9

exit 0
