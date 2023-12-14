print("Loading images")
IMG = {
  Graphics.loadImage("POPSLDR/USB.PNG"),
  Graphics.loadImage("POPSLDR/SMB.PNG"),
  Graphics.loadImage("POPSLDR/HDD.PNG"),
  Graphics.loadImage("POPSLDR/PSL.PNG"),
}
for x=1, #IMG do
  Graphics.setImageFilters(IMG[x], LINEAR)
end