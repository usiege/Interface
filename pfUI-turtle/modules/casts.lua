pfUI:RegisterModule("turtle-customcasts", "vanilla", function()
    if (pfUI_config["disabled"] and
      pfUI_config["disabled"]["turtle-customcasts"]  == "1") then
      return
    end
    -- integration is already supplied -> return
    if pfUI.api.libcast.customcast["trueshot"] then return end

    -- add trueshot to pfUI's custom casts
    local libcast = pfUI.api.libcast
    local player = UnitName("player")

    libcast.customcast["trueshot"] = function(begin, duration)
      if begin then
        local duration = duration or 1000

        for i=1,32 do
          if UnitBuff("player", i) == "Interface\\Icons\\Racial_Troll_Berserk" then
            local berserk = 0.3
            if((UnitHealth("player")/UnitHealthMax("player")) >= 0.40) then
              berserk = (1.30 - (UnitHealth("player") / UnitHealthMax("player"))) / 3
            end
            duration = duration / (1 + berserk)
          elseif UnitBuff("player", i) == "Interface\\Icons\\Ability_Hunter_RunningShot" then
            duration = duration / 1.4
          elseif UnitBuff("player", i) == "Interface\\Icons\\Ability_Warrior_InnerRage" then
            duration = duration / 1.3
          elseif UnitBuff("player", i) == "Interface\\Icons\\Inv_Trinket_Naxxramas04" then
            duration = duration / 1.2
          end
        end

        local _,_, lag = GetNetStats()
        local start = GetTime() + lag/1000

        -- add cast action to the database
        libcast.db[player].cast = "Trueshot"
        libcast.db[player].rank = lastrank
        libcast.db[player].start = start
        libcast.db[player].casttime = duration
        libcast.db[player].icon = "Interface\\Icons\\Inv_spear_07"
        libcast.db[player].channel = nil
      else
        -- remove cast action to the database
        libcast.db[player].cast = nil
        libcast.db[player].rank = nil
        libcast.db[player].start = nil
        libcast.db[player].casttime = nil
        libcast.db[player].icon = nil
        libcast.db[player].channel = nil
      end
    end
  end)