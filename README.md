# Postman's Figura Helpers

A list of helpful script files to simply drag into your figura model

## Nameplate Helper


## Local Speech Helper

*All settings can be customized at the top of the script file!*

#### Quick Setup
1. Download `PostmansLocalSpeechHelper.lua` and `localspeech.bbmodel`
2. Place both files in your avatar's root folder
3. Reload your avatar - that's it!

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

