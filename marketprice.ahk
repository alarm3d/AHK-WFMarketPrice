#NoEnv
#SingleInstance Force
#include <ClearItem>
#include <Vis2>
#Include, <TT>
#include <JSON>
SetBatchLines -1
ListLines Off


#Persistent
Menu, Tray, Icon, ducat.ico
Menu, Tray, NoStandard
Menu, Tray, Add, Item Name, showitemname
Menu, Tray, Add, Vaulted, showvaulted
Menu, Tray, Add, Previous Hour, showprevioushour
Menu, Tray, Add, Previous Day, showpreviousday
Menu, Tray, Add, Ducats Per Plat, showducatsperplat
Menu, Tray, Add, Ducats Per Plat WA, showducatsperplatwa
Menu, Tray, Add, Average Plat, showaverageplat
Menu, Tray, Add, Average Plat WA, showaverageplatwa
Menu, Tray, Add, Ducat Value, showducats
Menu, Tray, Add
Menu, Tray, Add, Task Time, tasktime
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add, Exit, Exit
Menu, Tray, Tip, Market price
Menu, Tray, Click, 1

IniRead, showitemname, config.ini, TrayMenu, showitemname
IniRead, showvaulted, config.ini, TrayMenu, showvaulted
IniRead, showprevioushour, config.ini, TrayMenu, showprevioushour
IniRead, showpreviousday, config.ini, TrayMenu, showpreviousday
IniRead, showducatsperplat, config.ini, TrayMenu, showducatsperplat
IniRead, showducatsperplatwa, config.ini, TrayMenu, showducatsperplatwa
IniRead, showaverageplat, config.ini, TrayMenu, showaverageplat
IniRead, showaverageplatwa, config.ini, TrayMenu, showaverageplatwa
IniRead, showducats, config.ini, TrayMenu, showducats
IniRead, tasktime, config.ini, TrayMenu, tasktime
IniRead, vaulted, config.ini, Vaulted
vaulted := StrSplit(vaulted, "`n")

if(showitemname)
Menu,Tray,Togglecheck, Item Name
if(showvaulted)
Menu,Tray,Togglecheck, Vaulted 
if(showprevioushour)
Menu,Tray,Togglecheck, Previous Hour
if(showpreviousday)
Menu,Tray,Togglecheck, Previous Day
if(showducatsperplat)
Menu,Tray,Togglecheck, Ducats Per Plat
if(showducatsperplatwa)
Menu,Tray,Togglecheck, Ducats Per Plat WA
if(showaverageplat)
Menu,Tray,Togglecheck, Average Plat
if(showaverageplatwa)
Menu,Tray,Togglecheck, Average Plat WA
if(showducats)
Menu,Tray,Togglecheck, Ducat Value
if(tasktime)
Menu,Tray,Togglecheck, Task Time
lng := "ru"
ComObjError(0)
apirequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
apirequest.Open("GET","https://api.warframe.market/v1/items")
apirequest.SetRequestHeader("Language", "ru")
apirequest.SetRequestHeader("Platform", "pc")
apirequest.Send()
if(apirequest.status = 200)
itemsjson := JSON.Load(apirequest.ResponseText)
else {
	MsgBox % "Error: " apirequest.status "`nScript will now exit"
	ExitApp
}

apirequest.Open("GET","https://api.warframe.market/v1/tools/ducats")
apirequest.SetRequestHeader("Language", "ru")
apirequest.SetRequestHeader("Platform", "pc")
apirequest.Send()
if(apirequest.status == 200)
ducatsjson := JSON.Load(apirequest.ResponseText)
else {
	MsgBox % "Error: " apirequest.status "`nScript will now exit"
	ExitApp
}

theme := 1
~+z::
if(tasktime) {
	DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
}
msg := ""
msg2 := ""
themecheck := 1
active := 0
;ToolTip

Loop {
	WinGetPos, focusX, focusY, ClientWidth, ClientHeight, A
	ImageSearch, FoundX, FoundY, focusX, focusY, focusX+ClientWidth, focusY+ClientHeight, img/%theme%.png
	if (ErrorLevel == 0) {
		PixelGetColor, color, FoundX, FoundY
		BoundX := FoundX+140
		loop {
			if(BoundX < (focusX+ClientWidth))
			{
				PixelGetColor, colorbound, BoundX, FoundY
				if(color != colorbound) {
					xoffset := BoundX - FoundX - 5
					break
				}
				else {
					BoundX += 5
				}
			}
			else {
				break
			}
		}
		PixelGetColor, color2, FoundX+(xoffset*0.5), FoundY+Ceil(xoffset/9)
		if(color == color2) {
			item := StrReplace(OCR([FoundX, FoundY, xoffset ,Ceil(xoffset/6.33)]), "`r`n", " ")
		}
		else {
			item := OCR([FoundX, FoundY, xoffset, Ceil(xoffset/9.33)])
		}
		
		item := ClearItem(item)
		SearchLoop:
		loop % itemsjson.payload.items.ru.length() {
			itemtemp := itemsjson.payload.items.ru[A_Index].item_name
			StringUpper itemtemp, itemtemp, U
			StringReplace, itemtemp, itemtemp, Й, И, All
			StringReplace, itemtemp, itemtemp, Ё, Е, All
			if(InStr(itemtemp,item) OR InStr(item,itemtemp) AND estimation) {
				itemid := itemsjson.payload.items.ru[A_Index].id
				if(showitemname)
				msg2 := msg2 itemsjson.payload.items.ru[A_Index].item_name
				if(showpreviousday)
				{
					msg := msg "`n"
					loop % ducatsjson.payload.previous_day.length() {
						if InStr(ducatsjson.payload.previous_day[A_Index].item,itemid) {
							if(showducats)
							msg := msg "Дукат: " ducatsjson.payload.previous_day[A_Index].ducats "`n"
							if(showducatsperplat)
							msg := msg "Дукат в платине: " ducatsjson.payload.previous_day[A_Index].ducats_per_platinum "`n"
							if(showducatsperplatwa)
							msg := msg "Дукат в платине  в среднем: " ducatsjson.payload.previous_day[A_Index].ducats_per_platinum_wa "`n"
							if(showaverageplat)
							msg := msg "Платины: " ducatsjson.payload.previous_day[A_Index].median "`n"
							if(showaverageplatwa)
							msg := msg "Платины  в среднем: " ducatsjson.payload.previous_day[A_Index].wa_price "`n"
							break
						}
					}
				}
				if(showprevioushour)
				{
					msg := msg "`n"
					loop % ducatsjson.payload.previous_hour.length() {
						if InStr(ducatsjson.payload.previous_hour[A_Index].item,itemid) {
							if(showducats)
							msg := msg "Дукат: " ducatsjson.payload.previous_hour[A_Index].ducats "`n"
							if(showducatsperplat)
							msg := msg "Дукат в платине: " ducatsjson.payload.previous_hour[A_Index].ducats_per_platinum "`n"
							if(showducatsperplatwa)
							msg := msg "Дукат в платин в среднем: " ducatsjson.payload.previous_hour[A_Index].ducats_per_platinum_wa "`n"
							if(showaverageplat)
							msg := msg "Платины: " ducatsjson.payload.previous_hour[A_Index].median "`n"
							if(showaverageplatwa)
							msg := msg "Платины в среднем: " ducatsjson.payload.previous_hour[A_Index].wa_price "`n"
							break
						}
					}
				}
				break
			}
			else if(A_Index == itemsjson.payload.items.ru.length()) {
				if(!estimation) { 
					estimation := 1
					GoTo, SearchLoop
				}
				else {
					break
				}
			}
		}
		if(showvaulted) {
			Loop % vaulted.length()
			{
				if InStr(item, vaulted[A_Index]) {
					vaultext := "Vaulted: Yes`n"
					break
				}
				else { 
					vaultext := "Vaulted: No`n"
				}
			}
			msg := msg vaultext
		}
		break
	}
	else if (ErrorLevel == 1) {
		if(themecheck) {
			themecheck := 0
			theme := 1
		}
		else if(theme != 14) {
			theme++
		}
		else {
			msg := "Текст не найден`n"
			break
		}
	}
	else if (ErrorLevel == 2) {
		msg := "Could not start the search`n"
		break
	}
}
if(tasktime) {
	DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
	DllCall("QueryPerformanceFrequency", "Int64*", Frequency)
	msg := msg "Время обработки " Ceil((CounterAfter - CounterBefore)*1000/Frequency) " ms"
}

TT:=TT("CloseButton Balloon OnClose=ExitApp",, msg2)
TT.Font("s12")
MouseGetPos, xpos, ypos
TT.Show(msg)
active := 1
SetTimer End, 15000
return

End:
TT.Remove()
active := 0
SetTimer End, Off
return

if(active)
~LButton::
TT.Remove()
active := 0
return

showitemname:
Menu,Tray,Togglecheck, Item Name
showitemname := !showitemname
IniWrite, %showitemname%, config.ini, TrayMenu, showitemname
return

showducats:
Menu,Tray,Togglecheck, Ducat Value
showducats := !showducats
IniWrite, %showducats%, config.ini, TrayMenu, showducats
return

showvaulted:
Menu,Tray,Togglecheck, Vaulted
showvaulted := !showvaulted
IniWrite, %showvaulted%, config.ini, TrayMenu, showvaulted
return

showprevioushour:
Menu,Tray,Togglecheck, Previous Hour
showprevioushour := !showprevioushour
IniWrite, %showprevioushour%, config.ini, TrayMenu, showprevioushour
return

showpreviousday:
Menu,Tray,Togglecheck, Previous Day
showpreviousday := !showpreviousday
IniWrite, %showpreviousday%, config.ini, TrayMenu, showpreviousday
return

showducatsperplat:
Menu,Tray,Togglecheck, Ducats Per Plat
showducatsperplat := !showducatsperplat
IniWrite, %showducatsperplat%, config.ini, TrayMenu, showducatsperplat
return

showducatsperplatwa:
Menu,Tray,Togglecheck, Ducats Per Plat WA
showducatsperplatwa := !showducatsperplatwa
IniWrite, %showducatsperplatwa%, config.ini, TrayMenu, showducatsperplatwa
return

showaverageplat:
Menu,Tray,Togglecheck, Average Plat
showaverageplat := !showaverageplat
IniWrite, %showaverageplat%, config.ini, TrayMenu, showaverageplat
return

showaverageplatwa:
Menu,Tray,Togglecheck, Average Plat WA
showaverageplatwa := !showaverageplatwa
IniWrite, %showaverageplatwa%, config.ini, TrayMenu, showaverageplatwa
return

tasktime:
Menu,Tray,Togglecheck, Task Time
tasktime := !tasktime
IniWrite, %tasktime%, config.ini, TrayMenu, tasktime
return

Reload:
Reload
return

Exit:
ExitApp
return
