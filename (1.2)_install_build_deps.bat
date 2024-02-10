@echo off
TITLE Av1an Win Build Script 🐦

cls

setlocal enabledelayedexpansion 

:: Set path 
set "AV1=%~dp0"

:: Set Wget command
set "Download-->=%AV1%\wget.exe -q -N --no-check-certificate --show-progress"

:: Set 7zr command
set "Extract-->=%AV1%\7zr.exe -y x"

:: Correct path
cd "%AV1%"

echo ---------------------
echo Installing Build deps
echo ---------------------

:: Download portable Wget
curl -O -C - --progress-bar https://web.archive.org/web/20230511215002/https://eternallybored.org/misc/wget/1.21.4/64/wget.exe

:: Download portable 7zip
%Download-->% https://www.7-zip.org/a/7zr.exe

:: Download nasm from https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/win64/nasm-2.16.01-win64.zip
%Download-->% https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/win64/nasm-2.16.01-win64.zip
tar -xf .\nasm-2.16.01-win64.zip --strip-components 1 -C dependencies\nasm

:: Download git from https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/PortableGit-2.43.0-64-bit.7z.exe
%Download-->% https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/PortableGit-2.43.0-64-bit.7z.exe
%Extract-->% PortableGit-2.43.0-64-bit.7z.exe -odependencies\git > nul

:: Download clang from https://github.com/vovkos/llvm-package-windows/releases/download/clang-master/clang-13.0.0-windows-amd64-msvc15-msvcrt.7z
%Download-->% https://github.com/vovkos/llvm-package-windows/releases/download/clang-master/clang-13.0.0-windows-amd64-msvc15-msvcrt.7z
tar -xf clang-13.0.0-windows-amd64-msvc15-msvcrt.7z --strip-components=1 -C dependencies\clang > nul

:: Download vs build tools
%Download-->% https://aka.ms/vs/17/release/vs_BuildTools.exe
::vs_BuildTools.exe --add Microsoft.VisualStudio.Workload.VCTools --wait --quiet 
::vs_BuildTools.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --wait --quiet
::vs_BuildTools.exe --add Microsoft.VisualStudio.Component.Windows11SDK.22000 --wait --quiet
::winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"
vs_BuildTools.exe --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000 --wait --quiet 

:: Download Rustup
%Download-->% https://win.rustup.rs/x86_64 -O rustup-init.exe
rustup-init.exe -qy

:: Clean up
del .wget-hsts > nul
del wget.exe > nul
del 7zr.exe > nul
del nasm-2.16.01-win64.zip > nul
del PortableGit-2.43.0-64-bit.7z.exe > nul
del clang-13.0.0-windows-amd64-msvc15-msvcrt.7z > nul
del vs_BuildTools.exe > nul
del rustup-init.exe > nul

echo ---------------------------------
echo Build deps Installation Finished!
echo Exiting...
echo ---------------------------------
PAUSE
