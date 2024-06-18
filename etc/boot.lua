--[[
NEUTRINO Launcher by El_isra                                                         
LICENSE: GNU GPL v3
--]]
package.path = "./?.lua;./LUA/?.lua;./NEUTRINO/?.lua"

function LOG(...)
  print_uart(...)
  end
function LOGF(S, ...)
  print_uart(string.format(S, ...))
end

LOG("- NEUTRINO LAUNCHER -")
LOG("By El_isra. GFX by Berion. based on Enceladus")

require("loader")
