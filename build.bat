@echo off
TITLE Av1an Build

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

:: install git from https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/PortableGit-2.43.0-64-bit.7z.exe
set PATH=!PATH!;%AV1%\dependencies\git\bin
git clone https://github.com/microsoft/vcpkg dependencies\vcpkg 2>nul
:: Clone av1an repo
git clone https://github.com/master-of-zen/Av1an source 2>nul
cd source
git pull
cd ..

set PATH=!PATH!;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\
set PATH=!PATH!;%SYSTEMROOT%\System32

:: TODO make this dynamic
set PATH=!PATH!;"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.38.33130\bin\Hostx64\x64"

::LLVM
:: powershell.exe Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
:: powershell.exe Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
:: scoop install main/llvm

cd dependencies\vcpkg\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -File bootstrap.ps1 >$null 2>&1

cd ..

::vcpkg update
git pull
vcpkg update
::vcpkg install 
::vcpkg install ffmpeg
::setx VCPKG_ROOT %AV1%\dependencies\vcpkg

REM :: make it build debug only
REM cd triplets
REM del x64-windows-dbg.cmake
REM ECHO set(VCPKG_TARGET_ARCHITECTURE x64) >> x64-windows-dbg.cmake
REM ECHO set(VCPKG_CRT_LINKAGE dynamic) >> x64-windows-dbg.cmake
REM ECHO set(VCPKG_LIBRARY_LINKAGE dynamic) >> x64-windows-dbg.cmake
REM ECHO set(VCPKG_BUILD_TYPE debug) >> x64-windows-dbg.cmake
REM cd ..
REM vcpkg install ffmpeg:x64-windows-dbg

REM :: make it build release only
REM cd triplets
REM del x64-windows-rel.cmake
REM ECHO set(VCPKG_TARGET_ARCHITECTURE x64) >> x64-windows-rel.cmake
REM ECHO set(VCPKG_CRT_LINKAGE dynamic) >> x64-windows-rel.cmake
REM ECHO set(VCPKG_LIBRARY_LINKAGE dynamic) >> x64-windows-rel.cmake
REM ECHO set(VCPKG_BUILD_TYPE release) >> x64-windows-rel.cmake
REM cd ..
REM vcpkg install ffmpeg:x64-windows-rel

::TOFIX
:: Install pkgconfig (pkgconf)
vcpkg install pkgconf --triplet x64-windows
copy dependencies\ffmpeg-6.1.1\lib\*.lib source > NUL
copy dependencies\vcpkg\packages\pkgconf_x64-windows\lib\pkgconf.lib source > NUL

:: FFMPEG_DIR
setx FFMPEG_DIR %AV1%\dependencies\ffmpeg-6.1.1

:: Clang
setx LIBCLANG_PATH %AV1%\dependencies\clang\bin

::Copy vs libs
cd "%AV1%"
copy dependencies\vapoursynth64\sdk\lib64\VapourSynth.lib source
copy dependencies\vapoursynth64\sdk\lib64\VSScript.lib source

:: assuming rust is installed
set PATH=!PATH!;C:\Users\%username%\.cargo\bin
cd source
git pull
::cargo build
cargo build -r

copy target\release\av1an.exe .. > NUL

pause