/*
 Copyright 2022, Thanks to SP193.
 code borrowed from OpenPs2Loader, thanks to krahjolito for bgm support
 Licenced under Academic Free License version 3.0
 Review OpenPS2Loader README & LICENSE files for further details.
 */
/*--    Theme Background Music    -------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------*/
#include <audsrv.h>
#include <vorbis/vorbisfile.h>
#include <kernel.h>
#include <errno.h>
#include <malloc.h>
#include <string.h>
#include <stdio.h>

int gEnableBGM = 1;
#define DPRINTF(x...)

// default sfx
// Silence unused variable warnings from vorbisfile.h
static ov_callbacks OV_CALLBACKS_NOCLOSE __attribute__((unused));
static ov_callbacks OV_CALLBACKS_STREAMONLY __attribute__((unused));
static ov_callbacks OV_CALLBACKS_STREAMONLY_NOCLOSE __attribute__((unused));

/*--    Theme Sound Effects    ----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------*/

#define BGM_RING_BUFFER_COUNT 16
#define BGM_RING_BUFFER_SIZE  4096
#define BGM_THREAD_BASE_PRIO  0x40
#define BGM_THREAD_STACK_SIZE 0x1000

extern void *_gp;

static int bgmThreadID, bgmIoThreadID;
static int outSema, inSema;
static unsigned char terminateFlag, bgmIsPlaying;
static unsigned char rdPtr, wrPtr;
static char bgmBuffer[BGM_RING_BUFFER_COUNT][BGM_RING_BUFFER_SIZE];
static volatile unsigned char bgmThreadRunning, bgmIoThreadRunning;

static u8 bgmThreadStack[BGM_THREAD_STACK_SIZE] __attribute__((aligned(16)));
static u8 bgmIoThreadStack[BGM_THREAD_STACK_SIZE] __attribute__((aligned(16)));

static OggVorbis_File *vorbisFile;

static void bgmThread(void *arg)
{
    DPRINTF("%s: starts\n", __func__);
    bgmThreadRunning = 1;

    while (!terminateFlag) {
        SleepThread();

        while (PollSema(outSema) == outSema) {
            audsrv_wait_audio(BGM_RING_BUFFER_SIZE);
            audsrv_play_audio(bgmBuffer[rdPtr], BGM_RING_BUFFER_SIZE);
            rdPtr = (rdPtr + 1) % BGM_RING_BUFFER_COUNT;

            SignalSema(inSema);
        }
    }

    audsrv_stop_audio();

    rdPtr = 0;
    wrPtr = 0;

    bgmThreadRunning = 0;
    bgmIsPlaying = 0;
}

static void bgmIoThread(void *arg)
{
    DPRINTF("%s: starts\n", __func__);
    int partsToRead, decodeTotal, bitStream, i;

    bgmIoThreadRunning = 1;
    do {
        WaitSema(inSema);
        partsToRead = 1;

        while ((wrPtr + partsToRead < BGM_RING_BUFFER_COUNT) && (PollSema(inSema) == inSema))
            partsToRead++;

        decodeTotal = BGM_RING_BUFFER_SIZE;
        int bufferPtr = 0;
        do {
            int ret = ov_read(vorbisFile, bgmBuffer[wrPtr] + bufferPtr, decodeTotal, 0, 2, 1, &bitStream);
            if (ret > 0) {
                bufferPtr += ret;
                decodeTotal -= ret;
            } else if (ret < 0) {
                DPRINTF("BGM: I/O error while reading.\n");
                terminateFlag = 1;
                break;
            } else if (ret == 0)
                ov_pcm_seek(vorbisFile, 0);
        } while (decodeTotal > 0);

        wrPtr = (wrPtr + partsToRead) % BGM_RING_BUFFER_COUNT;
        for (i = 0; i < partsToRead; i++)
            SignalSema(outSema);
        WakeupThread(bgmThreadID);
    } while (!terminateFlag && gEnableBGM);

    bgmIoThreadRunning = 0;
    terminateFlag = 1;
    WakeupThread(bgmThreadID);
}

static int bgmLoad(const char* gDefaultBGMPath)
{
    DPRINTF("%s: starts\n", __func__);
    FILE *bgmFile;
    char bgmPath[256];

    vorbisFile = (OggVorbis_File*) malloc(sizeof(OggVorbis_File));
    memset(vorbisFile, 0, sizeof(OggVorbis_File));

    //snprintf(bgmPath, sizeof(bgmPath), gDefaultBGMPath);
    memcpy(bgmPath, gDefaultBGMPath, sizeof(bgmPath));
    bgmFile = fopen(bgmPath, "rb");
    if (bgmFile == NULL) {
        DPRINTF("BGM: Failed to open Ogg file %s\n", bgmPath);
        return -ENOENT;
    }

    if (ov_open_callbacks(bgmFile, vorbisFile, NULL, 0, OV_CALLBACKS_DEFAULT) < 0) {
        DPRINTF("BGM: Input does not appear to be an Ogg bitstream.\n");
        return -ENOENT;
    }

    return 0;
}

static int bgmInit(void)
{
    DPRINTF("%s: starts\n", __func__);
    ee_thread_t thread;
    ee_sema_t sema;
    int result;

    terminateFlag = 0;
    rdPtr = 0;
    wrPtr = 0;
    bgmThreadRunning = 0;
    bgmIoThreadRunning = 0;

    sema.max_count = BGM_RING_BUFFER_COUNT;
    sema.init_count = BGM_RING_BUFFER_COUNT;
    sema.attr = 0;
    sema.option = (u32) "bgm-in-sema";
    inSema = CreateSema(&sema);

    if (inSema >= 0) {
        sema.max_count = BGM_RING_BUFFER_COUNT;
        sema.init_count = 0;
        sema.attr = 0;
        sema.option = (u32) "bgm-out-sema";
        outSema = CreateSema(&sema);

        if (outSema < 0) {
            DeleteSema(inSema);
            return outSema;
        }
    } else
        return inSema;

    thread.func = (void*) bgmThread;
    thread.stack = bgmThreadStack;
    thread.stack_size = sizeof(bgmThreadStack);
    thread.gp_reg = &_gp;
    thread.initial_priority = BGM_THREAD_BASE_PRIO;
    thread.attr = 0;
    thread.option = 0;

    // BGM thread will start in DORMANT state.
    bgmThreadID = CreateThread(&thread);

    if (bgmThreadID >= 0) {
        thread.func = &bgmIoThread;
        thread.stack = bgmIoThreadStack;
        thread.stack_size = sizeof(bgmIoThreadStack);
        thread.gp_reg = &_gp;
        thread.initial_priority = BGM_THREAD_BASE_PRIO + 1;
        thread.attr = 0;
        thread.option = 0;

        // BGM I/O thread will start in DORMANT state.
        bgmIoThreadID = CreateThread(&thread);
        if (bgmIoThreadID >= 0) {
            result = 0;
        } else {
            DeleteSema(inSema);
            DeleteSema(outSema);
            DeleteThread(bgmThreadID);
            result = bgmIoThreadID;
        }
    } else {
        result = bgmThreadID;
        DeleteSema(inSema);
        DeleteSema(outSema);
    }

    return result;
}

static void bgmDeinit(void)
{
    DPRINTF("%s()\n", __func__);
    DeleteSema(inSema);
    DeleteSema(outSema);
    DeleteThread(bgmThreadID);
    DeleteThread(bgmIoThreadID);

    // Vorbisfile takes care of fclose.
    ov_clear(vorbisFile);
    free(vorbisFile);
    vorbisFile = NULL;
}

static void bgmShutdownDelayCallback(s32 alarm_id, u16 time, void *common)
{
    iWakeupThread((int)common);
}

void bgmStart(const char* gDefaultBGMPath)
{
    DPRINTF("%s: starts\n", __func__);
    struct audsrv_fmt_t audsrvFmt;

    int ret = bgmInit();
    DPRINTF("%s: bgmInit (%d)\n", __func__, ret);
    if (ret >= 0) {
        if ((ret = bgmLoad(gDefaultBGMPath)) != 0) {
            DPRINTF("%s: bgmLoad failed with return value (%d)\n", __func__, ret);
            bgmDeinit();
            return;
        }
        DPRINTF("%s: bgmLoad (%d)\n", __func__, ret);

        vorbis_info *vi = ov_info(vorbisFile, -1);
        ov_pcm_seek(vorbisFile, 0);
        audsrvFmt.channels = vi->channels;
        audsrvFmt.freq = vi->rate;
        audsrvFmt.bits = 16;
        DPRINTF("%s: audsrvFmt = {\n\tchannels = %d\n\tfreq = %d \n\tbits = %d\n}\n", __func__, audsrvFmt.channels, audsrvFmt.freq, audsrvFmt.bits);

        DPRINTF("%s: audsrv_set_format(&audsrvFmt);\n", __func__);
        //audsrv_set_format(&audsrvFmt);

        bgmIsPlaying = 1;
        DPRINTF("%s: starting thread\n", __func__);
        StartThread(bgmIoThreadID, NULL);
        StartThread(bgmThreadID, NULL);
    }
}

void bgmStop(void)
{
    int threadId;


    DPRINTF("%s: terminating threads...\n", __func__);

    terminateFlag = 1;
    WakeupThread(bgmThreadID);

    threadId = GetThreadId();
    while (bgmIoThreadRunning) {
        SetAlarm(200 * 16, &bgmShutdownDelayCallback, (void *)threadId);
        SleepThread();
    }
    while (bgmThreadRunning) {
        SetAlarm(200 * 16, &bgmShutdownDelayCallback, (void *)threadId);
        SleepThread();
    }

    bgmDeinit();

    DPRINTF("BGM: stopped.\n");
}

int isBgmPlaying(void)
{
    DPRINTF("%s: starts\n", __func__);
    int ret = (int)bgmIsPlaying;
    return ret;
}

// HACK: BGM stutters while perfroming certain tasks, mute during these operations and unmute once completed.
void bgmMute(void)
{
    DPRINTF("%s()\n", __func__);
    audsrv_set_volume(0);
}

void setVol(int vol)
{
    DPRINTF("%s()\n", __func__);
    audsrv_set_volume(vol);
}
