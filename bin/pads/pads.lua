



function DrawOnScreenDualshock(P)
  if P == 9 then
    Graphics.drawScaleImage(RES.select, X_MID-64, Y_MID-16, 32, 32)
  else
    Graphics.drawScaleImage(RES.select, X_MID-64, Y_MID-16, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 10 then
    Graphics.drawScaleImage(RES.start, X_MID+32, Y_MID-16, 32, 32)
  else
    Graphics.drawScaleImage(RES.start, X_MID+32, Y_MID-16, 32, 32, Color.new(128, 128, 128, 60))
  end

  if P == 5 then
    Graphics.drawScaleImage(RES.up, X_MID-216, Y_MID-64-8, 64, 64)
  else
    Graphics.drawScaleImage(RES.up, X_MID-216, Y_MID-64-8, 64, 64, Color.new(128, 128, 128, 60))
  end
  if P == 13 then
    Graphics.drawScaleImage(RES.down, X_MID-216, Y_MID+8, 64, 64)
  else
    Graphics.drawScaleImage(RES.down, X_MID-216, Y_MID+8, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 7 then
    Graphics.drawScaleImage(RES.left, X_MID-256, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(RES.left, X_MID-256, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 8 then
    Graphics.drawScaleImage(RES.right, X_MID-176, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(RES.right, X_MID-176, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 6 then
    Graphics.drawScaleImage(RES.triangle, X_MID+152, Y_MID-64-8, 64, 64)
  else
    Graphics.drawScaleImage(RES.triangle, X_MID+152, Y_MID-64-8, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 14 then
    Graphics.drawScaleImage(RES.cross, X_MID+152, Y_MID+8, 64, 64)
  else
    Graphics.drawScaleImage(RES.cross, X_MID+152, Y_MID+8, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 11 then
    Graphics.drawScaleImage(RES.square, X_MID+112, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(RES.square, X_MID+112, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 12 then
    Graphics.drawScaleImage(RES.circle, X_MID+192, Y_MID-32, 64, 64)
  else
    Graphics.drawScaleImage(RES.circle, X_MID+192, Y_MID-32, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 1 then
    Graphics.drawScaleImage(RES.L1, X_MID-256, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(RES.L1, X_MID-256, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 2 then
    Graphics.drawScaleImage(RES.L2, X_MID-184, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(RES.L2, X_MID-184, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 3 then
    Graphics.drawScaleImage(RES.R1, X_MID+112, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(RES.R1, X_MID+112, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 4 then
    Graphics.drawScaleImage(RES.R2, X_MID+184, Y_MID-140, 64, 64)
  else
    Graphics.drawScaleImage(RES.R2, X_MID+184, Y_MID-140, 64, 64, Color.new(128, 128, 128, 60))
  end


  if P == 15 then
    Graphics.drawScaleImage(RES.L3, X_MID-112, Y_MID+60, 64, 64)
  else
    Graphics.drawScaleImage(RES.L3, X_MID-112, Y_MID+60, 64, 64, Color.new(128, 128, 128, 60))
  end

  if P == 16 then
    Font.ftPrint(fontSmall, X_MID, Y_MID+82, 8, 500, 64, "AUTO")
  else
    Font.ftPrint(fontSmall, X_MID, Y_MID+82, 8, 500, 64, "AUTO", Color.new(128, 128, 128, 60))
  end

  if P == 17 then
    Graphics.drawScaleImage(RES.R3, X_MID+48, Y_MID+60, 64, 64)
  else
    Graphics.drawScaleImage(RES.R3, X_MID+48, Y_MID+60, 64, 64, Color.new(128, 128, 128, 60))
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
    Graphics.drawScaleImage(RES.BG, 0.0, 0.0, SCR_X, SCR_Y)
    DrawOnScreenDualshock(P)
    DrawUsableKeys(DUK_CIRCLE|DUK_CROSS, 0x70)
    Screen.flip()
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
        local A
        local keyy 
        A, keyy= DisplayGenerictMOptPromptDiag(DLG, PADBUTTONS[P], DrawOnScreenDualshock, DUK_CROSS|DUK_CIRCLE|DUK_TRIANGLE|DUK_SQUARE)
        if A > 0 then
          local VAL = nil
          if Pads.check(keyy, PAD_CROSS) or Pads.check(keyy, PAD_SQUARE) then
            VAL = OFM._start()
            if VAL ~= nil and Pads.check(keyy, PAD_SQUARE) and (VAL:sub(0, 2)=="mc") then VAL = "mc?"..VAL:sub(4) end
          elseif Pads.check(keyy, PAD_TRIANGLE) then
            local T = DisplayGenerictMOptPrompt(PS2BBL_CMDS, "Commands")
            if T > 0 then VAL = PS2BBL_CMDS.item[T] end
          end
          if VAL == nil or VAL == "" then else PS2BBL_MAIN_CONFIG.keys[P][A] = VAL end
        end
        D = 1
        pad = 0
      end
    end

    if D > 0 then D = D + 1 end
    if D > 7 then D = 0 end
    --Screen.waitVblankStart()
  end
  
end
KeyConfigDialog()