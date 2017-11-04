#!/bin/sh

. `dirname $0`/common.sh

curl ${CURL_ARGS} --request DELETE \
     --header "${AUTH_HEADER}" \
     ${BASE_URL}/box/${CLOUD_USER}/${BOX_NAME} | checkerrors || exit 9

exit 0
