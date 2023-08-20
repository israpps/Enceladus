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

-- refresh files list
function refreshFileList(directory, tempmode) -- directory to list / list files in directory (true) or mount paths (false)
	if tempmode == false then
		ofmItemTotal = 0
		ofmSelectedItem = 1
		ofmItem = nil;
		ofmItem = {};

		-- MEMORY CARD 1
		mctypea = System.getMCInfo(0)
		if mctypea ~= 0 then
			ofmItemTotal=ofmItemTotal+1
			ofmItem[ofmItemTotal] = {};
			ofmItem[ofmItemTotal].Name = "Memory Card 1" -- displayed name
			ofmItem[ofmItemTotal].Type = "folder" -- "file" or "folder"
			ofmItem[ofmItemTotal].Dir = "mc0:/" -- directory (path)
			ofmItem[ofmItemTotal].Size = "" -- displayed size
		end

		-- MEMORY CARD 2
		mctypeb = System.getMCInfo(1)
		if mctypeb ~= 0 then
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
					if System.doesFileExist(directory..ofmItem[nr].Name) then
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
		Font.ftPrint(fontBig, 16, plusYValue+TempY, 0, 500, 64, ofmItem[nr].Name, OFM_COLOR_LIST)
		Font.ftPrint(fontBig, 548, plusYValue+TempY, 0, 500, 64, ofmItem[nr].Size, OFM_COLOR_LIST)
	end
end

-- drawing selection bar
function drawSelectionBar()
	TempYb=AdjustY+68+ofmSelectedItem*25
	Graphics.drawRect(352, TempYb, 704, 25, OFM_COLOR_SELECTIONBAR)
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
	Graphics.drawRect(352, 46, 704, 4, Color.new(255,255,255,128))
	Graphics.drawRect(352, 74, 704, 4, Color.new(255,255,255,128))
	Font.ftPrint(fontSmall, 16, plusYValue+51, 0, 704, 64, ofmCurrentPath, OFM_COLOR_LIST)
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