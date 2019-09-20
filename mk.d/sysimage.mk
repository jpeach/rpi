Sysimage_Defconfig := board/rpi4/defconfig

# Build an install image.
sysimage: build/sysimage/.config
	$(MAKE) \
		BR2_DL_DIR=$$(pwd)/archives \
		O=$$(pwd)/build/sysimage \
		-C build/buildroot

# Set our pre-generated config as the default.
build/sysimage/.config: board/rpi4/defconfig
	$(MAKE) \
		BR2_DL_DIR=$$(pwd)/archives \
		BR2_DEFCONFIG=$$(pwd)/$(Sysimage_Defconfig) \
		O=$$(pwd)/build/sysimage \
		-C build/buildroot \
		defconfig
