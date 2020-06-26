#!/usr/bin/env bash
# post-process a packer vagrant box to raw image for Digital Rebar

###
#  Requires:  bsdtar, qemu-img
###

set -e
xiterr() { [[ $1 =~ ^[0-9]+$ ]] && { XIT=$1; shift; } || XIT=1; printf "FATAL: $*\n"; exit $XIT; }

BASE="box.img"
BLD=${PACKER_BUILD_NAME:-1}
BOX=$BLD
QCW="$BOX.qcow2"
RAW=$BLD.img

[[ "$BOX" =~ .*\.box$ ]] || BOX="${BOX}.box"

which qemu-img > /dev/null 2>&1 || xiterr "no 'qemu-img' found, install and try again."
# thanks Mac OS .... yet again for sucking
which md5sum > /dev/null 2>&1 && MD5=$(which md5sum) || true
which md5 > /dev/null 2>&1 && MD5=$(which md5) || true
IDENT=$(uuidgen | $MD5 | awk ' { print $1 } ' | cut -c 1-10)
which tar > /dev/null 2>&1 && TAR=$(which tar) || true
which bsdtar > /dev/null 2>&1 && TAR=$(which bsdtar) || true
CH=$($TAR --version | awk ' { print $1 } ')
[[ "$CH" != "bsdtar" ]] && xiterr 1 "Require 'bsdtar', install it and try again."

$TAR -s "/box.img/$QCW/" -xzvf $BOX $BASE
qemu-img convert -f qcow2 -O raw $QCW $RAW
