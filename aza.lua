script_name('Arizona_Assistant')
script_author('Phealz')
script_version('1.0 beta')
script_description('Помощник для Аризоны. Информация по обновлению - /obcheck.')

require "lib.moonloader"

local dlstatus = require('moonloader').download_status
local hook = require 'lib.samp.events'
local tag = '[ARZ Assistant]' -- just
local tagG = '{00C22A}[ARZ Assistant]:' -- green
local keys = require 'vkeys'
local themes = import '/resource/themes/imgui_themes.lua'
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local slider = imgui.ImInt(1)
local encoding = require'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.05 beta"

local update_url = "https://raw.githubusercontent.com/Phealz/scripts/master/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "https://github.com/Phealz/scripts/blob/master/ARZ_AS.luac?raw=true" -- тут свою ссылку
local script_path = thisScript().path

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
sbiv=false
}
}, 'arz_as')

local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)
local skip = imgui.ImBool(mainIni.config.skip)
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

local status = inicfg.load(mainIni, 'arz_as.ini')
if not doesFileExist('moonloader/config/arz_as.ini') then inicfg.save(mainIni, 'arz_as.ini') end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        nick = sampGetPlayerNickname(id)
        
        imgui.Process = false

        downloadUrlToFile(update_url, update_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                updateIni = inicfg.load(nil, update_path)
                if tonumber(updateIni.version.vers) > script_vers then
                    sampAddChatMessage(tagG .. " {FFFFFF}Найдено обновление на версию: " .. updateIni.version.vers_text, -1)
                    sampAddChatMessage(tagG .. ' {FFFFFF}Начинаю обновление...', -1)
                    update_state = true
                end
                os.remove(update_path)
            end
        end)
       
        sampAddChatMessage(tagG .. " {890303}by Phealz {00C22A}loaded.{FFFFFF} Version: {890303}v.1.05 beta ", -1)
        sampAddChatMessage(tagG .. ' {FFFFFF}Информация по обновлению: /obinfo', -1)

        sampRegisterChatCommand('obinfo', obinfo)

        sampRegisterChatCommand('arza', cmd_imgui)
    
        sampRegisterChatCommand('pr', function()
        act = not act; sampAddChatMessage(act and '{00C22A}Реклама включена!' or '{00C22A}Реклама выключена!', -1)
	    if act then
         piar()
        end
	    end)
        
        

    while true do
        wait(0)
    
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(tagG .. " {FFFFFF}Обновление завершено успешно.", -1)
                    thisScript():reload()
                end
            end)
            break
        end
        
        if main_window_state.v == false then
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
                sampSendChat('/lock')
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
            sampSendChat('/usedrugs 5')
        end

        if narkotiki.v and isKeyJustPressed(VK_MENU) and isKeyJustPressed(0x32) then
            sampSendChat('/usedrugs 10')
        end

        if narkotiki.v and isKeyJustPressed(VK_MENU) and isKeyJustPressed(0x33) then
            sampSendChat('/usedrugs 15')
        end

        if sbiv.v and not isCharInAnyCar(PLAYER_PED) then
            if testCheat('Q') then
                sampSendChat('/anim 1')
            end
        end
    end
end

function cmd_imgui(arg)
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end
function obinfo(arg)
    sampAddChatMessage(tagG .. ' {FFFFFF}Версия скрипта: .' .. updateIni.version.vers_text, -1)
    sampAddChatMessage(tagG .. ' {FFFFFF}Убрал косяки (18.07.20).', -1)
end

function imgui.OnDrawFrame()
    if main_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(765, 370), imgui.Cond.FirstUseEver)
		if not window_pos then
			ScreenX, ScreenY = getScreenResolution()ScreenX, ScreenY = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(0.5, 0.5))
		end
    imgui.Begin('Arizona Assistant | By Phealz', main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)
            imgui.Text(u8'  VK: @tooked. Помог скрипт karacb, @mq_228_suqa1488.')
            imgui.BeginChild("##ya_lox", imgui.ImVec2(300, 105), true, imgui.WindowFlags.NoScrollbar)
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
            imgui.EndChild()
            imgui.BeginChild('##y_menya_maver_sletel(', imgui.ImVec2(300, 60), true, imgui.WindowFlags.NoScrollbar)
                imgui.Checkbox(u8'Маска', mask)
                imgui.SameLine()
                imgui.TextQuestion(u8'При сочетании клавиш MSK (как чит), оденет маску.')
                imgui.Checkbox(u8'Сигарета', smoke)
                imgui.SameLine()
                imgui.TextQuestion(u8'При сочетании клавиш SIG (как чит), достанет сигарету из инвентаря.')
            imgui.EndChild()
            imgui.BeginChild('##hochu_elegiu(', imgui.ImVec2(300, 80), true, imgui.WindowFlags.NoScrollbar)
                imgui.Checkbox(u8'Закрыть авто', lock)
                imgui.SameLine()
                imgui.TextQuestion(u8'Закроет авто на клавишу L.')
                imgui.Checkbox(u8'Вынуть ключ из замка зажигания', key)
                imgui.SameLine()
                imgui.TextQuestion(u8'Вынет ключ из замка зажигания на клавишу K.')
                imgui.Checkbox(u8'Часы', time)
                imgui.SameLine()
                imgui.TextQuestion(u8'Отыграет часы нажатием на сочитание клавиш TI (как чит).')
                imgui.SameLine()
                imgui.InputText('', chasi)
            imgui.EndChild()
            imgui.SetCursorPos(imgui.ImVec2(310, 46))
            imgui.BeginChild('##eshe_ne_lupil(', imgui.ImVec2(450, 105), true, imgui.WindowFlags.NoScrollbar)
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
            imgui.EndChild()
            imgui.SetCursorPos(imgui.ImVec2(8, 303))
            if imgui.Button(u8'Сохранить настройки', imgui.ImVec2(145, 64)) then
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
                inicfg.save(mainIni, 'arz_as.ini')
            end
            imgui.SetCursorPos(imgui.ImVec2(158, 303))
            if imgui.Button(u8'Перезагрузить скрипт', imgui.ImVec2(150,64)) then
                thisScript():reload()
            end
            imgui.SetCursorPos(imgui.ImVec2(310, 303))
            if imgui.Button(u8'Создатель', imgui.ImVec2(450, 64)) then
                sampAddChatMessage(tagG .. ' {FFFFFF}ARZ Mesa: Luqa_Scholz', -1)
                sampAddChatMessage(tagG .. ' {FFFFFF}Youtube: https://www.youtube.com/c/frip1337', -1)
                sampAddChatMessage(tagG .. ' {FFFFFF}VK: https://vk.com/tooked', -1)
            end
            imgui.SetCursorPos(imgui.ImVec2(310, 155))
            imgui.BeginChild('##ya_kupil_elegu)', imgui.ImVec2(450, 145), true, imgui.WindowFlags.NoScrollbar)
                imgui.SetCursorPos(imgui.ImVec2(8, 10))
                imgui.Checkbox(u8'Наркотики', narkotiki)
                imgui.SameLine()
                imgui.TextQuestion(u8'ALT + 1 = 5 наркотиков, ALT + 2 = 10 наркотиков, ALT + 3 = 15 наркотиков.')
                imgui.Checkbox(u8'Минуты в деморгане', minyt)
                imgui.SameLine()
                imgui.TextQuestion(u8'Переводит секунды в минуты в деморгане')
                --imgui.Checkbox(u8'Автоеда в доме', eda)
                --imgui.SameLine()
                --imgui.TextQuestion(u8'Автоматически кушает в доме')
                imgui.SetCursorPos(imgui.ImVec2(137, 10))
                imgui.Checkbox(u8'Сбив', sbiv)
                imgui.SameLine()
                imgui.TextQuestion(u8'При нажатии на клавишу Y, скрипт активирует /anim 1, дальше просто нажать энтер.')
            imgui.EndChild()
    imgui.End()
    end
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