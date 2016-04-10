#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <Array.au3>
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

;===============================================================================
; 実行ファイルの同梱
;===============================================================================
__TeraTermInclude(@TempDir & "\teraterm\")

;===============================================================================
; 共通関数定義
;===============================================================================
; コントロールを横に指定個並べた場合の
; コントロールの横幅を取得する
Func CtrlWidth(Const $count)
	Return $CtrlWidth / $count
EndFunc   ;==>CtrlWidth

; コントロールを横に指定個並べた場合の
; コントロールの配置位置(x座標)を取得する
Func CtrlCol(Const $index, Const $count)
	Return $MainTabLeftMargin + (CtrlWidth($count) * ($index - 1))
EndFunc   ;==>CtrlCol

; グループ内にコントロールを横に指定個並べた場合の
; コントロールの横幅を取得する
Func GCtrlWidth(Const $count)
	Return $GCtrlWidth / $count
EndFunc   ;==>GCtrlWidth

; グループ内にコントロールを横に指定個並べた場合の
; コントロールの配置位置(x座標)を取得する
Func GCtrlCol(Const $index, Const $count)
	Return $MainTabLeftMargin + (GCtrlWidth($count) * ($index - 1)) + $Margin
EndFunc   ;==>GCtrlCol

;===============================================================================
; クローズイベントリスナ
;===============================================================================
; イベントリスナ
Local $EventCloseListener[0]

; クローズイベントリスナを登録する
Func RegisterEventClose(Const $func)
	__EventRegister($EventCloseListener, $func)
EndFunc   ;==>RegisterEventClose

; クローズイベントリスナの登録を解除する
Func UnregisterEventClose(Const $func)
	__EventUnregister($EventCloseListener, $func)
EndFunc   ;==>UnregisterEventClose

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
GUISetOnEvent($GUI_EVENT_CLOSE, "EventClose")

; イベント定義
Func EventClose()
	__EventNotify($EventCloseListener)
	If @GUI_WinHandle = $MainWindow Then
		Exit
	EndIf
EndFunc   ;==>EventClose

;===============================================================================
; メインウィンドウの表示
;===============================================================================
GUISetState(@SW_SHOW)
While 1
	Sleep(1000)
WEnd
