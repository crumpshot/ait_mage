Global $Paused
HotKeySet("{END}", "__ExitBot")
HotKeySet("{DELETE}", "__PauseBot")

msgbox(0,"BotRunning", "Bot is active")
WinActivate("EverQuest","")

while(1)
sleep(200)
;__mezAdds()
__mageCombat()
sleep(500)
__outofCombatSit()
sleep(5000) ;iterative testing purposes
   WEnd


Func __ExitBot()
   msgbox(0,"BotDone", "Bot is stopped")
   Exit
EndFunc

Func __PauseBot()
   $Paused = NOT $Paused
   While $Paused
   sleep(100)
   ToolTip('Script is "Paused" ',0,0)
   WEnd
   ToolTip("")
EndFunc


Func __outofCombatSit()
   $currentCombatPixel = pixelgetcolor(1068,717) ;checks for black incombat icon logo - hex value: 0x000000
   $standingPixel = pixelgetcolor(1564,926) ;checks sit/stand button for standing status - hex value:0xC7C7C9
   $recentCombatPixel = pixelgetcolor(971,797) ;checks combat timer bar exists - hex value:0x999699
   ;msgbox(0,"test", $standingPixel) ;for testing
   If $currentCombatPixel <> 0 AND $standingPixel = 13290189 AND $recentCombatPixel = 10065561 Then ;if out of combat AND standing AND recently in combat/, then send SIT hotkey.. calculated off of the 30sec CD timer top gold color pixel
	  sleep(2000)
	  Send("x")
	  sleep(1000)
   EndIf
EndFunc


Func __manaCheck30()
      $manaPixel = pixelgetcolor(994,810) ;gets mana pixel at 30% mark. Set this coords value per character/screen
   If $manaPixel = 29415 Then ;IFstatement returns VALUE 1 for mana bar color being BLUE (ie has >=80% mana) hex value:0x0072E7
	  Return 1
   Else
	  Return 0
   EndIf
EndFunc


Func __TargetHpCheck95()
      $hpPixel = pixelgetcolor(918,754) ;gets hp pixel at 95% mark. Set this coords value per character/screen
   ;msgbox(0,"hp", $hpPixel)
   If $hpPixel = 2632232 Then ;IFstatement returns VALUE 1 for hp bar being NOT red hex value:0x282A28
	  Return 1
   Else
	  Return 2
   EndIf
EndFunc


Func __mageCombat()
   $mobCheck = __mobInLOS()
   If $mobCheck = 1 Then
	  sleep(500)
	  ;testing purposes ;msgbox(0,"mobCount",$mobCount)
	  Send("{ESCAPE}") ;clears target window
	  sleep(200)
	  Send("r") ;targets xtar1 ({F5})
	  sleep(500)
	  $targetHPengage = __TargetHpCheck95()
		 If $targetHPengage = 1 Then
		 Send("3") ;assists w/pet and pauses 1sec
		 sleep(4000)
		 $mana30 = __manaCheck30()
			If $mana30 = 1 Then
			sleep(3000)
			Send("2") ;nukes
			sleep(5000)
			EndIf
		 EndIf

   EndIf

EndFunc

Func __mobInLOS()
   Send("{ESCAPE}")
   sleep(100)
   Send("f")
   sleep(200)
   $targetPixel = pixelgetcolor(735,734) ;gets pixel for target pane to determine if anything selected, from upper left color border hex value:0x101521
   If $targetPixel <> 1053985 Then
	  Return 1
   Else
	  Return 0
   EndIf
EndFunc


;--------Future Functions To Write---------------

Func __conCheck() ;logic to determine if spells should be cast on mob based on CON
EndFunc