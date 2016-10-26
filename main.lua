-- Sample app for the TextToSpeech plugin for Corona SDK
-- Documentation: http://spiralcodestudio.com/plugin-texttospeech/

display.setStatusBar(display.HiddenStatusBar)

local json = require('json')
local widget = require('widget')
local audio = require('audio')
local texttospeech = require('plugin.texttospeech')

local platform = system.getInfo('platformName')
local apiLevel = system.getInfo('androidApiLevel')
-- 14 -> Android 4.0
-- 21 -> Android 5.0
texttospeech.enableDebug()

local function onInit(event)
	print('Init callback')
	if not event.isError then
		print(platform)
		if platform == 'Android' then
			if apiLevel >= 14 then
				print('Engines:', json.prettify(event.engines))
			end
			print('Default engine:', event.defaultEngine)
		end

		if platform == 'iPhone OS' or platform == 'Mac OS X' or (platform == 'Android' and apiLevel >= 21) then
			local languagesAndVoices = texttospeech.getLanguagesAndVoices()
			if languagesAndVoices then
				print('Languages and voices:', json.prettify(languagesAndVoices))
			end
		end
	else
		print('Error initializing Text To Speech')
	end
end
texttospeech.init(onInit)

local voice
if platform == 'Mac OS X' then
	voice = 'com.apple.speech.synthesis.voice.samantha'
elseif platform == 'iPhone OS' then
	voice = 'alex'
end

display.setDefault('background', 1)

local xl, xr, y = display.contentWidth * .25, display.contentWidth * .75, display.contentCenterY
local w, h = display.contentWidth * 0.45, 50

widget.newButton{
	x = xl, y = y - 200,
	width = w, height = h,
	label = 'Speak',
	onRelease = function()
		local text = 'Nobody expects the Spanish Inquisition! Our chief weapon is surprise, surprise and fear, fear and surprise, our two weapons are fear and surprise, and ruthless efficiency.'
		texttospeech.speak(text, {
			voice = voice,
			onStart = function(event)
				print('Speech "' .. event.id .. '" has started.')
			end,
			onProgress = function(event)
				if event.start then
					print('Speech "' .. event.id .. '" progress: ' .. text:sub(event.start, event.start + event.count))
				elseif event.audio then
					print('Speech "' .. event.id .. '" progress: chunk length - ' .. #event.audio)
				end
			end,
			onComplete = function(event)
				print('Speech "' .. event.id .. '" has ended.')
			end
		})
	end}

widget.newButton{
	x = xr, y = y - 200,
	width = w, height = h,
	label = 'Speak Russian',
	onRelease = function()
		local text = 'Ну и гадость же эта ваша заливная рыба.'
		texttospeech.speak(text, {
			language = 'ru-RU',
			--voice = 'ru-RU-locale', -- Optional. Has effect only on Android 5.0+
			pitch = 0.8,
			rate = 0.6,
			volume = 0.9,
			id = 'fish',
			onStart = function(event)
				print('Speech "' .. event.id .. '" has started.')
			end,
			onProgress = function(event)
				-- Simple string.sub() won't work for UTF-8 strings, use UTF-8 plugin
				if event.start then
					print('Speech "' .. event.id .. '" progress: start - ' .. event.start .. ', count - ' .. event.count)
				elseif event.audio then
					print('Speech "' .. event.id .. '" progress: chunk length - ' .. #event.audio)
				end
			end,
			onComplete = function(event)
				print('Speech "' .. event.id .. '" has ended.')
			end
		})
	end}

widget.newButton{
	x = xl, y = y - 120,
	width = w, height = h,
	label = 'Speak Japanese',
	onRelease = function()
		local text = '愛と正義の、セーラー服美少女戦士、セーラームーン! 月に代わって、お仕置きよ!'
		texttospeech.speak(text, {
			language = 'ja-JP',
			pitch = 1.2,
			rate = 1,
			id = 'japanese',
			onStart = function(event)
				print('Speech "' .. event.id .. '" has started.')
			end,
			onProgress = function(event)
				-- Simple string.sub() won't work for UTF-8 strings, use UTF-8 plugin
				if event.start then
					print('Speech "' .. event.id .. '" progress: start - ' .. event.start .. ', count - ' .. event.count)
				elseif event.audio then
					print('Speech "' .. event.id .. '" progress: chunk length - ' .. #event.audio)
				end
			end,
			onComplete = function(event)
				print('Speech "' .. event.id .. '" has ended.')
			end,
			onPause = function(event)
				print('Speech "' .. event.id .. '" has been paused.')
			end,
			onContinue = function(event)
				print('Speech "' .. event.id .. '" has been continnued.')
			end
		})
	end}

	widget.newButton{
		x = xr, y = y - 120,
		width = w, height = h,
		label = 'Speak to file',
		onRelease = function()
			local extension = 'wav'
			if platform == 'Mac OS X' then
				extension = 'aiff'
			end
			local text = 'Spiral Code Studio presents you the Text To Speech plugin.'
			texttospeech.speak(text, {
				voice = voice,
				id = 'file',
				filename = 'speech.' .. extension,
				baseDir = system.DocumentsDirectory,
				onStart = function(event)
					print('Speech "' .. event.id .. '" has started.')
				end,
				onProgress = function(event)
					if event.start then
						print('Speech "' .. event.id .. '" progress: ' .. text:sub(event.start, event.start + event.count))
					elseif event.audio then
						print('Speech "' .. event.id .. '" progress: chunk length - ' .. #event.audio)
					end
				end,
				onComplete = function(event)
					print('Speech "' .. event.id .. '" has ended.')
				end,
				onPause = function(event)
					print('Speech "' .. event.id .. '" has been paused.')
				end,
				onContinue = function(event)
					print('Speech "' .. event.id .. '" has been continnued.')
				end
			})
		end}

widget.newButton{
	x = xl, y = y - 40,
	width = w, height = h,
	label = 'Is speaking?',
	onRelease = function()
		native.showAlert('Is speaking?', texttospeech.isSpeaking() and 'Yes' or 'No', {'OK'})
	end}

widget.newButton{
	x = xr, y = y - 40,
	width = w, height = h,
	label = 'Stop',
	onRelease = function()
		texttospeech.stop()
	end}

widget.newButton{
	x = xl, y = y + 40,
	width = w, height = h,
	label = 'Pause',
	onRelease = function()
		texttospeech.pause()
	end}

widget.newButton{
	x = xr, y = y + 40,
	width = w, height = h,
	label = 'Continue',
	onRelease = function()
		texttospeech.continue()
	end}

widget.newButton{
	x = xl, y = y + 120,
	width = w, height = h,
	label = 'Pause at word',
	onRelease = function()
		texttospeech.pause(true)
	end}

widget.newButton{
	x = xr, y = y + 120,
	width = w, height = h,
	label = 'Get lang/voices',
	onRelease = function()
		local languagesAndVoices = texttospeech.getLanguagesAndVoices()
		if languagesAndVoices then
			print('Languages and voices:', json.prettify(languagesAndVoices))
		end
	end}

widget.newButton{
	x = xl, y = y + 200,
	width = w, height = h,
	label = 'Play file',
	onRelease = function()
		local extension = 'wav'
		if platform == 'Mac OS X' then
			extension = 'aiff'
		end
		local speech = audio.loadSound('speech.' .. extension, system.DocumentsDirectory)
		if speech then
			audio.play(speech, {onComplete = function()
				audio.dispose(speech)
			end})
		end
	end}

if platform == 'Android' then
	widget.newButton{
		x = xr, y = y + 200,
		width = w, height = h,
		label = 'Set Pico TTS',
		onRelease = function()
			texttospeech.init({engine = 'com.svox.pico', listener = onInit})
		end}
end
