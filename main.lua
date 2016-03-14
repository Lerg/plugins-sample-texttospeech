display.setStatusBar(display.HiddenStatusBar)

local json = require('json')
local widget = require('widget')
local texttospeech = require('plugin.texttospeech')

--[[
texttospeech.init(callback)

Must be callled before using any other Text To Speech functions.

callback(event) - called on initialization complete.
    event.isError - boolean, true if there was any error.
    event.engines - table, a list of available engines. Key - engine label, value - engine package name. Requires Android 4.0+.
    event.defaultEngine - string, package name of the default engine. Android only.


texttospeech.getLanguagesAndVoices(), table

Returns a list of available languages and voices for current engine. On Android requires Android 5.0+.

table.languages - array of strings, a list of languages.
table.voices - table, a list of voices. Key - voice name, value - voice language. On iOS there can be iether one or two voices: 'default' and 'alex'. Alex is Siri's voice and only available on iOS 9+.


texttospeech.setEngine(engine), boolean

Sets an engine to use. Returns true on success. Engine might require some time to be initialized. Android only.

engine - string, engine package name.


texttospeech.speak(text, [options])

Generate and play the speech.

text - string, text to be spoken.
options.language - string, language to be used, like 'ru-RU', 'fr-FR'. Default is 'en-US'.
options.voice - string, voice to be used. Requires Android 5.0+.
options.pitch - float, alter the pitch of the voice, value from 0.5 to 2.0. Default is 1.0.
options.rate - float, adjust speaking speed. Android value from 0.5 to 2.0, default is 1.0. iOS value - no idea, it's a mess.
options.volume - float, set volume of the voice, value from 0.0 to 1.0. Default is 1.0.
option.id - string, optional id for the text, passed to onComplete. If not supplied - a random value.
options.onComplete(id) - function, called when speech has ended.


texttospeech.isSpeaking(), boolean

Returns true if currently speaking.


texttospeech.stop()

Stop the speech.

]]

local platform = system.getInfo('platformName')
local apiLevel = system.getInfo('androidApiLevel')
-- 14 -> Android 4.0
-- 21 -> Android 5.0

texttospeech.init(function(event)
    print('Init callback')
    if not event.isError then
        if platform == 'Android' then
            if apiLevel >= 14 then
                print('Engines:', json.prettify(event.engines))
            end
            print('Default engine:', event.defaultEngine)
        end

        if platform == 'iPhone OS' or (platform == 'Android' and apiLevel >= 21) then
            local languagesAndVoices = texttospeech.getLanguagesAndVoices()
            print('Languages and voices:', json.prettify(languagesAndVoices))
        end
    else
        print('Error initializing Text To Speech')
    end
end)

display.setDefault('background', 1)

local x, y = display.contentCenterX, display.contentCenterY
local w, h = display.contentWidth * 0.8, 50

widget.newButton{
    x = x, y = y - 120,
    width = w, height = h,
    label = 'Speak',
    onRelease = function()
        texttospeech.speak('Nobody expects the Spanish Inquisition! Our chief weapon is surprise, surprise and fear, fear and surprise, our two weapons are fear and surprise, and ruthless efficiency.', {
            --voice = 'alex', -- iOS 9.0+
            onComplete = function(id)
                print('Speech "' .. id .. '" has ended.')
            end
        })
    end}

widget.newButton{
    x = x, y = y - 40,
    width = w, height = h,
    label = 'Speak Russian',
    onRelease = function()
        texttospeech.speak('Ну и гадость же эта ваша заливная рыба.', {
            language = 'ru-RU',
            --voice = 'ru-RU-locale', -- Optional. Has effect only on Android 5.0+
            pitch = 0.8,
            rate = 0.6,
            volume = 0.9,
            id = 'fish',
            onComplete = function(id)
                print('Speech "' .. id .. '" has ended.')
            end
        })
    end}

widget.newButton{
    x = x, y = y + 40,
    width = w, height = h,
    label = 'Is speaking?',
    onRelease = function()
        native.showAlert('Is speaking?', texttospeech.isSpeaking() and 'Yes' or 'No', {'OK'})
    end}

widget.newButton{
    x = x, y = y + 120,
    width = w, height = h,
    label = 'Stop',
    onRelease = function()
        texttospeech.stop()
    end}
