--[[
NEUTRINO Launcher by El_isra                                                         
LICENSE: GNU GPL v3
--]]
package.path = "./NEUTRINO/?.lua;./?.lua;./LUA/?.lua"

function LOG(...)
  print_uart(...)
  end
function LOGF(S, ...)
  print_uart(string.format(S, ...))
end

LOG("- NEUTRINO LAUNCHER -")
LOG("By El_isra. GFX by Berion. based on Enceladus")

require("loader")
error("end of builtin script reached") -- to avoid enceladus returning an error without message after builtin script ends