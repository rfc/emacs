@echo off
set EMACS=C:\Compiler\emacs\bin

echo ================================
echo  Installing .emacs and .emacs.d
echo ================================

echo Copying .emacs
xcopy /q /y /v ".emacs" "%APPDATA%\.emacs"
echo Copying .emacs.d/*
xcopy /q /y /v ".emacs.d\*.el" "%APPDATA%\.emacs.d\"
echo Copying .emacs.d/lisp/*
xcopy /q /y /v /s ".emacs.d\lisp\*" "%APPDATA%\.emacs.d\lisp\"
echo Creating .emacs.d/elpa/*
if not exist "%APPDATA%\.emacs.d\elpa\" mkdir "%APPDATA%\.emacs.d\elpa\"

echo Compiling main scripts...
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\custom.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-cc.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-ruby.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-python.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-elpa.el"

echo Compiling 3rd party scripts...
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\lisp\window-numbering.el"
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\lisp\package.el"

echo.
echo POSTINSTALL:
echo ------------
echo 1. Build CEDET: %EMACS%\emacs.exe -Q -l "%APPDATA%\.emacs.d\lisp\cedet\cedet-build.el" -f cedet-build
echo.

set EMACS=
echo.
echo Done.