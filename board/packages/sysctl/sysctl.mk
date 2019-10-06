define SYSCTL_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/sysctl.d
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/modules-load.d

	$(INSTALL) -m 0755 $(SYSCTL_PKGDIR)/sysctl.conf $(TARGET_DIR)/etc/sysctl.d/70-kubernetes.conf
	$(INSTALL) -m 0755 $(SYSCTL_PKGDIR)/module.conf $(TARGET_DIR)/etc/modules-load.d/70-kubernetes.conf
endef

$(eval $(generic-package))
