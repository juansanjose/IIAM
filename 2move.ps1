$cSource = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Linq;
using System.Text;
public class Clicker
{
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct INPUT
{ 
    public int type; // 0 = INPUT_MOUSE,
                            // 1 = INPUT_KEYBOARD
                            // 2 = INPUT_HARDWARE
    public MOUSEINPUT mi;
}

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct MOUSEINPUT
{
    public int    dx ;
    public int    dy ;
    public int    mouseData ;
    public int    dwFlags;
    public int    time;
    public IntPtr dwExtraInfo;
}

//This covers most use cases although complex mice may have additional buttons
//There are additional constants you can use for those cases, see the msdn page
const int MOUSEEVENTF_MOVED      = 0x0001 ;
const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
const int MOUSEEVENTF_WHEEL      = 0x0080 ;
const int MOUSEEVENTF_XDOWN      = 0x0100 ;
const int MOUSEEVENTF_XUP        = 0x0200 ;
const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

const int screen_length = 0x10000 ;

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx
[System.Runtime.InteropServices.DllImport("user32.dll")]
extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

public static void LeftClickAtPoint(int x, int y)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}

public static void RightClickAtPoint(int x, int y)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_RIGHTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}

}
'@
	

Add-Type -TypeDefinition $cSource -ReferencedAssemblies System.Windows.Forms,System.Drawing

#Send a click at a specified point
# while($k -ne 10){
#Start-Process notepad -WindowStyle maximized
 $Pos = [System.Windows.Forms.Cursor]::Position
 [Clicker]::RightClickAtPoint($Pos.X,$Pos.Y)
# Start-Sleep -Seconds 1

  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point( 10 , 10 )
#  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point( 1000 , 1 )

for (($i = 0), ($j = 0); ($i -le 1000); ($i=$i+4),($j=$j+4))
{
     Start-Sleep -Milliseconds 10

 [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point( $i ,  $j )
   

}
$Pos = [System.Windows.Forms.Cursor]::Position
[Clicker]::LeftClickAtPoint($Pos.X,$Pos.Y)
[Clicker]::RightClickAtPoint($Pos.X,$Pos.Y)  

for (($i = $Pos.X), ($j = $Pos.Y); ($i -gt 10); ($i=$i-4),($j=$j-4))
{
     Start-Sleep -Milliseconds 10

 [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point( $i ,  $j )
  

}

[Clicker]::LeftClickAtPoint($Pos.X,$Pos.Y)
[Clicker]::RightClickAtPoint($Pos.X,$Pos.Y)

 #$Pos = [System.Windows.Forms.Cursor]::Position
# [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point( (($Pos.X) + 10) , (($Pos.Y)+240) )
#[Clicker]::LeftClickAtPoint($Pos.X , $Pos.Y)
#[Clicker]::LeftClickAtPoint(1920 , 0)
# $k++
# }
#  $wshell = New-Object -ComObject Wscript.Shell

#  $wshell.Popup("Operation Completed",0,"Done",0x1)
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class DesktopWindows {
    public struct Rect {
       public int Left { get; set; }
       public int Top { get; set; }
       public int Right { get; set; }
       public int Bottom { get; set; }
    }

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hwnd, ref Rect rectangle);
}
'@

# $processName = 'notepad'
# $processesByName = [System.Diagnostics.Process]::GetProcessesByName($processName)

# foreach($process in $processesByName) {
#     if($process.MainWindowHandle -ne 0) {
#         $windowRect = [DesktopWindows+Rect]::new()
#         $return = [DesktopWindows]::GetWindowRect($process.MainWindowHandle,[ref]$windowRect)
#             if($return) {
#                 [PSCustomObject]@{ProcessName=$processName; ProcessID=$process.Id; MainWindowHandle=$process.MainWindowHandle; WindowTitle=$process.MainWindowTitle; Top=$windowRect.Top; Left=$windowRect.Left;}
#             }
#             else
#             {
#                 echo 'Failed to get window rect'
#             }
#     }
#     else
#     {
#         echo "No MainWindowHandle for $processName"
#     }
# }