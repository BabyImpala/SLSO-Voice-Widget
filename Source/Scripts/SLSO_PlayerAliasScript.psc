scriptname SLSO_PlayerAliasScript extends ReferenceAlias
{SLSO_PlayerAliasScript script}

String File

;=============================================================
;INIT
;=============================================================

Event OnInit()
	Maintenance()
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

function Maintenance()
	File = "/SLSO/Config.json"
	if JsonUtil.GetErrors(File) != ""
		Debug.Messagebox("SLSO Json has errors, mod wont work")
		return
	endif
	
	;register events
	self.RegisterForModEvent("SexLabOrgasmSeparate", "Orgasm")
	self.RegisterForModEvent("AnimationStart", "OnSexLabStart")
	self.RegisterForModEvent("AnimationEnd", "OnSexLabEnd")
	
	Clear()
	
	;check and reset normal voices if needed
	if	((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetSize() > 0
		int i = 0
		while i < ((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetSize()
			if ((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).GetAt(i) == none
				((Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist).Revert()
				((Game.GetFormFromFile(0x63A3, "SLSO.esp") as formlist).GetAt(1) as formlist).Revert()
				JsonUtil.SetIntValue(File, "sl_voice_player", 0)
				JsonUtil.SetIntValue(File, "sl_voice_npc", 0)
				return
			endif
			i += 1
		endwhile
	endif
	
	;check and reset victim voices if needed
	if	((Game.GetFormFromFile(0x7935, "SLSO.esp") as formlist).GetAt(1) as formlist).GetSize() > 0
		int i = 0
		while i < ((Game.GetFormFromFile(0x7935, "SLSO.esp") as formlist).GetAt(1) as formlist).GetSize()
			if ((Game.GetFormFromFile(0x7935, "SLSO.esp") as formlist).GetAt(1) as formlist).GetAt(i) == none
				((Game.GetFormFromFile(0x7935, "SLSO.esp") as formlist).GetAt(1) as formlist).Revert()
				((Game.GetFormFromFile(0x7938, "SLSO.esp") as formlist).GetAt(1) as formlist).Revert()
				return
			endif
			i += 1
		endwhile
	endif
	
endFunction

function Clear()
	int i = 1
	SLSO_MCM SLSO = self.GetOwningQuest() as SLSO_MCM
	while i <= 5
		;clear widget alias
		(self.GetOwningQuest().GetAlias(i)).RegisterForModEvent("SLSO_Stop_widget", "Stop_widget")
		int handle = ModEvent.Create("SLSO_Stop_widget")
		if (handle)
			ModEvent.PushInt(handle, i)
			ModEvent.Send(handle)
		endif
		i += 1
	endwhile
endFunction

;----------------------------------------------------------------------------
;SexLab hooks
;----------------------------------------------------------------------------

Event OnSexLabStart(string EventName, string argString, Float argNum, form sender)
	RegisterKey(JsonUtil.GetIntValue(File, "hotkey_widget"))
	SLSO_MCM SLSO = self.GetOwningQuest() as SLSO_MCM
	sslThreadModel Thread = SLSO.SexLab.GetThread(argString as int) as sslThreadModel
	Actor[] Positions = Thread.GetPositions()

	;if thread has player, enable widgets
	int i = 0
	if Thread.HasPlayer()
		while i < Positions.Length
			if Positions[i] != none
				;fill widget and game() alias
				(self.GetOwningQuest().GetAlias(i+1) as ReferenceAlias).ForceRefTo(Positions[i])
				;start alias widget
				(self.GetOwningQuest().GetAlias(i+1)).RegisterForModEvent("SLSO_Start_widget", "Start_widget")
			endif
			i += 1
		endwhile
		i = 0
	endif
	
	;add game, voice, animsync abilities and start everything
	while i < Positions.Length
		if Positions[i] != none
			;attemp to force remove abilities, that may not have finished, if animation fired up right after previous has ended
			Positions[i].RemoveSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellVoice)
			;add fresh abilities
			Positions[i].AddSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellVoice, false)
			;wait 1s for scripts and abilities setup and be ready for events
			;there should be some sort of callback, but fuck that magic, waiting 1 sec is easier
			utility.wait(1)
			;push event to start everything
			int handle = ModEvent.Create("SLSO_start_widget")
			if (handle)
				ModEvent.PushInt(handle, i+1)
				ModEvent.PushInt(handle, argString as int)
				ModEvent.Send(handle)
			endif
		endif
		i += 1
	endwhile
EndEvent

Event OnSexLabEnd(string EventName, string argString, Float argNum, form sender)
	UnregisterKey(JsonUtil.GetIntValue(File, "hotkey_widget"))
	sslThreadModel Thread = (self.GetOwningQuest() as SLSO_MCM).SexLab.GetThread(argString as int) as sslThreadModel
	if Thread.HasPlayer()
		Clear() ;clear alias widget, abilities
	endif
EndEvent

Function RegisterKey(int RKey = 0)
	If (RKey != 0)
		self.RegisterForKey(RKey)
	EndIf
EndFunction

Function UnregisterKey(int RKey = 0)
	If (RKey != 0)
		self.UnregisterForKey(RKey)
	EndIf
EndFunction

Event OnKeyDown(int keyCode)
	If !Utility.IsInMenuMode()
		If keyCode == JsonUtil.GetIntValue(File, "hotkey_widget")
			If JsonUtil.GetIntValue(File, "widget_enabled") == 1
				JsonUtil.SetIntValue(File, "widget_enabled", 0)
				(self.GetOwningQuest().GetAlias(1) as SLSO_Widget1Update).HideWidget()
				(self.GetOwningQuest().GetAlias(2) as SLSO_Widget2Update).HideWidget()
				(self.GetOwningQuest().GetAlias(3) as SLSO_Widget3Update).HideWidget()
				(self.GetOwningQuest().GetAlias(4) as SLSO_Widget4Update).HideWidget()
				(self.GetOwningQuest().GetAlias(5) as SLSO_Widget5Update).HideWidget()
			Else
				JsonUtil.SetIntValue(File, "widget_enabled", 1)
			EndIf
		EndIf
	EndIf
EndEvent