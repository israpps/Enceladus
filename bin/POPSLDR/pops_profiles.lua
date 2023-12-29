--[[
  ___  ___  ___  ___ _                 _         
 | _ \/ _ \| _ \/ __| |   ___  __ _ __| |___ _ _ 
 |  _/ (_) |  _/\__ \ |__/ _ \/ _` / _` / -_) '_|
 |_|  \___/|_|  |___/____\___/\__,_\__,_\___|_|  
  Licensed under GNU General public license v3.0
--]]
LOG("Registering POPStarter profiles...")
local DEFAULT_PROFILE = 0 -- change this if you want a default profile. list starts counting from 1
PLDR.PROFILES = {
  {
    ELF="mass:/POPSLDR/PROFILES/MAIN/POPSTARTER.ELF";
    DESC="Latest popstarter without any modifications";
  },
  {
    ELF="mass:/POPSLDR/PROFILES/DEBUG/POPSTARTER.ELF";
    DESC="Latest popstarter with debug menus enabled";
  },
  {
    ELF="mass:/POPSLDR/PROFILES/USBDELAY/POPSTARTER.ELF";
    DESC="Latest popstarter with increased USB delay";
  },
  {
    ELF="mass:/POPSLDR/PROFILES/USBDELAY_DEBUG/POPSTARTER.ELF";
    DESC="Latest popstarter with increased USB delay & debug menus enabled";
  },
}

if DEFAULT_PROFILE > 0 and DEFAULT_PROFILE <= #PLDR.PROFILES then
  PLDR.POPSTARTER_PATH = PLDR.PROFILES[DEFAULT_PROFILE].ELF
end