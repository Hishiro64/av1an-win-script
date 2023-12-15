@echo off
TITLE FFmpeg VP9

cls

setlocal enabledelayedexpansion

:: Set path 
set "FFMPEG=%~dp0"

:: Correct path
cd "%FFMPEG%"

:: Set path to FFmpeg
set path=%FFMPEG%\..\..\dependencies\ffmpeg-latest

:: Count how many in queue
set /a queueCounter=0

for %%f in (input\*.webm input\*.mp4 input\*.mkv input\*.mov) do (
    set /a queueCounter+=1
)

:: Exit on 0 files
if !queueCounter! == 0 (
    echo No files found in input directory.
    PAUSE
    EXIT /B
)

:: set paramaters for FFmpeg
set /p args=<%FFMPEG%\params.txt
set /p audio-args=<%FFMPEG%\audio-params.txt

:: Recursively run FFmpeg on the contents in input
set /a queue=1
for %%f in (input\*.webm input\*.mp4 input\*.mkv input\*.mov) do (

    echo ───────────────────────────────────
    echo  FFmpeg VP9 2-Pass ^| !queueCounter! left in queue
    echo ───────────────────────────────────

    ffmpeg.exe -i "%%f" %args% -pass 1 -an -f null -
    ffmpeg.exe -i "%%f" %args% -pass 2 %audio-args% ./output/output-%%~nf_!queue!.webm

    :: Delete the following line, if you want to keep input files in place
    MOVE "%%f" .\input\completed-inputs > nul

    set /a queue+=1
    set /a queueCounter-=1

    if !queueCounter! == 0 (
       echo.
       echo Finished Encoding
       echo.
       PAUSE
       EXIT /B
    )
)	
