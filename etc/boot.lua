local M = Screen.getMode()
Font.fmLoad()
local GMIDZ_PATH = "CDVDMAN_PATTERNS.TPR"
local GMIDZ = nil
local TRLL_PATH = "PS1DVR_PATCH.UDNL"
local TRLL_PNG = nil
function AERR(file)
	Screen.clear()
	Font.fmPrint(30, 30, 0.6, "Cannot find '"..file.."'\nPlease Paste it on same folder than this program")
	Screen.flip()
	while true do
	end
end
Sound.setVolume(100)
Sound.setADPCMVolume(1, 100)

if doesFileExist(GMIDZ_PATH) then BGM.Start(GMIDZ_PATH) else AERR(GMIDZ_PATH) end
BGM.Mute()
if doesFileExist(TRLL_PATH) then TRLL_PNG = Graphics.loadImage(TRLL_PATH) end
if TRLL_PNG== nil then AERR(TRLL_PATH) end

Tx = 347/2
Ty = 288/2
while not BGM.IsPlayIng() do

end
local COLORS = {
	Color.new(128,0,0),
	Color.new(128,128,0),
	Color.new(0,128,128),
	Color.new(0,128,0),
	Color.new(0,0,128),
	Color.new(128,0,128),
}
System.sleep(1)
BGM.SetVolume(100)
while true do
	Screen.clear()
	Graphics.drawImage(TRLL_PNG, M.width/2-(Tx), M.height/2-(Ty), COLORS[math.random(1, #COLORS)])
	Screen.flip()
end
