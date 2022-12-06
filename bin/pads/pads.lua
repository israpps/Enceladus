

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
-- DVDPLAYERUPDATE = "INSTALL/KELF/DVDPLAYER.XLF"
SYSUPDATE_MAIN = "INSTALL/KELF/SYSTEM.XLF"
KERNEL_PATCH_100 = "INSTALL/KELF/OSDSYS.KERNEL"
KERNEL_PATCH_101 = "INSTALL/KELF/OSD110.KERNEL"

local circle = Graphics.loadImage("pads/circle.png")
local cross = Graphics.loadImage("pads/cross.png")
--local square = Graphics.loadImage("pads/square.png")
local triangle = Graphics.loadImage("pads/triangle.png")

--[[local up = Graphics.loadImage("pads/up.png")
local down = Graphics.loadImage("pads/down.png")
local left = Graphics.loadImage("pads/left.png")
local right = Graphics.loadImage("pads/right.png")]]
local MC = Graphics.loadImage("pads/MC.png")
local LOGO = Graphics.loadImage("pads/logo.png")
local BG = Graphics.loadImage("pads/background.png")

local REGION = KELFBinder.getsystemregion()
--local REGIONSTR = KELFBinder.getsystemregionString(REGION)

Language = KELFBinder.getsystemLanguage() 
if Language == 0 then
  if System.doesFileExist("lang/japanese.lua") then dofile("lang/japanese.lua") end
elseif Language == 2 then if System.doesFileExist("lang/french.lua") then dofile("lang/french.lua") end
elseif Language == 3 then if System.doesFileExist("lang/spanish.lua") then dofile("lang/spanish.lua") end
elseif Language == 4 then if System.doesFileExist("lang/german.lua") then dofile("lang/german.lua") end
elseif Language == 5 then if System.doesFileExist("lang/italian.lua") then dofile("lang/italian.lua") end
elseif Language == 6 then if System.doesFileExist("lang/dutch.lua") then dofile("lang/dutch.lua") end
elseif Language == 7 then if System.doesFileExist("lang/portuguese.lua") then dofile("lang/portuguese.lua") end
else
end
function promptkeys(SELECT, ST, CANCEL, CT, REFRESH, RT, ALFA)

  if SELECT == 1 then
    Graphics.drawImage(cross, 80.0, 400.0, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
    Font.ftPrint(font, 110 , 407, 0, 400, 16, ST, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
  end
  if CANCEL == 1 then
    Graphics.drawImage(circle, 170.0, 400.0, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
    Font.ftPrint(font, 200 , 407, 0, 400, 16, CT, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
  end
  if REFRESH == 1 then
    Graphics.drawImage(triangle, 260.0, 400.0, Color.new(0x80, 0x80, 0x80, 0x80-ALFA))
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
        Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0, Color.new(128, 128, 128, Q))
      else
        Graphics.drawScaleImage(BG, 0.0, 0.0, 640.0, 480.0)
      end
      Graphics.drawScaleImage(LOGO, 50.0, 50.0, 256.0, 128.0, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 20  , 8, 630, 16, "HELLO MOTHERFUCKER", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 40  , 8, 630, 16, "THIS IS NOT A PUBLIC-READY VERSION!", Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 320 , 8, 630, 16, LNG_CRDTS0, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 340 , 8, 630, 16, LNG_CRDTS1, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 360 , 8, 630, 16, LNG_CRDTS2, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 380 , 8, 630, 16, LNG_CRDTS3, Color.new(128, 128, 128, Q))
      Font.ftPrint(font, 320, 400 , 8, 630, 16, LNG_CRDTS4, Color.new(240, 240, 240, Q))
      Screen.flip()
    end
end

function MainMenu()
  local T = 1
  local D = 15
  local A = 0x50
  while true do
    Screen.clear()
    Font.ftPrint(font, 150, 20,  0, 630, 32, LNG_MM1, Color.new(220, 220, 220, 0x80-A))
    if T == 1 then
      Font.ftPrint(font, 100, 150, 0, 630, 16, LNG_MM2, Color.new(200, 200, 200, 0x80-A)) else
      Font.ftPrint(font, 100, 150, 0, 630, 16, LNG_MM2, Color.new(200, 200, 200, 0x50-A))
    end
    if T == 2 then
      Font.ftPrint(font, 100, 190, 0, 630, 16, LNG_MM3, Color.new(200, 200, 200, 0x80-A)) else
      Font.ftPrint(font, 100, 190, 0, 630, 16, LNG_MM3, Color.new(200, 200, 200, 0x50-A))
    end
    if T == 3 then
      Font.ftPrint(font, 100, 230, 0, 630, 16, LNG_MM4, Color.new(200, 200, 200, 0x80-A)) else
      Font.ftPrint(font, 100, 230, 0, 630, 16, LNG_MM4, Color.new(200, 200, 200, 0x50-A))
    end
    if T == 4 then
      Font.ftPrint(font, 100, 300, 0, 630, 16, LNG_MM5, Color.new(200, 200, 200, 0x80-A)) else
      Font.ftPrint(font, 100, 300, 0, 630, 16, LNG_MM5, Color.new(200, 200, 200, 0x50-A))
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
    if T < 1 then T = 4 end
    if T > 4 then T = 1 end

  end
  return T
end

function Installmodepicker()
  local T = 1
  local D = 15
  local A = 0x50
  local PROMTPS = {
    LNG_IMPP0,
    LNG_IMPP1,
    LNG_IMPP2
  }
  while true do
    Screen.clear()
    Font.ftPrint(font, 150, 20,  0, 630, 32, LNG_IMPMP0, Color.new(220, 220, 220, 0x80-A))

    if T == 1 then
      Font.ftPrint(font, 100, 150, 0, 630, 16, LNG_IMPMP1, Color.new(200, 200, 200, 0x80-A)) else
      Font.ftPrint(font, 100, 150, 0, 630, 16, LNG_IMPMP1, Color.new(200, 200, 200, 0x50-A))
    end
    if T == 2 then
      Font.ftPrint(font, 100, 190, 0, 630, 16, LNG_IMPMP2, Color.new(200, 200, 200, 0x80-A)) else
      Font.ftPrint(font, 100, 190, 0, 630, 16, LNG_IMPMP2, Color.new(200, 200, 200, 0x50-A))
    end
    if T == 3 then
      Font.ftPrint(font, 100 , 230, 0, 630, 16, LNG_IMPMP3, Color.new(200, 200, 200, 0x80-A)) else
      Font.ftPrint(font, 100 , 230, 0, 630, 16, LNG_IMPMP3, Color.new(200, 200, 200, 0x50-A))
    end
    
    Font.ftPrint(font, 80 , 350, 0, 600, 32, PROMTPS[T], Color.new(200, 200, 200, 0x50-A))
    promptkeys(1,LNG_CT0, 1, LNG_CT1,0, 0, A)
    if A > 0 then A=A-1 end
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
    if T < 1 then T = 3 end
    if T > 3 then T = 1 end

  end
  return T
end

function NormalInstall(port, slot)
  local ROMVERN = KELFBinder.getROMversion()
  local RET
  System.createDirectory(string.format("mc%d:/%s", port, KELFBinder.getsysupdatefolder()))
  KELFBinder.setSysUpdateFoldProps(port, slot, KELFBinder.getsysupdatefolder())
  SYSUPDATEPATH = KELFBinder.calculateSysUpdatePath()
  Screen.clear(Color.new(0, 0, 0))
  Font.ftPrint(font, 320, 20  , 8, 600, 64, string.format(LNG_INSTPMPT, SYSUPDATEPATH))
  Screen.flip()
  if (ROMVERN == 100) or (ROMVERN == 101) then -- PROTOKERNEL NEED TWO UPDATES TO FUNCTION
    Secrman.downloadfile(port, slot, SYSUPDATE_MAIN, string.format("mc%d:/%s", port, "BIEXEC-SYSTEM/osd130.elf")) -- SCPH-18000
    if (ROMVERN == 100) then
      RET = Secrman.downloadfile(port, slot, KERNEL_PATCH_100, string.format("mc%d:/%s", port, SYSUPDATEPATH))
      if RET < 0 then secrerr(RET) end
    else
      RET = Secrman.downloadfile(port, slot, KERNEL_PATCH_101, string.format("mc%d:/%s", port, SYSUPDATEPATH))
      if RET < 0 then secrerr(RET) end
    end
  else
    RET = Secrman.downloadfile(port, slot, SYSUPDATE_MAIN, string.format("mc%d:/%s", port, SYSUPDATEPATH))
    if RET < 0 then secrerr(RET) end
  end
  Screen.clear()
  Font.ftPrint(font, 320, 40,  8, 630, 64, LNG_INSTPMPT1)
  System.sleep(2)
  Screen.flip()
end

function MemcardPickup()
  local T = 0
  local D = 15
  local Q = 0x77
  local QP = -4
  local A = 0x50
  local mcinfo0 = System.getMCInfo(0)
  local mcinfo1 = System.getMCInfo(1)
  while true do
    local HC = ((mcinfo0.type == 2) or (mcinfo1.type == 2))
    Screen.clear()
    Font.ftPrint(font, 320, 20,  8, 630, 32, LNG_MEMCARD0, Color.new(0x80, 0x80, 0x80, 0x80-A))
    if mcinfo0.type == 2 then
      Font.ftPrint(font, 80, 270,  0, 630, 32, string.format(LNG_MEMCARD1, 1, mcinfo0.freemem), Color.new(0x80, 0x80, 0x80, 0x80-A))
      if T == 0 then
        Graphics.drawImage(MC, 80.0, 150.0, Color.new(0x80, 0x80, 0x80, Q))
      else
        Graphics.drawImage(MC, 80.0, 150.0, Color.new(0x80, 0x80, 0x80, 0x80-A))
      end
    end
    if mcinfo1.type == 2 then
      Font.ftPrint(font, 360, 270,  0, 630, 32, string.format(LNG_MEMCARD1, 2, mcinfo1.freemem), Color.new(0x80, 0x80, 0x80, 0x80-A))
      if T == 1 then
        Graphics.drawImage(MC, 360.0, 150.0, Color.new(0x80, 0x80, 0x80, Q))
      else
        Graphics.drawImage(MC, 360.0, 150.0, Color.new(0x80, 0x80, 0x80, 0x80-A))
      end
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

    if Pads.check(pad, PAD_CIRCLE) and D == 0 then break end
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
    Font.ftPrint(font, 150, 20,  0, 630, 32, string.format("Select system update executables %d %d %x",T,UPDT[T], FINAL))
    Font.ftPrint(font, 100, 50,  0, 630, 16, LNG_REGS0, Color.new(250, 250, 250, 0x80-A))
    Font.ftPrint(font, 100, 150, 0, 630, 16, LNG_REGS1, Color.new(250, 250, 250, 0x80))
    Font.ftPrint(font, 100, 230, 0, 630, 16, LNG_REGS2, Color.new(250, 250, 250, 0x80-A))
    Font.ftPrint(font, 100, 290, 0, 630, 16, LNG_REGS3, Color.new(250, 250, 250, 0x80-A))
    Font.ftPrint(font, 20, 340, 0, 600, 32, UPDTT[T], Color.new(250, 250, 250, 0x80-A))
    if T == JAP_ROM_100 then
      Font.ftPrint(font, 110, 70, 0, 400, 16, " osdsys.elf", Color.new(200^(UPDT[0]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 70, 0, 400, 16, "osdsys.elf", Color.new(200^(UPDT[0]+1), 200, 200, 0x50-A))
    end
    if T == JAP_ROM_101 then
      Font.ftPrint(font, 110, 90, 0, 400, 16, " osd110.elf", Color.new(200^(UPDT[1]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 90, 0, 400, 16, "osd110.elf", Color.new(200^(UPDT[1]+1), 200, 200, 0x50-A))
    end
    if T == JAP_ROM_120 then
      Font.ftPrint(font, 110, 110, 0, 400, 16, " osd130.elf", Color.new(200^(UPDT[2]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 110, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[2]+1), 200, 200, 0x50-A))
    end
    if T == JAP_STANDARD then
      Font.ftPrint(font, 110, 130, 0, 400, 16, " osdmain.elf", Color.new(200^(UPDT[3]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 130, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[3]+1), 200, 200, 0x50-A))
    end
    if T == USA_ROM_110 then
      Font.ftPrint(font, 110, 170, 0, 400, 16, " osd120.elf", Color.new(200^(UPDT[4]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 170, 0, 400, 16, "osd120.elf", Color.new(200^(UPDT[4]+1), 200, 200, 0x50-A))
    end
    if T == USA_ROM_120 then
      Font.ftPrint(font, 110, 190, 0, 400, 16, " osd130.elf", Color.new(200^(UPDT[5]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 190, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[5]+1), 200, 200, 0x50-A))
    end
    if T == USA_STANDARD then
      Font.ftPrint(font, 110, 210, 0, 400, 16, " osdmain.elf", Color.new(200^(UPDT[6]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 210, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[6]+1), 200, 200, 0x50-A))
    end
    if T == EUR_ROM_120 then
      Font.ftPrint(font, 110, 250, 0, 400, 16, " osd130.elf", Color.new(200^(UPDT[7]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 250, 0, 400, 16, "osd130.elf", Color.new(200^(UPDT[7]+1), 200, 200, 0x50-A))
    end
    if T == EUR_STANDARD then
      Font.ftPrint(font, 110, 270, 0, 400, 16, " osdmain.elf", Color.new(200^(UPDT[8]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 270, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[8]+1), 200, 200, 0x50-A))
    end
    if T == CHN_STANDARD then
      Font.ftPrint(font, 110, 310, 0, 400, 16, " osdmain.elf", Color.new(200^(UPDT[9]+1), 200, 200, 0x80-A)) else
      Font.ftPrint(font, 110, 310, 0, 400, 16, "osdmain.elf", Color.new(200^(UPDT[9]+1), 200, 200, 0x50-A))
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

function secrerr(RET)
  if RET < 0 then
    Screen.clear(Color.new(0xff, 00, 00))
    Font.ftPrint(font, 320, 40,  8, 630, 64, string.format(LNG_INSTERR, RET))
    if RET == -5 then
      Font.ftPrint(font, 320, 60,  8, 630, 64, LNG_EIO)
    elseif RET == -22 then
      Font.ftPrint(font, 320, 40,  8, 630, 64, LNG_SECRMANERR)
    elseif RET == -12 then
      Font.ftPrint(font, 320, 40,  8, 630, 64, LNG_ENOMEM)
    else
      Font.ftPrint(font, 320, 40,  8, 630, 64, LNG_EUNKNOWN)
    end
    while true do end
  end
end

function performExpertINST(port, slot, UPDT)
  Screen.clear()
  local FLAGS = 0
  for i=0,9 do
    if UPDT[i] == 1 then
      FLAGS = FLAGS | (1 << (i+1))
    end
  end
  Font.ftPrint(font, 150, 630,  0, 400, 64, LNG_INSTALLING)
  Screen.flip()
  if UPDT[0] == 1 or UPDT[1] == 1 or UPDT[2] == 1 or UPDT[3] == 1 then
    System.createDirectory(string.format("mc%d:/%s", port, "BIEXEC-SYSTEM"))
    KELFBinder.setSysUpdateFoldProps(port, slot, "BIEXEC-SYSTEM")
  end
  if UPDT[4] == 1 or UPDT[5] == 1 or UPDT[6] == 1 then
    System.createDirectory(string.format("mc%d:/%s", port, "BAEXEC-SYSTEM"))
    KELFBinder.setSysUpdateFoldProps(port, slot, "BAEXEC-SYSTEM")
  end
  if UPDT[7] == 1 or UPDT[8] == 1 then
    System.createDirectory(string.format("mc%d:/%s", port, "BEEXEC-SYSTEM"))
    KELFBinder.setSysUpdateFoldProps(port, slot, "BEEXEC-SYSTEM")
  end
  if UPDT[9] == 1 then
    System.createDirectory(string.format("mc%d:/%s", port, "BCEXEC-SYSTEM"))
    KELFBinder.setSysUpdateFoldProps(port, slot, "BCEXEC-SYSTEM")
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
  if RET < 0 then secrerr(RET) end
  Screen.clear()
  Font.ftPrint(font, 320, 40,  8, 630, 64, LNG_INSTFINISH)
  System.sleep(2)
  Screen.flip()
end

function Ask2quit()
  Screen.clear()
  Font.ftPrint(font, 320, 240  , 8, 630, 16, LNG_WANNAQUIT)
  promptkeys(1,LNG_YES,1,LNG_NO, 1,LNG_RWLE, 0)
  Screen.flip()
  while true do
    
    local pad = Pads.get()
    if Pads.check(pad, PAD_CROSS) then System.exitToBrowser() end
    if Pads.check(pad, PAD_CIRCLE) then break end
    if Pads.check(pad, PAD_TRIANGLE) then System.loadELF("INSTALL/CORE/BACKDOOR.ELF") end
  end
end

function SystemInfo()
  local D = 15
  local A = 0x50
  local UPDTPATH = KELFBinder.calculateSysUpdatePath()
  while true do
    Screen.clear()
    Font.ftPrint(font, 320, 20, 8, 630, 32, LNG_SYSTEMINFO, Color.new(220, 220, 220, 0x80-A))
    Font.ftPrint(font, 50, 60,  0, 630, 32, string.format("ROMVER = [%s]", ROMVER), Color.new(220, 220, 220, 0x80-A))
    Font.ftPrint(font, 50, 80,  0, 630, 32, string.format(LNG_SUPATH, UPDTPATH), Color.new(220, 220, 220, 0x80-A))

    promptkeys(0,LNG_CT0, 1, LNG_CT4,0, 0, A)
    if A > 0 then A=A-1 end
    Screen.flip()
    local pad = Pads.get()
    if D > 0 then D = D+1 end
    if D > 10 then D = 0 end
    if Pads.check(pad, PAD_CIRCLE) and D == 0 then break end
  end
end
-- SCRIPT BEHAVIOUR BEGINS --
--SystemInfo()
greeting()
while true do
local TT = MainMenu()
System.sleep(1)
-- SYSTEM UPDATE
if (TT == 1) then
  local TTT = Installmodepicker()
  System.sleep(1)
  if TTT == 1 then
    local port = MemcardPickup()
    NormalInstall(port, 0)
    System.sleep(1)
  elseif TTT == 3 then
    local port = MemcardPickup()
    local UPDT = expertINSTprompt()
    if UPDT["x"] == true then
      performExpertINST(port, 0, UPDT)
    end
    System.sleep(1)
  end
elseif TT == 2 then -- DVDPLAYER

elseif TT == 3 then
  SystemInfo()
elseif TT == 4 then
  Ask2quit()
  System.sleep(1)
end
-- SYSTEM UPDATE
end
Screen.clear()
while true do end


