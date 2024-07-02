--[[
NEUTRINO Launcher by El_isra                                                         
LICENSE: GNU GPL v3
--]]
LOG("> Registering extra diags")

local cur = 0
local lding = 0
function ModLoadUI()
  Font.ftPrint(BFONT, 40, 40, 0, 128, 64, "Driver Manager")
  Graphics.drawRect(0, 60, UI.SCR.X, 2, WHITE)
  for i = 0, BDM.DEVA, 1 do
    local I = IMG.dev_usb
    local C = i == cur and 127 or 100
    if i == BDM.DEVS.HDD then I = IMG.dev_ide
    elseif i == BDM.DEVS.MX4SIO then I = IMG.dev_mx4sio
    elseif i == BDM.DEVS.ILINK then I = IMG.dev_ilink
    elseif i == BDM.DEVS.UDPBD then I = IMG.dev_udpbd end
    if Main.Devs[i+1] == IOP.LDFAIL then
      Font.ftPrint(BFONT, 180, 70+16+(70*i), 0, 500, 64, ("Driver startup error: '%s'  id:%d  ret:%d\n\"%s\""):format(
        BDM.DEVSTAT[i].CUL, BDM.DEVSTAT[i].ID, BDM.DEVSTAT[i].RET, IOP.GetModuleErr(BDM.DEVSTAT[i].ID, BDM.DEVSTAT[i].RET)), Color.new(128, 128, 128, C))
    elseif Main.Devs[i+1] == IOP.NLOAD then
      C = C-50
    end
    local col = Color.new(128, 128, 128, C)
    if Main.Devs[i+1] == IOP.LDFAIL then col = Color.new(200, 0, 0, C)
    elseif Main.Devs[i+1] == IOP.LOADED then col = Color.new(0, 128, 0, C)
    end
    Font.ftPrint(BFONT, 180, 70+(70*i), 0, 128, 64, BDM.DevAlias[i], col)
    Graphics.drawImage(I, 100, 70+(70*i), col)
  end
  if lding > 0 then
      Graphics.drawRect(0, UI.SCR.Y_MID-16, UI.SCR.X, 48, Color.new(0,128,128,60))
      Font.ftPrint(BFONT, UI.SCR.X_MID, UI.SCR.Y_MID, 8, 400, 64, "LOADING DRIVER", Color.new(255,255,255))
    if lding == 1 then
      lding = 2
    elseif lding == 2 then
      Main.LoadModule(cur)
      lding = 0
    end
  end
  Font.ftPrint(SFONT, 100, UI.SCR.Y-50, 0, 400, 64, "X: Load Driver   O: Go Back")
  if PADListen() then
    if Pads.check(GPAD, PAD_UP)  then cur = CLAMP(cur-1, 0, BDM.DEVA) end
    if Pads.check(GPAD, PAD_DOWN) then cur = CLAMP(cur+1, 0, BDM.DEVA) end
    if Pads.check(GPAD, PAD_CIRCLE) then cur = 0 return 0 end
    if Pads.check(GPAD, PAD_CROSS) and Main.Devs[cur+1] == IOP.NLOAD then lding = 1 end
  end
  return -1
end


function CompatModesDisp()
  local compatmodes = {
    {t="Accurate reads";d="Limits the reading speed to the maximun speeds than a real disc could reach on PS2";};
    {t="Sync reads";d="ISO Readings while in-game will be synchronized";};
    {t="Unhook syscalls";d="Unhook all the syscalls from the EmotionEngine interfered by neutrino EE_Core";};
    {t="Emulate Dual Layer DVD";d="Emulates CDVDMAN functions related to Dual Layer discs\nby responding with information from the first layer";};
  }
  Font.ftPrint(BFONT, 40, 40, 0, 128, 64, "Compatibility modes")
  Graphics.drawRect(0, 60, UI.SCR.X, 2, WHITE)
  for i = 1, #compatmodes, 1 do
    --local g = 128
    local t = 0x50
    if i == (cur+1) then t = 0x80 end
    --if Main.compat[i] then g = 0xff end
    Font.ftPrint(BFONT, 110, 50+(30*i), 0, 200, 64, compatmodes[i].t, Main.compat[i] and Color.new(50, 128, 50, t) or Color.new(128, 128, 128, t))
  end
  Font.ftPrint(SFONT, 100, UI.SCR.Y-100, 0, 400, 64, compatmodes[cur+1].d, GREY)
  Font.ftPrint(SFONT, 100, UI.SCR.Y-50 , 0, 400, 64, "X: switch mode   O: Go Back")
  if PADListen() then
    if Pads.check(GPAD, PAD_UP)  then cur = CLAMP(cur-1, 0, #compatmodes-1) end
    if Pads.check(GPAD, PAD_DOWN) then cur = CLAMP(cur+1, 0, #compatmodes-1) end
    if Pads.check(GPAD, PAD_CIRCLE) then cur=0 return 0 end
    if Pads.check(GPAD, PAD_CROSS) then Main.compat[cur+1] = not Main.compat[cur+1]; end
  end
  return -1
end