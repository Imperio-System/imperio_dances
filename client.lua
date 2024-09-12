------------------------
--------VARIABLES-------
------------------------

local dancing = false
local invitation = ""

------------------------
--------FUNCTIONS-------
------------------------

function startDance(duration)
	TriggerServerEvent('imperio_dances:updatePoints', 0, invitation)
	SendNUIMessage({show = "start", duration = duration})
	dancing = true
	alternateDances()
	while dancing do
		if IsControlJustPressed(0, 32) then --W
			SendNUIMessage({key = "W"})
		elseif IsControlJustPressed(0, 34) then --A
			SendNUIMessage({key = "A"})
		elseif IsControlJustPressed(0, 33) then --S
			SendNUIMessage({key = "S"})
		elseif IsControlJustPressed(0, 35) then --D
			SendNUIMessage({key = "D"})
		end
		Wait(1)
	end
end

function alternateDances()
	local dances = {
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "high_left_up",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "high_left_down",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "med_right_down",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "med_center",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "high_center_down",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "low_left",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "low_left_down",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "low_left_up",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "low_right",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "low_right_down",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "low_right_up",
		},
		{
			dict = "anim@amb@nightclub@dancers@tale_of_us_entourage@",
			anim = "mi_dance_prop_13_v2_male^4",
		},
		{
			dict = "anim@amb@nightclub@dancers@tale_of_us_entourage@",
			anim = "mi_dance_crowd_13_v2_female^4",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "med_left",
		},
		{
			dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
			anim = "med_right",
		},
	}

	CreateThread(function()
		local prev = 0
		while dancing do
			local rnd = math.random(#dances)
			while prev == rnd do
				rnd = math.random(#dances)
			end
			prev = rnd
			local anim = dances[rnd]

			ESX.Streaming.RequestAnimDict(anim.dict, function()
				TaskPlayAnim(ESX.PlayerData.ped, anim.dict, anim.anim, 8.0, -8, -1, 1, 0, 0, 0, 0)
			end)
			Wait(10000)
		end
	end)
end

function menuStartDanceContest()
	ESX.TriggerServerCallback('imperio_dances:getSongs', function(songs)
		local elements = {}

		for i = 1, #songs do
			local song = songs[i]
			elements[i] = {
				title = song.label,
				args={
					id = song.id
				},
				onSelect = function(args)
					TriggerServerEvent('imperio_dances:startDance', args.id)
				end
			}
		end

		lib.registerContext({
			id = 'menuStartDanceContest',
			title = Translate('start_dance_menu_title'),
			menu = 'MenuDanceContest',
			options = elements
		})

		lib.showContext('menuStartDanceContest')
	end)
end

function menuSongs()
	ESX.TriggerServerCallback('imperio_dances:getSongs', function(songs)
		local elements = {}
		for i = 1, #songs do
			local song = songs[i]
			elements[i] = {
				title = song.label,
				args = {
					id = song.id,
					video = song.video
				},
				arrow = true,
				onSelect = function(args)
					local soundId = 'test'..PlayerId()
					if exports.xsound:soundExists(soundId) then
						if exports.xsound:isPlaying(soundId) then
							exports.xsound:Pause(soundId)
						end
						exports.xsound:Destroy(soundId)
					end
					exports.xsound:PlayUrl(soundId, args.video, 0.5, false)
					exports.xsound:destroyOnFinish(soundId, true)
					menuDeleteSong(args)
				end
			}
		end

		elements[#elements+1] = {
			title = Translate('add_song'),
			onSelect = function()
				local input = lib.inputDialog(Translate('add_song'), {
					{type = 'input', label = Translate('song_name'), required = true},
					{type = 'input', label = Translate('song_url'), required = true, placeholder = 'https://www.youtube.com/watch?v=xxxxxxxxxx'}
				},{allowCancel = true})

				if input then
					local pattern = "v=(...........)"
					local vidid =  string.match(input[2], pattern)
					TriggerServerEvent('imperio_dances:addSong', vidid, input[1])
				end
			end
		}

		elements[#elements+1] = {
			title = Translate('stop_music'),
			onSelect = function()
				local soundId = 'test'..PlayerId()
				if exports.xsound:soundExists(soundId) then
					if exports.xsound:isPlaying(soundId) then
						exports.xsound:Pause(soundId)
					end
					exports.xsound:Destroy(soundId)
				end
			end
		}

		lib.registerContext({
			id = 'menuSongs',
			title = Translate('menu_songs_title'),
			menu = 'MenuDanceContest',
			options = elements
		})

		lib.showContext('menuSongs')
	end)
end

function menuDeleteSong(data)
	lib.registerContext({
		id = 'menuDeleteSong',
		title = Translate('menu_delete_song_title'),
		menu = 'menuSongs',
		options = {
			{
				title = Translate('confirm_delete'),
				args = data,
				onSelect = function(args)
					local soundId = 'test'..PlayerId()
					if exports.xsound:soundExists(soundId)then
						if exports.xsound:isPlaying(soundId) then
							exports.xsound:Pause(soundId)
						end
						exports.xsound:Destroy(soundId)
						TriggerServerEvent('imperio_dances:removeSong', args.id)
					end
				end
			}
		}
	})
	lib.showContext('menuDeleteSong')
end

function menuInvite()
	local elements = {}

	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(ESX.PlayerData.ped), 5.0)
	local svidme = GetPlayerServerId(PlayerId())

	elements[1] = {
        title = Translate('me', svidme),
        args = {
            value = svidme
        },
        onSelect = function(args)
            TriggerServerEvent('imperio_dances:inviteDance', args.value)
        end
    }

	for i = 1, #players do
		local player = players[i]
        local svid = GetPlayerServerId(player)

        elements[i+1] = {
            title = Translate('id', svid),
            args = {
                value = svid
            },
            onSelect = function(args)
                TriggerServerEvent('imperio_dances:inviteDance', args.value)
            end
        }
    end

	lib.registerContext({
		id = 'menuInvite',
		title = Translate('menu_invite_title'),
		manu = 'MenuDanceContest',
		options = elements
	})

	lib.showContext('menuInvite')
end

function endDance()

	local dances = {
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "air_slap_a_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "cheer_a_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "clapping_a_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "dance_a_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "finger_guns_a_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "finger_guns_b_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "fist_pump_a_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "hands_air_b_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "hands_air_c_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "regal_a_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "regal_b_1st",
		},
		{
			dict = "anim@arena@celeb@podium@no_prop@",
			anim = "regal_c_1st",
		},
	}

	local rnd = math.random(#dances)
	local anim = dances[rnd]
	ESX.Streaming.RequestAnimDict(anim.dict, function()
		TaskPlayAnim(ESX.PlayerData.ped, anim.dict, anim.anim, 8.0, -8, -1, 0, 0, 0, 0, 0)
	end)
end

function menuContest(menu)
	if Config.Nightclubs[ESX.PlayerData.job.name] then
		lib.registerContext({
			id = 'MenuDanceContest',
			title = Translate('menu_dance_contest_title'),
			menu = menu,
			options = {
				{
					title = Translate('invite_contest'),
					arrow = true,
					onSelect = function()
						menuInvite()
					end
				},
				{
					title = Translate('start_contest'),
					arrow = true,
					onSelect = function()
						menuStartDanceContest()
					end
				},
				{
					title = Translate('manage_songs'),
					arrow = true,
					onSelect = function()
						menuSongs()
					end
				}
			}
		})

		lib.showContext('MenuDanceContest')
	else
		ESX.ShowNotification(Translate('not_access'))
	end
end

exports('openMenu', menuContest)

------------------------
---------EVENTS---------
------------------------

RegisterNetEvent('imperio_dances:startDance', function(nightclub, duration)
	Config.Nightclubs[nightclub].scores = {}
	if invitation == nightclub then
		local coords = GetEntityCoords(ESX.PlayerData.ped)
		local distance = #(Config.Nightclubs[invitation].cordsScores - coords)

		if distance < 15 then
			startDance(duration)
		else
			invitation = ""
			ESX.ShowNotification(Translate('start_dance_error'))
		end
	end
end)

RegisterNetEvent('imperio_dances:menu', function(menu)
	menuContest(menu)
end)

RegisterNetEvent('imperio_dances:showPoints', function(points, nightclub, id)
	if not nightclub or not id then
		return
	end
	Config.Nightclubs[nightclub].scores[id] = points
end)

RegisterNetEvent('imperio_dances:receiveInvitation', function(nightclub)
	local answer = lib.alertDialog({
		header = Translate('invitation_header'),
		content = Translate('invitation_content'),
		centered = true,
		cancel = true,
		labels = {
			cancel = Translate('reject'),
			confirm = Translate('confirm')
		}
	})

	if answer == 'confirm' then
		invitation = nightclub
	end
end)

------------------------
--------CALLBACKS-------
------------------------

RegisterNUICallback('updatePoints', function(data, cb)
    TriggerServerEvent('imperio_dances:updatePoints', data.ammount, invitation)
	cb('ok')
end)

RegisterNUICallback('endDance', function(_, cb)
	if invitation ~= "" then
		endDance()
		dancing = false
	end
	invitation = ""
	cb('ok')
end)

------------------------
--------THREADS---------
------------------------

CreateThread(function()
	while true do
		local coordsPed = GetEntityCoords(ESX.PlayerData.ped)
		local sleep = 500

		for _, nightclub in pairs(Config.Nightclubs) do
			local distance = #(nightclub.cordsScores - coordsPed)

			if distance < 8 and nightclub.scores ~= {} then
				local x, y, z = table.unpack(nightclub.cordsScores)
				z = z+(0.15*#nightclub.scores)
				for id, points in pairs(nightclub.scores) do
					ESX.Game.Utils.DrawText3D(vec3(x, y, z), Translate('score_text', id, points), 1, 4)
					z = z-0.15
				end
				sleep = 0
			end
		end
		Wait(sleep)
	end
end)

------------------------
--------COMMANDS--------
------------------------

RegisterCommand('dances', function()
	menuContest()
end)