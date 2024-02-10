@echo off
TITLE Av1an Run

cls

setlocal enabledelayedexpansion

:: Set path 
set "AV1=%~dp0"

:: Correct path
cd "%AV1%"

:: Set the base path variable
set PATH=%AV1%\dependencies

:: Append paths
for /D %%G in ("%AV1%\dependencies\*") do (
    set PATH=!PATH!;%%G
)

copy dependencies\ffmpeg-6.1.1\bin\*.dll .

:: run av1an.exe --version
start cmd.exe /k av1an.exe --version