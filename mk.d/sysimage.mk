Sysimage_Defconfig := board/rpi4/defconfig

sysimage: build/sysimage/.config

build/sysimage/.config: board/rpi4/defconfig
	$(MAKE) \
		BR2_DL_DIR=archives \
		BR2_DEFCONFIG=$$(pwd)/$(Sysimage_Defconfig) \
		O=$$(pwd)/build/sysimage \
		-C build/buildroot \
		defconfig
