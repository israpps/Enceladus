--if doesFileExist("lip.lua") then dofile("lip.lua") end
SCR_X = 704
SCR_Y = 480
X_MID = SCR_X/2
Y_MID = SCR_Y/2
Screen.setMode(_480p, SCR_X, SCR_Y, CT24, INTERLACED, FIELD)
RES = {}
RES = Graphics.loadEmbeddedAssets()
Graphics.setImageFilters(RES.BG, LINEAR)
Graphics.setImageFilters(RES.circle, NEAREST)
Graphics.setImageFilters(RES.cross, NEAREST)
Graphics.setImageFilters(RES.square, NEAREST)
Graphics.setImageFilters(RES.triangle, NEAREST)
Graphics.setImageFilters(RES.up, NEAREST)
Graphics.setImageFilters(RES.down, NEAREST)
Graphics.setImageFilters(RES.left, NEAREST)
Graphics.setImageFilters(RES.right, NEAREST)
Graphics.setImageFilters(RES.start, NEAREST)
Graphics.setImageFilters(RES.select, NEAREST)
Graphics.setImageFilters(RES.R1, NEAREST)
Graphics.setImageFilters(RES.R2, NEAREST)
Graphics.setImageFilters(RES.L1, NEAREST)
Graphics.setImageFilters(RES.L2, NEAREST)
Graphics.setImageFilters(RES.L3, NEAREST)
Graphics.setImageFilters(RES.R3, NEAREST)
Font.ftInit()
_FNT_ = Font.LoadBuiltinFont()
_FNT2_ = Font.LoadBuiltinFont(1)

Font.ftSetCharSize(_FNT_, 940, 940)
Font.ftSetCharSize(_FNT2_, 740, 740)
fontSmall = _FNT2_
fontBig = _FNT_
pad = 0
PADBUTTONS = {"L1", "L2", "R1", "R2", "UP", "TRIANGLE", "LEFT", "RIGHT", "SELECT", "START", "SQUARE", "CIRCLE", "DOWN", "CROSS", "L3", "AUTO", "R3"}
PADATTEMPT = {1, 2, 3}

LNG = {
  MAIN_MENU_PROMPT = "PS2BBL Configurator";
  MAIN_MENU_LAB_LOAD_CONF = "Load Config";
  MAIN_MENU_LAB_SAVE_CONF = "Save Config";
  MAIN_MENU_LAB_LOAD_DEFS = "Load defaults";
  MAIN_MENU_LAB_CONFIGURE = "Configure";
  MAIN_MENU_LAB_ABOUT     = "About";
  MAIN_MENU_LAB_LAUNCHELF = "load ELF";
  MAIN_MENU_LAB_LAUNCHOSD = "Go back to browser";

  MAIN_MENU_STR_LOAD_CONF = "Read config from a device";
  MAIN_MENU_STR_SAVE_CONF = "Save config into a device";
  MAIN_MENU_STR_LOAD_DEFS = "Load the stock config";
  MAIN_MENU_STR_CONFIGURE = "Browse the configuration values";
  MAIN_MENU_STR_ABOUT     = "Information about the program";
  MAIN_MENU_STR_LAUNCHELF = "Load other program";
  MAIN_MENU_STR_LAUNCHOSD = "Exit PS2BBL configurator into PS2 Browser";

  READ_CONF_FROM_MC0    = "Read config from Memory Card on slot 1";
  READ_CONF_FROM_MC1    = "Read config from Memory Card on slot 2";
  READ_CONF_FROM_USB    = "Read config from USB Mass storage";
  READ_CONF_FROM_MX4SIO = "Read config from MX4SIO SDCard";
  READ_CONF_FROM_IHDD   = "Read config from Internal HDD";

  SAVE_CONF_INTO_MC0    = "Save config into Memory Card on slot 1";
  SAVE_CONF_INTO_MC1    = "Save config into Memory Card on slot 2";
  SAVE_CONF_INTO_USB    = "Save config into USB Mass storage";
  SAVE_CONF_INTO_MX4SIO = "Save config into MX4SIO SDCard";
  SAVE_CONF_INTO_IHDD   = "Save config into Internal HDD";

  PS2BBLCMD_STR_CDVD            = "Makes PS2BBL run a disc";
  PS2BBLCMD_STR_CDVD_NO_PS2LOGO = "Makes PS2BBL run a disc. but skipping usage of PS2LOGO (useful for Mechapwn)";
  PS2BBLCMD_STR_CREDITS         = "displays credits (duh). and shows compilation date and associated git commit hash";
  PS2BBLCMD_STR_OSDSYS          = "Executes OSDSYS program (Console main menu).\nbut passing args to avoid booting MC or HDD Updates";
  PS2BBLCMD_STR_HDDCHECKER      = "Runs HDD diagnosis tests (only works if PS2BBL has HDD support enabled)";

  MAINCONFD_LAB_MNCONF = "Main Config";
  MAINCONFD_LAB_LKCONF = "Launch Keys";
  MAINCONFD_STR_MNCONF = "Configure the main aspects of PS2BBL";
  MAINCONFD_STR_LKCONF = "Configure wich applications to run when bound key is pressed";

  MAINCONFP_STR_PS2LOG = "Run PS2 games with PS2LOGO program or run game directly";
  MAINCONFP_STR_WAITIM = "Time (in miliseconds) that PS2BBL will wait for a key press before\nLaunching AUTO Applications";
  MAINCONFP_STR_LGOCOL = "Change PS2BBL Logo color based on memory card play history";
  MAINCONFP_STR_DISCTR = "If PS2BBL should open the disc tray (if empty)\nWhen user calls disc launcher commands";
  MAINCONFP_STR_LGODIS = "Logo display setting.\n2: show logo and console info, 1: show console info\n0:Dont show anything";
  MAINCONFP_STR_IRXLDR = "Defines a path to an IRX driver to be loaded on memory when PS2BBL reads config";
  CREDITSDL_STR_FULL = [[
 Coded by El_isra (Matias Israelson)
 
 Based on Enceladus by Daniel Sant0s
 Based (design wise) on FreeMcBoot configurator and KELFBinder
 BG Image by berion
 Fonts used: Liberation Sans & Inter (by Rasmus Anderson)
 
 More information at github.com/israpps/PS2BBL-configurator
 ]]; -- this is a multi line string, the line breaks of the text file itself are interpreted as literal line breaks.
 --therefore, dont add any newline unless its a single line string

  LAB_NOT_SET = "<not set>";
  MSG_IRX_LOAD_FAIL = "Failed to load driver: ";
  MSG_HDD_STAT_ERR = "HDD Status error: ";
  WARN_EMPTY_CONF_SAVE = "Warning\nYou are trying to save blank config to file\ncontinue?";
  ERROR_PART_MOUNT_FAIL = "Failed to mount partition: ";
  ERROR_LUA_EXT_SCRIPT = "ERROR AT EXTERNAL SCRIPT";
  OFM_ERROR_LISTING_FILES = "Error while browsing:\n%s"
}

GSTATE = {
  HDD_LOADED = 0;--0: not loaded, 1: loaded, -1: failed to load
  MX4SIO_LOADED = 0;--0: not loaded, 1: loaded, -1: failed to load
  CONFIG_LOADSTATE = -1;--if <0: no config loaded, >0: config loaded
  ALLOW_HDD_BROWSING = true
}

Notif_queue = {
  display = function ()
    local Q
    if #Notif_queue.msg < 1 then return end
    if #Notif_queue.msg > 1 then Q = 0x50 elseif Notif_queue.ALFA > 0x50 then Q = 0x50 else Q = math.floor(Notif_queue.ALFA) end
    Graphics.drawRect(30, 30, X_MID-30, 40, Color.new(0, 0, 0, Q))
    Font.ftPrint(_FNT2_, 32, 32, 0, X_MID-30, 32, Notif_queue.msg[1], Color.new(0, 100, 255, math.floor(Notif_queue.ALFA)))
    Notif_queue.ALFA = Notif_queue.ALFA-.5
    if Notif_queue.ALFA < 1 then
      Notif_queue.ALFA = 0x90
      table.remove(Notif_queue.msg, 1)
    end
  end;
  ALFA = 0x80;
  msg = {};
}

function LoadHDD_Stuff()
  if GSTATE.HDD_LOADED ~= 0 then return end
  local ret, str = IOP.LoadHDDModules()
  if ret ~= 1 then
    local msg
    if ret == 0 then msg = LNG.MSG_IRX_LOAD_FAIL..str else msg = LNG.MSG_HDD_STAT_ERR..str end
    table.insert(Notif_queue.msg, string.format(msg, str))
    GSTATE.HDD_LOADED = -1
  else
    GSTATE.HDD_LOADED = 1
  end
end

function LoadMX4_Stuff()
  if GSTATE.MX4SIO_LOADED ~= 0 then return end
  local id, result = IOP.load_MX4SIO_Module()
  if id < 0 or result ~= 0 then
    table.insert(Notif_queue.msg, ("%sMX4SIO_BD.IRX (ID:%d, ret:%d)"):format(LNG.MSG_IRX_LOAD_FAIL, id, result))
    GSTATE.MX4SIO_LOADED = -1
  else
    GSTATE.MX4SIO_LOADED = 1
  end
end

function Check_device_ld(sret)
  if sret == 4 then LoadMX4_Stuff() end
  if sret == 5 then LoadHDD_Stuff() end
end

function Screen.SpecialFlip(notif)
  if notif ~= nil then
    Notif_queue.display()
  end
  Screen.flip()
end

function BDM.GetDeviceAlias(indx)
  local A = BDM.GetDeviceType(indx)
  if A == BD_USB then return string.format("usb%d:/", indx)
  elseif A == BD_MX4SIO then return string.format("mx4sio%d:/", indx)
  elseif A == BD_ILINK then return string.format("ilink%d:/", indx)
  elseif A == BD_UDPBD then return string.format("udpbd%d:/", indx)
  else return string.format("mass%d:/", indx) end
end

function Special_tostring(VAL)
  if type(VAL) == "nil" then return LNG.LAB_NOT_SET
  elseif type(VAL) == "boolean" then if VAL then return "1" else return "0" end
  else
    return tostring(VAL)
  end
end

function Font.ftPrintMultiLineAligned(font, x, y, spacing, width, height, text, color)
  local internal_y = y
  for line in text:gmatch("([^\n]*)\n?") do
    Font.ftPrint(font, x, internal_y, 8, width, height, line, color)
    internal_y = internal_y+spacing
  end
end

function OnScreenError(STR)
  print("ERROR")
  print(STR)
  local Q = 0x40
  while true do
    Screen.clear()
    Font.ftPrint(_FNT_, X_MID, 40, 8, 630, 32, LNG.ERROR_LUA_EXT_SCRIPT, Color.new(255, 255, 255, 0x80))
    Graphics.drawRect(0, 60, SCR_X, Y_MID+40, Color.new(255, 0, 0, 0x40-Q))
    Graphics.drawRect(0, 60, SCR_X, 2, Color.new(255, 0, 0, 0x80))
    Font.ftPrintMultiLineAligned(_FNT2_, X_MID, 70, 20, 630, 32, STR,  Color.new(200, 200, 0, 0x80))
    Graphics.drawRect(0, Y_MID+100, SCR_X, 2, Color.new(0xff, 0, 0, 0x80))
    Font.ftPrintMultiLineAligned(_FNT2_, X_MID, Y_MID+120, 20, 630, 32, "Report to github.com/israpps/PS2BBL-Configurator/issues/", Color.new(255, 255, 255, 0x80))
    Screen.SpecialFlip(true)
    if Q > 0 then Q=Q-1 end
  end
end


function new_config_struct()
  local T = {
    keys = {},
    config = {
      SKIP_PS2LOGO = true,
      KEY_READ_WAIT_TIME = 4000,
      OSDHISTORY_READ = true,
      EJECT_TRAY =  true,
      LOGO_DISPLAY = 2,
      LOAD_IRX_E0 = nil,
      LOAD_IRX_E1 = nil,
      LOAD_IRX_E2 = nil,
      LOAD_IRX_E3 = nil,
      LOAD_IRX_E4 = nil,
      LOAD_IRX_E5 = nil,
      LOAD_IRX_E6 = nil,
    },
  }
  for i = 1, #PADBUTTONS do
    T.keys[i] = {}
    for x = 1, 3, 1 do
      T.keys[i][x] = nil
    end
  end
  return T
end

function replace_device(VAL, NEWDEV)
  local FINAL
  local niee = string.find(VAL, ":", 1, true)
  FINAL = NEWDEV..VAL:sub(niee)
    return FINAL
end


--- Processes a HDD full path into its components. (eg: `hdd0:__system:pfs:/osd110/hosdsys.elf`)
---@param PATH string
---@return string mountpart: will return partition path for mounting (`hdd0:__system`)
---@return string pfsindx: will return pfs index (`pfs:`)
---@return string filepath: will return path to file when partition gets mounted (`pfs:/osd110/hosdsys.elf`)
function GetMountData(PATH)
  local CNT = 0
  local TBL = {}
  for i in string.gmatch(PATH, "[^:]*") do
    table.insert(TBL, i)
    CNT = CNT+1
  end
  local mountpart = ""
  local pfsindx   = ""
  local filepath  = ""
  if CNT == 4 then
    mountpart = string.format("%s:%s", TBL[1], TBL[2])
    pfsindx   = string.format("%s:", TBL[3])
    filepath  = string.format("%s:%s", TBL[3], TBL[4])
  end
  return mountpart, pfsindx, filepath
end

function CheckPath(PATH)
  local pos = string.find(PATH, ":", 1, true)
  local DEV = PATH:sub(1, pos)
  local NEWPATH = PATH
  if DEV == "mx4sio:" then
    local indx = BDM.GetDeviceByType(BD_MX4SIO)
    if indx >= 0 then NEWPATH = replace_device(PATH, ("mass%d"):format(indx)) end
  elseif DEV == "ilink:" then
    local indx = BDM.GetDeviceByType(BD_ILINK)
    if indx >= 0 then NEWPATH = replace_device(PATH, ("mass%d"):format(indx)) end
  elseif DEV == "hdd0:" then
    local MountPart
    MountPart, _, NEWPATH = GetMountData(PATH)
    if GSTATE.HDD_LOADED == 1 then
      if System.MountHDDPartition(MountPart) ~= 0 then
        table.insert(Notif_queue.msg, LNG.ERROR_PART_MOUNT_FAIL..MountPart)
      end
    end
  --elseif DEV == "mc?:" then
  end
  return NEWPATH
end


PS2BBL_MAIN_CONFIG = new_config_struct()
print("LIP (Lua Ini Parser)\tCopyright (c) 2012 Carreras Nicolas. modified by El_isra for PS2BBL Usage");
--- INI handling functions
LIP = {
--- Returns a table containing all the data from the INI file.
---@param fileName string The name of the INI file to parse.
---@return table|nil data the table containing all data from the INI file. nil if an error ocurred
---@return integer error the error code in case an issue arised while reading
load = function (fileName)
  local data = new_config_struct()
  local ret = 0
  local FD = System.openFile(fileName, FREAD);
  local file
  if FD < 0 then
    print("LIP.load: Cannot open"..fileName)
    ret = -5
  else
    file = System.readFile(FD, System.sizeFile(FD));
    for line in file:gmatch('[^\n]+') do
      local param, value = line:match('^([%w|_]+)%s-=[ ]?%s-(.+)[\r\n]');
      -- TODO: CLEANUP --print(string.format("- '%s' = '%s'", param, value))
      if(param ~= nil and value ~= nil)then
        if param:find("^LK_.*_E[123]")then --Launch keys are special case. handle them as a structure, not as data pairs....
          for i = 1, #PADBUTTONS do
            if param:find("^LK_"..PADBUTTONS[i]) then
              for x = 1, 3, 1 do
                if param == string.format("LK_%s_E%d", PADBUTTONS[i], PADATTEMPT[x]) then
                  data.keys[i][x] = value
                  goto BRK
                end
              end
            end
          end
          print(string.format("Unknown Launch KEY ('%s' = '%s')", param, value))
          ::BRK::
        else
          if(tonumber(value))then
            value = tonumber(value);
          elseif(value == 'true')then
            value = true;
          elseif(value == 'false')then
            value = false;
          end
          data.config[param] = value;
        end
      end
    end
  end
  if FD >= 0 then System.closeFile(FD) end
  if ret < 0 then
    data = nil
    table.insert(Notif_queue.msg, string.format("Failed to read '%s'\nerror code: %d", fileName, ret))
  else
    table.insert(Notif_queue.msg, string.format("Successfully loaded from\n%s", fileName))
  end
  return data, ret
end;
--- Saves all the data from a table to an INI file.
---@param fileName string The name of the INI file to fill.
---@param data table|nil The table containing all the data to store.
save = function (fileName, data)
  if data == nil or data.config == nil or data.keys == nil then table.insert(Notif_queue.msg, "Config Save aborted: Config structure is NIL") end
  local FD = System.openFile(fileName, FCREATE);
  local contents = "";
  if (FD >= 0) then
    local subtbl = {}
    for key, value in pairs(data.config) do
      if not(key ~= nil and key ~= "") and (value ~= nil and value ~= "") then goto continue end
      if (key:sub(1,9) ~= "LOAD_IRX_") then
        contents = contents .. ('%s = %s\n'):format(key, Special_tostring(value))
      else
        table.insert(subtbl, key)
      end
        ::continue::
    end
    if #subtbl > 0 then
      table.sort(subtbl)
      contents = contents.."\n"
      for _, k in ipairs(subtbl) do
        if data.config[k] ~= nil and data.config[k] ~= "" then
          contents = contents .. ('%s = %s\n'):format(k, Special_tostring(data.config[k]))
        end
      end
    end
      contents = contents.."\n"
      for i = 1, #PADBUTTONS do
        for x = 1, 3, 1 do
          if data.keys[i][x] ~= nil then
            contents = contents .. ('LK_%s_E%d = %s\n'):format(PADBUTTONS[i], x, data.keys[i][x])
          end
        end
      end
    System.writeFile(FD, contents, string.len(contents));
    System.closeFile(FD);
    table.insert(Notif_queue.msg, string.format("Successfully saved to\n%s", fileName))
  else
    table.insert(Notif_queue.msg, string.format("Failed to save config to '%s'\nerr %d", fileName, FD))
  end
end;
}
--#region DrawUsableKeys
DUK_CROSS = (1 << 0)
DUK_CIRCLE = (1 << 1)
DUK_TRIANGLE = (1 << 2)
DUK_TRIANGLE_CMD = (1 << 3)|DUK_TRIANGLE
DUK_CIRCLE_GOBACK = (1 << 4)|DUK_CIRCLE
DUK_SQUARE = (1 << 5)
DUK_INTSLIDER = (1 << 6)
DUK_SELECT_CLEAR = (1 << 7)
DUK_START_SAVE = (1 << 8)
function DrawUsableKeys(FLAGS, alfa)
  if alfa == nil then alfa = 0x80 end
  local txcol, pngcol
  txcol = Color.new(255, 255, 255, alfa)
  pngcol = Color.new(128, 128, 129, alfa)
  if (FLAGS & DUK_CROSS) ~= 0 then
    Graphics.drawScaleImage(RES.cross, 30, SCR_Y-35, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, 60, SCR_Y-30, 0, 630, 16, "OK", txcol)
  end
  if (FLAGS & DUK_CIRCLE) ~= 0 then
    local MSG = FLAGS & DUK_CIRCLE_GOBACK and "Cancel" or "Go Back"
    Graphics.drawScaleImage(RES.circle, 30, SCR_Y-60, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, 60, SCR_Y-55, 0, 630, 16, MSG, txcol)
  end
  if (FLAGS & DUK_TRIANGLE) ~= 0 then
    local MSG = FLAGS & DUK_TRIANGLE_CMD and "Assign command" or "Quit"
    Graphics.drawScaleImage(RES.triangle, SCR_X-30, SCR_Y-60, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, SCR_X-60-(MSG:len()*5), SCR_Y-55, 4, 630, 16, MSG, txcol)
  end
  if (FLAGS & DUK_SQUARE) ~= 0 then
    local MSG = "Map to mc?:"
    Graphics.drawScaleImage(RES.square, SCR_X-30, SCR_Y-35, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, SCR_X-60-(MSG:len()*5), SCR_Y-30, 4, 630, 16, MSG, txcol)
  end
  if (FLAGS & DUK_INTSLIDER) ~= 0 then
    Graphics.drawScaleImage(RES.L1, 190, SCR_Y-60, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, 220, SCR_Y-55, 0, 630, 16, "-1000", txcol)

    Graphics.drawScaleImage(RES.R1, SCR_X-230, SCR_Y-60, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, SCR_X-270, SCR_Y-55, 4, 630, 16, "+1000", txcol)

    Graphics.drawScaleImage(RES.L2, 190, SCR_Y-35, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, 220, SCR_Y-30, 0, 630, 16, "-100", txcol)

    Graphics.drawScaleImage(RES.R2, SCR_X-230, SCR_Y-35, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, SCR_X-270, SCR_Y-30, 4, 630, 16, "+100", txcol)
  end
  if (FLAGS & DUK_SELECT_CLEAR) ~= 0 then
    Graphics.drawScaleImage(RES.select, 190, SCR_Y-60, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, 225, SCR_Y-55, 0, 630, 16, "clear", txcol)
  end
  if (FLAGS & DUK_START_SAVE) ~= 0 then
    Graphics.drawScaleImage(RES.start, SCR_X-230, SCR_Y-60, 32, 32, pngcol)
    Font.ftPrint(_FNT2_, SCR_X-265, SCR_Y-55, 4, 630, 16, "Save", txcol)
  end
end
--#endregion

MAIN_MENU = {
  item = {
    LNG.MAIN_MENU_LAB_LOAD_CONF,
    LNG.MAIN_MENU_LAB_SAVE_CONF,
    LNG.MAIN_MENU_LAB_LOAD_DEFS,
    LNG.MAIN_MENU_LAB_CONFIGURE,
    LNG.MAIN_MENU_LAB_ABOUT,
    LNG.MAIN_MENU_LAB_LAUNCHELF,
    LNG.MAIN_MENU_LAB_LAUNCHOSD,
  },
  desc = {
    LNG.MAIN_MENU_STR_LOAD_CONF,
    LNG.MAIN_MENU_STR_SAVE_CONF,
    LNG.MAIN_MENU_STR_LOAD_DEFS,
    LNG.MAIN_MENU_STR_CONFIGURE,
    LNG.MAIN_MENU_STR_ABOUT,
    LNG.MAIN_MENU_STR_LAUNCHELF,
    LNG.MAIN_MENU_STR_LAUNCHOSD,
  },
}

LOAD_CONF = {
  item = {
    "mc0:/PS2BBL/CONFIG.INI",
    "mc1:/PS2BBL/CONFIG.INI",
    "mass:/PS2BBL/CONFIG.INI",
    "mx4sio:/PS2BBL/CONFIG.INI",
    "hdd0:__sysconf:pfs:/PS2BBL/CONFIG.INI",
  },
  desc = {
    LNG.READ_CONF_FROM_MC0,
    LNG.READ_CONF_FROM_MC1,
    LNG.READ_CONF_FROM_USB,
    LNG.READ_CONF_FROM_MX4SIO,
    LNG.READ_CONF_FROM_IHDD,
  },
}
SAVE_CONF = {
  item = {
    "mc0:/PS2BBL/CONFIG.INI",
    "mc1:/PS2BBL/CONFIG.INI",
    "mass:/PS2BBL/CONFIG.INI",
    "mx4sio:/PS2BBL/CONFIG.INI",
    "hdd0:__sysconf/PS2BBL/CONFIG.INI",
  },
  desc = {
    LNG.SAVE_CONF_INTO_MC0,
    LNG.SAVE_CONF_INTO_MC1,
    LNG.SAVE_CONF_INTO_USB,
    LNG.SAVE_CONF_INTO_MX4SIO,
    LNG.SAVE_CONF_INTO_IHDD,
  },
}
PS2BBL_CMDS = {
  item = {
    "$CDVD",
    "$CDVD_NO_PS2LOGO",
    "$CREDITS",
    "$OSDSYS",
    "$HDDCHECKER",
  },
  desc = {
    LNG.PS2BBLCMD_STR_CDVD,
    LNG.PS2BBLCMD_STR_CDVD_NO_PS2LOGO,
    LNG.PS2BBLCMD_STR_CREDITS,
    LNG.PS2BBLCMD_STR_OSDSYS,
    LNG.PS2BBLCMD_STR_HDDCHECKER,
  },
}
MAIN_CONFIG_DLG = {
  item = {
    LNG.MAINCONFD_LAB_MNCONF,
    LNG.MAINCONFD_LAB_LKCONF,
  },
  desc = {
    LNG.MAINCONFD_STR_MNCONF,
    LNG.MAINCONFD_STR_LKCONF,
  },
}
--#region uicommon
function Drawbar(x, y, prog, col)
  Graphics.drawRect(x-(prog*2), y, prog*4, 5, col)
end
--0, 0xde, 0xf
function DisplayGenerictMOptPrompt(options_t, heading)
  local T = 1
  local D = 1
  local A = 0x80
  local TSIZE = #options_t.item
  while true do
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y)

    Font.ftPrint(_FNT_, 40, 40, 0, 630, 32, heading, Color.new(220, 220, 220, 0x80 - A))
    Graphics.drawRect(0, 60, SCR_X, 1, Color.new(255, 255, 255, 0x80-A))
    for i = 1, #options_t.item do
      if i == T then
        Font.ftPrint(_FNT2_, 60+1, 60+(i*20), 0, 630, 16, options_t.item[T], Color.new(0xff, 0xff, 0xff, 0x80 - A))
      else
        Font.ftPrint(_FNT2_, 60,   60+(i*20), 0, 630, 16, options_t.item[i], Color.new(0xff, 0xff, 0xff, 0x70 - A))
      end
    end
    Graphics.drawRect(0, 330, SCR_X, 1, Color.new(0xff, 0xff, 0xff, 0x80-A))
    if options_t.desc ~= nil then
      Font.ftPrint(_FNT2_, 80, 350, 0, 600, 32, options_t.desc[T], Color.new(0x70, 0x70, 0x70, 0x70 - A))
    end
  DrawUsableKeys(DUK_CIRCLE|DUK_CROSS)
    if A > 0 then A = A - 1 end
    Screen.SpecialFlip(true)
    pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      D = 1
      Screen.clear()
      break
    end

    if Pads.check(pad, PAD_CIRCLE) and D == 0 then
      T = 0
      break
    end

    if Pads.check(pad, PAD_UP) and D == 0 then
      T = T - 1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then
      T = T + 1
      D = 1
    end
    if D > 0 then D = D + 1 end
    if D > 10 then D = 0 end
    if T < 1 then T = TSIZE end
    if T > TSIZE then T = 1 end
  end
  return T
end

function DisplayGenerictMOptPromptDiag(options_t, heading, draw_callback, AVAILPADS)
  local T = 1
  local D = 15
  local A = 0x80
  pad = 0
  local TSIZE = #options_t.item
  while true do
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y)
    if draw_callback ~= nil then draw_callback(0) end
    Graphics.drawRect(0, 81, SCR_X, 379-81, Color.new(0, 0, 0, 50-A))
    Font.ftPrint(_FNT_, 40, 60, 0, 630, 32, heading, Color.new(220, 220, 220, 0x80 - A))
    Graphics.drawRect(0, 80, SCR_X, 1, Color.new(255, 255, 255, 0x80-A))
    Graphics.drawRect(0, 380, SCR_X, 1, Color.new(0xff, 0xff, 0xff, 0x80-A))
    for i = 1, #options_t.item do
      if i == T then
        Font.ftPrint(_FNT2_, 60+1, 70+(i*20), 0, 630, 16, options_t.item[i], Color.new(0xff, 0xff, 0xff, 0x80 - A))
      else
        Font.ftPrint(_FNT2_, 60, 70+(i*20), 0, 630, 16, options_t.item[i], Color.new(0xff, 0xff, 0xff, 0x70 - A))
      end
    end
    if options_t.desc ~= nil then
      Font.ftPrint(_FNT2_, 80, 370, 0, 600, 32, options_t.desc[T], Color.new(0x70, 0x70, 0x70, 0x70 - A))
    end
    DrawUsableKeys(AVAILPADS)
    if A > 0 then
      A = A - 1
    else
      pad = Pads.get()
    end
    Screen.SpecialFlip(true)

    if D == 0 then
      if (Pads.check(pad, PAD_CROSS) or
      (Pads.check(pad, PAD_TRIANGLE) and AVAILPADS&DUK_TRIANGLE) or
      (Pads.check(pad, PAD_SELECT) and AVAILPADS&DUK_SELECT_CLEAR) or
      (Pads.check(pad, PAD_SELECT) and AVAILPADS&DUK_TRIANGLE) or
      (Pads.check(pad, PAD_SQUARE) and AVAILPADS&DUK_SQUARE))
      then
        D = 1
        Screen.clear()
        break
      end

      if Pads.check(pad, PAD_CIRCLE) then
        T = 0
        break
      end

      if Pads.check(pad, PAD_UP) then
        T = T - 1
        D = 1
      elseif Pads.check(pad, PAD_DOWN) then
        T = T + 1
        D = 1
      end
    end

    if D > 0 then D = D + 1 end
    if D > 10 then D = 0 end
    if T < 1 then T = TSIZE end
    if T > TSIZE then T = 1 end
  end
  return T, pad
end

function DisplayGenericYES_NO_Prompt(MESSAGE)
  local T = false
  local D = 1
  local A = 0x80
  while true do
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y)
    Graphics.drawRect(0, Y_MID-60, SCR_X, 120, Color.new(0, 0, 0, 50-A))
    Font.ftPrintMultiLineAligned(_FNT_, X_MID, Y_MID-30, 20, 630, 16, MESSAGE, Color.new(0xff, 0xff, 0xff, 0x80 - A))
    Graphics.drawRect(0, Y_MID-60, SCR_X, 2, Color.new(255, 255, 255, 0x80-A))
    Graphics.drawRect(0, Y_MID+60, SCR_X, 2, Color.new(0xff, 0xff, 0xff, 0x80-A))

    DrawUsableKeys(DUK_CIRCLE|DUK_CROSS)
    if A > 0 then A = A - 1 end
    Screen.SpecialFlip(true)
    pad = Pads.get()
    if D == 0 then
      if Pads.check(pad, PAD_CROSS) then
        T = true
        Screen.clear()
        break
      end

      if Pads.check(pad, PAD_CIRCLE) then
        T = false
        break
      end
    end

    if D > 0 then D = D + 1 end
    if D > 10 then D = 0 end
  end
  return T
end

function IntSlider(is_milisecond, VAL, heading)
  local origval = VAL
  local QUIT = false
  if heading == nil then heading = "" end
  local D = 1
  while not QUIT do
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y)
    Graphics.drawRect(0, Y_MID-30, SCR_X, 60, Color.new(0, 0, 0, 50))
    Font.ftPrint(_FNT_, X_MID, Y_MID-60, 8, 630, 32, heading, Color.new(220, 220, 220, 0x80))
    Graphics.drawRect(0, Y_MID-30, SCR_X, 1, Color.new(255, 255, 255, 0x80))
    Graphics.drawRect(0, Y_MID+30, SCR_X, 1, Color.new(255, 255, 255, 0x80))
    Font.ftPrint(_FNT_, X_MID, Y_MID, 8, 630, 32, VAL, Color.new(220, 220, 220, 0x80))

    DrawUsableKeys(DUK_INTSLIDER|DUK_CIRCLE|DUK_CROSS)
    Screen.SpecialFlip(true)
    pad = Pads.get()
    if Pads.check(pad, PAD_CROSS) and D==0 then
      return VAL
    end
    if Pads.check(pad, PAD_CIRCLE) and D==0 then
      return origval
    end
    if Pads.check(pad, PAD_R1) and D==0 then
      D=1
      VAL = VAL+1000
    end
    if Pads.check(pad, PAD_R2) and D==0 then
      D=1
      VAL = VAL+100
    end
    if Pads.check(pad, PAD_L1) and D==0 then
      D=1
      VAL = VAL-1000
    end
    if Pads.check(pad, PAD_L2) and D==0 then
      D=1
      VAL = VAL-100
    end
    if D >= 10 then D=0 else D = D+1 end
    if VAL < 0 then VAL = 0 end
    if VAL > 10000 then VAL = 10000 end
  end
end

function GenericBGFade(fadein, allow_notif)
  local A = 0x79
  if fadein then A = 1 end
  while A < 0x80 and A > 0 do
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y, Color.new(0x80, 0x80, 0x80, A))
    Screen.SpecialFlip(allow_notif)
    if fadein then A = A+1 else A = A-1 end
  end
end
--#endregion

-----------
OFM = {
ofmRoundSize = function (inputValue)
  roundValue=inputValue*10
  roundTempValueA,roundTempValueB = math.modf(roundValue/1)
  roundValue= 1 * (roundTempValueA + (roundTempValueB > 0.5 and 1 or 0))
  roundValue=roundValue/10
  return roundValue
end;
-- check pad up/down
checkPadUpDown = function ()
  if Pads.check(OFM.paad, PAD_UP) then
    PadUpHolding=PadUpHolding+1
  else
    PadUpHolding=0
  end
  if Pads.check(OFM.paad, PAD_DOWN) then
    PadDownHolding=PadDownHolding+1
  else
    PadDownHolding=0
  end
  if PadUpHolding == 1 then
    OFM.ofmSelectedItem = OFM.ofmSelectedItem - 1
  elseif PadUpHolding >= OFM.ofmWaitBeforeScroll then
    for nr = 2, 512 do
      nra = nr*OFM.ofmScrollDelay
      if PadUpHolding == nra then
        OFM.ofmSelectedItem = OFM.ofmSelectedItem - 1
      end
    end
  end
  if PadDownHolding == 1 then
    OFM.ofmSelectedItem = OFM.ofmSelectedItem + 1
  elseif PadDownHolding >= OFM.ofmWaitBeforeScroll then
    for nr = 2, 512 do
      nra = nr*OFM.ofmScrollDelay
      if PadDownHolding == nra then
        OFM.ofmSelectedItem = OFM.ofmSelectedItem + 1
      end
    end
  end

  if OFM.ofmSelectedItem <= 0 then
    OFM.ofmSelectedItem = 1
  end
  if OFM.ofmSelectedItem > ofmItemTotal then
    OFM.ofmSelectedItem = ofmItemTotal
  end
end;
-- refresh files list -- directory to list / list files in directory (true) or mount paths (false)
refreshFileList = function (directory, tempmode)
  if tempmode == false then
    ofmItemTotal = 0
    OFM.ofmSelectedItem = 1
    ofmItem = nil;
    ofmItem = {};

    -- MEMORY CARD 1
    mctypea = System.getMCInfo(0)
    if mctypea.type == 2 and mctypea.format == 1 then
      ofmItemTotal=ofmItemTotal+1
      ofmItem[ofmItemTotal] = {};
      ofmItem[ofmItemTotal].Name = "mc0:/" -- displayed name
      ofmItem[ofmItemTotal].Type = "folder" -- "file" or "folder"
      ofmItem[ofmItemTotal].Dir = "mc0:/" -- directory (path)
      ofmItem[ofmItemTotal].Size = string.format("%.1fMb Free", mctypea.freemem/1024)
    end

    -- MEMORY CARD 2
    mctypeb = System.getMCInfo(1)
    if mctypeb.type == 2 and mctypeb.format == 1 then
      ofmItemTotal=ofmItemTotal+1
      ofmItem[ofmItemTotal] = {};
      ofmItem[ofmItemTotal].Name = "mc1:/"
      ofmItem[ofmItemTotal].Type = "folder"
      ofmItem[ofmItemTotal].Dir = "mc1:/"
      ofmItem[ofmItemTotal].Size = string.format("%.1fMb Free", mctypeb.freemem/1024)
    end

    -- HDD
    if System.doesDirectoryExist("hdd0:/") and GSTATE.ALLOW_HDD_BROWSING then
      ofmItemTotal=ofmItemTotal+1
      ofmItem[ofmItemTotal] = {};
      ofmItem[ofmItemTotal].Name = "hdd0:/"
      ofmItem[ofmItemTotal].Type = "folder"
      ofmItem[ofmItemTotal].Dir = "hdd0:/"
      ofmItem[ofmItemTotal].Size = ""
    end

    -- CD/DVD
    if System.doesDirectoryExist("cdfs:/") then
      ofmItemTotal=ofmItemTotal+1
      ofmItem[ofmItemTotal] = {};
      ofmItem[ofmItemTotal].Name = "cdfs:/"
      ofmItem[ofmItemTotal].Type = "folder"
      ofmItem[ofmItemTotal].Dir = "cdfs:/"
      ofmItem[ofmItemTotal].Size = ""
    end

    -- MASS
    for i = 0, 10, 1 do
      local bdbd = string.format("mass%d:/", i)
      if System.doesDirectoryExist(bdbd) then
        ofmItemTotal=ofmItemTotal+1
        ofmItem[ofmItemTotal] = {};
        ofmItem[ofmItemTotal].Name = BDM.GetDeviceAlias(i)
        ofmItem[ofmItemTotal].Type = "folder"
        ofmItem[ofmItemTotal].Dir = bdbd
        ofmItem[ofmItemTotal].Size = ""
      end
    end

    -- HOST
    if System.doesDirectoryExist("host:/") then
      ofmItemTotal=ofmItemTotal+1
      ofmItem[ofmItemTotal] = {};
      ofmItem[ofmItemTotal].Name = "host:/"
      ofmItem[ofmItemTotal].Type = "folder"
      ofmItem[ofmItemTotal].Dir = "host:/"
      ofmItem[ofmItemTotal].Size = ""
    end
  else
    ofmItemTotal=1
    OFM.ofmSelectedItem=1
    listdir = nil
    listdir = System.listDirectory(directory)
    if listdir == nil then table.insert(Notif_queue.msg, string.format(LNG.OFM_ERROR_LISTING_FILES, directory)) return end
    ofmItemTotal = #listdir
    ofmItem = nil;
    ofmItem = {};
    if not System.doesDirectoryExist(directory) then
      ofmItem[1] = {};
      ofmItem[1].Name = ".."
      ofmItem[1].Type = ""
      ofmItem[1].Size = ""
    else
      for nr = 1, ofmItemTotal do
        ofmItem[nr] = {};
        ofmItem[nr].Name = listdir[nr].name
        ofmItem[nr].Size = ""
        if listdir[nr].PartitionType ~= nil then --if enceladus has update from El_isra for partition type...
          if listdir[nr].PartitionType ~= 0x0100 then -- check for PFS Partition ONLY
            ofmItem[nr].Name = "."
          else
            ofmItem[nr].Size = System.GetPFSPartitionFreeSpace("hdd0:"..listdir[nr].name, 1) / 1048576
            ofmItem[nr].Size = OFM.ofmRoundSize(OFM.ofmRoundSize(ofmItem[nr].Size))
            ofmItem[nr].Size = ofmItem[nr].Size.." MB"
          end
        end
        if directory == "mc0:/" or directory == "mc1:/" then
          ofmItem[nr].Type = "folder"
          ofmItem[nr].Dir = ofmItem[nr].Name.."/"
          ofmItem[nr].Name = ofmItem[nr].Dir
        elseif directory == "hdd0:/" then
          ofmItem[nr].Type = "folder"
          ofmItem[nr].Dir = ofmItem[nr].Name
          ofmItem[nr].Name = ofmItem[nr].Dir
        else
          if doesFileExist(directory..ofmItem[nr].Name) then
            ofmItem[nr].Type = "file"
            ofmItem[nr].Size = listdir[nr].size
            if ofmItem[nr].Size <= 4096 then
              ofmItem[nr].Size = OFM.ofmRoundSize(ofmItem[nr].Size)
              ofmItem[nr].Size = ofmItem[nr].Size.." B"
            elseif ofmItem[nr].Size >= 4096 and ofmItem[nr].Size <= 1048576 then
              ofmItem[nr].Size = ofmItem[nr].Size / 1024
              ofmItem[nr].Size = OFM.ofmRoundSize(ofmItem[nr].Size)
              ofmItem[nr].Size = ofmItem[nr].Size.." KB"
            elseif ofmItem[nr].Size >= 1048576 then
              ofmItem[nr].Size = ofmItem[nr].Size / 1048576
              ofmItem[nr].Size = OFM.ofmRoundSize(ofmItem[nr].Size)
              ofmItem[nr].Size = ofmItem[nr].Size.." MB"
            end
          else
            ofmItem[nr].Type = "folder"
            ofmItem[nr].Dir = ofmItem[nr].Name.."/"
            ofmItem[nr].Name = ofmItem[nr].Dir
          end
        end
      end

      -- removing ".", ".." and "" items:
      ofmItemOld=ofmItem
      ofmItem=nil
      ofmItem={}
      tempItemCount=0
      for i = 1, #ofmItemOld do
        if ofmItemOld[i].Name ~= "." and ofmItemOld[i].Name ~= ".." and ofmItemOld[i].Name ~= "" and ofmItemOld[i].Name ~= "./" and ofmItemOld[i].Name ~= "../" and ofmItemOld[i].Name ~= "/" then
          tempItemCount=tempItemCount+1
          ofmItem[tempItemCount]={}
          ofmItem[tempItemCount].Name = ofmItemOld[i].Name
          ofmItem[tempItemCount].Type = ofmItemOld[i].Type
          ofmItem[tempItemCount].Dir = ofmItemOld[i].Dir
          ofmItem[tempItemCount].Size = ofmItemOld[i].Size
        end
      end
      ofmItemOld=nil
      ofmItemTotal = tempItemCount
      if ofmItemTotal == 0 then
        ofmItem[1] = {};
        ofmItem[1].Name = ".."
        ofmItem[1].Type = ""
        ofmItem[1].Size = ""
      end

      -- sorting items
      if ofmItemTotal >= 2 then
        for i = 1, ofmItemTotal do
          if ofmItem[i].Type == "file" then
            ofmItem[i].TypeAndName = "F"..ofmItem[i].Name
          else
            ofmItem[i].TypeAndName = "D"..ofmItem[i].Name
          end
        end
      end
      table.sort(ofmItem, function (TempTabA, TempTabB) return TempTabA.TypeAndName < TempTabB.TypeAndName end)
    end
  end
end;
-- displaying list of files
listFiles = function ()
  OFM.AdjustY = 0
  if OFM.ofmSelectedItem < 15 then
    ofmItemTotalB=OFM.ofmSelectedItem+24
    if ofmItemTotalB > ofmItemTotal then
      ofmItemTotalB = ofmItemTotal
    end
  else
    ofmItemTotalB=OFM.ofmSelectedItem+6
    if ofmItemTotalB > ofmItemTotal then
      ofmItemTotalB = ofmItemTotal
    end
  end
  if ofmItemTotal > 15 then
    if OFM.ofmSelectedItem >= 14 then
      TempA = OFM.ofmSelectedItem - 14
      TempB = -25
      OFM.AdjustY = TempA*TempB
    end
    if OFM.ofmSelectedItem >= 14 and OFM.ofmSelectedItem == ofmItemTotal then
      TempA = OFM.ofmSelectedItem - 15
      TempB = -25
      OFM.AdjustY = TempA*TempB
    end
  end
  TempC = 1
  if ofmItemTotal > 15 then
    if OFM.ofmSelectedItem == ofmItemTotal and OFM.ofmSelectedItem > 14 then
      TempC = OFM.ofmSelectedItem-14
    elseif OFM.ofmSelectedItem > 13 then
      TempC = OFM.ofmSelectedItem-13
    end
  end
  for nr = TempC, ofmItemTotalB do
    TempY=OFM.AdjustY+60+nr*25
    local TMPCOL
    if nr ~= OFM.ofmSelectedItem then TMPCOL = OFM.COLOR_SELECTIONBAR else TMPCOL = OFM.COLOR_LIST end
    Font.ftPrint(fontBig, 16, TempY, 0, 500, 64, ofmItem[nr].Name, TMPCOL)
    Font.ftPrint(fontBig, 548, TempY, 0, 500, 64, ofmItem[nr].Size, TMPCOL)
  end
end;
-- entering selected directory
enterSelectedDirectory = function ()
  if ofmItem[OFM.ofmSelectedItem].Name ~= "." and ofmItem[OFM.ofmSelectedItem].Name ~= ".." and OFM.ofmCurrentPath ~= "hdd0:/" then
    if System.doesDirectoryExist(OFM.ofmCurrentPath..ofmItem[OFM.ofmSelectedItem].Dir) then
      OFM.ofmFolder[0] = OFM.ofmFolder[0]+1
      OFM.ofmFolder[OFM.ofmFolder[0]] = ofmItem[OFM.ofmSelectedItem].Dir
      OFM.ofmCurrentPath = ""
      for i = 1, OFM.ofmFolder[0] do
        OFM.ofmCurrentPath=OFM.ofmCurrentPath..OFM.ofmFolder[i]
      end
      OFM.refreshFileList(OFM.ofmCurrentPath, true)
    end
  elseif OFM.ofmCurrentPath == "hdd0:/" then
    if System.MountHDDPartition("hdd0:"..ofmItem[OFM.ofmSelectedItem].Dir, 0, FIO_MT_RDONLY) == 0 then
      OFM.lastMountedPartition = ofmItem[OFM.ofmSelectedItem].Dir
      OFM.ofmCurrentPath = "pfs:/"
      OFM.ofmFolder[0] = 1
      OFM.ofmFolder[1] = "pfs:/"
      OFM.enterSelectedDirectory()
      OFM.refreshFileList(OFM.ofmCurrentPath, true)
    else
      OFM.lastMountedPartition = nil
      table.insert(Notif_queue, LNG.ERROR_PART_MOUNT_FAIL..ofmItem[OFM.ofmSelectedItem].Dir)
    end
  end
end;
-- go back from selected directory
goBackFromDirectory = function ()
  if OFM.ofmCurrentPath == "pfs:/" then
    System.UnMountHDDPartition(0)
    OFM.lastMountedPartition = nil
  end
  if OFM.ofmFolder[0] == 1 then
    OFM.ofmFolder[0] = 0
    OFM.ofmFolder[1] = ""
    OFM.ofmCurrentPath=""
    OFM.refreshFileList(OFM.ofmCurrentPath, false)
  else
    OFM.ofmFolder[OFM.ofmFolder[0]] = ""
    OFM.ofmFolder[0] = OFM.ofmFolder[0]-1
    OFM.ofmCurrentPath = ""
        for i = 1, OFM.ofmFolder[0] do
            OFM.ofmCurrentPath=OFM.ofmCurrentPath..OFM.ofmFolder[i]
        end
    OFM.refreshFileList(OFM.ofmCurrentPath, true)
    for i = 1, #ofmItem do
      if ofmItem[i].Dir == OFM.ofmFolder[OFM.ofmFolder[0]] then
        OFM.ofmSelectedItem = i
      end
    end
    end
end;
-- draw overlay
drawOFMoverlay = function ()
  Font.ftPrint(fontSmall, 16, plusYValue+51, 0, 704, 64, OFM.ofmCurrentPath, OFM.COLOR_LIST)
    Graphics.drawRect(0, 71, SCR_X, 1, Color.new(255, 255, 255, 0x80))
end;
_start = function ()
  OFM.lastMountedPartition = nil
  OFM.ofmScrollDelay=4
  OFM.ofmWaitBeforeScroll=14
  OFM.COLOR_LIST=Color.new(255,255,255,128)
  OFM.COLOR_SELECTIONBAR=Color.new(255,255,255,40)
  OFM.ofmCurrentPath = ""
  OFM.refreshFileList("", false)
  OFM.ofmSelectedItem=1
  OFM.ofmFolder={}
  OFM.ofmFolder[0]=0
  OFM.AdjustY=0
  OFM.keepInOFMApp=true
  if plusYValue == nil then plusYValue=0 end
  local ret = nil
  OFM.paad = 0
  OFM.oldpad = 0
  OFM.first_roll = true
  while OFM.keepInOFMApp do
  if not OFM.first_roll then OFM.paad = Pads.get() else OFM.first_roll = false end
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y, Color.new(0x80, 0x80, 0x80, 0x80))
    OFM.drawOFMoverlay() -- draws overlay
      if ofmItemTotal >= 1 then
        OFM.checkPadUpDown() -- check up/down buttons
      end
    OFM.listFiles() -- print list of items
      if Pads.check(OFM.paad, PAD_CROSS) and not Pads.check(OFM.oldpad, PAD_CROSS) then
          -- enter directory
          if ofmItem[OFM.ofmSelectedItem].Type == "folder" then
              OFM.enterSelectedDirectory()
          elseif ofmItem[OFM.ofmSelectedItem].Name ~= "." and ofmItem[OFM.ofmSelectedItem].Name ~= ".." then
            ret = OFM.ofmCurrentPath..ofmItem[OFM.ofmSelectedItem].Name
            if OFM.lastMountedPartition ~= nil and string.sub(OFM.ofmCurrentPath, 1, 5) == "pfs:/" then
              ret = string.format("hdd0:%s:%s", OFM.lastMountedPartition, ret)
            end
            goto GETLOST
          end
      end
      if Pads.check(OFM.paad, PAD_CIRCLE) and not Pads.check(OFM.oldpad, PAD_CIRCLE) then
          if OFM.ofmFolder[0] >= 1 then
              OFM.goBackFromDirectory()
          else
              OFM.keepInOFMApp=false
              ret = nil
          end
      end
      if Pads.check(OFM.paad, PAD_TRIANGLE) and not Pads.check(OFM.oldpad, PAD_TRIANGLE) then
          OFM.keepInOFMApp=false
          ret = nil
      end
      Screen.waitVblankStart()
      OFM.oldpad = OFM.paad;
      Screen.SpecialFlip(true)
  end
  ::GETLOST::
  OFM.ofmFolder=nil
  OFM.ofmCurrentPath = ""
  ofmItem=nil
  return ret
end
}
-----------

function call_script(SCRIPT)
    local A, ERR = dofile_protected(SCRIPT);
  if not A then OnScreenError(ERR) end
end

function Configure_PS2BBL_opts()
  local T = 1
  local D = 1
  local A = 0x80
  local heading = "PS2BBL Settings"
  local options_t = {
    item = {
      "SKIP_PS2LOGO",
      "KEY_READ_WAIT_TIME",
      "OSDHISTORY_READ",
      "EJECT_TRAY",
      "LOGO_DISPLAY",
      "LOAD_IRX_E0",
      "LOAD_IRX_E1",
      "LOAD_IRX_E2",
      "LOAD_IRX_E3",
      "LOAD_IRX_E4",
      "LOAD_IRX_E5",
      "LOAD_IRX_E6",
    },
    desc = {
      LNG.MAINCONFP_STR_PS2LOG,
      LNG.MAINCONFP_STR_WAITIM,
      LNG.MAINCONFP_STR_LGOCOL,
      LNG.MAINCONFP_STR_DISCTR,
      LNG.MAINCONFP_STR_LGODIS,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
      LNG.MAINCONFP_STR_IRXLDR,
    },
    ptr = {
      PS2BBL_MAIN_CONFIG.config.SKIP_PS2LOGO,
      PS2BBL_MAIN_CONFIG.config.KEY_READ_WAIT_TIME,
      PS2BBL_MAIN_CONFIG.config.OSDHISTORY_READ,
      PS2BBL_MAIN_CONFIG.config.EJECT_TRAY,
      PS2BBL_MAIN_CONFIG.config.LOGO_DISPLAY,
      PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E0,
      PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E1,
      PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E2,
      PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E3,
      PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E4,
      PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E5,
      PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E6,
    }
  }
  local TSIZE = #options_t.item
  while true do
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y)

    Font.ftPrint(_FNT_, 40, 40, 0, 630, 32, heading, Color.new(220, 220, 220, 0x80 - A))
    Graphics.drawRect(0, 60, SCR_X, 1, Color.new(255, 255, 255, 0x80-A))
    for i = 1, #options_t.item do
      local MSGG = options_t.item[i].." = "..Special_tostring(options_t.ptr[i])
      if i == T then
        Font.ftPrint(_FNT2_, 60+1, 60+(i*20), 0, 630, 16, MSGG, Color.new(0xff, 0xff, 0xff, 0x80 - A))
      else
        Font.ftPrint(_FNT2_, 60, 60+(i*20), 0, 630, 16, MSGG, Color.new(0xff, 0xff, 0xff, 0x70 - A))
      end
    end
    Graphics.drawRect(0, 330, SCR_X, 1, Color.new(0xff, 0xff, 0xff, 0x80-A))
    if options_t.desc ~= nil then
      Font.ftPrint(_FNT2_, 80, 350, 0, 600, 64, options_t.desc[T], Color.new(0x70, 0x70, 0x70, 0x70 - A))
    end
    DrawUsableKeys(T > 5 and (DUK_CIRCLE_GOBACK|DUK_CROSS|DUK_SQUARE|DUK_SELECT_CLEAR|DUK_START_SAVE) or (DUK_CIRCLE_GOBACK|DUK_CROSS|DUK_START_SAVE))
    if A > 0 then A = A - 1 end
    Screen.SpecialFlip(true)
    pad = Pads.get()

    if Pads.check(pad, PAD_CROSS) and D == 0 then
      D = 1
      pad = 0
      if T == 1 then options_t.ptr[T] = not options_t.ptr[T]
      elseif T == 2 then local wololo = IntSlider(true, options_t.ptr[T], options_t.item[T]) if wololo ~= nil then options_t.ptr[T] = wololo end
      elseif T == 3 then options_t.ptr[T] = not options_t.ptr[T]
      elseif T == 4 then options_t.ptr[T] = not options_t.ptr[T]
      elseif T == 5 then options_t.ptr[T] = options_t.ptr[T]+1 if options_t.ptr[T] > 2 then options_t.ptr[T] = 0 end
      else
    D = 1
        local path = OFM._start()
        pad = 0
        if path ~= nil and path ~= "" then options_t.ptr[T] = path end
      end
    end

    if (Pads.check(pad, PAD_CIRCLE) or Pads.check(pad, PAD_START)) and D == 0 then
      if Pads.check(pad, PAD_START) then
        PS2BBL_MAIN_CONFIG.config.SKIP_PS2LOGO = options_t.ptr[1]
        PS2BBL_MAIN_CONFIG.config.KEY_READ_WAIT_TIME = options_t.ptr[2]
        PS2BBL_MAIN_CONFIG.config.OSDHISTORY_READ = options_t.ptr[3]
        PS2BBL_MAIN_CONFIG.config.EJECT_TRAY = options_t.ptr[4]
        PS2BBL_MAIN_CONFIG.config.LOGO_DISPLAY = options_t.ptr[5]
        PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E0 = options_t.ptr[6]
        PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E1 = options_t.ptr[7]
        PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E2 = options_t.ptr[8]
        PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E3 = options_t.ptr[9]
        PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E4 = options_t.ptr[10]
        PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E5 = options_t.ptr[11]
        PS2BBL_MAIN_CONFIG.config.LOAD_IRX_E6 = options_t.ptr[12]
      end
      T = 0
      break
    end
    if Pads.check(pad, PAD_SQUARE) and D == 0 and T > 5 then
      D = 1
      pad = 0
      local path = OFM._start()
      pad = 0
      if path ~= nil and path ~= "" then options_t.ptr[T] = replace_device(path, "mc?") end
    end
    if Pads.check(pad, PAD_SELECT) and D == 0 and T > 5 then
      D = 1
      options_t.ptr[T] = nil
    end

    if Pads.check(pad, PAD_UP) and D == 0 then
      T = T - 1
      D = 1
    elseif Pads.check(pad, PAD_DOWN) and D == 0 then
      T = T + 1
      D = 1
    end
    if D > 0 then D = D + 1 end
    if D > 10 then D = 0 end
    if T < 1 then T = TSIZE end
    if T > TSIZE then T = 1 end
  end
  return T
end

function FollowThatTrainCJ()
  local PATH = OFM._start()
  if PATH ~= nil or PATH ~= "" then
    if doesFileExist(PATH) then System.loadELF(PATH) end
  end
end

function Credits()
  local Q = 0x80
  local goinorcomin = true
  while true do
    pad = Pads.get()
    Screen.clear()
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y)
    Font.ftPrint(_FNT_, X_MID, 40, 8, 630, 32, LNG.MAIN_MENU_PROMPT, Color.new(255, 255, 255, 0x80-Q))
    Graphics.drawRect(0, 60, SCR_X, Y_MID+100, Color.new(0, 0, 0, 0x40-Q))
    Graphics.drawRect(0, 60, SCR_X, 2, Color.new(255, 255, 255, 0x80-Q))
    Font.ftPrintMultiLineAligned(_FNT_, X_MID, 70, 25, 630, 32, LNG.CREDITSDL_STR_FULL,  Color.new(200, 200, 200, 0x80-Q))
    Graphics.drawRect(0, Y_MID+160, SCR_X, 2, Color.new(255, 255, 255, 0x80-Q))
    DrawUsableKeys(DUK_CIRCLE_GOBACK)
    Screen.SpecialFlip(true)
    if Pads.check(pad, PAD_CIRCLE) then goinorcomin = false end
    if goinorcomin then
      if Q > 0 then Q=Q-1 end
    else
      if Q < 0x80 then Q=Q+1 else return end
    end
  end
end
--PROGRAM BEHAVIOR BEGINS
if doesFileExist("lang.lua") then call_script("lang.lua") end
GenericBGFade(true, nil)
if doesFileExist("main.lua") then call_script("main.lua") end
while true do
  local aret = 0
  local sret = 0
  aret = DisplayGenerictMOptPrompt(MAIN_MENU, LNG.MAIN_MENU_PROMPT.." - CLOSED BETA 1")
  if aret == 1 then
    sret = DisplayGenerictMOptPrompt(LOAD_CONF, MAIN_MENU.item[aret])
    if sret ~= 0 then
      Check_device_ld(sret)
      local sub_PS2BBL_MAIN_CONFIG = LIP.load(CheckPath(LOAD_CONF.item[sret]))
      if sub_PS2BBL_MAIN_CONFIG ~= nil then
        PS2BBL_MAIN_CONFIG = sub_PS2BBL_MAIN_CONFIG
        GSTATE.CONFIG_LOADSTATE = 0
      else
        GSTATE.CONFIG_LOADSTATE = -1
      end
    end
  elseif aret == 2 then
    if GSTATE.CONFIG_LOADSTATE < 0 then
      if not DisplayGenericYES_NO_Prompt(LNG.WARN_EMPTY_CONF_SAVE) then
        goto BRK_C2
      end
    end
    sret = DisplayGenerictMOptPrompt(SAVE_CONF, MAIN_MENU.item[aret])
    Check_device_ld(sret)
    if sret ~= 0 then
      LIP.save(CheckPath(LOAD_CONF.item[sret]), PS2BBL_MAIN_CONFIG)
    end
    ::BRK_C2::
  elseif aret == 3 then
    PS2BBL_MAIN_CONFIG = new_config_struct()
    PS2BBL_MAIN_CONFIG.keys[16][1] = "mass:/APPS/OPNPS2LD.ELF"
    PS2BBL_MAIN_CONFIG.keys[16][2] = "mc?:/APPS/OPNPS2LD.ELF"
    PS2BBL_MAIN_CONFIG.keys[16][3] = "mc?:/OPL/OPNPS2LD.ELF"
    PS2BBL_MAIN_CONFIG.keys[16][3] = "mc?:/OPL/OPNPS2LD.ELF"
    PS2BBL_MAIN_CONFIG.keys[3][1]  = "mc?:/BOOT/ULE.ELF"
    PS2BBL_MAIN_CONFIG.keys[3][2]  = "mc?:/APPS/ULE.ELF"
    PS2BBL_MAIN_CONFIG.keys[3][3]  = "mc?:/BOOT/BOOT.ELF"
    PS2BBL_MAIN_CONFIG.keys[9][1]  = "rom0:TESTMODE"
    PS2BBL_MAIN_CONFIG.keys[10][1] = "$OSDSYS"
    PS2BBL_MAIN_CONFIG.config.SKIP_PS2LOGO = true
    PS2BBL_MAIN_CONFIG.config.KEY_READ_WAIT_TIME = 4000
    PS2BBL_MAIN_CONFIG.config.OSDHISTORY_READ = true
    PS2BBL_MAIN_CONFIG.config.EJECT_TRAY = true
    PS2BBL_MAIN_CONFIG.config.LOGO_DISPLAY = 2
    GSTATE.CONFIG_LOADSTATE = 0
  elseif aret == 4 then
    sret = DisplayGenerictMOptPrompt(MAIN_CONFIG_DLG, MAIN_MENU.item[aret])
    if sret ~= 0 then
      if sret == 1 then
        Configure_PS2BBL_opts()
      elseif sret == 2 then
        call_script("pads/pads.lua")
      end
    end
  elseif aret == 5 then
    Credits()
  elseif aret == 6 then
    FollowThatTrainCJ()
  elseif aret == 7 then
    System.exitToBrowser()
  end
end
