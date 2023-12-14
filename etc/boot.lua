package.path = "./POPSLDR/?.lua;./?.lua;mass:/POPSLDR/?.lua;mc0:/POPSLDR/?.lua;mc1:/POPSLDR/?.lua"
GPAD = 0
Font.ftInit()
BFONT = Font.LoadBuiltinFont()
Font.ftSetCharSize(BFONT, 800, 800)
function STOP() print("PROGRAM STOP") while true do end end
function RunScript(S)
  local A, ERR = dofile_protected(S)
  if not A then
    print(ERR)
    STOP()
  end
end

if doesFileExist("POPSLDR/System.lua") then
	RunScript("POPSLDR/System.lua");
end