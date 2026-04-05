scriptname SLSO_MCM extends SKI_ConfigBase
{MCM Menu script}

SexLabFramework property SexLab auto
Spell property SLSO_SpellAnimSync auto
Spell property SLSO_SpellVoice auto
Spell property SLSO_SpellGame auto

String File
String EnjConfigFile

;=============================================================
;INIT
;=============================================================

event OnConfigInit()
    ModName = "SLSO Voice & Widget"
	self.RefreshStrings()
endEvent

Function RefreshStrings()
	Pages = new string[3]
	Pages[0] = "$page1"
	Pages[1] = "$page2"
	Pages[2] = "$page3"
	
	File = "/SLSO/Config.json"
EndFunction

event OnPageReset(string page)
	if page == ""
		self.RefreshStrings()
	endif

	if page == "$page1"
		self.Page_Sound_System()
	elseif page == "$page2"
		self.Page_Widget()
	elseif page == "$page3"
		self.Page_Widget_Colors()
	endif
endEvent

;=============================================================
;PAGES Layout
;=============================================================

function Page_Widget()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddKeyMapOptionST("hotkey_widget", "$hotkey_widget", JsonUtil.GetIntValue(File, "hotkey_widget"))
		AddToggleOptionST("widget_player_only", "$widget_player_only", JsonUtil.GetIntValue(File, "widget_player_only"))
		AddToggleOptionST("widget_show_enjoymentmodifier", "$widget_show_enjoymentmodifier", JsonUtil.GetIntValue(File, "widget_show_enjoymentmodifier"))
		AddToggleOptionST("widget_show_painedgingtext", "$widget_show_painedgingtext", JsonUtil.GetIntValue(File, "widget_show_painedgingtext"))
		AddSliderOptionST("LabelTextSize", "$LabelTextSize", JsonUtil.GetFloatValue(File, "widget_labeltextsize") as Int)
		AddSliderOptionST("ValueTextSize", "$ValueTextSize", JsonUtil.GetFloatValue(File, "widget_valuetextsize") as Int)
		
		AddHeaderOption("$Widget_1")
			AddTextOptionST("widget1_0", "$Enabled", JsonUtil.StringListGet(File, "widget1", 0))
			AddSliderOptionST("widget1_1", "$Position_X", JsonUtil.StringListGet(File, "widget1", 1) as Int)
			AddSliderOptionST("widget1_2", "$Position_Y", JsonUtil.StringListGet(File, "widget1", 2) as Int)
			AddTextOptionST("widget1_3", "$FillDirection", JsonUtil.StringListGet(File, "widget1", 3))
			
		AddHeaderOption("$Widget_2")
			AddTextOptionST("widget2_0", "$Enabled", JsonUtil.StringListGet(File, "widget2", 0))
			AddSliderOptionST("widget2_1", "$Position_X", JsonUtil.StringListGet(File, "widget2", 1) as Int)
			AddSliderOptionST("widget2_2", "$Position_Y", JsonUtil.StringListGet(File, "widget2", 2) as Int)
			AddTextOptionST("widget2_3", "$FillDirection", JsonUtil.StringListGet(File, "widget2",3))

	SetCursorPosition(1)
		
		AddEmptyOption()
		AddHeaderOption("$Widget_3")
			AddTextOptionST("widget3_0", "$Enabled", JsonUtil.StringListGet(File, "widget3", 0))
			AddSliderOptionST("widget3_1", "$Position_X", JsonUtil.StringListGet(File, "widget3", 1) as Int)
			AddSliderOptionST("widget3_2", "$Position_Y", JsonUtil.StringListGet(File, "widget3", 2) as Int)
			AddTextOptionST("widget3_3", "$FillDirection", JsonUtil.StringListGet(File, "widget1", 3))
			
		AddHeaderOption("$Widget_4")
			AddTextOptionST("widget4_0", "$Enabled", JsonUtil.StringListGet(File, "widget4", 0))
			AddSliderOptionST("widget4_1", "$Position_X", JsonUtil.StringListGet(File, "widget4", 1) as Int)
			AddSliderOptionST("widget4_2", "$Position_Y", JsonUtil.StringListGet(File, "widget4", 2) as Int)
			AddTextOptionST("widget4_3", "$FillDirection", JsonUtil.StringListGet(File, "widget4", 3))
			
		AddHeaderOption("$Widget_5")
			AddTextOptionST("widget5_0", "$Enabled", JsonUtil.StringListGet(File, "widget5", 0))
			AddSliderOptionST("widget5_1", "$Position_X", JsonUtil.StringListGet(File, "widget5", 1) as Int)
			AddSliderOptionST("widget5_2", "$Position_Y", JsonUtil.StringListGet(File, "widget5", 2) as Int)
			AddTextOptionST("widget5_3", "$FillDirection", JsonUtil.StringListGet(File, "widget5", 3))
endfunction	

function Page_Widget_Colors()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$Enjoyment_Colours_Header")
			AddColorOptionST("widgetcolors_0", "$Flash", JsonUtil.StringListGet(File, "widgetcolors", 0) as int)
			AddColorOptionST("widgetcolors_1", "$High", JsonUtil.StringListGet(File, "widgetcolors", 1) as int)
			AddColorOptionST("widgetcolors_2", "$Moderate", JsonUtil.StringListGet(File, "widgetcolors", 2) as int)
			AddColorOptionST("widgetcolors_3", "$Low", JsonUtil.StringListGet(File, "widgetcolors", 3) as int)
			AddColorOptionST("widgetcolors_4", "$Edging", JsonUtil.StringListGet(File, "widgetcolors", 4) as int)
			AddColorOptionST("widgetcolors_5", "$Pain", JsonUtil.StringListGet(File, "widgetcolors", 5) as int)
			AddColorOptionST("widgetcolors_6", "$Base_Male", JsonUtil.StringListGet(File, "widgetcolors", 6) as int)
			AddColorOptionST("widgetcolors_7", "$Base_Female", JsonUtil.StringListGet(File, "widgetcolors", 7) as int)

	SetCursorPosition(1)
		AddHeaderOption("$Widget_Settings_Header")
			AddColorOptionST("LabelColor", "$LabelColor", JsonUtil.GetFloatValue(File, "widget_labelcolor") as int)
			AddColorOptionST("SelectedActorColor", "$SelectedActorColor", JsonUtil.GetFloatValue(File, "widget_selectedactorcolor") as int)
			AddSliderOptionST("BorderAlpha", "$BorderAlpha", JsonUtil.GetFloatValue(File, "widget_borderalpha") as Int)
			AddSliderOptionST("BackgroundAlpha", "$BackgroundAlpha", JsonUtil.GetFloatValue(File, "widget_backgroundalpha") as Int)
			AddSliderOptionST("MeterAlpha", "$MeterAlpha", JsonUtil.GetFloatValue(File, "widget_meteralpha") as Int)
			AddSliderOptionST("MeterScale", "$MeterScale", JsonUtil.GetFloatValue(File, "widget_meterscale") as Int)
endfunction	

function Page_Sound_System()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$Sound_System_VoicePacks_Selection_Header")
		AddToggleOptionST("sl_voice_mutesexlab", "$sl_voice_mutesexlab", JsonUtil.GetIntValue(File, "sl_voice_mutesexlab"))
		AddToggleOptionST("sl_voice_enjoymentbased", "$sl_voice_enjoymentbased", JsonUtil.GetIntValue(File, "sl_voice_enjoymentbased"))
		AddToggleOptionST("sl_voice_playandwait", "$sl_voice_playandwait", JsonUtil.GetIntValue(File, "sl_voice_playandwait"))
		AddSliderOptionST("sl_voice_painswitch", "$sl_voice_painswitch", JsonUtil.GetIntValue(File, "sl_voice_painswitch") * 10)
		AddSliderOptionST("sl_voice_player", "$PC_voice_pack", JsonUtil.GetIntValue(File, "sl_voice_player"))
		AddSliderOptionST("sl_voice_npc", "$NPC_voice_pack", JsonUtil.GetIntValue(File, "sl_voice_npc"))
	

	SetCursorPosition(1)
		AddHeaderOption("$Sound_System_Installed_VoicePacks_Header")
		AddHeaderOption("$Sound_System_Installed_F_VoicePacks_Header")
		int i = 0
		while i < ((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetSize()
			if ((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetAt(i) != none
				AddTextOption(i + 1, (((Game.GetFormFromFile(0x63A3, "SLSO.esp") as formlist).GetAt(1) as formlist).GetAt(i) as form).GetName() + " (" + DectoHex((((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetAt(i) as form).GetFormID())+")", OPTION_FLAG_DISABLED)
			else
				AddTextOption("Something wrong", "save, reload", OPTION_FLAG_DISABLED)
			endif
		i = i + 1
		endwhile
endfunction	

string function DectoHex(Int value)
    String digits = "0123456789ABCDEF"
    int base = 16
    String hex = ""
	
	if (value <= 0)
		return 0
	endif
	
    while (value > 0)
        int digit = value % base
        hex = StringUtil.GetNthChar(digits, digit) + hex
        value = value / base
	endwhile
	
    return hex
endfunction	

;=============================================================
;Sliders
;=============================================================

state sl_hot_voice_strength
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetIntValue(File, "sl_hot_voice_strength"))
		SetSliderDialogDefaultValue(90)
		SetSliderDialogRange(30, 200)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetIntValue(File, "sl_hot_voice_strength", value as int)
		SetSliderOptionValueST(JsonUtil.GetIntValue(File, "sl_hot_voice_strength"))
	endEvent
	
	event OnHighlightST()
		SetInfoText("$sl_hot_voice_strength_description")
	endEvent
endState

;=============================================================
;TOGGLES
;=============================================================

state widget_player_only
	event OnSelectST()
		if JsonUtil.GetIntValue(File, "widget_player_only") == 1
			JsonUtil.SetIntValue(File, "widget_player_only", 0)
		else
			JsonUtil.SetIntValue(File, "widget_player_only", 1)
		endif
		SetToggleOptionValueST(JsonUtil.GetIntValue(File, "widget_player_only"))
	endEvent
endState

state widget_show_enjoymentmodifier
	event OnSelectST()
		if JsonUtil.GetIntValue(File, "widget_show_enjoymentmodifier") == 1
			JsonUtil.SetIntValue(File, "widget_show_enjoymentmodifier", 0)
		else
			JsonUtil.SetIntValue(File, "widget_show_enjoymentmodifier", 1)
		endif
		SetToggleOptionValueST(JsonUtil.GetIntValue(File, "widget_show_enjoymentmodifier"))
	endEvent
endState

state widget_show_painedgingtext
	event OnSelectST()
		if JsonUtil.GetIntValue(File, "widget_show_painedgingtext") == 1
			JsonUtil.SetIntValue(File, "widget_show_painedgingtext", 0)
		else
			JsonUtil.SetIntValue(File, "widget_show_painedgingtext", 1)
		endif
		SetToggleOptionValueST(JsonUtil.GetIntValue(File, "widget_show_painedgingtext"))
	endEvent
endState

;=============================================================
;HOTKEYS
;=============================================================

state hotkey_widget
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		bool continue = true
 
		; Check for conflict
		if conflictControl != ""
			string msg
			if conflictName != ""
				msg = "This key is already mapped to:\n'" + conflictControl + "'\n(" + conflictName + ")\n\n Are you sure you want to continue?"
			else
				msg = "This key is already mapped to:\n'" + conflictControl + "'\n\n Are you sure you want to continue?"
			endIf
			continue = ShowMessage(msg, true, "Yes", "No")
		endIf

		; Set allowed key change
		if continue
			JsonUtil.SetIntValue(File, "hotkey_widget", newKeyCode)
			SetKeyMapOptionValueST(JsonUtil.GetIntValue(File, "hotkey_widget"))
		endIf
	endEvent

	event OnHighlightST()
		SetInfoText("$hotkey_widget_description")
	endEvent
endState

;=============================================================
;Widgets
;=============================================================

state widget1_0
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget1", 0) == "On"
			JsonUtil.StringListSet(File, "widget1", 0, "Off")
		else
			JsonUtil.StringListSet(File, "widget1", 0, "On")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget1", 0))
	endEvent
endState

state widget1_1
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget1", 1) as Int)
		SetSliderDialogDefaultValue(495)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget1", 1, value )
		(self.GetAlias(1) as SLSO_Widget1Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget1", 1) as int)
	endEvent
endState

state widget1_2
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget1", 2) as Int)
		SetSliderDialogDefaultValue(680)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget1", 2, value )
		(self.GetAlias(1) as SLSO_Widget1Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget1", 2) as int)
	endEvent
endState

state widget1_3
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget1", 3) == "left"
			JsonUtil.StringListSet(File, "widget1", 3, "right")
		elseif JsonUtil.StringListGet(File, "widget1", 3) == "right"
			JsonUtil.StringListSet(File, "widget1", 3, "both")
		else
			JsonUtil.StringListSet(File, "widget1", 3, "left")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget1", 3))
	endEvent
endState

state widget2_0
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget2", 0) == "On"
			JsonUtil.StringListSet(File, "widget2", 0, "Off")
		else
			JsonUtil.StringListSet(File, "widget2", 0, "On")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget2", 0))
	endEvent
endState

state widget2_1
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget2", 1) as Int)
		SetSliderDialogDefaultValue(495)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget2", 1, value )
		(self.GetAlias(2) as SLSO_Widget2Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget2", 1) as int)
	endEvent
endState

state widget2_2
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget2", 2) as Int)
		SetSliderDialogDefaultValue(680)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget2", 2, value )
		(self.GetAlias(2) as SLSO_Widget2Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget2", 2) as int)
	endEvent
endState

state widget2_3
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget2", 3) == "left"
			JsonUtil.StringListSet(File, "widget2", 3, "right")
		elseif JsonUtil.StringListGet(File, "widget2", 3) == "right"
			JsonUtil.StringListSet(File, "widget2", 3, "both")
		else
			JsonUtil.StringListSet(File, "widget2", 3, "left")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget2", 3))
	endEvent
endState

state widget3_0
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget3", 0) == "On"
			JsonUtil.StringListSet(File, "widget3", 0, "Off")
		else
			JsonUtil.StringListSet(File, "widget3", 0, "On")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget3", 0))
	endEvent
endState

state widget3_1
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget3", 1) as Int)
		SetSliderDialogDefaultValue(495)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget3", 1, value )
		(self.GetAlias(3) as SLSO_Widget3Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget3", 1) as int)
	endEvent
endState

state widget3_2
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget3", 2) as Int)
		SetSliderDialogDefaultValue(680)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget3", 2, value )
		(self.GetAlias(3) as SLSO_Widget3Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget3", 2) as int)
	endEvent
endState

state widget3_3
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget3", 3) == "left"
			JsonUtil.StringListSet(File, "widget3", 3, "right")
		elseif JsonUtil.StringListGet(File, "widget3", 3) == "right"
			JsonUtil.StringListSet(File, "widget3", 3, "both")
		else
			JsonUtil.StringListSet(File, "widget3", 3, "left")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget3", 3))
	endEvent
endState

state widget4_0
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget4", 0) == "On"
			JsonUtil.StringListSet(File, "widget4", 0, "Off")
		else
			JsonUtil.StringListSet(File, "widget4", 0, "On")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget4", 0))
	endEvent
endState

state widget4_1
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget4", 1) as Int)
		SetSliderDialogDefaultValue(495)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget4", 1, value )
		(self.GetAlias(4) as SLSO_Widget4Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget4", 1) as int)
	endEvent
endState

state widget4_2
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget4", 2) as Int)
		SetSliderDialogDefaultValue(680)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget4", 2, value )
		(self.GetAlias(4) as SLSO_Widget4Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget4", 2) as int)
	endEvent
endState

state widget4_3
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget4", 3) == "left"
			JsonUtil.StringListSet(File, "widget4", 3, "right")
		elseif JsonUtil.StringListGet(File, "widget4", 3) == "right"
			JsonUtil.StringListSet(File, "widget4", 3, "both")
		else
			JsonUtil.StringListSet(File, "widget4", 3, "left")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget4", 3))
	endEvent
endState

state widget5_0
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget5", 0) == "On"
			JsonUtil.StringListSet(File, "widget5", 0, "Off")
		else
			JsonUtil.StringListSet(File, "widget5", 0, "On")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget5", 0))
	endEvent
endState

state widget5_1
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget5", 1) as Int)
		SetSliderDialogDefaultValue(495)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget5", 1, value )
		(self.GetAlias(4) as SLSO_widget5Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget5", 1) as int)
	endEvent
endState

state widget5_2
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.StringListGet(File, "widget5", 2) as Int)
		SetSliderDialogDefaultValue(680)
		SetSliderDialogRange(1, 4000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.StringListSet(File, "widget5", 2, value )
		(self.GetAlias(4) as SLSO_widget5Update).UpdateWidgetPosition()
		SetSliderOptionValueST(JsonUtil.StringListGet(File, "widget5", 2) as int)
	endEvent
endState

state widget5_3
	event OnSelectST()
		if JsonUtil.StringListGet(File, "widget5", 3) == "left"
			JsonUtil.StringListSet(File, "widget5", 3, "right")
		elseif JsonUtil.StringListGet(File, "widget5", 3) == "right"
			JsonUtil.StringListSet(File, "widget5", 3, "both")
		else
			JsonUtil.StringListSet(File, "widget5", 3, "left")
		endif
		SetTextOptionValueST(JsonUtil.StringListGet(File, "widget5", 3))
	endEvent
endState

state LabelTextSize
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetFloatValue(File, "widget_labeltextsize") as Int)
		SetSliderDialogDefaultValue(20)
		SetSliderDialogRange(1, 50)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetFloatValue(File, "widget_labeltextsize", value )
		SetSliderOptionValueST(JsonUtil.GetFloatValue(File, "widget_labeltextsize") as int)
	endEvent
endState

state ValueTextSize
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetFloatValue(File, "widget_valuetextsize") as Int)
		SetSliderDialogDefaultValue(20)
		SetSliderDialogRange(1, 50)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetFloatValue(File, "widget_valuetextsize", value )
		SetSliderOptionValueST(JsonUtil.GetFloatValue(File, "widget_valuetextsize") as int)
	endEvent
endState

state BorderAlpha
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetFloatValue(File, "widget_borderalpha") as Int)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetFloatValue(File, "widget_borderalpha", value )
		SetSliderOptionValueST(JsonUtil.GetFloatValue(File, "widget_borderalpha") as int)
	endEvent
endState

state BackgroundAlpha
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetFloatValue(File, "widget_backgroundalpha") as Int)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetFloatValue(File, "widget_backgroundalpha", value )
		SetSliderOptionValueST(JsonUtil.GetFloatValue(File, "widget_backgroundalpha") as int)
	endEvent
endState

state MeterAlpha
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetFloatValue(File, "widget_meteralpha") as Int)
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetFloatValue(File, "widget_meteralpha", value )
		SetSliderOptionValueST(JsonUtil.GetFloatValue(File, "widget_meteralpha") as int)
	endEvent
endState

state MeterScale
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetFloatValue(File, "widget_meterscale") as Int)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetFloatValue(File, "widget_meterscale", value )
		SetSliderOptionValueST(JsonUtil.GetFloatValue(File, "widget_meterscale") as int)
	endEvent
endState

;=============================================================
;Widget Colours
;=============================================================

state widgetcolors_0
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 0) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 0, value )
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 0) as int)
	endEvent
endState

state widgetcolors_1
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 1) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 1, value as string)
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 1) as int)
	endEvent
endState

state widgetcolors_2
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 2) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 2, value as string)
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 2) as int)
	endEvent
endState

state widgetcolors_3
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 3) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 3, value as string)
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 3) as int)
	endEvent
endState

state widgetcolors_4
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 4) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 4, value as string)
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 4) as int)
	endEvent
endState

state widgetcolors_5
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 5) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 5, value as string)
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 5) as int)
	endEvent
endState

state widgetcolors_6
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 6) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 6, value as string)
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 6) as int)
	endEvent
endState

state widgetcolors_7
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.StringListGet(File, "widgetcolors", 7) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.StringListSet(File, "widgetcolors", 7, value as string)
		SetColorOptionValueST(JsonUtil.StringListGet(File, "widgetcolors", 7) as int)
	endEvent
endState

state LabelColor
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.GetFloatValue(File, "widget_labelcolor", 16777215) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.SetFloatValue(File, "widget_labelcolor", value)
		SetColorOptionValueST(JsonUtil.GetFloatValue(File, "widget_labelcolor", 16777215) as int)
	endEvent
endState

state SelectedActorColor
	event OnColorOpenST()
		SetColorDialogStartColor(JsonUtil.GetFloatValue(File, "widget_selectedactorcolor", 16768768) as int)
	endEvent

	event OnColorAcceptST(int value)
		JsonUtil.SetFloatValue(File, "widget_selectedactorcolor", value)
		SetColorOptionValueST(JsonUtil.GetFloatValue(File, "widget_selectedactorcolor", 16768768) as int)
	endEvent
endState

;=============================================================
;Sound System
;=============================================================

state sl_voice_mutesexlab
	event OnSelectST()
		if JsonUtil.GetIntValue(File, "sl_voice_mutesexlab") == 1
			JsonUtil.SetIntValue(File, "sl_voice_mutesexlab", 0)
		else
			JsonUtil.SetIntValue(File, "sl_voice_mutesexlab", 1)
		endif
		SetToggleOptionValueST(JsonUtil.GetIntValue(File, "sl_voice_mutesexlab"))
	endEvent
	
	event OnHighlightST()
		SetInfoText("$sl_voice_mutesexlab_description")
	endEvent
endState

state sl_voice_enjoymentbased
	event OnSelectST()
		if JsonUtil.GetIntValue(File, "sl_voice_enjoymentbased") == 1
			JsonUtil.SetIntValue(File, "sl_voice_enjoymentbased", 0)
		else
			JsonUtil.SetIntValue(File, "sl_voice_enjoymentbased", 1)
		endif
		SetToggleOptionValueST(JsonUtil.GetIntValue(File, "sl_voice_enjoymentbased"))
	endEvent
	
	event OnHighlightST()
		SetInfoText("$sl_voice_enjoymentbased_description")
	endEvent
endState

state sl_voice_playandwait
	event OnSelectST()
		if JsonUtil.GetIntValue(File, "sl_voice_playandwait") == 1
			JsonUtil.SetIntValue(File, "sl_voice_playandwait", 0)
		else
			JsonUtil.SetIntValue(File, "sl_voice_playandwait", 1)
		endif
		SetToggleOptionValueST(JsonUtil.GetIntValue(File, "sl_voice_playandwait"))
	endEvent
	
	event OnHighlightST()
		SetInfoText("$sl_voice_playandwait_description")
	endEvent
endState

state sl_voice_reset
	event OnSelectST()
		;sl_voice_reset
	endEvent
	
	event OnHighlightST()
		SetInfoText("$sl_voice_reset_description")
	endEvent
endState

;=============================================================
;Sliders
;=============================================================

state sl_voice_painswitch
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetIntValue(File, "sl_voice_painswitch"))
		SetSliderDialogDefaultValue(8)
		SetSliderDialogRange(0, 10)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetIntValue(File, "sl_voice_painswitch", value as int)
		SetSliderOptionValueST((value * 10) as int)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$sl_voice_painswitch_description")
	endEvent
endState

state sl_voice_player
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetIntValue(File, "sl_voice_player"))
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, ((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetSize())
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetIntValue(File, "sl_voice_player", value as int)
		SetSliderOptionValueST(value as int)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$PC_voice_pack_description")
	endEvent
endState

state sl_voice_npc
	event OnSliderOpenST()
		SetSliderDialogStartValue(JsonUtil.GetIntValue(File, "sl_voice_npc"))
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(-2, 0)	;((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetSize())
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		JsonUtil.SetIntValue(File, "sl_voice_npc", value as int)
		SetSliderOptionValueST(value as int)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$NPC_voice_pack_description")
	endEvent
endState
