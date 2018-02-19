#include <File.au3>
#include <ImageSearch2015.au3>

; ===============================================================================================================================
; Variables for the _INetSmtpMailCom
; ===============================================================================================================================
Global Enum _
        $g__INetSmtpMailCom_ERROR_FileNotFound = 1, _
        $g__INetSmtpMailCom_ERROR_Send, _
        $g__INetSmtpMailCom_ERROR_ObjectCreation, _
        $g__INetSmtpMailCom_ERROR_COUNTER

Global Const $g__cdoSendUsingPickup = 1 ; Send message using the local SMTP service pickup directory.
Global Const $g__cdoSendUsingPort = 2 ; Send the message using the network (SMTP over the network). Must use this to use Delivery Notification
Global Const $g__cdoAnonymous = 0 ; Do not authenticate
Global Const $g__cdoBasic = 1 ; basic (clear-text) authentication
Global Const $g__cdoNTLM = 2 ; NTLM
Global $gs_thoussep = "."
Global $gs_decsep = ","
Global $sFileOpenDialog = ""
Global $receiveTell = "C:\Users\Headslasha\Downloads\Games\AutoIT\SCRIPTS\tellwindow.png"
Global $textcount=0

; Delivery Status Notifications
Global Const $g__cdoDSNDefault = 0 ; None
Global Const $g__cdoDSNNever = 1 ; None
Global Const $g__cdoDSNFailure = 2 ; Failure
Global Const $g__cdoDSNSuccess = 4 ; Success
Global Const $g__cdoDSNDelay = 8 ; Delay

;HotKeySet("{END}", "__ExitBot")
;HotKeySet("{DELETE}", "__PauseBot")

msgbox(0,"TellBotRunning", "TellBot is active")
WinActivate("EverQuest","")

while(1)
__checkTells()
sleep(30000)
WEnd

Func __checkTells()
$x1=0
$y1=0
$tellCheck = _ImageSearch($receiveTell,1,$x1,$y1,0,0)
If $tellCheck = True Then
   $textcount = $textcount+1
   If $textcount <= 3 Then
   _Sendmail()
   EndIf
ElseIf $tellCheck = False Then
   $textcount=0
EndIf
EndFunc

Func __ExitBot()
   msgbox(0,"TellBotDone", "Tell Bot is stopped")
   Exit
EndFunc

Func __PauseBot()
   $Paused = NOT $Paused
   While $Paused
   sleep(100)
   ToolTip('Tell Script is "Paused" ',0,0)
   WEnd
   ToolTip("")
EndFunc



Func _Sendmail()
    Local $sSmtpServer = "smtp.gmail.com" ; address for the smtp-server to use - REQUIRED
    Local $sFromName = "myEQBots" ; name from who the email was sent
    Local $sFromAddress = "myeqbots@gmail.com" ; address from where the mail should come
    Local $sToAddress = "2053001120@vtext.com" ; destination address of the email - REQUIRED
    Local $sSubject = "Dingaling" ; subject from the email - can be anything you want it to be
    Local $sBody = "YouHaveATell" ; the messagebody from the mail - can be left blank but then you get a blank mail
    Local $sAttachFiles = "" ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
    Local $sCcAddress = "" ; address for cc - leave blank if not needed
    Local $sBccAddress = "" ; address for bcc - leave blank if not needed
    Local $sImportance = "Normal" ; Send message priority: "High", "Normal", "Low"
    Local $sUsername = "myeqbots@gmail.com" ; username for the account used from where the mail gets sent - REQUIRED
    Local $sPassword = "spider8989" ; password for the account used from where the mail gets sent - REQUIRED
    Local $iIPPort = 465 ; GMAIL port used for sending the mail
    Local $bSSL = True ; GMAIL enables/disables secure socket layer sending - set to True if using httpS


    Local $bIsHTMLBody = False
    Local $iDSNOptions = $g__cdoDSNDefault

    Local $rc = _INetSmtpMailCom($sSmtpServer, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $sAttachFiles, $sCcAddress, $sBccAddress, $sImportance, $sUsername, $sPassword, $iIPPort, $bSSL, $bIsHTMLBody, $iDSNOptions)
    If @error Then
        MsgBox(0, "_INetSmtpMailCom(): Error sending message", _
                "Error code: " & @error & @CRLF & @CRLF & _
                "Error Hex Number: " & _INetSmtpMailCom_ErrHexNumber() & @CRLF & @CRLF & _
                "Description: " & _INetSmtpMailCom_ErrDescription() & @CRLF & @CRLF & _
                "Description (rc): " & $rc & @CRLF & @CRLF & _
                "ScriptLine: " & _INetSmtpMailCom_ErrScriptLine() _
                )
        ConsoleWrite("### COM Error !  Number: " & _INetSmtpMailCom_ErrHexNumber() & "   ScriptLine: " & _INetSmtpMailCom_ErrScriptLine() & "   Description:" & _INetSmtpMailCom_ErrDescription() & @LF)
    Else
        Dim $iMsgBoxAnswer
        ;$iMsgBoxAnswer = MsgBox(262208, "SUCCESS", ":-)", 2)
    EndIf

EndFunc   ;==>_Enviarmail



#Region UDF Functions
; The UDF
; #FUNCTION# ====================================================================================================================
; Name ..........: _INetSmtpMailCom
; Description ...:
; Syntax ........: _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress[, $s_Subject = ""[, $as_Body = ""[,
;                  $s_AttachFiles = ""[, $s_CcAddress = ""[, $s_BccAddress = ""[, $s_Importance = "Normal"[, $s_Username = ""[,
;                  $s_Password = ""[, $IPPort = 25[, $bSSL = False[, $bIsHTMLBody = False[, $iDSNOptions = $g__cdoDSNDefault]]]]]]]]]]]])
; Parameters ....: $s_SmtpServer        - A string value.
;                  $s_FromName          - A string value.
;                  $s_FromAddress       - A string value.
;                  $s_ToAddress         - A string value.
;                  $s_Subject           - [optional] A string value. Default is "".
;                  $s_Body              - [optional] A string value. Default is "".
;                  $s_AttachFiles       - [optional] A string value. Default is "".
;                  $s_CcAddress         - [optional] A string value. Default is "".
;                  $s_BccAddress        - [optional] A string value. Default is "".
;                  $s_Importance        - [optional] A string value. Default is "Normal".
;                  $s_Username          - [optional] A string value. Default is "".
;                  $s_Password          - [optional] A string value. Default is "".
;                  $IPPort              - [optional] An integer value. Default is 25.
;                  $bSSL                - [optional] A binary value. Default is False.
;                  $bIsHTMLBody         - [optional] A binary value. Default is False.
;                  $iDSNOptions         - [optional] An integer value. Default is $g__cdoDSNDefault.
; Return values .: None
; Author ........: Jos
; Modified ......: mLipok
; Remarks .......:
; Related .......: http://www.autoitscript.com/forum/topic/23860-smtp-mailer-that-supports-html-and-attachments/
; Link ..........: http://www.autoitscript.com/forum/topic/167292-smtp-mailer-udf/
; Example .......: Yes
; ===============================================================================================================================
Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $s_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance = "Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $bSSL = False, $bIsHTMLBody = False, $iDSNOptions = $g__cdoDSNDefault)
    ; init Error Handler
    _INetSmtpMailCom_ErrObjInit()

    Local $objEmail = ObjCreate("CDO.Message")
    If Not IsObj($objEmail) Then Return SetError($g__INetSmtpMailCom_ERROR_ObjectCreation, Dec(_INetSmtpMailCom_ErrHexNumber()), _INetSmtpMailCom_ErrDescription())

    ; Clear previous Err information
    _INetSmtpMailCom_ErrHexNumber(0)
    _INetSmtpMailCom_ErrDescription('')
    _INetSmtpMailCom_ErrScriptLine('')

    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress

    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject

    ; Select whether or not the content is sent as plain text or HTM
    If $bIsHTMLBody Then
        $objEmail.Textbody = $s_Body & @CRLF
    Else
        $objEmail.HTMLBody = $s_Body
    EndIf

    ; Add Attachments
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
            If FileExists($S_Files2Attach[$x]) Then
                ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
                $objEmail.AddAttachment($S_Files2Attach[$x])
            Else
                ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
                Return SetError($g__INetSmtpMailCom_ERROR_FileNotFound, 0, 0)
            EndIf
        Next
    EndIf

    ; Set Email Configuration
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = $g__cdoSendUsingPort
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    If Number($IPPort) = 0 Then $IPPort = 25
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    ;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = $g__cdoBasic
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = $bSSL

    ;Update Configuration Settings
    $objEmail.Configuration.Fields.Update

    ; Set Email Importance
    Switch $s_Importance
        Case "High"
            $objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "High"
        Case "Normal"
            $objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Normal"
        Case "Low"
            $objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Low"
    EndSwitch

    ; Set DSN options
    If $iDSNOptions <> $g__cdoDSNDefault And $iDSNOptions <> $g__cdoDSNNever Then
        $objEmail.DSNOptions = $iDSNOptions
        $objEmail.Fields.Item("urn:schemas:mailheader:disposition-notification-to") = $s_FromAddress
;~      $objEmail.Fields.Item("urn:schemas:mailheader:return-receipt-to") = $s_FromAddress
    EndIf

    ; Update Importance and Options fields
    $objEmail.Fields.Update

    ; Sent the Message
    $objEmail.Send

    If @error Then
        _INetSmtpMailCom_ErrObjCleanUp()
        Return SetError($g__INetSmtpMailCom_ERROR_Send, Dec(_INetSmtpMailCom_ErrHexNumber()), _INetSmtpMailCom_ErrDescription())
    EndIf

    ; CleanUp
    $objEmail = ""
    _INetSmtpMailCom_ErrObjCleanUp()

EndFunc   ;==>_INetSmtpMailCom

;
; Com Error Handler
Func _INetSmtpMailCom_ErrObjInit($bParam = Default)
    Local Static $oINetSmtpMailCom_Error = Default
    If $bParam == 'CleanUp' And $oINetSmtpMailCom_Error <> Default Then
        $oINetSmtpMailCom_Error = ''
        Return $oINetSmtpMailCom_Error
    EndIf
    If $oINetSmtpMailCom_Error = Default Then
        $oINetSmtpMailCom_Error = ObjEvent("AutoIt.Error", "_INetSmtpMailCom_ErrFunc")
    EndIf
    Return $oINetSmtpMailCom_Error
EndFunc   ;==>_INetSmtpMailCom_ErrObjInit

Func _INetSmtpMailCom_ErrObjCleanUp()
    _INetSmtpMailCom_ErrObjInit('CleanUp')
EndFunc   ;==>_INetSmtpMailCom_ErrObjCleanUp

Func _INetSmtpMailCom_ErrHexNumber($vData = Default)
    Local Static $vReturn = 0
    If $vData <> Default Then $vReturn = $vData
    Return $vReturn
EndFunc   ;==>_INetSmtpMailCom_ErrHexNumber

Func _INetSmtpMailCom_ErrDescription($sData = Default)
    Local Static $sReturn = ''
    If $sData <> Default Then $sReturn = $sData
    Return $sReturn
EndFunc   ;==>_INetSmtpMailCom_ErrDescription

Func _INetSmtpMailCom_ErrScriptLine($iData = Default)
    Local Static $iReturn = ''
    If $iData <> Default Then $iReturn = $iData
    Return $iReturn
EndFunc   ;==>_INetSmtpMailCom_ErrScriptLine

Func _INetSmtpMailCom_ErrFunc()
    _INetSmtpMailCom_ErrObjInit()
    _INetSmtpMailCom_ErrHexNumber(Hex(_INetSmtpMailCom_ErrObjInit().number, 8))
    _INetSmtpMailCom_ErrDescription(StringStripWS(_INetSmtpMailCom_ErrObjInit().description, 3))
    _INetSmtpMailCom_ErrScriptLine(_INetSmtpMailCom_ErrObjInit().ScriptLine)
    SetError(1) ; something to check for when this function returns
    Return
EndFunc   ;==>_INetSmtpMailCom_ErrFunc

#EndRegion UDF Functions