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
MAJ = 0
MIN = 0
PATCH = 0
VER = v$(MAJ).$(MIN).$(PATCH)

#------------------------------------------------------------------#
#----------------------- Configuration flags ----------------------#
#------------------------------------------------------------------#
#-------------------------- Reset the IOP -------------------------#
RESET_IOP = 1
#---------------------- enable DEBUGGING MODE ---------------------#
DEBUG = 0
#----------------------- Set IP for PS2Client ---------------------#
PS2LINK_IP = 192.168.1.10
#------------------------------------------------------------------#
F_KEYBOARD ?= 0

BINDIR = bin/
EE_BIN = $(BINDIR)enceladus.elf
EE_BIN_PKD = $(BINDIR)neutrino_launcher.elf

EE_LIBS = -L$(PS2SDK)/ports/lib -L$(PS2DEV)/gsKit/lib/ -Lmodules/ds34bt/ee/ -Lmodules/ds34usb/ee/ \
	-lpatches -lfileXio -lpad -ldebug -llua -lmath3d -ljpeg -lfreetype -lgskit_toolkit -lgskit -ldmakit \
	-lpng -lz -lmc -laudsrv -lelf-loader -lds34bt -lds34usb

EE_INCS += -I$(PS2DEV)/gsKit/include -I$(PS2SDK)/ports/include -I$(PS2SDK)/ports/include/freetype2 -I$(PS2SDK)/ports/include/zlib

EE_INCS += -Imodules/ds34bt/ee -Imodules/ds34usb/ee

EE_GFLAGS += -Wno-sign-compare -fno-strict-aliasing -fno-exceptions -DLUA_USE_PS2 -D_MAJOR=$(MAJ) -D_MINOR=$(MIN) -D_PATCH=$(PATCH)

ifeq ($(RESET_IOP),1)
EE_GFLAGS += -DRESET_IOP
endif

ifeq ($(DEBUG),1)
EE_GFLAGS += -DDEBUG
endif


BIN2S = $(PS2SDK)/bin/bin2c
GITHASH =$(shell git rev-parse --short HEAD)
EE_GFLAGS += -D__GIT_HASH__=\"$(GITHASH)\"
#-------------------------- App Content ---------------------------#
EXT_LIBS = modules/ds34usb/ee/libds34usb.a modules/ds34bt/ee/libds34bt.a

APP_CORE = main.o system.o pad.o graphics.o render.o \
		   calc_3d.o gsKit3d_sup.o atlas.o fntsys.o md5.o \
		   sound.o

LUA_LIBS =	luaplayer.o luasound.o luacontrols.o \
			luatimer.o luaScreen.o luagraphics.o \
			luasystem.o luaRender.o

IOP_MODULES = iomanX.o fileXio_verbose.o \
			  sio2man.o mcman.o mcserv.o padman.o libsd.o \
			  usbd.o audsrv.o bdm.o bdmfs_fatfs.o \
			  usbmass_bd.o cdfs.o ds34bt.o ds34usb.o

EMBEDDED_RSC = boot.o

ifeq ($(F_KEYBOARD),1)
  EE_GFLAGS += -DPS2KBD
  EE_LIBS += -lkbd
  IOP_MODULES += ps2kbd.o
  LUA_LIBS +=  luaKeyboard.o
endif


EE_CXXFLAGS += $(EE_GFLAGS)
EE_CFLAGS += $(EE_GFLAGS)

EE_OBJS = $(APP_CORE) $(LUA_LIBS) $(IOP_MODULES) $(EMBEDDED_RSC)

EE_OBJS_DIR = obj/
EE_SRC_DIR = src/
EE_ASM_DIR = asm/
EE_OBJS := $(EE_OBJS:%=$(EE_OBJS_DIR)%) # remap all EE_OBJ to obj subdir

#------------------------------------------------------------------#
all: ds34 $(EE_BIN_PKD)
	@echo "$$HEADER"

$(EE_BIN_PKD): $(EE_BIN)
	$(EE_STRIP) $(EE_BIN)
	ps2-packer $(EE_BIN) $(EE_BIN_PKD)

RELDIR = releasepack/
REL_PKG = $(RELDIR)Neutrino-Launcher-$(VER)-$(GITHASH).7z
package: $(EE_BIN_PKD)
	mkdir -p $(RELDIR)
	rm -f $(REL_PKG)
	7z a $(REL_PKG) $(EE_BIN_PKD) bin/changelog bin/NEUTRINO/* LICENSE README.md
#--------------------- Embedded ressources ------------------------#

$(EE_ASM_DIR)boot.c: etc/boot.lua | $(EE_ASM_DIR)
	$(BIN2S) $< $@ bootString

# Images
EMBED/%.s: EMBED/%.png
	$(BIN2S) $< $@ $(shell basename $< .png)
#------------------------------------------------------------------#


#-------------------- Embedded IOP Modules ------------------------#
vpath %.irx embed/iop/
vpath %.irx modules/ds34bt/iop/
vpath %.irx modules/ds34usb/iop/
vpath %.irx $(PS2SDK)/iop/irx/
IRXTAG = $(notdir $(addsuffix _irx, $(basename $<)))
$(EE_ASM_DIR)%.c: %.irx
	$(DIR_GUARD)
	$(BIN2S) $< $@ $(IRXTAG)

$(EE_ASM_DIR)ps2kbd.c: $(PS2SDK)/iop/irx/ps2kbd.irx | $(EE_ASM_DIR)
	$(BIN2S) $< $@ ps2kbd_irx

ds34: modules/ds34bt/ee/libds34bt.a modules/ds34usb/ee/libds34usb.a modules/ds34bt/iop/ds34bt.irx modules/ds34usb/iop/ds34usb.irx

modules/ds34bt/ee/libds34bt.a: modules/ds34bt/ee
	$(MAKE) -C $<

modules/ds34bt/iop/ds34bt.irx: modules/ds34bt/iop
	$(MAKE) -C $<

modules/ds34usb/ee/libds34usb.a: modules/ds34usb/ee
	$(MAKE) -C $<

modules/ds34usb/iop/ds34usb.irx: modules/ds34usb/iop
	$(MAKE) -C $<
#------------------------------------------------------------------#

$(EE_OBJS_DIR):
	@mkdir -p $@

$(EE_ASM_DIR):
	@mkdir -p $@

debug: $(EE_BIN)
	echo "Building $(EE_BIN) with debug symbols..."

clean:
	@rm -rf $(EE_OBJS_DIR)
	@rm -rf $(EE_ASM_DIR)
	rm -f $(EE_BIN)
	rm -f $(EE_BIN_PKD)
	rm -f $(EMBEDDED_RSC)

rebuild: clean all

run:
	cd bin; ps2client -h $(PS2LINK_IP) execee host:$(EE_BIN)

intellisense:
	etc/update_lua_globals.sh

reset:
	ps2client -h $(PS2LINK_IP) reset   

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.c | $(EE_OBJS_DIR)
	@echo "  - $@"
	@$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_ASM_DIR)%.c | $(EE_OBJS_DIR)
	@echo "  - $@"
	@$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.cpp | $(EE_OBJS_DIR)
	@echo "  - $@"
	$(EE_CXX) $(EE_CXXFLAGS) $(EE_INCS) -c $< -o $@

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
