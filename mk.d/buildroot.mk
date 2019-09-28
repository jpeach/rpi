Buildroot_Version := 2019.08
Buildroot_Archive := archives/buildroot-$(Buildroot_Version).tar.bz2
Buildroot_SHA1 := ae463c4fd8b61119bdc0b548afc7a04690714da6

fetch:: archives/.buildroot

archives/.buildroot: $(Buildroot_Archive) $(Buildroot_Archive).sha1
	@sha1sum --check $(Buildroot_Archive).sha1
	@touch $@

$(Buildroot_Archive):
	@$(CURL) -o $@  https://buildroot.org/downloads/$(notdir $@)

$(Buildroot_Archive).sha1:
	@echo $(Buildroot_SHA1) $(Buildroot_Archive) > $@

buildroot: ## Fetch and prepare buildroot
buildroot: build/buildroot/Config.in

build/buildroot/Config.in: Systemd_Pkg := build/buildroot/package/systemd
build/buildroot/Config.in: archives/.buildroot
	$(MKDIR_P) $(dir $@)
	$(TAR) --directory=build/buildroot --strip-components=1 -xf $(Buildroot_Archive)
	$(SED) --in-place '-es/SYSTEMD_VERSION.*241/SYSTEMD_VERSION = 243/' $(Systemd_Pkg)/systemd.mk
	echo 'sha256  0611843c2407f8b125b1b7cb93533bdebd4ccf91c99dffa64ec61556a258c7d1  systemd-243.tar.gz' >> $(Systemd_Pkg)/systemd.hash
	# Drop the following patches for systems-243
	$(RM_F) $(Systemd_Pkg)/0001-install-don-t-use-ln-relative.patch
	$(RM_F) $(Systemd_Pkg)/0002-Refuse-dbus-message-paths-longer-than-BUS_PATH_SIZE_.patch
	$(RM_F) $(Systemd_Pkg)/0003-Allocate-temporary-strings-to-hold-dbus-paths-on-the.patch
	$(RM_F) $(Systemd_Pkg)/0004-meson-drop-misplaced-Wl-undefined-argument.patch
