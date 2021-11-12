Devtank HILTOP Production Tester Buildroot Example
==================================================

Introduction
------------
This is a basic example production tester.

It of course has nothing to actually test, so it's just the example mock up hardware tested. Each production tester uses the same framework, but has it's own "binding" required to test what ever it is that is being production tested. More can be found out in the "docs" folder of "devtank-dtlib".


Setup
-----
Buildroot is a very big project and so we just submodule it. Though we still have patches for buildroot itself.

Once cloned and the submodule are setup, call "./init.sh" before trying to build as this will apply our patches to buildroot.
After that, you should be able to go into the buildroot folder and do "make hiltop_defconfig" followed by "make" to build the image.
More can be found out about buildroot at : https://buildroot.org
