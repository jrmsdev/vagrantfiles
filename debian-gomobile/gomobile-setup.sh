#!/bin/sh
# ref: https://github.com/mpl/go4droid/blob/master/Dockerfile

set -e

SDK_FILE=sdk-tools-linux-3859397.zip
SDK_FILE_HASH=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0
SDK_URL=https://dl.google.com/android/repository/$SDK_FILE

setupSDK() {
    mkdir -vp $ANDROID_HOME
    cd $ANDROID_HOME
    if ! test -s ./tools/bin/sdkmanager; then
        echo "download: $SDK_URL"
        wget -cq $SDK_URL
        sha256sum -c $SDK_FILE_HASH $SDK_FILE
        unzip $SDK_FILE
    fi
    echo y | ./tools/bin/sdkmanager --update
    echo y | ./tools/bin/sdkmanager 'platforms;android-23'
    echo y | ./tools/bin/sdkmanager 'build-tools;23.0.3'
    echo y | ./tools/bin/sdkmanager 'extras;android;m2repository'
    echo y | ./tools/bin/sdkmanager 'ndk-bundle'
    cd - >/dev/null
}

export GOPATH=$HOME
export ANDROID_HOME=$HOME/android-sdk

setupSDK
if ! grep -F "${ANDROID_HOME}/platform-tools" $HOME/.bashrc; then
    echo "export PATH=${ANDROID_HOME}/platform-tools:$PATH" >>$HOME/.bashrc
fi

go get -u golang.org/x/mobile/cmd/gomobile
gomobile init -ndk $ANDROID_HOME/ndk-bundle

exit 0
