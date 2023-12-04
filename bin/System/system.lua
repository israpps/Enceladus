package.path = "./?.lua;mass:/POPSLDR/?.lua;mc0:/POPSLDR/?.lua;mc1:/POPSLDR/?.lua"
PLDR = {
  POPSTARTER_PATH = "mass:/POPS/POPSTARTER.ELF";
  GAMEPATH = ".";
  GAMES = {};
}

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
  SCR = {
    X = 702;
    X_MID = 702/2;
    Y = 480;
    Y_MID = 480/2;
  };
  --- wrapper for Screen.flip(), here you add UI draws that MUST be on top of everything (eg: error notifs)
  flip = function () Screen.flip() end;
  GameList = {
    MAXDRAW = 18;
    CURR = 1;
    Reset = function ()
      UI.GameList.CURR = 1;
    end;
    Play = function()
      local ammount = #PLDR.GAMES
      local STARTUP = 1
      if (UI.GameList.CURR > UI.GameList.MAXDRAW) then STARTUP = UI.GameList.CURR end
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
  Pad = {
    PDELAY = 200;
    Listen = function ()
      if UI.Pad.Timer == nil then UI.Pad.Timer = Timer.new() end
      local T = Timer.getTime(UI.Pad.Timer)
      while (T+200) > Timer.getTime(UI.Pad.Timer) do end
      GPAD = Pads.get()
    end;
    Timer = nil;
  }
}

Screen.setMode(_480p, UI.SCR.X, UI.SCR.Y, CT24, INTERLACED, FIELD)

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

while true do
  Screen.clear(Color.new(128, 00, 80))
  UI.GameList.Play()
  UI.flip()
end