LOG("- loader.lua begins")
LOG("CWD:", System.currentDirectory())

require("utils")
require("ui")
require("gamelist")

GameList.clist = {
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
}

Main = {
  Devs = {
    true, -- usb
    false, -- sdc (mx4sio)
    false, -- udp
    false, -- sd (iLink)
    false, -- ata (bdm_hdd)
  };
  modloc = System.currentDirectory().."/NEUTRINO/modules/";
  neutrino_loc = System.currentDirectory().."/NEUTRINO/neutrino.elf";
  bsd = "usb";
}

function Main.LoadModule(M)
  local RET, ID
  local modname
  if M == 1 then
    modname = "mx4sio_bd_mini.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  elseif M == 2 then --
    modname = "dev9_ns.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
    if ID == 1 or RET < 0 then goto quit end
    modname = "smap_udpbd.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  elseif M == 3 then --
    modname = "iLinkman.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
    if ID == 1 or RET < 0 then goto quit end
    modname = "IEEE1394_bd_mini.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  elseif M == 4 then --
    modname = "dev9_ns.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
    if ID == 1 or RET < 0 then goto quit end
    modname = "ata_bd.irx"
    RET, ID = IOP.loadModule(Main.modloc..modname)
  end

  ::quit::
  if ID == 1 or RET < 0 then
    local extra = ""
    if ID == -200 then extra ="\nMissing module dependency"
    elseif ID == -203 then extra ="\nFile not found"
    elseif ID == -400 then extra ="\nNOT ENOUGH FREE IOP RAM"
    elseif RET == 1 then extra ="\nDriver startup aborted"
    end
    UI.Notif_queue.add(("Failed to load module %s (%d|%d)"..extra):format(modname, RET, ID))
  end
end

Main.LoadModule(3)

function Main.LaunchNeutrino(GAME, ...)
  local bsd = ("-bsd=%s"):format(Main.bsd)
  local gameloc = ("-dvd=mass:%s"):format(GAME)
  System.loadELF(Main.neutrino_loc, 1, bsd, gameloc, ...)
end
local SCENES = {
  MAIN = 0,
  GAMELIST = 1,
}
local CURSCENE = SCENES.MAIN
local x
while true do
  UI.clear()
  if CURSCENE == SCENES.MAIN then
    x = BDM.DeviceListPrompt()
    if x > -1 then
      BDM.CURRBD = x
      CURSCENE = SCENES.GAMELIST
    end
  elseif CURSCENE == SCENES.GAMELIST then
    GameList.display(GameList.clist)
  end
  UI.flip()
end