
local GAMEDB = {}
GAMEDB = require("db")
Font.ftInit()
MFONT = Font.ftLoad("MFONT")
SFONT = Font.ftLoad("MFONT")
LFONT = Font.ftLoad("MFONT")
Font.ftSetCharSize(MFONT, 800, 800)
Font.ftSetCharSize(SFONT, 650, 650)
SCR_X = 704
SCR_Y = 480
X_MID = SCR_X/2
Y_MID = SCR_Y/2
function UpdateScreen()
  local modetable = Screen.getMode()
  Screen.setMode(modetable.mode, 704, 480, CT24, INTERLACED, FIELD)
end

MC2 = Graphics.loadImage("MC2.png")
Graphics.setImageFilters(MC2, LINEAR)

GPAD = 0
local HISTORY = {
	{
		{
			history = {
        exist = doesFileExist("mc0:/BADATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc0:/BADATA-SYSTEM/history.old");
        data = nil
      };
		},
		{
			history = {
        exist = doesFileExist("mc0:/BEDATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc0:/BEDATA-SYSTEM/history.old");
        data = nil
      };
		},
		{
			history = {
        exist = doesFileExist("mc0:/BIDATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc0:/BIDATA-SYSTEM/history.old");
        data = nil
      };
		},
		{
			history = {
        exist = doesFileExist("mc0:/BCDATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc0:/BCDATA-SYSTEM/history.old");
        data = nil
      };
		},
	},

	{
		{
			history = {
        exist = doesFileExist("mc1:/BADATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc1:/BADATA-SYSTEM/history.old");
        data = nil
      };
		},
		{
			history = {
        exist = doesFileExist("mc1:/BEDATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc1:/BEDATA-SYSTEM/history.old");
        data = nil
      };
		},
		{
			history = {
        exist = doesFileExist("mc1:/BIDATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc1:/BIDATA-SYSTEM/history.old");
        data = nil
      };
		},
		{
			history = {
        exist = doesFileExist("mc1:/BCDATA-SYSTEM/history");
        data = nil
      };
			old = {
        exist = doesFileExist("mc1:/BCDATA-SYSTEM/history.old");
        data = nil
      };
		},
	},
}
print(GAMEDB["SLPM_666.75"])


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

local ST = {MAIN = 1, REGPICK = 2, HISTORY_QUERY = 3, HISTORY_DISP = 4}
local REGS = {"A", "E", "I", "C"}
local REGSTR = {"America and some parts of asia", "PAL (Europe, oceania, russia)", "Japan", "Mainland China"}
local CURR = {
  MCSLOT = 0,
  REGION = 1,
  MAIN_HISTORY = true
}
local CSTAGE = ST.REGPICK

function Font.ftPrintMultiLineAligned(font, x, y, spacing, width, height, text, color)
  local internal_y = y
  local COL = Color.new(128,128,128)
  if text == nil then error("called ftPrintMultiLineAligned without text", 2)end
  if type(color) == "number" then COL = color end
  for line in text:gmatch("([^\n]*)\n?") do
    Font.ftPrint(font, x, internal_y, 8, width, height, line, COL)
    internal_y = internal_y+spacing
  end
end

function MainMenu()
  Font.ftPrintMultiLineAligned(LFONT, X_MID, 50, 20, SCR_X, 64, "Nostalgia Scrapper")
  Font.ftPrintMultiLineAligned(SFONT, X_MID, 70, 20, SCR_X, 64, "Travel back into better times")
  Graphics.drawScaleImage(MC2, 64, Y_MID, 64, 64)
  Font.ftPrint(SFONT, 64+32, Y_MID+20, 8, 64, 64, "L1")
  Graphics.drawScaleImage(MC2, SCR_X-192, Y_MID, 64, 64)
  Font.ftPrint(SFONT, SCR_X-192+32, Y_MID+20, 8, 64, 64, "R1")
  if Pads.check(GPAD, PAD_L1) then CURR.MCSLOT = 0 CSTAGE = ST.REGPICK end
  if Pads.check(GPAD, PAD_R1) then CURR.MCSLOT = 1 CSTAGE = ST.REGPICK end
end

function RegionPick()
  Font.ftPrintMultiLineAligned(LFONT, X_MID, 50, 20, SCR_X, 64, "Choose Region")
  Font.ftPrintMultiLineAligned(SFONT, X_MID, 70, 20, SCR_X, 64, "PS2 saves the gameplay history on specific folders\ndepending on the console region")
  for i = 1, 4 do
    Font.ftPrintMultiLineAligned(MFONT, X_MID, 150+(25*i), 20, SCR_X, 64, REGSTR[i], CURR.REGION == i and Color.new(0, 128, 128) or Color.new(128,128,128))
  end
  if Pads.check(GPAD, PAD_DOWN) then CURR.REGION = CYCLE_CLAMP(CURR.REGION+1, 1, #REGS) end
  if Pads.check(GPAD, PAD_UP) then CURR.REGION = CYCLE_CLAMP(CURR.REGION-1, 1, #REGS) end
  if Pads.check(GPAD, PAD_CROSS) then CSTAGE = ST.HISTORY_QUERY end
  if Pads.check(GPAD, PAD_CIRCLE) then CSTAGE = ST.MAIN end
end

function HistoryQuery()
  Font.ftPrintMultiLineAligned(LFONT, X_MID, 50, 20, SCR_X, 64, "Choose History file")
  Font.ftPrintMultiLineAligned(MFONT, X_MID, 175, 20, SCR_X, 64, "history", (CURR.MAIN_HISTORY) and Color.new(0, 128, 128) or Color.new(128,128,128))
  Font.ftPrintMultiLineAligned(MFONT, X_MID, 200, 20, SCR_X, 64, "history.old", (not CURR.MAIN_HISTORY) and Color.new(0, 128, 128) or Color.new(128,128,128))
  Font.ftPrintMultiLineAligned(SFONT, X_MID, SCR_Y-150, 20, SCR_X, 64, CURR.MAIN_HISTORY
  and " \nThe main history file, the 21 most played games are recorded here\n " or "When the console has to add a new game to the main history\nif it is full\nthe game that was loaded the fewest times is sent to this file to make space")

  if Pads.check(GPAD, PAD_DOWN) then CURR.MAIN_HISTORY = false end
  if Pads.check(GPAD, PAD_UP) then CURR.MAIN_HISTORY = true end
  if Pads.check(GPAD, PAD_CIRCLE) then CSTAGE = ST.REGPICK end
  if Pads.check(GPAD, PAD_CROSS) then CSTAGE = ST.HISTORY_DISP end
end

local CC = 1
function DisplayHistory(TABLE)
  if TABLE == nil then
    Font.ftPrintMultiLineAligned(LFONT, X_MID, Y_MID, 20, SCR_X, 64, "Could not access the history file")
    if Pads.check(GPAD, PAD_CIRCLE) then CSTAGE = ST.HISTORY_QUERY CC=1 end
    return
  end
  for i = 1, #TABLE do
    --print(TABLE[i].ELF, TABLE[i].LaunchCount, TABLE[i].date)
    Font.ftPrint(SFONT, 60, 40+(15*i), 0, SCR_X, 64, TABLE[i].ELF == "<EMPTY>" and TABLE[i].ELF or
    string.format("%-16s   Launched %d times, first played at %s", TABLE[i].ELF, TABLE[i].LaunchCount, TABLE[i].date), (CC == i) and Color.new(0, 128, 128) or Color.new(128,128,128))

  end
    if Pads.check(GPAD, PAD_DOWN) then CC = CYCLE_CLAMP(CC+1, 1, #TABLE) end
    if Pads.check(GPAD, PAD_UP) then CC = CYCLE_CLAMP(CC-1, 1, #TABLE) end
    if Pads.check(GPAD, PAD_CIRCLE) then CSTAGE = ST.HISTORY_QUERY CC=1 end
    if TABLE[CC].ELF ~= "<EMPTY>" then
      local a = GAMEDB[TABLE[CC].ELF]
      if a ~= nil then Font.ftPrintMultiLineAligned(MFONT, X_MID, SCR_Y-100, 20, SCR_X, 64, "Game title: "..a) end
    end

end


Q = 1
while true do
  Q = CYCLE_CLAMP(Q+1, 0, 10)
  if Q == 0 then GPAD = Pads.get() else GPAD = 0 end
  Screen.clear(Color.new(0, 4, 20))
  if CSTAGE == ST.MAIN then
    MainMenu()
  elseif CSTAGE == ST.REGPICK then
    RegionPick()
  elseif CSTAGE == ST.HISTORY_QUERY then
    HistoryQuery()
  elseif CSTAGE == ST.HISTORY_DISP then
    if CURR.MAIN_HISTORY then
      local A = 1
      -- print(type(HISTORY))
      -- print(type(HISTORY[CURR.MCSLOT]), type(HISTORY[1]))
      -- print(type(HISTORY[CURR.MCSLOT].A))
      -- print(type(HISTORY[CURR.MCSLOT][CURR.REGION].old))
      -- print(type(HISTORY[CURR.MCSLOT][CURR.REGION].old.exist))
      if HISTORY[CURR.MCSLOT+1][CURR.REGION].history.exist then
        if HISTORY[CURR.MCSLOT+1][CURR.REGION].history.data == nil then
          HISTORY[CURR.MCSLOT+1][CURR.REGION].history.data = System.ParseOSDHistory(string.format("mc%d:/B%sDATA-SYSTEM/history", CURR.MCSLOT, REGS[CURR.REGION]))
        end
        DisplayHistory(HISTORY[CURR.MCSLOT+1][CURR.REGION].history.data)
      end
    else
      if HISTORY[CURR.MCSLOT+1][CURR.REGION].old.exist then
        if HISTORY[CURR.MCSLOT+1][CURR.REGION].old.data == nil then
          HISTORY[CURR.MCSLOT+1][CURR.REGION].old.data = System.ParseOSDHistoryOLD(string.format("mc%d:/B%sDATA-SYSTEM/history.old", CURR.MCSLOT, REGS[CURR.REGION]))
        end
        DisplayHistory(HISTORY[CURR.MCSLOT+1][CURR.REGION].old.data)
      end
    end
  end
  Screen.flip()
end