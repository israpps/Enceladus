Font.fmLoad()

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
local MC = Graphics.loadImage("pads/MC.png")

local r1 = Graphics.loadImage("pads/R1.png")
local r2 = Graphics.loadImage("pads/R2.png")

local l1 = Graphics.loadImage("pads/L1.png")
local l2 = Graphics.loadImage("pads/L2.png")

local l3 = Graphics.loadImage("pads/L3.png")
local r3 = Graphics.loadImage("pads/R3.png")

local pad = nil
local rx = nil
local ry = nil
local lx = nil
local ly = nil
local pressure = nil
local mcinf0 = {type = 0, freemem = 0, format = 0}
local mcinf1 = {type = 0, freemem = 0, format = 0}
function SHIFT(x) return 1 << x end 
function InstallSYS() end
function UninstallSYS() end

function PickMC()
  local has_mc0
  local has_mc1
  local ANIM = 0
  local AUGMENT = 5
  local MCPORT = 0
  mcinf0 = System.getMCInfo(0)
  mcinf1 = System.getMCInfo(1)
  has_mc0 = mcinf0.type == 2
  has_mc1 = mcinf1.type == 2
  while true do
    Screen.clear()
    pad = Pads.get()
    if ANIM > 250 then
      mcinf0 = System.getMCInfo(0)
      mcinf1 = System.getMCInfo(1)
      has_mc0 = mcinf0.type == 2
      has_mc1 = mcinf1.type == 2
    end
    Font.fmPrint(150, 25, 0.7, "\nChoose a memory card slot")
    Font.fmPrint(100, 390, 0.4, string.format("Slot 0 - type=%d, freemem=%d, format=%d", mcinf0.type, mcinf0.freemem, mcinf0.format))
    Font.fmPrint(100, 420, 0.4, string.format("Slot 1 - type=%d, freemem=%d, format=%d", mcinf1.type, mcinf1.freemem, mcinf1.format))
    if Pads.check(pad, PAD_LEFT)  --[[ and has_mc0 ]] then MCPORT = 0 end
    if Pads.check(pad, PAD_RIGHT) --[[ and has_mc1 ]] then MCPORT = 1 end
    ANIM = ANIM + AUGMENT
    if ANIM > 250 then AUGMENT = -5 end
    if ANIM < 6   then AUGMENT = 5  end
    if true then
      if MCPORT == 0 then
        Graphics.drawImage(MC, 100.0, 190.0, Color.new(128, 128, 128, ANIM))
      else
        Graphics.drawImage(MC, 100.0, 190.0)
      end
    end

    if true then
      if MCPORT == 1 then
        Graphics.drawImage(MC, 400.0, 190.0, Color.new(128, 128, 128, ANIM))
      else
        Graphics.drawImage(MC, 400.0, 190.0)
      end
    end
    Screen.flip()
  end
end

function MainMenu()
  local shouldQuit = true
  while shouldQuit do
    Screen.clear()
    Font.fmPrint(150, 25, 0.7, "\nPlayStation System Update Manager\n")
    Font.fmPrint(100, 390, 0.4, "\nSpecial thanks to: DanielSantos, HWNJ, SP193 and your mother\n")
    pad = Pads.get()
    Graphics.drawImage(cross, 120.0, 100.0)
    Font.fmPrint(160, 110, 0.5, "Install System Update")
    Graphics.drawImage(triangle, 120.0, 150.0)
    Font.fmPrint(160, 160, 0.5, "Uninstall System Update")

    if Pads.check(pad, PAD_CROSS) then
      InstallSYS()
    end

    if Pads.check(pad, PAD_TRIANGLE) then
      UninstallSYS()
    end

    Screen.flip()
  end
end

PickMC()
--Secrman.init()
  MainMenu()
  while true do end


while true do
  Screen.clear()

  Font.fmPrint(150, 25, 0.6, "\nEnceladus project: Controls demo\n")
  Font.fmPrint(100, 370, 0.4, "\nTips:\n")
  Font.fmPrint(100, 390, 0.4, "\nPress R2+L2 to start rumble and R3+L3 to stop it.\n")
  Font.fmPrint(100, 405, 0.4, "\nButtons transparency varies with the pressure applied to them\n")

  pad = Pads.get()
  rx, ry = Pads.getRightStick()
  lx, ly = Pads.getLeftStick()

  if Pads.check(pad, PAD_SELECT) then
    Graphics.drawImage(pad_select, 260.0, 190.0)
  else
    Graphics.drawImage(pad_select, 260.0, 190.0, Color.new(128, 128, 128, 60))
  end
  
  if Pads.check(pad, PAD_START) then
    Graphics.drawImage(start, 380.0, 190.0)
  else
    Graphics.drawImage(start, 380.0, 190.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_UP) then
    pressure = Pads.getPressure(PAD_UP)
    Graphics.drawImage(up, 120.0, 155.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(up, 120.0, 155.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_DOWN) then
    pressure = Pads.getPressure(PAD_DOWN)
    Graphics.drawImage(down, 120.0, 225.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(down, 120.0, 225.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_LEFT) then
    pressure = Pads.getPressure(PAD_LEFT)
    Graphics.drawImage(left, 85.0, 190.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(left, 85.0, 190.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_RIGHT) then
    pressure = Pads.getPressure(PAD_RIGHT)
    Graphics.drawImage(right, 155.0, 190.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(right, 155.0, 190.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_TRIANGLE) then
    pressure = Pads.getPressure(PAD_TRIANGLE)
    Graphics.drawImage(triangle, 520.0, 155.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(triangle, 520.0, 155.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_CROSS) then
    pressure = Pads.getPressure(PAD_CROSS)
    Graphics.drawImage(cross, 520.0, 225.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(cross, 520.0, 225.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_SQUARE) then
    pressure = Pads.getPressure(PAD_SQUARE)
    Graphics.drawImage(square, 485.0, 190.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(square, 485.0, 190.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_CIRCLE) then
    pressure = Pads.getPressure(PAD_CIRCLE)
    Graphics.drawImage(circle, 555.0, 190.0, Color.new(128, 128, 128,  pressure))
  else
    Graphics.drawImage(circle, 555.0, 190.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_L1) then
    pressure = Pads.getPressure(PAD_L1)
    Graphics.drawImage(l1, 102.0, 100.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(l1, 102.0, 100.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_L2) then
    pressure = Pads.getPressure(PAD_L2)
    Graphics.drawImage(l2, 137.0, 100.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(l2, 137.0, 100.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_R1) then
    pressure = Pads.getPressure(PAD_R1)
    Graphics.drawImage(r1, 502.0, 100.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(r1, 502.0, 100.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_R2) then
    pressure = Pads.getPressure(PAD_R2)
    Graphics.drawImage(r2, 537.0, 100.0, Color.new(128, 128, 128, pressure))
  else
    Graphics.drawImage(r2, 537.0, 100.0, Color.new(128, 128, 128, 60))
  end

  Graphics.drawCircle(lx/4+257.0, ly/4+317.0, 8.0, Color.new(255, 0, 0, 255), 1)
  Graphics.drawCircle(rx/4+417.0, ry/4+317.0, 8.0, Color.new(255, 0, 0, 255), 1)

  Graphics.drawRect(220.0, 280.0, 75, 75, Color.new(128, 128, 128, 32))
  Graphics.drawRect(380.0, 280.0, 75, 75, Color.new(128, 128, 128, 32))

  if Pads.check(pad, PAD_L3) then
    Graphics.drawImage(l3, 242.0, 300.0)
  else
    Graphics.drawImage(l3, 242.0, 300.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_R3) then
    Graphics.drawImage(r3, 402.0, 300.0)
  else
    Graphics.drawImage(r3, 402.0, 300.0, Color.new(128, 128, 128, 60))
  end

  if Pads.check(pad, PAD_R2) and Pads.check(pad, PAD_L2) then
    Pads.rumble(1 ,255)
  end

  if Pads.check(pad, PAD_R3) and Pads.check(pad, PAD_L3) then
    Pads.rumble(0 ,0)
  end
  
  Screen.flip()
  --Screen.waitVblankStart()
end
