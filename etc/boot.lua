
	LNG_CRDTS0 = "Coded By El_isra (aka: Matias Israelson)"
	LNG_CRDTS1 = "Based on Enceladus. by Daniel Santos"
	LNG_CRDTS2 = "SECRMAN and SECRSIF taken from FreeMcBoot 1.9 series installer"
	LNG_CRDTS3 = "GFX by Berion"
	LNG_CRDTS4 = "Get me Free at github.com/israpps/KelfBinder"
	LNG_MM1 = "Welcome to KELFBinder"
	LNG_MM2 = "Manage System Updates"
	LNG_MM3 = "Manage DVDPlayer Updates (Comming soon)"
	LNG_MM4 = "System Information"
	LNG_MM5 = "Exit program"
	LNG_CT0 = "Select"
	LNG_CT1 = "Cancel"
	LNG_CT2 = "Refresh"
	LNG_CT3 = "Begin Installation"
	LNG_CT4 = "Quit"
	LNG_IMPP0 = "Perform an installation compatible with this console\n and similar units"
	LNG_IMPP1 = "The clasic installation modes of FreeMcBoot"
	LNG_IMPP2 = "Choose manually wich updates you will install"
	LNG_IMPMP0 = "Choose Installation mode" -- TODO: CHECK IF CAN BE DELETED
	LNG_IMPMP1 = "Normal Install"
	LNG_IMPMP2 = "Advanced Install (Comming soon!)"
	LNG_IMPMP3 = "Expert Install"
	LNG_INSTPMPT = "BINDING KELF\n\n%s\n"
	LNG_INSTPMPT1 = "Installation Finished!"
	LNG_MEMCARD0 = "Choose a Memory card"
	LNG_MEMCARD1 = "Memory card %d\nFree Space %d kb"
	LNG_SUC0 = "Kernel Patch for early SCPH-10000\n needs SCPH-18000 update to function"
	LNG_SUC1 = "Kernel Patch for late SCPH-10000 and SCPH-15000\n needs SCPH-18000 update to function"
	LNG_SUC2 = "SCPH-18000"
	LNG_SUC3 = "ANY japanese model without PCMCIA connection"
	LNG_SUC4 = "USA release model\n SCPH-30001 with chassis B"
	LNG_SUC5 = "USA release model\n SCPH-30001 with chassis C"
	LNG_SUC6 = "ANY american and asian models\n excluding USA release models"
	LNG_SUC7 = "European release model\n SCPH-3000(2-4) with chassis C"
	LNG_SUC8 = "ANY european model excluding release models"
	LNG_SUC9 = "the rare Chinese models"
	LNG_EXPERTINST_PROMPT = "Select system update executables"
	LNG_REGS0 = "Japan - SCPH-XXX00"
	LNG_REGS1 = "USA and Asia"
	LNG_REGS2 = "Europe - SCPH-XXX0[2-4]"
	LNG_REGS3 = "China - SCPH-XXX09"
	LNG_EIO = "I/O ERROR"
	LNG_SECRMANERR = "SECRDOWNLOADFILE Failed!\nPossible Magicgate error"
	LNG_ENOMEM = "MEMORY ALLOCATION ERROR!"
	LNG_EUNKNOWN = "Unknown error!"
	LNG_INSTERR = "Installation Failed! (%d)"
	LNG_INSTALLING = "Installing System Updates..."
	LNG_INSTFINISH = "Installation concluded!"
	LNG_WANNAQUIT = "Exit Program?"
	LNG_YES = " Yes"
	LNG_NO = " No"
	LNG_RWLE = "Run wLaunchELF"
	LNG_SYSTEMINFO = "SYSTEM INFORMATION"
	LNG_SUPATH = "System Update Path = [%s]"
	LNG_CONTINUE = "Continue"
	LNG_COMPAT0 = "This console model does not support system updates"
	LNG_COMPAT1 = "However, you can still use it to install updates"

if System.doesFileExist("System/index.lua") then
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