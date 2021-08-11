!include "EnvVarUpdate.nsh"
!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"

Var Dialog
Var CentroLabel
Var CentroText
Var CentroState
Var CajaLabel
Var CajaText
Var CajaState
Var IpWSLabel
Var IpWSText
Var IpWSState

;--------------------------------
; Show install details
    ShowInstDetails show

;--------------------------------
;Interface Settings

    !define MUI_ABORTWARNING

Page custom nsDialogsPage nsDialogsPageLeave

Function nsDialogsPage

    nsDialogs::Create 1018
    Pop $Dialog

    ${If} $Dialog == error
        Abort
    ${EndIf}

    ${NSD_CreateLabel} 0 0 100% 12u "Centro:"
    Pop $CentroLabel

    ${NSD_CreateText} 0 13u 100% 12u $CentroState
    Pop $CentroText

    ${NSD_CreateLabel} 0 39u 100% 12u "Caja:"
    Pop $CajaLabel

    ${NSD_CreateText} 0 52u 100% 12u $CajaState
    Pop $CajaText
	
	${NSD_CreateLabel} 0 75u 100% 12u "IpWS:"
    Pop $IpWSLabel

    ${NSD_CreateText} 0 88u 100% 12u $IpWSState
    Pop $IpWSText

    nsDialogs::Show

FunctionEnd

Function nsDialogsPageLeave

    ${NSD_GetText} $CentroText $CentroState
	${NSD_GetText} $CajaText $CajaState
    ${NSD_GetText} $IpWSText $IpWSState

    ${If} $CentroState == ""
        MessageBox MB_OK "Centro es obligatorio."
        Abort
    ${EndIf}
	
	${If} $CajaState == ""
        MessageBox MB_OK "Caja es obligatorio."
        Abort
    ${EndIf}
	
	${If} $IpWSState == ""
        MessageBox MB_OK "IpWS es obligatorio."
        Abort
    ${EndIf}

    StrCpy $1 $CentroState
    StrCpy $2 $CajaState
	StrCpy $3 $IpWSState

	FileOpen $9 "C:\vds_config\credentials.json" w
    FileWrite $9 '{"centro":"$1", "caja":"$2", "ip":"$3"}'
    FileClose $9
    SetFileAttributes "C:\vds_config\credentials.json" READONLY
	

FunctionEnd

Section
SectionEnd


!macro customHeader
    
!macroend

!macro preInit
    
!macroend

!macro customInstall
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR"
!macroend

!macro customUnInstall
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
!macroend