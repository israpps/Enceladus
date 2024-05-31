LOG("- loader.lua begins")
LOG("CWD:", System.currentDirectory())

require("utils")
require("ui")
require("gamelist")

GameList.clist = {
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
}

while true do
  UI.clear()
  GameList.display(GameList.clist)
  UI.flip()
end