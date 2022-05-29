; Copyright (c) 2019 mattno
;
; This work is licensed under the terms of the MIT license.
; For a copy, see <https://opensource.org/licenses/MIT>.

; Allows automation of settings for Thrustmaster wheels/rims.

#pragma compile(Icon, wheel.ico)
#pragma compile(ProductName, TH Automate)
#pragma compile(OriginalFilename, TH-Auto.exe)
#pragma compile(FileDescription, Automates setting settings for Thrustmaster wheels/rims.)
#pragma compile(ProductVersion, 0.0.1)
#pragma compile(FileVersion, 0.0.1, 0.0.1.1)
#pragma compile(CompanyName, 'mattno')
#pragma compile(UPX, true)
#pragma compile(Compression, 9)

#include <MsgBoxConstants.au3>

Global $closeJoyCpl = false
Global $closeThCpl = false

Global Const $sJoyCplTitle = "Game Controllers"
Global Const $sThCplTitle = "[REGEXPTITLE:Thrustmaster .* Control Panel.*]"

; DEFAULT PROFILE
Global $rotation = "900"
Global $gainOverall = "75"
Global $gainConstant = "100"
Global $gainPeriodic = "100"
Global $gainSpring = "100"
Global $gainDamper = "100"

If $CmdLine[0] > 0 Then
   $rotation = $CmdLine[1]
EndIf
If $CmdLine[0] > 1 Then
   $gainOverall = $CmdLine[2]
EndIf
If $CmdLine[0] > 2 Then
   $gainConstant = $CmdLine[3]
EndIf
If $CmdLine[0] > 3 Then
   $gainPeriodic = $CmdLine[4]
EndIf
If $CmdLine[0] > 4 Then
   $gainSpring = $CmdLine[5]
EndIf
If $CmdLine[0] > 5 Then
   $gainDamper = $CmdLine[6]
EndIf

Local $hThCpl = GetThCpl()
If "" = $hThCpl Then
   Exit
EndIf

SetRotation($hThCpl)
SetGains($hThCpl)

If $closeThCpl Then
	  ControlClick( $hThCpl, "", "[CLASS:Button; TEXT:OK]")
EndIf
If $closeJoyCpl Then
   Local $hWnd = WinGetHandle ( $sJoyCplTitle )
   ControlClick( $hWnd, "", "[CLASS:Button; TEXT:OK]")
EndIf

Exit

Func GetJoyCpl()
   Local $hJoyCpl = WinGetHandle ($sJoyCplTitle)
   If @error Then
		 Run("control.exe joy.cpl")
		 ConsoleWrite ( "Run control.exe joy.cpl : @error=" & @error & @CRLF  )
		 $hJoyCpl = WinWait ( $sJoyCplTitle )
		 $closeJoyCpl = True
   EndIf
   ConsoleWrite ( "$hJoyCpl=" & $hJoyCpl & @CRLF  )
   WinActivate ( $hJoyCpl )
   return $hJoyCpl
EndFunc

Func GetThCpl()
   Local $hThCpl = WinGetHandle ($sThCplTitle)
   If (Not $hThCpl) Then
	  $closeThCpl = True

	  Local $hJoyCpl = GetJoyCpl()

	  ; Names as they appear in Game Controller applet
	  Local $tsNames[5]
	  $tsNames[0] = "Thrustmaster TX Racing Wheel"
	  $tsNames[1] = "Ferrari F1 Wheel Advanced TX"
	  $tsNames[2] = "TS-PC Racer"
	  $tsNames[3] = "Ferrari F1 Wheel Advanced TS-PC Racer"
	  $tsNames[4] = "Thrustmaster T300RS Racing Wheel"
	  Local $idx = -1
	  Local $err = False

	  ; find the first matching item
	  Do
		 ;Sleep(200)
		 $idx = Mod($idx + 1, UBound($tsNames))
		 ConsoleWrite ( "Find[" & $tsNames[$idx] & "]..." & @CRLF  )
		 Local $index = ControlListView ($hJoyCpl, "", "[CLASS:SysListView32; INSTANCE:1]", "FindItem", $tsNames[$idx])
		 $err = @error
		 ConsoleWrite ( "Find[" &  $tsNames[$idx] & "]: @error=" & $err &  "; index=" & $index  & @CRLF  )
		 If $err Then
			ExitLoop
		 EndIf
		 Local $success = $index <> -1 And Not $err
		 ConsoleWrite ("Until: " & $success & @CRLF )
	  Until ($success And $idx < UBound($tsNames))
	  If $err Or $index = -1 Then
		 MsgBox($MB_OK + $MB_ICONERROR + $MB_SETFOREGROUND, "Error", "Failed finding Thurstmaster wheel!")
		 Exit 1
		 return 0
	  EndIf

      ; Select Thrusmaster wheel
	  Do
		 $isSelected = -1
		 ;Sleep(100)
		 ControlListView ($hJoyCpl, "", "[CLASS:SysListView32; INSTANCE:1]", "Select",  $index )
		 ConsoleWrite ( "Select: @error=" & @error &  "; isSelected=" & $isSelected & "; index=" & $index & @CRLF  )
		 Local $isSelected = ControlListView ($hJoyCpl, "", "[CLASS:SysListView32; INSTANCE:1]", "IsSelected", $index)
	  Until (1 = $isSelected)

      ; Open Thrustmaster wheel control
	  Do
		 ;Sleep(100)
		 Local $status = ControlClick($hJoyCpl, "", "[CLASS:Button; TEXT:&Properties]")
		 ConsoleWrite ( "Properties: @error=" & @error &  "; status=" & $status  & @CRLF  )
	  Until (1 = $status)

	  WinWait ( $sThCplTitle )
	  $hThCpl = WinGetHandle ( $sThCplTitle )
	  ConsoleWrite ( "Thrustmaster: @error=" & @error &  "; $hThCpl=" & $hThCpl  & @CRLF  )

   EndIf

   WinActivate ( $hThCpl )
   Local $titleThCpl = WinGetTitle ( $hThCpl )
   ConsoleWrite ( "Thrustmaster: @error=" & @error &  "; $titleThCpl=" & $titleThCpl & @CRLF  )

   Return $hThCpl
 EndFunc

Func SetRotation($hThCpl)

; Display the handle of the Notepad window.
   ;MsgBox($MB_SYSTEMMODAL, "", $hWnd)

   Local $inFocus = ControlGetFocus ( $hThCpl )

   Local $tab = SetTab($hThCpl, 1)

   ;Local $title = WinGetTitle($hThCpl)

   Local $rim = ControlGetText ( $hThCpl, "", "[CLASS:Static; INSTANCE:15]" )
   ConsoleWrite ( "$rim=" & $rim & @CRLF )

   ;MsgBox($MB_SYSTEMMODAL, "", $hWnd)

   ControlFocus($hThCpl, "", "[CLASS:Edit; INSTANCE:1]")
   Local $status = ControlSetText($hThCpl, "", "[CLASS:Edit; INSTANCE:1]", $rotation)
   ConsoleWrite ( "ControlSetText: @error=" & @error & "; $status=" & $status & @CRLF )

   $tab = SetTab($hThCpl, $tab)
   ControlFocus($hThCpl, "", $inFocus)


;Sleep(800)
EndFunc

Func SetGains($hThCpl)

; Display the handle of the Notepad window.
   ;MsgBox($MB_SYSTEMMODAL, "", $hWnd)

   Local $inFocus = ControlGetFocus ( $hThCpl )
   Local $tab = SetTab($hThCpl, 3)


   Sleep(10)
   ControlFocus($hThCpl, "", "[CLASS:SysTabControl32; INSTANCE:1]")


   ; Master Gain
   ;Sleep(10)
   Send("{TAB 2}")
   Send("+{END}" & $gainOverall)

   ;Sleep(10)
   Send("{TAB 2}")
   Send("+{END}" & $gainConstant)

   ;Sleep(10)
   Send("{TAB 2}")
   Send("+{END}" & $gainPeriodic)

   ;Sleep(10)
   Send("{TAB 2}")
   Send("+{END}" & $gainSpring)

   ;Sleep(10)
   Send("{TAB 2}")
   Send("+{END}" & $gainDamper)

   Send("{TAB}")
   ;Sleep(100)

   $tab = SetTab($hThCpl, $tab)
   ControlFocus($hThCpl, "", $inFocus)

EndFunc

Func SetTab($hThCpl, $tab)
   Local $resetTab = -1
   Do
	  Local $ctab = ControlCommand( $hThCpl, "", "[CLASS:SysTabControl32; INSTANCE:1]", "CurrentTab" )
	  ConsoleWrite ( "Thrustmaster: @error=" & @error &  "; $tab=" & $ctab  & @CRLF  )
	  If $resetTab = -1 Then
		 $resetTab = $ctab
	  EndIf
	  If $ctab = $tab Then
		 ExitLoop
	  EndIf

	  Local $rightOrLeft = "TabLeft"
	  If ( $ctab < $tab) Then
		 $rightOrLeft = "TabRight"
	  EndIf
	  ControlCommand( $hThCpl, "", "[CLASS:SysTabControl32; INSTANCE:1]", $rightOrLeft )
   Until  (False)
   Return $resetTab
EndFunc
