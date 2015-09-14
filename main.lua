display.setStatusBar(display.HiddenStatusBar)

local widget = require('widget')
local texttospeech = require('plugin.texttospeech')

--[[
texttospeech.speak(text, [options])

Generate and play the speech.

text - string, text to be spoken.
options.language - string, language to be used, like 'ru-RU', 'fr-FR'. Default is 'en-US'.
options.pitch - float, alter the pitch of the voice, value from 0.5 to 2.0. Default is 1.0.
options.rate - float, adjust speaking speed, value from 0.5 to 2.0. Default is 1.0.
options.volume - float, set volume of the voice, value from 0.0 to 1.0. Default is 1.0.


texttospeech.stop()

Stop the speech.

]]

display.setDefault('background', 1)

local x, y = display.contentCenterX, display.contentCenterY
local w, h = display.contentWidth * 0.8, 50

widget.newButton{
    x = x, y = y - 100,
    width = w, height = h,
    label = 'Speak',
    onRelease = function()
        texttospeech.speak('Nobody expects the Spanish Inquisition! Our chief weapon is surprise, surprise and fear, fear and surprise, our two weapons are fear and surprise, and ruthless efficiency.')
    end}

widget.newButton{
    x = x, y = y,
    width = w, height = h,
    label = 'Speak Russian',
    onRelease = function()
        texttospeech.speak('Ну и гадость же эта ваша заливная рыба.', {
            language = 'ru-RU',
            pitch = 0.8,
            rate = 0.6,
            volume = 0.9
        })
    end}

widget.newButton{
    x = x, y = y + 100,
    width = w, height = h,
    label = 'Stop',
    onRelease = function()
        texttospeech.stop()
    end}