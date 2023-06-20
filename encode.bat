@echo off
TITLE Av1 Encode 🐦

cls

setlocal enabledelayedexpansion

:: Set path 
set "AV1=%~dp0"

:: Correct path
cd "%AV1%"

:: Set paths
set path=%AV1%\dependencies\vapoursynth64-r62;%AV1%\dependencies\ffmpeg-5.1.2;%AV1%\dependencies\ffmpeg-latest;%AV1%\dependencies\mkvtoolnix;%AV1%\dependencies\svt-av1;%AV1%\dependencies\x264;%AV1%\dependencies\x265;%AV1%\dependencies\rav1e;%AV1%\dependencies\aom


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

:: set paramaters for av1an
set /p args=<%AV1%\params.txt

:: Recursively encode contents in input
set /a queue=1
for %%f in (input\*.webm input\*.mp4 input\*.mkv input\*.mov) do (

    echo ----------------------------
    echo  Encoding ^| !queueCounter! left in queue
    echo ````````````````````````````

    av1an.exe -i "%%f" -o ./output/output-%%~nf_!queue!.mkv %args%

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
