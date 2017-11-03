#!/bin/sh

. `dirname $0`/common.sh

curl ${CURL_ARGS} --header "${JSON_HEADER}" --header "${AUTH_HEADER}" \
     ${BASE_URL}/box/${CLOUD_USER}/${BOX_NAME}/versions \
     --data "{ \"version\": { \"version\": \"${BOX_VERSION}\", \"description\": \"v${BOX_VERSION}\" } }" | \
     checkerrors || exit 9

exit 0
