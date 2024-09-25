dofile("consoleid.db")
function DPRINTF(x, ...)
  return print(string.format(x, ...))
end
Font.ftInit()
MFNT = Font.ftLoad("font.ttf")
Font.ftSetCharSize(MFNT, 800, 800)
local m = Screen.getMode()
X = m.width
Y = m.height
XMID = X//2
YMID = Y//2
--#endregion MODELS
ConsoleID = System.GetConsoleID()
MechaVer = {}
MechaVer.major, MechaVer.minor = System.GetMECHACONVersion()
print("ConsoleID", ConsoleID)
print("MechaVer.major", MechaVer.major)
print("MechaVer.minor", MechaVer.minor)
Ret, EEPROMmodel = System.GetEEPROMmodel()
local ROMVERFD = System.openFile("rom0:ROMVER", FREAD)
ROMVER = System.readFile(ROMVERFD, 15)
System.closeFile(ROMVERFD)
local serialFound, serial = System.GetConsoleSerial()
function GetModel(ID)
  if Model[ID] ~= nil then
    return Model[ID]
  else
    return "UNKNOWN"
  end
end
function ModelIsUknown(ID)
  return (Model[ID] == nil)
end
function CLAMP(a, MIN, MAX)
  if a < MIN then return MIN end
  if a > MAX then return MAX end
  return a
end
function Tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
local UnknownModel = ModelIsUknown(ConsoleID)
local QR = Graphics.LoadQRCode()
Graphics.setImageFilters(QR, LINEAR)
C = {
  white = Color.new(128,128,128);
  red = Color.new(128,0,0);
}
local QQ = 1
local x = 128;
repeat
  Screen.clear()
  Font.ftPrint(MFNT, XMID, 50, 8, Y, 32, "PlayStation2 Model detector")
  Font.ftPrint(MFNT, XMID, 70, 8, Y, 32, "By: El_isra")
  Font.ftPrint(MFNT, XMID, 90, 8, Y, 32, "Based on MECHAPWN and PS2IDENT code")
  Font.ftPrint(MFNT, XMID, 110, 8, Y, 32, "Database registered models: "..Tablelength(Model))
  Graphics.drawRect(0, 130, X, 2, Color.new(255,255,255))
  Font.ftPrint(MFNT, 150, 135, 0, Y, 32, "ROMVER: "..ROMVER)
  Font.ftPrint(MFNT, 150, 150, 0, Y, 32, ("MECHACON: v%d.%d"):format(MechaVer.major, MechaVer.minor))
  Font.ftPrint(MFNT, 150, 165, 0, Y, 32, ("ConsoleID: 0x%04x (%s)"):format(ConsoleID, GetModel(ConsoleID)), UnknownModel and C.red or C.white)
  Font.ftPrint(MFNT, 150, 180, 0, Y, 32, ("EEPROM Model: %s"):format(EEPROMmodel), (Ret ~= 0 or EEPROMmodel == "UNKNOWN") and C.red or C.white)
  Font.ftPrint(MFNT, 150, 195, 0, Y, 32, ("Serial Number: %07d"):format(serial), serialFound and C.red or C.white)
  Graphics.drawRect(0, 215, X, 2, Color.new(255,255,255))
  if UnknownModel then
    if Pads.check(Pads.get(), PAD_START) then
      Graphics.drawScaleImage(QR, XMID-128, 220, 220, 220)
    else
      Font.ftPrint(MFNT, XMID, 215, 8, Y, 32, "Unknown Console ID! Please report:", Color.new(255,255,0, x))
      Font.ftPrint(MFNT, XMID, 230, 8, Y, 32, "https://github.com/israpps/israpps/discussions/2", Color.new(255,255,0, x))
      Graphics.drawScaleImage(QR, XMID-64, 250, 128, 128)
      
      Font.ftPrint(MFNT, XMID+64, 360, 0, Y, 32, "hold start for bigger QR!", Color.new(128,128,128, x))
    end
  end
  if x > 127 then QQ = -1 end
  if x < 50 then QQ = 1 end
  x = x + QQ
  Screen.flip()
until (not UnknownModel)
print("END OF LOOP")
while true do
	--System.Sleep(10)
end