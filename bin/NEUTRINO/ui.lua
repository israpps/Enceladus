require("utils") -- make sure dependencies are there

LOG("-- Initializing UI")
Font.ftInit()

BFONT = Font.ftLoad("NEUTRINO/font.ttf")
SFONT = Font.ftLoad("NEUTRINO/font.ttf")
LFONT = Font.ftLoad("NEUTRINO/font.ttf")
Font.ftSetCharSize(BFONT, 800, 800)
Font.ftSetCharSize(SFONT, 600, 600)

UI = {
  SCR = {
  X = 704;
  Y = 480;
  X_MID = (704/2);
  Y_MID = (480/2);
  };
  --- Notifications queue handler
  Notif_queue = {
    display = function ()
      local Q
      if #UI.Notif_queue.msg < 1 then return end
      if #UI.Notif_queue.msg > 1 then
        Q = 0x50
      elseif UI.Notif_queue.ALFA > 0x50 then
        Q = 0x50
      else
        Q = math.floor(UI.Notif_queue.ALFA)
      end
      Graphics.drawRect(30, 30, UI.SCR.X_MID-30, 40, Color.new(0, 0, 0, Q))
      Font.ftPrint(BFONT, 32, 32, 0, UI.SCR.X_MID-30, 32, UI.Notif_queue.msg[1], Color.new(0, 100, 255, math.floor(UI.Notif_queue.ALFA)))
      UI.Notif_queue.ALFA = UI.Notif_queue.ALFA-.4
      if UI.Notif_queue.ALFA < 1 then
        UI.Notif_queue.ALFA = 0x90
        table.remove(UI.Notif_queue.msg, 1)
      end
    end;
    ALFA = 0x80;
    add = function (NOTIF)
      LOG(NOTIF)
      table.insert(UI.Notif_queue.msg, NOTIF)
    end;
    msg = {};
  };
}

---  UI code done at the begining of main loop. place here all the drawing that must be done BEFORE UI Draw
function UI.Pre()
  Screen.clear() -- DONT DELETE
end

--- UI code done AFTER UI Draw.
function UI.Top()
  UI.Notif_queue.display() -- DONT DELETE
  Screen.flip() -- DONT DELETE
end

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