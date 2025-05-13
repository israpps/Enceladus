#ifndef MECHAEMU_RPC
#define MECHAEMU_RPC
#include <stdint.h>
struct DownLoadFileParam
{
    int32_t port, slot;
    uint8_t buffer[0x400];

    int32_t result;
};

struct keyscontrol
{
    int newkyey;//requested key (pass -1 to get the current key)
    int currentkey;//the key that remains enabled after function ends
};

enum MGENUM {
    MGINT_INVALID = -1,
    MGINT_RETAIL,
    MGINT_DEVELOPER,
    MGINT_ARCADE,
    MGINT_PROTOTYPE,

    MGINT_COUNT,
};

#define MECHAEMU_RPC_IRX    (0x10245) // 0x10000 + `M` `E` `C` `H` `A` `E` `M` `U`
enum MECHAEMU_RPC_CMDS {
    SECRME_DOWNLOADFILE = 0,
    SECRME_CONTROLKEYS,
    SECRME_AUTHCARD,
};

#endif
