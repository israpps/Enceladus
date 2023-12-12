package.path = "./POPSLDR/?.lua;./?.lua;mass:/POPSLDR/?.lua;mc0:/POPSLDR/?.lua;mc1:/POPSLDR/?.lua"
GPAD = 0
Font.ftInit()
BFONT = Font.LoadBuiltinFont()
function RunScript(S)
  local A, ERR = dofile_protected(S)
  if not A then
    print(ERR)
    while true do end
  end
end

if doesFileExist("POPSLDR/System.lua") then
	RunScript("POPSLDR/System.lua");
end