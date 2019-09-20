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

buildroot: build/buildroot/Config.in

build/buildroot/Config.in: archives/.buildroot
	$(MKDIR_P) $(dir $@)
	$(TAR) --directory=build/buildroot --strip-components=1 -xf $(Buildroot_Archive)
