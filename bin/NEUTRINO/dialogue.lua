LOG("> Registering extra diags")


local cur = 0
local lding = 0
function ModLoadUI()
  Font.ftPrint(BFONT, 40, 40, 0, 128, 64, "Driver Manager")
  Graphics.drawRect(0, 60, UI.SCR.X, 2, GREY)
  for i = 0, BDM.DEVA, 1 do
    local I = IMG.dev_usb
    local C = i == cur and 127 or 100
    if i == BDM.DEVS.HDD then I = IMG.dev_ide
    elseif i == BDM.DEVS.MX4SIO then I = IMG.dev_mx4sio
    elseif i == BDM.DEVS.ILINK then I = IMG.dev_ilink
    elseif i == BDM.DEVS.UDPBD then I = IMG.dev_udpbd end
    if Main.Devs[i+1] == IOP.LDFAIL then
      Font.ftPrint(BFONT, 180, 70+16+(70*i), 0, 300, 64, ("Driver startup error: '%s'  id:%d  ret:%d\n\"%s\""):format(
        BDM.DEVSTAT[i].CUL, BDM.DEVSTAT[i].ID, BDM.DEVSTAT[i].RET, IOP.GetModuleErr(BDM.DEVSTAT[i].ID, BDM.DEVSTAT[i].RET)), Color.new(128, 128, 128, C))
    elseif Main.Devs[i+1] == IOP.NLOAD then
      C = C-50
    end
    local col = Color.new(128, 128, 128, C)
    if Main.Devs[i+1] == IOP.LDFAIL then col = Color.new(200, 0, 0, C)
    elseif Main.Devs[i+1] == IOP.LOADED then col = Color.new(0, 128, 40, C)
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
    if Pads.check(GPAD, PAD_CIRCLE) then return cur end
    if Pads.check(GPAD, PAD_CROSS) then lding = 1 end
  end
  return -1
end