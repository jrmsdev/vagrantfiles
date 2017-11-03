VERFILE=version.txt
test -s $VERFILE || {
    echo "${VERFILE}: file not found or empty!" >&2
    exit 1
}

CREDSFILE=~/.vagrant_cloud.credentials
test -s $CREDSFILE || {
    echo "${CREDSFILE}: file not found or empty!" >&2
    exit 2
}

BOX_NAME=`basename $PWD`
BOX_VERSION=`cat $VERFILE`
BOX_PROVIDER='virtualbox'

BASE_URL='https://app.vagrantup.com/api/v1'
CURL_ARGS='-s'

CLOUD_USER=`cat $CREDSFILE | cut -d ' ' -f 1`
CLOUD_TOKEN=`cat $CREDSFILE | cut -d ' ' -f 2`

AUTH_HEADER="Authorization: Bearer ${CLOUD_TOKEN}"
JSON_HEADER="Content-Type: application/json"

checkerrors() {
    read line
    if echo $line | grep -F 'error'; then
        return 1
    fi
    return 0
}
