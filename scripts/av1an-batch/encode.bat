@echo off
TITLE Av1 Encode 🐦

cls

setlocal enabledelayedexpansion

:: Set path 
set "AV1=%~dp0"

:: Correct path
cd "%AV1%"

:: Set the base path variable
set PATH=%AV1%\..\..\dependencies

:: Append paths
for /D %%G in ("%AV1%\..\..\dependencies\*") do (
    set PATH=!PATH!;%%G
)

:: Count how many in queue
set /a queueCounter=0

for %%f in (input\*.webm input\*.mp4 input\*.mkv input\*.mov) do (
    set /a queueCounter+=1
)

:: Exit on 0 files
if !queueCounter! == 0 (
    echo No files found in input directory. Hint: Finished input files are moved into ".\input\completed-inputs"
    PAUSE
    EXIT /B
)

:: set paramaters for av1an
set /p args=<%AV1%\params.txt

:: Recursively encode contents in input
set /a queue=1
for %%f in (input\*.webm input\*.mp4 input\*.mkv input\*.mov) do (

    echo ----------------------------
    echo  Encoding ^| !queueCounter! left in queue
    echo ----------------------------

    :: Show full command being run
    echo av1an -i "%%f" -o "./output/output-%%~nf_!queue!.mkv" %args% > last_run
    bat --style plain,grid .\last_run
    echo.

    av1an -i "%%f" -o "./output/output-%%~nf_!queue!.mkv" %args%

    IF ERRORLEVEL 1 (
	    echo:
        echo:
        echo Error occurred while encoding "%%f"
        echo Could be params.txt, input file, or the script
	    echo:   Early exit...
	    echo:
        PAUSE
        EXIT /B
    ) ELSE (
        :: Delete the following line, if you still want to keep input files from moving
        MOVE "%%f" .\input\completed-inputs > nul
    )
    
    set /a queue+=1
    set /a queueCounter-=1

    if !queueCounter! == 0 (
       echo:
       echo:
       echo Finished Encoding
       echo:
       PAUSE
       EXIT /B
    )
)