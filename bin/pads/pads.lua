Screen.clear()
Font.ftInit()
font = Font.ftLoad("pads/font.ttf")
local temporaryVar = System.openFile("rom0:ROMVER", FREAD)
local temporaryVar_size = System.sizeFile(temporaryVar)
ROMVER = System.readFile(temporaryVar, temporaryVar_size)
ROMVER = string.sub(ROMVER,0,14)
System.closeFile(temporaryVar)

KELFBinder.init(ROMVER)
Secrman.init()

SYSUPDATE_MAIN = "INSTALL/KELF/SYSTEM.XLF"
-- SYSUPDATE_DESR = "INSTALL/KELF/XSYSTEM.XLF"
KERNEL_PATCH_100 = "INSTALL/KELF/OSDSYS.KERNEL"
KERNEL_PATCH_101 = "INSTALL/KELF/OSD110.KERNEL"

local circle = Graphics.loadImage("pads/circle.png")
local cross = Graphics.loadImage("pads/cross.png")
local square = Graphics.loadImage("pads/square.png")
local triangle = Graphics.loadImage("pads/triangle.png")

local up = Graphics.loadImage("pads/up.png")
local down = Graphics.loadImage("pads/down.png")
local left = Graphics.loadImage("pads/left.png")
local right = Graphics.loadImage("pads/right.png")

--local start = Graphics.loadImage("pads/start.png")
--local pad_select = Graphics.loadImage("pads/select.png")

--local r1 = Graphics.loadImage("pads/R1.png")
--local r2 = Graphics.loadImage("pads/R2.png")

--local l1 = Graphics.loadImage("pads/L1.png")
--local l2 = Graphics.loadImage("pads/L2.png")

--local l3 = Graphics.loadImage("pads/L3.png")
--local r3 = Graphics.loadImage("pads/R3.png")
local MC = Graphics.loadImage("pads/MC.png")

pad = nil
local SYSUPDATEPATH = KELFBinder.calculateSysUpdatePath()
local REGION = KELFBinder.getsystemregion()
local REGIONSTR = KELFBinder.getsystemregionString()
local ROMVERN = KELFBinder.getROMversion()
Language = KELFBinder.getsystemLanguage()

function promptkeys(SELECT, CANCEL, REFRESH)

  if SELECT == 1 then
    Graphics.drawImage(cross, 80.0, 400.0)
    Font.ftPrint(font, 110 , 407, 0, 400, 16, "Select")
  end
  if CANCEL == 1 then
    Graphics.drawImage(circle, 170.0, 400.0)
    Font.ftPrint(font, 200 , 407, 0, 400, 16, "Quit")
  end
  if REFRESH == 1 then
    Graphics.drawImage(triangle, 240.0, 400.0)
    Font.ftPrint(font, 270 , 407, 0, 400, 16, "Refresh")
  end

end

function greeting()
  local CONTINUE = true
  local Q = 4
  local W = 1
    while CONTINUE do
      Screen.clear()
      if Q > 250 then W = -1 end
      if Q > 3 then Q = Q+W else CONTINUE = false end
      Font.ftPrint(font, 320, 20  , 8, 600, 64, "HELLO MOTHERFUCKER", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 320 , 8, 600, 64, "Coded By El_isra (aka: Matias Israelson)", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 340 , 8, 600, 64, "Based on Enceladus. by Daniel Santos", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 360 , 8, 600, 64, "SECRMAN and SECRSIF taken from FreeMcBoot 1.9 series installer", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 380 , 8, 600, 64, "Thanks to everyone that contributed with ideas !", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 400 , 8, 600, 64, "Get me Free at github.com/israpps/KelfBinder", Color.new(240, 240, 240, Q))
      Screen.flip()
    end
end

function MainMenu()
  local T = 3
  local D = 0
  while true do
    Screen.clear()
    Font.ftPrint(font, 150, 20,  0, 400, 32, "HELLO MOTHERFUCKER")
    if T == 3 then
      Font.ftPrint(font, 100, 150, 0, 400, 16, "Manage System Updates", Color.new(200, 200, 200, 0x80))
    else
      Font.ftPrint(font, 100, 150, 0, 400, 16, "Manage System Updates", Color.new(200, 200, 200, 0x50))
    end
    if T == 2 then
      Font.ftPrint(font, 100, 190, 0, 400, 16, "Manage DVDPlayer Updates", Color.new(200, 200, 200, 0x80))
    else
      Font.ftPrint(font, 100, 190, 0, 400, 16, "Manage DVDPlayer Updates", Color.new(200, 200, 200, 0x50))
    end
    if T == 1 then
      Font.ftPrint(font, 100, 300, 0, 400, 16, "Exit program", Color.new(200, 200, 200, 0x80))
    else
      Font.ftPrint(font, 100, 300, 0, 400, 16, "Exit program", Color.new(200, 200, 200, 0x50))
    end

    promptkeys(1,0,0)
    Screen.flip()
    pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      Screen.clear()
      break
    end

    if Pads.check(pad, PAD_UP) and D == 0 then 
      T = T+1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then 
      T = T-1
      D = 1
    end
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if T < 1 then T = 3 end
    if T > 3 then T = 1 end 

  end
  return T
end

function SystemUpdatePicker()
  local T = 3
  local D = 0
  while true do
    Screen.clear()
    Font.ftPrint(font, 150, 20,  0, 400, 32, "HELLO MOTHERFUCKER")

    if T == 3 then
      Font.ftPrint(font, 100, 150, 0, 400, 16, "Normal Install", Color.new(200, 200, 200, 0x80))
    else
      Font.ftPrint(font, 100, 150, 0, 400, 16, "Normal Install", Color.new(200, 200, 200, 0x50))
    end
    if T == 2 then
      Font.ftPrint(font, 100, 190, 0, 400, 16, "Advanced Install", Color.new(200, 200, 200, 0x80))
    else
      Font.ftPrint(font, 100, 190, 0, 400, 16, "Advanced Install", Color.new(200, 200, 200, 0x50))
    end
    if T == 1 then
      Font.ftPrint(font, 100 , 230, 0, 400, 16, "Expert Install", Color.new(200, 200, 200, 0x80))
    else
      Font.ftPrint(font, 100 , 230, 0, 400, 16, "Expert Install", Color.new(200, 200, 200, 0x50))
    end

    promptkeys(1,1,0)

    Screen.flip()
    local pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      Screen.clear()
      break
    end

    if Pads.check(pad, PAD_UP) and D == 0 then 
      T = T+1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then 
      T = T-1
      D = 1
    end
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if T < 1 then T = 3 end
    if T > 3 then T = 1 end 

  end
  return T
end

function MemcardPickup()
  local T = 1
  local D = 0
  local Q = 0x77
  local QP = -4
  local mcinfo0 = System.getMCInfo(0)
  local mcinfo1 = System.getMCInfo(1)
  while true do
    Screen.clear()
    Font.ftPrint(font, 320, 20,  8, 400, 32, "Choose a Memory card")
    if (T == 1) and (mcinfo0.type == 2) then
      Graphics.drawImage(MC, 80.0, 150.0, Color.new(0x80, 0x80, 0x80, Q))
    else
      Graphics.drawImage(MC, 80.0, 150.0)
    end


    if mcinfo0.type == 2 then
      Font.ftPrint(font, 80, 270,  0, 400, 32, "Memory Card 1\n  Free Space: "..mcinfo0.freemem.." kb")
      if T == 2 then
        Graphics.drawImage(MC, 360.0, 150.0, Color.new(0x80, 0x80, 0x80, Q))
      else
        Graphics.drawImage(MC, 360.0, 150.0)
      end
    end
    if mcinfo1.type == 2 then
      Font.ftPrint(font, 360, 270,  0, 400, 32, "Memory Card 2\n  Free Space: "..mcinfo1.freemem.." kb")
      if T == 2 then
        Graphics.drawImage(MC, 360.0, 150.0, Color.new(0x80, 0x80, 0x80, Q))
      else
        Graphics.drawImage(MC, 360.0, 150.0)
      end
    end

    promptkeys(1,1,1)
    Screen.flip()
    pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      Screen.clear()
      break
    end

    if Pads.check(pad, PAD_LEFT) and D == 0 then 
      T = 1
      D = 1
      Q = 0x77
    elseif Pads.check(pad, PAD_RIGHT) and D == 0 then 
      T = 2
      D = 1
      Q = 0x77
    end
    if Q < 4 then QP = 4 end
    if Q > 0x77 then QP = -4 end
    Q = Q+QP
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    
    if Pads.check(pad, PAD_TRIANGLE)  then
      mcinfo0 = System.getMCInfo(0)
      mcinfo1 = System.getMCInfo(1)
    end

  end
  return T
end

-- HERE THE SCRIPT BEHAVIOUR SHOULD BEGIN
--greeting()
MainMenu()
System.sleep(1)
SystemUpdatePicker()
System.sleep(1)
MemcardPickup()
System.sleep(1)
while true do
  Screen.clear()

  Font.ftPrint(font, 150, 20,  0, 400, 32, ROMVER)
  Font.ftPrint(font, 150, 50,  0, 400, 32, "your console looks for updates on this path \n "..SYSUPDATEPATH.."\n")
  Font.ftPrint(font, 150, 100, 0, 400, 32, "Console region "..REGION.." ("..REGIONSTR..")\n")
  Font.ftPrint(font, 150, 150, 0, 400, 32, "system ROM version is "..ROMVERN.."\n")
  Font.ftPrint(font, 150, 190, 0, 400, 32, "system Language is "..Language.."\n")
  --Font.fmPrint(100, 370, 0.4, "\nTips:\n")
  --Font.ftPrint(font, 100, 300, 0, 400, 32, string.format("SLOT0  type=%d, freespace=%d, format=%d", mcinfo0.type, mcinfo0.freemem, mcinfo0.format))
  --Font.ftPrint(font, 100, 350, 0, 400, 32, string.format("SLOT1  type=%d, freespace=%d, format=%d", mcinfo1.type, mcinfo1.freemem, mcinfo1.format))
  pad = Pads.get()
  
  Screen.flip()
  --Screen.waitVblankStart()
end


--]]

while true do end