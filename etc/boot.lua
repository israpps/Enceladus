Screen.clear() Graphics.drawRect(318, 222, 4, 4, Color.new(255, 255, 255)) Screen.flip()
	LNG_CRDTS0 = "Coded by El_isra (aka: Matias Israelson)"
	LNG_CRDTS1 = "Based on Enceladus by Daniel Santos"
	LNG_CRDTS2 = "SECRMAN and SECRSIF taken from Free McBoot 1.9 series installer"
	LNG_CRDTS3 = "GFX by Berion"
	LNG_CRDTS4 = "Get me free at https://www.github.com/israpps/KelfBinder"
	LNG_CRDTS5 = "Thanks to:"
	LNG_MM1 = "Welcome to KELFBinder"
	LNG_MM2 = "Manage System Updates"
	LNG_MM3 = "Manage DVDPlayer Updates"
	LNG_MM4 = "System Information"
	LNG_MM5 = "Exit"
	LNG_MM6 = "Credits"
	LNG_CT0 = "Select"
	LNG_CT1 = "Cancel"
	LNG_CT2 = "Refresh"
	LNG_CT3 = "Begin Installation"
	LNG_CT4 = "Quit"
	LNG_IMPP0 = "Perform an installation compatible with this console\nand similar units"
	LNG_IMPP1 = "Free McBoot's classic installation modes"
	LNG_IMPP2 = "Choose manually which updates will be installed"
	LNG_IMPMP1 = "Normal Install"
	LNG_IMPMP2 = "Advanced Install"
	LNG_IMPMP3 = "Expert Install"
	LNG_INSTPMPT = "BINDING KELF\n\n%s\n"
	LNG_INSTPMPT1 = "Installation finished!"
	LNG_MEMCARD0 = "Choose a Memory Card"
	LNG_MEMCARD1 = "Memory Card %d"
	LNG_MEMCARD2 = "Free space %d kb"
	LNG_SUC0 = "Kernel Patch for early SCPH-10000\nneeds SCPH-18000 update to function"
	LNG_SUC1 = "Kernel Patch for late SCPH-10000 and SCPH-15000\nneeds SCPH-18000 update to function"
	LNG_SUC2 = "SCPH-18000"
	LNG_SUC3 = "Any Japanese model without PCMCIA connector"
	LNG_SUC4 = "American release model\nSCPH-30001 with B chassis"
	LNG_SUC5 = "American release model\nSCPH-30001 with C chassis"
	LNG_SUC6 = "Any American and Asian models\nexcluding American release models"
	LNG_SUC7 = "European release model\nSCPH-3000(2-4) with C chassis"
	LNG_SUC8 = "Any European model excluding release models"
	LNG_SUC9 = "The rare Chinese models"
	LNG_EXPERTINST_PROMPT = "Select the system update executables"
	LNG_EXPERTINST_PROMPT1 = "This console uses:"
	LNG_REGS0 = "Japan - SCPH-XXX00"
	LNG_REGS1 = "USA and Asia"
	LNG_REGS2 = "Europe / Oceania- SCPH-XXX0[2-4]"
	LNG_REGS3 = "China - SCPH-XXX09"
	LNG_EIO = "I/O ERROR"
	LNG_SECRMANERR = "SECRDOWNLOADFILE Failed! - Possible MagicGate error"
	LNG_ENOMEM = "MEMORY ALLOCATION ERROR!"
	LNG_SOURCE_KELF_GONE = "input KELF can't be opened"
	LNG_EUNKNOWN = "Unknown error!"
	LNG_INSTERR = "Installation failed! (%d)"
	LNG_INSTALLING = "Installing System Updates..."
	LNG_INSTFINISH = "Installation finished!"
	LNG_WANNAQUIT = "Exit application?"
	LNG_YES = "Yes"
	LNG_NO = "No"
	LNG_RWLE = "Run wLaunchELF"
	LNG_SYSTEMINFO = "SYSTEM INFORMATION"
	LNG_SUPATH = "System Update Path = [%s]"
	LNG_CONTINUE = "Continue"
	LNG_COMPAT0 = "This console model does not support system updates."
	LNG_COMPAT1 = "However, you can still use it to install updates."
	LNG_PICK_DVDPLAYER_REG = "Choose the DVD Player's update region"
	LNG_JPN = "Japan"
	LNG_USA = "USA"
	LNG_ASI = "Asia"
	LNG_USANASIA = "USA & Asia"
	LNG_EUR = "Europe"
	LNG_CHN = "China"
	LNG_AI_CROSS_MODEL = "Cross Model"
	LNG_AI_CROSS_REGION = "Cross Region"
	LNG_CONSOLE_MODEL = "Console model = [%s]"
	LNG_IS_COMPATIBLE = "Supports Updates = %s"
	LNG_DESC_CROSS_MODEL  =  "Install system updates for every PS2 of this same region"
	LNG_DESC_CROSS_REGION =  "Install system updates for every PS2 of every region"
	LNG_DESC_PSXDESR      =  "Install a system update for PSX-DESR systems"
	LNG_WARNING = "Warning!"
	LNG_WARN_CONFLICT0 = "The selected Memory Card seems to have a system update\nalready installed"
	LNG_WARN_CONFLICT1 = "clean the target folders before proceeding?"
	LNG_WARN_CONFLICT2 = "Note: If you don't clean the folders, the update will \nbe installed anyways, but on a dirty enviroment"
	LNG_FMCBINST_CRAP0 = "FreeMcBoot Multi Installation detected!"
	LNG_FMCBINST_CRAP1 = "The Memory Card must be formatted before installing."
	LNG_FMCBINST_CRAP2 = "There is risk of FileSystem corruption if the card is not formatted"
	LNG_ERROR = "Error!"
	LNG_NOT_ENOUGH_SPACE0 = "There is not enough space on the selected Memory Card"
	LNG_NOT_ENOUGH_SPACE1 = "Needed space  %.1f Kb - Available Space %.1f Kb"
	LNG_INCOMPATIBLE_CARD = "incompatible device!"
	LNG_INSTALLING_EXTRA = "Installing aditional files..."
	LNG_UNFORMATTED_CARD = "unformatted"
	LNG_EXTRA_INSTALL_ENABLE = "Extra files will be installed"
	LNG_EXTRA_INSTALL_DISABLE = "Extra files will not be installed"


	BETANUM = "014"
IS_NOT_PUBLIC_READY = true
if System.doesFileExist("INSTALL/KELFBinder.lua") then
	dofile("INSTALL/KELFBinder.lua");
  elseif System.doesFileExist("System/index.lua") then
	dofile("System/index.lua");
  elseif System.doesFileExist("System/script.lua") then
	dofile("System/script.lua");
  elseif System.doesFileExist("System/system.lua") then
	dofile("System/system.lua");
  elseif System.doesFileExist("index.lua") then
	dofile("index.lua");
  elseif System.doesFileExist("script.lua") then
	dofile("script.lua");
  elseif System.doesFileExist("system.lua") then
	dofile("system.lua");
end

Screen.clear(Color.new(0xff, 0xff, 0xff))
Screen.flip()
while true do end