
ECHO OFF
CLS
:MENU
ECHO.
ECHO ...............................................
ECHO PRESS 1, 2, 3 OR 4 to select your task, or 0 to EXIT.
ECHO ...............................................
ECHO.
ECHO 1 - See IP Address
ECHO 2 - See Macaddress
ECHO 3 - List All Wifi
ECHO 4 - List All Wifi Password
ECHO 0 - EXIT
ECHO.
SET /P M=Type 1, 2, 3, 4 or 0 then press ENTER:
ECHO.

IF %M%==1 GOTO List_ip_address
IF %M%==2 GOTO List_Mac
IF %M%==3 GOTO List_Wifi
IF %M%==4 GOTO All_Wifi_Passwords
IF %M%==0 GOTO EOF

:List_ip_address
NETSH INT IP SHOW CONFIG | FINDSTR /R "Configuration for interface.* Address.*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"
GOTO MENU

:List_Mac
setlocal enableDelayedExpansion
set MACLIST=01-02-03-04-05-06 AA-BB-CC-DD-EE-FF
for /f "delims=" %%a in ('ipconfig /all') do (
    set line=%%a
    if not "!line:~0,1!"==" " if not "!line:adapter=!"=="!line!" (
        set name=!line:*adapter =!
        set name=!name::=!
    )
    for /f "tokens=1,2,*" %%b in ("%%a") do (
        if "%%b %%c"=="Physical Address." (
            set mac=%%d
            set mac=!mac:*: =!
            echo !name!: !mac!
            call set mactest=%%MACLIST:!mac!=%%
            if not "!MACLIST!"=="!mactest!" (
                netsh interface set interface name="!name!" newname="newNetworkName1"
                netsh int ip set address "newNetworkName1" static 192.168.0.101 255.255.255.0 0.0.0.0
            )
        )
    )
)

GOTO MENU

:List_Wifi
netsh wlan show profile
GOTO MENU
:All_Wifi_Passwords
setlocal enabledelayedexpansion

for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do ( 
    set wifi_pwd=
    for /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| find "Key Content"`) do (
        set wifi_pwd=%%F
    )
    echo %%a : !wifi_pwd!
)
GOTO MENU
:BOTH
cd %windir%\system32\notepad.exe
start notepad.exe
cd %windir%\system32\calc.exe
start calc.exe
GOTO MENU


@echo off

