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

local pad = nil
local keymap = {}
keymap[1] = {01, 02, 03, 04}
keymap[2] = {05, 06}
keymap[3] = {07, 08, 09, 10, 11, 12}
keymap[4] = {13, 14}
keymap[5] = {15, 16, 17}
local X = 1
local Y = 1
local D = 1
local P = 1
while true do
  Screen.clear()
  Graphics.drawScaleImage(BG, 0.0, 0.0, SCR_X, SCR_Y)
  pad = Pads.get()
  if D == 0 then
    if Pads.check(pad, PAD_DOWN) and Y<5 then
      Y = Y+1
    end
    if Pads.check(pad, PAD_UP) and Y>1 then
      Y = Y-1
    end
    if Pads.check(pad, PAD_RIGHT) and X<#keymap[Y] then
      X = X+1
    end
    if Pads.check(pad, PAD_LEFT) and X>1 then
      X = X-1
    end
    if X >= #keymap[Y] then X = #keymap[Y] end
    --print(string.format("%d %d", Y, X))

    P = keymap[Y][X]
    D = 1
  end

  if Pads.check(pad, PAD_CROSS) then
    print("chose key ".. P .. "\n")
    local DLG = {
      item = {}
    }
    for x = 1, 3, 1 do
      table.insert(DLG.item, PS2BBL_MAIN_CONFIG.keys[P][x])
    end
    --DisplayGenerictMOptPromptDiag(DLG, PADBUTTONS[P])
  end

  if P == 9 then
    Graphics.drawScaleImage(pad_select, 260.0, 190.0, 32, 32)
  else
    Graphics.drawScaleImage(pad_select, 260.0, 190.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 10 then
    Graphics.drawScaleImage(start, 380.0, 190.0, 32, 32)
  else
    Graphics.drawScaleImage(start, 380.0, 190.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 5 then
    Graphics.drawScaleImage(up, 120.0, 155.0, 32, 32)
  else
    Graphics.drawScaleImage(up, 120.0, 155.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 13 then
    Graphics.drawScaleImage(down, 120.0, 225.0, 32, 32)
  else
    Graphics.drawScaleImage(down, 120.0, 225.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 7 then
    Graphics.drawScaleImage(left, 85.0, 190.0, 32, 32)
  else
    Graphics.drawScaleImage(left, 85.0, 190.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 8 then
    Graphics.drawScaleImage(right, 155.0, 190.0, 32, 32)
  else
    Graphics.drawScaleImage(right, 155.0, 190.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 6 then
    Graphics.drawScaleImage(triangle, 520.0, 155.0, 32, 32)
  else
    Graphics.drawScaleImage(triangle, 520.0, 155.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 14 then
    Graphics.drawScaleImage(cross, 520.0, 225.0, 32, 32)
  else
    Graphics.drawScaleImage(cross, 520.0, 225.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 11 then
    Graphics.drawScaleImage(square, 485.0, 190.0, 32, 32)
  else
    Graphics.drawScaleImage(square, 485.0, 190.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 12 then
    Graphics.drawScaleImage(circle, 555.0, 190.0, 32, 32)
  else
    Graphics.drawScaleImage(circle, 555.0, 190.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 1 then
    Graphics.drawScaleImage(l1, 102.0, 100.0, 32, 32)
  else
    Graphics.drawScaleImage(l1, 102.0, 100.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 2 then
    Graphics.drawScaleImage(l2, 137.0, 100.0, 32, 32)
  else
    Graphics.drawScaleImage(l2, 137.0, 100.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 3 then
    Graphics.drawScaleImage(r1, 502.0, 100.0, 32, 32)
  else
    Graphics.drawScaleImage(r1, 502.0, 100.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 4 then
    Graphics.drawScaleImage(r2, 537.0, 100.0, 32, 32)
  else
    Graphics.drawScaleImage(r2, 537.0, 100.0, 32, 32, Color.new(128, 128, 128, 60))
  end


  if P == 15 then
    Graphics.drawScaleImage(l3, 242.0, 300.0, 32, 32)
  else
    Graphics.drawScaleImage(l3, 242.0, 300.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 17 then
    Graphics.drawScaleImage(r3, 402.0, 300.0, 32, 32)
  else
    Graphics.drawScaleImage(r3, 402.0, 300.0, 32, 32, Color.new(128, 128, 128, 60))
  end

  
  Screen.flip()
  if D > 0 then D = D + 1 end
  if D > 10 then D = 0 end
  --Screen.waitVblankStart()
end