-- ================================================================
-- Postman's Local Speech Helper
-- Last update 9/19/2025
-- Find more scripts at https://github.com/Postman67/postmans-figura-helpers
-- Buy me a coffee at https://buymeacoffee.com/postman67
-- ================================================================

-- ===============================================================
-- Features:
-- - Typewriter Effect: Text appears character by character with typing sounds
-- - Color Words: Automatic solid and gradient coloring for specific words
-- - Text Effects: Shake effects, hover animation, and dramatic pauses
-- - Chat Control: Configure whether messages go to local speech bubbles, global chat, or both
-- - Typing Indicator: Shows when you're typing to other players
-- - Fully Configurable: Customize appearance, sounds, timing, and behavior
-- ================================================================

-- ================================
-- CONFIGURATION VARIABLES
-- ================================

-- Make sure to download the localspeech.bbmodel from the github and place it in your avatar root folder
-- This script will not work without the .bbmodel
local model_path = models.localspeech    -- Path to the localspeech model

-- Text Appearance Settings
local hide_nameplate_during_speech = true           -- Hide nameplate while text is showing
local default_text_color = "#FFFFFF"                 -- Default color for uncolored text (hex format)
local text_scale = 0.4                              -- Size of the text (higher = bigger)
local text_x_position = -19                         -- X position of text (-30 is default)
local text_y_position = 28                          -- Y position of text (20 is default)
local text_z_position = -10                         -- Z position of text (default is -5)
local text_alignment = "CENTER"                     -- Alignment of text (LEFT, CENTER, RIGHT)
local text_width = 150                              -- Width of text box
local text_bold = false                             -- Enable bold text formatting
local text_light_level = 15                         -- Light level for text (0-15)

-- Typing Sound Settings
local typing_sound = "block.copper_bulb.step"       -- Sound for typing (You can use MC sounds, or sound files)
local normal_pitch_range = {50, 80}                 -- Pitch range for normal typing sounds
local dots_pitch_range = {10, 30}                   -- Pitch range for dot sounds (lower = deeper)
local dots_slowdown_multiplier = 10                 -- Dramatic pause for dots (higher = longer pause)
local sound_volume = 0.5                            -- Volume of typing sounds (0-1)

-- Chat Override Settings - If setting overrides to "\" (backslash) set the entry as "\\" due to Lua escape characters
local enable_chat_override = true                   -- When enabled, typing into the chatbox normally (without the override prefix) sends to local chat
local chat_override_prefix = "?"                    -- Prefix to override to either local or global depending on setting above
local globalandlocal_chat_prefix = ">"              -- Prefix to send chat to both global and local chat

-- Visual Effects Settings
local enable_text_shake = true                      -- Toggle for text shake effect
local shake_intensity = 0.1                         -- Base shake amount (higher = more shake)
local caps_shake_multiplier = 7                     -- Extra shake when ENTIRE MESSAGE is ALL-CAPS
local enable_outline = true                         -- Enable text outline
local outline_color = {0.0, 0.0, 0.0}               -- Outline color (RGB, 0-1)
local enable_shadow = true                          -- Enable text shadow
local enable_see_through = true                     -- Make text visible through blocks
local enable_text_hover = true                      -- Makes text gently hover/sway
local hover_intensity = 0.7                         -- How much the text sways (higher = more sway)
local hover_speed = 0.03                            -- Speed of the hover/sway (lower = slower, higher = faster)

-- Text Display Settings
local chars_delay = 1                               -- Typing speed (lower = faster, higher = slower)
local use_auto_hold_duration = true                 -- If true, hold time is double the typing time; if false, use manual time
local manual_hold_duration = 500                    -- Manual hold time in ticks (20 ticks = 1 second)

-- Auto Hold Duration Settings
local base_char_hold_time = 8                       -- Base time each character adds to hold duration (in ticks)
local dot_char_hold_time = 40                       -- Extra time for dots (periods) since they slow typing
local slow_char_hold_time = 15                      -- Time for other slow characters (commas, etc.)
local hold_time_multiplier = 1.5                    -- Overall multiplier for calculated hold time
local minimum_hold_time = 100                       -- Minimum message hold time in ticks (prevents short messages from disappearing too quickly)

-- Typing Indicator Settings
local enable_typing_indicator = true                -- Enable a typing indicator when your textbox is open
local typing_indicator_text = "I am typing"         -- Base text for typing indicator
local typing_indicator_scale = 0.4                  -- Size of typing indicator text
local typing_indicator_x = 10                       -- X position relative to player
local typing_indicator_y = 25                       -- Y position relative to player
local typing_indicator_z = -5                       -- Z position relative to player
local typing_indicator_color = "#FFC56D"          -- Color of typing indicator text
local typing_dots_speed = 15                        -- Speed of dot animation (lower = faster)
local typing_dots_max = 3                           -- Maximum number of dots in animation
local typing_indicator_alignment = "LEFT"           -- Alignment: "LEFT", "CENTER", or "RIGHT" (LEFT prevents shifting during animation)

-- ================================
-- COLOR AND GRADIENT DEFINITIONS
-- ================================

-- When a word is matched, it will change to the specified color. 
-- If the beginning of a word longer than one in the list contains a color, the whole word will overrun with the color.
-- i.e. "star" will match to yellow, so "starwalker" will overrun yellow. "end" will match to purple, so "ending" will overrun purple.
-- Adding a space after a word stops the match (i.e. "star " won't color "walker") and starts looking for a new match
-- This list is NOT case-sensitive, so "Star" or "STAR" will match "star"
-- Words can be surrounded by asterisks *like this* to force yellow color (e.g. *bottle* will be yellow even though it isn't in the list)
-- Certain words in this list are from me (Postman67's) personal preferences and experiences, feel free to modify or remove them as you see fit.

local color_words = {
    ["yellow"] = "#fff200",
    ["aga"] = "#fff200",
    ["minecraft"] = "#fff200",
    ["join"] = "#fff200",
    ["bird"] = "#fff200",
    ["key"] = "#fff200",
    ["item"] = "#fff200",
    ["cool"] = "#fff200",
    ["piss"] = "#fff200",
    ["gold"] = "#fff200",
    ["must"] = "#fff200",
    ["ball"] = "#fff200",
    ["love"] = "#fff200",
    ["jesus"] = "#fff200",
    ["much"] = "#fff200",
    ["depress"] = "#fff200",
    ["big"] = "#fff200",
    ["definitely"] = "#fff200",
    ["fabulous"] = "#fff200",
    ["bee"] = "#fff200",
    [":3"] = "#fff200",
    ["red"] = "#ff0000",
    ["loki"] = "#ff0000",
    ["run"] = "#ff0000",
    ["dead"] = "#ff0000",
    ["death"] = "#ff0000",
    ["died"] = "#ff0000",
    ["die"] = "#ff0000",
    ["brutus"] = "#ff0000",
    ["2001"] = "#ff0000",
    ["9/11"] = "#ff0000",
    ["genocide"] = "#ff0000",
    ["hate"] = "#ff0000",
    ["redstone"] = "#ff0000",
    ["blood"] = "#ff0000",
    ["kill"] = "#ff0000",
    ["sucks"] = "#ff0000",
    ["nether"] = "#940000",
    ["orange"] = "#fca600",
    ["break"] = "#fca600",
    ["copper"] = "#fca600",
    ["brown"] = "#7f4b3a",
    ["horse"] = "#7f4b3a",
    ["green"] = "#00c000",
    ["emerald"] = "#00c000",
    ["please"] = "#00c000",
    ["moss"] = "#00c000",
    ["unpleasant"] = "#25D22B",
    ["starbucks"] = "#006241",
    ["cyan"] = "#40fcff",
    ["olyy"] = "#40fcff",
    ["yeer"] = "#40fcff",
    ["miku"] = "#40fcff",
    ["cozr"] = "#40fcff",
    ["aqua"] = "#40fcff",
    ["diamond"] = "#40fcff",
    ["blue"] = "#003cff",
    ["water"] = "#003cff",
    ["rain"] = "#003cff",
    ["lapis"] = "#003cff",
    ["navy"] = "#023542",
    ["sculk"] = "#023542",
    ["discord"] = "#7289da",
    ["purple"] = "#d535d9",
    ["breed"] = "#d535d9",
    ["end"] = "#d535d9",
    ["twitch"] = "#d535d9",
    ["amethyst"] = "#d535d9",
    ["spider"] = "#d535d9",
    ["pink"] = "#FC68B2",
    ["cute"] = "#FC68B2",
    ["sylveon"] = "#FC68B2",
    ["grey"] = "#808080",
    ["news"] = "#808080",
    ["black"] = "#000000",
    ["void"] = "#000000",
}

-- Gradient words - define words that should have gradients
-- When a word is matched, it will apply the specified gradient to the entire word.
-- The color overrun on single words does NOT apply to gradients, it must be an exact match for the gradient to apply.
-- If a word in the gradient list is also in the single words list, the gradient will take precedence.
-- This list is NOT case-sensitive, so "Rainbow" or "RAINBOW" will match "rainbow"
-- Certain words in this list are from me (Postman67's) personal preferences and experiences, feel free to modify or remove them as you see fit.

local gradient_words = {
    ["rainbow"] = {"#ff0000", "#ff8000", "#ffff00", "#00ff00", "#0080ff", "#8000ff"},  -- Red to Purple
    ["fire"] = {"#ff0000", "#ff4000", "#ff8000", "#ffff00"},  -- Red to Yellow
    ["ocean"] = {"#000080", "#0040ff", "#0080ff", "#00ffff"},  -- Navy to Cyan
    ["sunset"] = {"#ff4000", "#ff8000", "#ffff00", "#ff8040"},  -- Orange sunset
    ["galaxy"] = {"#200040", "#400080", "#8000ff", "#ff00ff"},  -- Purple galaxy
    ["forest"] = {"#004000", "#008000", "#40ff40", "#80ff80"},
    ["breed?"] = {"#83007F", "#EE0BD7", "#FC00F4", "#FF1E9A"},
    ["cozr"] = {"#fcfcfc", "#fcb4bf", "#b3fcec", "#7e7e7e"},
    ["unpleasant"] = {"#25d22b", "#ff3afc", "#9e5206"},
    ["unplsnt_gradient"] = {"#25d22b", "#ff3afc", "#9e5206"},
    ["gradient"] = {"#25d22b", "#ff3afc", "#9e5206"},
    ["colors"] = {"#25d22b", "#ff3afc", "#9e5206"},
    ["carson"] = {"#990000", "#FFB0B0", "#888888"},

    -- Pride Flag Gradients
    ["pride"] = {"#e40303", "#ff8c00", "#ffed00", "#008018", "#004cff", "#732982"},  -- Original Pride/Rainbow
    ["gay"] = {"#078d70", "#98e8c1", "#ffffff", "#7bade2", "#3d1a78"},  -- Gay Men
    ["lesbian"] = {"#d62900", "#ff9b55", "#ffffff", "#d462a6", "#a40062"},  -- Lesbian
    ["bi"] = {"#d60270", "#d60270", "#9b59b6", "#0038a8", "#0038a8"},  -- Bisexual
    ["bisexual"] = {"#d60270", "#d60270", "#9b59b6", "#0038a8", "#0038a8"},  -- Bisexual (full word)
    ["trans"] = {"#5bcefa", "#f5a9b8", "#ffffff", "#f5a9b8", "#5bcefa"},  -- Transgender
    ["transgender"] = {"#5bcefa", "#f5a9b8", "#ffffff", "#f5a9b8", "#5bcefa"},  -- Transgender (full word)
    ["nb"] = {"#fcf434", "#ffffff", "#9c59d1", "#000000"},  -- Non-binary
    ["nonbinary"] = {"#fcf434", "#ffffff", "#9c59d1", "#000000"},  -- Non-binary (full word)
    ["enby"] = {"#fcf434", "#ffffff", "#9c59d1", "#000000"},  -- Non-binary (alt name)
    ["pan"] = {"#ff218c", "#ffd800", "#21b1ff"},  -- Pansexual
    ["pansexual"] = {"#ff218c", "#ffd800", "#21b1ff"},  -- Pansexual (full word)
    ["ace"] = {"#000000", "#a3a3a3", "#ffffff", "#800080"},  -- Asexual
    ["asexual"] = {"#000000", "#a3a3a3", "#ffffff", "#800080"},  -- Asexual (full word)
    ["aro"] = {"#3da542", "#a7d379", "#ffffff", "#a9a9a9", "#000000"},  -- Aromantic
    ["aromantic"] = {"#3da542", "#a7d379", "#ffffff", "#a9a9a9", "#000000"},  -- Aromantic (full word)
    ["demi"] = {"#000000", "#a3a3a3", "#ffffff", "#800080"},  -- Demisexual (same as ace for simplicity)
    ["demisexual"] = {"#000000", "#a3a3a3", "#ffffff", "#800080"},  -- Demisexual (full word)
    ["fluid"] = {"#ff75a2", "#ffffff", "#be18d6", "#000000", "#333ebd"},  -- Genderfluid
    ["genderfluid"] = {"#ff75a2", "#ffffff", "#be18d6", "#000000", "#333ebd"},  -- Genderfluid (full word)
    ["agender"] = {"#000000", "#c4c4c4", "#ffffff", "#b7f684", "#ffffff", "#c4c4c4", "#000000"},  -- Agender
    ["poly"] = {"#f714ba", "#01d66a", "#1594f6"},  -- Polysexual
    ["polysexual"] = {"#f714ba", "#01d66a", "#1594f6"},  -- Polysexual (full word)
    ["omni"] = {"#fe9ace", "#ff66cc", "#660099", "#0066cc", "#3333cc"},  -- Omnisexual
    ["omnisexual"] = {"#fe9ace", "#ff66cc", "#660099", "#0066cc", "#3333cc"},  -- Omnisexual (full word)
    ["queer"] = {"#000000", "#99d9ea", "#b19cd9", "#ffffff", "#f5a9b8"},  -- Queer
    ["questioning"] = {"#678094", "#b3d6ed", "#ffffff", "#e8b5e8", "#9b4f96"},  -- Questioning

    -- Country Flag Gradients
    ["usa"] = {"#b22234", "#ffffff", "#3c3b6e"},  -- United States (Red, White, Blue)
    ["america"] = {"#b22234", "#ffffff", "#3c3b6e"},  -- United States (alt name)
    ["canada"] = {"#ff0000", "#ffffff", "#ff0000"},  -- Canada (Red, White, Red)
    ["uk"] = {"#012169", "#ffffff", "#c8102e"},  -- United Kingdom (Blue, White, Red)
    ["britain"] = {"#012169", "#ffffff", "#c8102e"},  -- United Kingdom (alt name)
    ["england"] = {"#ffffff", "#ce1126"},  -- England (White, Red)
    ["france"] = {"#0055a4", "#ffffff", "#ef4135"},  -- France (Blue, White, Red)
    ["germany"] = {"#000000", "#dd0000", "#ffce00"},  -- Germany (Black, Red, Gold)
    ["italy"] = {"#009246", "#ffffff", "#ce2b37"},  -- Italy (Green, White, Red)
    ["spain"] = {"#aa151b", "#f1bf00", "#aa151b"},  -- Spain (Red, Yellow, Red)
    ["netherlands"] = {"#21468b", "#ffffff", "#ae1c28"},  -- Netherlands (Blue, White, Red)
    ["holland"] = {"#21468b", "#ffffff", "#ae1c28"},  -- Netherlands (alt name)
    ["russia"] = {"#ffffff", "#0039a6", "#d52b1e"},  -- Russia (White, Blue, Red)
    ["japan"] = {"#ffffff", "#bc002d", "#ffffff"},  -- Japan (White, Red, White)
    ["china"] = {"#de2910", "#ffde00", "#de2910"},  -- China (Red, Yellow, Red)
    ["india"] = {"#ff9933", "#ffffff", "#138808"},  -- India (Saffron, White, Green)
    ["brazil"] = {"#009c3b", "#ffdf00", "#002776"},  -- Brazil (Green, Yellow, Blue)
    ["brazilian"] = {"#009c3b", "#ffdf00", "#002776"},  -- Brazil (Green, Yellow, Blue)
    ["australia"] = {"#00008b", "#ffffff", "#ff0000"},  -- Australia (Blue, White, Red)
    ["mexico"] = {"#006847", "#ffffff", "#ce1126"},  -- Mexico (Green, White, Red)
    ["sweden"] = {"#006aa7", "#fecc00", "#006aa7"},  -- Sweden (Blue, Yellow, Blue)
    ["norway"] = {"#ef2b2d", "#ffffff", "#002868"},  -- Norway (Red, White, Blue)
    ["finland"] = {"#ffffff", "#003580", "#ffffff"},  -- Finland (White, Blue, White)
    ["denmark"] = {"#c8102e", "#ffffff", "#c8102e"},  -- Denmark (Red, White, Red)
    ["ireland"] = {"#169b62", "#ffffff", "#ff883e"},  -- Ireland (Green, White, Orange)
    ["scotland"] = {"#005eb8", "#ffffff", "#005eb8"},  -- Scotland (Blue, White, Blue)
    ["wales"] = {"#00b04f", "#ffffff", "#dd2d26"},  -- Wales (Green, White, Red)
    ["poland"] = {"#ffffff", "#dc143c"},  -- Poland (White, Red)
    ["ukraine"] = {"#005bbb", "#ffd700"},  -- Ukraine (Blue, Yellow)

}

-- OK ITS JUST CODE FROM HERE ON OUT
-- NO SERIOUSLY DONT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING

-- ================================
-- INTERNAL VARIABLES (DO NOT MODIFY)
-- ================================
local hide_ticks = 0
local hiding = false
local chars_delay_countdown = 0
local current_msg_len = 0
local g_msg = ""
local current_char = 0

-- Hover/sway animation variable
local hover_animation_time = 0

-- Typing indicator variables
local is_typing = false
local typing_dot_animation = 0
local typing_indicator_visible = false
local remote_typing_indicator = false  -- For showing other players' typing indicators

-- Check if the model exists
if not model_path then
    error("No localspeech model found. Did you download it? Make sure to place the localspeech.bbmodel file in your avatar root folder.")
end

-- ================================
-- DYNAMIC TIMING HELPER FUNCTIONS
-- ================================

-- Function to calculate dynamic hold time based on message content
local function calculate_dynamic_hold_time(message)
    local total_time = 0
    
    for i = 1, #message do
        local char = message:sub(i, i)
        
        if char == "." then
            -- Dots get extra time since they slow down typing
            total_time = total_time + dot_char_hold_time
        elseif char == "," or char == ";" or char == ":" or char == "!" or char == "?" then
            -- Other punctuation gets slightly more time
            total_time = total_time + slow_char_hold_time
        else
            -- Regular characters get base time
            total_time = total_time + base_char_hold_time
        end
    end
    
    -- Apply multiplier and ensure minimum time
    total_time = math.floor(total_time * hold_time_multiplier)
    return math.max(total_time, minimum_hold_time)
end

-- ================================
-- UTF-8 HELPER FUNCTIONS
-- ================================

-- returns the number of UTF-8 characters in a string
local function utf8_len(str)
    local _, count = string.gsub(str, "[^\128-\191]", "")
    return count
end

-- determines how many bytes a UTF-8 character takes based on the first byte
local function utf8_char_len(c)
    if c < 0x80 then
        return 1
    elseif c < 0xE0 then
        return 2
    elseif c < 0xF0 then
        return 3
    else
        return 4
    end
end

-- returns the Nth UTF-8 character from the end of the string
local function utf8_nth_from_end(str, n)
    local i = #str
    local count = 0

    while i > 0 do
        local c = str:byte(i)
        if c < 0x80 or c >= 0xC0 then
            count = count + 1
            if count == n then
                return str:sub(i, i + utf8_char_len(c) - 1)
            end
        end
        i = i - 1
    end

    return ""
end

-- Returns a substring of the first N UTF-8 characters
local function utf8_sub(str, n)
    local i = 1
    local len = 0

    while i <= #str do
        len = len + 1
        if len > n then
            return str:sub(1, i - 1)
        end

        local c = str:byte(i)
        if c < 0x80 then
            i = i + 1
        elseif c < 0xE0 then
            i = i + 2
        elseif c < 0xF0 then
            i = i + 3
        else
            i = i + 4
        end
    end

    return str
end

-- ================================
-- COLOR HELPER FUNCTIONS
-- ================================

-- Helper function to convert hex color to RGB values (0-255)
local function hex_to_rgb(hex)
    local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
    if r and g and b then
        return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
    end
    return 255, 255, 255  -- Default to white if parsing fails
end

-- Helper function to convert RGB values back to hex
local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
end

-- Function to interpolate between two colors
local function lerp_color(color1, color2, t)
    local r1, g1, b1 = hex_to_rgb(color1)
    local r2, g2, b2 = hex_to_rgb(color2)
    
    local r = r1 + (r2 - r1) * t
    local g = g1 + (g2 - g1) * t
    local b = b1 + (b2 - b1) * t
    
    return rgb_to_hex(r, g, b)
end

-- Function to get a single character at position i from a UTF-8 string
local function utf8_char_at(str, pos)
    local byte_pos = 1
    local char_count = 0
    
    while byte_pos <= #str do
        char_count = char_count + 1
        if char_count == pos then
            local char_start = byte_pos
            local c = str:byte(byte_pos)
            local char_len = utf8_char_len(c)
            return str:sub(char_start, char_start + char_len - 1)
        end
        
        local c = str:byte(byte_pos)
        byte_pos = byte_pos + utf8_char_len(c)
    end
    
    return ""
end

-- Function to create gradient segments for a word
local function create_gradient_segments(word, colors)
    local segments = {}
    local word_len = utf8_len(word)
    
    if word_len <= 1 or #colors < 2 then
        -- If word is too short or not enough colors, use first color
        table.insert(segments, {
            type = "color",
            text = word,
            color = colors[1] or "#ffffff"
        })
        return segments
    end
    
    -- Create segments for each character with interpolated colors
    for i = 1, word_len do
        local char = utf8_char_at(word, i)
        local progress = (i - 1) / (word_len - 1)  -- 0 to 1
        
        -- Find which color segment we're in
        local segment_size = 1 / (#colors - 1)
        local segment_index = math.floor(progress / segment_size) + 1
        local local_progress = (progress % segment_size) / segment_size
        
        -- Clamp segment_index
        if segment_index >= #colors then
            segment_index = #colors - 1
            local_progress = 1
        end
        
        local color = lerp_color(colors[segment_index], colors[segment_index + 1], local_progress)
        
        table.insert(segments, {
            type = "color",
            text = char,
            color = color
        })
    end
    
    return segments
end

-- Function to create typing indicator text with animated dots
local function get_typing_indicator_text()
    local dots_count = math.floor(typing_dot_animation / typing_dots_speed) % (typing_dots_max + 1)
    local dots = string.rep(".", dots_count)
    return string.format('[{"text":"%s","color":"%s"},{"text":"%s","color":"%s"}]', 
                        typing_indicator_text, typing_indicator_color, dots, typing_indicator_color)
end

-- ================================
-- TEXT PROCESSING FUNCTIONS
-- ================================

-- Function to check if the entire message is in ALL CAPS
local function is_entire_message_caps(text)
    local has_letters = false
    for i = 1, #text do
        local char = text:sub(i, i)
        if char:match("%a") then  -- is a letter
            has_letters = true
            if char:lower() == char then  -- found a lowercase letter
                return false
            end
        end
    end
    return has_letters  -- return true only if we found letters and they were all uppercase
end

local function truncate_color_json(text, max_chars)
    local segments = {}
    local last_end = 1

    while true do
        local s, e = string.find(text, "%S+", last_end)
        if not s then break end

        local prefix = text:sub(last_end, s - 1)
        local word   = text:sub(s, e)

        if #segments == 0 then
            -- always start with a text segment
            table.insert(segments, { type = "text", text = "" })
        end

        if prefix ~= "" then
            table.insert(segments, { type = "text", text = prefix })
        elseif color_words[word] and #segments == 0 then
            -- if the message starts with a color word, make sure we start the JSON with a text segment first
            table.insert(segments, { type = "text", text = "" })
        end
        
        -- matcher
        local word_lower = word:lower()
        local is_asterisked = word:sub(1,1) == "*" and word:sub(-1) == "*" and #word > 2

        if is_asterisked then
            -- override the color with yellow if the word is surrounded by asterisks *
            word = word:sub(2, -2)
            table.insert(segments, {
                type  = "color",
                text  = word,
                color = "#fff200"
            })
        else
            -- Check for gradient words first
            local gradient_colors = gradient_words[word_lower]
            if gradient_colors then
                -- Create gradient segments for this word
                local gradient_segments = create_gradient_segments(word, gradient_colors)
                for _, gradient_seg in ipairs(gradient_segments) do
                    table.insert(segments, gradient_seg)
                end
            else
                -- Check for regular color words
                local match_color = nil
                local longest_match = 0

                for key, color in pairs(color_words) do
                    -- only match whole word parts (like "star" in "starwalker", but not "i" in "pink")
                    if word_lower:sub(1, #key) == key and #key > longest_match then
                        match_color = color
                        longest_match = #key
                    end
                end

                if match_color then
                    table.insert(segments, {
                        type  = "color",
                        text  = word,
                        color = match_color
                    })
                else
                    table.insert(segments, { type = "text", text = word })
                end
            end
        end

        last_end = e + 1
    end

    local suffix = text:sub(last_end)
    if suffix ~= "" then
        table.insert(segments, { type = "text", text = suffix })
    end

    local used = 0
    local out_segs = {}

    for _, seg in ipairs(segments) do
        local seg_len = utf8_len(seg.text) or 0

        if used + seg_len < max_chars then
            table.insert(out_segs, seg)
            used = used + seg_len
        else
            local remaining = max_chars - used
            if remaining > 0 then
                local part = utf8_sub(seg.text, remaining)
                if seg.type == "color" then
                    table.insert(out_segs, {
                        type  = "color",
                        text  = part,
                        color = seg.color
                    })
                else
                    table.insert(out_segs, { type = "text", text = part })
                end
                used = used + remaining
            end
            break
        end
    end

    local parts = {}
    for _, seg in ipairs(out_segs) do
        if seg.type == "text" then
            if text_bold then
                table.insert(parts, string.format("{\"text\":%q,\"color\":%q,\"bold\":true}", seg.text, default_text_color))
            else
                table.insert(parts, string.format("{\"text\":%q,\"color\":%q}", seg.text, default_text_color))
            end
        else
            -- Colored words are always bold, regardless of use_bold_text setting
            table.insert(parts, string.format(
                "{\"text\":%q,\"color\":%q,\"bold\":true}",
                seg.text,
                seg.color
            ))
        end
    end

    return "[" .. table.concat(parts, ",") .. "]"
end

events.RENDER:register(function(d)
    -- Update hover animation timer
    if enable_text_hover then
        hover_animation_time = hover_animation_time + hover_speed
    end
    
    local cameraRot = client:getCameraRot()

    -- if in first-person view, don't rotate at all
    if renderer:isFirstPerson() then
        cameraRot = vec(0, 0, 0)
    end

    local i = cameraRot.y - player:getBodyYaw(d)

    -- rotate the model to face the camera
    model_path:setRot(0, -i, 0)
    model_path.root:setRot(0, 180, 0)
    
    -- Apply hover effect to the entire model if text is visible
    if enable_text_hover and model_path.root.text:getVisible() then
        local hover_x = math.sin(hover_animation_time) * hover_intensity
        local hover_y = math.cos(hover_animation_time * 0.7) * hover_intensity * 0.5
        model_path.root:setPos(hover_x, hover_y, 0)
    else
        -- Reset position when not hovering
        model_path.root:setPos(0, 0, 0)
    end
    
    -- Handle typing indicator
    if enable_typing_indicator then
        -- Show typing indicator if either local player is typing OR remote player is typing
        if typing_indicator_visible or remote_typing_indicator then
            -- Update dot animation
            typing_dot_animation = typing_dot_animation + 1
            
            -- Create or update typing indicator text
            local typingText = model_path.root:newText("typing_indicator")
            typingText:setText(get_typing_indicator_text())
                     :setPos(typing_indicator_x, typing_indicator_y, typing_indicator_z)
                     :setScale(typing_indicator_scale)
                     :setAlignment(typing_indicator_alignment)
                     :setWidth(100)
                     :setLight(15, 15)
                     :setOutline(true)
                     :setOutlineColor(0, 0, 0)
                     :setShadow(true)
                     :setSeeThrough(true)
                     :setVisible(true)
        else
            -- Hide typing indicator when not typing
            if model_path.root:getTask("typing_indicator") then
                model_path.root:removeTask("typing_indicator")
            end
        end
    end
end)

-- ================================
-- MAIN EVENT FUNCTIONS
-- ================================

function events.tick()
    if current_char < current_msg_len then
        chars_delay_countdown = chars_delay_countdown + 1
        
        -- check if next character to be typed is a dot for dramatic slowdown
        local current_delay = chars_delay
        if current_char < current_msg_len then
            local next_character = utf8_char_at(g_msg, current_char + 1)
            if next_character == "." then
                current_delay = chars_delay * dots_slowdown_multiplier
            end
        end

        if chars_delay_countdown >= current_delay then
            current_char = current_char + 1

            -- generate a new dynamic text element
            local nameText = model_path.root.text:newText("dynamic_text")
            local msg = truncate_color_json(g_msg, current_char)

            -- calculate shake offset if enabled
            local shake_x = 0
            local shake_y = 0
            if enable_text_shake then
                local current_shake_intensity = shake_intensity
                -- check if entire message is ALL CAPS for violent shaking
                if is_entire_message_caps(g_msg) then
                    current_shake_intensity = shake_intensity * caps_shake_multiplier
                end
                shake_x = (math.random() - 0.5) * 2 * current_shake_intensity
                shake_y = (math.random() - 0.5) * 2 * current_shake_intensity
            end

            -- set up the new partial message with shake offset (hover is now handled by model position)
            nameText:setText(msg)
                    :setPos(text_x_position + shake_x, text_y_position + shake_y, text_z_position)
                    :setScale(text_scale)
                    :setAlignment(text_alignment)
                    :setWidth(text_width)
                    :setLight(text_light_level, text_light_level)
                    :setOutline(enable_outline)
                    :setOutlineColor(outline_color[1], outline_color[2], outline_color[3])
                    :setShadow(enable_shadow)
                    :setSeeThrough(enable_see_through)

            -- reset delay countdown
            chars_delay_countdown = 0

            -- if the last char wasn't a space, play the voice
            local visible_text = utf8_sub(g_msg, current_char)
            local last_char = utf8_nth_from_end(visible_text, 3)
            if last_char ~= " " then
                local random_pitch
                -- check if the current character is a dot for lower pitch
                local current_character = utf8_char_at(g_msg, current_char)
                if current_character == "." then
                    random_pitch = math.random(dots_pitch_range[1], dots_pitch_range[2]) / 100
                else
                    random_pitch = math.random(normal_pitch_range[1], normal_pitch_range[2]) / 100
                end
                sounds:playSound(typing_sound, player:getPos(), sound_volume, random_pitch)
            end
        end
    end
    
    if model_path.root.text:getVisible() and (not hiding) and current_char >= current_msg_len then
        hiding = true
        if use_auto_hold_duration then
            -- Dynamic duration: calculate based on character content and typing delays
            hide_ticks = calculate_dynamic_hold_time(g_msg)
        else
            hide_ticks = manual_hold_duration
        end
    end

    -- Continuously shake all-caps text while visible (only during hold/hiding phase)
    if model_path.root.text:getVisible() and enable_text_shake and current_char >= current_msg_len then
        if is_entire_message_caps(g_msg) then
            -- Recreate text element with new shake position every frame for all-caps
            local continuous_shake_x = (math.random() - 0.5) * 2 * shake_intensity * caps_shake_multiplier
            local continuous_shake_y = (math.random() - 0.5) * 2 * shake_intensity * caps_shake_multiplier
            
            -- Remove existing text and create new one with shake (hover is now handled by model position)
            local nameText = model_path.root.text:newText("dynamic_text")
            local msg = truncate_color_json(g_msg, current_char)
            
            nameText:setText(msg)
                    :setPos(text_x_position + continuous_shake_x, text_y_position + continuous_shake_y, text_z_position)
                    :setScale(text_scale)
                    :setAlignment(text_alignment)
                    :setWidth(text_width)
                    :setLight(text_light_level, text_light_level)
                    :setOutline(enable_outline)
                    :setOutlineColor(outline_color[1], outline_color[2], outline_color[3])
                    :setShadow(enable_shadow)
                    :setSeeThrough(enable_see_through)
        end
    end

    if hiding then
        hide_ticks = hide_ticks - 1
        if hide_ticks == 0 then
            model_path.root.text:setVisible(false)
            hiding = false
            -- show nameplate again when message disappears (if feature is enabled)
            if hide_nameplate_during_speech then
                nameplate.ENTITY:setVisible(true)
            end
        end
    end
    
    -- Typing indicator detection
    if enable_typing_indicator then
        local chat_open = host:isChatOpen()
        if chat_open and not typing_indicator_visible then
            -- Player just opened chat, start showing typing indicator
            typing_indicator_visible = true
            typing_dot_animation = 0
            -- Send ping to show typing indicator to other players
            pings.typing_indicator(true)
        elseif not chat_open and typing_indicator_visible then
            -- Player closed chat, hide typing indicator
            typing_indicator_visible = false
            -- Send ping to hide typing indicator from other players
            pings.typing_indicator(false)
        end
    end
end

-- Local function to handle speech generation
local function generate_speech(msg)
    g_msg = msg
    current_msg_len = utf8_len(msg)
    chars_delay_countdown = 0
    current_char = 0
    hiding = false


    -- hide nameplate when chat message appears (if feature is enabled)
    if hide_nameplate_during_speech then
        nameplate.ENTITY:setVisible(false)
    end

    -- Sync hover animation for multiplayer
    if enable_text_hover then
        pings.sync_hover_animation(hover_animation_time)
    end

    -- show text UI (revert to original working version)
    model_path.root.text:setVisible(true)
end

function pings.chat_msg(msg)
    generate_speech(msg)
end

-- Ping function to play voice sounds on multiplayer servers
function pings.play_voice_sound(sound_file, pitch)
    if sound_file and pitch then
        local speak = sounds[sound_file]
        speak:setPos(player:getPos())
        speak:setPitch(pitch)
        speak:setVolume(sound_volume)
        speak:setSubtitle("Postman67 Speaks")
        speak:play()
    end
end

-- Ping function to synchronize hover animation for multiplayer
function pings.sync_hover_animation(animation_time)
    if enable_text_hover then
        hover_animation_time = animation_time
    end
end

-- Ping function to show/hide typing indicator for multiplayer
function pings.typing_indicator(is_visible)
    if enable_typing_indicator then
        remote_typing_indicator = is_visible
        if is_visible then
            typing_dot_animation = 0  -- Reset animation when starting to type
        end
    end
end

function events.CHAT_SEND_MESSAGE(msg)
    -- check if msg is nil or empty
    if not msg or msg == "" then
        return msg
    end
    
    -- if it's a command (starts with /), don't intercept
    if msg:sub(1, 1) == "/" then
        return msg
    end
    
    -- if it starts with chat_override_prefix, override the default behavior
    if msg:sub(1, 1) == chat_override_prefix then
        local override_msg = msg:sub(2)  -- remove the override prefix
        if enable_chat_override then
            -- when chat override is enabled (default = local), prefix sends to global only
            return override_msg  -- allow message to go to global chat without local speech bubble
        else
            -- when chat override is disabled (default = global), prefix sends to local only
            pings.chat_msg(override_msg)  -- send ping so others see speech bubble
            host:appendChatHistory(override_msg)
            return nil  -- prevent sending to global chat
        end
    end
    
    -- if it starts with globalandlocal_chat_prefix, send to global chat AND generate local text
    if msg:sub(1, 1) == globalandlocal_chat_prefix then
        local global_msg = msg:sub(2)  -- remove the prefix
        pings.chat_msg(global_msg)  -- send ping so others see speech bubble
        return global_msg  -- allow message to go to global chat
    end
    
    -- default behavior based on enable_chat_override setting
    if enable_chat_override then
        -- when chat override is enabled, default to local chat only
        pings.chat_msg(msg)  -- send ping so others see speech bubble
        host:appendChatHistory(msg)
        return nil  -- prevent sending to global chat
    else
        -- when chat override is disabled, default to global chat normally
        return msg
    end
end