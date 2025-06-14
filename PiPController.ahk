
; Chrome Picture-in-Picture Controller
; Makes PiP window transparent and click-through by default
; Hold Shift to make it opaque and interactive

#NoEnv
#SingleInstance Force
SetBatchLines, -1
SetWinDelay, -1
CoordMode, Mouse, Screen

; Configuration
transparency := 80       ; Default transparency level (0-255, where 0 is invisible, 255 is opaque)
checkInterval := 50      ; How often to check mouse position (milliseconds)

; Variables
pipWindow := ""
isHovering := false

; Main loop
SetTimer, CheckMouseOverPiP, %checkInterval%
return

CheckMouseOverPiP:
    ; Get the mouse position
    MouseGetPos, mouseX, mouseY, windowUnderMouse, controlUnderMouse
    
    ; Find Picture-in-Picture window
    pipWindow := FindPiPWindow()
    
    if (pipWindow != "") {
        WinGetPos, pipX, pipY, pipWidth, pipHeight, ahk_id %pipWindow%
        
        ; Check if mouse is over the PiP window
        isMouseOverPiP := (mouseX >= pipX && mouseX <= pipX + pipWidth && mouseY >= pipY && mouseY <= pipY + pipHeight)
        
        if (isMouseOverPiP) {
            ; Check if Shift is pressed
            if (GetKeyState("Shift", "P")) {
                ; Make window fully opaque and clickable
                WinSet, Transparent, 255, ahk_id %pipWindow%
                WinSet, ExStyle, -0x20, ahk_id %pipWindow%
            } else {
                ; Make window semi-transparent and click-through
                WinSet, Transparent, %transparency%, ahk_id %pipWindow%
                WinSet, ExStyle, +0x20, ahk_id %pipWindow%
            }
            if (!isHovering) {
                isHovering := true
            }
        } else if (isHovering) {
            WinSet, Transparent, 255, ahk_id %pipWindow%
            WinSet, ExStyle, -0x20, ahk_id %pipWindow%
            isHovering := false
        }
    }
return

FindPiPWindow() {
    WinGet, id, ID, Picture-in-picture ahk_exe chrome.exe
    if (id)
        return id
    WinGet, id, ID, Picture in picture ahk_exe chrome.exe
    if (id)
        return id
    WinGet, id, ID, Picture-in-picture ahk_exe msedge.exe
    if (id)
        return id
    return ""
}

^!p::
    Suspend
    if (A_IsSuspended)
        TrayTip, PiP Controller, Script paused, 2
    else
        TrayTip, PiP Controller, Script resumed, 2
return

^!x::ExitApp
