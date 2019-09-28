SSH_Root_Privkey := config/admin@rpi.key
SSH_Root_Pubkey := config/admin@rpi.pub

SSH_Keygen := ssh-keygen

keys: ## Generate root SSH keys
keys: skel $(SSH_Root_Privkey) $(SSH_Root_Pubkey)

$(SSH_Root_Privkey) $(SSH_Root_Pubkey):
	$(SSH_Keygen) \
		-N "" \
		-a 100 \
		-t ed25519 \
		-C $(basename $(notdir $(SSH_Root_Privkey))) \
		-f $(basename SSH_Root_Privkey)
	mv $(basename SSH_Root_Privkey) $(SSH_Root_Privkey)
	mv $(basename SSH_Root_Privkey).pub $(SSH_Root_Pubkey)
