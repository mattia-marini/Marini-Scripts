-- @noindex

local header = [[


-- >>>> Marini FX Linker
-- This code is generated by Marini FX Linker. It should NOT be modified by the user
-- It starts the background synching task on startup automatically
-- If you don't want it, you can delete this block or run the "Marini_FX linker Autostart Toggle" script
]]

local body = [[

reaper.Main_OnCommand(reaper.NamedCommandLookup("_RS0de0cd5a575891743053b10bb23b6356627d0210"), -1)

]]

local trailer = [[
-- <<<< Marini FX Linker]]

local startupFile = reaper.GetResourcePath().."/Scripts/__startup.lua"
local read = io.open(startupFile, "r")
local content = ""
if read then
  content = read:read("*all")
  read:close()
end

local pattern = "%-%- >>>> Marini FX Linker.*%-%- <<<< Marini FX Linker"

local function removeTrailingNewlines(inputString)
    local cleanedString = inputString:gsub("[\r\n]+$", "")
    return cleanedString
end

local function addAutoStartup()
  local write = io.open(startupFile, "w")
  if not write then return end
  if content:match(pattern) then
    print("c'è già autostart")
    write:write(content)
    return
  end
  write:write(removeTrailingNewlines(content) .. header .. body .. trailer)
  write:close()
end

local function removeAutoStartup()
  local write = io.open(startupFile, "w")
  if not write then return end
  local newContent = content:gsub(pattern, "")
  write:write(removeTrailingNewlines(newContent))
  write:close()
end

local commandID = ({reaper.get_action_context()})[4]
local toggle = reaper.GetToggleCommandState(commandID) == 1

if toggle then removeAutoStartup() 
else addAutoStartup() end

reaper.SetToggleCommandState(0,commandID, toggle and 0 or 1)
reaper.RefreshToolbar(commandID)
