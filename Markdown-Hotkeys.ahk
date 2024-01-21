; Markdown-Hotkeys
; Version 1.0 - Created by Schmurtz
; Date: 2024/01/21
; Compatibility: AutoHotKey 1.1

; Description:
; This script adds keyboard shortcuts to quickly create Markdown URL and code highlighting.
; While optimized for Discord, it can be used in other applications.

; Usage:
; =======

; Creating Hyperlinks (alt + K):
; -----------------------------
; - Press Alt + K to open the Hyperlink GUI.
;   - If text is selected, it will be used as the hyperlink text.
;   - If the clipboard contains a web address (starting with "http"), it will be automatically added as the URL.
; - Press Enter to confirm the data, and Escape to close the GUI.
; - The variable 'ShowUrlGui' can be adjusted to disable the GUI.

; Code Syntax Highlighting (alt + L):
; -----------------------------------
; - Select the portion of code you want to highlight.
; - Press Alt + L to open the Code Syntax Highlighting GUI.
; - Use the Up and Down arrows to select the programming language.
; - Press Enter to apply the syntax highlighting.


#Persistent
ShowUrlGui := 1
Menu, Tray, Icon, C:\Windows\system32\accessibilitycpl.dll,12

!K:: ; Hotkey to show the url GUI : alt + K

    ; Check if the clipboard content starts with "http" (case-insensitive)
    if (RegExMatch(Clipboard, "i)^\s*http"))
    {
        Httpclipboard := Clipboard
    }
    else
    {
        Httpclipboard := ""
    }

    ClipboardBackup := ClipboardAll ; Backup the current clipboard content

    Clipboard := ""

    Send, ^c ; Copy the currently selected text to the clipboard
    ClipWait, 0
    If (ErrorLevel)
        clipboardEmpty := 1
    Else
        clipboardEmpty := 0

    if not DllCall("IsClipboardFormatAvailable", "uint", 1) ; we check if the content is text
    {
        if clipboardEmpty = 0
        {
            ; Display a MsgBox if the clipboard does not contain text
            MsgBox, Something else than text is currently selected.
                return
        }
    }

    if ShowUrlGui = 1
    {
        Gui, Add, Text, x10 y13 w30, Text:
        Gui, Add, Edit, vText x45 y10 w600 h25, %Clipboard%

        Gui, Add, Text, x10 y45 w30 , URL:
        Gui, Add, Edit, vUrl x45 y45 w600 h25, %Httpclipboard%

        Gui, Add, Button, Default gButtonOK, OK
        Gui, -SysMenu ; Remove the system menu (close button)
        Gui, Color, 2989FF
        Gui, Show, , Markdown URL GUI ; Show the GUI

        if clipboardEmpty 
        {
            ControlFocus, Edit1, Markdown URL GUI
        }
        else
        {
            ControlFocus, Edit2, Markdown URL GUI
        }
    }
    else
    {
        Url := Httpclipboard
        text := Clipboard
        GoSub, ButtonOK ; Call the subroutine directly
    }
    ; Set focus to the second textbox
    Clipboard := ClipboardBackup
return

ButtonOK:
    Gui, Submit ; Submit the values entered in the textboxes
    Send {[}
    Send %Text%
    Send {]}{(}
    Send %Url%
    Send {)}
    if (Url = "")
    {
        Send {left}
    }
    Gui, Destroy ; Close the GUI
return

!L:: ; Hotkey to show the code syntaxe hiligh GUI : alt + K

    ClipboardBackup := ClipboardAll ; Save the current clipboard content

    Clipboard := ""

    Send, ^c ; Copy the selected text to the clipboard
    ClipWait, 0
    If (ErrorLevel)
        clipboardEmpty := 1
    Else
        clipboardEmpty := 0

    if not DllCall("IsClipboardFormatAvailable", "uint", 1) ; we check if the content is text
    {
        if clipboardEmpty = 0
        {
            ; Display a MsgBox if the selected object is not text
            MsgBox, Something else than text is currently selected.
                return
        }
    }else
    { 
        codeclipboard := Clipboard
    }

    ; Set focus to the second textbox
    Clipboard := ClipboardBackup
    gui, add, ListBox, w100 h100 Choose1 vCodeType,Triple quote|Single quote|shell|C|html|fix
    Gui, Add, Button, Default gButtonCode, OK
    Gui, Color, 2989FF
    Gui, -SysMenu ; Remove the system menu (close button)
    Gui, Show, , Language

return

ButtonCode:
    Gui, Submit
    ;MsgBox You selected: %CodeType%
    SetKeyDelay, 1, 1

    if CodeType = Single quote
    {
        QuoteNum := 1
        CodeType := " "
    }
    else
    {
        QuoteNum := 3
        CodeType := " "
    }

    Send {`` %QuoteNum%}%CodeType%+{enter}
    ClipboardBackup := ClipboardAll
    Clipboard := codeclipboard
    Send ^v+{enter} ; we use the clipboard and a ctrl + v to type faster
    ;Send %codeclipboard%+{enter}  
    Send {`` %QuoteNum%}{space}
    Clipboard := ClipboardBackup
    Gui, Destroy
return

GuiClose:
    Gui, Destroy
return

~Esc::Gui, Destroy

