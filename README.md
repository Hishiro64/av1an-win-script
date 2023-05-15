#  🐦 Av1an Win Script

A Windows Batch script that sets up [Av1an](https://github.com/master-of-zen/Av1an) with all its dependencies for AV1 in a portable workspace. It doesn't require building from source or modifying any path variables. Once installed, you can queue multiple files to be encoded using the parameters you specify.

![preview](./preview.png)

## 🛠️ Installation
  Open PowerShell in a directory path that contains no spaces and run:

  ````
  git clone https://github.com/Hishiro64/av1an-win-script.git; ./av1an-win-script/install.bat
  ````
You could also [download](https://github.com/Hishiro64/av1an-win-script/archive/refs/heads/main.zip), extract, and double click on `install.bat`

## 🚗 Usage
   1. Place the videos you want to encode into the `input` directory
   2. Modify the encoder augments by editing `params.txt` (Defaults are fine)
   3. Run `encode.bat`
   4. Once it finishes, the encoded videos should be in the `output` directory
