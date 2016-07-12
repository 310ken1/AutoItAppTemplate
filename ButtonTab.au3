#include-once
#include <GUIConstantsEx.au3>
#include "lib/utility/Debug.au3"

;===============================================================================
; 定数定義
;===============================================================================
; タブ名
Local $title = "ボタン"

;===============================================================================
; タブ画面定義
;===============================================================================
GUICtrlCreateTabItem($title)
;GUICtrlSetState(-1, $GUI_SHOW) ; 初期表示指定

Local $row1 = $MainTabTopMargin
Local $row2 = $row1 + $ButtonHeight
Local $row3 = $row2 + $ButtonHeight
Local $button1 = GUICtrlCreateButton("button1", CtrlCol(1, 1), $row1, CtrlWidth(1), $ButtonHeight)
Local $button2 = GUICtrlCreateButton("button2", CtrlCol(1, 2), $row2, CtrlWidth(2), $ButtonHeight)
Local $button3 = GUICtrlCreateButton("button3", CtrlCol(2, 2), $row2, CtrlWidth(2), $ButtonHeight)
Local $button4 = GUICtrlCreateButton("button4", CtrlCol(1, 3), $row3, CtrlWidth(3), $ButtonHeight)
Local $button5 = GUICtrlCreateButton("button5", CtrlCol(2, 3), $row3, CtrlWidth(3), $ButtonHeight)
Local $button6 = GUICtrlCreateButton("button6", CtrlCol(3, 3), $row3, CtrlWidth(3), $ButtonHeight)

Local $group_top = $row3 + $ButtonHeight + $Margin
Local $group_height = $ButtonHeight * 3 + $GroupTopMargin + $GroupBottomMargin
Local $group = GUICtrlCreateGroup("グループ", CtrlCol(1, 1), $group_top, CtrlWidth(1), $group_height)
Local $group_row1 = $group_top + $GroupTopMargin
Local $group_row2 = $group_row1 + $ButtonHeight
Local $group_row3 = $group_row2 + $ButtonHeight
Local $group1 = GUICtrlCreateButton("group1", GCtrlCol(1, 1), $group_row1, GCtrlWidth(1), $ButtonHeight)
Local $group2 = GUICtrlCreateButton("group2", GCtrlCol(1, 2), $group_row2, GCtrlWidth(2), $ButtonHeight)
Local $group3 = GUICtrlCreateButton("group3", GCtrlCol(2, 2), $group_row2, GCtrlWidth(2), $ButtonHeight)
Local $group4 = GUICtrlCreateButton("group4", GCtrlCol(1, 3), $group_row3, GCtrlWidth(3), $ButtonHeight)
Local $group5 = GUICtrlCreateButton("group5", GCtrlCol(2, 3), $group_row3, GCtrlWidth(3), $ButtonHeight)
Local $group6 = GUICtrlCreateButton("group6", GCtrlCol(3, 3), $group_row3, GCtrlWidth(3), $ButtonHeight)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $groups_top = $group_top + $group_height + $Margin
Local $groups_height = $ButtonHeight * 2 + $GroupTopMargin + $GroupBottomMargin
Local $groups_row1 = $groups_top + $GroupTopMargin
Local $groups_row2 = $groups_row1 + $ButtonHeight
Local $groups_space = 2
Local $groups_col_max = 3
Local $groups_width = CtrlWidth($groups_col_max, $groups_space)
Local $groups_col1 = CtrlCol(1, $groups_col_max, $groups_space)
Local $groups_col2 = CtrlCol(2, $groups_col_max, $groups_space)
Local $groups_col3 = CtrlCol(3, $groups_col_max, $groups_space)
Local $groups = GUICtrlCreateGroup("グループ1", $groups_col1, $groups_top, $groups_width, $groups_height)
GUICtrlCreateButton("group1", GCtrlCol(1, 1, $groups_col1, $groups_width), $groups_row1, GCtrlWidth(1, $groups_width), $ButtonHeight)
GUICtrlCreateButton("group1-1", GCtrlCol(1, 2, $groups_col1, $groups_width), $groups_row2, GCtrlWidth(2, $groups_width), $ButtonHeight)
GUICtrlCreateButton("group1-2", GCtrlCol(2, 2, $groups_col1, $groups_width), $groups_row2, GCtrlWidth(2, $groups_width), $ButtonHeight)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Local $groups = GUICtrlCreateGroup("グループ2", $groups_col2, $groups_top, $groups_width, $groups_height)
GUICtrlCreateButton("group2", GCtrlCol(1, 1, $groups_col2, $groups_width), $groups_row1, GCtrlWidth(1, $groups_width), $ButtonHeight)
GUICtrlCreateButton("group2-1", GCtrlCol(1, 2, $groups_col2, $groups_width), $groups_row2, GCtrlWidth(2, $groups_width), $ButtonHeight)
GUICtrlCreateButton("group2-2", GCtrlCol(2, 2, $groups_col2, $groups_width), $groups_row2, GCtrlWidth(2, $groups_width), $ButtonHeight)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Local $groups = GUICtrlCreateGroup("グループ3", $groups_col3, $groups_top, $groups_width, $groups_height)
GUICtrlCreateButton("group1", GCtrlCol(1, 1, $groups_col3, $groups_width), $groups_row1, GCtrlWidth(1, $groups_width), $ButtonHeight)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $buttons[6] = [$button1, $button2, $button3, $button4, $button5, $button6]
Local $groups[6] = [$group1, $group2, $group3, $group4, $group5, $group6]

;===============================================================================
; イベント登録
;===============================================================================
For $b In $buttons
	GUICtrlSetOnEvent($b, "Event")
Next

For $g In $groups
	GUICtrlSetOnEvent($g, "Event")
Next

; イベント定義
Func Event()
	$output = ""
	Switch @GUI_CtrlId
		Case $button1
			$output = "1"
		Case $button2
			$output = "2"
		Case $button3
			$output = "3"
		Case $button4
			$output = "4"
		Case $button5
			$output = "5"
		Case $button6
			$output = "6"
		Case $group1
			$output = "g1"
		Case $group2
			$output = "g2"
		Case $group3
			$output = "g3"
		Case $group4
			$output = "g4"
		Case $group5
			$output = "g5"
		Case $group6
			$output = "g6"
	EndSwitch
	__p($output)
EndFunc   ;==>Event

