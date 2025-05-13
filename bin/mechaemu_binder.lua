BG = Graphics.loadImage("bg.png")
Graphics.setImageFilters(BG, LINEAR)


local V = Screen.getMode()
Screen.setMode(V.mode, 704, 480, V.colorMode, V.interlace, V.field)


Font.ftInit()
LSANS = Font.ftLoad("font.ttf") --- LIBERATION SANS
LSANS_SMALL = Font.ftLoad("font.ttf") --- LIBERATION SANS smaller
Font.ftSetCharSize(LSANS_SMALL, 840, 840)
Font.ftSetCharSize(LSANS, 940, 940)
BgWhite = Color.new(0xC0, 0xC0, 0xC0)
REDFONT = Color.new(200, 0, 0, 128)
FNTCOL = Color.new(200, 200, 200, 128)
FNTCOLShade = Color.new(128, 128, 128, 0x60)
function ftPrint_shaded(font, x, y, align, width, height, text, color, shadecolor)
    Font.ftPrint(font, x+1, y+1, align, width, height, text, shadecolor)
    Font.ftPrint(font, x, y, align, width, height, text, color)
end

Screen.clear(0)
Graphics.drawScaleImage(BG, 0.0, 0.0, 702, 480)
Font.ftPrint(LSANS, 50, 50, 0, 400, 40, "LOADING", FNTCOL)
Screen.flip()

local id, ret = Sif.loadModule(System.currentDirectory().."/secrsif_mechaemu.irx");

local normalkelf = {
    "BIEXEC-SYSTEM/osdsys.elf",  --- JAP, chassis A     ROM v1.00 (early SCPH-10000)
    "BIEXEC-SYSTEM/osd110.elf",  --- JAP, chassis A     ROM v1.01 (late SCPH-10000 & SCPH-15000)
    "BIEXEC-SYSTEM/osd130.elf",  --- JAP, chassis A+/AB ROM v1.20 (SCPH-18000)
    "BIEXEC-SYSTEM/osdmain.elf", --- any JAP model without PCMCIA, chassis D or newer

    --- USA updates
    "BAEXEC-SYSTEM/osd120.elf",  --- USA, ROM v1.10, 'B' Chassis (release model SCPH-30001)
    "BAEXEC-SYSTEM/osd130.elf",  --- USA, ROM v1.20, 'C' Chassis (release model SCPH-30001)
    "BAEXEC-SYSTEM/osdmain.elf", --- any USA model with chassis D or newer

    --- EUR updates
    "BEEXEC-SYSTEM/osd130.elf",  --- EUR, ROM v1.20, 'C' Chassis (release model SCPH-3000[2-4])
    "BEEXEC-SYSTEM/osdmain.elf", --- any EUR model with chassis D or newer

    --- standard CHINA updates
    "BCEXEC-SYSTEM/osdmain.elf", --- no known chinese models use sub-standard paths, covering a whole region with one file is so cool isn't it?
};
local arcadekelf = {
    "boot.bin"
};

if (id==0 and ret > 0) then
    print("go on, everything ok")
    Mecha.connect_rpc()
    local a = Mecha.ChangeKeyset(1)
    print("KEY ", a)
else
    error(("Failed to load IRX module\n%s: %d %d"):format("secrsif_mechaemu", id, ret))
end

while true do
    
end