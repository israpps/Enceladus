#ifndef DPRINTF_H
#define DPRINTF_H

#define COMMON_PRINTF

#ifdef __cplusplus
extern "C" {
#endif
void sio_printf(const char *fmt, ...);
#ifdef __cplusplus
}
#endif

#ifdef SIO_PRINTF
#ifdef __cplusplus
extern "C" {
#endif
    #include <SIOCookie.h>
    #define DPRINTF_INIT() ee_sio_start(38400, 0, 0, 0, 0, 1)
    #define DPRINTF(x...) sio_printf(x)
    //#define DFLUSH() fflush(stdout)
#ifdef __cplusplus
}
#endif
#endif

#ifdef SCR_PRINTF
    #include <debug.h>
    #define DPRINTF(x...) scr_printf(x)
#endif

#ifdef COMMON_PRINTF
    #define DPRINTF(x...) printf(x)
    #define DPRINTF_INIT(x...);
#endif

#ifndef DPRINTF
#ifdef __cplusplus
extern "C" {
#endif
    #include <SIOCookie.h>
    #define DPRINTF_INIT() ee_sio_start(38400, 0, 0, 0, 0, 1)
    #define DPRINTF(x...) sio_printf(x)
    //#define DFLUSH() fflush(stdout)
#ifdef __cplusplus
}
#endif
#endif

#ifndef DPRINTF_INIT
    #define DPRINTF_INIT(x...);
#endif

#endif