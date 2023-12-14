--[[
  POPSLoader Main script. dont touch unless you know what youre doing
  to do cosmetic changes, please check the `ui.lua` and `images.lua` files
  to add custom popstarter profiles check `pops_profiles.lua`
]]

PLDR = {
  POPSTARTER_PATH = "mass:/POPS/POPSTARTER.ELF";
  GAMEPATH = ".";
  GAMES = {};
  PROFILES = {};
  CheckPOPStarterDEPS = function ()
    if UI.CURSCENE == UI.SCENES.GUSB then
      return doesFileExist("mass:/POPS/POPS_IOX.PAK")
    --[[
    elseif UI.CURSCENE == UI.SCENES.GHDD then
      HDD.MountPart("hdd0:__common")
      return (doesFileExist("pfs0:/POPS/POPS.ELF") and doesFileExist("pfs0:/POPS/IOPRP252.IMG"))
    --]]
    end
  end;
}

require("pops_profiles")
require("ui")
require("images")


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

function Font.ftPrintMultiLineAligned(font, x, y, spacing, width, height, text, color)
  local internal_y = y
  for line in text:gmatch("([^\n]*)\n?") do
    Font.ftPrint(font, x, internal_y, 8, width, height, line, color)
    internal_y = internal_y+spacing
  end
end

function PLDR.GetPS1GameLists(path, tabl)
  local RET = {}
  local found_smth = false
  if type(tabl) == "table" then RET = tabl end
  if path ~= nil then PLDR.GAMEPATH = path end
  local DIR = System.listDirectory(PLDR.GAMEPATH)
  if DIR ~= nil then
    for i = 1, #DIR do
      if string.lower(string.sub(DIR[i].name,-4)) == ".vcd" then
        print("Found PS1 Game ", DIR[i].name)
        found_smth = true
        table.insert(RET, DIR[i].name)
      end
    end
  end
  if found_smth then
    table.sort(RET)
    PLDR.GAMES = RET
    return RET
  else
    return nil
  end
end

---DONT TOUCH ME
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

---DONT TOUCH ME
function PLDR.RunPOPStarterGame(game)
  System.loadELF(PLDR.POPSTARTER_PATH, 0, game)
  print(">>> UNHANDLED ERROR at Launching game '", game, " via ", PLDR.POPSTARTER_PATH, " Failed")
  STOP()
end
---MAIN PROGRAM BEHAVIOUR BEGINS
UI.WelcomeDraw.Play()
while true do
  UI.BottomDraw.Play()
  if UI.CURSCENE == UI.SCENES.MMAIN then
    UI.MainMenu.Play()
  elseif UI.CURSCENE == UI.SCENES.MPROFILE then
    UI.ProfileQuery.Play()
  elseif UI.CURSCENE <= UI.SCENES.GHDD then
    UI.GameList.Play()
  end
  UI.flip()
end