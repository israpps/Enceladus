LOG("-- Initializing UI")
Font.ftInit()

BFONT = Font.ftLoad("NEUTRINO/font.ttf")
SFONT = Font.ftLoad("NEUTRINO/font.ttf")
LFONT = Font.ftLoad("NEUTRINO/font.ttf")
Font.ftSetCharSize(BFONT, 800, 800)
Font.ftSetCharSize(SFONT, 600, 600)

UI = {
  clear = function ()
    Screen.clear()
  end;

  flip = function ()
    Screen.flip()
  end;
  SCR = {
  X = 704;
  Y = 480;
  X_MID = (704/2);
  Y_MID = (480/2);
  }
}

GPAD = 0
OPAD = 0
PADC = 7
function PADListen()
  PADC = CYCLE_CLAMP(PADC-1, 0, 7)
  if PADC == 0 then
    OPAD = GPAD
    GPAD = Pads.get()
    return true
  else
    GPAD = 0
    return false
  end
end

YELLOW = Color.new(0xff, 0xff, 0)
GREY = Color.new(0x80, 0x80, 0x80)

function Font.ftPrintMultiLineAligned(font, x, y, spacing, width, height, text, color)
  local internal_y = y
  local COL = GREY
  if type(color) == "number" then COL = color end
  for line in text:gmatch("([^\n]*)\n?") do
    Font.ftPrint(font, x, internal_y, 8, width, height, line, COL)
    internal_y = internal_y+spacing
  end
end

function UI.UpdateVmode()
  local C = Screen.getMode()
  Screen.setMode(C.mode, UI.SCR.X, UI.SCR.Y, C.colorMode, C.interlace, C.field)
  LOGF(">> Screen size changed to %dx%d", UI.SCR.X, UI.SCR.Y)
end
UI.UpdateVmode()