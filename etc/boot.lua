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

if doesFileExist("System/index.lua") then
	RunScript("System/index.lua");
  elseif doesFileExist("System/script.lua") then
    RunScript("System/script.lua");
  elseif doesFileExist("System/system.lua") then
    RunScript("System/system.lua");
  elseif doesFileExist("index.lua") then
    RunScript("index.lua");
  elseif doesFileExist("script.lua") then
    RunScript("script.lua");
  elseif doesFileExist("system.lua") then
    RunScript("system.lua");
end