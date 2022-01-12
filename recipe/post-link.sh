#!/bin/bash

set -e

if [[ "$(uname)" == "Darwin" && "$(arch)" == "arm64" ]]; then
    # Binaries which access the keychain do not seem to work with the
    # cctools signing.  Because the git-credential-osxkeychain does not
    # need any path modifications, it is skipped by the conda system
    # signing during install.
    /usr/bin/codesign -s - -f ${PREFIX}/bin/git-credential-osxkeychain >& /dev/null
fi
