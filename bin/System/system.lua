Font.fmLoad() 
Screen.clear(Color.new(0,0,0))
local circle = Graphics.loadImage("pads/circle.png")
local cross = Graphics.loadImage("pads/cross.png")
local square = Graphics.loadImage("pads/square.png")
local triangle = Graphics.loadImage("pads/triangle.png")

local up = Graphics.loadImage("pads/up.png")
local down = Graphics.loadImage("pads/down.png")
local left = Graphics.loadImage("pads/left.png")
local right = Graphics.loadImage("pads/right.png")

local start = Graphics.loadImage("pads/start.png")
local pad_select = Graphics.loadImage("pads/select.png")

local r1 = Graphics.loadImage("pads/R1.png")
local r2 = Graphics.loadImage("pads/R2.png")

local l1 = Graphics.loadImage("pads/L1.png")
local l2 = Graphics.loadImage("pads/L2.png")

local l3 = Graphics.loadImage("pads/L3.png")
local r3 = Graphics.loadImage("pads/R3.png")
local MC = Graphics.loadImage("pads/MC.png")

local pad = nil
local rx = nil
local ry = nil
local lx = nil
local ly = nil
local pressure = nil

function checkmc
while true do
  Screen.clear(Color.new(0,0,0))

  Font.fmPrint(150, 25, 0.6, "\nKELF Manager\n")


  Font.fmPrint(150, 100, 0.5, "\nInstall System update\n") Graphics.drawImage(cross, 100.0, 100.0)
  Font.fmPrint(150, 140, 0.5, "\nInstall DVDPlayer update\n") Graphics.drawImage(triangle, 100.0, 140.0)
  Font.fmPrint(150, 180, 0.5, "\nManage System updates\n") Graphics.drawImage(square, 100.0, 180.0)
  Font.fmPrint(100, 370, 0.4, "\nCredits:\n")
  Font.fmPrint(100, 390, 0.4, "\nCoded By El_isra\n")
  Font.fmPrint(100, 405, 0.4, "\nbased on Enceladus by daniel santos, SECRMAN & SECRSIF thanks to SP193\n")

  pad = Pads.get()
  if Pads.check(pad, PAD_L2) then
  elseif
  elseif


  Screen.flip()
  --Screen.waitVblankStart()
end
