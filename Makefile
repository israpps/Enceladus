.SILENT:                                                                              

define HEADER
    \033[1m                                                                   
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
    \033[0m                                                                            
endef
export HEADER

#------------------------------------------------------------------#
#----------------------- Configuration flags ----------------------#
#------------------------------------------------------------------#
#-------------------------- Reset the IOP -------------------------#
RESET_IOP ?= 1
#---------------------- enable DEBUGGING MODE ---------------------#
DEBUG ?= 0
#----------------------- Set IP for PS2Client ---------------------#
PS2LINK_IP ?= 192.168.1.10
#--------------------- Use Console ROM drivers --------------------#
USE_ROM_DRIVERS ?= 0
#------------------------------------------------------------------#

EE_BIN = enceladus.elf
EE_BIN_PKD = enceladus_pkd.elf

EE_LIBS = -L$(PS2SDK)/ports/lib -L$(PS2DEV)/gsKit/lib/ -lpatches -lfileXio -ldebug -llua -ljpeg -lfreetype -lgskit_toolkit -lgskit -ldmakit -lpng -lz -lmc -laudsrv -lelf-loader

EE_INCS += -I$(PS2DEV)/gsKit/include -I$(PS2SDK)/ports/include -I$(PS2SDK)/ports/include/freetype2 -I$(PS2SDK)/ports/include/zlib

EE_CFLAGS   += -Wno-sign-compare -fno-strict-aliasing -fno-exceptions -DLUA_USE_PS2
EE_CXXFLAGS += -Wno-sign-compare -fno-strict-aliasing -fno-exceptions -DLUA_USE_PS2

ifeq ($(RESET_IOP),1)
EE_CXXFLAGS += -DRESET_IOP
endif

ifeq ($(DEBUG),1)
EE_CXXFLAGS += -DDEBUG
endif

BIN2S = $(PS2SDK)/bin/bin2s

EE_SRC_DIR = src/
EE_OBJS_DIR = obj/
EE_ASM_DIR = asm/
#-------------------------- App Content ---------------------------#
APP_CORE = main.o graphics.o atlas.o \
		   fntsys.o md5.o secrman_rpc.o

LUA_LIBS =	luaplayer.o luasound.o luacontrols.o \
			luatimer.o luaScreen.o luagraphics.o \
			luasystem.o luasecrman.o

IOP_MODULES = usbd.o audsrv.o bdm.o bdmfs_vfat.o \
			  usbmass_bd.o cdfs.o secrman.o secrsif.o

ifeq ($(USE_ROM_DRIVERS),0)
	IOP_MODULES += sio2man.o mcserv.o mcman.o padman.o libsd.o
	EE_LIBS += -lpadx
else
	EE_LIBS += -lpad
	EE_CXXFLAGS += -DUSE_ROM_DRIVERS
endif

EMBEDDED_RSC = boot.o

EE_OBJS = $(IOP_MODULES) $(EMBEDDED_RSC) $(APP_CORE) $(LUA_LIBS)

EE_OBJS := $(EE_OBJS:%=$(EE_OBJS_DIR)%)

#------------------------------------------------------------------#

all: $(EE_BIN) $(EE_OBJS_DIR) $(EE_ASM_DIR)
	@echo "$$HEADER"

	echo "Stripping $(EE_BIN)..."
	$(EE_STRIP) $(EE_BIN)

	echo "Compressing $(EE_BIN_PKD)...\n"
	ps2-packer $(EE_BIN) $(EE_BIN_PKD) > /dev/null
	
	mv $(EE_BIN) bin/
	mv $(EE_BIN_PKD) bin/


#--------------------- Embedded ressources ------------------------#

$(EE_ASM_DIR)boot.s: etc/boot.lua
	echo "Embedding boot script..."
	$(BIN2S) $< $@ bootString

#------------------------------------------------------------------#


debug: $(EE_BIN)
	echo "Building $(EE_BIN) with debug symbols..."

clean:

	echo "Cleaning $(EE_BIN)..."
	rm -f bin/$(EE_BIN)

	echo "Cleaning $(EE_BIN_PKD)..."
	rm -f bin/$(EE_BIN_PKD)

	echo "Cleaning objects folder..."
	rm -rf $(EE_OBJS_DIR)

	echo "Cleaning embedded objects folder..."
	rm -rf $(EE_ASM_DIR)

	echo "Cleaning SECRMAN..."
	make -C modules-iop/secrman clean 

	echo "Cleaning SECRSIF..."
	make -C modules-iop/secrsif clean 

rebuild: clean all

run:
	cd bin; ps2client -h $(PS2LINK_IP) execee host:$(EE_BIN)
       
reset:
	ps2client -h $(PS2LINK_IP) reset   

#-------------- Recipes related to object subfolders ---------------#
$(EE_ASM_DIR):
	@mkdir -p $@

$(EE_OBJS_DIR):
	@mkdir -p $@

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.c | $(EE_OBJS_DIR)
	@echo "- $@"
	$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.cpp | $(EE_OBJS_DIR)
	@echo "- $@"
	$(EE_CXX) $(EE_CXXFLAGS) $(EE_INCS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_ASM_DIR)%.s | $(EE_OBJS_DIR)
	@echo "- $@"
	$(EE_AS) $(EE_ASFLAGS) $< -o $@
#------------------------------------------------------------------#

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
include embed.make