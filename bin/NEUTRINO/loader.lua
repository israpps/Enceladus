--[[
NEUTRINO Launcher by El_isra                                                         
LICENSE: GNU GPL v3
--]]
LOG("> loader.lua begins")
LOG("CWD:", System.currentDirectory())

IOP.loadModule(System.currentDirectory().."/tty.irx")

require("utils")
require("ui")
require("gamelist")

Main = {
  Devs = {
    true, -- usb
    false, -- sdc (mx4sio)
    false, -- udp
    false, -- sd (iLink)
    false, -- ata (bdm_hdd)
  };
  irx = {
    DEV9 = {ld = false, id=0, ret=0};
  };
  modloc = System.currentDirectory().."/NEUTRINO/modules/";
  neutrino_loc = System.currentDirectory().."/NEUTRINO/neutrino.elf";
  bsd = "usb";
}

function LoadDev9(path)
  if Main.irx.DEV9.ld then return 0 end -- already loaded
  local RET, ID
  RET, ID = IOP.loadModule(path)
  if (RET == 1 or ID < 0) then return -1 end -- failed
  Main.irx.DEV9.ld = true
  Main.irx.DEV9.id = ID
  Main.irx.DEV9.ret = RET
  return 1 -- loaded
end

function Main.LoadModule(M)
  local RET, ID
  local modname
  if M == BDM.DEVS.MX4SIO and not Main.Devs[M+1] then
    modname = "mx4sio_bd_mini.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  elseif M == BDM.DEVS.UDPBD and not Main.Devs[M+1] then --
    modname = "dev9_ns.irx"
    if LoadDev9(Main.modloc..modname) < 0 then
      ID = Main.irx.DEV9.id
      RET = Main.irx.DEV9.ret
      goto quit
    end
    modname = "smap_udpbd.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  elseif M == BDM.DEVS.ILINK and not Main.Devs[M+1] then --
    modname = "iLinkman.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
    if RET == 1 or ID < 0 then goto quit end
    modname = "IEEE1394_bd_mini.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  elseif M == BDM.DEVS.HDD and not Main.Devs[M+1] then --
    modname = "dev9_ns.irx"
    if LoadDev9(Main.modloc..modname) < 0 then
      ID = Main.irx.DEV9.id
      RET = Main.irx.DEV9.ret
      goto quit
    end
    modname = "ata_bd.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  else
    LOG("!!! Requested module is already loaded or failed to load previously")
    return
  end

  ::quit::
  if RET == 1 or ID < 0 then
    local extra = ""
    if ID == -200 then extra ="\nMissing module dependency"
    elseif ID == -203 then extra ="\nFile not found"
    elseif ID == -400 then extra ="\nNOT ENOUGH FREE IOP RAM"
    elseif RET == 1 then extra ="\nDriver startup aborted"
    end
    UI.Notif_queue.add(("Failed to load module %s (%d|%d)"..extra):format(modname, RET, ID))
  else
    LOG("Module successful startup")
    Main.Devs[M+1] = true
  end
end

Main.LoadModule(BDM.DEVS.UDPBD)


---@param GAME string Game image location, full path.
---@param ... string Extra parameters to be passed to neutrino
function Main.LaunchNeutrino(GAME, ...)
  local bsd = ("-bsd=%s"):format(Main.bsd)
  local gameloc = ("-dvd=mass:%s"):format(GAME)
  System.loadELF(Main.neutrino_loc, 1, bsd, gameloc, ...)
end

local SCENES = {
  MAIN = 0,
  GAMELIST = 1,
  CREDITS = 2,
}

local CURSCENE = SCENES.CREDITS
local x
while true do
  UI.Pre()
  if CURSCENE == SCENES.MAIN then
    x = BDM.DeviceListPrompt()
    if x > -1 then
      GameList.clist = {}
      BDM.CURRBD = x
      CURSCENE = SCENES.GAMELIST
      local T
      T = GameList.ParseMassDevice(BDM.CURRBD, "CD", GameList.clist)
      if T ~= nil then GameList.clist = T end
      T = GameList.ParseMassDevice(BDM.CURRBD, "DVD", GameList.clist)
      if T ~= nil then GameList.clist = T end
    end
  elseif CURSCENE == SCENES.GAMELIST then
    local G = GameList.display(GameList.clist)
    if G == -1 then
      CURSCENE = SCENES.MAIN
    elseif G > 0 then
      LOGF(">>> GAME EXEC REQUEST '%s' (loc %s)\n", GameList.clist[G].name, GameList.clist[G].loc)
      if not doesFileExist(Main.neutrino_loc) then
        UI.Notif_queue.add("Neutrino ELF missing!\n"..Main.neutrino_loc)
      else
        Main.LaunchNeutrino(GameList.clist[G].loc.."/"..GameList.clist[G].name)
      end
    end
  elseif CURSCENE == SCENES.CREDITS then
    if UI.Credits.Play() then CURSCENE = SCENES.MAIN end
  end
  UI.Top()
end