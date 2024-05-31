
package.path = "./?.lua;./LUA/?.lua;./NEUTRINO/?.lua"

function LOG(...)
  print_uart(...)
  end
function LOGF(S, ...)
  print_uart(string.format(S, ...))
end

require("loader")
