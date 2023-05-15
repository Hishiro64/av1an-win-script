@echo off
TITLE Av1an Win Script ⚙

cls

setlocal enabledelayedexpansion 

:: Set path 
set "AV1=%~dp0"

:: Set Wget command
set "Download-->=%AV1%\wget.exe -q -N --show-progress"

:: Set 7zr command
set "Extract-->=%AV1%\7zr.exe -y x"

:: Correct path
cd "%AV1%"

echo   Installing
echo  ````````````

:: Create these directories
for %%d in (input input\completed-inputs output cache ) do (
    mkdir .\%%d
)

for %%d in (vapoursynth64-r62 ffmpegAv1an mkvtoolnix  svt-av1 vmaf aom) do (
    mkdir .\dependencies\%%d
)

:: Download portable Wget
curl -O -C - --progress-bar https://eternallybored.org/misc/wget/1.21.3/64/wget.exe

:: Download portable 7zip
%Download-->% https://www.7-zip.org/a/7zr.exe

:: Download av1an
%Download-->% https://github.com/master-of-zen/Av1an/releases/download/latest/av1an.exe

pushd .\dependencies\ffmpegAv1an

:: Download ffmpeg with shared libaries 
%Download-->% https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-5.1.2-full_build-shared.7z
%Extract-->% .\ffmpeg-5.1.2-full_build-shared.7z ffmpeg-5.1.2-full_build-shared\bin > nul

:: Move contents of bin
for /R "ffmpeg-5.1.2-full_build-shared\bin" %%f in (*) do (
    move "%%f" "%destination%" > nul
)

rmdir /s /q .\ffmpeg-5.1.2-full_build-shared

cd ..\

:: Download portable mkvtoolnix 
%Download-->% https://mkvtoolnix.download/windows/releases/76.0/mkvtoolnix-64-bit-76.0.7z -O mkvtoolnix.7z
%Extract-->% .\mkvtoolnix.7z > nul
del .\mkvtoolnix.7z

cd .\aom

:: Download aom av1 encoder
%Download-->% https://github.com/BlueSwordM/aom-av1-psy/releases/download/aom-av1-psy-1.0.0/Skylake.Windows.aom-av1-psy-Windows-Endless_Possibility-LTO-2022-09-06.7z
%Extract-->% Skylake.Windows.aom-av1-psy-Windows-Endless_Possibility-LTO-2022-09-06.7z > nul
ren aom-av1-psy-Windows-Endless_Possibility-Skylake-LTO-2022-09-06.exe aomenc.exe

cd ..\
cd .\vmaf

:: Download vmaf model
%Download-->% https://raw.githubusercontent.com/Netflix/vmaf/master/model/vmaf_v0.6.1.json

cd ..\
cd .\vapoursynth64-r62

:: Download embedded Python ~3.11.2
%Download-->% https://www.python.org/ftp/python/3.11.2/python-3.11.2-embed-amd64.zip
tar -xf .\python-3.11.2-embed-amd64.zip 
del .\python-3.11.2-embed-amd64.zip

:: Download VapourSynth64 Portable ~R62
%Download-->% https://github.com/vapoursynth/vapoursynth/releases/download/R62/VapourSynth64-Portable-R62.7z
%Extract-->% .\VapourSynth64-Portable-R62.7z > nul
del .\VapourSynth64-Portable-R62.7z

:: Download plugins [But its broken for some reason]
:: .\python.exe .\vsrepo.py update -p
:: .\python.exe .\vsrepo.py install lsmas ffms2 -p

cd ..\
cd .\svt-av1

:: Download SVT-AV1 release ~1.5.0
curl -sLf "https://gitlab.com/AOMediaCodec/SVT-AV1/-/jobs/4187469677/artifacts/download?file_type=archive" -O NUL -w "%%{url_effective}" > ./raw.txt

(for /f "usebackq delims=" %%a in ("raw.txt") do (
    set "line=%%a"
    set "line=!line:~0,-11!"
    echo !line!
)) > "downloadlink.txt"


%Download-->% -i .\downloadlink.txt -O SVT-AV1-1.5.zip

:: Clean up
del download > nul
del downloadlink.txt > nul
del raw.txt > nul

tar -xf .\SVT-AV1-1.5.zip --strip-components 2 > nul

popd

:: Clean up
del .wget-hsts > nul
del wget.exe > nul
del 7zr.exe > nul

PAUSE