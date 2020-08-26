script_name('Arizona_Assistant')
script_author('Phealz')
script_version('2.5')
script_description('Помощник для Аризоны. Информация по обновлению - /obcheck.')

require "lib.moonloader"

local dlstatus = require('moonloader').download_status
local hook = require 'lib.samp.events'

local tag = '[ARZ Assistant]' -- just
local tagG = '{00C22A}[ARZ Assistant]{FFFFFF}:' -- green
local tagD = '{00C22A}[ARZ Assistant Download]{FFFFFF}:'


local inicfg = require 'inicfg'
local imgui = require 'imgui'
local slider = imgui.ImInt(1)
local encoding = require'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local dlstatus = require('moonloader').download_status

local directIni = "moonloader/config/arz_as.ini"

local mainIni = inicfg.load({
config =
{
skip=false,
skipDM=false,
flud=false,
phone=false,
mask=false,
smoke=false,
lock=false,
key=false,
time=false,
chasi= " ",
vrsms= " ",
dopsms=false,
doppiar= " ",
narkotiki=false,
deagle=false,
mfour=false,
rifle=false,
minyt=false,
sbiv=false,
repcar=false,
fillcar=false
},
autologin = 
{
autologinBox=false,
parolI= " "
},
accent =
{
    accentic=false,
    accenti= " "
}
}, 'arz_as')

local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)
local skip = imgui.ImBool(mainIni.config.skip)
local accentic = imgui.ImBool(mainIni.accent.accentic)
local accenti = imgui.ImBuffer(''..mainIni.accent.accenti, 500)
local skipDM = imgui.ImBool(mainIni.config.skipDM)
local flud = imgui.ImBool(mainIni.config.flud)
local phone = imgui.ImBool(mainIni.config.phone)
local slider = imgui.ImInt(15000)
local mask = imgui.ImBool(mainIni.config.mask)
local smoke = imgui.ImBool(mainIni.config.smoke)
local lock = imgui.ImBool(mainIni.config.lock)
local key = imgui.ImBool(mainIni.config.key)
local time = imgui.ImBool(mainIni.config.time)
local chasi = imgui.ImBuffer(''..mainIni.config.chasi, 500)
local vrsms = imgui.ImBuffer(''..mainIni.config.vrsms, 500)
local dopsms = imgui.ImBool(mainIni.config.dopsms)
local doppiar = imgui.ImBuffer(''..mainIni.config.doppiar, 500)
local narkotiki = imgui.ImBool(mainIni.config.narkotiki)
local deagle = imgui.ImBool(mainIni.config.deagle)
local mfour = imgui.ImBool(mainIni.config.mfour)
local rifle = imgui.ImBool(mainIni.config.rifle)
local minyt = imgui.ImBool(mainIni.config.minyt)
local sbiv = imgui.ImBool(mainIni.config.sbiv)
local repcar = imgui.ImBool(mainIni.config.repcar)
local fillcar = imgui.ImBool(mainIni.config.fillcar)
local autologinBox = imgui.ImBool(mainIni.autologin.autologinBox)
local parolI = imgui.ImBuffer(''..mainIni.autologin.parolI, 500)

local osnfunctions = imgui.ImBool(false)
local oscripte = imgui.ImBool(false)
local piarik = imgui.ImBool(false)
local chasiki = imgui.ImBool(false)
local accent = imgui.ImBool(false)
local infob = imgui.ImBool(false)

local autologin = imgui.ImBool(false)


local status = inicfg.load(mainIni, 'arz_as.ini')
if not doesFileExist('moonloader/config/arz_as.ini') then inicfg.save(mainIni, 'arz_as.ini') end

function update()
    local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
    downloadUrlToFile('https://gist.githubusercontent.com/Phealz/d2ac9f507182d7a481c2bbaf15b0b132/raw/b0e121d4b0973fb5c0230025a43666908d3d08cd/versions', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
      local f = io.open(fpath, 'r') -- открывает файл
      if f then
        local info = decodeJson(f:read('*a')) -- читает
        updatelink = info.updateurl
        if info and info.latest then
          version = tonumber(info.latest) -- переводит версию в число
          if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
            lua_thread.create(goupdate) -- апдейт
          else -- если меньше, то
            update = false -- не даём обновиться
            sampAddChatMessage((tagD .. ' У вас последняя версия скрипта! Обновление отменено.'), -1)
          end
        end
      end
    end
end)
end

function goupdate()
    sampAddChatMessage((tagD .. ' Обнаружено обновление! Обновляюсь...'), -1)
    sampAddChatMessage((tagD .. ' Текущая версия: '..thisScript().version..". Новая версия: "..version), -1)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
      if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
      sampAddChatMessage((tagD .. ' Обновление завершено!'), -1)
      thisScript():reload()
    end
    end)
    end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        nick = sampGetPlayerNickname(id)
        
        imgui.Process = false

        sampAddChatMessage(tagG .. " {890303}by Phealz {00C22A}loaded.{FFFFFF} Version: {890303}v. "..thisScript().version, -1)
        sampAddChatMessage(tagG .. ' {FFFFFF}Добро пожаловать, '..nick, -1)

        sampRegisterChatCommand('obinfo', obinfo)

        sampRegisterChatCommand('arza', cmd_imgui)
    
        sampRegisterChatCommand('pr', function()
        act = not act; sampAddChatMessage(act and '{00C22A}Реклама включена!' or '{00C22A}Реклама выключена!', -1)
	    if act then
         piar()
        end
        end)

        if doesFileExist('moonloader\\lib\\vkeys.lua') then
            sampAddChatMessage(tagD .. ' Модуль vkeys.lua установлен!')
            keys = require 'vkeys'
        else
            downloadUrlToFile('https://docs.google.com/uc?id=1vCzvkXwKaCXDkQQACf2TnETUmugKT6rs', 'moonloader\\lib\\vkeys.lua', function (id, status)
                if status == dl.status.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(tagD .. ' Модуль vkeys успешно установлен!', -1)
                    keys = require 'vkeys'
                    print(tagD .. ' Модуль vkeys успешно установлен!')
                end
            end)
        end
        
        if not doesDirectoryExist('moonloader\\resource\\themes') then
            createDirectory('moonloader\\resource\\themes')
            print(tagD .. ' Папка themes имеется!')
        end
        
        if doesFileExist('moonloader\\resource\\themes\\imgui_themes.lua') then
            themes = import '/resource/themes/imgui_themes.lua'
            print(tagD .. ' imgui_themes.lua имеется!')
        else
            downloadUrlToFile('https://docs.google.com/uc?id=1oamATUXTv0TMjUlEiUvJdq3TUCicRPdk', 'moonloader\\resource\\themes\\imgui_themes.lua', function (id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(tagD .. ' Модуль imgui_themes.lua был загружен!', -1)
                    themes = import '/resource/themes/imgui_themes.lua'
                    print(tagD .. " Модуль imgui_themes.lua был загружен!")
                end
            end)
        end
        
    while true do
        wait(0)
    
        if not main_window_state.v and not oscripte.v and not osnfunctions.v and not piarik.v and not chasiki.v and not autologin.v and not infob.v then
            imgui.Process = false
        end

        if phone.v and isKeyJustPressed(VK_P) and not sampIsCursorActive() then
            sampSendChat('/phone')
        end

        if mask.v then
            if testCheat('MSK') then
                sampSendChat('/mask')
            end
        end

        if smoke.v then
            if testCheat('SMK') then
                sampSendChat('/smoke')
            end
        end

        if lock.v then
            if testCheat('L') then
                sampSendChat('/cars')
            end
        end

        if key.v and isCharInAnyCar(PLAYER_PED) then
            if testCheat('K') then
                sampSendChat('/key')
            end
        end

        if time.v and not sampIsCursorActive() then 
            if testCheat('RE') then
                sampSendChat(u8:decode(chasi.v))
                wait(1200)
                sampSendChat('/time')
                wait(1200)
                sampSendChat('/do На часах '..os.date('%H:%M:%S.'))
            end
        end

        if narkotiki.v and isKeyJustPressed(VK_MENU) and isKeyJustPressed(0x31) then
            sampSendChat('/usedrugs 1')
        end

        if narkotiki.v and isKeyJustPressed(VK_MENU) and isKeyJustPressed(0x32) then
            sampSendChat('/usedrugs 2')
        end

        if narkotiki.v and isKeyJustPressed(VK_MENU) and isKeyJustPressed(0x33) then
            sampSendChat('/usedrugs 3')
        end

        if sbiv.v and not isCharInAnyCar(PLAYER_PED) then
            if testCheat('Q') then
                sampSendChat('/anim 1')
            end
        end

        if repcar.v and not sampIsCursorActive() then
            if testCheat('RCAR') then
                sampSendChat('/repcar')
            end
        end
        
        if fillcar.v and not sampIsCursorActive() then
            if testCheat('FCAR') then
                sampSendChat('/fillcar')
            end
        end
    end
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function cmd_imgui(arg)
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end
function obinfo(arg)
    sampAddChatMessage(tagG .. ' {FFFFFF}Версия скрипта: '..thisScript().version, -1)
    sampAddChatMessage(tagG .. ' {FFFFFF}Добавлена автодокачка необходимых библиотек.', -1)
    sampAddChatMessage(tagG .. ' {FFFFFF}Удачной игры, '..nick, id, -1)
end

function hook.onSendChat(message)
    if accentic.v then
        if message == ')' or message == '(' or message ==  '))' or message == '((' or message == 'xD' or message == ':D' or message == ':d' or message == 'q' or message == 'XD' then return{message} end
        return{'['..u8:decode(accenti.v)..']: '..message}
    end
end

function imgui.OnDrawFrame()
    if main_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(196, 173), imgui.Cond.FirstUseEver)
		if not window_pos then
			ScreenX, ScreenY = getScreenResolution()ScreenX, ScreenY = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(4.7, 0.5))
		end
        imgui.Begin('Arizona Assistant | By Phealz', main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
            if imgui.Button(u8'Основные функции', imgui.ImVec2(180, 20)) then
                osnfunctions.v = true
            end

            if imgui.Button(u8'О скрипте', imgui.ImVec2(180, 20)) then
                oscripte.v = true
            end

            if imgui.Button(u8'АвтоПиар', imgui.ImVec2(180, 20)) then
                piarik.v = true
            end

            if imgui.Button(u8'Отыгровка часов', imgui.ImVec2(180, 20)) then
                chasiki.v = true
            end

            if imgui.Button(u8'АвтоЛогин', imgui.ImVec2(180, 20)) then
                autologin.v = true
            end
            
            if imgui.Button(u8'Акцент', imgui.ImVec2(180, 20)) then
                accent.v = true
            end
        imgui.End()
        
        if accent.v then
            imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(2.699, 1.04))
            imgui.Begin(u8'Акцент', accent,imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
                if imgui.Checkbox(u8'Включить акцент', accentic) then
                    mainIni.accent.accentic = accentic.v 
                    inicfg.save(mainIni, 'arz_as.ini')
                end
                imgui.Text('[')
                imgui.SameLine()
                if imgui.InputText('', accenti) then
                    mainIni.accent.accenti = accenti.v
                    inicfg.save(mainIni, 'arz_as.ini')
                end
                imgui.SameLine()
                imgui.Text(']')
                imgui.SameLine()
                imgui.Text(':')
            imgui.End()
        end

        if osnfunctions.v then
            imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(2.83, 0.187))
        imgui.Begin(u8"Основные функции",osnfunctions,imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
            imgui.Checkbox(u8'Автоскип репорта', skip)
            imgui.SameLine()
            imgui.TextQuestion(u8'Как только скрипт увидит ответ администратора он пропустит диалог.')
            imgui.Checkbox(u8'Автоскип ДМ ЗЗ', skipDM)
            imgui.SameLine()
            imgui.TextQuestion(u8'Когда вы ударите/стрельнете в ЗЗ, скрипт скипнет диалог о ДМ ЗЗ.')
            imgui.Checkbox(u8'Убирает флуд сервера', flud)
            imgui.SameLine()
            imgui.TextQuestion(u8'Убирает флуд по типу: со склада выехал матовоз и тп.')
            imgui.Checkbox(u8'Телефон', phone)
            imgui.SameLine()
            imgui.TextQuestion(u8'Достанет телефон на клавишу P')
            imgui.Checkbox(u8'Маска', mask)
            imgui.SameLine()
            imgui.TextQuestion(u8'При сочетании клавиш MSK (как чит), оденет маску.')
            imgui.Checkbox(u8'Сигарета', smoke)
            imgui.SameLine()
            imgui.TextQuestion(u8'При сочетании клавиш SIG (как чит), достанет сигарету из инвентаря.')
            imgui.Checkbox(u8'Закрыть авто', lock)
            imgui.SameLine()
            imgui.TextQuestion(u8'Закроет авто на клавишу L.')
            imgui.Checkbox(u8'Вынуть ключ из замка зажигания', key)
            imgui.SameLine()
            imgui.TextQuestion(u8'Вынет ключ из замка зажигания на клавишу K.')
            imgui.Checkbox(u8'Наркотики', narkotiki)
            imgui.SameLine()
            imgui.TextQuestion(u8'ALT + 1 = 1 наркотик, ALT + 2 = 2 наркотикa, ALT + 3 = 3 наркотикa.')
            imgui.Checkbox(u8'Минуты в деморгане', minyt)
            imgui.SameLine()
            imgui.TextQuestion(u8'Переводит секунды в минуты в деморгане')
            imgui.Checkbox(u8'Сбив', sbiv)
            imgui.SameLine()
            imgui.TextQuestion(u8'При нажатии на клавишу Q, скрипт активирует /anim 1, дальше просто нажать энтер.')
            imgui.Checkbox(u8'Ремонт машины', repcar)
            imgui.SameLine()
            imgui.TextQuestion(u8'Отремонтирует машину сочетанием клавиш RCAR.')
            imgui.Checkbox(u8'Заправка машины', fillcar)
            imgui.SameLine()
            imgui.TextQuestion(u8'Заправит машину сочетанием клавиш FCAR.')
            if imgui.Button(u8'Сохранить настройки', imgui.ImVec2(241, 64)) then
                mainIni.config.skip = skip.v
                mainIni.config.skipDM = skipDM.v
                mainIni.config.flud = flud.v
                mainIni.config.phone = phone.v
                mainIni.config.mask = mask.v
                mainIni.config.smoke = smoke.v 
                mainIni.config.lock = lock.v
                mainIni.config.key = key.v 
                mainIni.config.time = time.v
                mainIni.config.chasi = chasi.v
                mainIni.config.vrsms = vrsms.v 
                mainIni.config.dopsms = dopsms.v 
                mainIni.config.doppiar = doppiar.v 
                mainIni.config.narkotiki = narkotiki.v 
                mainIni.config.deagle = deagle.v 
                mainIni.config.mfour = mfour.v 
                mainIni.config.rifle = rifle.v 
                mainIni.config.minyt = minyt.v 
                mainIni.config.sbiv = sbiv.v 
                mainIni.config.repcar = repcar.v
                mainIni.config.fillcar = fillcar.v 
                mainIni.autologin.autologinBox = autologinBox.v
                mainIni.autologin.parolI = parolI.v 
                inicfg.save(mainIni, 'arz_as.ini')
                sampAddChatMessage(tagG .. ' {FFFFFF}Изменения успешно сохранены!', -1)
            end
        imgui.End()
        end

        if oscripte.v then
            imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(1.318, 0.273))
            imgui.Begin(u8'О скрипте', oscripte, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
                imgui.TextColoredRGB(' {d40103}Arizona Assistant {FFFFFF}- скрипт-помощник для серверов {a2284c}Аризона РП {FFFFFF}написанный на языке {a2284c}"Lua".\n {FFFFFF}Этот скрипт значительно облегчит игру на серверах {a2284c}Аризона РП\n {FFFFFF}Если у вас есть улучшения для скрипта, напишите в тему скрипта на сайте {3b3993}Blast Hack{FFFFFF}\nВерсия скрипта: '..thisScript().version..'.')
                if imgui.Button(u8'Создатель', imgui.ImVec2(533, 35)) then
                    sampAddChatMessage(tagG .. ' {FFFFFF}ARZ Mesa: Luqa_Scholz', -1)
                    sampAddChatMessage(tagG .. ' {FFFFFF}Youtube: https://www.youtube.com/c/frip1337', -1)
                    sampAddChatMessage(tagG .. ' {FFFFFF}VK: https://vk.com/tooked', -1)
                end
                if imgui.Button(u8'Перезагрузить скрипт', imgui.ImVec2(533,35)) then
                    thisScript():reload()
                end
                if imgui.Button(u8'Выключить скрипт', imgui.ImVec2(533, 35)) then
                    lua_thread.create(function ()
                        imgui.Process = false
                        crashhelper = true
                        wait(500)
                        SciptDie()
                    end)
                end
                if imgui.Button(u8'Скрипт на BlastHack', imgui.ImVec2(533, 35)) then
                    os.execute('explorer "https://www.blast.hk/threads/59990/"')
                end
                
                if imgui.Button(u8'Обновиться', imgui.ImVec2(533, 35)) then
                    update()
                end
            imgui.End()
        end

        if piarik.v then
            imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(1.63, 0.49))
            imgui.Begin(u8'АвтоПиар', piarik, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
                imgui.Text(u8'Активация /pr')
                imgui.SameLine()
                imgui.PushItemWidth(280)
                imgui.SliderInt(u8'Задержка', slider, 1500, 300000)
                imgui.PushItemWidth(200)
                imgui.InputText(u8'Реклама /vr', vrsms)
                imgui.Checkbox(u8'Доп. пиар', dopsms)
                imgui.SameLine()
                imgui.TextQuestion(u8'Включает доп. пиар')
                imgui.PushItemWidth(200)
                imgui.InputText(u8'Доп. пиар.', doppiar)
                if imgui.Button(u8'Сохранить', imgui.ImVec2(430, 25)) then
                    mainIni.config.vrsms = vrsms.v 
                    mainIni.config.dopsms = dopsms.v 
                    mainIni.config.doppiar = doppiar.v 
                    inicfg.save(mainIni, 'arz_as.ini')
                    sampAddChatMessage(tagG .. ' {FFFFFF}Изменения успешно сохранены!', -1)
                end
            imgui.End()
        end

        if chasiki.v then
            imgui.SetNextWindowSize(imgui.ImVec2(285, 80), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(2.544, 0.96))
            imgui.Begin(u8'Часы', chasiki, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
                imgui.Checkbox(u8'Часы', time)
                imgui.SameLine()
                imgui.TextQuestion(u8'Отыграет часы нажатием на сочитание клавиш TI (как чит).')
                imgui.SameLine()
                imgui.InputText('', chasi)
                if imgui.Button(u8'Сохранить', imgui.ImVec2(263, 25)) then
                    mainIni.config.time = time.v
                    mainIni.config.chasi = chasi.v
                    inicfg.save(mainIni, 'arz_as.ini')
                    sampAddChatMessage(tagG .. ' {FFFFFF}Изменения успешно сохранены!', -1)
                end
            imgui.End()
        end

        if autologin.v then
            imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(5.992, 0.74))
            imgui.Begin(u8'АвтоЛогин', autologin, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
                imgui.Checkbox(u8'АвтоЛогин', autologinBox)
                imgui.SameLine()
                imgui.TextQuestion(u8'Автоматически будет вводить ваш пароль при заходе на сервер.')
                imgui.InputText('', parolI)
                if imgui.Button(u8'Сохранить', imgui.ImVec2(105, 20)) then
                    mainIni.autologin.autologinBox = autologinBox.v
                    mainIni.autologin.parolI = parolI.v 
                    inicfg.save(mainIni, 'arz_as.ini')
                    sampAddChatMessage(tagG .. ' {FFFFFF}Изменения успешно сохранены!', -1)
                end
            imgui.End()
        end
    end
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end

function imgui.TextQuestion(text)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function hook.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
    if skip.v then
        if dialogId == 1333 then
            sampSendDialogResponse(id, 1, 0, nil)
            return false
        end
    end
    if skipDM.v then
        if dialogId == 0 then
            sampSendDialogResponse(id, 0, _, nil)
            return false
        end
    end

    if phone.v then
        if dialogId == 1000 then
            sampSendDialogResponse(1000,1,0,"")
            return false
         end
     end

     if lock.v then
        if dialogId == 162 then
            sampSendDialogResponse(162, 1, 0, '')
            return false
        end
    end

    if lock.v then
        if dialogId == 163 then
            sampSendDialogResponse(163, 1, 0, '')
            return false
        end
    end

    if autologinBox.v then
        if dialogId == 2 then
            sampSendDialogResponse(2, 1, -1, mainIni.autologin.parolI)
            return false
        end
    end
end

function hook.onServerMessage(color, text)
    if flud.v then
		if text:find("~~~~~~~~~~~~~~~~~~~~~~~~~~") and not text:find('говорит') then
			return false
		end
		if text:find("- Основные команды") and not text:find('говорит') then
			return false
		end
		if text:find("- Пригласи друга") and not text:find('говорит') then
			return false
		end
		if text:find("- Донат и получение") and not text:find('говорит') then
			return false
		end
		if text:find("выехал") and not text:find('говорит') then
			return false
		end
		if text:find("убив его") and not text:find('говорит') then
			return false
		end
		if text:find("начал работу") and not text:find('говорит') then
			return false
		end
		if text:find("Убив его") and not text:find('говорит') then
			return false
		end
		if text:find("между использованием") and not text:find('говорит') then
			return false
		end
		if text:find("обновлениях сервера") and not text:find('говорит') then
			return false
		end
		if text:find("Пополнение игрового счета") and not text:find('говорит') then
			return false
		end
		if text:find("Наш сайт") and not text:find('говорит') then
			return false
		end
	end
end

function hook.onDisplayGameText(style, time, text)
    if minyt.v then
        if style == 3 and time == 1000 and text:find("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.") then
            local c, _ = math.modf(tonumber(text:match("Jailed (%d+)")) / 60)
            return {style, time, string.format("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.", text:match("Jailed (%d+)"), c)}
          end
    end
end

function piar()
    lua_thread.create(function()
		if act and dopsms.v then
		  sampSendChat(u8:decode(vrsms.v))
		  wait(1200)
	      sampSendChat(u8:decode(doppiar.v))
          wait(slider.v)
		  return true
		end
		if act then
		  sampSendChat(u8:decode(vrsms.v))
		  wait(slider.v)
		  return true
		end
	end)
end



function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()