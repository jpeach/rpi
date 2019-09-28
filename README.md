# rpi-config
Raspberry Pi PicoCluster config

## Quickstart
This repository contains some [Buildroot](https://www.buildroot.org)
wrappers to generate a Raspberry Pi 4 boot image. The image will have
DHCP enabled and will create an "admin" user with ssh and sudo access.

Building the image:
```
$ make buildroot sysimage
```

Once this completes, dd the `sdcard.img` file from `build/sysimage/images`
onto a SD card and stick it into the Taspberry Pi slot.

## Creating a Buildroot config

Start out with a new [Buildroot](https://www.buildroot.org) clone:
```
$ git clone git://git.buildroot.net/buildroot
```

Make sure that the Raspberry Pi 4 support is present:
```
$ make list-defconfigs | grep raspberrypi
  raspberrypi0_defconfig              - Build for raspberrypi0
  raspberrypi0w_defconfig             - Build for raspberrypi0w
  raspberrypi2_defconfig              - Build for raspberrypi2
  raspberrypi3_64_defconfig           - Build for raspberrypi3_64
  raspberrypi3_defconfig              - Build for raspberrypi3
  raspberrypi3_qt5we_defconfig        - Build for raspberrypi3_qt5we
  raspberrypi4_defconfig              - Build for raspberrypi4
  raspberrypi_defconfig               - Build for raspberrypi
```

Set the Rasberry Pi default config:
```
$ make defconfig raspberrypi4_defconfig
```

Now, use `make menuconfig` to customize the configuration. To export the
current config, use `savedefconfig`, like this:
```
$ make savedefconfig BR2_DEFCONFIG=/home/jpeach/src/rpi/board/rpi4/defconfig
```

Once this is done, and there is a local [defconfig](./board/rpi4/defconfig),
you can do `make sysimage-menuconfig` to update it using the Buildroot UI

The system image is saved to `build/sysimage/images`, and you can copy
it to a SD card with dd:
```
$ sudo dd if=build/sysimage/images/sdcard.img of=/dev/mmcblk0
```

## Issues and Workarounds

* [#12784](https://github.com/systemd/systemd/issues/12784)
  systemd fails to bring up network interfaces on kernel >= 5.2. Manual
  workaround is to bring up the interface on the console, i.e. `ip link
  set eth0 up`. Fixed in systemd 243.
* Some GNU packages (e.g. findutils) will fail to build without
  `makeinfo`. This can be fixed by installing the `textinfo` package on
  the host.
* systemd-hostnamed can set the hostname from the DHCP response, but this
  will only work if you build against
  [polkit](https://gitlab.freedesktop.org/polkit/polkit/). If you omit
  this, systemd-networkd will log a "Permission denied" error when it
  tries to set the hostname.
* Root filesystem size. Ideally we want the root filesystem to fill
  the SD card (32G in my case), however trying to generate a large image
  causes OOM errors and kernel oops on my dev host. Need to investigate
  how to repartition the device and resize the image after the fact.
