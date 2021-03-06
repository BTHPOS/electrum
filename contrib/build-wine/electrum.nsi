;--------------------------------
;Include Modern UI
  !include "TextFunc.nsh" ;Needed for the $GetSize function. I know, doesn't sound logical, it isn't.
  !include "MUI2.nsh"

;--------------------------------
;Variables

  !define PRODUCT_NAME "ElectrumBTH"
  !define PRODUCT_WEB_SITE "https://github.com/BTHPOS/electrum"
  !define PRODUCT_PUBLISHER "Bithereum Organization"
  !define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

;--------------------------------
;General

  ;Name and file
  Name "${PRODUCT_NAME}"
  OutFile "dist/electrumbth-setup.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\${PRODUCT_NAME}" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

  ;Specifies whether or not the installer will perform a CRC on itself before allowing an install
  CRCCheck on

  ;Sets whether or not the details of the install are shown. Can be 'hide' (the default) to hide the details by default, allowing the user to view them, or 'show' to show them by default, or 'nevershow', to prevent the user from ever seeing them.
  ShowInstDetails show

  ;Sets whether or not the details of the uninstall  are shown. Can be 'hide' (the default) to hide the details by default, allowing the user to view them, or 'show' to show them by default, or 'nevershow', to prevent the user from ever seeing them.
  ShowUninstDetails show

  ;Sets the colors to use for the install info screen (the default is 00FF00 000000. Use the form RRGGBB (in hexadecimal, as in HTML, only minus the leading '#', since # can be used for comments). Note that if "/windows" is specified as the only parameter, the default windows colors will be used.
  InstallColors /windows

  ;This command sets the compression algorithm used to compress files/data in the installer. (http://nsis.sourceforge.net/Reference/SetCompressor)
  SetCompressor /SOLID lzma

  ;Sets the dictionary size in megabytes (MB) used by the LZMA compressor (default is 8 MB).
  SetCompressorDictSize 64

  ;Sets the text that is shown (by default it is 'Nullsoft Install System vX.XX') in the bottom of the install window. Setting this to an empty string ("") uses the default; to set the string to blank, use " " (a space).
  BrandingText "${PRODUCT_NAME} Installer v${PRODUCT_VERSION}"

  ;Sets what the titlebars of the installer will display. By default, it is 'Name Setup', where Name is specified with the Name command. You can, however, override it with 'MyApp Installer' or whatever. If you specify an empty string (""), the default will be used (you can however specify " " to achieve a blank string)
  Caption "${PRODUCT_NAME}"

  ;Adds the Product Version on top of the Version Tab in the Properties of the file.
  VIProductVersion 1.0.0.0

  ;VIAddVersionKey - Adds a field in the Version Tab of the File Properties. This can either be a field provided by the system or a user defined field.
  VIAddVersionKey ProductName "${PRODUCT_NAME} Installer"
  VIAddVersionKey Comments "The installer for ${PRODUCT_NAME}"
  VIAddVersionKey CompanyName "${PRODUCT_NAME}"
  VIAddVersionKey LegalCopyright "2013-2018 ${PRODUCT_PUBLISHER}"
  VIAddVersionKey FileDescription "${PRODUCT_NAME} Installer"
  VIAddVersionKey FileVersion ${PRODUCT_VERSION}
  VIAddVersionKey ProductVersion ${PRODUCT_VERSION}
  VIAddVersionKey InternalName "${PRODUCT_NAME} Installer"
  VIAddVersionKey LegalTrademarks "${PRODUCT_NAME} is a trademark of ${PRODUCT_PUBLISHER}"
  VIAddVersionKey OriginalFilename "${PRODUCT_NAME}.exe"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_ABORTWARNING_TEXT "Are you sure you wish to abort the installation of ${PRODUCT_NAME}?"

  !define MUI_ICON "tmp\electrum\icons\electrumbth.ico"

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES

    # Setting for finish page
    !define MUI_FINISHPAGE_SHOWREADME
    !define MUI_FINISHPAGE_SHOWREADME_TEXT "Launch ${PRODUCT_NAME}"
    !define MUI_FINISHPAGE_SHOWREADME_FUNCTION RunApplication
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
Section "Start with Windows" SecStartup
SectionEnd

;--------------------------------
;Descriptions
  LangString DESC_SecStartup ${LANG_ENGLISH} "Run ${PRODUCT_NAME} on Windows Startup"

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartup} $(DESC_SecStartup)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Installer Sections

;Check if we have Administrator rights
Function .onInit
	UserInfo::GetAccountType
	pop $0
	${If} $0 != "admin" ;Require admin rights on NT4+
		MessageBox mb_iconstop "Administrator rights required!"
		SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
		Quit
	${EndIf}
FunctionEnd

Function RunApplication
  ExecShell "" "$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe"
FunctionEnd

Section
  SetOutPath $INSTDIR

  ;Uninstall previous version files
  RMDir /r "$INSTDIR\*.*"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
  Delete "$SMSTARTUP\${PRODUCT_NAME}.lnk"

  ;Files to pack into the installer
  File /r "dist\electrumbth\*.*"
  File "..\..\icons\electrumbth.ico"

  ;Store installation folder
  WriteRegStr HKCU "Software\${PRODUCT_NAME}" "" $INSTDIR

  ;Create uninstaller
  DetailPrint "Creating uninstaller..."
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;Create desktop shortcut
  DetailPrint "Creating desktop shortcut..."
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe" ""

  ;Create start-menu items
  DetailPrint "Creating start-menu items..."
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe" "" "$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME} Testnet.lnk" "$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe" "--testnet" "$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe" 0

  ;Links bithereumnetwork: URI's to ElectrumBTH
  WriteRegStr HKCU "Software\Classes\bithereumnetwork" "" "URL:bithereumnetwork Protocol"
  WriteRegStr HKCU "Software\Classes\bithereumnetwork" "URL Protocol" ""
  WriteRegStr HKCU "Software\Classes\bithereumnetwork" "DefaultIcon" "$\"$INSTDIR\electrumbth.ico, 0$\""
  WriteRegStr HKCU "Software\Classes\bithereumnetwork\shell\open\command" "" "$\"$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe$\" $\"%1$\""

  ;Adds an uninstaller possibility to Windows Uninstall or change a program section
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\electrumbth.ico"

  ;Fixes Windows broken size estimates
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKCU "${PRODUCT_UNINST_KEY}" "EstimatedSize" "$0"

  ${If} ${SectionIsSelected} ${SecStartup}
    CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\electrumbth-${PRODUCT_VERSION}.exe" ""
  ${EndIf}
SectionEnd

;--------------------------------
;Descriptions

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  RMDir /r "$INSTDIR\*.*"

  RMDir "$INSTDIR"

  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
  Delete "$SMSTARTUP\${PRODUCT_NAME}.lnk"
  RMDir  "$SMPROGRAMS\${PRODUCT_NAME}"

  DeleteRegKey HKCU "Software\Classes\bithereumnetwork"
  DeleteRegKey HKCU "Software\${PRODUCT_NAME}"
  DeleteRegKey HKCU "${PRODUCT_UNINST_KEY}"
SectionEnd
