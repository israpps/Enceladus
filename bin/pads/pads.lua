Font.ftInit()
font = Font.ftLoad("pads/font.ttf")
--ALIGN_HCENTER = bit.blshift(2, 2)
--ALIGN_VCENTER = bit.blshift(2, 0)
temporaryVar = System.openFile("rom0:ROMVER", FREAD)
temporaryVar_size = System.sizeFile(temporaryVar)
ROMVER = System.readFile(temporaryVar, temporaryVar_size)
ROMVER = string.sub(ROMVER,0,14)
System.closeFile(temporaryVar)
KELFBinder.init(ROMVER)
local circle = Graphics.loadImage("pads/circle.png")
local cross = Graphics.loadImage("pads/cross.png")
local square = Graphics.loadImage("pads/square.png")
local triangle = Graphics.loadImage("pads/triangle.png")

local up = Graphics.loadImage("pads/up.png")
local down = Graphics.loadImage("pads/down.png")
local left = Graphics.loadImage("pads/left.png")
local right = Graphics.loadImage("pads/right.png")

local start = Graphics.loadImage("pads/start.png")
local pad_select = Graphics.loadImage("pads/select.png")

local r1 = Graphics.loadImage("pads/R1.png")
local r2 = Graphics.loadImage("pads/R2.png")

local l1 = Graphics.loadImage("pads/L1.png")
local l2 = Graphics.loadImage("pads/L2.png")

local l3 = Graphics.loadImage("pads/L3.png")
local r3 = Graphics.loadImage("pads/R3.png")

local pad = nil
--[[local rx = nil
local ry = nil
local lx = nil
local ly = nil]]
local pressure = nil
local SYSUPDATEPATH = KELFBinder.calculateSysUpdatePath()
local REGION = KELFBinder.getsystemregion()
local REGIONSTR = KELFBinder.getsystemregionString()
local ROMVERN = KELFBinder.getROMversion()
Language = KELFBinder.getsystemLanguage()
while true do
  Screen.clear()

  Font.ftPrint(font, 150, 20,  0, 400, 32, ROMVER)
  Font.ftPrint(font, 150, 50,  0, 400, 32, "your console looks for updates on this path \n "..SYSUPDATEPATH.."\n")
  Font.ftPrint(font, 150, 100, 0, 400, 32, "Console region "..REGION.." ("..REGIONSTR..")\n")
  Font.ftPrint(font, 150, 150, 0, 400, 32, "system ROM version is "..ROMVERN.."\n")
  Font.ftPrint(font, 150, 190, 0, 400, 32, "system Language is "..Language.."\n")
  --Font.fmPrint(100, 370, 0.4, "\nTips:\n")
  --Font.fmPrint(100, 390, 0.4, "\nPress R2+L2 to start rumble and R3+L3 to stop it.\n")
  --Font.fmPrint(100, 405, 0.4, "\nButtons transparency varies with the pressure applied to them\n")

  pad = Pads.get()
  
  Screen.flip()
  --Screen.waitVblankStart()
end
