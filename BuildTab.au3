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

Local $key_default = "default"
Local $key_target = "target"
Local $key_filer = "filer"

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
Local $BuildOptions_hWnd = 0
Local $BuildOptions_ConfigKey = 1
Local $BuildOptionsName[3] = ["Option1", "Option2", "Option3"]
Local $BuildOptionsCount = UBound($BuildOptionsName)
Local $BuildOptionsColMax = 4
Local $BuildOptionsRowMax = Ceiling($BuildOptionsCount / $BuildOptionsColMax)
Local $BuildOptionsTop = $target_top + $target_height + $Margin
Local $BuildOptionsHeight = $CtrlHeight + $GroupTopMargin + $GroupBottomMargin
Local $BuildOptions[$BuildOptionsCount][2]
GUICtrlCreateGroup("ビルドオプション", _
		CtrlCol(1, 1), $BuildOptionsTop, CtrlWidth(1), $BuildOptionsHeight)
GUIStartGroup()
Local $col = 1
Local $row = $BuildOptionsTop + $GroupTopMargin
For $i = 0 To $BuildOptionsCount - 1
	$BuildOptions[$i][$BuildOptions_hWnd] = GUICtrlCreateRadio($BuildOptionsName[$i], _
			GCtrlCol($col, $BuildOptionsColMax), $row, GCtrlWidth($BuildOptionsColMax), $CtrlHeight)
	$BuildOptions[$i][$BuildOptions_ConfigKey] = StringLower($BuildOptionsName[$i])

	$col += 1
	If $BuildOptionsColMax < $col Then
		$col = 1
		$row += $CtrlHeight
	EndIf
Next
GUICtrlCreateGroup("", -99, -99, 1, 1)

; ビルドパッケージ
Local $BuildPackage_hWnd = 0
Local $BuildPackage_ConfigKey = 1
Local $BuildPackageName[9] = [ _
		"Package1", "Package2", "Package3", _
		"Package4", "Package5", "Package6", _
		"Package7", "Package8", "Package9"]
Local $BuildPackageCount = UBound($BuildPackageName)
Local $BuildPackageColMax = 3
Local $BuildPackageRowMax = Ceiling($BuildPackageCount / $BuildPackageColMax)
Local $BuildPackageTop = $BuildOptionsTop + $BuildOptionsHeight + $Margin
Local $BuildPackageHeight = $CtrlHeight * $BuildPackageRowMax + $GroupTopMargin + $GroupBottomMargin
Local $BuildPackages[$BuildPackageCount][2]
GUICtrlCreateGroup("ビルドパッケージ", _
		CtrlCol(1, 1), $BuildPackageTop, CtrlWidth(1), $BuildPackageHeight)
Local $col = 1
Local $row = $BuildPackageTop + $GroupTopMargin
For $i = 0 To $BuildPackageCount - 1
	$BuildPackages[$i][$BuildPackage_hWnd] = GUICtrlCreateCheckbox($BuildPackageName[$i], _
			GCtrlCol($col, $BuildPackageColMax), $row, GCtrlWidth($BuildPackageColMax), $CtrlHeight)
	$BuildPackages[$i][$BuildPackage_ConfigKey] = StringLower($BuildPackageName[$i])

	$col += 1
	If $BuildPackageColMax < $col Then
		$col = 1
		$row += $CtrlHeight
	EndIf
Next
GUICtrlCreateGroup("", -99, -99, 1, 1)

; ボタン
Local $BuildButtonTop = $BuildPackageTop + $BuildPackageHeight + $Margin
Local $BuildButtonHeight = $BuildButtonTop + $ButtonHeight
Local $build_button = GUICtrlCreateButton("ビルド", CtrlCol(1, 3), $BuildButtonTop, CtrlWidth(3), $ButtonHeight)
Local $write_button = GUICtrlCreateButton("書込み", CtrlCol(2, 3), $BuildButtonTop, CtrlWidth(3), $ButtonHeight)
Local $open_button = GUICtrlCreateButton("オープン", CtrlCol(3, 3), $BuildButtonTop, CtrlWidth(3), $ButtonHeight)

;===============================================================================
; 初期値設定
;===============================================================================
; ビルドターゲット
__IniSetComboItem($target_combo, $ConfigFile, $section_build, $key_target)
__IniReadComboItemDefault($target_combo, $ConfigFile, $section_build)

; ビルドオプション
For $i = 0 To $BuildOptionsCount - 1
	Local $hWnd = $BuildOptions[$i][$BuildOptions_hWnd]
	Local $key = $BuildOptions[$i][$BuildOptions_ConfigKey]
	__IniReadCheckDefault($hWnd, $ConfigFile, $section_build, $key)
Next

; ビルドパッケージ
For $i = 0 To $BuildPackageCount - 1
	Local $hWnd = $BuildPackages[$i][$BuildPackage_hWnd]
	Local $key = $BuildPackages[$i][$BuildPackage_ConfigKey]
	__IniReadCheckDefault($hWnd, $ConfigFile, $section_build, $key)
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
	Local $fullpath = __UrlToFile($uri)

	Local $cmd = $app_filer & " """ & $fullpath & """"
	Run($cmd)
EndFunc   ;==>OpenButtonEvent

;===============================================================================
; イベントリスナ登録
;===============================================================================
OnAutoItExitRegister("BuildTabExit")

Func BuildTabExit()
	__IniWriteComboItemDefault($target_combo, $ConfigFile, $section_build)

	For $i = 0 To $BuildOptionsCount - 1
		Local $hWnd = $BuildOptions[$i][$BuildOptions_hWnd]
		Local $key = $BuildOptions[$i][$BuildOptions_ConfigKey]
		__IniWriteCheckDefault($hWnd, $ConfigFile, $section_build, $key)
	Next

	For $i = 0 To $BuildPackageCount - 1
		Local $hWnd = $BuildPackages[$i][$BuildPackage_hWnd]
		Local $key = $BuildPackages[$i][$BuildPackage_ConfigKey]
		__IniWriteCheckDefault($hWnd, $ConfigFile, $section_build, $key)
	Next
EndFunc   ;==>BuildTabEventClose
