
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
#include <sys/stat.h>

#include <dirent.h>

#include <sbv_patches.h>
#include <smem.h>

#include "include/graphics.h"
#include "include/sound.h"
#include "include/luaplayer.h"
#include "include/pad.h"

#define NEWLIB_PORT_AWARE
#include <fileXio_rpc.h>
#include <fileio.h>

extern "C"{
#include <libds34bt.h>
#include <libds34usb.h>
}
#define EXTERN_IRX(_n) \
extern unsigned char _n[]; \
extern unsigned int size_##_n
extern char bootString[];
extern unsigned int size_bootString;

EXTERN_IRX(iomanX_irx);
EXTERN_IRX(fileXio_irx);
EXTERN_IRX(sio2man_irx);
EXTERN_IRX(mcman_irx);
EXTERN_IRX(mcserv_irx);
EXTERN_IRX(padman_irx);
EXTERN_IRX(cdfs_irx);
EXTERN_IRX(usbd_irx);
EXTERN_IRX(bdm_irx);
EXTERN_IRX(bdmfs_fatfs_irx);
EXTERN_IRX(usbmass_bd_irx);
EXTERN_IRX(ds34usb_irx);
EXTERN_IRX(ds34bt_irx);

#ifdef F_Sound
EXTERN_IRX(libsd_irx);
EXTERN_IRX(audsrv_irx);
#endif

char boot_path[255];

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


void initMC(void)
{
   int ret;
   // mc variables
   int mc_Type, mc_Free, mc_Format;

   
   printf("initMC: Initializing Memory Card\n");

   ret = mcInit(MC_TYPE_XMC);
   
   if( ret < 0 ) {
	printf("initMC: failed to initialize memcard server.\n");
   } else {
       printf("initMC: memcard server started successfully.\n");
   }
   
   // Since this is the first call, -1 should be returned.
   // makes me sure that next ones will work !
   mcGetInfo(0, 0, &mc_Type, &mc_Free, &mc_Format); 
   mcSync(MC_WAIT, NULL, &ret);
}

#define IRX_REPORT(X) printf("%s: id=%d, ret=%d\n", X, irx_id, irx_ret)
#define load_irx(_mod, X) irx_id = SifExecModuleBuffer(&_mod, size_##_mod, 0, NULL, &irx_ret); IRX_REPORT(X)
#define load_irx_args(_mod, argc, argv, X) irx_id = SifExecModuleBuffer(&_mod, size_##_mod, argc, argv, &irx_ret); IRX_REPORT(X)

int main(int argc, char * argv[])
{
    const char * errMsg;
    int irx_id, irx_ret;

    #ifdef RESET_IOP  
    SifInitRpc(0);
    while (!SifIopReset("", 0)){};
    while (!SifIopSync()){};
    SifInitRpc(0);
    #endif
    
    // install sbv patch fix
    printf("Installing SBV Patches...\n");
    sbv_patch_enable_lmb();
    sbv_patch_disable_prefix_check(); 
    sbv_patch_fileio(); 

	DIR *directorytoverify;
	directorytoverify = opendir("host:.");
#ifndef FORCE_FILEXIO_LOAD
    if(directorytoverify==NULL){
#endif
		load_irx(iomanX_irx, "IOMANX");
		load_irx(fileXio_irx, "FILEXIO");
		closedir(directorytoverify);
#ifndef FORCE_FILEXIO_LOAD
	}
#endif
	load_irx(sio2man_irx, "SIO2MAN");
	load_irx(mcman_irx, "MCMAN");
	load_irx(mcserv_irx, "MCSERV");
    initMC();

	load_irx(padman_irx, "PADMAN");
#ifdef F_Sound
	load_irx(libsd_irx, "LIBSD");
    SifExecModuleBuffer(&libsd_irx, size_libsd_irx, 0, NULL, NULL);
#endif
    // load pad & mc modules 
    printf("Installing Pad & MC modules...\n");

    // load USB modules
	load_irx(usbd_irx, "USBD");

    
    int ds3pads = 1;
	load_irx_args(ds34usb_irx, 4, (char *)&ds3pads, "DS34USB");
	load_irx_args(ds34bt_irx,  4, (char *)&ds3pads, "DS32BT");
    ds34usb_init();
    ds34bt_init();

	load_irx(bdm_irx, "BDM");
	load_irx(bdmfs_fatfs_irx, "BDMFS_FATFS");
	load_irx(usbmass_bd_irx, "USBMASS_BD");

	load_irx(cdfs_irx, "CDFS");

#ifdef F_Sound
	load_irx(audsrv_irx, "AUDSRV");
#endif

    //waitUntilDeviceIsReady by fjtrujy

    struct stat buffer;
    int ret = -1;
    int retries = 50;

    while(ret != 0 && retries > 0)
    {
        ret = stat("mass:/", &buffer);
        /* Wait until the device is ready */
        nopdelay();

        retries--;
    }
	
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

        init_scr();

        if (errMsg != NULL)
        {
            scr_setfontcolor(0x0000ff);
            sleep(1); //ensures message is printed no matter what
		    scr_clear();
		    scr_setXY(5, 2);
		    scr_printf("ERROR AT BOOT SCRIPT\n");
		    scr_printf(errMsg);
		    puts(errMsg);
		    scr_printf("\nPress [start] to restart\n");
        	while (!isButtonPressed(PAD_START)) {
                	sleep(1);
		    }
            scr_setfontcolor(0xffffff);
        }

    }

	return 0;
}

