Font.fmLoad()
--dbgscr.init()
Screen.clear(Color.new(128, 0, 128))
Screen.flip()
System.sleep(3)
-- dbgscr.clear()
local GMIDZ_PATH = "CDVDMAN_PATTERNS.TPR"
local GMIDZ = nil
local TRLL_PATH = "PS1DVR_PATCH.UDNL"
local TRLL_PNG = nil
function AERR(file)
	Screen.clear()
	--dbgscr.clear()
	--dbgscr.write("Cannot find '"..file.."'\nPlease Paste it on same folder than this program")
	Font.fmPrint(30, 30, 0.6, "Cannot find '"..file.."'\nPlease Paste it on same folder than this program")
	Screen.flip()
	while true do
	end
end
Sound.setVolume(100)
Sound.setADPCMVolume(1, 100)
local T = Sound.loadADPCM("snd.adp")
Sound.playADPCM(1, T)
print("T")
if doesFileExist(GMIDZ_PATH) then BGM.Start(GMIDZ_PATH) else AERR(GMIDZ_PATH) end
if doesFileExist(TRLL_PATH) then TRLL_PNG = Graphics.loadImage(TRLL_PATH) end
if TRLL_PNG== nil then AERR(TRLL_PATH) end
-- dbgscr.write("\t\taaa")
Sound.playADPCM(1, GMIDZ)
Screen.clear()
Font.fmPrint(30, 30, 0.6, "AAAAAAAAAAAAAAAAA")
Screen.flip()
while true do end