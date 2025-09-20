# Postman's Figura Helpers

A list of helpful script files to simply drag into your figura model

## Nameplate Helper

*All settings can be customized at the top of the script file!*

The Nameplate Helper creates animated gradient nameplates with customizable hover content and chat customization. It handles both the in-world nameplate above your head and your name in chat.

#### Quick Setup
1. Download `PostmansNameplateHelper.lua`
2. Place the file in your avatar's root folder
3. Edit the placeholder text at the top of the script
4. Reload your avatar - you're done!

#### Features
- **Gradient Animation**: Smooth color transitions across your name
- **Dual Nameplate Control**: Separate settings for in-world and chat nameplates
- **Hover Content**: Custom text that appears when players look at you
- **Chat Integration**: Gradient name in chat with custom suffix and hover cards
- **Figura Mark Coloring**: Option to sync your Figura mark color with the gradient
- **Flexible Configuration**: Prefix/suffix text, colors, positioning, and styling

#### Important Limitations
**In-World Nameplate**: Shows above your head with optional hover content
**Chat Nameplate**: Appears in chat messages with separate gradient and hover card
- **Placeholder Replacement Required**: You MUST edit the placeholder text (like "YourNameHere") or the nameplate will show placeholder values
- **Figura Cloud Dependant**: Other players need Figura to see your custom nameplate
- **Figura Emojis**: You can add Figura emojis ONLY to the suffix and prefix, not the player name
- **Performance**: Very smooth gradients with many colors may cause minor performance impact
- **Hover Detection**: Hover content relies on client detection and may not work perfectly in all situations
- **Color Format**: Colors must be in hex format (#RRGGBB)

#### Customization Tips
- Use online gradient generators to create color arrays
- You can use \n (newline) in your hover text to add another row of text
- Test different animation speeds for your preferred effect


## Local Speech Helper

*All settings can be customized at the top of the script file!*

#### Quick Setup
1. Download `PostmansLocalSpeechHelper.lua` and `localspeech.bbmodel`
2. Place both files in your avatar's root folder
3. Enable chat modification in figura -> Settings -> Dev -> Chat Messages: ON
4. Reload/Reupload your avatar - that's it!

Note: Avatar needs to be uploaded to figura cloud and pings enabled to function properly  
Selecting the avatar without uploading it will result in the local and global chat not working

#### Features
- **Typewriter Effect**: Text appears character by character with typing sounds
- **Color Words**: Automatic solid and gradient coloring for specific words
- **Text Effects**: Shake effects, hover animation, and dramatic pauses
- **Chat Control**: Configure whether messages go to local speech bubbles, global chat, or both
- **Typing Indicator**: Shows when you're typing to other players
- **Fully Configurable**: Customize appearance, sounds, timing, and behavior

#### Default Behavior
- Type normally in chat to send messages localy
- Use `?` prefix to send messages to global chat only
- Use `>` prefix to send messages to both local and global chat

#### Color List

Certain words in this list are from me (Postman67's) personal preferences and experiences, feel free to modify or remove them as you see fit. Keep these in mind:

##### Single color list
- When a word is matched, it will change to the specified color. 
- If the beginning of a word longer than one in the list contains a color, the whole word will overrun with the color.
- i.e. `star` will match to yellow, so `starwalker` will overrun yellow. `end` will match to purple, so `ending` will overrun purple.
- Adding a space after a word stops the match (i.e. `star ` with a space, won't color `walker`) and starts looking for a new match
- This list is **NOT** case-sensitive, so `Star` or `STAR` will match `star`
- Words can be surrounded by asterisks `*like this*` to force yellow color (e.g. `*bottle*` will be yellow even though it isn't in the list)

##### Gradient list
- When a word is matched, it will apply the specified gradient to the entire word.
- The color overrun on single words does **NOT** apply to gradients, it must be an exact match for the gradient to apply.
- If a word in the gradient list is also in the single words list, the gradient will take precedence.
- This list is NOT case-sensitive, so `Rainbow` or `RAINBOW` will match `rainbow`

