Font.ftInit()
LSANS = Font.ftLoad("font.ttf") --- LIBERATION SANS
BgWhite = Color.New(0xCC, 0xCC, 0xCC)
FntBlack = Color.New(0x10, 0x10, 0x10, 0x10)
FntBlackShade = Color.New(0x60, 0x60, 0x60, 0x60)
function ftPrint_shaded(font, x, y, align, width, height, text, color, shadecolor)
    Font.ftPrint(font, x, y, align, width, height, text, color)
    Font.ftPrint(font, x+2, y+2, align, width, height, text, shadecolor)
end

Screen.Clear(BgWhite)

ftPrint_shaded(LSANS, 50, 50, 0, 400, 40, "Hello There", FntBlack, FntBlackShade)

Screen.flip()

while true do
    
end