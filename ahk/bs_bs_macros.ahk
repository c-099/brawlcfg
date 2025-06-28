#Requires AutoHotkey v2.0+
#SingleInstance Force

masterToggle := true
alwaysAimToggle := true

F4::DoExit()
F1::Clicked
F2::Clicked_2 

MyGui := Gui(, "Brawl Bluestacks Controls")
MyGui.BackColor := "Black"
MyGui.SetFont("s8", "Courier New")
MyGui.Add("Button", "x50 y5 w90 h30 vResize", "RESIZE").OnEvent("Click", ResizeWindows)
MyGui.Add("Button", "w90 h30 vToggle", masterToggle ? "Toggle: ON" : "Toggle: OFF").OnEvent("Click", Clicked)
MyGui.Add("Button", "w90 h30 vToggle_2", alwaysAimToggle ? "Toggle_2: ON" : "Toggle_2: OFF").OnEvent("Click", Clicked_2)
MyGui.Add("Button", "w90 h30", "EXIT").OnEvent("Click", DoExit)

MyGui.SetFont("s12", "Courier New")
MyGui.OnEvent("Close", DoExit)
MyGui.Show("w190 h150 y760")

DoExit(*) {
    if GetKeyState("RButton", "L")
            Send("{RButton up}")

    if GetKeyState("MButton", "L")
        Send("{MButton up}")

    ExitApp
}

Clicked(*) {
    global masterToggle := !masterToggle
    MyGui["Toggle"].text := masterToggle ? "Toggle: ON" : "Toggle: OFF"
    ToolTip(masterToggle ? "Toggle: ON" : "Toggle: OFF")
    SetTimer(() => ToolTip(), -1200)
}

Clicked_2(*) {
     if (GetKeyState("RButton", "L")) {
        Send("{RButton up}")
    }
    global alwaysAimToggle := !alwaysAimToggle
    MyGui["Toggle_2"].text := alwaysAimToggle ? "Toggle_2: ON" : "Toggle_2: OFF"
    ToolTip(alwaysAimToggle ? "Toggle_2: ON" : "Toggle_2: OFF")
    SetTimer(() => ToolTip(), -1200)
}

ResizeWindows(*) {
    MyGui["Resize"].Enabled := false 
    MyGui["Resize"].text := "Resizing..."
    if (WinExist("ahk_class Qt672QWindowIcon")) {
        WinActivate
        WinGetPos(&wX, &wY, &wW, &wH)

        while (wX != 0) { ;bluestacks doesn't like being moved
            WinMove(0, 0)
            sleep 200
            WinGetPos(&wX, &wY, &wW, &wH)
            OutputDebug("wX:" wX "`n")
        }

        try ControlGetPos(&cX, &cY, &cW, &cH, "BlueStacksApp1", "ahk_class Qt672QWindowIcon")
        catch {
            OutputDebug "ControlGetPos Failed`n"
            ExitApp
        }

        if (cW + 3 = wW) {
            OutputDebug("COLLAPSED`n")
            WinMove(, , 1244, 749)
        }
        else {
            OutputDebug("EXPANDED`n")
            WinMove(, , 1292, 749)
        }

        OutputDebug("Window: X" wX " Y" wY " - " wW "x" wH "`n")
        OutputDebug("Client: " cW "x" cH "`n")
    }
    else {
        OutputDebug "Bluestacks window not found`n"
    }

    if WinExist("Power League Prodigy") {
        WinActivate
        WinMove(1232, 0, 697, 1030)
    }
    else {
        OutputDebug "Power League Prodigy window not found`n"
    }
    MyGui["Resize"].Enabled := true 
    MyGui["Resize"].text := "Resize"
}

RestoreMovement() {
	if(GetKeyState("w"))
		send("{w up}")
	if(GetKeyState("a"))
		send("{a up}")
	if(GetKeyState("s"))
		send("{s up}")
	if(GetKeyState("d"))
		send("{d up}")

	if(GetKeyState("w", "P"))
		send("{w down}")
	if(GetKeyState("a", "P"))
		send("{a down}")
	if(GetKeyState("s", "P"))
		send("{s down}")
	if(GetKeyState("d", "P"))
		send("{d down}")
}

#HotIf masterToggle && !WinExist("BlueStacks Keymap Editor") && WinActive("ahk_class Qt672QWindowIcon")
    WheelUp::return	
	WheelDown::return

    ~F11::
    ~!Tab:: {
    if (GetKeyState("RButton", "L"))
        Send("{RButton up}")
    }

    ; WheelUp:: {
    ;     Send("{MButton up}")
    ; }
	; WheelDown:: {
    ;     static sTime := A_TickCount-400
    ;     if(A_TickCount - sTime < 400)
    ;         return
    ;     sTime := A_TickCount
    ;     if(GetKeyState("RButton", "L")) {
    ;         Send("{XButton1}")
    ;         sleep 150
    ;     }
    ;     Send("{MButton down}")
    ; }
    *F13::F8
    ~F8 up::RestoreMovement()
    F10::^+a  

    *a up:: {
        Send("{a up}")

        if (GetKeyState("d", "P")) {
            Send("{d down}")
        }
    }
    *a:: {
        if (GetKeyState("d")) {
            Send("{d up}")
        }

        Send("{a down}")    
    }

    *d up:: {
        Send("{d up}")

        if (GetKeyState("a", "P")) {
            Send("{a down}")
        }
    }
    *d:: {
        if (GetKeyState("a")) {
            Send("{a up}")
        }

        Send("{d down}")    
    }

    ~XButton1:: {
        sleep 30
        if GetKeyState("RButton", "L")
            Send("{RButton up}")

        if GetKeyState("MButton", "L")
            Send("{MButton up}")
    }

	XButton2:: {
		static deltaTime := A_TickCount-300
		if(A_TickCount - deltaTime < 300)
			return
		deltaTime := A_TickCount

		if(GetKeyState("RButton"))
			Click("up, right")

		send("{F8 down}")
		sleep 70
		send("{f down}{f up}")
		SendLevel 1
		SendEvent "{F8 up}"
	}

    *LShift:: {
        if( GetKeyState("RButton", "L")){
            Send("{XButton1}")
            sleep 170
        }
                    
		Send("{LShift}")
		Loop {
            sleep 150
            if( !GetKeyState("LShift", "P"))
				break

			Send("{LShift}")
		}
    }

	*Space:: {
        pressDown := false
        if( GetKeyState("RButton")){
            pressDown := true
            Send("{XButton1}")
            sleep 20        
            Send("{RButton up}")
            sleep 100        
        }
                    
		Send("{Space}")
		Loop {
            sleep 150
            if( !GetKeyState("Space", "P"))
				break

			Send("{Space}")
		}

        if (pressDown) {
            Send("{RButton down}")
            sleep 10
        }
	}

    t::{
		sleepTime := 30        

		send("{w up}{a up}{s up}{d up}")
		Loop {
            w_sleep := 0
            a_sleep := 0
            s_sleep := 0
            d_sleep := 0
			if ( GetKeyState("w", "P") ) {
                w_sleep := sleepTime
			}
            if ( GetKeyState("a", "P") ) {
                a_sleep := sleepTime
            }
            if ( GetKeyState("s", "P") ) {
                s_sleep := sleepTime
            }
            if ( GetKeyState("d", "P") ) {
                d_sleep := sleepTime
            }
			

			if(!GetKeyState("w")) {				
				Send("{w down}")
				sleep sleepTime
			}
			Send("{a down}")
			sleep sleepTime + w_sleep
			Send("{w up}")
			sleep sleepTime
			Send("{s down}")
			sleep sleepTime + a_sleep
			Send("{a up}")
			sleep sleepTime
			Send("{d down}")
			sleep sleepTime + s_sleep
			Send("{s up}")
			sleep sleepTime
			Send("{w down}")
			sleep sleepTime + d_sleep
			Send("{d up}")
			
			if(!GetKeyState("t", "P"))
				break

			sleep sleepTime
		}

		RestoreMovement()
	}

#HotIf alwaysAimToggle && masterToggle && !WinExist("BlueStacks Keymap Editor") && WinActive("ahk_class Qt672QWindowIcon")
    RButton::{
        if(GetKeyState("RButton", "L")) {
            Send("{RButton up}")
            sleep 30
            Send("{RButton down}")
        }
        else {
            Send("{RButton down}")
        }
    }

    *MButton:: {
        pressDown := false
        if(GetKeyState("RButton", "L")) {
            pressDown := true
            Send("{XButton1}")
            sleep 160
        }
        
        Send("{MButton down}")
        waitTime := A_TickCount
        KeyWait("MButton")
        waitTime := A_TickCount - waitTime
        if (waitTime < 50)
            sleep 50        
        Send("{MButton up}")

         if (pressDown) {
            Send("{RButton up}")
            sleep 10
            Send("{RButton down}")
         }
    }

    *LButton:: {
        if(GetKeyState("RButton")) {
            Send("{RButton up}")
            sleep 10            
        }
         
        Send("{LButton down}")
        KeyWait("LButton")
        Send("{LButton up}")
    }