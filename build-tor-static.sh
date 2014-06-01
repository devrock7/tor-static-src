#!/bin/bash

echo "setting up environment variables"
VERSION=0.2.4.22-static
TORSDIR=$HOME/torsource
TORDIR=$HOME/tor-$VERSION
TMPDIR=$TORSDIR/tmp

echo "creating environment folders"
mkdir -p $TORSDIR
cd $TORSDIR

echo "downloading source tarball"
wget --no-check-certificate https://github.com/devrock7/tor-static/raw/master/tor-$VERSION-src.tar.gz  > /dev/null 2>&1

echo "extracting source tarball"
tar zfpx tor-$VERSION-src.tar.gz

echo "building libevent"
cd $TORSDIR/libevent-2.0.21-stable
./configure --disable-shared --enable-static --with-pic --prefix=$TMPDIR/libevent > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1

echo "building zlib"
cd $TORSDIR/zlib-1.2.8
./configure --prefix=$TMPDIR/zlib > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1

echo "building openssl"
cd $TORSDIR/openssl-1.0.1g
./config no-shared no-dso --prefix=$TMPDIR/openssl > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1

echo "building tor-$VERSION"
cd $TORSDIR/tor-0.2.4.22
./configure --enable-static-tor --with-libevent-dir=$TMPDIR/libevent --with-openssl-dir=$TMPDIR/openssl --with-zlib-dir=$TMPDIR/zlib --prefix=$TORDIR --bindir=$TORDIR --sysconfdir=$TORDIR --datarootdir=$TORDIR --docdir=$TORDIR > /dev/null 2>&1
make > /dev/null 2>&1
echo "installing tor-$VERSION ($TORDIR)"
make install > /dev/null 2>&1

echo "DONE!"
