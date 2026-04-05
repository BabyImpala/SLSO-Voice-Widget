Scriptname SLSO_Widget4Update Extends ReferenceAlias

SLSO_WidgetCoreScript4 Property Widget Auto

SexLabFramework SexLab
sslThreadModel Thread

String File
String widgetid
String ActorName
String EnjoymentValue
Float LastTimeFlash
Int BaseColor = 0xFFFFFF	 	; white
Int Gender = 0
Bool Display_widget = true
Bool WidgetVisible = false

;----------------------------------------------------------------------------
;Widget Setup
;----------------------------------------------------------------------------

Event OnInit()
	HideWidget()
	File = "/SLSO/Config.json"
	widgetid = "widget" + self.GetID()
EndEvent

Event Start_widget(Int Widget_Id, Int Thread_Id)
	if Widget_Id == self.GetID()
		UnregisterForModEvent("SLSO_Start_widget")

		SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
		Thread = SexLab.GetThread(Thread_Id) as sslThreadModel
		if Thread.HasPlayer()
			StartWidget()
		else
			StopWidget()
		endif
		self.RegisterForModEvent("SLSO_Change_Partner", "Change_Partner")
	endif
EndEvent

Event Change_Partner(Form ActorRef)
	;SexLab.Log(GetActorRef().GetDisplayName() + " changed widget recieved:" + ActorRef as Actor + " ref:" + self.GetActorRef())
	if ActorRef as Actor == self.GetActorRef()
		Widget.LabelTextColor = JsonUtil.GetFloatValue(File, "widget_selectedactorcolor", 16768768) as int
		;SexLab.Log(" changed widget BorderColor - yellow:" + Widget.BorderColor)
	else
		Widget.LabelTextColor = JsonUtil.GetFloatValue(File, "widget_labelcolor", 16777215) as int
		;SexLab.Log(" changed widget BorderColor - black:"+ Widget.BorderColor)
	endif
EndEvent

Event Stop_widget(Int Widget_Id)
	if Widget_Id == self.GetID()
		StopWidget()
	endif
EndEvent

Function StartWidget()
	if ((JsonUtil.GetIntValue(File, "widget_player_only") == 1 && self.GetActorRef() == Game.Getplayer()) || JsonUtil.GetIntValue(File, "widget_player_only") != 1)
		Display_widget = true
	else
		Display_widget = false
		StopWidget()
		return
	endif
	if (JsonUtil.StringListGet(File, widgetid, 0) != "on")
		return
	endif
	UpdateWidgetPosition()
EndFunction

Function StopWidget()
	UnRegisterForUpdate()
	UnregisterForAllModEvents()
	HideWidget()
	(self as ReferenceAlias).Clear()
EndFunction

Function ShowWidget()
	Widget.Alpha = 100.0
	WidgetVisible = true
	If ((Display_widget == true) && (self.GetActorRef() == Game.Getplayer()))
		; abMovement must be enabled via EPC else the widget won't show (DPC won't work)
		; rest stays same as SexLabUtil.MOVEMENT_LOCK since ShowWidget() is for STATE_ANIMATING only
		Game.EnablePlayerControls(abMovement=true, abFighting=false, abCamSwitch=false, abLooking=true,\
			abSneaking=false, abMenu=true, abActivate=false, abJournalTabs=true, aiDisablePovType=0)
	EndIf
EndFunction

Function HideWidget()
	Widget.Alpha = 0.0
	WidgetVisible = false
EndFunction

Function UpdateWidgetPosition()
	Actor ActorRef = self.GetActorRef() 
	If ActorRef != none
		;female/futa
		If (Sexlab.GetSex(ActorRef) == 1 || Sexlab.GetSex(ActorRef) == 2)
			BaseColor = JsonUtil.StringListGet(File, "widgetcolors", 7) as int
			Gender = 1
		;male
		Else
			BaseColor = JsonUtil.StringListGet(File, "widgetcolors", 6) as int
			Gender = 0
		EndIf
	Else
		BaseColor = 0xFFFFFF
	EndIf
	Widget.BorderColor = JsonUtil.GetFloatValue(File, "widget_bordercolor", 0) as int
	Widget.BorderWidth = 0
	;Widget.Width = JsonUtil.GetFloatValue(File, "widget_width")
	;Widget.Height = JsonUtil.GetFloatValue(File, "widget_height")
	Widget.X = JsonUtil.StringListGet(File, widgetid, 1) as Float
	Widget.Y = JsonUtil.StringListGet(File, widgetid, 2) as Float
	Widget.MeterFillMode = JsonUtil.StringListGet(File, widgetid, 3)
	Widget.SetMeterPercent(0.0)
	Widget.BorderAlpha = JsonUtil.GetFloatValue(File, "widget_borderalpha")
	Widget.BackgroundAlpha = JsonUtil.GetFloatValue(File, "widget_backgroundalpha")
	Widget.MeterAlpha = JsonUtil.GetFloatValue(File, "widget_meteralpha")
	Widget.MeterScale = JsonUtil.GetFloatValue(File, "widget_meterscale")
	Widget.LabelTextSize = JsonUtil.GetFloatValue(File, "widget_labeltextsize")
	Widget.ValueTextSize = JsonUtil.GetFloatValue(File, "widget_valuetextsize")
	Widget.LabelTextColor = JsonUtil.GetFloatValue(File, "widget_labelcolor", 16777215) as int
	ActorName = self.GetActorRef().GetDisplayName()
	if JsonUtil.GetIntValue(File, "widget_show_enjoymentmodifier") == 1
		EnjoymentValue = "..."
	else
		EnjoymentValue = ""
	endif
	Widget.SetTexts(ActorName, EnjoymentValue)
	LastTimeFlash = game.GetRealHoursPassed()
	RegisterForSingleUpdate(0.5)
EndFunction

;----------------------------------------------------------------------------
;Widget update Loop
;----------------------------------------------------------------------------

Event OnUpdate()
	Actor ActorRef = self.GetActorRef()
	If ((ActorRef == none) || (Thread.ActorAlias(ActorRef).GetActorRef() == none) || (Thread.ActorAlias(ActorRef).GetState() == "Empty"))
		StopWidget()
		return
	EndIf
	If ((JsonUtil.GetIntValue(File, "widget_enabled") != 1) || (Thread.ActorAlias(ActorRef).GetState() == "Paused"))
		If WidgetVisible
			HideWidget()
		EndIf
	ElseIf (Thread.ActorAlias(ActorRef).GetState() == "Animating")
		string DetectedInteractions = "(" + Thread.GetCurrentInteractionString(ActorRef) + ")"
		If DetectedInteractions == "()"
			DetectedInteractions = "..."
		EndIf
		If !WidgetVisible
			ShowWidget()
		EndIf
		UpdateWidget(Thread.GetEnjoyment(ActorRef) as float, DetectedInteractions)
	EndIf
	RegisterForSingleUpdate(0.5)
EndEvent

Function UpdateWidget(Float Enjoyment, string DetectedInteractions)
	if EnjoymentValue != ""
		;EnjoymentValue = "E:" + StringUtil.Substring(Thread.GetEnjoyment(self.GetActorRef()), 0, 5) + "%"
		EnjoymentValue = DetectedInteractions
	endif
	Widget.SetTexts(ActorName, EnjoymentValue)
	Enjoyment /= 100
	If (Enjoyment >= 0.0 && Enjoyment <= 1.0)
		If Enjoyment >= 0.75
			Widget.SetMeterColors(BaseColor, JsonUtil.StringListGet(File, "widgetcolors", 1) as int)
		ElseIf Enjoyment >= 0.50
			Widget.SetMeterColors(BaseColor, JsonUtil.StringListGet(File, "widgetcolors", 2) as int)
		ElseIf Enjoyment >= 0.25
			Widget.SetMeterColors(BaseColor, JsonUtil.StringListGet(File, "widgetcolors", 3) as int)
		Else
			Widget.SetMeterColors(BaseColor, BaseColor)
		EndIf
		Widget.SetMeterPercent(Enjoyment*100)
	EndIf
	If Enjoyment < 0.0
		Widget.SetMeterColors(BaseColor, JsonUtil.StringListGet(File, "widgetcolors", 5) as int)
		Widget.SetMeterPercent(Enjoyment * 100 * -1)
		If JsonUtil.GetIntValue(File, "widget_show_painedgingtext") == 1
			Widget.SetTexts(ActorName, "Pain: " + EnjoymentValue)
		EndIf
	EndIf
	If Enjoyment > 1.0
		Widget.SetMeterColors(BaseColor, JsonUtil.StringListGet(File, "widgetcolors", 4) as int)
		Widget.SetMeterPercent((Enjoyment - 1) *100, true)
		If JsonUtil.GetIntValue(File, "widget_show_painedgingtext") == 1
			Widget.SetTexts(ActorName, "Edging: " + EnjoymentValue)
		EndIf
	EndIf
	If Enjoyment >= 0.90
		GetCurrentHourOfDay()		;flash
	EndIf
EndFunction

Function GetCurrentHourOfDay()
	float Time = game.GetRealHoursPassed() 		; days spend in game
;	Time *= 24 									; hours spend in game
;	Time *= 60 									; minutes spend in game
;	Time *= 60 									; seconds spend in game
;	Time += x 									; x seconds delay so Flash() can play

	;Debug.Notification(Math.Floor(Time*24*60*60) + " | " + Math.Floor(LastTimeFlash*24*60*60 + 10))
	if Math.Floor(Time*86400) >= Math.Floor(LastTimeFlash*86410)
		Widget.StartMeterFlash()
		LastTimeFlash = Time
	endif
EndFunction
