# rpi-config
Raspberry Pi PicoCluster config

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
