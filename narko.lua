script_name('narko')
script_author('dima')
script_description('opinanie')

require "lib.moonloader"
local dIstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local scrpit_vers = 1
local script_vers_text = "1.00"

local update_url = "https://raw.githubusercontent.com/dim4ik-sen/ivent/refs/heads/main/iventupdate.ini"
local update_path = "moonloader\\config\\iventupdate.ini"

local script_url = ""
local script_path = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    sampRegisterChatCommand("update", cmd_update)

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dIstatus.STATUS_ENDOWLOADDATA then
            sampAddChatMessage("Файл загружен успешно.", -1)
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > scrpit_vers then
                sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
                update_state = true
            else
                sampAddChatMessage("Нет обновлений. Текущая версия: " .. script_vers_text, -1)
            end
            os.remove(update_path)
        else
            sampAddChatMessage("Ошибка загрузки файла: " .. status, -1)
        end
    end)    

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(update_url, update_path, function(id, status)
                if status == dIstatus.STATUS_ENDOWLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end) 
            break
        end
    end
end

function cmd_update(arg)
    sampShowDialog(1000, "Автообновление", "Это урок по обновлению", "Закрыть", "", 0)
end