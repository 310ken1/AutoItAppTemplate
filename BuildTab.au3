#include-once
#include <GUIConstantsEx.au3>
#include "lib/app/TeraTerm.au3"
#include "lib/utility/Debug.au3"
#include "lib/utility/Ini.au3"
#include "lib/utility/Template.au3"
#include "lib/utility/Uri.au3"

;===============================================================================
; 定数定義
;===============================================================================
; タブ名
Local $title = "ビルド"

; 設定ファイルのセクション名とキー名
Local $section_build = "build"
Local $section_settings = "settings"

Local $key_default = "default"
Local $key_target = "target"
Local $key_filer = "filer"

Local $key_option1 = "option1"
Local $key_option2 = "option2"
Local $key_option3 = "option3"
Local $key_package1 = "package1"
Local $key_package2 = "package2"
Local $key_package3 = "package3"
Local $key_package4 = "package4"
Local $key_package5 = "package5"
Local $key_package6 = "package6"
Local $key_package7 = "package7"
Local $key_package8 = "package8"
Local $key_package9 = "package9"

; アプリ
Local $app_filer = IniRead($ConfigFile, $section_build, $key_filer, 'explorer')

;===============================================================================
; タブ画面定義
;===============================================================================
GUICtrlCreateTabItem($title)
GUICtrlSetState(-1, $GUI_SHOW) ; 初期表示指定

; ビルドターゲット
Local $target_top = $MainTabTopMargin
Local $target_height = $CtrlHeight
Local $target_combo = GUICtrlCreateCombo("", CtrlCol(1, 1), $target_top, CtrlWidth(1), $CtrlHeight)

; ビルドオプション
Local $option_top = $target_top + $target_height + $Margin
Local $option_row1 = $option_top + $Margin * 3
Local $option_height = $CtrlHeight + $Margin * 4
Local $option_group = GUICtrlCreateGroup("ビルドオプション", $MainTabLeftMargin, $option_top, CtrlWidth(1), $option_height)
GUIStartGroup()
Local $option1_radio = GUICtrlCreateRadio("Option1", GCtrlCol(1, 3), $option_row1, GCtrlWidth(3), $CtrlHeight)
Local $option2_radio = GUICtrlCreateRadio("Option2", GCtrlCol(2, 3), $option_row1, GCtrlWidth(3), $CtrlHeight)
Local $option3_radio = GUICtrlCreateRadio("Option3", GCtrlCol(3, 3), $option_row1, GCtrlWidth(3), $CtrlHeight)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; ビルドパッケージ
Local $package_top = $option_top + $option_height + $Margin
Local $package_height = $CtrlHeight * 3 + $GroupTopMargin + $GroupBottomMargin
GUICtrlCreateGroup("ビルドパッケージ", $MainTabLeftMargin, $package_top, $CtrlWidth, $package_height)
Local $package_row1 = $package_top + $GroupTopMargin
Local $package_row2 = $package_row1 + $CtrlHeight
Local $package_row3 = $package_row2 + $CtrlHeight
Local $package1_check = GUICtrlCreateCheckbox("Package1", GCtrlCol(1, 3), $package_row1, GCtrlWidth(3), $CtrlHeight)
Local $package2_check = GUICtrlCreateCheckbox("Package2", GCtrlCol(2, 3), $package_row1, GCtrlWidth(3), $CtrlHeight)
Local $package3_check = GUICtrlCreateCheckbox("Package3", GCtrlCol(3, 3), $package_row1, GCtrlWidth(3), $CtrlHeight)
Local $package4_check = GUICtrlCreateCheckbox("Package4", GCtrlCol(1, 3), $package_row2, GCtrlWidth(3), $CtrlHeight)
Local $package5_check = GUICtrlCreateCheckbox("Package5", GCtrlCol(2, 3), $package_row2, GCtrlWidth(3), $CtrlHeight)
Local $package6_check = GUICtrlCreateCheckbox("Package6", GCtrlCol(3, 3), $package_row2, GCtrlWidth(3), $CtrlHeight)
Local $package7_check = GUICtrlCreateCheckbox("Package7", GCtrlCol(1, 3), $package_row3, GCtrlWidth(3), $CtrlHeight)
Local $package8_check = GUICtrlCreateCheckbox("Package8", GCtrlCol(2, 3), $package_row3, GCtrlWidth(3), $CtrlHeight)
Local $package9_check = GUICtrlCreateCheckbox("Package9", GCtrlCol(3, 3), $package_row3, GCtrlWidth(3), $CtrlHeight)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; ボタン
Local $button_top = $package_top + $package_height + $Margin
Local $button_height = $button_top + $ButtonHeight
Local $build_button = GUICtrlCreateButton("ビルド", CtrlCol(1, 3), $button_top, CtrlWidth(3), $ButtonHeight)
Local $write_button = GUICtrlCreateButton("書込み", CtrlCol(2, 3), $button_top, CtrlWidth(3), $ButtonHeight)
Local $open_button = GUICtrlCreateButton("オープン", CtrlCol(3, 3), $button_top, CtrlWidth(3), $ButtonHeight)

Local $options[3] = [$option1_radio, $option2_radio, $option3_radio]
Local $packages[3][3] = [ _
		[$package1_check, $package2_check, $package3_check], _
		[$package4_check, $package5_check, $package6_check], _
		[$package7_check, $package8_check, $package9_check]]

;===============================================================================
; 初期値設定
;===============================================================================
; ビルドターゲット
__IniSetComboItem($target_combo, $ConfigFile, $section_build, $key_target)
__IniReadComboItemDefault($target_combo, $ConfigFile, $section_build)

; ビルドオプション
Local $option_relation[3][2] = [ _
		[$option1_radio, $key_option1], _
		[$option2_radio, $key_option2], _
		[$option3_radio, $key_option3]]
For $i = 0 To UBound($option_relation) - 1
	Local $hWnd = $option_relation[$i][0]
	Local $key = $option_relation[$i][1]
	__IniReadCheckDefault($hWnd, $ConfigFile, $section_settings, $key)
Next

; ビルドパッケージ
Local $package_relation[9][2] = [ _
		[$package1_check, $key_package1], _
		[$package2_check, $key_package2], _
		[$package3_check, $key_package3], _
		[$package4_check, $key_package4], _
		[$package5_check, $key_package5], _
		[$package6_check, $key_package6], _
		[$package7_check, $key_package7], _
		[$package8_check, $key_package8], _
		[$package9_check, $key_package9]]
For $i = 0 To UBound($package_relation) - 1
	Local $hWnd = $package_relation[$i][0]
	Local $key = $package_relation[$i][1]
	__IniReadCheckDefault($hWnd, $ConfigFile, $section_settings, $key)
Next

;===============================================================================
; イベント登録
;===============================================================================
GUICtrlSetOnEvent($build_button, "BuildButtonEvent")
GUICtrlSetOnEvent($write_button, "WriteButtonEvent")
GUICtrlSetOnEvent($open_button, "OpenButtonEvent")

; イベント定義
Func BuildButtonEvent()
	Local $uri = GUICtrlRead($target_combo)
	Local $rule[3][2] = [ _
			["server", __UrlDomain($uri)], _
			["user", __UrlUser($uri)], _
			["password", __UrlPassword($uri)] _
			]
	Local $template = _
			"connect '{{server}} /ssh /auth=password /user={{user}} /passwd={{password}}" & @CRLF & _
			"wait '$'" & @CRLF & _
			"sendln 'ls'" & @CRLF & _
			"wait '$'" & @CRLF & _
			"sendln 'sleep 2 && exit'" & @CRLF

	Local $ttl = "build.ttl"
	FileWrite($ttl, __TemplateCompile($template, $rule))

	__TeraTermMacroRunWait($ttl)

	FileDelete($ttl)
EndFunc   ;==>BuildButtonEvent

Func WriteButtonEvent()
	MsgBox(0, "test", "write")
EndFunc   ;==>WriteButtonEvent

Func OpenButtonEvent()
	Local $uri = GUICtrlRead($target_combo)
	Local $fullpath = ""

	Local $server = __UrlDomain($uri)
	If $server <> "" Then
		$fullpath = '\\' & $server
	EndIf

	Local $path = __UrlPath($uri)
	If $path <> "" Then
		$fullpath = $fullpath & StringReplace($path, '/', '\')
	EndIf

	Local $cmd = $app_filer & " """ & $fullpath & """"
	__p($cmd)
	Run($cmd)
EndFunc   ;==>OpenButtonEvent

;===============================================================================
; イベントリスナ登録
;===============================================================================
RegisterEventClose("BuildTabEventClose")

Func BuildTabEventClose()
	__IniWriteComboItemDefault($target_combo, $ConfigFile, $section_build)

	For $i = 0 To UBound($option_relation) - 1
		Local $hWnd = $option_relation[$i][0]
		Local $key = $option_relation[$i][1]
		__IniWriteCheckDefault($hWnd, $ConfigFile, $section_settings, $key)
	Next

	For $i = 0 To UBound($package_relation) - 1
		Local $hWnd = $package_relation[$i][0]
		Local $key = $package_relation[$i][1]
		__IniWriteCheckDefault($hWnd, $ConfigFile, $section_settings, $key)
	Next
EndFunc   ;==>BuildTabEventClose
