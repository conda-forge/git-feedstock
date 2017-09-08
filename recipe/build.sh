#!/bin/bash

export C_INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"

if [ "$(uname)" == "Darwin" ]
then
    export LDFLAGS="-Wl,-rpath,$PREFIX/lib"
elif [ "$(uname)" == "Linux" ]
then
    export LDFLAGS="-Wl,-rpath=$PREFIX/lib"
fi

# NO_TCLTK disables git-gui
# NO_PERL disables all perl-based utils:
#   git-instaweb, gitweb, git-cvsserver, git-svn
#   /ref http://www.spinics.net/lists/git/msg99803.html
# NO_GETTEXT disables internationalization (localized message translations)
# NO_INSTALL_HARDLINKS uses symlinks which makes the package 85MB slimmer (8MB instead of 93MB!)

# Add a place for git config files.
mkdir -p $PREFIX/etc
make configure
./configure \
    --prefix="${PREFIX}" \
    --with-gitattributes="${PREFIX}/etc/gitattributes" \
    --with-gitconfig="${PREFIX}/etc/gitconfig" \
    --with-iconv="${PREFIX}/lib"
make \
    --jobs="$CPU_COUNT" \
    NO_TCLTK=1 \
    NO_PERL=1 \
    NO_GETTEXT=1 \
    NO_INSTALL_HARDLINKS=1 \
    all strip install

git config --system http.sslVerify true
git config --system http.sslCAPath "${PREFIX}/ssl/cacert.pem"
git config --system http.sslCAInfo "${PREFIX}/ssl/cacert.pem"

# Install completion files
mkdir -p $PREFIX/share/bash-completion/completions
cp contrib/completion/git-completion.bash $PREFIX/share/bash-completion/completions/git
