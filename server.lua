------------------------
--------VARIABLES-------
------------------------
local youtubevideoLink = 'https://www.youtube.com/watch?v='
--the api key you have generated in https://console.cloud.google.com with the YouTube Data API v3 enabled
local youtubeApiKey = ''

------------------------
---------EVENTS---------
------------------------

RegisterServerEvent('imperio_dances:updatePoints', function(points, job)
    TriggerClientEvent('imperio_dances:showPoints', -1, points, job, source)
end)

RegisterServerEvent('imperio_dances:inviteDance', function(idInvited)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name

    TriggerClientEvent('imperio_dances:receiveInvitation', idInvited, job)
end)

RegisterServerEvent('imperio_dances:startDance', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name

    MySQL.single('select url, thumbUrl, thumbTitle, title, duration from imperio_dances where job=? and id=?', {job, id}, function(data)
        if data then
            local area = Config.Nightclubs[job].area

            if exports['cs-hall']:IsPlaying(area) then
                exports['cs-hall']:Pause(area)
                Wait(1500)
            else
                exports['cs-hall']:Stop(area)
            end
            exports['cs-hall']:AddToQueue(area, data.url, data.thumbUrl, data.thumbTitle, data.title, 'fab fa-youtube icon', data.duration)

            local queue = exports['cs-hall']:GetQueue(area)

            exports['cs-hall']:QueueNow(area, #queue)
            exports['cs-hall']:Play(area)
            TriggerClientEvent('imperio_dances:startDance', -1, job, data.duration)
        else
            xPlayer.showNotification(Translate('not_found'))
        end
    end)
end)

RegisterServerEvent('imperio_dances:addSong', function(vidId, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name

    PerformHttpRequest("https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails&id="..vidId.."&key="..youtubeApiKey  , function(err, data, head)
        if err == 200 then
            local videoInfo = json.decode(data)
            videoInfo = videoInfo.items[1]

            local url = youtubevideoLink..vidId
            local thumbUrl = videoInfo.snippet.thumbnails.high.url
            local thumbTitle = videoInfo.snippet.channelTitle
            local title = videoInfo.snippet.title
            local duration = videoInfo.contentDetails.duration
            local t = { H = 0, M = 0, S = 0}

            for v, k in duration:gmatch("([%d.,]+)(%u)") do
                t[k] = tonumber(v)
            end

            t['M'] = t['M']+t['H']*60
            duration = t['S']+t['M']*60

            MySQL.insert('INSERT INTO imperio_dances (url, name, job, thumbUrl, thumbTitle, title, duration) VALUES (?, ?, ?, ?, ?, ?, ?)', {url, name, job, thumbUrl, thumbTitle, title, duration}, function(id)
                if id then
                    xPlayer.showNotification(Translate('song_added'))
                else
                    xPlayer.showNotification(Translate('song_add_error'), 'error')
                end
            end)
        else
            xPlayer.showNotification(Translate('video_data_error'))
        end
    end, "GET", "", { ["Content-Type"] = "application/json"})
end)

RegisterServerEvent('imperio_dances:removeSong', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name

    MySQL.update('DELETE FROM imperio_dances WHERE id=? AND job=?', {id, job}, function(rowsChanged)
        if rowsChanged then
            xPlayer.showNotification(Translate('song_deleted'))
        else
            xPlayer.showNotification(Translate('song_delete_error'), 'error')
        end
    end)
end)

------------------------
--------CALLBACKS-------
------------------------

ESX.RegisterServerCallback('imperio_dances:getSongs', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name

    MySQL.query("SELECT id, url, name FROM `imperio_dances` WHERE `job` = ?", {job}, function(result)
        local songTable = {}

        if #result > 0 then
            for i=1, #result do
                local data = result[i]
                songTable[i] = {
                    video = data.url,
                    label = "🎼" .. data.name,
                    id = data.id
                }
            end
        end
        cb(songTable)
    end)
end)