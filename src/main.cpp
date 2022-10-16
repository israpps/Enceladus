
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sifrpc.h>
#include <loadfile.h>
#include <libmc.h>
#include <libcdvd.h>
#include <iopheap.h>
#include <iopcontrol.h>
#include <smod.h>
#include <audsrv.h>

#include <sbv_patches.h>
#include <smem.h>

#include "include/graphics.h"
#include "include/sound.h"
#include "include/luaplayer.h"

#define IMPORT_BIN2C(_n) \
    extern unsigned char _n; \
    extern unsigned int size_##_n
extern char bootString[];
extern unsigned int size_bootString;

IMPORT_BIN2C(cdfs_irx);
IMPORT_BIN2C(usbd_irx);
IMPORT_BIN2C(bdm_irx);
IMPORT_BIN2C(bdmfs_vfat_irx);
IMPORT_BIN2C(usbmass_bd_irx);
IMPORT_BIN2C(audsrv_irx);
IMPORT_BIN2C(secrman_irx);
IMPORT_BIN2C(secrsif_irx);
#ifndef USE_ROM_DRIVERS
IMPORT_BIN2C(sio2man_irx);
IMPORT_BIN2C(mcserv_irx);
IMPORT_BIN2C(mcman_irx);
IMPORT_BIN2C(padman_irx);
IMPORT_BIN2C(libsd_irx);
#endif

char boot_path[255];

void initMC(void)
{
   int ret;
   // mc variables
   int mc_Type, mc_Free, mc_Format;

   
   printf("Initializing Memory Card\n");

#ifndef USE_ROM_DRIVERS
    ret = mcInit(MC_TYPE_XMC);
#else
    ret = mcInit(MC_TYPE_MC);
#endif
   if( ret < 0 ) {
	printf("MC_Init : failed to initialize memcard server.\n");
   }
   
   // Since this is the first call, -1 should be returned.
   // makes me sure that next ones will work !
   mcGetInfo(0, 0, &mc_Type, &mc_Free, &mc_Format); 
   mcSync(MC_WAIT, NULL, &ret);
}

void setLuaBootPath(int argc, char ** argv, int idx)
{
    if (argc>=(idx+1))
    {

	char *p;
	if ((p = strrchr(argv[idx], '/'))!=NULL) {
	    snprintf(boot_path, sizeof(boot_path), "%s", argv[idx]);
	    p = strrchr(boot_path, '/');
	if (p!=NULL)
	    p[1]='\0';
	} else if ((p = strrchr(argv[idx], '\\'))!=NULL) {
	   snprintf(boot_path, sizeof(boot_path), "%s", argv[idx]);
	   p = strrchr(boot_path, '\\');
	   if (p!=NULL)
	     p[1]='\0';
	} else if ((p = strchr(argv[idx], ':'))!=NULL) {
	   snprintf(boot_path, sizeof(boot_path), "%s", argv[idx]);
	   p = strchr(boot_path, ':');
	   if (p!=NULL)
	   p[1]='\0';
	}

    }
    
    // check if path needs patching
    if( !strncmp( boot_path, "mass:/", 6) && (strlen (boot_path)>6))
    {
        strcpy((char *)&boot_path[5],(const char *)&boot_path[6]);
    }
      
    
}


int main(int argc, char * argv[])
{
    const char * errMsg;

    #ifdef RESET_IOP  
    SifInitRpc(0);
    while (!SifIopReset("", 0)){};
    while (!SifIopSync()){};
    SifInitRpc(0);
    #endif
    
    // install sbv patch fix
    printf("Installing SBV Patch...\n");
    sbv_patch_enable_lmb();
    sbv_patch_disable_prefix_check(); 
    sbv_patch_fileio(); 
int temp = -10;
#ifndef USE_ROM_DRIVERS
    temp = SifExecModuleBuffer(&sio2man_irx, size_sio2man_irx, 0, NULL, NULL);
    printf("SIO2MAN: %d\n", temp);
    temp = SifExecModuleBuffer(&mcman_irx, size_mcman_irx, 0, NULL, NULL);
    printf("MCMAN: %d\n", temp);
    temp = SifExecModuleBuffer(&mcserv_irx, size_mcserv_irx, 0, NULL, NULL);
    printf("MCSERV: %d\n", temp);
    temp = SifExecModuleBuffer(&padman_irx, size_padman_irx, 0, NULL, NULL);
    printf("PADMAN: %d\n", temp);
    temp = SifExecModuleBuffer(&libsd_irx, size_libsd_irx, 0, NULL, NULL);
    printf("LIBSD: %d\n", temp);
#else
    temp = SifLoadModule("rom0:SIO2MAN", 0, NULL);
    printf("rom0:SIO2MAN: %d\n", temp);
    temp = SifLoadModule("rom0:MCMAN", 0, NULL);
    printf("rom0:MCMAN: %d\n", temp);
	temp = SifLoadModule("rom0:MCSERV", 0, NULL);
    printf("rom0:MCSERV: %d\n", temp);
	temp = SifLoadModule("rom0:PADMAN", 0, NULL);
    printf("rom0:PADMAN: %d\n", temp);
    temp = SifLoadModule("rom0:LIBSD", 0, NULL);
    printf("rom0:LIBSD: %d\n", temp);
#endif

    // load USB modules    
    temp = SifExecModuleBuffer(&usbd_irx, size_usbd_irx, 0, NULL, NULL);
    printf("USBD: %d\n", temp);
    temp = SifExecModuleBuffer(&bdm_irx, size_bdm_irx, 0, NULL, NULL);
    printf("BDM: %d\n", temp);
    temp = SifExecModuleBuffer(&bdmfs_vfat_irx, size_bdmfs_vfat_irx, 0, NULL, NULL);
    printf("BDMFS_VFAT: %d\n", temp);
    temp = SifExecModuleBuffer(&usbmass_bd_irx, size_usbmass_bd_irx, 0, NULL, NULL);
    printf("USBMASS_BD: %d\n", temp);

    temp = SifExecModuleBuffer(&cdfs_irx, size_cdfs_irx, 0, NULL, NULL);
    printf("CDFS: %d\n", temp);

    temp = SifExecModuleBuffer(&audsrv_irx, size_audsrv_irx, 0, NULL, NULL);
    printf("AUDSVR: %d\n", temp);

	temp = SifExecModuleBuffer(&secrman_irx, size_secrman_irx, 0, NULL, NULL);
    printf("SECRMAN: %d\n", temp);
	temp = SifExecModuleBuffer(&secrsif_irx, size_secrsif_irx, 0, NULL, NULL);
    printf("SECRSIF: %d\n", temp);

    audsrv_init();

    initMC();

	
        // if no parameters are specified, use the default boot
	if (argc < 2)
	{
	   // set boot path global variable based on the elf path
	   setLuaBootPath (argc, argv, 0);  
        }
        else // set path based on the specified script
        {
           if (!strchr(argv[1], ':')) // filename doesn't contain device
              // set boot path global variable based on the elf path
	      setLuaBootPath (argc, argv, 0);  
           else
              // set path global variable based on the given script path
	      setLuaBootPath (argc, argv, 1);
	}
	
	// Lua init
	// init internals library
    
    // graphics (gsKit)
    initGraphics();

    pad_init();

    // set base path luaplayer
    chdir(boot_path); 

    printf("boot path : %s\n", boot_path);
	dbgprintf("boot path : %s\n", boot_path);
    
    while (1)
    {
    
        // if no parameters are specified, use the default boot
        if (argc < 2) {
            errMsg = runScript(bootString, true); 
        } else {
            errMsg = runScript(argv[1], false);
        }   

        gsKit_clear_screens();

        init_scr();

        sleep(1);

        if (errMsg != NULL)
        {
   	    scr_printf("Error: %s\n", errMsg);
        }

        scr_printf("\nPress [start] to restart\n");
        while (!isButtonPressed(PAD_START)) graphicWaitVblankStart();

    }

	return 0;
}

