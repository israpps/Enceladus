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

Graphics.setImageFilters(circle, NEAREST)
Graphics.setImageFilters(cross, NEAREST)
Graphics.setImageFilters(square, NEAREST)
Graphics.setImageFilters(triangle, NEAREST)
Graphics.setImageFilters(up, NEAREST)
Graphics.setImageFilters(down, NEAREST)
Graphics.setImageFilters(left, NEAREST)
Graphics.setImageFilters(right, NEAREST)
Graphics.setImageFilters(start, NEAREST)
Graphics.setImageFilters(pad_select, NEAREST)
Graphics.setImageFilters(r1, NEAREST)
Graphics.setImageFilters(r2, NEAREST)
Graphics.setImageFilters(l1, NEAREST)
Graphics.setImageFilters(l2, NEAREST)
Graphics.setImageFilters(l3, NEAREST)
Graphics.setImageFilters(r3, NEAREST)

function DrawOnScreenDualshock(P)
  if P == 9 then
    Graphics.drawScaleImage(pad_select, X_MID-64, Y_MID-16, 32, 32)
  else
    Graphics.drawScaleImage(pad_select, X_MID-64, Y_MID-16, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 10 then
    Graphics.drawScaleImage(start, X_MID+32, Y_MID-16, 32, 32)
  else
    Graphics.drawScaleImage(start, X_MID+32, Y_MID-16, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 5 then
    Graphics.drawScaleImage(up, X_MID-216, Y_MID-64-8, 64, 64)
  else
    Graphics.drawScaleImage(up, X_MID-216, Y_MID-64-8, 64, 64, Color.new(128, 128, 128, 60))
  end
  if P == 13 then
    Graphics.drawScaleImage(down, X_MID-216, Y_MID+8, 64, 64)
  else
    Graphics.drawScaleImage(down, X_MID-216, Y_MID+8, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 7 then
    Graphics.drawScaleImage(left, X_MID-256, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(left, X_MID-256, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 8 then
    Graphics.drawScaleImage(right, X_MID-176, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(right, X_MID-176, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 6 then
    Graphics.drawScaleImage(triangle, X_MID+152, Y_MID-64-8, 64, 64)
  else
    Graphics.drawScaleImage(triangle, X_MID+152, Y_MID-64-8, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 14 then
    Graphics.drawScaleImage(cross, X_MID+152, Y_MID+8, 64, 64)
  else
    Graphics.drawScaleImage(cross, X_MID+152, Y_MID+8, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 11 then
    Graphics.drawScaleImage(square, X_MID+112, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(square, X_MID+112, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 12 then
    Graphics.drawScaleImage(circle, X_MID+192, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(circle, X_MID+192, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 1 then
    Graphics.drawScaleImage(l1, X_MID-256, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(l1, X_MID-256, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 2 then
    Graphics.drawScaleImage(l2, X_MID-184, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(l2, X_MID-184, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 3 then
    Graphics.drawScaleImage(r1, X_MID+112, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(r1, X_MID+112, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 4 then
    Graphics.drawScaleImage(r2, X_MID+184, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(r2, X_MID+184, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end


  if P == 15 then
    Graphics.drawScaleImage(l3, X_MID-112, Y_MID+60, 64, 64)
  else
    Graphics.drawScaleImage(l3, X_MID-112, Y_MID+60, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 16 then
    Font.ftPrint(fontSmall, X_MID, Y_MID+82, 8, 500, 64, "AUTO")
  else
    Font.ftPrint(fontSmall, X_MID, Y_MID+82, 8, 500, 64, "AUTO", Color.new(128, 128, 128, 60))
  end

  if P == 17 then
    Graphics.drawScaleImage(r3, X_MID+48, Y_MID+60, 64, 64)
  else
    Graphics.drawScaleImage(r3, X_MID+48, Y_MID+60, 64, 64, Color.new(128, 128, 128, 60))
  end
end

function KeyConfigDialog()
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
  local pad = nil

  while true do
    Screen.clear()
    Graphics.drawScaleImage(BG, 0.0, 0.0, SCR_X, SCR_Y)
    DrawOnScreenDualshock(P)
    pad = Pads.get()
    if D == 0 then
      D = 1
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

      if Pads.check(pad, PAD_CROSS) then
        print("chose key ".. P .. "\n")
        local DLG = {
          item = {}
        }
        for x = 1, 3, 1 do
          if PS2BBL_MAIN_CONFIG.keys[P][x] == nil or PS2BBL_MAIN_CONFIG.keys[P][x] == "" then
            DLG.item[x] = "<not set>"
          else
            DLG.item[x] = PS2BBL_MAIN_CONFIG.keys[P][x]
          end
        end
        local A = DisplayGenerictMOptPromptDiag(DLG, PADBUTTONS[P], DrawOnScreenDualshock)
        if A > 0 then
          local VAL = OFM._start()
          if VAL == nil or VAL == "" then else PS2BBL_MAIN_CONFIG.keys[P][A] = VAL end
        end
        D = 1
        pad = 0
      end
    end

    Screen.flip()
    if D > 0 then D = D + 1 end
    if D > 7 then D = 0 end
    --Screen.waitVblankStart()
  end
  
end

KeyConfigDialog()