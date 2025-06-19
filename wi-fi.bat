@echo off
:: Set console width and height (in characters)
mode con: cols=100 lines=30
setlocal enabledelayedexpansion
color 3
title Wi-Fi Password Viewer Tool

:menu
cls
echo ====================================================
echo             Wi-Fi Password Viewer Tool              
echo ====================================================
echo [1] View saved Wi-Fi networks
echo [2] Help / Instructions
echo [3] Exit
echo ----------------------------------------------------
set /p opt="Choose an option (1-3): "

if "%opt%"=="1" goto show_profiles
if "%opt%"=="2" goto help
if "%opt%"=="3" exit
echo Invalid choice. Try again.
pause
goto menu

:help
cls
echo -------------------- HELP --------------------------
echo This tool allows you to:
echo - List saved Wi-Fi profiles on this computer.
echo - Choose one using its number to view its password.
echo.
echo STEPS:
echo 1. Select option 1 from the main menu.
echo 2. Choose the network number.
echo 3. View the password and details.
echo ----------------------------------------------------
pause
goto menu

:show_profiles
cls
echo Retrieving Wi-Fi profiles...
set count=0
set "profile_file=%temp%\wifi_profiles.txt"
netsh wlan show profiles | findstr "All User Profile" > "%profile_file%"

:: Display list with numbers
for /f "tokens=1,* delims=:" %%A in ('type "%profile_file%"') do (
    set /a count+=1
    set "line=%%B"
    set "line=!line:~1!"
    set "wifi[!count!]=!line!"
    echo !count!. !line!
)

echo.
set /p choice="Enter the number of the Wi-Fi profile: "

:: Check and display password
if defined wifi[%choice%] (
    set "selected_wifi=!wifi[%choice%]!"
    cls
    echo Showing details for: !selected_wifi!
    echo --------------------------------------------
    netsh wlan show profile name="!selected_wifi!" key=clear
) else (
    echo Invalid selection.
)

pause
goto menu
