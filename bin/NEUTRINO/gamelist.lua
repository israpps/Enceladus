
GameList = {
  CURR = 1;
  MAXDRAW = 18;
};

BDM = {
  DeviceList = {};
  MAX_BD = 6;
}

--initialize BDM device table
for i = 0, BDM.MAX_BD, 1 do
  BDM.DeviceList[i] = -19
end

local STARTUP = 1
function GameList.display(L)
  local ammount = #L
  if (GameList.CURR > (STARTUP+(GameList.MAXDRAW-1))) then -- recalc list pos only when hittin min/max
    STARTUP = (GameList.CURR-GameList.MAXDRAW+1)
  elseif (GameList.CURR < STARTUP) then
    STARTUP = CLAMP(GameList.CURR-1, 1, ammount)
  end

  for i = STARTUP, ammount do
    if i >= (STARTUP+GameList.MAXDRAW) then break end
    local Y = 30+((i-STARTUP)*21)
    Font.ftPrint(BFONT, 30, Y, 0, UI.SCR.X, 16, L[i], i == GameList.CURR and YELLOW or GREY)
  end
  if ammount <= 0 then
    Font.ftPrintMultiLineAligned(LFONT, UI.SCR.X_MID, UI.SCR.Y_MID, 20, UI.SCR.X, 32, "No games found")
    Font.ftPrintMultiLineAligned(LFONT, UI.SCR.X_MID+1, UI.SCR.Y_MID+1, 20, UI.SCR.X, 32, "No games found")
  end
  if PADListen() then
    if Pads.check(GPAD, PAD_DOWN) then GameList.CURR = CLAMP(GameList.CURR+1, 1, ammount) end
    if Pads.check(GPAD, PAD_UP  ) then GameList.CURR = CLAMP(GameList.CURR-1, 1, ammount) end
  end
end

function GameList.ParseMassDevice(index, subfolder, ret2)
  local basepath = string.format("host%d:/%s", index, subfolder)
  local DIR = System.listDirectory(basepath)
  local ret = {}
  if type(ret2) == "table" then ret = ret2 end
  for i = 1, #DIR do
    if string.lower(string.sub(DIR[i].name, -4)) == ".iso" then
      table.insert(ret, DIR[i].name)
      LOG("> PARSE: ADD", DIR[i].name)
    end
  end
  LOG("parsed", basepath)
end

function BDM.UpdateDeviceList()
  BDM.DeviceList = {}
  for i = 0, BDM.MAX_BD, 1 do
    local type = GetBDMDeviceType(i)
    if type >= 0 then
      BDM.DeviceList[i] = type
    else
      LOG("BDM ", i, "err:", type)
    end
  end
end
