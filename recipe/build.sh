#!/bin/bash

# NO_INSTALL_HARDLINKS uses symlinks which makes the package 85MB slimmer (8MB instead of 93MB!)

# pcre-feedstock recipe does not include --enable-jit
export NO_LIBPCRE1_JIT=1

pushd code

# Add a place for git config files.
mkdir -p $PREFIX/etc
make configure
./configure \
    --prefix="${PREFIX}" \
    --with-gitattributes="${PREFIX}/etc/gitattributes" \
    --with-gitconfig="${PREFIX}/etc/gitconfig" \
    --with-libpcre1 \
    --with-iconv="${PREFIX}/lib" \
    --with-perl="${PREFIX}/bin/perl" \
    --with-tcltk="${PREFIX}/bin/tclsh"
make \
    --jobs="$CPU_COUNT" \
    NO_INSTALL_HARDLINKS=1 \
    all strip install

# build osxkeychain
if [[ $(uname) == "Darwin" ]]; then
  pushd contrib/credential/osxkeychain
  make -e
  cp -avf git-credential-osxkeychain $PREFIX/bin
  popd
fi


# Install completion files
mkdir -p $PREFIX/share/bash-completion/completions
cp contrib/completion/git-completion.bash $PREFIX/share/bash-completion/completions/git

popd # code

# Install manpages
mkdir -p $PREFIX/man
cp -r manpages/* $PREFIX/man
# Add symlinks in $PREFIX/share/man so that manpages work on macOS
if [[ $(uname) == "Darwin" ]]; then
  ln -s $PREFIX/man/man1/git* $PREFIX/share/man/man1/
  ln -s $PREFIX/man/man5/git* $PREFIX/share/man/man5/
  ln -s $PREFIX/man/man7/git* $PREFIX/share/man/man7/
fi

# Install htmldocs
mkdir -p $PREFIX/share/doc/git
cp -r htmldocs/* $PREFIX/share/doc/git
