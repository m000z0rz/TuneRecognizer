@echo off
REM This file is to push Arduino code from the repository path to the sketches folder
echo.
echo.
IF EXIST "%USERPROFILE%\My Documents\Arduino" GOTO copyXP
IF EXIST "%USERPROFILE%\Documents\Arduino" GOTO copy7
echo ERROR: Couldn't find a documents folder :(
GOTO EOF

:copyXP
IF NOT EXIST "%USERPROFILE%\My Documents\Arduino\TuneRecognizer" mkdir "%USERPROFILE%\My Documents\Arduino\TuneRecognizer"
COPY "TuneRecognizer\*.*" "%USERPROFILE%\My Documents\Arduino\TuneRecognizer\" /Y
GOTO EOF

:copy7
IF NOT EXIST "%USERPROFILE%\Documents\Arduino\TuneRecognizer" mkdir "%USERPROFILE%\Documents\Arduino\TuneRecognizer"
COPY "TuneRecognizer\*.*" "%USERPROFILE%\Documents\Arduino\TuneRecognizer\" /Y
GOTO EOF

:EOF
