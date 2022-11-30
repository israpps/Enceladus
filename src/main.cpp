
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sifrpc.h>
#include <loadfile.h>
#include <libmc.h>
#include <libcdvd.h>
#include <iopheap.h>
#include <iopcontrol.h>
#include <iopcontrol_special.h>
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

extern "C" {
#include <libds34bt.h>
#include <libds34usb.h>
}

#include "include/dbgprintf.h"

#define IMPORT_BIN2C(_n)       \
    extern unsigned char _n[]; \
    extern unsigned int size_##_n


extern char bootString[];
extern unsigned int size_bootString;

IMPORT_BIN2C(iomanX_irx);
IMPORT_BIN2C(fileXio_irx);
IMPORT_BIN2C(sio2man_irx);
IMPORT_BIN2C(mcman_irx);
IMPORT_BIN2C(mcserv_irx);
IMPORT_BIN2C(padman_irx);
IMPORT_BIN2C(libsd_irx);
IMPORT_BIN2C(cdfs_irx);
IMPORT_BIN2C(usbd_irx);
IMPORT_BIN2C(bdm_irx);
IMPORT_BIN2C(bdmfs_vfat_irx);
IMPORT_BIN2C(usbmass_bd_irx);
IMPORT_BIN2C(audsrv_irx);
IMPORT_BIN2C(ds34usb_irx);
IMPORT_BIN2C(ds34bt_irx);
IMPORT_BIN2C(secrsif_irx);
IMPORT_BIN2C(secrman_irx);
IMPORT_BIN2C(IOPRP);

char boot_path[255];

void setLuaBootPath(int argc, char **argv, int idx)
{
    if (argc >= (idx + 1)) {

        char *p;
        if ((p = strrchr(argv[idx], '/')) != NULL) {
            snprintf(boot_path, sizeof(boot_path), "%s", argv[idx]);
            p = strrchr(boot_path, '/');
            if (p != NULL)
                p[1] = '\0';
        } else if ((p = strrchr(argv[idx], '\\')) != NULL) {
            snprintf(boot_path, sizeof(boot_path), "%s", argv[idx]);
            p = strrchr(boot_path, '\\');
            if (p != NULL)
                p[1] = '\0';
        } else if ((p = strchr(argv[idx], ':')) != NULL) {
            snprintf(boot_path, sizeof(boot_path), "%s", argv[idx]);
            p = strchr(boot_path, ':');
            if (p != NULL)
                p[1] = '\0';
        }
    }

    // check if path needs patching
    if (!strncmp(boot_path, "mass:/", 6) && (strlen(boot_path) > 6)) {
        strcpy((char *)&boot_path[5], (const char *)&boot_path[6]);
    }

    DPRINTF("%s: boot_path=%s\n", __func__, boot_path);
}


void initMC(void)
{
    int ret;
    // mc variables
    int mc_Type, mc_Free, mc_Format;


    DPRINTF("initMC: Initializing Memory Card\n");

    ret = mcInit(MC_TYPE_XMC);

    if (ret < 0) {
        DPRINTF("initMC: failed to initialize memcard server.\n");
    } else {
        DPRINTF("initMC: memcard server started successfully.\n");
    }

    // Since this is the first call, -1 should be returned.
    // makes me sure that next ones will work !
    mcGetInfo(0, 0, &mc_Type, &mc_Free, &mc_Format);
    mcSync(MC_WAIT, NULL, &ret);
}

int main(int argc, char *argv[])
{
//#ifdef SCR_PRINTF
    init_scr();
//#endif
    const char *errMsg;
    int ret = -1, STAT;
#ifdef RESET_IOP
    SifInitRpc(0);
    // ONLY ONE OF THE LINES BETWEEN THESE TWO COMMENTS CAN BE ENABLED AT THE SAME TIME
    // while (!SifIopReset("", 0)){};
    SifIopRebootBuffer(IOPRP, size_IOPRP); // use IOPRP image with SECRMAN_special inside
    // ONLY ONE OF THE LINES BETWEEN THESE TWO COMMENTS CAN BE ENABLED AT THE SAME TIME
    while (!SifIopSync()) {};
    SifInitRpc(0);
#endif

    // install sbv patch fix
    DPRINTF("Installing SBV Patches...\n");
    sbv_patch_enable_lmb();
    sbv_patch_disable_prefix_check();
    sbv_patch_fileio();

    DIR *directorytoverify;
    directorytoverify = opendir("host:.");
    if (directorytoverify == NULL) {
        ret = SifExecModuleBuffer(&iomanX_irx, size_iomanX_irx, 0, NULL, &STAT);
        DPRINTF("[IOMANX.IRX]: ret=%d, stat=%d\n", ret, STAT);
        ret = SifExecModuleBuffer(&fileXio_irx, size_fileXio_irx, 0, NULL, &STAT);
        DPRINTF("[FILEXIO.IRX]: ret=%d, stat=%d\n", ret, STAT);
    }
    ret = SifExecModuleBuffer(&sio2man_irx, size_sio2man_irx, 0, NULL, &STAT);
    DPRINTF("[SIO2MAN.IRX]: ret=%d, stat=%d\n", ret, STAT);
    if (directorytoverify == NULL) {
        fileXioInit();
    }
    if (directorytoverify != NULL) {
        closedir(directorytoverify);
    }
    ret = SifExecModuleBuffer(&mcman_irx, size_mcman_irx, 0, NULL, &STAT);
    DPRINTF("[MCMAN.IRX]: ret=%d, stat=%d\n", ret, STAT);
    ret = SifExecModuleBuffer(&mcserv_irx, size_mcserv_irx, 0, NULL, &STAT);
    DPRINTF("[MCSERV.IRX]: ret=%d, stat=%d\n", ret, STAT);
    initMC();

    ret = SifExecModuleBuffer(&padman_irx, size_padman_irx, 0, NULL, &STAT);
    DPRINTF("[PADMAN.IRX]: ret=%d, stat=%d\n", ret, STAT);
    ret = SifExecModuleBuffer(&libsd_irx, size_libsd_irx, 0, NULL, &STAT);
    DPRINTF("[LIBSD.IRX]: ret=%d, stat=%d\n", ret, STAT);

    // load USB modules
    ret = SifExecModuleBuffer(&usbd_irx, size_usbd_irx, 0, NULL, &STAT);
    DPRINTF("[USBD.IRX]: ret=%d, stat=%d\n", ret, STAT);


    int ds3pads = 1;
    ret = SifExecModuleBuffer(&ds34usb_irx, size_ds34usb_irx, 4, (char *)&ds3pads, &STAT);
    DPRINTF("[DS34USB.IRX]: ret=%d, stat=%d\n", ret, STAT);
    ret = SifExecModuleBuffer(&ds34bt_irx, size_ds34bt_irx, 4, (char *)&ds3pads, &STAT);
    DPRINTF("[DS34BT.IRX]: ret=%d, stat=%d\n", ret, STAT);
    ds34usb_init();
    ds34bt_init();

    ret = SifExecModuleBuffer(&bdm_irx, size_bdm_irx, 0, NULL, &STAT);
    DPRINTF("[BDM.IRX]: ret=%d, stat=%d\n", ret, STAT);
    ret = SifExecModuleBuffer(&bdmfs_vfat_irx, size_bdmfs_vfat_irx, 0, NULL, &STAT);
    DPRINTF("[BDMFS_VFAT.IRX]: ret=%d, stat=%d\n", ret, STAT);
    ret = SifExecModuleBuffer(&usbmass_bd_irx, size_usbmass_bd_irx, 0, NULL, &STAT);
    DPRINTF("[USBMASS_BD.IRX]: ret=%d, stat=%d\n", ret, STAT);

    ret = SifExecModuleBuffer(&cdfs_irx, size_cdfs_irx, 0, NULL, &STAT);
    DPRINTF("[CDFS.IRX]: ret=%d, stat=%d\n", ret, STAT);

    ret = SifExecModuleBuffer(&audsrv_irx, size_audsrv_irx, 0, NULL, &STAT);
    DPRINTF("[AUDSRV.IRX]: ret=%d, stat=%d\n", ret, STAT);
    ret = SifExecModuleBuffer(&secrsif_irx, size_secrsif_irx, 0, NULL, &STAT);
    DPRINTF("[SECRSIF.IRX]: ret=%d, stat=%d\n", ret, STAT);
#ifndef RESET_IOP
    ret = SifExecModuleBuffer(&secrsif_irx, size_secrsif_irx, 0, NULL, &STAT);
    DPRINTF("[SECRMAN_SPECIAL.IRX]: ret=%d, stat=%d\n", ret, STAT);
#endif
    DPRINTF("\n\n\nFINISHED LOADING IRX FILES\n");
    // waitUntilDeviceIsReady by fjtrujy

    struct stat buffer;
    ret = -1;
    int retries = 50;

    while (ret != 0 && retries > 0) {
        ret = stat("mass:/", &buffer);
        /* Wait until the device is ready */
        nopdelay();

        retries--;
    }
    DPRINTF("FINISHED WAITING FOR USB DEVICE READY\n");

    // if no parameters are specified, use the default boot
    if (argc < 2) {
        // set boot path global variable based on the elf path
        setLuaBootPath(argc, argv, 0);
    } else // set path based on the specified script
    {
        if (!strchr(argv[1], ':')) // filename doesn't contain device
                                   // set boot path global variable based on the elf path
            setLuaBootPath(argc, argv, 0);
        else
            // set path global variable based on the given script path
            setLuaBootPath(argc, argv, 1);
    }

    // Lua init
    // init internals library

    // graphics (gsKit)
    initGraphics();
    DPRINTF("initGraphics() Finished\n");

    pad_init();
    DPRINTF("pad_init() Finished\n");

    // set base path luaplayer
    chdir(boot_path);

    DPRINTF("boot path : %s\n", boot_path);

    while (1) {

        // if no parameters are specified, use the default boot
        if (argc < 2) {
            DPRINTF("running bootstring\n");
            errMsg = runScript(bootString, true);
        } else {
            DPRINTF("running argv[1] =%s\n", argv[1]);
            errMsg = runScript(argv[1], false);
        }


        if (errMsg != NULL) {
#ifndef SCR_PRINTF
            init_scr();
#endif
            scr_clear();
            DPRINTF("\n\nerrMsg is not null and it's contents are:\n%s\n\n", errMsg);
#ifndef SCR_PRINTF
            scr_printf("\n\nerrMsg is not null and it's contents are:\n%s\n\n", errMsg);
#endif
            scr_setXY(5, 2);
            scr_printf("Enceladus ERROR!\n");
            scr_printf(errMsg);
            scr_printf("\nPress [start] to restart\n");
            while (!isButtonPressed(PAD_START)) {
            }
        }
    }

    return 0;
}
