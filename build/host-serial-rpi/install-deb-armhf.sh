#!/bin/sh

# set -x

LEN=`getconf LONG_BIT`

if [ $LEN -ne 32 ]; then
    echo "Attempting to build on wrong platform."
    exit 1
fi

ARCH=$(dpkg --print-architecture)
echo "Build debian package for $ARCH"
echo "First make everything."

# ./build.sh
make

HERE=`pwd`

DEST="./debian-${ARCH}/usr/local/bin"
LIBS="./debian-${ARCH}/usr/local/etc"
DEBS="./debian-${ARCH}/DEBIAN"

if [ ! -d ${DEBS} ];then
    mkdir -p ${DEBS}
fi

if [ ! -f ${DEBS}/control ]; then
    echo "Fatal Error: No package control file"
    exit 1
fi

if [ ! -d ${DEST} ]; then
    mkdir -p ${DEST}
fi

if [ ! -d ${LIBS} ]; then
    mkdir -p ${LIBS}
fi

if [ ! -f app.dic ]; then
    echo "No dictionary."
    exit 1 
else
    cp app.dic $LIBS
    cd $LIBS
fi

cd $HERE
if [ -x forth.sh ]; then
    cp forth.sh ${DEST}/forth
fi


cp ./forth ${DEST}/cforth
strip ${DEST}/cforth

dpkg -b ./debian-${ARCH} .