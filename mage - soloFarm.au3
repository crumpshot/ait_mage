#include <ImageSearch2015.au3>

;petbuffs: 1233,769 to 1288,990

Global $Paused
Global $burnout = "C:\Users\Headslasha\Downloads\Games\AutoIT\SCRIPTS\burnout.png"
Global $damageShield = "C:\Users\Headslasha\Downloads\Games\AutoIT\SCRIPTS\damageShield.png"
Global $manabuff = "C:\Users\Headslasha\Downloads\Games\AutoIT\SCRIPTS\manaBuff.png"
HotKeySet("{END}", "__ExitBot")
HotKeySet("{DELETE}", "__PauseBot")

msgbox(0,"BotRunning", "Bot is active")
WinActivate("EverQuest","")

while(1)
sleep(200)
;__mezAdds()
__mageCombat()
sleep(500)
;__outofCombatSit()
__PetBuffs()
sleep(1000)
__selfBuffs()
sleep(5000) ;iterative testing purposes
   WEnd

Func __PetBuffs()
$x1=0
$y1=0
$burnoutCheck = _ImageSearch($burnout,1,$x1,$y1,0,0)
If $burnoutCheck = False Then
   Send("8")
   sleep(1000)
   Send("{ESCAPE}")
   sleep(6000)
EndIf

sleep(200)
$petDsCheck = _ImageSearch($damageShield,1,$x1,$y1,0,0)
If $petDsCheck = False Then
   Send("9")
   sleep(1000)
   Send("{ESCAPE}")
   sleep(6000)
EndIf

EndFunc

Func __selfBuffs()
$x1=0
$y1=0
$manabuffCheck = _ImageSearch($manabuff,1,$x1,$y1,0,0)
If $manabuffCheck = False Then
   Send("4")
   sleep(1000)
   Send("{ESCAPE}")
   sleep(6000)
EndIf
EndFunc

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
      $hpPixel = pixelgetcolor(915,754) ;gets hp pixel at 95% mark. Set this coords value per character/screen
   ;msgbox(0,"hp", $hpPixel)
   If $hpPixel = 2632232 Then ;IFstatement returns VALUE 1 for hp bar being NOT red hex value:0x282A28
	  Return 1
   Else
	  Return 2
   EndIf
EndFunc


Func __mageCombat()
		 Send("0") ;assists w/pet and pauses 1sec
		 sleep(55000)
EndFunc

Func __mobInLOS()
   Send("{ESCAPE}")
   sleep(100)
   Send("F5")
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