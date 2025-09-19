-- ==============================
-- Postman's Nameplate Helper
-- Last update 9/18/2025
-- Find more scripts at https://github.com/Postman67/postmans-figura-helpers
-- Buy me a coffee at https://buymeacoffee.com/postman67
-- ==============================

-- Organized, optimized, and modified by Postman67
-- Original gradient script by Circlemaniac

-- ===== CONFIGURATION =====
-- Basic nameplate settings
local username = ""                                          -- leave empty to use your player name, or set custom name
local colors = {"#FF0000","#FF4D00","#FF9900","#FFE600", "#FF9900", "#FF4D00"} -- gradient colors array (can be any length)
                                                             -- Example: {"#5BCEFA","#F5A9B8","#FFFFFF","#F5A9B8"} for trans flag
local offset = 0.1                                           -- color scroll per letter (1 = one full color cycle)
local speed = 0.1                                            -- animation speed for color transitions
local affectFiguraMark = true                                -- whether to color the Figura mark icon

-- Hover content settings (when someone looks at you)
local hoverContent = "Your text here"                        -- text shown when hovering over nameplate
local hoverContentColor = "#8D8D8D"                         -- color for hover text

-- Nameplate prefix/suffix settings
local nameplatePrefix = ""                                    -- text to show before the name (e.g., "[", "< ", "⭐ ", etc.)
local nameplateSuffix = ""                                    -- text to show after the name (e.g., "]", " >", " ⭐", etc.)

-- Nameplate appearance settings
local enableOutline = false                                  -- whether to enable text outline
local enableShadow = true                                    -- whether to enable text shadow
local backgroundColor = "#000000"                            -- background color (hex)
local nameplatePosition = {0, 0, 0}                         -- nameplate position offset {x, y, z}

-- Chat nameplate settings
local boldText = true                                         -- whether chat name should be bold
local chatGradientStart = "#FF0000"                          -- starting color for chat name gradient
local chatGradientEnd = "#FFB300"                            -- ending color for chat name gradient
local chatUsername = "YourNameHere"                       -- username for chat (leave empty to use main username)
local chatSuffix = "YOUR-SUFFIX-HERE"                        -- suffix text for chat nameplate

-- Chat hover card settings
local chatHoverTitle = "Your Name"                           -- title in chat hover card
local chatHoverSubtitle = "(Your subtitle)"                  -- subtitle in chat hover card
local chatHoverLine1 = "First line of info"                  -- first info line
local chatHoverLine2 = "Second line of info"                 -- second info line

-- ============================================
-- IMPLEMENTATION (Do not edit below this line)
-- ============================================


local hexToRGB = vectors.hexToRGB
for i, v in ipairs(colors) do
  colors[i - 1] = hexToRGB(v)
end
local colorCount = #colors
colors[colorCount] = colors[0]
local floor = math.floor
local rgbToHex = vectors.rgbToHex

-- Configure nameplate appearance
nameplate.ENTITY:setBackgroundColor(vectors.hexToRGB(backgroundColor))
nameplate.ENTITY:setOutline(enableOutline)
nameplate.ENTITY:setShadow(enableShadow)
if nameplatePosition[1] ~= 0 or nameplatePosition[2] ~= 0 or nameplatePosition[3] ~= 0 then
  nameplate.ENTITY:setPos(nameplatePosition[1], nameplatePosition[2], nameplatePosition[3])
end

if username == "" then
  function events.ENTITY_INIT()
    username = player:getName()
  end
end
local usernameChars

function events.tick()
  if not usernameChars then
    usernameChars = {}
    for i = 1, #username do
      usernameChars[i] = username:sub(i, i)
    end
    return
  end
  
  -- Check if someone is hovering over the player
  local isBeingHovered = false
  if client and client.getViewer then
    local viewer = client.getViewer()
    if viewer and viewer.getTargetedEntity then
      local target = viewer:getTargetedEntity()
      isBeingHovered = (target == player)
    end
  end
  -- Also check if we're the host viewing ourselves
  if host and host.isHost and host:isHost() then
    isBeingHovered = true
  end
  
  local color
  local nameComponents = {}
  
  -- Add prefix if configured
  if nameplatePrefix ~= "" then
    table.insert(nameComponents, {text = nameplatePrefix})
  end
  
  -- Add colored username characters
  local time = world.getTime() * speed
  for i = 1, #username do
    local counter = (time + offset * i) % colorCount
    local counterFloored = floor(counter)
    color = colors[counterFloored] + (colors[counterFloored + 1] - colors[counterFloored]) * (counter - counterFloored)
    table.insert(nameComponents, {
      text = usernameChars[i],
      color = "#" .. rgbToHex(color),
      bold = true
    })
  end
  
  -- Add suffix if configured
  if nameplateSuffix ~= "" then
    table.insert(nameComponents, {text = nameplateSuffix})
  end
  
  if affectFiguraMark then
    avatar:setColor(color)
  end
  
  -- Create clean tablist name (no hover content)
  local listName = {text = "", extra = nameComponents}
  
  -- Create entity nameplate with optional hover content
  local entityName = {text = "", extra = nameComponents}
  if isBeingHovered then
    -- Add hover content
    table.insert(entityName.extra, {
      text = "\n" .. hoverContent,
      color = hoverContentColor,
      bold = true
    })
  end
  
  nameplate.ENTITY:setText(toJson(entityName))
  nameplate.LIST:setText(toJson(listName))
end

-- Chat Name gradient formatting
local function generateChatGradient(text, startColor, endColor)
  local gradient = {}
  local startRGB = vectors.hexToRGB(startColor)
  local endRGB = vectors.hexToRGB(endColor)
  local textLength = #text
  
  for i = 1, textLength do
    local progress = (i - 1) / math.max(1, textLength - 1) -- 0 to 1
    local color = startRGB + (endRGB - startRGB) * progress
    table.insert(gradient, {
      text = text:sub(i, i),
      color = "#" .. vectors.rgbToHex(color),
      bold = boldText
    })
  end
  
  return gradient
end

local chatNameToUse = chatUsername ~= "" and chatUsername or (username ~= "" and username or player:getName())
local ChatNameGradient = generateChatGradient(chatNameToUse, chatGradientStart, chatGradientEnd)

-- Function to create nameplate text with custom suffix
local function createNameplateText(...)
  local nameText = {}
  -- Copy the gradient
  for i, part in ipairs(ChatNameGradient) do
    nameText[i] = part
  end
  -- Add the suffix parts
  local suffixes = {...}
  for _, suffix in ipairs(suffixes) do
    table.insert(nameText, suffix)
  end
  return nameText
end

-- Create hover content for chat nameplate
local chatHoverContentData = {
  {text = "", color = "#fefefe"}, -- Default color
  {text = chatHoverTitle, color = "#FF4D00"},{text = " " .. chatHoverSubtitle, color = "#9898ac"},
  {text = "\n - ", color = "#fefefe"},{text = chatHoverLine1, color = "#FFE3AE"},
  {text = "\n - ", color = "#fefefe"},{text = chatHoverLine2, color = "#FFCA8D"},
}

-- Create chat nameplate with hover functionality
local chatNameWithHover = {
  text = "",
  extra = createNameplateText({ text = chatSuffix, bold = true }),
  hoverEvent = {
    action = "show_text",
    contents = chatHoverContentData
  }
}

nameplate.CHAT:setText(toJson(chatNameWithHover))