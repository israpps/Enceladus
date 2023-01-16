#define _GNU_SOURCE
#include <SIOCookie.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sio.h>

// GLOBAL
FILE *EE_SIO;
cookie_io_functions_t COOKIE_FNCTS;

ssize_t cookie_sio_write(void *c, const char *buf, size_t size);
ssize_t cookie_sio_read(void *c, char *buf, size_t size);
// int cookie_sio_seek(void *c, _off64_t *offset, int whence);
// int cookie_sio_close(void *c);

int ee_sio_start(u32 baudrate, u8 lcr_ueps, u8 lcr_upen, u8 lcr_usbl, u8 lcr_umode)
{
    sio_init(baudrate, lcr_ueps, lcr_upen, lcr_usbl, lcr_umode);

    COOKIE_FNCTS.read = cookie_sio_read;
    COOKIE_FNCTS.close = NULL;
    COOKIE_FNCTS.seek = NULL;
    COOKIE_FNCTS.write = cookie_sio_write;
    EE_SIO = fopencookie(NULL, "w+", COOKIE_FNCTS);
    if (EE_SIO == NULL) {
        printf("EE_SIO stream is NULL\n");
        return EESIO_COOKIE_OPEN_IS_NULL;
    }
    setvbuf(EE_SIO, NULL, _IONBF, 0); // no buffering for this bad boy
    fprintf(EE_SIO, "%s: finished\n", __func__);
    return EESIO_SUCESS;
}


ssize_t cookie_sio_write(void *c, const char *buf, size_t size)
{
    return sio_putsn(buf);
}

ssize_t cookie_sio_read(void *c, char *buf, size_t size)
{
    return sio_read(buf, size);
}
/*
int cookie_sio_seek(void *c, _off64_t *offset, int whence)
{
    DPRINTF("%s: start", __func__);
    return 0;
}

int cookie_sio_close(void *c)
{
    DPRINTF("%s: start", __func__);
    return 0;
} */
