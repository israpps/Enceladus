--if doesFileExist("lip.lua") then dofile("lip.lua") end

SCR_X = 704
SCR_Y = 480
Screen.setMode(_480p, SCR_X, SCR_Y, CT24, INTERLACED, FIELD)
local BG = Graphics.loadImage("pads/BG.png")
Graphics.setImageFilters(BG, LINEAR)
Font.ftInit()
X_MID = SCR_X/2
Y_MID = SCR_Y/2
print("LIP (Lua Ini Parser)\tCopyright (c) 2012 Carreras Nicolas");
LIP = {};

--- Returns a table containing all the data from the INI file.
--@param fileName The name of the INI file to parse. [string]
--@return The table containing all data from the INI file. [table]
function LIP.load(fileName)
	local FD = System.openFile(fileName, FREAD);
    local file = System.readFile(FD, System.sizeFile(FD));
	local data = {};
	local section;
	for line in file:gmatch('[^\n]+') do
		print(line)
		local param, value = line:match('^([%w|_]+)%s-=[ ]?%s-(.+)[\r]?$');
		print(string.format("%s|%s", param, value))
		if(param ~= nil and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[param] = value;
		end
	end
	System.closeFile(FD)
	return data;
end

--- Saves all the data from a table to an INI file.
--@param fileName The name of the INI file to fill. [string]
--@param data The table containing all the data to store. [table]
function LIP.save(fileName, data)
	local FD = System.openFile(fileName, FCREATE);
	local contents = '';

	for key, value in pairs(data) do
		if not key:find('^LK') then contents = contents .. ('%s = %s\n'):format(key, tostring(value)); end
	end --we iterate this crap twice: first, leave launch keys for the bottom
	for key, value in pairs(data) do
		if key:find('^LK') then contents = contents .. ('%s = %s\n'):format(key, tostring(value)); end
	end
    System.writeFile(FD, contents, string.len(contents));
    System.closeFile(FD);
end


--local DATA = LIP.load("pads/LOL.ini")
--LIP.save("LOL2.ini", DATA)

_FNT_ = Font.ftLoad("pads/font.ttf")
_FNT2_ = Font.ftLoad("pads/font.ttf")
Font.ftSetCharSize(_FNT_, 940, 940)
Font.ftSetCharSize(_FNT2_, 740, 740)
fontSmall = _FNT2_
fontBig = _FNT_

local MAIN_MENU = {
	item = {
		"Load Config",
		"Save Config",
		"Load defaults",
		"Configure"
	},
	desc = {
		"Read config from a device",
		"Save config into a device",
		"Load the stock config",
		"Browse the configuration values"
	},
}
local LOAD_CONF = {
	item = {
		"mc0:/PS2BBL/CONFIG.INI",
		"mc0:/PS2BBL/CONFIG.INI",
		"mass:/PS2BBL/CONFIG.INI",
		"hdd0:__sysconf/PS2BBL/CONFIG.INI",
	},
	desc = {
		"Read config from Memory Card on slot 1",
		"Read config from Memory Card on slot 2",
		"Read config from USB Mass storage",
		"Read config from Internal HDD",
	},
}
local SAVE_CONF = {
	item = {
		"mc0:/PS2BBL/CONFIG.INI",
		"mc0:/PS2BBL/CONFIG.INI",
		"mass:/PS2BBL/CONFIG.INI",
		"hdd0:__sysconf/PS2BBL/CONFIG.INI",
	},
	desc = {
		"Save config into Memory Card on slot 1",
		"Save config into Memory Card on slot 2",
		"Save config into USB Mass storage",
		"Save config into Internal HDD",
	},
}

local PS2BBL_CMDS = {
	item = {
		"$CDVD",
		"$CDVD_NO_PS2LOGO",
		"$CREDITS",
		"$OSDSYS",
    "$HDDCHECKER",
	},
	desc = {
		"Makes PS2BBL run a disc",
		"Makes PS2BBL run a disc. but skipping usage of PS2LOGO (useful for Mechapwn)",
		"displays credits (duh). and shows compilation date and associated git commit hash",
		"Executes OSDSYS program (Console main menu).\nbut passing args to avoid booting MC or HDD Updates",
    "Runs HDD diagnosis tests (only works if PS2BBL has HDD support enabled)"
	},
}
function Drawbar(x, y, prog, col)
	Graphics.drawRect(x-(prog*2), y, prog*4, 5, col)
end
--0, 0xde, 0xf
function DisplayGenerictMOptPrompt(options_t, heading)
  local T = 1
  local D = 15
  local A = 0x80
  local TSIZE = #options_t.item
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, SCR_X, SCR_Y)

    Font.ftPrint(_FNT_, 40, 40, 0, 630, 32, heading, Color.new(220, 220, 220, 0x80 - A))
    Graphics.drawRect(0, 60, SCR_X, 1, Color.new(255, 255, 255, 0x70-A))
    for i = 1, #options_t.item do
      if i == T then
        Font.ftPrint(_FNT_, 60+1, 80+(i*20), 0, 630, 16, options_t.item[T], Color.new(0xff, 0xff, 0xff, 0x80 - A))
      else
        Font.ftPrint(_FNT_, 60, 80+(i*20), 0, 630, 16, options_t.item[i], Color.new(0xff, 0xff, 0xff, 0x70 - A))
      end
    end
    Graphics.drawRect(0, 330, SCR_X, 1, Color.new(0xff, 0xff, 0xff, 0x80-A))
    Font.ftPrint(_FNT_, 80, 350, 0, 600, 32, options_t.desc[T], Color.new(0x70, 0x70, 0x70, 0x70 - A))
    if A > 0 then A = A - 1 end
    Screen.flip()
    local pad = Pads.get()

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
function DisplayGenerictMOptPromptDiag(options_t, heading)
  local T = 1
  local D = 15
  local A = 0x80
  local TSIZE = #options_t.item
  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, SCR_X, SCR_Y)

    Graphics.drawRect(0, 81, SCR_X, 349-81, Color.new(0, 0, 0, 20-A))
    Font.ftPrint(_FNT_, 40, 60, 0, 630, 32, heading, Color.new(220, 220, 220, 0x80 - A))
    Graphics.drawRect(0, 80, SCR_X, 1, Color.new(255, 255, 255, 0x80-A))
    Graphics.drawRect(0, 350, SCR_X, 1, Color.new(0xff, 0xff, 0xff, 0x80-A))
    for i = 1, #options_t.item do
      if i == T then
        Font.ftPrint(_FNT_, 60+1, 100+(i*20), 0, 630, 16, options_t.item[T], Color.new(0xff, 0xff, 0xff, 0x80 - A))
      else
        Font.ftPrint(_FNT_, 60, 100+(i*20), 0, 630, 16, options_t.item[i], Color.new(0xff, 0xff, 0xff, 0x70 - A))
      end
    end
    Font.ftPrint(_FNT2_, 80, 370, 0, 600, 32, options_t.desc[T], Color.new(0x70, 0x70, 0x70, 0x70 - A))
    if A > 0 then A = A - 1 end
    Screen.flip()
    local pad = Pads.get()

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
DisplayGenerictMOptPromptDiag(PS2BBL_CMDS, "PS2BBL Internal Commands")
function GenericBGFade(fadein)
	local A = 0x79
	if fadein then A = 1 end
	while A < 0x80 and A > 0 do
	  Screen.clear()
	  Graphics.drawScaleImage(BG, 0.0, 0.0, SCR_X, SCR_Y, Color.new(0x80, 0x80, 0x80, A))
	  Screen.flip()
	  if fadein then A = A+1 else A = A-1 end
	end
end

local CURRITEM = 0
local ret = 0
--
-- round file size
function ofmRoundSize(inputValue)
	roundValue=inputValue*10
	roundTempValueA,roundTempValueB = math.modf(roundValue/1)
	roundValue= 1 * (roundTempValueA + (roundTempValueB > 0.5 and 1 or 0))
	roundValue=roundValue/10
	return roundValue
end

ofmScrollDelay=4
ofmWaitBeforeScroll=14
-- check pad up/down
function checkPadUpDown()
	if Pads.check(pad, PAD_UP) then
		PadUpHolding=PadUpHolding+1
	else
		PadUpHolding=0
	end
	if Pads.check(pad, PAD_DOWN) then
		PadDownHolding=PadDownHolding+1
	else
		PadDownHolding=0
	end
	if PadUpHolding == 1 then
		ofmSelectedItem = ofmSelectedItem - 1
	elseif PadUpHolding >= ofmWaitBeforeScroll then
		for nr = 2, 512 do
			nra = nr*ofmScrollDelay
			if PadUpHolding == nra then
				ofmSelectedItem = ofmSelectedItem - 1
			end
		end
	end
	if PadDownHolding == 1 then
		ofmSelectedItem = ofmSelectedItem + 1
	elseif PadDownHolding >= ofmWaitBeforeScroll then
		for nr = 2, 512 do
			nra = nr*ofmScrollDelay
			if PadDownHolding == nra then
				ofmSelectedItem = ofmSelectedItem + 1
			end
		end
	end

	if ofmSelectedItem <= 0 then
		ofmSelectedItem = 1
	end
	if ofmSelectedItem > ofmItemTotal then
		ofmSelectedItem = ofmItemTotal
	end
end

-- refresh files list -- directory to list / list files in directory (true) or mount paths (false)
function refreshFileList(directory, tempmode)
	if tempmode == false then
		ofmItemTotal = 0
		ofmSelectedItem = 1
		ofmItem = nil;
		ofmItem = {};

		-- MEMORY CARD 1
		mctypea = System.getMCInfo(0)
		if mctypea.type == 2 then
			ofmItemTotal=ofmItemTotal+1
			ofmItem[ofmItemTotal] = {};
			ofmItem[ofmItemTotal].Name = "Memory Card 1" -- displayed name
			ofmItem[ofmItemTotal].Type = "folder" -- "file" or "folder"
			ofmItem[ofmItemTotal].Dir = "mc0:/" -- directory (path)
			ofmItem[ofmItemTotal].Size = "" -- displayed size
		end

		-- MEMORY CARD 2
		mctypeb = System.getMCInfo(1)
		if mctypeb.type == 2 then
			ofmItemTotal=ofmItemTotal+1
			ofmItem[ofmItemTotal] = {};
			ofmItem[ofmItemTotal].Name = "Memory Card 2"
			ofmItem[ofmItemTotal].Type = "folder"
			ofmItem[ofmItemTotal].Dir = "mc1:/"
			ofmItem[ofmItemTotal].Size = ""
		end

		-- HDD
		if System.doesDirectoryExist("hdd0:/") then
			ofmItemTotal=ofmItemTotal+1
			ofmItem[ofmItemTotal] = {};
			ofmItem[ofmItemTotal].Name = "Hard Drive"
			ofmItem[ofmItemTotal].Type = "folder"
			ofmItem[ofmItemTotal].Dir = "hdd0:/"
			ofmItem[ofmItemTotal].Size = ""
		end

		-- CD/DVD
		if System.doesDirectoryExist("cdfs:/") then
			ofmItemTotal=ofmItemTotal+1
			ofmItem[ofmItemTotal] = {};
			ofmItem[ofmItemTotal].Name = "Optical Drive"
			ofmItem[ofmItemTotal].Type = "folder"
			ofmItem[ofmItemTotal].Dir = "cdfs:/"
			ofmItem[ofmItemTotal].Size = ""
		end

		-- MASS
		if System.doesDirectoryExist("mass:/") then
			ofmItemTotal=ofmItemTotal+1
			ofmItem[ofmItemTotal] = {};
			ofmItem[ofmItemTotal].Name = "USB Drive"
			ofmItem[ofmItemTotal].Type = "folder"
			ofmItem[ofmItemTotal].Dir = "mass:/"
			ofmItem[ofmItemTotal].Size = ""
		end

		-- HOST
		if System.doesDirectoryExist("host:/") then
			ofmItemTotal=ofmItemTotal+1
			ofmItem[ofmItemTotal] = {};
			ofmItem[ofmItemTotal].Name = "Host directory"
			ofmItem[ofmItemTotal].Type = "folder"
			ofmItem[ofmItemTotal].Dir = "host:/"
			ofmItem[ofmItemTotal].Size = ""
		end
	else
		ofmItemTotal=1
		ofmSelectedItem=1
		listdir = nil
		listdir = System.listDirectory(directory)
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
				if directory == "mc0:/" or directory == "mc1:/" then
					ofmItem[nr].Type = "folder"
					ofmItem[nr].Dir = ofmItem[nr].Name.."/"
					ofmItem[nr].Name = ofmItem[nr].Dir
				else
					if doesFileExist(directory..ofmItem[nr].Name) then
						ofmItem[nr].Type = "file"
						ofmItem[nr].Size = listdir[nr].size
						if ofmItem[nr].Size <= 4096 then
							ofmItem[nr].Size = ofmRoundSize(ofmItem[nr].Size)
							ofmItem[nr].Size = ofmItem[nr].Size.." B"
						elseif ofmItem[nr].Size >= 4096 and ofmItem[nr].Size <= 1048576 then
							ofmItem[nr].Size = ofmItem[nr].Size / 1024
							ofmItem[nr].Size = ofmRoundSize(ofmItem[nr].Size)
							ofmItem[nr].Size = ofmItem[nr].Size.." KB"
						elseif ofmItem[nr].Size >= 1048576 then
							ofmItem[nr].Size = ofmItem[nr].Size / 1048576
							ofmItem[nr].Size = ofmRoundSize(ofmItem[nr].Size)
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
end

-- displaying list of files
function listFiles()
	AdjustY = 0
	if ofmSelectedItem < 15 then
		ofmItemTotalB=ofmSelectedItem+24
		if ofmItemTotalB > ofmItemTotal then
			ofmItemTotalB = ofmItemTotal
		end
	else
		ofmItemTotalB=ofmSelectedItem+6
		if ofmItemTotalB > ofmItemTotal then
			ofmItemTotalB = ofmItemTotal
		end
	end
	if ofmItemTotal > 15 then
		if ofmSelectedItem >= 14 then
			TempA = ofmSelectedItem - 14
			TempB = -25
			AdjustY = TempA*TempB
		end
		if ofmSelectedItem >= 14 and ofmSelectedItem == ofmItemTotal then
			TempA = ofmSelectedItem - 15
			TempB = -25
			AdjustY = TempA*TempB
		end
	end
	TempC = 1
	if ofmItemTotal > 15 then
		if ofmSelectedItem == ofmItemTotal and ofmSelectedItem > 14 then
			TempC = ofmSelectedItem-14
		elseif ofmSelectedItem > 13 then
			TempC = ofmSelectedItem-13
		end
	end
	for nr = TempC, ofmItemTotalB do
		TempY=AdjustY+60+nr*25
		local TMPCOL
		if nr ~= ofmSelectedItem then TMPCOL = OFM_COLOR_SELECTIONBAR else TMPCOL = OFM_COLOR_LIST end
		Font.ftPrint(fontBig, 16, TempY, 0, 500, 64, ofmItem[nr].Name, TMPCOL)
		Font.ftPrint(fontBig, 548, TempY, 0, 500, 64, ofmItem[nr].Size, TMPCOL)
	end
end

-- drawing selection bar
function drawSelectionBar()
end

-- entering selected directory
function enterSelectedDirectory()
	if ofmItem[ofmSelectedItem].Name ~= "." and ofmItem[ofmSelectedItem].Name ~= ".." then
		if System.doesDirectoryExist(ofmCurrentPath..ofmItem[ofmSelectedItem].Dir) then
			ofmFolder[0] = ofmFolder[0]+1
			ofmFolder[ofmFolder[0]] = ofmItem[ofmSelectedItem].Dir
			ofmCurrentPath = ""
			for i = 1, ofmFolder[0] do
				ofmCurrentPath=ofmCurrentPath..ofmFolder[i]
			end
			refreshFileList(ofmCurrentPath, true)
		end
	end
end

-- go back from selected directory
function goBackFromDirectory()
	if ofmFolder[0] == 1 then
		ofmFolder[0] = 0
		ofmFolder[1] = ""
		ofmCurrentPath=""
		refreshFileList(ofmCurrentPath, false)
	else
		ofmFolder[ofmFolder[0]] = ""
		ofmFolder[0] = ofmFolder[0]-1
		ofmCurrentPath = ""
        for i = 1, ofmFolder[0] do
            ofmCurrentPath=ofmCurrentPath..ofmFolder[i]
        end
		refreshFileList(ofmCurrentPath, true)
		for i = 1, #ofmItem do
			if ofmItem[i].Dir == ofmFolder[ofmFolder[0]] then
				ofmSelectedItem = i
			end
		end
    end
end

-- draw overlay
function drawOFMoverlay()
	Font.ftPrint(fontSmall, 16, plusYValue+51, 0, 704, 64, ofmCurrentPath, OFM_COLOR_LIST)
    Graphics.drawRect(0, 71, SCR_X, 1, Color.new(255, 255, 255, 0x80))
end


OFM_COLOR_LIST=Color.new(255,255,255,128)
OFM_COLOR_SELECTIONBAR=Color.new(255,255,255,40)


if plusYValue == nil then
	plusYValue=0
end

ofmCurrentPath = ""
refreshFileList("", false)
ofmSelectedItem=1

ofmFolder={}
ofmFolder[0]=0

AdjustY=0

keepInOFMApp=true


---------------------------------------------------------
--------- FILE MANAGER ----------------------------------
---------------------------------------------------------

while keepInOFMApp do
    pad = Pads.get()
    Screen.clear()
	Graphics.drawScaleImage(BG, 0.0, 0.0, SCR_X, SCR_Y, Color.new(0x80, 0x80, 0x80, 0x80))
    drawOFMoverlay() -- draws overlay
    if ofmItemTotal >= 1 then
        drawSelectionBar() -- draw selection bar
		checkPadUpDown() -- check up/down buttons
    end
	listFiles() -- print list of items
    if Pads.check(pad, PAD_CROSS) and not Pads.check(oldpad, PAD_CROSS) then
        -- enter directory
        if ofmItem[ofmSelectedItem].Type == "folder" then
            enterSelectedDirectory()
        end
    end
    if Pads.check(pad, PAD_CIRCLE) and not Pads.check(oldpad, PAD_CIRCLE) then
        if ofmFolder[0] >= 1 then
            goBackFromDirectory()
        else
            keepInOFMApp=false
        end
    end
    if Pads.check(pad, PAD_TRIANGLE) and not Pads.check(oldpad, PAD_TRIANGLE) then
        keepInOFMApp=false
    end
    Screen.waitVblankStart()
    oldpad = pad;
    Screen.flip()
end

ofmFolder=nil
ofmCurrentPath = ""
ofmItem=nil
--



GenericBGFade(true)

while true do

  ret = DisplayGenerictMOptPrompt(MAIN_MENU, "PS2BBL Configurator")
  if ret == 1 then
	DisplayGenerictMOptPrompt(LOAD_CONF, MAIN_MENU.item[ret])
  elseif ret == 2 then
	DisplayGenerictMOptPrompt(SAVE_CONF, MAIN_MENU.item[ret])
  elseif ret == 4 then
	DisplayGenerictMOptPrompt(SAVE_CONF, MAIN_MENU.item[ret])
  end
end
if doesFileExist("pads/pads.lua") then
	dofile("pads/pads.lua");
end