; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; NSIS Installer script for DaisyDuck
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!include "languages\declaration.nsh"

!define PRODUCT_NAME "DaisyDuck Player"
!define PRODUCT_VERSION 1.0.1
!define PRODUCT_PUBLISHER "GeeXboX"
!define PRODUCT_UNINST_KEY \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Project settings
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name "DaisyDuck"
OutFile "daisyduck-win32-installer-${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\DaisyDuck"
BrandingText "${PRODUCT_NAME}"
ShowInstDetails show
ShowUninstDetails show
SetCompressor /SOLID /FINAL lzma
SetOverwrite ifnewer
CRCCheck on


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; UI settings
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!include MUI2.nsh
!define MUI_WELCOMEFINISHPAGE_BITMAP "side.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "side.bmp"
!define MUI_COMPONENTSPAGE_SMALLDESC

; Finish Page
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION ExecAppFile
!define MUI_FINISHPAGE_LINK $Link_VisitWebsite
!define MUI_FINISHPAGE_LINK_LOCATION "https://skywalker13.github.io/DaisyDuck/"


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Install Pages
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Uninstall Pages
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Sections
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Section "-$Name_SectionInstDaisyDuck"
  Call InstDaisyDuck
SectionEnd

Section $Name_SectionInstConfiguration SEC00
  Call InstConfig
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC00} $Desc_SectionInstConfiguration
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "-$Name_SectionWriteUninstaller"
  Call WriteUninstaller
SectionEnd

Section "-un.Uninstall"
  Call un.Uninstaller
SectionEnd

Section "un.$Name_SectionUninstConfiguration" SEC90
  Call un.UninstConfig
SectionEnd

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC90} $Desc_SectionUninstConfiguration
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Languages
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!insertmacro MUI_LANGUAGE "English" ; Default
!insertmacro MUI_LANGUAGE "French"


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Functions
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Function ExecAppFile
  Exec "$INSTDIR\bin\daisyduck.exe"
FunctionEnd

Function .onInit
  !include "languages\english.nsh"
  StrCmp $LANGUAGE ${LANG_FRENCH} French EndLanguageCmp

 French:
  !include "languages\french.nsh"
  Goto EndLanguageCmp

 EndLanguageCmp:
FunctionEnd

Function InstDaisyDuck
  SetOutPath "$INSTDIR"

  File /r "bin"
  File /r "usr"
  File "daisyduck.ico"

  CreateDirectory "$SMPROGRAMS\DaisyDuck"
  CreateShortCut "$SMPROGRAMS\DaisyDuck\DaisyDuck.lnk" \
    "$INSTDIR\bin\daisyduck.exe" "" "$INSTDIR\daisyduck.ico"
  CreateShortCut "$DESKTOP\DaisyDuck.lnk" \
    "$INSTDIR\bin\daisyduck.exe" "" "$INSTDIR\daisyduck.ico"
  CreateShortCut "$SMPROGRAMS\DaisyDuck\$Name_UninstallerLink.lnk" \
    "$INSTDIR\uninstall.exe"
FunctionEnd

Function InstConfig
  SetShellVarContext current
  SetOutPath "$APPDATA\DaisyDuck"

  CreateDirectory "$APPDATA\DaisyDuck"
  File /nonfatal "daisyduck.conf"
FunctionEnd

Function WriteUninstaller
  WriteUninstaller "$INSTDIR\uninstall.exe"

  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" \
    "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" \
    "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" \
    "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" \
    "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" \
    "NoModify" 1
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" \
    "NoRepair" 1
FunctionEnd

Function un.onInit
  !include "languages\english.nsh"
  StrCmp $LANGUAGE ${LANG_FRENCH} French EndLanguageCmp

 French:
  !include "languages\french.nsh"
  Goto EndLanguageCmp

 EndLanguageCmp:
FunctionEnd

Function un.Uninstaller
  Delete "$DESKTOP\DaisyDuck.lnk"
  RMdir /r "$SMPROGRAMS\DaisyDuck"
  RMDir /r /rebootok "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
FunctionEnd

Function un.UninstConfig
  RMDir /r /rebootok "$APPDATA\DaisyDuck"
FunctionEnd
