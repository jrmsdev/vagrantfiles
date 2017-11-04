#!/bin/sh

. `dirname $0`/common.sh

curl ${CURL_ARGS} --header "${JSON_HEADER}" \
     --header "${AUTH_HEADER}" ${BASE_URL}/boxes \
     --data "
     {
        \"box\": {
            \"username\": \"${CLOUD_USER}\",
            \"name\": \"${BOX_NAME}\",
            \"is_private\": false
        }
     }" | checkerrors || exit 9

curl ${CURL_ARGS} --request PUT --header "${JSON_HEADER}" \
     --header "${AUTH_HEADER}" ${BASE_URL}/box/${CLOUD_USER}/${BOX_NAME} \
     --data "
     {
        \"box\": {
            \"short_description\": \"jrmsdev ${BOX_NAME} - base box\",
            \"description\": \"jrmsdev ${BOX_NAME} - base box\",
            \"is_private\": false
        }
     }" | checkerrors || exit 9

exit 0
