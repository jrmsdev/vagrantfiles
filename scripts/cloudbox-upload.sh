#!/bin/sh

. `dirname $0`/common.sh

BOXPKG=base.box

test -s $BOXPKG || {
    echo "${BOXPKG}: file not found!" >&2
    exit 1
}

set -e

du -sh $BOXPKG

upurl=${BASE_URL}/box/${CLOUD_USER}/${BOX_NAME}/version/${BOX_VERSION}/provider/${BOX_PROVIDER}/upload

response=`curl ${CURL_ARGS} --header "${AUTH_HEADER}" ${upurl}`

upload_path=`echo $response | grep -F '"upload_path":' | cut -d ':' -f '2-' | sed 's/"//g' | sed 's/}//g'`

curl -v --request PUT --upload-file $BOXPKG $upload_path

exit 0
