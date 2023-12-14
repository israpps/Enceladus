print("Registering POPSLoader UI")
UI = {
    CURSCENE = 4;
    SCENES = {GUSB=1, GSMB=2, GHDD=3, MMAIN=4, MPROFILE=5};
    UpdateVmode = function ()
      Screen.setMode(UI.SCR.VMODE, UI.SCR.X, UI.SCR.Y, CT24, INTERLACED, FIELD)
    end;
    --- UI Constants
    SCR = {
      X = 702;
      X_MID = 702/2;
      Y = 480;
      Y_MID = 480/2;
      VMODE = _480p;
      BGCOL = Color.new(32, 0, 32);
    };
    --- Notifications queue handler
    Notif_queue = {
      display = function ()
        local Q
        if #UI.Notif_queue.msg < 1 then return end
        if #UI.Notif_queue.msg > 1 then Q = 0x50 elseif UI.Notif_queue.ALFA > 0x50 then Q = 0x50 else Q = UI.Notif_queue.ALFA end
        Graphics.drawRect(30, 30, UI.SCR.X_MID-30, 40, Color.new(0, 0, 0, Q))
        Font.ftPrint(BFONT, 32, 32, 0, UI.SCR.X_MID-30, 32, UI.Notif_queue.msg[1], Color.new(0, 100, 255, UI.Notif_queue.ALFA))
        UI.Notif_queue.ALFA = UI.Notif_queue.ALFA-1
        if UI.Notif_queue.ALFA < 1 then
          UI.Notif_queue.ALFA = 0x90
          table.remove(UI.Notif_queue.msg, 1)
        end
      end;
      ALFA = 0x80;
      msg = {};
    };
    --- wrapper for Screen.flip(), here you add UI draws that renders on top of everything (for example, error notifications)
    flip = function ()
      UI.Notif_queue.display()
      Screen.flip()
    end;
    WelcomeDraw = {
      Play = function ()
        local Q=0
        while Q<128 do
          Screen.clear(UI.SCR.BGCOL)
          Graphics.drawScaleImage(IMG[4], UI.SCR.X_MID-(Graphics.getImageWidth(IMG[4])),
          UI.SCR.Y_MID-(Graphics.getImageHeight(IMG[4])), Graphics.getImageWidth(IMG[4])*2, Graphics.getImageHeight(IMG[4])*2, Color.new(128,128,128,Q))
          UI.flip()
          Q=Q+1
        end
      end

    };
    --- UI draw routine applied before drawing UI, add background and stuff you want rendered UNDER UI and text
    BottomDraw = {
      Play = function ()
        Screen.clear(UI.SCR.BGCOL)
        Graphics.drawScaleImage(IMG[4], UI.SCR.X_MID-(Graphics.getImageWidth(IMG[4])),
        UI.SCR.Y_MID-(Graphics.getImageHeight(IMG[4])), Graphics.getImageWidth(IMG[4])*2, Graphics.getImageHeight(IMG[4])*2)
        --if UI.CURSCENE <= UI.SCENES.GHDD or UI.CURSCENE == UI.SCENES.MPROFILE then
          Graphics.drawRect(20, 20, UI.SCR.X-100, 398, Color.new(0, 0, 0, 40))
        --end
      end;
    };
    GameList = {
      MAXDRAW = 18;
      CURR = 1;
      Reset = function ()
        UI.GameList.CURR = 1;
      end;
      Play = function()
        local ammount = #PLDR.GAMES
        local STARTUP = 1
        if (UI.GameList.CURR > UI.GameList.MAXDRAW) then STARTUP = (ammount-UI.GameList.MAXDRAW+1) end
        for i = STARTUP, ammount do
          if i >= (STARTUP+UI.GameList.MAXDRAW) then break end
          local Y = 20+((i-STARTUP)*21)
          Font.ftPrint(BFONT, 30, Y, 0, UI.SCR.X, 16, string.sub(PLDR.GAMES[i],1, -5), i == UI.GameList.CURR and Color.new(128, 128, 0, 128) or Color.new(128, 128, 128, 128))
        end
        UI.Pad.Listen()
        if Pads.check(GPAD, PAD_CIRCLE) then UI.CURSCENE = UI.SCENES.MMAIN end
        if Pads.check(GPAD, PAD_DOWN) then UI.GameList.CURR = CLAMP(UI.GameList.CURR+1, 1, ammount) GPAD = 0 end
        if Pads.check(GPAD, PAD_UP) then UI.GameList.CURR = CLAMP(UI.GameList.CURR-1, 1, ammount) GPAD = 0 end
        if Pads.check(GPAD, PAD_CROSS) then
            print("System.loadELF('".. PLDR.POPSTARTER_PATH .."', 1, '"..PLDR.GAMEPATH .. PLDR.GAMES[UI.GameList.CURR].."')")
            if not doesFileExist(PLDR.POPSTARTER_PATH) then
              table.insert(UI.Notif_queue.msg, "Cant find POPSTARTER ELF\n"..PLDR.POPSTARTER_PATH)
            elseif not doesFileExist(PLDR.GAMEPATH .. PLDR.GAMES[UI.GameList.CURR]) then
              table.insert(UI.Notif_queue.msg, "Cant find Game\n"..PLDR.GAMEPATH .. PLDR.GAMES[UI.GameList.CURR])
            else
              PLDR.RunPOPStarterGame(PLDR.GAMEPATH .. PLDR.GAMES[UI.GameList.CURR])
            end
        end
      end;
    };
    ProfileQuery = {
      lastopt = 1;
      curopt = 1;
      Play = function ()
        local profcnt = #PLDR.PROFILES
        Font.ftPrint(BFONT, UI.SCR.X_MID, 30, 8, UI.SCR.X, 16, "Choose POPStarter Profile", Color.new(128,128,128))
        Font.ftPrint(BFONT, UI.SCR.X_MID, 60, 8, UI.SCR.X, 16, "Profile "..UI.ProfileQuery.curopt, Color.new(128,128,128))
        Font.ftPrint(BFONT, UI.SCR.X_MID, 190, 8, UI.SCR.X, 16, PLDR.PROFILES[UI.ProfileQuery.curopt].DESC, Color.new(128,128,128))
        Font.ftPrint(BFONT, UI.SCR.X_MID, 280, 8, UI.SCR.X, 16, PLDR.PROFILES[UI.ProfileQuery.curopt].ELF, Color.new(128,128,128, 110))
        UI.Pad.Listen()
        if Pads.check(GPAD, PAD_DOWN) then UI.ProfileQuery.curopt = CLAMP(UI.ProfileQuery.curopt+1, 1, profcnt) GPAD = 0 end
        if Pads.check(GPAD, PAD_UP) then UI.ProfileQuery.curopt = CLAMP(UI.ProfileQuery.curopt-1, 1, profcnt) GPAD = 0 end
        if Pads.check(GPAD, PAD_CIRCLE) then UI.CURSCENE = UI.SCENES.MMAIN end
        if Pads.check(GPAD, PAD_CROSS) then
          print("Chose profile", UI.ProfileQuery.curopt)
          if not doesFileExist(PLDR.PROFILES[UI.ProfileQuery.curopt].ELF) then
            print("ERROR: POPStarter profile points to non existent ELF")
            table.insert(UI.Notif_queue.msg, "POPStarter ELF missing")
          else
            PLDR.POPSTARTER_PATH = PLDR.PROFILES[UI.ProfileQuery.curopt].ELF
            UI.CURSCENE = UI.MainMenu
          end
        end
      end;
    };
    MainMenu = {
      OPT = 1;
      opts = {"USB", "SMB", "HDD"};
      Play = function ()
        local profcnt = 3
        Font.ftPrint(BFONT, UI.SCR.X_MID, 30, 8, UI.SCR.X, 16, "Welcome to POPStarter Loader", Color.new(128,128,128))
        for x = 1, #UI.MainMenu.opts do
          Graphics.drawImage(IMG[x], 256+(110*(x-1))-64, UI.SCR.Y_MID-64, x == UI.MainMenu.OPT and Color.new(128, 128, 0) or Color.new(128,128,128))
        end
        if UI.MainMenu.OPT > 1 then Font.ftPrint(BFONT, UI.SCR.X_MID, UI.SCR.Y_MID+UI.SCR.Y_MID/2, 8, UI.SCR.X, 16, "COMMING SOON", Color.new(128,128,0)) end
        UI.Pad.Listen()
        if Pads.check(GPAD, PAD_RIGHT) then UI.MainMenu.OPT = CLAMP(UI.MainMenu.OPT+1, 1, profcnt) GPAD = 0 end
        if Pads.check(GPAD, PAD_LEFT) then UI.MainMenu.OPT = CLAMP(UI.MainMenu.OPT-1, 1, profcnt) GPAD = 0 end
        if Pads.check(GPAD, PAD_START) then UI.CURSCENE = UI.SCENES.MPROFILE end
        if Pads.check(GPAD, PAD_CROSS) then
          print("Chose ", UI.MainMenu.OPT)
          if UI.MainMenu.OPT == 1 then
            if PLDR.GetPS1GameLists(".", nil) ~= nil then
              UI.CURSCENE = UI.MainMenu.OPT
            else
              table.insert(UI.Notif_queue.msg, "No games found on 'mass:/'")
            end
          end --because we still dont support HDD or SMB
        end
      end
    };
    Pad = {
      PDELAY = 150;
      CLK = 0;
      Listen = function ()
        if UI.Pad.Timer == nil then
          UI.Pad.Timer = Timer.new()
          UI.Pad.CLK = Timer.getTime(UI.Pad.Timer)
        end
        if (UI.Pad.CLK+UI.Pad.PDELAY) > Timer.getTime(UI.Pad.Timer) then
          GPAD = 0
        else
          GPAD = Pads.get()
          UI.Pad.CLK = Timer.getTime(UI.Pad.Timer)
        end
      end;
      Timer = nil;
    }
  }
 