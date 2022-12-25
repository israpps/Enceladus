Screen.clear()
Font.ftInit()
font = Font.ftLoad("pads/font.ttf")
Font.ftSetCharSize(font, 940, 940)
local temporaryVar = System.openFile("rom0:ROMVER", FREAD)
local temporaryVar_size = System.sizeFile(temporaryVar)
ROMVER = System.readFile(temporaryVar, temporaryVar_size)
ROMVER = string.sub(ROMVER,0,14)
System.closeFile(temporaryVar)
KELFBinder.init(ROMVER)
Secrman.init()
ROMVERN = KELFBinder.getROMversion()
KELFBinder.InitConsoleModel()
IS_PSX = 0
if System.doesFileExist("rom0:PSXVER") then 
  IS_PSX = 1
else
  IS_PSX = 0
end
DVDPLAYERUPDATE = "INSTALL/KELF/DVDPLAYER.XLF"
SYSUPDATE_MAIN  = "INSTALL/KELF/SYSTEM.XLF"
PSX_SYSUPDATE   =  "INSTALL/KELF/XSYSTEM.XLF"

temporaryVar = System.openFile(SYSUPDATE_MAIN, FREAD)
SYSUPDATE_SIZE = System.sizeFile(temporaryVar)
System.closeFile(temporaryVar)
KERNEL_PATCH_100 = "INSTALL/KELF/OSDSYS.KERNEL"
KERNEL_PATCH_101 = "INSTALL/KELF/OSD110.KERNEL"

local circle = Graphics.loadImage("pads/circle.png")
local cross = Graphics.loadImage("pads/cross.png")
local triangle = Graphics.loadImage("pads/triangle.png")

local MC2 = Graphics.loadImage("pads/mc_ps2.png")
local MC1 = Graphics.loadImage("pads/mc_ps1.png")
local MCU = Graphics.loadImage("pads/mc_empty.png")
local LOGO        = Graphics.loadImage("pads/logo.png")
local BG          = Graphics.loadImage("pads/background.png")
local BGERR       = Graphics.loadImage("pads/background_error.png")
local BGSCS       = Graphics.loadImage("pads/background_success.png")
local CURSOR      = Graphics.loadImage("pads/firefly.png")
local REDCURSOR   = Graphics.loadImage("pads/firefly_error.png")
local GREENCURSOR = Graphics.loadImage("pads/firefly_success.png")

Graphics.setImageFilters(LOGO       , LINEAR)
Graphics.setImageFilters(BG         , LINEAR)
Graphics.setImageFilters(BGERR      , LINEAR)
Graphics.setImageFilters(BGSCS      , LINEAR)

local REGION = KELFBinder.getsystemregion()
--local REGIONSTR = KELFBinder.getsystemregionString(REGION)
local R = 0.1
local RINCREMENT = 0.00018

Language = KELFBinder.getsystemLanguage()
Language = 3
if System.doesFileExist("lang/global.lua") then dofile("lang/global.lua")
elseif Language == 0 then if System.doesFileExist("lang/japanese.lua") then dofile("lang/japanese.lua") end
elseif Language == 2 then if System.doesFileExist("lang/french.lua") then dofile("lang/french.lua") end
elseif Language == 3 then if System.doesFileExist("lang/spanish.lua") then dofile("lang/spanish.lua") end
elseif Language == 4 then if System.doesFileExist("lang/german.lua") then dofile("lang/german.lua") end
elseif Language == 5 then if System.doesFileExist("lang/italian.lua") then dofile("lang/italian.lua") end
elseif Language == 6 then if System.doesFileExist("lang/dutch.lua") then dofile("lang/dutch.lua") end
elseif Language == 7 then if System.doesFileExist("lang/portuguese.lua") then dofile("lang/portuguese.lua") end
else
end

function ORBMAN(Q)
  R = R+RINCREMENT
  if R > 200 and RINCREMENT > 0 then RINCREMENT = -0.00018 end
  if R < 0   and RINCREMENT < 0 then RINCREMENT =  0.00018 end
  Graphics.drawImage(CURSOR, 180+(80*math.cos(math.deg(R*2.1+1.1))), 180+(80*math.sin(math.deg(R*2.1+1.1))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(CURSOR, 180+(80*math.cos(math.deg(R*2.1+1.2))), 180+(80*math.sin(math.deg(R*2.1+1.2))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(CURSOR, 180+(80*math.cos(math.deg(R*2.1+1.3))), 180+(80*math.sin(math.deg(R*2.1+1.3))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(CURSOR, 180+(80*math.cos(math.deg(R*2.1+1.4))), 180+(80*math.sin(math.deg(R*2.1+1.4))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(CURSOR, 180+(80*math.cos(math.deg(R*2.1+1.7))), 180+(80*math.sin(math.deg(R*2.1+1.7))),  Color.new(128, 128, 128, Q))
  Graphics.drawImage(CURSOR, 180+(80*math.cos(math.deg(R*2.1+1.8))), 180+(80*math.sin(math.deg(R*2.1+1.8))),  Color.new(128, 128, 128, Q))
  Graphics.drawImage(CURSOR, 180+(80*math.cos(math.deg(R*2.1+1.9))), 180+(80*math.sin(math.deg(R*2.1+1.9))),  Color.new(128, 128, 128, Q))
end

function ORBMANex(IMG, Q, X, Z, POW)
  R = R+RINCREMENT
  if R > 200 and RINCREMENT > 0 then RINCREMENT = -0.00018 end
  if R < 0   and RINCREMENT < 0 then RINCREMENT =  0.00018 end
  Graphics.drawImage(IMG, X+(POW*math.cos(math.deg(R*2.1+1.1))), Z+(POW*math.sin(math.deg(R*2.1+1.1))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(IMG, X+(POW*math.cos(math.deg(R*2.1+1.2))), Z+(POW*math.sin(math.deg(R*2.1+1.2))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(IMG, X+(POW*math.cos(math.deg(R*2.1+1.3))), Z+(POW*math.sin(math.deg(R*2.1+1.3))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(IMG, X+(POW*math.cos(math.deg(R*2.1+1.4))), Z+(POW*math.sin(math.deg(R*2.1+1.4))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(IMG, X+(POW*math.cos(math.deg(R*2.1+1.7))), Z+(POW*math.sin(math.deg(R*2.1+1.7))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(IMG, X+(POW*math.cos(math.deg(R*2.1+1.8))), Z+(POW*math.sin(math.deg(R*2.1+1.8))), Color.new(128, 128, 128, Q))
  Graphics.drawImage(IMG, X+(POW*math.cos(math.deg(R*2.1+1.9))), Z+(POW*math.sin(math.deg(R*2.1+1.9))), Color.new(128, 128, 128, Q))
end

function WaitWithORBS(NN)
  N = NN
  while N > 1 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    Screen.flip()
    N = N-1
  end
end

function FadeWIthORBS()
  local A = 0x80
  while A > 0 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(A)
    Screen.flip()
    A = A-1
  end
end

function promptkeys(SELECT, ST, CANCEL, CT, REFRESH, RT, ALFA)
  if SELECT == 1 then
    Graphics.drawScaleImage(cross, 90.0, 410.0, 16, 16, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
    Font.ftPrint(font, 110 , 407, 0, 400, 16, ST, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
  end
  if CANCEL == 1 then
    Graphics.drawScaleImage(circle, 180.0, 410.0, 16, 16, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
    Font.ftPrint(font, 200 , 407, 0, 400, 16, CT, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
  end
  if REFRESH == 1 then
    Graphics.drawScaleImage(triangle, 270.0, 410.0, 16, 16, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
    Font.ftPrint(font, 290 , 407, 0, 400, 16, RT, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
  end

end

function greeting()
  local CONTINUE = true
  local Q = 2
  local W = 1
    while CONTINUE do
      Screen.clear()
      if Q > 0x80 then W = -1 end
      if Q > 1 then Q = Q+W else CONTINUE = false end
      if W > 0 then
        Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(Q, Q, Q, Q))
      else
        Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
      end
      Graphics.drawImage(LOGO, 64.0, 50.0, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 20  , 8, 630, 16, "THIS IS NOT A PUBLIC-READY VERSION!", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 40  , 8, 630, 16, " Closed BETA - 007 ", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 320 , 8, 630, 16, LNG_CRDTS0, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 340 , 8, 630, 16, LNG_CRDTS1, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 360 , 8, 630, 16, LNG_CRDTS2, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 380 , 8, 630, 16, LNG_CRDTS3, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 400 , 8, 630, 16, LNG_CRDTS4, Color.new(240, 240, 240, Q))
      Screen.flip()
    end
end

function OrbIntro(BGQ)
  local A = 0x70
  local X = 0x90
  local Q = 0x80
  while X > 0 do
    Screen.clear()
    if BGQ == 0 then
      Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    else
      Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
      if Q > 0 then Q=Q-1 end
    end
    ORBMANex(CURSOR, 0x70-A, 180, 180, 80+X)
    if A > 0 then A=A-1 end
    if X > 0 then X=X-1 end
    Screen.flip()
  end
end

function MainMenu()
  local T = 1
  local D = 15
  local A = 0x80
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    Font.ftPrint(font, 320, 20,  8, 630, 32, LNG_MM1, Color.new(220, 220, 220, 0x90-A))
    if T == 1 then
      Font.ftPrint(font, 321, 150, 0, 630, 16, LNG_MM2, Color.new(0, 0xde, 0xff, 0x90-A)) else
      Font.ftPrint(font, 320, 150, 0, 630, 16, LNG_MM2, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 2 then
      Font.ftPrint(font, 321, 190, 0, 630, 16, LNG_MM3, Color.new(0, 0xde, 0xff, 0x90-A)) else
      Font.ftPrint(font, 320, 190, 0, 630, 16, LNG_MM3, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 3 then
      Font.ftPrint(font, 321, 230, 0, 630, 16, LNG_MM4, Color.new(0, 0xde, 0xff, 0x90-A)) else
      Font.ftPrint(font, 320, 230, 0, 630, 16, LNG_MM4, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 4 then
      Font.ftPrint(font, 321, 270, 0, 630, 16, LNG_MM6, Color.new(0, 0xde, 0xff, 0x90-A)) else
      Font.ftPrint(font, 320, 270, 0, 630, 16, LNG_MM6, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 5 then
      Font.ftPrint(font, 321, 310, 0, 630, 16, LNG_MM5, Color.new(0, 0xde, 0xff, 0x90-A)) else
      Font.ftPrint(font, 320, 310, 0, 630, 16, LNG_MM5, Color.new(200, 200, 200, 0x80-A))
    end
    if A > 0 then A=A-1 end
    promptkeys(1, LNG_CT0,0,0,0,0,A)
    Screen.flip()
    local pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      D = 1
      Screen.clear()
      break
    end

    if Pads.check(pad, PAD_UP) and D == 0 then
      T = T-1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then
      T = T+1
      D = 1
    end
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if T < 1 then T = 5 end
    if T > 5 then T = 1 end

  end
  return T
end

function Installmodepicker()
  local T = 1
  local D = 15
  local A = 0x80
  local PROMTPS = {
    LNG_IMPP0,
    LNG_IMPP1,
    LNG_IMPP2
  }
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    --Font.ftPrint(font, 150, 20,  0, 630, 32, LNG_IMPMP0, Color.new(220, 220, 220, 0x80-A))

    if T == 1 then
      Font.ftPrint(font, 321, 150, 0, 630, 16, LNG_IMPMP1, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 150, 0, 630, 16, LNG_IMPMP1, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 2 then
      Font.ftPrint(font, 321, 190, 0, 630, 16, LNG_IMPMP2, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 190, 0, 630, 16, LNG_IMPMP2, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 3 then
      Font.ftPrint(font, 321 , 230, 0, 630, 16, LNG_IMPMP3, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320 , 230, 0, 630, 16, LNG_IMPMP3, Color.new(200, 200, 200, 0x80-A))
    end
    
    Font.ftPrint(font, 80 , 350, 0, 600, 32, PROMTPS[T], Color.new(128, 128, 128, 0x80-A))
    promptkeys(1,LNG_CT0, 1, LNG_CT1,0, 0, A)
    if A > 0 then A=A-1 end
    Screen.flip()
    local pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      D = 1
      Screen.clear()
      break
    end

    if Pads.check(pad, PAD_CIRCLE) and D == 0 then
      T = 0
      break
    end

    if Pads.check(pad, PAD_UP) and D == 0 then
      T = T-1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then
      T = T+1
      D = 1
    end
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if T < 1 then T = 3 end
    if T > 3 then T = 1 end

  end
  return T
end

function DVDPlayerRegionPicker()
  local T = 1
  local D = 1
  local A = 0x80
  local PROMTPS = {
    "SCPH-XXX00",
    "SCPH-XXX0[1/6/7/8/10/11]",
    "SCPH-XXX0[2/3/4]",
    "SCPH-XXX09"
  }
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    Font.ftPrint(font, 320, 20,  8, 630, 32, LNG_PICK_DVDPLAYER_REG, Color.new(220, 220, 220, 0x80-A))

    if T == 1 then
      Font.ftPrint(font, 321, 150, 0, 630, 16, LNG_JAP, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 150, 0, 630, 16, LNG_JAP, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 2 then
      Font.ftPrint(font, 321, 190, 0, 630, 16, LNG_USANASIA, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 190, 0, 630, 16, LNG_USANASIA, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 3 then
      Font.ftPrint(font, 321 , 230, 0, 630, 16, LNG_EUR, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320 , 230, 0, 630, 16, LNG_EUR, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 4 then
      Font.ftPrint(font, 321 , 270, 0, 630, 16, LNG_CHN, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320 , 270, 0, 630, 16, LNG_CHN, Color.new(200, 200, 200, 0x80-A))
    end
    
    Font.ftPrint(font, 320 , 350, 8, 600, 32, PROMTPS[T], Color.new(128, 128, 128, 0x80-A))
    promptkeys(1,LNG_CT0, 1, LNG_CT1,0, 0, A)
    if A > 0 then A=A-1 end
    Screen.flip()
    local pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      D = 1
      Screen.clear()
      break
    end

    if Pads.check(pad, PAD_CIRCLE) and D == 0 then
      T = -1
      break
    end

    if Pads.check(pad, PAD_UP) and D == 0 then
      T = T-1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then
      T = T+1
      D = 1
    end
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if T < 1 then T = 4 end
    if T > 4 then T = 1 end

  end
  return (T-1)
end

function DVDPlayerINST(port, slot, target_region)
  local RET
  local TARGET_FOLD = KELFBinder.getDVDPlayerFolder(target_region)
  local TARGET_KELF = string.format("mc%d:/%s/dvdplayer.elf", port, TARGET_FOLD)
  System.createDirectory(string.format("mc%d:/%s", port, TARGET_FOLD))
  KELFBinder.setSysUpdateFoldProps(port, slot, TARGET_FOLD)
  Screen.clear()
  Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
  Font.ftPrint(font, 320, 20  , 8, 600, 64, string.format(LNG_INSTPMPT, TARGET_KELF))
  Screen.flip()
  
  RET = Secrman.downloadfile(port, slot, DVDPLAYERUPDATE, TARGET_KELF)
  if RET < 0 then secrerr(RET) return end
  secrerr(RET)
end

function NormalInstall(port, slot)

  if System.doesFileExist(string.format("mc%d:SYS-CONF/FMCBUINST.dat", port)) or 
     System.doesFileExist(string.format("mc%u:SYS-CONF/uninstall.dat", port)) then WarnIncompatibleMachine() return end

  local RET
  local REG = KELFBinder.getsystemregion()
  local TARGET_FOLD = string.format("mc%d:/%s", port, KELFBinder.getsysupdatefolder())
  if System.doesDirExist(TARGET_FOLD) then
    Ask2WipeSysUpdateDirs(false, false, false, false, true, port)
  end
  System.createDirectory(TARGET_FOLD)
  if REG == 0 then -- JAP
    System.copyFile("INSTALL/ASSETS/JAP.sys", string.format("%s/icon.sys", TARGET_FOLD))
  elseif REG == 1 or REG == 2 then --USA or ASIA
    System.copyFile("INSTALL/ASSETS/USA.sys", string.format("%s/icon.sys", TARGET_FOLD))
  elseif REG == 3 then
    System.copyFile("INSTALL/ASSETS/EUR.sys", string.format("%s/icon.sys", TARGET_FOLD))
  elseif REG == 4 then
    System.copyFile("INSTALL/ASSETS/CHN.sys", string.format("%s/icon.sys", TARGET_FOLD))
  end
  System.copyFile("INSTALL/ASSETS/PS2BBL.icn", string.format("%s/icon.sys", TARGET_FOLD)) --icon is the same for all

  KELFBinder.setSysUpdateFoldProps(port, slot, KELFBinder.getsysupdatefolder())
  SYSUPDATEPATH = KELFBinder.calculateSysUpdatePath()
  Screen.clear()
  Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
  if IS_PSX == 1 then
    Font.ftPrint(font, 320, 20  , 8, 600, 64, string.format(LNG_INSTPMPT, "BIEXEC-SYSTEM/xosdmain.elf"))
  else
    Font.ftPrint(font, 320, 20  , 8, 600, 64, string.format(LNG_INSTPMPT, SYSUPDATEPATH))
  end
    Screen.flip()
  if (ROMVERN == 100) or (ROMVERN == 101) then -- PROTOKERNEL NEEDS TWO UPDATES TO FUNCTION
    Secrman.downloadfile(port, slot, SYSUPDATE_MAIN, string.format("mc%d:/%s", port, "BIEXEC-SYSTEM/osd130.elf")) -- SCPH-18000
    if (ROMVERN == 100) then
      RET = Secrman.downloadfile(port, slot, KERNEL_PATCH_100, string.format("mc%d:/%s", port, SYSUPDATEPATH))
      if RET < 0 then secrerr(RET) return end
    else
      RET = Secrman.downloadfile(port, slot, KERNEL_PATCH_101, string.format("mc%d:/%s", port, SYSUPDATEPATH))
      if RET < 0 then secrerr(RET) return end
    end
  elseif IS_PSX == 1 then -- PSX NEEDS SPECIAL PATH
    RET = Secrman.downloadfile(port, slot, PSX_SYSUPDATE, string.format("mc%d:/BIEXEC-SYSTEM/xosdmain.elf", port))
    if RET < 0 then secrerr(RET) return end
  else -- ANYTHING ELSE FOLLOWS WHATEVER IS WRITTEN INTO 'SYSUPDATEPATH'
    RET = Secrman.downloadfile(port, slot, SYSUPDATE_MAIN, string.format("mc%d:/%s", port, SYSUPDATEPATH))
    if RET < 0 then secrerr(RET) return end
  end
  secrerr(RET)
end

function MemcardPickup()
  local T = 0
  local D = 15
  local Q = 0x77
  local QP = -4
  local A = 0x50
  local mi0
  local mi1
  local mcinfo0 = System.getMCInfo(0)
  local mcinfo1 = System.getMCInfo(1)
  while true do
    local HC = ((mcinfo0.type == 2) or (mcinfo1.type == 2))
    if mcinfo0.type == 2 then
      mi0 = MC2
    elseif mcinfo0.type == 1 then
      mi0 = MC1
    else mi0 = MCU
    end

    if mcinfo1.type == 2 then
      mi1 = MC2
    elseif mcinfo1.type == 1 then
      mi1 = MC1
    else mi1 = MCU
    end

    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    Font.ftPrint(font, 320, 20,  8, 630, 32, LNG_MEMCARD0, Color.new(0x80, 0x80, 0x80, 0x80-A))

    if mcinfo0.type == 2 then
      Font.ftPrint(font, 80, 270,  0, 630, 32, string.format(LNG_MEMCARD1, 1, mcinfo0.freemem), Color.new(0x80, 0x80, 0x80, 0x80-A))
    end
    if T == 0 then
      Graphics.drawScaleImage(mi0, 80.0+32, 180.0, 64, 64, Color.new(0x90, 0x90, 0x90, Q))
    else
      Graphics.drawScaleImage(mi0, 80.0+32, 180.0, 64, 64, Color.new(0x80, 0x80, 0x80, 0x80-A))
    end
    if mcinfo1.type == 2 then
      Font.ftPrint(font, 360, 270,  0, 630, 32, string.format(LNG_MEMCARD1, 2, mcinfo1.freemem), Color.new(0x80, 0x80, 0x80, 0x80-A))
    end
    if T == 1 then
      Graphics.drawScaleImage(mi1, 360.0+32, 180.0, 64, 64, Color.new(0x90, 0x90, 0x90, Q))
    else
      Graphics.drawScaleImage(mi1, 360.0+32, 180.0, 64, 64, Color.new(0x80, 0x80, 0x80, 0x80-A))
    end

    if A > 0 then A=A-1 end
    promptkeys(1,LNG_CT0,1,LNG_CT1, 1,LNG_CT2, A)
    Screen.flip()
    local pad = Pads.get()
    if Pads.check(pad, PAD_CROSS) and (D == 0) and (HC == true) then
      D = 1
      if (mcinfo0.type == 2 and T == 0) or (mcinfo1.type == 2 and T == 1) then
        Screen.clear()
        break
      end
    end

    if Pads.check(pad, PAD_CIRCLE) and D == 0 then T = -1 break end
    if Pads.check(pad, PAD_LEFT) and D == 0 then
      T = 0
      D = 1
      Q = 0x77
    elseif Pads.check(pad, PAD_RIGHT) and D == 0 then
      T = 1
      D = 1
      Q = 0x77
    end
    if Pads.check(pad, PAD_TRIANGLE) and D == 0 then
      mcinfo0 = System.getMCInfo(0)
      mcinfo1 = System.getMCInfo(1)
      A = 0x20
    end

    if Q < 4 then QP = 4 end
    if Q > 0x77 then QP = -4 end
    Q = Q+QP
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end


  end
  Screen.clear()
  return T
end

function expertINSTprompt()
  local FINAL = 0
  local T = 0
  local D = 15
  local A = 0x40
  --[[
    JAP_ROM_100, JAP_ROM_101, JAP_ROM_120, JAP_STANDARD,
    USA_ROM_110, USA_ROM_120, USA_STANDARD,
    EUR_ROM_120, EUR_STANDARD,
    CHN_STANDARD,]]
  local UPDT = { }
  UPDT["x"] = true
  local UPDTT = { }
  UPDTT[0] = LNG_SUC0
  UPDTT[1] = LNG_SUC1
  UPDTT[2] = LNG_SUC2
  UPDTT[3] = LNG_SUC3
  UPDTT[4] = LNG_SUC4
  UPDTT[5] = LNG_SUC5
  UPDTT[6] = LNG_SUC6
  UPDTT[7] = LNG_SUC7
  UPDTT[8] = LNG_SUC8
  UPDTT[9] = LNG_SUC9
  for i=0,10 do
    UPDT[i] = 0
  end
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    Font.ftPrint(font, 320, 20,  8, 630, 32, LNG_EXPERTINST_PROMPT)
    Font.ftPrint(font, 310, 50,  0, 630, 16, LNG_REGS0, Color.new(250, 250, 250, 0x80-A))
    Font.ftPrint(font, 310, 150, 0, 630, 16, LNG_REGS1, Color.new(250, 250, 250, 0x80))
    Font.ftPrint(font, 310, 230, 0, 630, 16, LNG_REGS2, Color.new(250, 250, 250, 0x80-A))
    Font.ftPrint(font, 310, 290, 0, 630, 16, LNG_REGS3, Color.new(250, 250, 250, 0x80-A))
    Font.ftPrint(font, 20, 340, 0, 600, 32, UPDTT[T], Color.new(250, 250, 250, 0x80-A))
    if T == JAP_ROM_100 then
      Font.ftPrint(font, 321, 70, 0, 400, 16, "osdsys.elf", Color.new(200^(UPDT[0]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 70, 0, 400, 16, "osdsys.elf", Color.new(200^(UPDT[0]+1), 0xde, 0xff, 0x50-A))
    end
    if T == JAP_ROM_101 then
      Font.ftPrint(font, 321, 90, 0, 400, 16, "osd110.elf", Color.new(200^(UPDT[1]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 90, 0, 400, 16, "osd110.elf", Color.new(200^(UPDT[1]+1), 0xde, 0xff, 0x50-A))
    end
    if T == JAP_ROM_120 then
      Font.ftPrint(font, 321, 110, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[2]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 110, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[2]+1), 0xde, 0xff, 0x50-A))
    end
    if T == JAP_STANDARD then
      Font.ftPrint(font, 321, 130, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[3]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 130, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[3]+1), 0xde, 0xff, 0x50-A))
    end
    if T == USA_ROM_110 then
      Font.ftPrint(font, 321, 170, 0, 400, 16, "osd120.elf", Color.new(200^(UPDT[4]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 170, 0, 400, 16, "osd120.elf", Color.new(200^(UPDT[4]+1), 0xde, 0xff, 0x50-A))
    end
    if T == USA_ROM_120 then
      Font.ftPrint(font, 321, 190, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[5]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 190, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[5]+1), 0xde, 0xff, 0x50-A))
    end
    if T == USA_STANDARD then
      Font.ftPrint(font, 321, 210, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[6]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 210, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[6]+1), 0xde, 0xff, 0x50-A))
    end
    if T == EUR_ROM_120 then
      Font.ftPrint(font, 321, 250, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[7]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 250, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[7]+1), 0xde, 0xff, 0x50-A))
    end
    if T == EUR_STANDARD then
      Font.ftPrint(font, 321, 270, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[8]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 270, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[8]+1), 0xde, 0xff, 0x50-A))
    end
    if T == CHN_STANDARD then
      Font.ftPrint(font, 321, 310, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[9]+1), 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 310, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[9]+1), 0xde, 0xff, 0x50-A))
    end
    if A > 0 then A=A-1 end
    promptkeys(1,LNG_CT0,1,LNG_CT1,1,LNG_CT3, A)
    Screen.flip()
    local pad = Pads.get()
    if UPDT[0] == 1 or UPDT[1] == 1 and UPDT[2] == 0 then
      UPDT[2] = 1
    end

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      D = 1
      if UPDT[T] == 1 then UPDT[T] = 0 else UPDT[T] = 1 end
      if T == 2 and UPDT[2] == 0 then
        UPDT[0] =0
        UPDT[1] =0
      end
    end

    if Pads.check(pad, PAD_TRIANGLE) and D == 0 then
      D = 1
      break
    end

    if Pads.check(pad, PAD_CIRCLE) and D == 0 then
      UPDT["x"] = false
      D = 1
      break
    end

    pad = Pads.get()
    if Pads.check(pad, PAD_UP) and D == 0 then
      T = T-1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then
      T = T+1
      D = 1
    end
    if D > 0 then D = D+1 end
    if D > 15 then D = 0 end
    if T < JAP_ROM_100 then T = CHN_STANDARD end
    if T > CHN_STANDARD then T = JAP_ROM_100 end

  end
  Screen.clear()
  return UPDT
end

function AdvancedINSTprompt()
  local T = 1
  local D = 15
  local A = 0x80
  local PROMTPS = {
    LNG_DESC_CROSS_MODEL,
    LNG_DESC_CROSS_REGION,
    LNG_DESC_PSXDESR
  }
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 448.0)
    ORBMAN(0x80)
    --Font.ftPrint(font, 150, 20,  0, 630, 32, LNG_IMPMP0, Color.new(220, 220, 220, 0x80-A))

    if T == 1 then
      Font.ftPrint(font, 321, 150, 0, 630, 16, LNG_AI_CROSS_MODEL, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 150, 0, 630, 16, LNG_AI_CROSS_MODEL, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 2 then
      Font.ftPrint(font, 321, 190, 0, 630, 16, LNG_AI_CROSS_REGION, Color.new(0, 0xde, 0xff, 0x80-A)) else
      Font.ftPrint(font, 320, 190, 0, 630, 16, LNG_AI_CROSS_REGION, Color.new(200, 200, 200, 0x80-A))
    end
    if T == 3 then
      Font.ftPrint(font, 321 , 230, 0, 630, 16, "PSX DESR", Color.new(0, 0xde, 0xff, 0x80-A)) elseif IS_PSX == 1 then
      Font.ftPrint(font, 320 , 230, 0, 630, 16, "PSX DESR", Color.new(100, 100, 100, 0x80-A)) else -- make the PSX option grey if runner machine is PSX
      Font.ftPrint(font, 320 , 230, 0, 630, 16, "PSX DESR", Color.new(200, 200, 200, 0x80-A))
    end

    Font.ftPrint(font, 80 , 350, 0, 600, 32, PROMTPS[T], Color.new(128, 128, 128, 0x80-A))
    promptkeys(1,LNG_CT0, 1, LNG_CT1,0, 0, A)
    if A > 0 then A=A-1 end
    Screen.flip()
    local pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      if T == 3 and IS_PSX == 1 then
        --user requested a PSX install on a PSX, senseless, normal install will already do the job
      else
        D = 1
        Screen.clear()
        break
      end
    end

    if Pads.check(pad, PAD_CIRCLE) and D == 0 then
      T = 0
      break
    end

    if Pads.check(pad, PAD_UP) and D == 0 then
      T = T-1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then
      T = T+1
      D = 1
    end
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if T < 1 then T = 3 end
    if T > 3 then T = 1 end
  end
  return T
end

function PreAdvancedINSTstep(INSTMODE)
  local UPDT = { }
  UPDT["x"] = true
  for i=0,10 do
    UPDT[i] = 0
  end
  if INSTMODE == 1 then
    if REGION == 0 then
      for i=0,3 do
        UPDT[i] = 1
      end
    elseif REGION == 1 or REGION == 2 then
      for i=4,6 do
        UPDT[i] = 1
      end
    elseif REGION == 3 then
      UPDT[7] = 1
      UPDT[8] = 1
    elseif REGION == 4 then
      UPDT[9] = 1
    end
  elseif INSTMODE == 2 then
    for i=0,9 do
      UPDT[i] = 1
    end
  elseif INSTMODE == 3 then
    UPDT[10] = 1
  else
    UPDT["x"] = false
  end
  return UPDT
end

function secrerr(RET)
  local A = 0x80
  local Q = 0x7f
  local QIN = 1
  local pad = 0
  while A > 0 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, A))
    A = A-1
    Screen.flip()
  end
  A = 0x80
  while true do
    Screen.clear()
    if RET == 1 then
      Graphics.drawScaleImage(BGSCS, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
      ORBMANex(GREENCURSOR, 0x80-Q-1, 180, 180, 80+Q)
    else
      Graphics.drawScaleImage(BGERR, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
      ORBMANex(REDCURSOR, 0x80-Q-1, 180, 180, 80+Q)
    end
    if Q < 0x20 then
      pad = Pads.get()
      if A > 0 then A = A-1 end

      promptkeys(1, LNG_CONTINUE, 0, 0, 0, 0, A)
      if RET ~= 1 then
        Font.ftPrint(font, 320, 40,  8, 630, 64, string.format(LNG_INSTERR, RET), Color.new(0x80, 0x80, 0x80, 0x80-A))
      else
        Font.ftPrint(font, 320, 40,  8, 630, 64, LNG_INSTPMPT1, Color.new(0x80, 0x80, 0x80, 0x80-A))
      end
      if RET == (-5) then
        Font.ftPrint(font, 320, 60,  8, 630, 64, LNG_EIO, Color.new(0x80, 0x80, 0x80, 0x80-A))
      elseif RET == (-22) then
        Font.ftPrint(font, 320, 60,  8, 630, 64, LNG_SECRMANERR, Color.new(0x80, 0x80, 0x80, 0x80-A))
      elseif RET == (-12) then
        Font.ftPrint(font, 320, 60,  8, 630, 64, LNG_ENOMEM, Color.new(0x80, 0x80, 0x80, 0x80-A))
      elseif RET == (-201) then
        Font.ftPrint(font, 320, 60,  8, 630, 64, LNG_SOURCE_KELF_GONE, Color.new(0x80, 0x80, 0x80, 0x80-A))
      elseif RET ~= 1 then -- only write unknown error if retcode is not a success
        Font.ftPrint(font, 320, 60,  8, 630, 64, LNG_EUNKNOWN, Color.new(0x80, 0x80, 0x80, 0x80-A))
      end
      
      if Pads.check(pad, PAD_CROSS) and A == 0 then
        QIN = -1
        Q = 1
      end
    end
    if Q > 0 and Q < 0x80 then Q=Q-QIN end
    if Q > 0x7f then break end
    Screen.flip()
  end
  OrbIntro(1)
end

function WarnOfShittyFMCBInst()
  local A = 0x80
  local AIN = -1
  local Q = 0x7f
  local QIN = 1
  local pad = 0
  while A > 0 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, A))
    A = A-1
    Screen.flip()
  end
  A = 0x80
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BGERR, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    ORBMANex(REDCURSOR, 0x80-Q-1, 180, 180, 80+Q)
    Font.ftPrint(font, 320,  60,  8, 630, 64, LNG_WARNING, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    Font.ftPrint(font, 320,  80,  8, 630, 64, LNG_FMCBINST_CRAP0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    Font.ftPrint(font, 320, 120,  8, 630, 64, LNG_FMCBINST_CRAP1, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    Font.ftPrint(font, 320, 190,  8, 630, 64, LNG_FMCBINST_CRAP2, Color.new(0x80, 0x80, A, 0x80-Q))

    if Q < 10 then
      pad = Pads.get()
    end

    if Pads.check(pad, PAD_CROSS) then
      QIN = -1
      Q = 1
    end

    if Q ~= 0 then Q = Q-QIN end

    A=A+AIN
    if A == 0x40 then AIN = -1 end
    if A == 0 then AIN = 1 end
    if Q > 0x7f then break end
    Screen.flip()
  end
  OrbIntro(1)
end

function Ask2WipeSysUpdateDirs(NEEDS_JAP, NEEDS_USA, NEEDS_EUR, NEEDS_CHN, NEEDS_CURRENT, port)
  local A = 0x80
  local Q = 0x7f
  local QIN = 1
  local pad = 0
  local SHOULD_WIPE = false
  local JAP_FOLD = string.format("mc%d:/%s", port, "BIEXEC-SYSTEM")
  local USA_FOLD = string.format("mc%d:/%s", port, "BAEXEC-SYSTEM")
  local EUR_FOLD = string.format("mc%d:/%s", port, "BEEXEC-SYSTEM")
  local CHN_FOLD = string.format("mc%d:/%s", port, "BCEXEC-SYSTEM")
  while A > 0 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, A))
    A = A-1
    Screen.flip()
  end
  A = 0x80
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BGERR, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    ORBMANex(REDCURSOR, 0x80-Q-1, 180, 180, 80+Q)

    if Q < 0x20 then
      pad = Pads.get()
      if A > 0 then A = A-1 end

      promptkeys(1, LNG_YES, 1, LNG_NO, 0, 0, A)
      Font.ftPrint(font, 50, 40,  0, 630, 64, LNG_WARNING, Color.new(0x80, 0x80, 0x80, 0x80-A))
      Font.ftPrint(font, 50, 100, 0, 630, 64, LNG_WARN_CONFLICT0, Color.new(0x80, 0x80, 0x80, 0x80-A))
      Font.ftPrint(font, 50, 160, 0, 630, 64, LNG_WARN_CONFLICT1, Color.new(0x80, 0x80, 0x80, 0x80-A))
      Font.ftPrint(font, 50, 260, 0, 630, 64, LNG_WARN_CONFLICT2, Color.new(0x70, 0x70, 0x70, 0x80-A))


      if Pads.check(pad, PAD_CROSS) then
        QIN = -1
        Q = 1
        SHOULD_WIPE = true
      end
      if Pads.check(pad, PAD_CIRCLE) then
        QIN = -1
        Q = 1
      end
    end
    if Q > 0 and Q < 0x80 then Q=Q-QIN end
    if Q > 0x7f then break end
    Screen.flip()
  end
  A = 0
  while A < 0x80 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, A))
    A = A+1
    Screen.flip()
  end

  if SHOULD_WIPE then
    if NEEDS_USA then System.WipeDirectory(USA_FOLD) end
    if NEEDS_CHN then System.WipeDirectory(CHN_FOLD) end
    if NEEDS_JAP then System.WipeDirectory(JAP_FOLD) end
    if NEEDS_EUR then System.WipeDirectory(EUR_FOLD) end
    if NEEDS_CURRENT then System.WipeDirectory(string.format("mc%d:/%s", port, KELFBinder.getsysupdatefolder())) end
  end
end

function WarnIncompatibleMachine()
  local A = 0x80
  local Q = 0x7f
  local QIN = 1
  local pad = 0
  while A > 0 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, A))
    A = A-1
    Screen.flip()
  end
  A = 0x80
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BGERR, 0.0, 0.0, 640.0, 480.0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    ORBMANex(REDCURSOR, 0x80-Q-1, 180, 180, 80+Q)

    pad = Pads.get()
    if A > 0 then A = A-1 end
    promptkeys(1, LNG_CONTINUE, 0, 0, 0, 0, Q)
    Font.ftPrint(font, 320, 40,  8, 630, 64, LNG_COMPAT0, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    Font.ftPrint(font, 320, 100, 8, 630, 64, LNG_COMPAT1, Color.new(0x80, 0x80, 0x80, 0x80-Q))
    if Pads.check(pad, PAD_CROSS) then
      QIN = -1
      Q = 1
    end
    if Q > 0 and Q < 0x80 then Q=Q-QIN end
    if Q > 0x7f then break end
    Screen.flip()
  end
end

function performExpertINST(port, slot, UPDT)
  Screen.clear()
  Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
  Screen.flip()

  if System.doesFileExist(string.format("mc%d:SYS-CONF/FMCBUINST.dat", port)) or
     System.doesFileExist(string.format("mc%u:SYS-CONF/uninstall.dat", port)) then WarnIncompatibleMachine() return end

  local FLAGS = 0
  local SIZE_NEED = 0
  local FD = System.openFile(SYSUPDATE_MAIN, FREAD)
  local SYSUPDATE_SIZE = System.sizeFile(FD)
  System.closeFile(FD)
  local NEEDS_JAP = false
  local NEEDS_USA = false
  local NEEDS_EUR = false
  local NEEDS_CHN = false
  local FOLDS_CONFLICT = false
  local JAP_FOLD = string.format("mc%d:/%s", port, "BIEXEC-SYSTEM")
  local USA_FOLD = string.format("mc%d:/%s", port, "BAEXEC-SYSTEM")
  local EUR_FOLD = string.format("mc%d:/%s", port, "BEEXEC-SYSTEM")
  local CHN_FOLD = string.format("mc%d:/%s", port, "BCEXEC-SYSTEM")

  if UPDT[0] == 1 or UPDT[1] == 1 or UPDT[2] == 1 or UPDT[3] == 1 then NEEDS_JAP = true end
  if UPDT[4] == 1 or UPDT[5] == 1 or UPDT[6] == 1 then NEEDS_USA = true end
  if UPDT[7] == 1 or UPDT[8] == 1 then NEEDS_EUR = true end
  if UPDT[9] == 1 then NEEDS_CHN = true end

  if NEEDS_JAP and System.doesDirExist(JAP_FOLD) then FOLDS_CONFLICT = true end
  if NEEDS_USA and System.doesDirExist(USA_FOLD) then FOLDS_CONFLICT = true end
  if NEEDS_EUR and System.doesDirExist(EUR_FOLD) then FOLDS_CONFLICT = true end
  if NEEDS_CHN and System.doesDirExist(CHN_FOLD) then FOLDS_CONFLICT = true end
  for i=0,9 do
    if UPDT[i] == 1 then
      FLAGS = FLAGS | (1 << (i+1))
      if i == 0 or 1 == 1 then SIZE_NEED = SIZE_NEED + 7000 else
      SIZE_NEED = SIZE_NEED + SYSUPDATE_SIZE end
    end
  end
  if FOLDS_CONFLICT then Ask2WipeSysUpdateDirs(NEEDS_JAP, NEEDS_USA, NEEDS_EUR, NEEDS_CHN, false, port) end
  Screen.clear()
  Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
  Font.ftPrint(font, 320, 20,  8, 400, 64, LNG_INSTALLING)
  Screen.flip()

  if NEEDS_JAP then
    System.createDirectory(JAP_FOLD)
    KELFBinder.setSysUpdateFoldProps(port, slot, "BIEXEC-SYSTEM")
    System.copyFile("INSTALL/ASSETS/JAP.sys", string.format("mc%d:/%s/icon.sys", port, "BIEXEC-SYSTEM"))
    System.copyFile("INSTALL/ASSETS/PS2BBL.icn", string.format("mc%d:/%s/PS2BBL.icn", port, "BIEXEC-SYSTEM"))
  end
  if NEEDS_USA then
    System.createDirectory(string.format("mc%d:/%s", port, "BAEXEC-SYSTEM"))
    KELFBinder.setSysUpdateFoldProps(port, slot, "BAEXEC-SYSTEM")
    System.copyFile("INSTALL/ASSETS/USA.sys", string.format("mc%d:/%s/icon.sys", port, "BAEXEC-SYSTEM"))
    System.copyFile("INSTALL/ASSETS/PS2BBL.icn", string.format("mc%d:/%s/PS2BBL.icn", port, "BAEXEC-SYSTEM"))
  end
  if NEEDS_EUR then
    System.createDirectory(string.format("mc%d:/%s", port, "BEEXEC-SYSTEM"))
    KELFBinder.setSysUpdateFoldProps(port, slot, "BEEXEC-SYSTEM")
    System.copyFile("INSTALL/ASSETS/EUR.sys", string.format("mc%d:/%s/icon.sys", port, "BEEXEC-SYSTEM"))
    System.copyFile("INSTALL/ASSETS/PS2BBL.icn", string.format("mc%d:/%s/PS2BBL.icn", port, "BEEXEC-SYSTEM"))
  end
  if NEEDS_CHN then
    System.createDirectory(string.format("mc%d:/%s", port, "BCEXEC-SYSTEM"))
    KELFBinder.setSysUpdateFoldProps(port, slot, "BCEXEC-SYSTEM")
    System.copyFile("INSTALL/ASSETS/CHN.sys", string.format("mc%d:/%s/icon.sys", port, "BCEXEC-SYSTEM"))
    System.copyFile("INSTALL/ASSETS/PS2BBL.icn", string.format("mc%d:/%s/PS2BBL.icn", port, "BCEXEC-SYSTEM"))
  end

  if UPDT[0] == 1 then
    RET = Secrman.downloadfile(port, slot, KERNEL_PATCH_100, string.format("mc%d:/BIEXEC-SYSTEM/osdsys.elf", port), 0) 
    if RET < 0 then secrerr(RET) end
  end
  if UPDT[1] == 1 then
    RET = Secrman.downloadfile(port, slot, KERNEL_PATCH_101, string.format("mc%d:/BIEXEC-SYSTEM/osd110.elf", port), 0) 
    if RET < 0 then secrerr(RET) end
  end

  SYSUPDATEPATH = KELFBinder.calculateSysUpdatePath()
  local RET = Secrman.downloadfile(port, slot, SYSUPDATE_MAIN, string.format("mc%d:/%s", port, SYSUPDATEPATH), FLAGS)
  System.sleep(2)
  secrerr(RET)
end

function Ask2quit()
  Q = 1
  QQ = 1
  while true do
    if Q > 100 then QQ = -1 end
    if Q < 1  then QQ = 1 end
    Q = Q+QQ
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    Font.ftPrint(font, 320, 40 , 8, 630, 16, LNG_WANNAQUIT)
    promptkeys(1,LNG_YES,1,LNG_NO, 1,LNG_RWLE, 0)
    ORBMAN(0x80-Q)
    local pad = Pads.get()
    if Pads.check(pad, PAD_CROSS) then System.exitToBrowser() end
    if Pads.check(pad, PAD_CIRCLE) then break end
    if Pads.check(pad, PAD_TRIANGLE) then if System.doesFileExist("INSTALL/CORE/BACKDOOR.ELF") then System.loadELF("INSTALL/CORE/BACKDOOR.ELF") end end
    Screen.flip()
  end
end

function SystemInfo()
  local D = 15
  local A = 0x50
  local UPDTPATH = KELFBinder.calculateSysUpdatePath()
  local COMPATIBLE_WITH_UPDATES = LNG_YES
  if ROMVERN > 220 then COMPATIBLE_WITH_UPDATES = LNG_NO end
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    Font.ftPrint(font, 320, 20, 8, 630, 32, LNG_SYSTEMINFO, Color.new(220, 220, 220, 0x80-A))

    Font.ftPrint(font, 50, 60,  0, 630, 32, string.format("ROMVER = [%s]", ROMVER), Color.new(220, 220, 220, 0x80-A))
    Font.ftPrint(font, 50, 80,  0, 630, 32, string.format(LNG_CONSOLE_MODEL, KELFBinder.getConsoleModel()), Color.new(220, 220, 220, 0x80-A))
    Font.ftPrint(font, 50, 100,  0, 630, 32, string.format(LNG_IS_COMPATIBLE, COMPATIBLE_WITH_UPDATES), Color.new(220, 220, 220, 0x80-A))
    if ROMVERN < 221 then
    Font.ftPrint(font, 50, 120,  0, 630, 32, string.format(LNG_SUPATH, UPDTPATH), Color.new(220, 220, 220, 0x80-A)) end

    promptkeys(0,LNG_CT0, 1, LNG_CT4,0, 0, A)
    if A > 0 then A=A-1 end
    Screen.flip()
    local pad = Pads.get()
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if Pads.check(pad, PAD_CIRCLE) and D == 0 then break end
  end
end

function Credits()
  local pad = 0
  local Q = 1
  local QINC = 1
  while Q > 0 do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
    ORBMAN(0x80)
    Graphics.drawScaleImage(LOGO, 192.0, 40.0, 256, 128, Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 200 , 8, 630, 16, LNG_CRDTS0, Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 220 , 8, 630, 16, LNG_CRDTS1, Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 240 , 8, 630, 16, LNG_CRDTS2, Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 260 , 8, 630, 16, LNG_CRDTS3, Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 300 , 8, 630, 16, LNG_CRDTS5, Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 320 , 8, 630, 16, "krHACKen, uyjulian, HWNJ", Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 340 , 8, 630, 16, "sp193, Leo Oliveira", Color.new(128, 128, 128, Q))
    Font.ftPrint(font, 320, 380 , 8, 630, 16, LNG_CRDTS4, Color.new(240, 240, 240, Q))
    Screen.flip()
    if (Q ~= 0x80) then Q=Q+QINC end
    pad = Pads.get()
    if Pads.check(pad, PAD_CROSS) then
      QINC = -1
      Q = (0x80-1)
    end
  end
end

-- SCRIPT BEHAVIOUR BEGINS --
--SystemInfo()

greeting()
if ROMVERN > 220 then WarnIncompatibleMachine() end
OrbIntro(0)
while true do
  local TT = MainMenu()
  WaitWithORBS(50)
  -- SYSTEM UPDATE
  if (TT == 1) then
    local TTT = Installmodepicker()
    WaitWithORBS(50)
    if TTT == 1 then
      local port = MemcardPickup()
      if port ~= -1 then
        FadeWIthORBS()
        NormalInstall(port, 0)
        WaitWithORBS(50)
      end
    elseif TTT == 2 then
      local memcard = 0
      local LOL = AdvancedINSTprompt()
      local UPDT = { }
      UPDT = PreAdvancedINSTstep(LOL)
      if UPDT["x"] == true then
        memcard = MemcardPickup()
        if UPDT[10] == 1 then -- IF PSX mode was selected
          IS_PSX = 1 -- simulate runner console is a PSX to reduce code duplication
          NormalInstall(memcard, 0)
          IS_PSX = 0
        else
          performExpertINST(memcard, 0, UPDT)
        end
      end
    elseif TTT == 3 then
      local port = MemcardPickup()
      if port ~= -1 then
        WaitWithORBS(30)
        local UPDT = expertINSTprompt()
        if UPDT["x"] == true then
          FadeWIthORBS()
          performExpertINST(port, 0, UPDT)
        end
      end
    end
  elseif TT == 2 then -- DVDPLAYER
    local port = MemcardPickup()
    WaitWithORBS(20)
    if (port >= 0) then
      local target_region = DVDPlayerRegionPicker()
      if (target_region >= 0 ) then
        FadeWIthORBS()
        DVDPlayerINST(port, 0, target_region)
      end
    end
  elseif TT == 3 then
    SystemInfo()
  elseif TT == 4 then
    Credits()
  elseif TT == 5 then
    Ask2quit()
  end
  -- SYSTEM UPDATE
end
Screen.clear(Color.new(0xff, 0, 0, 0))
while true do end


