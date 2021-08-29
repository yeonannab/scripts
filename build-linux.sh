#!/usr/bin/env bash
# Copyright 2021 Dokyung Song. All rights reserved.
# Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
	echo "Usage: $0 <KERNEL_SRC_DIR>" >&2
	exit 1
fi

KERNEL_SRC_DIR=$1
config=csi2115_f21

if [ ! -d $KERNEL_SRC_DIR ]; then
	echo $KERNEL_SRC_DIR does not exist.
	exit 1
fi

if [ $# -eq 2 ]; then
	IMAGE_OUT_DIR=$2
else
	BUILD_DIR=$(dirname $0)/build
	mkdir -p $BUILD_DIR

	IMAGE_OUT_DIR=$BUILD_DIR/linux

	IMAGE_OUT_DIR=$PWD/$IMAGE_OUT_DIR

	if [ ! -d $IMAGE_OUT_DIR ]; then
		echo Creating $IMAGE_OUT_DIR
		mkdir -p $IMAGE_OUT_DIR
	fi
fi

INSTALL_MOD_PATH=$IMAGE_OUT_DIR/modules

cp configs/v5.12.0-rc1-dontuse.config $IMAGE_OUT_DIR/$config/.config

pushd $KERNEL_SRC_DIR

set -eux

make csi2115_f21_defconfig O=$IMAGE_OUT_DIR/$config
make -j4 O=$IMAGE_OUT_DIR/$config bzImage

if [ $INSTALL_MOD_PATH != "" ]; then
	pushd $IMAGE_OUT_DIR/$config
	make modules_install INSTALL_MOD_PATH=$INSTALL_MOD_PATH
	popd
fi

popd
