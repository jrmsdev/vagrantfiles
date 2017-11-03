#!/bin/sh

. `dirname $0`/common.sh

curl ${CURL_ARGS} --header "${JSON_HEADER}" --header "${AUTH_HEADER}" \
     ${BASE_URL}/box/${CLOUD_USER}/${BOX_NAME}/version/${BOX_VERSION}/providers \
     --data "{ \"provider\": { \"name\": \"${BOX_PROVIDER}\" } }" | \
     checkerrors || exit 9

exit 0
