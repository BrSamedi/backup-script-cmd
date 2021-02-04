@echo off

::set destination=%cd%\archive
::set destination="e:\Backup\archive"
set destination="\\RT-N56U\AiDisk_a1\Backup"
set passwd="Pa$$w0rd!"
set outdate="-1"
set start_wd=0
set end_wd=24

set dirBackupList="BackupList.txt"
set exludeFoldersFiles="Exclude.txt"

set h=%TIME:~0,2%
set hh=%TIME:~0,2%
set m=%TIME:~3,2%
set dd=%DATE:~0,2%
set mm=%DATE:~3,2%
set yyyy=%DATE:~6,4%
set curdate=%yyyy%_%mm%_%dd%_%h%_%m%
set curdate=%curdate: =0%

If Not Exist "%destination%" (md "%destination%")
for /F "usebackq tokens=*" %%A in (%dirBackupList%) do call :process %%A

:process
if "%1" EQU "" goto closing
set fileName=%1
set source="%2"
set folder=%destination%\%fileName%
IF %h% LSS %start_wd% (exit) else (if %h% GTR %end_wd% (exit) else goto backup)

:backup
If Not Exist %folder% (md %folder%)
"C:\Program Files\7-Zip\7z.exe" a -tzip -ssw -mx5 -p%passwd% -r0 -xr@%exludeFoldersFiles% "%destination%\%fileName%\%curdate%_backup_%fileName%.zip" "%source%"
pushd %folder% && forfiles /m *_backup_*.zip /s /d %outdate% /c "cmd /c del @path /q" & popd

:closing
echo backup finished