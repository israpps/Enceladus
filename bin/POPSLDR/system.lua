PLDR = {
  POPSTARTER_PATH = "mass:/POPS/POPSTARTER.ELF";
  GAMEPATH = ".";
  GAMES = {};
  PROFILES = {}
}
require("pops_profiles")


function CLAMP(a, MIN, MAX)
  if a < MIN then return MIN end
  if a > MAX then return MAX end
  return a
end

function CYCLE_CLAMP(a, MIN, MAX)
  if a < MIN then return MAX end
  if a > MAX then return MIN end
  return a
end

UI = {
  UpdateVmode = function ()
    Screen.setMode(UI.SCR.VMODE, UI.SCR.X, UI.SCR.Y, CT24, INTERLACED, FIELD)
  end;
  --- UI Constants
  SCR = {
    X = 702;
    X_MID = 702/2;
    Y = 480;
    Y_MID = 480/2;
    VMODE = _480p;
  };
  --- Notifications queue handler
  Notif_queue = {
    display = function ()
      local Q
      if #UI.Notif_queue.msg < 1 then return end
      if #UI.Notif_queue.msg > 1 then Q = 0x50 elseif UI.Notif_queue.ALFA > 0x50 then Q = 0x50 else Q = UI.Notif_queue.ALFA end
      Graphics.drawRect(30, 30, UI.SCR.X_MID-30, 40, Color.new(0, 0, 0, Q))
      Font.ftPrint(BFONT, 32, 32, 0, UI.SCR.X_MID-30, 32, UI.Notif_queue.msg[1], Color.new(0, 100, 255, UI.Notif_queue.ALFA))
      UI.Notif_queue.ALFA = UI.Notif_queue.ALFA-3
      if UI.Notif_queue.ALFA < 1 then
        UI.Notif_queue.ALFA = 0x90
        table.remove(UI.Notif_queue.msg, 1)
      end
    end;
    ALFA = 0x80;
    msg = {};
  };
  --- wrapper for Screen.flip(), here you add UI draws that MUST be on top of everything (eg: error notifs)
  flip = function ()
    UI.Notif_queue.display()
    Screen.flip()
  end;
  GameList = {
    MAXDRAW = 18;
    CURR = 1;
    Reset = function ()
      UI.GameList.CURR = 1;
    end;
    Play = function()
      local ammount = #PLDR.GAMES
      local STARTUP = 1
      if (UI.GameList.CURR > UI.GameList.MAXDRAW) then STARTUP = (ammount-UI.GameList.MAXDRAW+1) end
      for i = STARTUP, ammount do
        if i >= (STARTUP+UI.GameList.MAXDRAW) then break end
        local Y = 20+((i-STARTUP)*21)
        Font.ftPrint(BFONT, 30, Y, 0, UI.SCR.X, 16, PLDR.GAMES[i], i == UI.GameList.CURR and Color.new(128, 128, 0, 128) or Color.new(128, 128, 128, 128))
      end
      UI.Pad.Listen()
      if Pads.check(GPAD, PAD_DOWN) then UI.GameList.CURR = CLAMP(UI.GameList.CURR+1, 1, ammount) GPAD = 0 end
      if Pads.check(GPAD, PAD_UP) then UI.GameList.CURR = CLAMP(UI.GameList.CURR-1, 1, ammount) GPAD = 0 end
      if Pads.check(GPAD, PAD_CROSS) then print("System.loadELF( ".. PLDR.POPSTARTER_PATH ..", 1,  ./".. PLDR.GAMES[UI.GameList.CURR]..")") end
    end;
  };
  ProfileQuery = {
    lastopt = 1;
    curopt = 1;
    Play = function ()
      local profcnt = #PLDR.PROFILES
      Font.ftPrint(BFONT, UI.SCR.X_MID, 30, 8, UI.SCR.X, 16, "Choose POPStarter Profile", Color.new(128,128,128))
      Font.ftPrint(BFONT, UI.SCR.X_MID, 60, 8, UI.SCR.X, 16, "Profile "..UI.ProfileQuery.curopt, Color.new(128,128,128))
      Font.ftPrint(BFONT, UI.SCR.X_MID, 190, 8, UI.SCR.X, 16, PLDR.PROFILES[UI.ProfileQuery.curopt].DESC, Color.new(128,128,128))
      Font.ftPrint(BFONT, UI.SCR.X_MID, 210, 8, UI.SCR.X, 16, PLDR.PROFILES[UI.ProfileQuery.curopt].ELF, Color.new(128,128,128, 110))
      UI.Pad.Listen()
      if Pads.check(GPAD, PAD_DOWN) then UI.ProfileQuery.curopt = CLAMP(UI.ProfileQuery.curopt+1, 1, profcnt) GPAD = 0 end
      if Pads.check(GPAD, PAD_UP) then UI.ProfileQuery.curopt = CLAMP(UI.ProfileQuery.curopt-1, 1, profcnt) GPAD = 0 end
      if Pads.check(GPAD, PAD_CROSS) then
        print("Chose profile", UI.ProfileQuery.curopt)
        if not doesFileExist(PLDR.PROFILES[UI.ProfileQuery.curopt].ELF) then
          print("ERROR: POPStarter profile points to non existent ELF")
          table.insert(UI.Notif_queue.msg, "POPStarter ELF missing")
        end
      end
    end;
  };
  MainMenu = {
    OPT = 1;
    Play = function ()
      local profcnt = 3
      Font.ftPrint(BFONT, UI.SCR.X_MID, 30, 8, UI.SCR.X, 16, "Welcome to POPStarter Loader", Color.new(128,128,128))
      Font.ftPrint(BFONT, 30, 60, 0, UI.SCR.X, 16, "USB", Color.new(128,128,128))
      Font.ftPrint(BFONT, 130, 60, 0, UI.SCR.X, 16, "SMB", Color.new(128,128,128))
      Font.ftPrint(BFONT, 230, 60, 0, UI.SCR.X, 16, "HDD", Color.new(128,128,128))
      Font.ftPrint(BFONT, UI.SCR.X_MID, 240, 8, UI.SCR.X, 16, UI.MainMenu.opts[UI.MainMenu.OPT], Color.new(128,128,128))
      UI.Pad.Listen()
      if Pads.check(GPAD, PAD_DOWN) then UI.MainMenu.OPT = CLAMP(UI.MainMenu.OPT+1, 1, profcnt) GPAD = 0 end
      if Pads.check(GPAD, PAD_UP) then UI.MainMenu.OPT = CLAMP(UI.MainMenu.OPT-1, 1, profcnt) GPAD = 0 end
      if Pads.check(GPAD, PAD_CROSS) then
        print("Chose profile", UI.MainMenu.OPT)
        if not doesFileExist(UI.MainMenu.opts[UI.MainMenu.OPT].ELF) then
          print("ERROR: POPStarter profile points to non existent ELF")
          table.insert(UI.Notif_queue.msg, "POPStarter ELF missing")
        end
      end
    end
  };
  Pad = {
    PDELAY = 150;
    CLK = 0;
    Listen = function ()
      if UI.Pad.Timer == nil then UI.Pad.Timer = Timer.new() end
      UI.Pad.CLK = Timer.getTime(UI.Pad.Timer)
      if (UI.Pad.CLK+UI.Pad.PDELAY) > Timer.getTime(UI.Pad.Timer) then
        GPAD = Pads.get()
      else
        GPAD = 0
      end
    end;
    Timer = nil;
  }
}



function Font.ftPrintMultiLineAligned(font, x, y, spacing, width, height, text, color)
  local internal_y = y
  for line in text:gmatch("([^\n]*)\n?") do
    Font.ftPrint(font, x, internal_y, 8, width, height, line, color)
    internal_y = internal_y+spacing
  end
end
function PLDR.GetPS1GameLists(path, tabl)
  local RET = {}
  if type(tabl) == "table" then RET = tabl end
  if path ~= nil then PLDR.GAMEPATH = path end
  local DIR = System.listDirectory(PLDR.GAMEPATH)
  if DIR ~= nil then
    for i = 1, #DIR do
      if string.lower(string.sub(DIR[i].name,-4)) == ".vcd" then
        print("Found PS1 Game ", DIR[i].name)
        table.insert(RET, DIR[i].name)
      end
    end
  else
    return nil
  end
  table.sort(RET)
  PLDR.GAMES = RET
  return RET
end

PLDR.GetPS1GameLists(".", nil)

function PLDR.GetVCDGameID(path)
  local RET = nil
  local fd = System.openFile(path, FREAD)
  if System.sizeFile(fd) < 0x10d900 then
    print("ERROR: VCD Size is not big enough to pull ID")
  else
    System.seekFile(fd, 0x10c900, SET)
    local buffer = System.readFile(fd, 4096)
    RET = string.match(buffer, "[A-Z][A-Z][A-Z][A-Z][_-][0-9][0-9][0-9].[0-9][0-9]")
  end
  System.closeFile(fd)
  return RET
end

function PLDR.RunPOPStarterGame(game)
  System.loadELF(PLDR.POPSTARTER_PATH, true, game)
  print(">>> UNHANDLED ERROR. Launching game ", game, " via ", PLDR.POPSTARTER_PATH, " Failed")
end

while true do
  Screen.clear(Color.new(128, 00, 80))
  UI.GameList.Play()
  UI.ProfileQuery.Play()
  UI.MainMenu.Play()
  UI.flip()
end