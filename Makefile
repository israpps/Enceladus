.SILENT:                                                                              

define HEADER
                                                                       
   @@@@@@@@*#                                                              
  @@@# @@@@@@@ @@@@%                                                    
   @@@.@@@@@@@@@@@@@@@@@@*       &&&&&&&.                                
     ,@@@@@@@@        @@@@@@&&&&&&&&&&&&&&&&                            
       *@@@@@@@          &&&&&&&&&@&&&&&&&&&&&&                         
          @@@@@@@      &&&&&&&&@@@@@@@@&&&&&&&&&&       @@@@@@       
             /@@@@@   &&&&&&@@@@@@@@@@@@@@&&&&  &&&   @@@@@@@@@@     
                 @@@@@@&&&&@@@@@@@@@@@@@@@@@@     &&  @@@@@@@@@@     
                    @@&@@@&&@@@@@@@@@@@@@@@@@      && @@@@@@@@@@     
                     &&&@@@@@@&@@@@@@@@@@@@@@@    &&&   @@@@@@.      
                      &&&&&@@@@@@&&@@@@@@@@@@@@@&&&&&               
                      &&&&&&&@@@@@@@@@@@@@@@@@@&&&&&&@@@                
                       (&&&&&&&@@@@&@@@@@@@@@@&&&&&& #@@@@@.            
                         &&&&&&&&&@@@@@&&@@@&&&&&&&     @@@@@@/         
                           &&&&&&&&@@@@@@@@@&&&&&         @@@@@@@       
                              &&&&&&&&&&&&@@@@@@@@@        @@@@@@@@,    
                                   &&&&&&&,     @@@@@@@@@@@@@@@@@@@@@@
                                                        &@@@@ @@@@@@@.

                                            
                            Enceladus project                                                               
                                                                                
endef
export HEADER

#------------------------------------------------------------------#
#----------------------- Configuration flags ----------------------#
#------------------------------------------------------------------#
#-------------------------- Reset the IOP -------------------------#
RESET_IOP ?= 1
#---------------------- enable DEBUGGING MODE ---------------------#
DEBUG ?= 1
#----------------------- Set IP for PS2Client ---------------------#
PS2LINK_IP ?= 192.168.1.10
#------------------------------------------------------------------#

EE_BIN = bin/enceladus.elf
EE_BIN_PKD = bin/enceladus_pkd.elf

EE_LIBS = -L$(PS2SDK)/ports/lib -L$(PS2DEV)/gsKit/lib/ -Lmodules/ds34bt/ee/ -Lmodules/ds34usb/ee/ -lpatches -lfileXio -lpad -ldebug -llua -lmath3d -ljpeg -lfreetype -lgskit_toolkit -lgskit -ldmakit -lpng -lz -lmc -laudsrv -lelf-loader -lds34bt -lds34usb

EE_INCS += -I$(PS2DEV)/gsKit/include -I$(PS2SDK)/ports/include -I$(PS2SDK)/ports/include/freetype2 -I$(PS2SDK)/ports/include/zlib

EE_INCS += -Imodules/ds34bt/ee -Imodules/ds34usb/ee

# stuff to send both to C and C++
GLOBAL_CFLAGS += -Wno-sign-compare -fno-strict-aliasing -fno-exceptions -DLUA_USE_PS2

FEATURES_CopyAsync ?= 0
FEATURES_Sound ?= 0
FEATURES_Render ?= 0
FEATURES_md5 ?= 0

ifeq ($(RESET_IOP),1)
GLOBAL_CFLAGS += -DRESET_IOP
endif

ifeq ($(DEBUG),1)
 $(info --- debugging enabled)
 GLOBAL_CFLAGS += -DDEBUG -O0 -g
else
  GLOBAL_CFLAGS += -Os
  EE_LDFLAGS += -s
endif

BIN2S = $(PS2SDK)/bin/bin2s

#-------------------------- Fixed source files ---------------------------#
EXT_LIBS = modules/ds34usb/ee/libds34usb.a modules/ds34bt/ee/libds34bt.a

APP_CORE = main.o system.o pad.o graphics.o \
		   atlas.o fntsys.o

LUA_LIBS =	luaplayer.o luasystem.o luacontrols.o \
			luatimer.o luaScreen.o luagraphics.o

IOP_MODULES = iomanx.o filexio.o \
			  sio2man.o mcman.o mcserv.o padman.o \
			  usbd.o bdm.o bdmfs_fatfs.o \
			  usbmass_bd.o cdfs.o ds34bt.o ds34usb.o

EMBEDDED_RSC = boot.o \
	BG.o circle.o cross.o down.o L1.o L2.o L3.o left.o R1.o R2.o R3.o right.o select.o square.o start.o triangle.o up.o \
	builtin_font.o

#------- Variable source files -------#
ifeq ($(FEATURES_CopyAsync), 1)
 GLOBAL_CFLAGS += -DF_CopyAsync
endif
ifeq ($(FEATURES_Sound), 1)
 GLOBAL_CFLAGS += -DF_Sound
 IOP_MODULES += libsd.o audsrv.o
 APP_CORE += sound.o
 LUA_LIBS += luasound.o
endif
ifeq ($(FEATURES_Render), 1)
 GLOBAL_CFLAGS += -DF_Render
 APP_CORE += render.o calc_3d.o gsKit3d_sup.o 
 LUA_LIBS += luarender.o
endif
ifeq ($(FEATURES_md5), 1)
 GLOBAL_CFLAGS += -DF_Md5
 APP_CORE += md5.o
endif

EE_OBJS = $(APP_CORE) $(LUA_LIBS) $(EMBEDDED_RSC) $(IOP_MODULES)

EE_OBJS_DIR = obj/
EE_SRC_DIR = src/
EE_ASM_DIR = asm/
EE_OBJS := $(EE_OBJS:%=$(EE_OBJS_DIR)%) # remap all EE_OBJ to obj subdir

EE_CFLAGS   += $(GLOBAL_CFLAGS)
EE_CXXFLAGS += $(GLOBAL_CFLAGS)

#------------------------------------------------------------------#
all: $(EXT_LIBS) $(EE_BIN)
	@echo "$$HEADER"

	echo "Building $(EE_BIN)..."

ifneq ($(DEBUG),1)
	$(EE_STRIP) $(EE_BIN)
endif

	echo "Compressing $(EE_BIN_PKD)...\n"
	ps2-packer $(EE_BIN) $(EE_BIN_PKD) > /dev/null

#--------------------- Embedded ressources ------------------------#

$(EE_ASM_DIR)boot.s: etc/boot.lua | $(EE_ASM_DIR)
	echo "Embedding boot script..."
	$(BIN2S) $< $@ bootString

# Images
$(EE_ASM_DIR)%.s: EMBED/%.png
	$(BIN2S) $< $@ $(shell basename $< .png)
	echo "Embedding $< Image..."

$(EE_ASM_DIR)%.s: EMBED/%.ttf
	$(BIN2S) $< $@ $(shell basename $< .ttf)
	echo "Embedding $< Font..."
#------------------------------------------------------------------#


#-------------------- Embedded IOP Modules ------------------------#
$(EE_ASM_DIR)iomanx.s: $(PS2SDK)/iop/irx/iomanX.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ iomanX_irx

$(EE_ASM_DIR)filexio.s: $(PS2SDK)/iop/irx/fileXio.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ fileXio_irx

$(EE_ASM_DIR)sio2man.s: $(PS2SDK)/iop/irx/sio2man.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ sio2man_irx
	
$(EE_ASM_DIR)mcman.s: $(PS2SDK)/iop/irx/mcman.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ mcman_irx

$(EE_ASM_DIR)mcserv.s: $(PS2SDK)/iop/irx/mcserv.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ mcserv_irx

$(EE_ASM_DIR)padman.s: $(PS2SDK)/iop/irx/padman.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ padman_irx
	
$(EE_ASM_DIR)libsd.s: $(PS2SDK)/iop/irx/libsd.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ libsd_irx

$(EE_ASM_DIR)usbd.s: $(PS2SDK)/iop/irx/usbd.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ usbd_irx

$(EE_ASM_DIR)audsrv.s: $(PS2SDK)/iop/irx/audsrv.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ audsrv_irx

$(EE_ASM_DIR)bdm.s: $(PS2SDK)/iop/irx/bdm.irx | $(EE_ASM_DIR)
	echo "Embedding Block Device Manager(BDM)..."
	$(BIN2S) $< $@ bdm_irx

$(EE_ASM_DIR)bdmfs_fatfs.s: $(PS2SDK)/iop/irx/bdmfs_fatfs.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ bdmfs_fatfs_irx

$(EE_ASM_DIR)usbmass_bd.s: $(PS2SDK)/iop/irx/usbmass_bd.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ usbmass_bd_irx

$(EE_ASM_DIR)cdfs.s: $(PS2SDK)/iop/irx/cdfs.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ cdfs_irx

modules/ds34bt/ee/libds34bt.a: modules/ds34bt/ee
	$(MAKE) -C $<

modules/ds34bt/iop/ds34bt.irx: modules/ds34bt/iop
	$(MAKE) -C $<

$(EE_ASM_DIR)ds34bt.s: modules/ds34bt/iop/ds34bt.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ ds34bt_irx

modules/ds34usb/ee/libds34usb.a: modules/ds34usb/ee
	$(MAKE) -C $<

modules/ds34usb/iop/ds34usb.irx: modules/ds34usb/iop
	$(MAKE) -C $<

$(EE_ASM_DIR)ds34usb.s: modules/ds34usb/iop/ds34usb.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ ds34usb_irx
	
#------------------------------------------------------------------#

$(EE_OBJS_DIR):
	@mkdir -p $@

$(EE_ASM_DIR):
	@mkdir -p $@

debug: $(EE_BIN)
	echo "Building $(EE_BIN) with debug symbols..."

clean:

	@echo "\nCleaning $(EE_BIN)..."
	rm -f $(EE_BIN)

	@echo "\nCleaning $(EE_BIN_PKD)..."
	rm -f $(EE_BIN_PKD)

	@echo "Cleaning obj dir"
	@rm -rf $(EE_OBJS_DIR)
	@echo "Cleaning asm dir"
	@rm -rf $(EE_ASM_DIR)
	
	$(MAKE) -C modules/ds34usb clean
	$(MAKE) -C modules/ds34bt clean
	
	
	echo "Cleaning embedded Resources..."
	rm -f $(EMBEDDED_RSC)

rebuild: clean all

pcsx2: all
	cmd.exe /c pcsx2.bat $(shell wslpath -m $(PWD)/$(EE_BIN))

run:
	ps2client -h $(PS2LINK_IP) execee host:$(EE_BIN)

intellisense:
	etc/update_lua_globals.sh

reset:
	ps2client -h $(PS2LINK_IP) reset   

analize: $(EE_BIN)
	python3 thirdparty/elf-size-analize.py $(EE_BIN) -R -t mips64r5900el-ps2-elf-

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.c | $(EE_OBJS_DIR)
	@echo "  - $@"
	@$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_ASM_DIR)%.s | $(EE_OBJS_DIR)
	@echo "  - $@"
	@$(EE_AS) $(EE_ASFLAGS) $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.cpp | $(EE_OBJS_DIR)
	@echo "  - $@"
	$(EE_CXX) $(EE_CXXFLAGS) $(EE_INCS) -c $< -o $@

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
