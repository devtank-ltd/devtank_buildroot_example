#! /bin/bash

ln -s ../../hiltop_board  buildroot/board/hiltop
ln -s ../../hiltop_defconfig buildroot/configs/hiltop_defconfig
ln -s ../../python-tz buildroot/package/python-tz
ln -s ../../devtank_prod_tester buildroot/package/devtank_prod_tester
cd buildroot
git apply ../gtk3.patch
git apply ../devtank.patch
git apply ../mako_br_fix.patch
