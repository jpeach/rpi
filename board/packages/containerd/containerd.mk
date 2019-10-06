################################################################################
#
# containerd
#
################################################################################
CONTAINERD_VERSION = 1.3.0
CONTAINERD_COMMIT = 36cf5b690dcc00ff0f34ff7799209050c3d0c59a
CONTAINERD_SITE = $(call github,containerd,containerd,v$(CONTAINERD_VERSION))
CONTAINERD_LICENSE = Apache-2.0
CONTAINERD_LICENSE_FILES = LICENSE

# There's no BTRFS support in the RPI build.
CONTAINERD_TAGS += no_btrfs

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
CONTAINERD_DEPENDENCIES += libseccomp host-pkgconf
CONTAINERD_TAGS += seccomp
endif

define CONTAINERD_USERS
	- -1 containerd-admin -1 - - - - -
	- -1 containerd       -1 - - - - -
endef

define CONTAINERD_BUILD_CMDS
	 cd $(CONTAINERD_SRC_PATH); \
	 $(GO_TARGET_ENV) \
		 GOPATH="$(@D)/$(CONTAINERD_WORKSPACE)" \
		 $(CONTAINERD_GO_ENV) \
		 $(MAKE) -C $(@D) BUILDTAGS="$(CONTAINERD_TAGS)" \
		    VERSION=$(CONTAINERD_VERSION) REVISION=$(CONTAINERD_COMMIT)
endef

define CONTAINERD_INSTALL_TARGET_CMDS
	$(INSTALL) -Dm755 \
		$(@D)/bin/containerd \
		$(TARGET_DIR)/usr/bin
	$(INSTALL) -Dm755 \
		$(@D)/bin/containerd-shim \
		$(TARGET_DIR)/usr/bin
	$(INSTALL) -Dm755 \
		$(@D)/bin/ctr \
		$(TARGET_DIR)/usr/bin
	$(INSTALL) -Dm644 \
		$(CONTAINERD_PKGDIR)/config.toml \
		$(TARGET_DIR)/etc/containerd/config.toml
endef

define CONTAINERD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -Dm644 \
		$(CONTAINERD_PKGDIR)/containerd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/containerd.service
	$(call link-service,containerd.service)
	$(call link-service,containerd-shutdown.service)
endef

$(eval $(golang-package))
