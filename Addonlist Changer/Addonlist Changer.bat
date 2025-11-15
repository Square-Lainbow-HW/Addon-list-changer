@echo off
title Addonlist Changer

set "folderPath=default"

for /f "tokens=1* delims==" %%a in ('type "AddonListDirectory.cfg"') do (
    set "folderPath=%%a"
)

set "addoninfoName=addonlist"

set "workshopfolderName=workshop"
set "workshopBackupName=backup"

set "folderWorkshopPath=%folderPath%\addons\%workshopfolderName%"
set "folderWorkshopBACKUP=%folderPath%\addons\%workshopBackupName%"

set "addoninfoPath=%folderPath%\%addoninfoName%.txt"
set "TurnedOffAddon=%folderPath%\%addoninfoName%_origin.txt"

if not exist "%addoninfoPath%" (
	echo there is no file named "%addoninfoName%.txt"
	echo in your "%folderPath%"
	echo Try Editing AddonListDirectory.cfg directory where it has addonlist.txt
	echo directory example: "C:\Program Files\Steam\steamapps\common\Left 4 Dead 2\left4dead2"
	pause
	exit
)

color 0A

echo Press 1 to turn off all addons
echo Press 2 to stop addon getting removed from hammer map testing
echo Press 3 to back to normal

set /p value=
if %value% == 1 goto offaddons
if %value% == 2 goto addonreadonly
if %value% == 3 goto normal

:offaddons

if exist "%TurnedOffAddon%" (
	echo this file exists. or probably was set. try doing back to normal
	pause
	exit
)
copy "%addoninfoPath%" "%TurnedOffAddon%"

echo Editing addoninfo to turn off all...

attrib -R "%addoninfoPath%"

set "search="1""
set "replace="0""
set "newtxtFile=%folderPath%\%addoninfoName%_replaced.txt"

for /f "delims=" %%a in ('type "%addoninfoPath%"') do (
    set "line=%%a"
	
    setlocal enabledelayedexpansion
    
    echo !line:%search%=%replace%!>>"%newtxtFile%"
    endlocal
)

del "%addoninfoPath%"
ren "%newtxtFile%" "%addoninfoName%.txt"



echo Set addoninfo as read-only...
attrib +R "%addoninfoPath%"

echo Done turned off addons
pause
exit





:addonreadonly

if exist "%TurnedOffAddon%" (
	echo this file exists. or probably was set. try doing back to normal
	pause
	exit
)

if exist "%folderWorkshopBACKUP%" (
	echo workshop backup folder detected. stopping function...
	pause
	exit
)

echo cloning addoninfo as a backup
copy "%addoninfoPath%" "%TurnedOffAddon%"

echo replacing "workshop\" to "backup\"

attrib -R "%addoninfoPath%"

set "search=%workshopfolderName%\"
set "replace=%workshopBackupName%\"
set "newtxtFile=%folderPath%\%addoninfoName%_replaced.txt"

for /f "delims=" %%a in ('type "%addoninfoPath%"') do (
    set "line=%%a"
	
    setlocal enabledelayedexpansion
    
    echo !line:%search%=%replace%!>>"%newtxtFile%"
    endlocal
)

del "%addoninfoPath%"
ren "%newtxtFile%" "%addoninfoName%.txt"

echo Set addoninfo as read-only...
attrib +R "%addoninfoPath%"

echo Renaming workshop folder to backup
ren "%folderWorkshopPath%" "%workshopBackupName%"

echo Adding workshop folder as a fake
md "%folderWorkshopPath%"

echo Done turned off addons
pause
exit




:normal

if exist "%folderWorkshopBACKUP%" (
	if exist "%folderWorkshopPath%" (
		echo workshop backup detected. removing the fake workshop folder
	
		rmdir /s /q "%folderWorkshopPath%"
	)

	echo renaming backup to workshop...
	ren "%folderWorkshopBACKUP%" "%workshopfolderName%"	
)

if exist "%TurnedOffAddon%" (
	echo Cloned AddonInfo file detected
	
	attrib -R "%addoninfoPath%"
	del "%addoninfoPath%"

	echo renaming file...
	ren "%TurnedOffAddon%" "%addoninfoName%.txt"
	
) else (
	echo Disabling read-only...
	attrib -R "%addoninfoPath%"
)

echo Done return back to normal

pause
exit

