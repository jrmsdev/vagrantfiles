#!/bin/sh

. `dirname $0`/common.sh

curl ${CURL_ARGS} --header "${JSON_HEADER}" \
     --header "${AUTH_HEADER}" ${BASE_URL}/boxes \
     --data "{ \"box\": { \"username\": \"${CLOUD_USER}\", \"name\": \"${BOX_NAME}\", \"is_private\": false } }" | \
     checkerrors || exit 9

exit 0
