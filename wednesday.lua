getgenv().silent = true

game:GetService("Players").LocalPlayer.Idled:Connect(function()
   game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)

   task.wait(1)

   game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
end)

local start_tick = os.clock()

local cheat = {
   aimbot = {
      info = {},

      silent_angle = nil,
   },
   backtrack = {
      info = {},
   },
   visuals = {
      info = {},
   },
}

local interfaces = {}

local ui = loadfile("janlib.lua")()

local aimbot_tab = ui:AddTab("Aimbot", 1)
local aimbot_column_left = aimbot_tab:AddColumn()
local aimbot_column_right = aimbot_tab:AddColumn()
local aimbot_section_selection = aimbot_column_left:AddSection("Selection")
local aimbot_section_options = aimbot_column_left:AddSection("Options")
local aimbot_section_br = aimbot_column_right:AddSection("Bullet Redirection")

aimbot_section_selection:AddList({
   value = "",
   values = game:GetService("Players"):GetPlayers(),
   flag = "aimbot_players",
   callback = function()
      if (cheat.aimbot.info[ui.flags["aimbot_players"]]) then
         ui.options["aimbot_priority"]:SetValue(cheat.aimbot.info[ui.flags["aimbot_players"]]["Priority"])
      end

      ui.options["aimbot_priority"]:SetValue(0)
   end
})

aimbot_section_selection:AddSlider({
   min = 0,
   max = 5,
   value = 0,
   flag = "aimbot_priority",
   text = "Priority",
   callback = function(value)
      if (not cheat.aimbot.info[ui.flags["aimbot_players"]]) then
         cheat.aimbot.info[ui.flags["aimbot_players"]] = {}
      end

      cheat.aimbot.info[ui.flags["aimbot_players"]]["Priority"] = value
   end
})

aimbot_section_options:AddToggle({
   value = false,
   text = "Toggle Aimbot",
   flag = "aimbot_toggle"
})

aimbot_section_options:AddToggle({
   value = false,
   text = "Visible Only",
   flag = "aimbot_visible"
})

aimbot_section_options:AddToggle({
   value = false,
   text = "Barrel FOV",
   flag = "aimbot_barrel_fov"
})

aimbot_section_options:AddSlider({
   min = 0,
   max = 1000,
   value = 0,
   suffix = "px",
   flag = "aimbot_fov",
   text = "Field of View"
})

aimbot_section_br:AddToggle({
   value = false,
   text = "Redirection Toggle",
   flag = "aimbot_br"
})

aimbot_section_br:AddSlider({
   min = 0,
   max = 100,
   value = 0,
   suffix = "%",
   flag = "aimbot_br_hitchance",
   text = "Redirection Hitchance"
})

aimbot_section_br:AddSlider({
   min = 0,
   max = 100,
   value = 0,
   suffix = "%",
   flag = "aimbot_br_accuracy",
   text = "Redirection Accuracy"
})

local visuals_tab = ui:AddTab("Visuals", 2)
local visuals_column_left = visuals_tab:AddColumn()
local visuals_column_right = visuals_tab:AddColumn()
local visuals_section_selection = visuals_column_left:AddSection("Selection")
local visuals_section_options = visuals_column_left:AddSection("Options")
local visuals_section_other = visuals_column_right:AddSection("Other")

visuals_section_selection:AddList({
   value = "",
   values = {"Enemies", "Allies"},
   flag = "visuals_selection",
   multiselect = true
})

visuals_section_options:AddToggle({
   state = false,
   text = "Boxes",
   flag = "visuals_boxes"
}):AddColor({
   flag = "visuals_boxes_allies",
   color = Color3.fromRGB(63, 82, 255),
   trans = 1
}):AddColor({
   flag = "visuals_boxes_enemies",
   color = Color3.fromRGB(255, 83, 83),
   trans = 1
})

visuals_section_options:AddToggle({
   state = false,
   text = "Names",
   flag = "visuals_names"
}):AddColor({
   flag = "visuals_names_allies",
   color = Color3.fromRGB(63, 82, 255),
   trans = 1
}):AddColor({
   flag = "visuals_names_enemies",
   color = Color3.fromRGB(255, 83, 83),
   trans = 1
})

visuals_section_options:AddToggle({
   state = false,
   text = "Health Bars",
   flag = "visuals_health_bars"
}):AddColor({
   flag = "visuals_health_bars_allies",
   color = Color3.fromRGB(0, 255, 0),
   trans = 1
}):AddColor({
   flag = "visuals_health_bars_enemies",
   color = Color3.fromRGB(0, 255, 0),
   trans = 1
})

visuals_section_options:AddToggle({
   state = false,
   text = "Chams",
   flag = "visuals_chams"
}):AddColor({
   flag = "visuals_chams_allies",
   color = Color3.fromRGB(63, 82, 255),
   trans = 1
}):AddColor({
   flag = "visuals_chams_enemies",
   color = Color3.fromRGB(255, 83, 83),
   trans = 1
})

visuals_section_options:AddList({
   value = "",
   values = {"Visible", "Invisible"},
   flag = "visuals_chams_selection",
   multiselect = true
})

--[[
visuals_section_options:AddToggle({
   state = false,
   text = "Outlines",
   flag = "visuals_outlines"
}):AddColor({
   flag = "visuals_outlines_allies",
   color = Color3.fromRGB(63, 82, 255),
   trans = 1
}):AddColor({
   flag = "visuals_outlines_enemies",
   color = Color3.fromRGB(255, 83, 83),
   trans = 1
})
]]--

visuals_section_other:AddToggle({
   state = false,
   text = "Show FOV",
   flag = "visuals_show_fov"
}):AddColor({
   flag = "visuals_fov",
   color = Color3.fromRGB(255, 255, 255),
   trans = 1
})

local misc_tab = ui:AddTab("Misc", 3)
local misc_column_left = misc_tab:AddColumn()
local misc_column_right = misc_tab:AddColumn()
local misc_section_options = misc_column_right:AddSection("Options")
local misc_section_streamer = misc_column_left:AddSection("Streamer")
local misc_section_cases = misc_column_left:AddSection("Cases")

misc_section_options:AddToggle({
   state = false,
   text = "Auto Spot",
   flag = "misc_auto_spot"
})

misc_section_options:AddToggle({
   state = false,
   text = "No Supression Assist",
   tip = "Removes suppression assist points.",
   flag = "misc_no_supression_assist"
})

misc_section_options:AddToggle({
   state = false,
   text = "Rainbow Tag Color",
   tip = "If you have a tag, it'll be rainbow!",
   flag = "misc_rainbow_tag"
})

misc_section_options:AddToggle({
   state = false,
   text = "God Mode",
   tip = "Weee funny god mode lole",
   flag = "misc_god_mode"
})

--[[
misc_section_cases:AddToggle({
   state = true,
   text = "Auto Roll Legendaries",
   flag = "misc_auto_roll_legendaries"
})
]]

misc_section_cases:AddToggle({
   state = false,
   text = "Auto Roll Skins",
   flag = "misc_auto_roll"
})

misc_section_cases:AddButton({
   text = "Roll Skins",
   flag = "misc_roll_skins",
   callback = function()
      local info = {
         ["Keys"] = {},
         ["Cases"] = {},
      }

      for _, item in next, interfaces.settings.inventorydata do
         if (item["Type"] == "Case Key") then
            if (not info["Keys"][item["Name"]]) then
               info["Keys"][item["Name"]] = 0
            end

            info["Keys"][item["Name"]] += 1
         end

         if (item["Type"] == "Case") then
            if (not info["Cases"][item["Name"]]) then
               info["Cases"][item["Name"]] = 0
            end

            info["Cases"][item["Name"]] += 1
         end
      end

      for key, quantity in next, info["Keys"] do
         if (not info["Cases"][key]) then continue end

         while (info["Cases"][key] > 0 and quantity > 0) do
            interfaces.net:send("startrollrequest", key, nil)

            info["Cases"][key] -= 1
            info["Keys"][key] -= 1

            task.wait(2)
         end
      end
   end
})

--[[
misc_section_cases:AddButton({
   text = "Dupe Roll Skins",
   flag = "misc_dupe_roll_skins",
   callback = function()
      local info = {
         ["Keys"] = {},
         ["Cases"] = {},
         ["Ignore"] = {},
      }

      local filter = {}

      for skin, info in next, interfaces.camo_database do
        if (info.Rarity ~= 3) then continue end

        filter[skin] = true
      end

      for _, item in next, interfaces.settings.inventorydata do
         if (item["Type"] == "Case Key") then
            if (not info["Keys"][item["Name"] ]) then
               info["Keys"][item["Name"] ] = 0
            end

            info["Keys"][item["Name"] ] += 1
         end

         if (item["Type"] == "Case") then
            if (not info["Cases"][item["Name"] ]) then
               info["Cases"][item["Name"] ] = 0
            end

            info["Cases"][item["Name"] ] += 1
         end

         if (item["Type"] == "Skin") then
            if (not info["Ignore"][item["Name"] ]) then
               info["Ignore"][item["Name"] ] = {}
            end

            info["Ignore"][item["Name"] ][item["Wep"] ] = true
         end
      end

      for key, quantity in next, info["Keys"] do
         if (not info["Cases"][key]) then continue end

         repeat task.wait() until ((interfaces.clock.getTime() - math.floor(interfaces.clock.getTime())) * 10) < 1

         local leave = false

         task.spawn(function()
            while(task.wait()) do
               if (leave or not (info["Cases"][key] > 0 and quantity > 0)) then break end

               repeat task.wait() until ((interfaces.clock.getTime() - math.floor(interfaces.clock.getTime())) * 10) < 1

               interfaces.net:send("startrollrequest", key, nil)

               info["Cases"][key] -= 1
               info["Keys"][key] -= 1

               task.wait(0.2)
            end
         end)

         while (info["Cases"][key] > 0 and quantity > 0) do
            task.wait()

            for _, item in next, interfaces.settings.inventorydata do
               if (item["Type"] == "Skin") then
                  if (filter[item["Name"] ] or (item["Legendary"] and ui.flags["misc_auto_roll_legendaries"])) then
                     if (info["Ignore"][item["Name"] ] and info["Ignore"][item["Name"] ][item["Wep"] ]) then continue end

                     leave = true
                  end
               end
            end

            if (leave) then break end
         end

         while (info["Cases"][key] > 0 and quantity > 0) do
            interfaces.net:send("startrollrequest", key, nil)

            info["Cases"][key] -= 1
            info["Keys"][key] -= 1
         end
      end
   end
})
]]--

misc_section_cases:AddButton({
   text = "Sell All Skins",
   unsafe = true,
   tip = "Sells all very rare skins that aren't legendaries.",
   flag = "misc_sell_all_skins",
   callback = function()
      local info = {}

      local filter = {}

      for skin, info in next, interfaces.camo_database do
        if (info.Rarity ~= 4) then continue end

        filter[skin] = true
      end

      for _, item in next, interfaces.settings.inventorydata do
         if (item["Type"] == "Skin") then
            if (not item["Legendary"]) then
               continue
            end

            if (not filter[item["Name"]]) then
               continue
            end

            if (not info[item["Name"]]) then
               info[item["Name"]] = {}
            end

            if (not info[item["Name"]][item["Wep"]]) then
               info[item["Name"]][item["Wep"]] = 0
            end

            info[item["Name"]][item["Wep"]] += 1
         end
      end

      for _, item in next, interfaces.settings.inventorydata do
         if (item["Type"] == "Skin") then
            if (info[item["Name"]] and info[item["Name"]][item["Wep"]]) then
               if (info[item["Name"]][item["Wep"]] == 1) then
                  continue
               else
                  info[item["Name"]][item["Wep"]] -= 1
               end
            end

            interfaces.net:send("sellskinrequest", item["Name"], item["Wep"])
         end
      end
   end
})

misc_section_cases:AddButton({
   text = "Sell Skins",
   flag = "misc_sell_skins",
   callback = function()
      local info = {}

      local filter = {}

      for skin, info in next, interfaces.camo_database do
        if (info.Rarity ~= 4) then continue end

        filter[skin] = true
      end

      for _, item in next, interfaces.settings.inventorydata do
         if (item["Type"] == "Skin") then
            -- if (not item["Legendary"]) then
            --    continue
            -- end

            if (not filter[item["Name"]]) then
               continue
            end

            if (not info[item["Name"]]) then
               info[item["Name"]] = {}
            end

            if (not info[item["Name"]][item["Wep"]]) then
               info[item["Name"]][item["Wep"]] = 0
            end

            info[item["Name"]][item["Wep"]] += 1
         end
      end

      for _, item in next, interfaces.settings.inventorydata do
         if (item["Type"] == "Skin") then
            if (info[item["Name"]] and info[item["Name"]][item["Wep"]]) then
               if (info[item["Name"]][item["Wep"]] == 1) then
                  continue
               else
                  info[item["Name"]][item["Wep"]] -= 1
               end
            end

            interfaces.net:send("sellskinrequest", item["Name"], item["Wep"])
         end
      end
   end
})

misc_section_cases:AddButton({
   text = "Buy Cases",
   flag = "misc_buy_cases",
   callback = function()
      interfaces.net:send("purchasecaserequest", ui.flags["misc_case_to_buy"], ui.flags["misc_buy_amount"], nil)
      interfaces.net:send("purchasekeyrequest", ui.flags["misc_case_to_buy"], ui.flags["misc_buy_amount"])
   end
})

misc_section_cases:AddList({
   text = "Case To Buy",
   value = "",
   values = {},
   flag = "misc_case_to_buy",
})

misc_section_cases:AddSlider({
   min = 0,
   max = 100,
   value = 0,
   suffix = "",
   flag = "misc_buy_amount",
   text = "Case Amount"
})

misc_section_streamer:AddToggle({
   state = true,
   text = "Disable Logs",
   tip = "Stop the severs logemessage & debug event.",
   flag = "misc_disable_logs"
})

ui:Init()

function cheat:safe_call(func)
   pcall(func, function()
      return false
   end)

   return true
end

function cheat:detour(name, loc, func)
   local old_function = nil

   local ran_successfully = cheat:safe_call(function()
      old_function = loc[name]

      loc[name] = newcclosure(function(...)
         if (not getgenv().library) then
            loc[name] = old_function

            return old_function(...)
         end

         return func(old_function, ...)
      end)
   end)

   if (ran_successfully) then
      ui:Notification("print", "Hooked", synlog.chalk(name).light.black)
   else
      ui:Notification("warn", "Failed To Hook", synlog.chalk(name).light.black)
   end
end

function cheat:render_stepped(priority, func, unload)
   local random_name = tostring(func)

   game:GetService("RunService"):BindToRenderStep(random_name, priority, function()
      if (not getgenv().library) then
         game:GetService("RunService"):UnbindFromRenderStep(random_name)

         if (unload) then
            unload()
         end

         return
      end

      func()
   end)
end

function cheat:heart_beat(func, unload)
   local connection

   connection = game:GetService("RunService").Heartbeat:Connect(function(delta)
      if (not getgenv().library) then
         connection:Disconnect()

         if (unload) then
            unload()
         end

         return
      end

      func(delta)
   end)
end

for _,table in next, getgc(true) do
   if (typeof(table) == "function") then
      local name = getinfo(table).name

      if (name == "bulletcheck") then
         interfaces.bulletcheck = table
      elseif (name == "trajectory") then
         interfaces.trajectory = table
      elseif (name == "call") then
         interfaces.call = table
      elseif (name == "loadplayer") then
         interfaces.loadplayer = table
      elseif (name == "rankcalculator") then
         interfaces.rankcalculator = table
      elseif (name == "gunbob") then
         interfaces.gunbob = table
      elseif (name == "gunsway") then
         interfaces.gunsway = table
      elseif (name == "getupdater") then
         interfaces.getupdater = table
      elseif (name == "updateplayernames") then
         interfaces.updateplayernames = table
      end
   end

   if (typeof(table) == "table") then
      if (rawget(table, "deploy")) then
         interfaces.menu = table
      elseif (rawget(table, "send")) then
         interfaces.net = table
      elseif (rawget(table, "gammo")) then
         interfaces.logic = table
      elseif (rawget(table, "setbasewalkspeed")) then
         interfaces.char = table
      elseif (rawget(table, "basecframe")) then
         interfaces.cam = table
      elseif (rawget(table, "votestep")) then
         interfaces.hud = table
      elseif (rawget(table, "getbodyparts")) then
         interfaces.replication = table
      elseif (rawget(table, "play")) then
         interfaces.sound = table
      elseif (rawget(table, "checkkillzone")) then
         interfaces.roundsystem = table
      elseif (rawget(table, "new") and rawget(table, "step") and rawget(table, "reset")) then
         setreadonly(table, false)

         interfaces.particle = table
      elseif (rawget(table, "unlocks")) then
         interfaces.dirtyplayerdata = table
      elseif (rawget(table, "toanglesyx")) then
         interfaces.vectorutil = table
      elseif (rawget(table, "IsVIP")) then
         interfaces.instancetype = table
      elseif (rawget(table, "timehit")) then
         interfaces.physics = table
      elseif (rawget(table, "raycastSingleExit")) then
         interfaces.raycastutil = table
      elseif (rawget(table, "bulletLifeTime")) then
         interfaces.publicsettings = table
      elseif (rawget(table, "player") and rawget(table, "reset")) then
         interfaces.animation = table
         interfaces.animation.oldplayer = interfaces.animation.player
         interfaces.animation.oldreset = interfaces.animation.reset
      elseif (rawget(table, "inventorydata")) then
         interfaces.settings = table
      -- elseif (rawget(table, "productionDatabase")) then
      --    interfaces.database = table
      end
   end
end

for _, module in next, getloadedmodules() do
   if (module.Name == "GameClock") then
      interfaces.clock = require(module)
   elseif (module.Name == "CaseDatabase") then
      interfaces.case_database = require(module)
   elseif (module.Name == "CamoDatabase") then
      interfaces.camo_database = require(module)
   end
end

for case_name, _ in next, interfaces.case_database do
   ui.options["misc_case_to_buy"]:AddValue(case_name, false)
   ui.options["misc_case_to_buy"].value = "Starter"
end

cheat:detour("new", interfaces.particle, function(original, particle, ...)
   local magnitude = particle.velocity.Magnitude

   if (ui.flags["aimbot_br"] and cheat.aimbot.silent_angle) then
      particle.velocity = (cheat.aimbot.silent_angle).Unit * magnitude
   end

   return original(particle, ...)
end)

cheat:detour("send", interfaces.net, function(original, self, event, ...)
   local arguments = {...}

   -- Phantom update obscured strings for some reason...
   local correct_event = string.gsub(event, "​", "")

   if (ui.flags["misc_disable_logs"]) then
      if (correct_event == "logmessage" or correct_event == "debug") then
         return
      end
   end

   if (ui.flags["exploits_no_fall"]) then
      if (correct_event == "falldamage") then
         return
      end
   end

   -- This removes the points from, "Suppressed Enemy". Stupid but still an exploit.
   if (ui.flags["misc_no_supression_assist"]) then
      if (correct_event == "suppressionassist") then
         return
      end
   end

   if (correct_event == "newbullets") then
      if (cheat.aimbot.silent_angle) then
         for _,bullet in next, arguments[1].bullets do
            bullet[1] = cheat.aimbot.silent_angle
         end
      end
   end

   if (correct_event == "repupdate") then
      if (ui.flags["misc_god_mode"]) then
         return
      end
   end

   if (ui.flags["misc_auto_spot"]) then
      if (correct_event == "ping") then
         for _, player in next, game:GetService("Players"):GetPlayers() do
            if (player.Team == game:GetService("Players").LocalPlayer.Team) then continue end

            interfaces.net:send("spotplayers", {player}, interfaces.clock.getTime())
         end
      end
   end

   if (ui.flags["misc_rainbow_tag"]) then
      if (correct_event == "ping") then
         interfaces.net:send("changetagcolor", math.random(0, 255), math.random(0, 255), math.random(0, 255))
      end
   end

   return original(self, event, unpack(arguments))
end)

-- Backtrack helper
cheat:heart_beat(function(delta)
   local function hook_player(player)
      local player_updater = interfaces.replication.getupdater(player)
      local player_info = cheat.backtrack.info[player]

      player_info.old_getpos = player_updater.getpos
      player_info.hooked = true

      player_updater.getpos = newcclosure(function(...)
         -- do backtrack :3
         if (player_info.running) then
            return player_info.torso_position.Position, player_info.torso_position.Position, player_info.head_position.Position
         end

         return player_info.old_getpos(...)
      end)
   end

   for _, player in next, game:GetService("Players"):GetPlayers() do
      local player_info = cheat.backtrack.info[player]

      if (not interfaces.replication.getupdater(player)) then
         if (player_info) then
            cheat.backtrack.info[player] = {}
         end

         continue
      end

      if (not player_info) then
         cheat.backtrack.info[player] = {}
         cheat.backtrack.info[player].records = {}
         cheat.backtrack.info[player].hooked = false
         cheat.backtrack.info[player].parts = interfaces.replication.getbodyparts(player)

         player_info = cheat.backtrack.info[player]
      end

      if (not player_info.hooked) then
         hook_player(player)
      end

      player_info.parts = interfaces.replication.getbodyparts(player)

      if (not player_info.parts) then
         continue
      end

      local record_tick = tick()

      player_info.records[record_tick] = {}
      player_info.records[record_tick].parts = {unpack(player_info.parts)}

      -- Validity check
      for record_tick, record_info in next, player_info.records do
         if (tick() - record_tick > 3) then
            player_info.records[record_tick] = nil
         end
      end

      if (player_info.active_record) then
         for _, part in next, player_info.active_record.parts do
            player_info.parts[part.Name].CFrame = part.CFrame
         end
      end
   end
end, function()
   for _, player in next, game:GetService("Players"):GetPlayers() do
      local function unhook_player(player)
         local player_updater = interfaces.replication.getupdater(player)
         local player_info = cheat.backtrack.info[player]

         player_updater.getpos = player_info.old_getpos
      end

      local player_info = cheat.backtrack.info[player]

      if (not player_info) then
         continue
      end

      unhook_player(player)
   end
end)

-- Aimbot
cheat:heart_beat(function(delta)
   if (not ui.flags["aimbot_toggle"]) then return end

   local function get_fov(screen_vector_1, screen_vector_2)
      return (screen_vector_1 - screen_vector_2).Magnitude
   end

   local function get_closest_record(player)
      local closest_record
      local closest_fov = math.huge

      local player_info = cheat.backtrack.info[player]

      for _, record in next, player_info.records do
         local player_parts = record.parts

         if (not player_parts) then continue end

         local player_screen_vector, player_on_screen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(player_parts.torso.Position)

         for _, part in next, player_parts do
            if (player_on_screen) then break end

            player_screen_vector, player_on_screen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(part.Position)
         end

         if (not player_on_screen) then continue end

         local viewport_size = game:GetService("Workspace").CurrentCamera.ViewportSize

         local player_fov = get_fov(viewport_size / 2, Vector2.new(player_screen_vector.X, player_screen_vector.Y))

         if (player_fov > ui.flags["aimbot_fov"] * interfaces.char.unaimedfov / game:GetService("Workspace").CurrentCamera.FieldOfView) then continue end

         if (closest_fov < player_fov) then continue end

         closest_player = player
         closest_fov = player_fov
      end
   end

   local function get_closest_player()
      local closest_player
      local closest_part
      local closest_fov = math.huge

      for _, player in next, game:GetService("Players"):GetPlayers() do
         if (player == game:GetService("Players").LocalPlayer) then continue end

         local player_parts = interfaces.replication.getbodyparts(player)

         if (not player_parts) then continue end
         if (player.Team == game:GetService("Players").LocalPlayer.Team) then continue end

         local player_screen_vector, player_on_screen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(player_parts.torso.Position)

         for _,part in next, player_parts do
            if (player_on_screen) then break end

            player_screen_vector, player_on_screen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(part.Position)
         end

         if (not player_on_screen) then continue end
         if (interfaces.hud:getplayerhealth(player) < 1) then continue end

         local viewport_size = game:GetService("Workspace").CurrentCamera.ViewportSize / 2

         if (interfaces.logic.currentgun) then
            if (ui.flags["aimbot_barrel_fov"] and interfaces.logic.currentgun.barrel) then
               viewport_size = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(interfaces.logic.currentgun.barrel.Position)
            end
         end

         local player_fov = get_fov(Vector2.new(viewport_size.X, viewport_size.Y), Vector2.new(player_screen_vector.X, player_screen_vector.Y))

         if (player_fov > ui.flags["aimbot_fov"] * interfaces.char.unaimedfov / game:GetService("Workspace").CurrentCamera.FieldOfView) then continue end

         if (closest_fov < player_fov) then continue end

         closest_player = player
         closest_fov = player_fov
      end

      closest_fov = math.huge
      local player_parts = interfaces.replication.getbodyparts(closest_player)

      if (not player_parts) then return end

      for name, part in next, player_parts do
         if(not part) then continue end
         if(name == "rootpart") then continue end

         local part_screen_vector, part_on_screen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(part.Position)

         if(not part_on_screen) then continue end

         local viewport_size = game:GetService("Workspace").CurrentCamera.ViewportSize

         local part_fov = get_fov(viewport_size / 2, Vector2.new(part_screen_vector.X, part_screen_vector.Y))

         if(part_fov > ui.flags["aimbot_fov"] * interfaces.char.unaimedfov / game:GetService("Workspace").CurrentCamera.FieldOfView) then continue end

         if(closest_fov < part_fov) then continue end

         closest_part = part
         closest_fov = part_fov
      end

      return closest_player, closest_part
   end

   local function get_bullet_trajectory(position, origin)
      if (not interfaces.logic.currentgun) then return end
      if (not interfaces.logic.currentgun.data) then return end

      origin = origin or game:GetService("Workspace").CurrentCamera.CFrame.Position

      local trajectory = interfaces.trajectory(origin, Vector3.new(0, -192.6, 0), position, interfaces.logic.currentgun.data.bulletspeed)

      return trajectory and origin + trajectory or false
   end

   local function get_silent_angle(part, player, player_origin)
      if (not part or not part.Position or not interfaces.logic.currentgun) then return end
      if (not interfaces.logic.currentgun or not interfaces.logic.currentgun.barrel) then return end
      if (interfaces.logic.currentgun.type == "KNIFE") then return end
      if (math.random(0, 100) > ui.flags["aimbot_br_hitchance"]) then return end

      if (not cheat.aimbot.info[player.Name]) then
         cheat.aimbot.info[player.Name] = {
            last_position = Vector3.zero,
         }
      end

      local origin = interfaces.logic.currentgun.barrel.Position

      local time_to_hit = (part.Position - origin).Magnitude / interfaces.logic.currentgun.data.bulletspeed
      local velocity = (player_origin - cheat.aimbot.info[player.Name].last_position) * (1 / delta)
      local target = part.Position + (velocity * time_to_hit)

      local delta_time_to_hit = (target - origin).Magnitude / interfaces.logic.currentgun.data.bulletspeed
      local delta_velocity = (player_origin - cheat.aimbot.info[player.Name].last_position) * (1 / delta_time_to_hit)
      local delta_target = part.Position + (delta_velocity * delta_time_to_hit)

      local random_angle = math.random(-(1 / (ui.flags["aimbot_br_accuracy"] / 100)) * 100, (1 / (ui.flags["aimbot_br_accuracy"] / 100)) * 100)
      local random_vector = Vector3.new(random_angle, random_angle, random_angle) / 100

      local trajectory = get_bullet_trajectory(delta_target + random_vector, origin)

      if (not trajectory) then return end

      local direction = trajectory - origin

      cheat.aimbot.info[player.Name].last_position = player_origin

      return direction.Unit
   end

   if (ui.flags["aimbot_br"]) then
      cheat.aimbot.silent_angle = nil

      if (not interfaces.char.alive) then return end
      if (not interfaces.logic.currentgun.barrel) then return end

      local player, closest_part = get_closest_player()
      local player_parts = interfaces.replication.getbodyparts(player)
      local camera_position = game:GetService("Workspace").CurrentCamera.CFrame.Position

      if (not player_parts) then return end

      local is_player_part = false

      for _, part in next, player_parts do
         if(is_player_part) then break end
         if(not ui.flags["aimbot_visible"]) then break end

         local camra_direction = part.Position - camera_position

         local parameters = RaycastParams.new()

         parameters.FilterDescendantsInstances = {game:GetService("Workspace").CurrentCamera, game:GetService("Players").LocalPlayer.Character}
         parameters.FilterType = Enum.RaycastFilterType.Blacklist

         local result = game:GetService("Workspace"):Raycast(camera_position, camra_direction, parameters)

         if (result and part == result.Instance) then
            is_player_part = true
         end
      end

      if (ui.flags["aimbot_visible"] and not is_player_part) then return end

      cheat.aimbot.silent_angle = get_silent_angle(closest_part, player, player_parts.torso.Position)
   end
end, function()

end)

-- AC130 Mode
--[[
task.spawn(function()
   while (task.wait()) do
      if (ui.flags["misc_ac130_mode"]) then
         for _, player in next, game:GetService("Players"):GetPlayers() do
            if (player == game:GetService("Players").LocalPlayer) then continue end
            if (player.Team == game:GetService("Players").LocalPlayer.Team) then continue end

            if (not interfaces.char.alive) then continue end
            if (not interfaces.logic.currentgun) then continue end

            task.wait(5)

            local player_parts = interfaces.replication.getbodyparts(player)

            if (not player_parts) then continue end

            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Anchored = true

            local old_position = Vector3.new(0, 100, 0)

            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(old_position)

            task.wait(1)

            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(player_parts.torso.Position + Vector3.new(0, 7, 0))

            interfaces.net:send("spotplayers", {player}, interfaces.clock.getTime())

            task.wait()

            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(old_position)
         end
      end
   end
end)
]]--

-- Visuals
cheat:render_stepped(1, function()
   -- Thanks nata :-)
   local function get_bounding_box(player)
      if (not interfaces.hud:isplayeralive(player)) then return end

      local camera_cframe = game:GetService("Workspace").CurrentCamera.CFrame
      local player_parts = interfaces.replication.getbodyparts(player)

      if (not player_parts) then return end

      local torso_cframe = player_parts.torso.CFrame
      local matrix_top = torso_cframe.Position + (torso_cframe.UpVector * 1.5) + camera_cframe.UpVector
      local matrix_bottom = torso_cframe.Position - (torso_cframe.UpVector * 3)

      local top, top_is_visible = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(matrix_top)
      local bottom, bottom_is_visible = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(matrix_bottom)

      if (not top_is_visible and not bottom_is_visible) then return end

      local width = math.floor(math.abs(top.X - bottom.X))
      local height = math.floor(math.max(math.abs(bottom.Y - top.Y), width * 0.6))
      local box_size = Vector2.new(math.floor(math.max(height / 1.7, width * 1.8)), height)
      local box_position = Vector2.new(math.floor(top.X * 0.5 + bottom.X * 0.5 - box_size.X * 0.5), math.floor(math.min(top.Y, bottom.Y)))

      return box_position, box_size
   end

   local local_player = game:GetService("Players").LocalPlayer

   if (not cheat.visuals.info[local_player]) then
      cheat.visuals.info[local_player] = {}
   end

   if (ui.flags["visuals_show_fov"]) then
      local fov_ratio = interfaces.char.unaimedfov / game:GetService("Workspace").CurrentCamera.FieldOfView
      local viewport_size = game:GetService("Workspace").CurrentCamera.ViewportSize / 2

      if (interfaces.logic.currentgun) then
         if (ui.flags["aimbot_barrel_fov"] and interfaces.logic.currentgun.barrel) then
            viewport_size = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(interfaces.logic.currentgun.barrel.Position)
         end
      end

      if (not cheat.visuals.info[local_player]["fov"]) then
         cheat.visuals.info[local_player]["fov"] = ui:Create("Circle", {
            Thickness = 1,
            NumSides = 100,
            Filled = false,
            Visible = false
         })
      end

      cheat.visuals.info[local_player]["fov"].Color = ui.flags["visuals_fov"]
      cheat.visuals.info[local_player]["fov"].Transparency = ui.options["visuals_fov"].trans
      cheat.visuals.info[local_player]["fov"].Radius = ui.flags["aimbot_fov"] * fov_ratio
      cheat.visuals.info[local_player]["fov"].Position = Vector2.new(viewport_size.X, viewport_size.Y)

      cheat.visuals.info[local_player]["fov"].Visible = true
   else
      if (cheat.visuals.info[local_player]["fov"]) then
         cheat.visuals.info[local_player]["fov"].Visible = false
      end
   end

   for _, player in next, game:GetService("Players"):GetPlayers() do
      if (player == local_player) then
         continue
      end

      local player_info = cheat.visuals.info[player]

      if (not player_info) then
         cheat.visuals.info[player] = {}
         cheat.visuals.info[player].parts = {}
         cheat.visuals.info[player].objects = {}

         player_info = cheat.visuals.info[player]
      end

      local box_position, box_size = get_bounding_box(player)

      if (not box_position or not box_size) then
         if (player_info.objects["box"]) then
            player_info.objects["box"].Visible = false
            player_info.objects["box_outline"].Visible = false
         end

         if (player_info.objects["name"]) then
            player_info.objects["name"].Visible = false
         end

         if (player_info.objects["health_bar"]) then
            player_info.objects["health_bar"].Visible = false
            player_info.objects["health_bar_outline"].Visible = false
          end

         continue
      end

      -- Boxes
      if (ui.flags["visuals_boxes"]) then
         if (not player_info.objects["box"]) then
            player_info.objects["box_outline"] = ui:Create("Square", {
               Thickness = 3,
               Filled = false,
               Visible = false,
            })

            player_info.objects["box"] = ui:Create("Square", {
               Thickness = 1,
               Filled = false,
               Visible = false,
            })
         end

         if (player.Team == local_player.Team) then
            if (ui.flags["visuals_selection"]["Allies"]) then
               player_info.objects["box"].Size = Vector2.new(box_size.X, box_size.Y)
               player_info.objects["box"].Position = Vector2.new(box_position.X, box_position.Y)
               player_info.objects["box"].Color = ui.flags["visuals_boxes_allies"]
               player_info.objects["box"].Transparency = ui.options["visuals_boxes_allies"].trans

               player_info.objects["box"].Visible = true

               player_info.objects["box_outline"].Size = Vector2.new(box_size.X, box_size.Y)
               player_info.objects["box_outline"].Position = Vector2.new(box_position.X, box_position.Y)
               player_info.objects["box_outline"].Color = Color3.new(0, 0, 0)
               player_info.objects["box_outline"].Transparency = ui.options["visuals_boxes_allies"].trans

               player_info.objects["box_outline"].Visible = true
            else
               player_info.objects["box"].Visible = false
               player_info.objects["box_outline"].Visible = false
            end
         else
            if (ui.flags["visuals_selection"]["Enemies"]) then
               player_info.objects["box"].Size = Vector2.new(box_size.X, box_size.Y)
               player_info.objects["box"].Position = Vector2.new(box_position.X, box_position.Y)
               player_info.objects["box"].Color = ui.flags["visuals_boxes_enemies"]
               player_info.objects["box"].Transparency = ui.options["visuals_boxes_enemies"].trans

               player_info.objects["box"].Visible = true

               player_info.objects["box_outline"].Size = Vector2.new(box_size.X, box_size.Y)
               player_info.objects["box_outline"].Position = Vector2.new(box_position.X, box_position.Y)
               player_info.objects["box_outline"].Color = Color3.new(0, 0, 0)
               player_info.objects["box_outline"].Transparency = ui.options["visuals_boxes_enemies"].trans

               player_info.objects["box_outline"].Visible = true
            else
               player_info.objects["box"].Visible = false
               player_info.objects["box_outline"].Visible = false
            end
         end
      else
         if (player_info.objects["box"]) then
            player_info.objects["box"].Visible = false
            player_info.objects["box_outline"].Visible = false
         end
      end

      -- Names
      if (ui.flags["visuals_names"]) then
         if (not player_info.objects["name"]) then
            player_info.objects["name"] = ui:Create("Text", {
               Font = 2,
               Size = 13,
               Center = true,
               Outline = true,
               Visible = false,
               Color = Color3.new(255, 255, 255)
            })
         end

         if (player.Team == local_player.Team) then
            if (ui.flags["visuals_selection"]["Allies"]) then
               player_info.objects["name"].Text = player.Name
               player_info.objects["name"].OutlineColor = ui.flags["visuals_names_allies"]
               player_info.objects["name"].Transparency = ui.options["visuals_names_allies"].trans
               player_info.objects["name"].Position = Vector2.new(box_position.X + (box_size.X / 2), box_position.Y - 3 - player_info.objects["name"].TextBounds.Y)

               player_info.objects["name"].Visible = true
            else
               player_info.objects["name"].Visible = false
            end
         else
            if (ui.flags["visuals_selection"]["Enemies"]) then
               player_info.objects["name"].Text = player.Name
               player_info.objects["name"].OutlineColor = ui.flags["visuals_names_enemies"]
               player_info.objects["name"].Transparency = ui.options["visuals_names_enemies"].trans
               player_info.objects["name"].Position = Vector2.new(box_position.X + (box_size.X / 2), box_position.Y - 3 - player_info.objects["name"].TextBounds.Y)

               player_info.objects["name"].Visible = true
            else
               player_info.objects["name"].Visible = false
            end
         end
      else
         if (player_info.objects["name"]) then
            player_info.objects["name"].Visible = false
         end
      end

      -- Health Bar
      if (ui.flags["visuals_health_bars"]) then
         if (not player_info.objects["health_bar"]) then
            player_info.objects["health_bar_outline"] = ui:Create("Square", {
               Thickness = 4,
               Filled = true,
               Visible = false,
            })

            player_info.objects["health_bar"] = ui:Create("Square", {
               Thickness = 2,
               Filled = true,
               Visible = false,
            })
         end

         if (player.Team == local_player.Team) then
            if (ui.flags["visuals_selection"]["Allies"]) then
               local health_fraction = math.ceil(interfaces.hud:getplayerhealth(player)) / 100

               local health_size = math.ceil(box_size.Y * health_fraction)
               local health_position = math.ceil((box_position.Y + box_size.Y) - health_size)

               player_info.objects["health_bar"].Size = Vector2.new(2, health_size)
               player_info.objects["health_bar"].Position = Vector2.new(box_position.X - 5, health_position)
               player_info.objects["health_bar"].Color = ui.flags["visuals_health_bars_allies"]
               player_info.objects["health_bar"].Transparency = ui.options["visuals_health_bars_allies"].trans

               player_info.objects["health_bar"].Visible = true

               player_info.objects["health_bar_outline"].Size = Vector2.new(4, box_size.Y + 2)
               player_info.objects["health_bar_outline"].Position = Vector2.new(box_position.X - 6, box_position.Y - 1)
               player_info.objects["health_bar_outline"].Color = Color3.new(0, 0, 0)
               player_info.objects["health_bar_outline"].Transparency = ui.options["visuals_health_bars_allies"].trans - 0.2

               player_info.objects["health_bar_outline"].Visible = true
            else
               player_info.objects["health_bar"].Visible = false
               player_info.objects["health_bar_outline"].Visible = false
            end
         else
            if (ui.flags["visuals_selection"]["Enemies"]) then
               local health_fraction = math.ceil(interfaces.hud:getplayerhealth(player)) / 100

               local health_size = math.ceil(box_size.Y * health_fraction)
               local health_position = math.ceil((box_position.Y + box_size.Y) - health_size)

               local hue, saturation, value = Color3.toHSV(ui.flags["visuals_health_bars_enemies"])
               local health_color = hue - ((120 / 360) * (-(health_fraction) + 1))

               player_info.objects["health_bar"].Size = Vector2.new(2, health_size)
               player_info.objects["health_bar"].Position = Vector2.new(box_position.X - 5, health_position)
               player_info.objects["health_bar"].Color = Color3.fromHSV(health_color, saturation, value)
               player_info.objects["health_bar"].Transparency = ui.options["visuals_health_bars_enemies"].trans

               player_info.objects["health_bar"].Visible = true

               player_info.objects["health_bar_outline"].Size = Vector2.new(4, box_size.Y + 2)
               player_info.objects["health_bar_outline"].Position = Vector2.new(box_position.X - 6, box_position.Y - 1)
               player_info.objects["health_bar_outline"].Color = Color3.new(0, 0, 0)
               player_info.objects["health_bar_outline"].Transparency = ui.options["visuals_health_bars_enemies"].trans - 0.2

               player_info.objects["health_bar_outline"].Visible = true
            else
               player_info.objects["health_bar"].Visible = false
               player_info.objects["health_bar_outline"].Visible = false
            end
         end
      else
         if (player_info.objects["health_bar"]) then
            player_info.objects["health_bar"].Visible = false
            player_info.objects["health_bar_outline"].Visible = false
          end
      end
   end

   for player, player_info in next, cheat.visuals.info do
      if (not game:GetService("Players"):FindFirstChild(player.Name)) then
         for _, object in next, player_info.objects do
            object.Visible = false
         end
      end
   end
end, function()
end)

-- Chams
cheat:render_stepped(1, function()
   for _, player in next, game:GetService("Players"):GetPlayers() do
      local local_player = game:GetService("Players").LocalPlayer

      -- Chams / Outlines
      if (ui.flags["visuals_chams"]) then
         local player_parts = interfaces.replication.getbodyparts(player)

         if (not player_parts) then continue end

         for _, part in next, player_parts do
            local cham_instance_visible: BoxHandleAdornment = part:FindFirstChild("visible")
            local cham_instance_invisible: BoxHandleAdornment = part:FindFirstChild("invisible")

            if (not interfaces.hud:isplayeralive(player)) then
               -- if (cham_instance) then
               --    cham_instance.Visible = false
               -- end

               continue
            end

            if (not cham_instance_visible or not cham_instance_invisible) then
               cham_instance_visible = ui:Create("BoxHandleAdornment", {
                  AlwaysOnTop = false,
                  Visible = false,
                  Parent = part,
                  Adornee = part,
                  Name = "visible",
                  ZIndex = 3 -- Draw Above.
               })

               cham_instance_invisible = ui:Create("BoxHandleAdornment", {
                  AlwaysOnTop = true,
                  Visible = false,
                  Parent = part,
                  Adornee = part,
                  Name = "invisible",
                  ZIndex = 2 -- Draw Below.
               })
            end

            if (player.Team == local_player.Team) then
               if (ui.flags["visuals_selection"]["Allies"]) then
                  if (ui.flags["visuals_chams_selection"]["Visible"]) then
                     cham_instance_visible.Visible = true

                     cham_instance_visible.Size = part.Size * 1.1
                     cham_instance_visible.Color3 = ui.flags["visuals_chams_allies"]
                     cham_instance_visible.Transparency = -(ui.options["visuals_chams_allies"].trans) + 1
                  else
                     cham_instance_visible.Visible = false
                  end

                  if (ui.flags["visuals_chams_selection"]["Invisible"]) then
                     local hue_color = {Color3.toHSV(ui.flags["visuals_chams_allies"])}
                     local desaturated_hsv = {hue_color[1], hue_color[2], 0.8} -- Ideally in future give the user free will of invisible color.

                     cham_instance_invisible.Visible = true

                     cham_instance_invisible.Size = part.Size
                     cham_instance_invisible.Color3 = Color3.fromHSV(desaturated_hsv[1], desaturated_hsv[2], desaturated_hsv[3])
                     cham_instance_invisible.Transparency = -(ui.options["visuals_chams_allies"].trans) + 1
                  else
                     cham_instance_invisible.Visible = false
                  end
               else
                  cham_instance_visible.Visible = false
                  cham_instance_invisible.Visible = false
               end
            else
               if (ui.flags["visuals_selection"]["Enemies"]) then
                  if (ui.flags["visuals_chams_selection"]["Visible"]) then
                     cham_instance_visible.Visible = true

                     cham_instance_visible.Size = part.Size * 1.1
                     cham_instance_visible.Color3 = ui.flags["visuals_chams_enemies"]
                     cham_instance_visible.Transparency = -(ui.options["visuals_chams_enemies"].trans) + 1
                  else
                     cham_instance_visible.Visible = false
                  end

                  if (ui.flags["visuals_chams_selection"]["Invisible"]) then
                     local hue_color = {Color3.toHSV(ui.flags["visuals_chams_enemies"])}
                     local desaturated_hsv = {hue_color[1], hue_color[2], 0.8} -- Ideally in future give the user free will of invisible color.

                     cham_instance_invisible.Visible = true

                     cham_instance_invisible.Size = part.Size
                     cham_instance_invisible.Color3 = Color3.fromHSV(desaturated_hsv[1], desaturated_hsv[2], desaturated_hsv[3])
                     cham_instance_invisible.Transparency = -(ui.options["visuals_chams_enemies"].trans) + 1
                  else
                     cham_instance_invisible.Visible = false
                  end
               else
                  cham_instance_visible.Visible = false
                  cham_instance_invisible.Visible = false
               end
            end
         end
      else
         local player_parts = interfaces.replication.getbodyparts(player)

         if (not player_parts) then continue end

         for _, part in next, player_parts do
            local cham_instance_visible: BoxHandleAdornment = part:FindFirstChild("visible")
            local cham_instance_invisible: BoxHandleAdornment = part:FindFirstChild("invisible")

            if (cham_instance_visible or cham_instance_invisible) then
               cham_instance_visible.Visible = false
               cham_instance_invisible.Visible = false
            end
         end
      end
   end

   for _, body in next, game:GetService("Workspace").Ignore.DeadBody:GetChildren() do
      for _, part in next, body:GetChildren() do
         if (part:IsA("Part")) then
            local cham_instance_visible: BoxHandleAdornment = part:FindFirstChild("visible")
            local cham_instance_invisible: BoxHandleAdornment = part:FindFirstChild("invisible")

            if (cham_instance_visible or cham_instance_invisible) then
               cham_instance_visible:Destroy()
               cham_instance_invisible:Destroy()
            end
         end
      end
   end
end, function()
   for _, body in next, game:GetService("Workspace").Ignore.DeadBody:GetChildren() do
      for _, part in next, body:GetChildren() do
         if (part:IsA("Part")) then
            local cham_instance_visible: BoxHandleAdornment = part:FindFirstChild("visible")
            local cham_instance_invisible: BoxHandleAdornment = part:FindFirstChild("invisible")

            if (cham_instance_visible or cham_instance_invisible) then
               cham_instance_visible:Destroy()
               cham_instance_invisible:Destroy()
            end
         end
      end
   end
end)

-- Auto Roll
task.spawn(function()
   while (task.wait()) do
      if (ui.flags["misc_auto_roll"]) then
         ui.options["misc_buy_cases"].callback()

         task.wait(ui.flags["misc_buy_amount"] / 15)

         ui.options["misc_dupe_roll_skins"].callback()

         task.wait(ui.flags["misc_buy_amount"] / 15)

         ui.options["misc_sell_skins"].callback()

         task.wait(ui.flags["misc_buy_amount"] / 15)
      end
   end
end)

ui:Notification("print", "Loaded in", synlog.chalk(tostring(math.ceil((os.clock() - start_tick) * 1000)).. "ms").light.black)