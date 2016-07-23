#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <Array.au3>
#include "lib/app/TeraTermInstall.au3"
#include "lib/utility/Event.au3"
Opt("GUIOnEventMode", 1)

;===============================================================================
; 定数定義
;===============================================================================
; メインウィンドウ関連定数
Global $MainWindowTitle = "AutoItAppTemplate"
Global $MainWindowWidth = 500
Global $MainWindowHeight = 500

; タブ関連定数
Global $MainTabWidth = 502
Global $MainTabHeight = 400
Global $MainTabLeftMargin = 5
Global $MainTabRightMargin = 7
Global $MainTabTopMargin = 30

; コントロール関連定数
Global $Margin = 5
Global $GroupTopMargin = 15
Global $GroupBottomMargin = 10

Global $CtrlHeight = 20
Global $ButtonHeight = 30

Global $CtrlWidth = $MainTabWidth - $MainTabLeftMargin - $MainTabRightMargin
Global $GCtrlWidth = $CtrlWidth - $Margin * 2

; 設定ファイル関連
Global $ConfigFile = "config.ini"

; アプリケーションデータ
Global $AppDir = @LocalAppDataDir & "\" & @ScriptName

;===============================================================================
; 実行ファイルの同梱
;===============================================================================
__TeraTermInclude($AppDir & "\teraterm\")

;===============================================================================
; 共通関数定義
;===============================================================================
; コントロールを横に指定個並べた場合の
; コントロールの横幅を取得する
Func CtrlWidth(Const $count, Const $space = 0, Const $width = $CtrlWidth)
	Return ($width - ($space * ($count - 1))) / $count
EndFunc   ;==>CtrlWidth

; コントロールを横に指定個並べた場合の
; コントロールの配置位置(x座標)を取得する
Func CtrlCol(Const $index, Const $count, Const $space = 0, Const $start = $MainTabLeftMargin, Const $width = $CtrlWidth)
	Return $start + (CtrlWidth($count, $space, $width) * ($index - 1)) + ($space * ($index - 1))
EndFunc   ;==>CtrlCol

; グループ内にコントロールを横に指定個並べた場合の
; コントロールの横幅を取得する
Func GCtrlWidth(Const $count, Const $width = $CtrlWidth)
	Return ($width - ($Margin * 2)) / $count
EndFunc   ;==>GCtrlWidth

; グループ内にコントロールを横に指定個並べた場合の
; コントロールの配置位置(x座標)を取得する
Func GCtrlCol(Const $index, Const $count, Const $start = $MainTabLeftMargin, Const $width = $CtrlWidth)
	Return $start + (GCtrlWidth($count, $width) * ($index - 1)) + $Margin
EndFunc   ;==>GCtrlCol

;===============================================================================
; メインウインドウ生成
;===============================================================================
Global $MainWindow = GUICreate($MainWindowTitle, $MainWindowWidth, $MainWindowHeight)

;===============================================================================
; ステータスバー生成
;===============================================================================
Local $StatusBarParts[3] = [75, 150, -1]
Global $StatusBar = _GUICtrlStatusBar_Create($MainWindow)
_GUICtrlStatusBar_SetParts($StatusBar, $StatusBarParts)
_GUICtrlStatusBar_SetText($StatusBar, "test", 1)

;===============================================================================
; タブ生成
;===============================================================================
GUICtrlCreateTab(0, 0, $MainTabWidth, $MainTabHeight)
#include "BuildTab.au3"
#include "ButtonTab.au3"
GUICtrlCreateTabItem("")

;===============================================================================
; イベント登録
;===============================================================================
GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")

; イベント定義
Func OnExit()
	If @GUI_WinHandle = $MainWindow Then
		Exit
	EndIf
EndFunc   ;==>OnExit

;===============================================================================
; メインウィンドウの表示
;===============================================================================
GUISetState(@SW_SHOW)
While 1
	Sleep(1000)
WEnd
