local samp = require("samp.events")
local inicfg = require("inicfg")
local keys = require("vkeys")
local encoding = require("encoding")

encoding.default = "windows-1251"
u8 = encoding.UTF8

local config_file = "bandit_binds.ini"
local config = {
    settings = {
        armor_key = "",
        mask_key = "",
        repcar_key = "",
        drug_key = "",
        reset_anim_armor = false,
        reset_anim_mask = false,
        reset_anim_repcar = false,
        reset_anim_drug = false
    }
}

function load_config()
    local f = io.open(getFolderPath(0) .. "\\config\\" .. config_file, "r")
    if f then
        f:close()
        config = inicfg.load(config, config_file)
    end
end

function save_config()
    inicfg.save(config, config_file)
end

-- Функция для сброса анимации (безопасный способ)
function reset_animation()
    if not isCharInAnyCar(PLAYER_PED) then
        clearCharTasksImmediately(PLAYER_PED)
    end
end

function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    load_config()
    
    sampRegisterChatCommand("armorbind", cmd_armorbind)
    sampRegisterChatCommand("maskbind", cmd_maskbind)
    sampRegisterChatCommand("repcarbind", cmd_repcarbind)
    sampRegisterChatCommand("drugbind", cmd_drugbind)
    sampRegisterChatCommand("usedrugs", cmd_usedrugs)
    sampRegisterChatCommand("banditbinds", cmd_banditbinds)
    
    -- Команды для сброса анимации
    sampRegisterChatCommand("resetanimarmor", cmd_resetanimarmor)
    sampRegisterChatCommand("resetanimmask", cmd_resetanimmask)
    sampRegisterChatCommand("resetanimrepcar", cmd_resetanimrepcar)
    sampRegisterChatCommand("resetanimdrug", cmd_resetanimdrug)
    
    lua_thread.create(function()
        while true do
            wait(0)
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() then
                -- Проверка бинда для брони
                if config.settings.armor_key ~= "" then
                    local armor_vkey = keys["VK_" .. config.settings.armor_key]
                    if armor_vkey and isKeyJustPressed(armor_vkey) then
                        sampSendChat("/armour")
                        if config.settings.reset_anim_armor then
                            wait(500)
                            reset_animation()
                        end
                    end
                end
                
                -- Проверка бинда для маски
                if config.settings.mask_key ~= "" then
                    local mask_vkey = keys["VK_" .. config.settings.mask_key]
                    if mask_vkey and isKeyJustPressed(mask_vkey) then
                        sampSendChat("/mask")
                        if config.settings.reset_anim_mask then
                            wait(500)
                            reset_animation()
                        end
                    end
                end
                
                -- Проверка бинда для починки
                if config.settings.repcar_key ~= "" then
                    local repcar_vkey = keys["VK_" .. config.settings.repcar_key]
                    if repcar_vkey and isKeyJustPressed(repcar_vkey) then
                        sampSendChat("/repcar")
                        if config.settings.reset_anim_repcar then
                            wait(500)
                            reset_animation()
                        end
                    end
                end
                
                -- Проверка бинда для наркотиков
                if config.settings.drug_key ~= "" then
                    local drug_vkey = keys["VK_" .. config.settings.drug_key]
                    if drug_vkey and isKeyJustPressed(drug_vkey) then
                        sampSendChat("/usedrugs 1")
                        if config.settings.reset_anim_drug then
                            wait(500)
                            reset_animation()
                        end
                    end
                end
            end
        end
    end)
    
    sampAddChatMessage(u8:decode("[BanditBinds] Скрипт загружен. Используйте /banditbinds для меню."), 0x00FF00)
    
    wait(-1)
end

function cmd_armorbind(arg)
    if not arg or arg == "" then
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /armorbind [клавиша]"), 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Поддерживаются буквы A-Z и цифры 0-9"), 0x00FF00)
        return
    end
    
    arg = arg:upper()
    if #arg == 1 and (arg:match("[A-Z]") or arg:match("[0-9]")) then
        if arg == config.settings.armor_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже привязана к АвтоБроне"), 0xFF0000)
        elseif arg == config.settings.mask_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоМаской"), 0xFF0000)
        elseif arg == config.settings.repcar_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоПочинкой"), 0xFF0000)
        elseif arg == config.settings.drug_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоНаркотиками"), 0xFF0000)
        else
            config.settings.armor_key = arg
            save_config()
            sampAddChatMessage(u8:decode("[BanditBinds] Клавиша для АвтоБрони изменена на: ") .. arg, 0x00FF00)
        end
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Введите одну букву A-Z или цифру 0-9"), 0x00FF00)
    end
end

function cmd_maskbind(arg)
    if not arg or arg == "" then
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /maskbind [клавиша]"), 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Поддерживаются буквы A-Z и цифры 0-9"), 0x00FF00)
        return
    end
    
    arg = arg:upper()
    if #arg == 1 and (arg:match("[A-Z]") or arg:match("[0-9]")) then
        if arg == config.settings.mask_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже привязана к АвтоМаске"), 0xFF0000)
        elseif arg == config.settings.armor_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоБроней"), 0xFF0000)
        elseif arg == config.settings.repcar_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоПочинкой"), 0xFF0000)
        elseif arg == config.settings.drug_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоНаркотиками"), 0xFF0000)
        else
            config.settings.mask_key = arg
            save_config()
            sampAddChatMessage(u8:decode("[BanditBinds] Клавиша для АвтоМаски изменена на: ") .. arg, 0x00FF00)
        end
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Введите одну букву A-Z или цифру 0-9"), 0x00FF00)
    end
end

function cmd_repcarbind(arg)
    if not arg or arg == "" then
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /repcarbind [клавиша]"), 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Поддерживаются буквы A-Z и цифры 0-9"), 0x00FF00)
        return
    end
    
    arg = arg:upper()
    if #arg == 1 and (arg:match("[A-Z]") or arg:match("[0-9]")) then
        if arg == config.settings.repcar_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже привязана к АвтоПочинке"), 0xFF0000)
        elseif arg == config.settings.armor_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоБроней"), 0xFF0000)
        elseif arg == config.settings.mask_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоМаской"), 0xFF0000)
        elseif arg == config.settings.drug_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоНаркотиками"), 0xFF0000)
        else
            config.settings.repcar_key = arg
            save_config()
            sampAddChatMessage(u8:decode("[BanditBinds] Клавиша для АвтоПочинки изменена на: ") .. arg, 0x00FF00)
        end
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Введите одну букву A-Z или цифру 0-9"), 0x00FF00)
    end
end

function cmd_drugbind(arg)
    if not arg or arg == "" then
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /drugbind [клавиша]"), 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Поддерживаются буквы A-Z и цифры 0-9"), 0x00FF00)
        return
    end
    
    arg = arg:upper()
    if #arg == 1 and (arg:match("[A-Z]") or arg:match("[0-9]")) then
        if arg == config.settings.drug_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже привязана к АвтоНаркотикам"), 0xFF0000)
        elseif arg == config.settings.armor_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоБроней"), 0xFF0000)
        elseif arg == config.settings.mask_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоМаской"), 0xFF0000)
        elseif arg == config.settings.repcar_key then
            sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Клавиша ") .. arg .. u8:decode(" уже занята АвтоПочинкой"), 0xFF0000)
        else
            config.settings.drug_key = arg
            save_config()
            sampAddChatMessage(u8:decode("[BanditBinds] Клавиша для АвтоНаркотиков изменена на: ") .. arg, 0x00FF00)
        end
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Введите одну букву A-Z или цифру 0-9"), 0x00FF00)
    end
end

function cmd_usedrugs(arg)
    if not arg or arg == "" then
        sampSendChat("/usedrugs 1")
        if config.settings.reset_anim_drug then
            wait(500)
            reset_animation()
        end
    else
        sampSendChat("/usedrugs " .. arg)
        if config.settings.reset_anim_drug then
            wait(500)
            reset_animation()
        end
    end
end

-- Команды для настройки сброса анимации
function cmd_resetanimarmor(arg)
    if not arg or arg == "" then
        local status = config.settings.reset_anim_armor and "true" or "false"
        sampAddChatMessage(u8:decode("[BanditBinds] Текущее значение resetanimarmor для брони: ") .. status, 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /resetanimarmor [true/false]"), 0x00FF00)
        return
    end
    
    arg = arg:lower()
    if arg == "true" then
        config.settings.reset_anim_armor = true
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для брони установлен в: true"), 0x00FF00)
    elseif arg == "false" then
        config.settings.reset_anim_armor = false
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для брони установлен в: false"), 0x00FF00)
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Используйте true или false"), 0xFF0000)
    end
end

function cmd_resetanimmask(arg)
    if not arg or arg == "" then
        local status = config.settings.reset_anim_mask and "true" or "false"
        sampAddChatMessage(u8:decode("[BanditBinds] Текущее значение resetanimmask для маски: ") .. status, 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /resetanimmask [true/false]"), 0x00FF00)
        return
    end
    
    arg = arg:lower()
    if arg == "true" then
        config.settings.reset_anim_mask = true
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для маски установлен в: true"), 0x00FF00)
    elseif arg == "false" then
        config.settings.reset_anim_mask = false
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для маски установлен в: false"), 0x00FF00)
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Используйте true или false"), 0xFF0000)
    end
end

function cmd_resetanimrepcar(arg)
    if not arg or arg == "" then
        local status = config.settings.reset_anim_repcar and "true" or "false"
        sampAddChatMessage(u8:decode("[BanditBinds] Текущее значение resetanimrepcar для починки: ") .. status, 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /resetanimrepcar [true/false]"), 0x00FF00)
        return
    end
    
    arg = arg:lower()
    if arg == "true" then
        config.settings.reset_anim_repcar = true
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для починки установлен в: true"), 0x00FF00)
    elseif arg == "false" then
        config.settings.reset_anim_repcar = false
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для починки установлен в: false"), 0x00FF00)
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Используйте true или false"), 0xFF0000)
    end
end

function cmd_resetanimdrug(arg)
    if not arg or arg == "" then
        local status = config.settings.reset_anim_drug and "true" or "false"
        sampAddChatMessage(u8:decode("[BanditBinds] Текущее значение resetanimdrug для наркотиков: ") .. status, 0x00FF00)
        sampAddChatMessage(u8:decode("[BanditBinds] Использование: /resetanimdrug [true/false]"), 0x00FF00)
        return
    end
    
    arg = arg:lower()
    if arg == "true" then
        config.settings.reset_anim_drug = true
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для наркотиков установлен в: true"), 0x00FF00)
    elseif arg == "false" then
        config.settings.reset_anim_drug = false
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Сброс анимации для наркотиков установлен в: false"), 0x00FF00)
    else
        sampAddChatMessage(u8:decode("[BanditBinds] Ошибка: Используйте true или false"), 0xFF0000)
    end
end

function cmd_banditbinds(arg)
    if arg and arg == "0" then
        config.settings.armor_key = ""
        config.settings.mask_key = ""
        config.settings.repcar_key = ""
        config.settings.drug_key = ""
        config.settings.reset_anim_armor = false
        config.settings.reset_anim_mask = false
        config.settings.reset_anim_repcar = false
        config.settings.reset_anim_drug = false
        save_config()
        sampAddChatMessage(u8:decode("[BanditBinds] Все бинды сброшены"), 0x00FF00)
    else
        local armor_status = config.settings.armor_key ~= "" and config.settings.armor_key or u8:decode("НЕТ")
        local mask_status = config.settings.mask_key ~= "" and config.settings.mask_key or u8:decode("НЕТ")
        local repcar_status = config.settings.repcar_key ~= "" and config.settings.repcar_key or u8:decode("НЕТ")
        local drug_status = config.settings.drug_key ~= "" and config.settings.drug_key or u8:decode("НЕТ")
        
        local reset_armor_status = config.settings.reset_anim_armor and u8:decode("ВКЛ") or u8:decode("ВЫКЛ")
        local reset_mask_status = config.settings.reset_anim_mask and u8:decode("ВКЛ") or u8:decode("ВЫКЛ")
        local reset_repcar_status = config.settings.reset_anim_repcar and u8:decode("ВКЛ") or u8:decode("ВЫКЛ")
        local reset_drug_status = config.settings.reset_anim_drug and u8:decode("ВКЛ") or u8:decode("ВЫКЛ")
        
        local dialog_text = u8:decode("BanditBinds - Текущие привязки клавиш\n\n") ..
                            u8:decode("АвтоБроня (/armour): ") .. armor_status .. u8:decode(" | Сброс аним: ") .. reset_armor_status .. u8:decode("\n") ..
                            u8:decode("АвтоМаска (/mask): ") .. mask_status .. u8:decode(" | Сброс аним: ") .. reset_mask_status .. u8:decode("\n") ..
                            u8:decode("АвтоПочинка (/repcar): ") .. repcar_status .. u8:decode(" | Сброс аним: ") .. reset_repcar_status .. u8:decode("\n") ..
                            u8:decode("АвтоНаркотики (/usedrugs 1): ") .. drug_status .. u8:decode(" | Сброс аним: ") .. reset_drug_status .. u8:decode("\n\n") ..
                            u8:decode("Для смены клавиш используйте:\n/armorbind [клавиша]\n/maskbind [клавиша]\n/repcarbind [клавиша]\n/drugbind [клавиша]\n\n") ..
                            u8:decode("Поддерживаются буквы A-Z и цифры 0-9\n\n") ..
                            u8:decode("Для сброса анимации:\n/resetanimarmor [true/false]\n/resetanimmask [true/false]\n/resetanimrepcar [true/false]\n/resetanimdrug [true/false]\n\n") ..
                            u8:decode("Для сброса биндов: /banditbinds 0")
        sampShowDialog(1000, u8:decode("BanditBinds"), dialog_text, u8:decode("Закрыть"), "", 0)
    end
end

function getFolderPath(id)
    local path = getWorkingDirectory()
    if id == 0 then
        local config_path = path .. "\\config"
        if not doesDirectoryExist(config_path) then
            createDirectory(config_path)
        end
        return path
    end
    return path
end
