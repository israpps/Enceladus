#ifndef DPRINTF_H
#define DPRINTF_H

#ifdef SIO_PRINTF
    #include <SIOCookie.h>
    #define DPRINTF_INIT() ee_sio_start(38400, 0, 0, 0, 0)
    #define DPRINTF(x...) printf(x)
#endif

#ifdef SCR_PRINTF
    #include <debug.h>
    #define DPRINTF(x...) scr_printf(x)
#endif

#ifdef COMMON_PRINTF
    #define DPRINTF(x...) printf(x)
#endif

#ifndef DPRINTF
    #define DPRINTF_INIT() ee_sio_start(38400, 0, 0, 0, 0)
    #define DPRINTF(x...) printf(x)
#endif

#ifndef DPRINTF_INIT
    #define DPRINTF_INIT(x...);
#endif

#endif