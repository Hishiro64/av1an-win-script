@echo off
TITLE Av1an Build

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

:: install git from https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/PortableGit-2.43.0-64-bit.7z.exe
set PATH=!PATH!;%AV1%\..\..\dependencies\git\bin
git clone https://github.com/microsoft/vcpkg ..\..\dependencies\vcpkg 2>nul

set PATH=!PATH!;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\

::LLVM
:: powershell.exe Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
:: powershell.exe Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
:: scoop install main/llvm

cd ..\..\dependencies\vcpkg\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -File bootstrap.ps1 --quiet --no-verbose >$null 2>&1
::vcpkg install 
cd ..
:: make it build release only
cd triplets
del x64-windows-rel.cmake
ECHO set(VCPKG_TARGET_ARCHITECTURE x64) >> x64-windows-rel.cmake
ECHO set(VCPKG_CRT_LINKAGE dynamic) >> x64-windows-rel.cmake
ECHO set(VCPKG_LIBRARY_LINKAGE dynamic) >> x64-windows-rel.cmake
ECHO set(VCPKG_BUILD_TYPE release) >> x64-windows-rel.cmake
cd ..
vcpkg install ffmpeg:x64-windows-rel --vcpkg-root=..\..\dependencies\vcpkg

:: Clone av1an repo
git clone https://github.com/master-of-zen/Av1an ..\..\source 2>nul

::Copy vs libs
cd "%AV1%"
copy ..\..\dependencies\vapoursynth64\sdk\lib64\VapourSynth.lib ..\..\source > NUL
copy ..\..\dependencies\vapoursynth64\sdk\lib64\VSScript.lib ..\..\source > NUL

:: assuming rust is installed
set PATH=!PATH!;C:\Users\%username%\.cargo\bin
cd ..\..\source
cargo build -r

copy target\release\av1an.exe .. > NUL

pause