Sysimage_Defconfig := board/rpi4/defconfig
Sysimage_Buildroot_Make = \
	$(MAKE) \
	BR2_DL_DIR=$$(pwd)/archives \
	BR2_DEFCONFIG=$$(pwd)/$(Sysimage_Defconfig) \
	O=$$(pwd)/build/sysimage \
	-C build/buildroot


sysimage: ## Build the system install image
sysimage: build/sysimage/.config
	$(Sysimage_Buildroot_Make)
	@echo Built image in build/sysimage/images

sysimage-menuconfig: ## Run buildroot menuconfig
sysimage-menuconfig: build/sysimage/.config
	@$(Sysimage_Buildroot_Make) menuconfig
	@$(Sysimage_Buildroot_Make) savedefconfig

# Set our pre-generated config as the default.
build/sysimage/.config: board/rpi4/defconfig
	$(Sysimage_Buildroot_Make) defconfig
