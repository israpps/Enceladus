#ifndef SYSUPDATE_PATH
#define SYSUPDATE_PATH

const char *sysupdate_paths[] = {
    /// JAP updates
    "BIEXEC-SYSTEM/osdsys.elf",  /// JAP, chassis A     ROM v1.00 (early SCPH-10000)
    "BIEXEC-SYSTEM/osd110.elf",  /// JAP, chassis A     ROM v1.01 (late SCPH-10000 & SCPH-15000)
    "BIEXEC-SYSTEM/osd130.elf",  /// JAP, chassis A+/AB ROM v1.20 (SCPH-18000)
    "BIEXEC-SYSTEM/osdmain.elf", /// any JAP model without PCMCIA, chassis D or newer

    /// USA updates
    "BAEXEC-SYSTEM/osd120.elf",  /// USA, ROM v1.10, 'B' Chassis (release model SCPH-30001)
    "BAEXEC-SYSTEM/osd130.elf",  /// USA, ROM v1.20, 'C' Chassis (release model SCPH-30001)
    "BAEXEC-SYSTEM/osdmain.elf", /// any USA model with chassis D or newer

    /// EUR updates
    "BEEXEC-SYSTEM/osd130.elf",  /// EUR, ROM v1.20, 'C' Chassis (release model SCPH-3000[2-4])
    "BEEXEC-SYSTEM/osdmain.elf", /// any EUR model with chassis D or newer

    /// standard CHINA updates
    "BCEXEC-SYSTEM/osdmain.elf", /// no known chinese models use sub-standard paths, covering a whole region with one file is so cool isn't it?

};

enum SYSUPDATE_COUNT
{
    JAP_ROM_100 = 0,
    JAP_ROM_101,
    JAP_ROM_120,
    JAP_STANDARD,

    USA_ROM_110,
    USA_ROM_120,
    USA_STANDARD,

    EUR_ROM_120,
    EUR_STANDARD,

    CHN_STANDARD,

    SYSTEM_UPDATE_COUNT

};

// the following bit shifted macros are intended to be used for special installations, where used picked specific updates
#define BS(x) (1 << X)

#define JAP_100 BS(1)
#define JAP_101 BS(2)
#define JAP_120 BS(3)
#define JAP_STD BS(4)

#define USA_110 BS(5)
#define USA_120 BS(6)
#define USA_STD BS(7)

#define EUR_120 BS(8)
#define EUR_STD BS(9)

#define CHN_STD BS(10)

#endif