#Requires AutoHotkey v2.0+
#SingleInstance Force

masterToggle := true
alwaysAimToggle := false
aimGadgetToggle := false

F4::DoExit()
F1::Clicked
F2::Clicked_2 
F3::Clicked_3

MyGui := Gui(, "Brawl Bluestacks Controls")
MyGui.BackColor := "Black"
MyGui.SetFont("s8", "Courier New")
MyGui.Add("Button", "x50 y5 w90 h30 vResize", "RESIZE").OnEvent("Click", ResizeWindows)
MyGui.Add("Button", "w90 h30 vToggle", masterToggle ? "Toggle: ON" : "Toggle: OFF").OnEvent("Click", Clicked)
MyGui.Add("Button", "w90 h30 vToggle_2", alwaysAimToggle ? "Always Aim: ON" : "Always Aim: OFF").OnEvent("Click", Clicked_2)
MyGui.Add("Button", "w90 h30 vToggle_3", aimGadgetToggle ? "Aim Gadget: ON" : "Aim Gadget: OFF").OnEvent("Click", Clicked_3)
MyGui.Add("Button", "w90 h30", "EXIT").OnEvent("Click", DoExit)

MyGui.SetFont("s12", "Courier New")
MyGui.OnEvent("Close", DoExit)
MyGui.Show("w190 h190 y760")

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
    MyGui["Toggle_2"].text := alwaysAimToggle ? "Always Aim: ON" : "Always Aim: OFF"
    ToolTip(alwaysAimToggle ? "Always Aim: ON" : "Always Aim: OFF")
    SetTimer(() => ToolTip(), -1200)
}

Clicked_3(*) {
    
    global aimGadgetToggle := !aimGadgetToggle
    MyGui["Toggle_3"].text := aimGadgetToggle ? "Aim Gadget: ON" : "Aim Gadget: OFF"
    ToolTip(aimGadgetToggle ? "Aim Gadget: ON" : "Aim Gadget: OFF")
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
            WinMove(, , 1174, 708)
        }
        else {
            OutputDebug("EXPANDED`n")
            WinMove(, , 1220, 708)
        }

        OutputDebug("Window: X" wX " Y" wY " - " wW "x" wH "`n")
        OutputDebug("Client: " cW "x" cH "`n")
    }
    else {
        OutputDebug "Bluestacks window not found`n"
    }

    if WinExist("PL Prodigy") {
        WinActivate
        WinMove(1212, 0, 716, 1034)
    }
    else {
        OutputDebug "PL Prodigy window not found`n"
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

    ;*F13::F8
    ;~*F8 up::RestoreMovement()

    *~a:: {
        if (GetKeyState("d")) {
            Send("{d up}")
        }
    }
    *~a up:: {
        if (GetKeyState("d", "P")) {
            SendLevel 1
		    SendEvent("{d down}")
        }
    }

    *~d:: {
        if (GetKeyState("a")) {
            Send("{a up}")
        } 
    }
    *~d up:: {
        if (GetKeyState("a", "P")) {
            SendLevel 1
		    SendEvent("{a down}")
        } 
    }

    *e:: {        
        if( GetKeyState("RButton")){
            Send("{XButton1}")
            Send("{RButton up}")
            sleep 150
        }

        Send("{e down}")
        KeyWait("e")
        Send("{e up}")
    }

    *Space:: {
        if(GetKeyState("LShift")) {
            return
        }
        if( GetKeyState("RButton")){
            Send("{XButton1}")
            Send("{RButton up}")
            sleep 150
        }
                    
		Send("{Space down}")
        KeyWait("Space")
        Send("{Space up}")
    }

    *LShift:: {
        if(GetKeyState("RButton")) {
            Send("{XButton1}")
            Send("{RButton up}")
            sleep 150
        }
        if(GetKeyState("Space")) {
            Send("{Space up}")
            sleep 150
        }

		SendEvent("{LShift down}")
        KeyWait("LShift")
        Send("{LShift up}")
        
        if(GetKeyState("Space", "P")) {
            sleep 20
		    Send("{Space down}")
            KeyWait("Space")
            Send("{Space up}")
        }
        if(GetKeyState("RButton", "P")) {
            sleep 20
            SendLevel 1
		    SendEvent("{RButton down}")
        }
    }

    *LCtrl:: {
        if( GetKeyState("RButton")){
            Send("{XButton1}")
            Send("{RButton up}")
            sleep 150
        }

        Send("{LCtrl down}")
        KeyWait("LCtrl")
        Send("{LCtrl up}")        
    }

    *XButton1:: {        
		static deltaTime := A_TickCount-300
		if(A_TickCount - deltaTime < 300)
			return
		deltaTime := A_TickCount

        Send("{XButton1}")
        
		if(GetKeyState("RButton")) {
            Send("{RButton up}")
        }
        if(GetKeyState("MButton")) {
            Send("{MButton up}")
        }
    }

	;*XButton2:: {}

    t::{
		sleepTime := 25        

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
#Hotif masterToggle and aimGadgetToggle
   *f:: {
        if( GetKeyState("RButton")){
            pressDown := true
            Send("{XButton1}")
            Send("{RButton up}")
            sleep 150
        }

        
            Send("{f down}")
            KeyWait("f")
            Send("{f up}")
        
        
    }
#HotIf alwaysAimToggle && masterToggle && !WinExist("BlueStacks Keymap Editor") && WinActive("ahk_class Qt672QWindowIcon")
    RButton::{
        if(GetKeyState("RButton", "L")) {
            Send("{RButton up}")
            sleep 50
            Send("{RButton down}")
        }
        else {
            Send("{RButton down}")
        }
    }

    *MButton:: {
        if(GetKeyState("RButton")) {
            Send("{XButton1}")
            Send("{RButton up}")
            sleep 150
        }
        
        Send("{MButton down}")
        waitTime := A_TickCount
        KeyWait("MButton")
        waitTime := A_TickCount - waitTime
        if (waitTime < 20)
            sleep 20        
        Send("{MButton up}")         
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