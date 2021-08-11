!include LogicLib.nsh
 
Page Custom MyCustomPage MyCustomLeave
 
Function MyCustomPage
  ReserveFile "InstallOptionsFile.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "InstallOptionsFile.ini"
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "InstallOptionsFile.ini"
FunctionEnd
 
Function MyCustomLeave
  # Get control window handle.
  !insertmacro MUI_INSTALLOPTIONS_READ $R0 "InstallOptionsFile.ini" "Field 1" "HWND"
  # Check if text has been entered in field 1.
  !insertmacro MUI_INSTALLOPTIONS_READ $R1 "InstallOptionsFile.ini" "Field 1" "State"
  # Make field background red!
  ${If} $R1 == ""
    SetCtlColors $R1 0x000000 0xFF0000
    Abort # Go back to page.
  # Reset field colours.
  ${Else}
    SetCtlColors $R1 0x000000 0xFFFFFF
  ${EndIf}
FunctionEnd