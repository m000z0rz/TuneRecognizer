@echo off
REM This file is to get Arduino code from the Sketches folder and copy it into the repository path
echo.
echo.
IF EXIST "%USERPROFILE%\My Documents\Arduino\TuneRecognizer" GOTO copyXP
IF EXIST "%USERPROFILE%\Documents\Arduino\TuneRecognizer" GOTO copy7
echo ERROR: Couldn't find Arduino code folder to pull from :(
GOTO EOF

:copyXP
COPY "%USERPROFILE%\My Documents\Arduino\TuneRecognizer\*.*" "TuneRecognizer\" /Y
GOTO EOF

:copy7
COPY "%USERPROFILE%\Documents\Arduino\TuneRecognizer\*.*" "TuneRecognizer\" /Y
GOTO EOF

:EOF
