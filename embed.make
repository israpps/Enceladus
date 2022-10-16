
#---- this file is purely to store recipes for embedded IRX drivers (or IOPRP Images) ----#
$(EE_ASM_DIR)usbd.s: $(PS2SDK)/iop/irx/usbd.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ usbd_irx

$(EE_ASM_DIR)audsrv.s: $(PS2SDK)/iop/irx/audsrv.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ audsrv_irx

$(EE_ASM_DIR)bdm.s: $(PS2SDK)/iop/irx/bdm.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ bdm_irx

$(EE_ASM_DIR)bdmfs_vfat.s: $(PS2SDK)/iop/irx/bdmfs_vfat.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ bdmfs_vfat_irx

$(EE_ASM_DIR)usbmass_bd.s: $(PS2SDK)/iop/irx/usbmass_bd.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ usbmass_bd_irx

$(EE_ASM_DIR)cdfs.s: $(PS2SDK)/iop/irx/cdfs.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ cdfs_irx

$(EE_ASM_DIR)libsd.s: $(PS2SDK)/iop/irx/libsd.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ libsd_irx

$(EE_ASM_DIR)padman.s: $(PS2SDK)/iop/irx/freepad.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ padman_irx

$(EE_ASM_DIR)mcman.s: $(PS2SDK)/iop/irx/mcman.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ mcman_irx

$(EE_ASM_DIR)mcserv.s: $(PS2SDK)/iop/irx/mcserv.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ mcserv_irx
	
$(EE_ASM_DIR)sio2man.s: $(PS2SDK)/iop/irx/sio2man.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ sio2man_irx

modules-iop/secrman/irx/secrman.irx:
	@echo "\033[1m-- SECRMAN\033[0m"
	make -C modules-iop/secrman
$(EE_ASM_DIR)secrman.s: modules-iop/secrman/irx/secrman.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ secrman_irx

modules-iop/secrsif/irx/secrsif.irx:
	@echo "\033[1m-- SECRSIF\033[0m"
	make -C modules-iop/secrsif
$(EE_ASM_DIR)secrsif.s: modules-iop/secrsif/irx/secrsif.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ secrsif_irx
#-----------------------------------------------------------------------------------------#