--[[
NEUTRINO Launcher by El_isra                                                         
LICENSE: GNU GPL v3
--]]
require("ui") -- make sure dependencies are there
GameList = {
  CURR = 1;
  MAXDRAW = 18;
};

BDM = {
  DEVS = {USB = 0, MX4SIO = 1, UDPBD = 2, ILINK = 3, HDD = 4};
  DEVA = 4;
  DEVSTAT = {};
  DeviceList = {};
  DevAlias = {};
  MAX_BD = 5;
  CURRBD = 0;
}
BDM.DevAlias[0] = "USB"
BDM.DevAlias[1] = "MX4SIO"
BDM.DevAlias[2] = "UDPBD"
BDM.DevAlias[3] = "iLink"
BDM.DevAlias[4] = "HDD"
for i = 0, BDM.DEVA do
  BDM.DEVSTAT[i] = {ID = -160, RET = -6, CUL = ""}
end

--initialize BDM device table
for i = 0, BDM.MAX_BD, 1 do
  BDM.DeviceList[i] = -19
end

local STARTUP = 1
function GameList.display(L)
  local ammount = #L
  if (GameList.CURR > (STARTUP+(GameList.MAXDRAW-1))) then
    STARTUP = (GameList.CURR-GameList.MAXDRAW+1)
  elseif (GameList.CURR < STARTUP) then
    STARTUP = CLAMP(GameList.CURR-1, 1, ammount)
  end

  for i = STARTUP, ammount do
    if i >= (STARTUP+GameList.MAXDRAW) then break end
    local Y = 30+((i-STARTUP)*21)
    Font.ftPrint(BFONT, 30, Y, 0, UI.SCR.X, 16, string.sub(L[i].name, 0, -5), i == GameList.CURR and YELLOW or GREY)
  end
  if ammount < 1 then
    Font.ftPrintMultiLineAligned(LFONT, UI.SCR.X_MID, UI.SCR.Y_MID, 20, UI.SCR.X, 32, "No games found")
  end
  Font.ftPrint(SFONT, 100, UI.SCR.Y-50, 0, 400, 64, "X: Run Game   O: Go Back")
  if PADListen() then
    if Pads.check(GPAD, PAD_DOWN) then GameList.CURR = CLAMP(GameList.CURR+1, 1, ammount) end
    if Pads.check(GPAD, PAD_UP) then GameList.CURR = CLAMP(GameList.CURR-1, 1, ammount) end
    if Pads.check(GPAD, PAD_L1) then GameList.CURR = CLAMP(GameList.CURR+GameList.MAXDRAW, 1, ammount) end
    if Pads.check(GPAD, PAD_R1) then GameList.CURR = CLAMP(GameList.CURR-GameList.MAXDRAW, 1, ammount) end
    if Pads.check(GPAD, PAD_CROSS) and ammount > 0 then return GameList.CURR end
    if Pads.check(GPAD, PAD_CIRCLE) then return -1 end
  end
  return 0
end

function GameList.ParseMassDevice(index, subfolder, ret2)
  local basepath = string.format("%s%d:/%s", "mass", index, subfolder)
  local DIR = System.listDirectory(basepath)
  local ret = {}
  if type(ret2) == "table" then ret = ret2 end
  if DIR == nil then
    --UI.Notif_queue.add(("Failed to parse directory\n'%s'"):format(basepath))
    return nil
  end
  for i = 1, #DIR do
    local T = {name = DIR[i].name; loc = "/"..subfolder; massindx = "mass"..index..":/"}
    if CheckExtension(DIR[i].name, ".iso") then
      table.insert(ret, T)
    end
  end
  return ret
end

function BDM.UpdateDeviceList()
  BDM.DeviceList = {}
  for i = 0, BDM.MAX_BD, 1 do
    local type = GetBDMDeviceType(i)
    BDM.DeviceList[i] = type
    if type < 0 then
      LOG("BDM ", i, "err:", type)
    end
  end
end

local cur = 0
function BDM.DeviceListPrompt()
  for i = 0, BDM.MAX_BD, 1 do
    local I = IMG.nodev
    local C = i == cur and 128 or 99
    local col = Color.new(128, 128, 128, C)
    if BDM.DeviceList[i] == BDM.DEVS.USB then I = IMG.dev_usb
    elseif BDM.DeviceList[i] == BDM.DEVS.HDD then I = IMG.dev_ide
    elseif BDM.DeviceList[i] == BDM.DEVS.MX4SIO then I = IMG.dev_mx4sio
    elseif BDM.DeviceList[i] == BDM.DEVS.ILINK then I = IMG.dev_ilink
    elseif BDM.DeviceList[i] == BDM.DEVS.UDPBD then I = IMG.dev_udpbd
    elseif BDM.DeviceList[i] < 0 then
      col = Color.new(40, 0, 40, C-28)
      if i == cur then Font.ftPrint(SFONT, 180, 50+16+(64*i), 0, UI.SCR.X, 64, ("no device detected (%d)"):format(BDM.DeviceList[i])) end
    end
    Graphics.drawImage(I, 100, 50+(64*i), col)
  end
  Font.ftPrint(SFONT, 100, UI.SCR.Y-50, 0, UI.SCR.X, 64, "X: Enter Device   START: Credits   SELECT: Refresh   ▲:Driver Manager   ■:Compatibility modes")
  if PADListen() then
    if Pads.check(GPAD, PAD_UP) then cur = CLAMP(cur-1, 0, BDM.MAX_BD) end
    if Pads.check(GPAD, PAD_DOWN) then cur = CLAMP(cur+1, 0, BDM.MAX_BD) end
    if Pads.check(GPAD, PAD_CROSS) and BDM.DeviceList[cur] >= 0 then GPAD=1 return cur end
    if Pads.check(GPAD, PAD_TRIANGLE) then return -2 end
    if Pads.check(GPAD, PAD_START) then return -3 end
    if Pads.check(GPAD, PAD_SQUARE) then return -4 end
    if Pads.check(GPAD, PAD_SELECT) then BDM.UpdateDeviceList() end
  end
  return -1
end

BDM.UpdateDeviceList()