#ifndef DPRINTF_H
#define DPRINTF_H

#define COMMON_PRINTF
#ifdef SIO_PRINTF
    #define DPRINTF(x...) sio_printf(x);
#endif

#ifdef SCR_PRINTF
    #include <debug.h>
    #define DPRINTF(x...) scr_printf(x);
#endif

#ifdef COMMON_PRINTF
    #define DPRINTF(x...) printf(x);
#endif

#ifndef DPRINTF
    #define DPRINTF(x...) ;
#endif

#endif