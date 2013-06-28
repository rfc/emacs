@echo off
set EMACS=C:\Dev\emacs\bin

echo ================================
echo  Installing .emacs and .emacs.d
echo ================================


if exist "%APPDATA%\.emacs.d\*.elc" del "%APPDATA%\.emacs.d\*.elc" 
if exist "%APPDATA%\.emacs.d\lisp\*.elc" del "%APPDATA%\.emacs.d\lisp\*.elc" 

echo Copying .emacs
xcopy /q /y /v ".emacs" "%APPDATA%\.emacs"
echo Copying .emacs.d/*
xcopy /q /y /v ".emacs.d\*.el" "%APPDATA%\.emacs.d\"
echo Copying .emacs.d/lisp/*
xcopy /q /y /v /s ".emacs.d\lisp\*" "%APPDATA%\.emacs.d\lisp\"
echo Creating .emacs.d/elpa/*
if not exist "%APPDATA%\.emacs.d\elpa\" mkdir "%APPDATA%\.emacs.d\elpa\"
echo Creating .emacs.d/snippets/*
if not exist "%APPDATA%\.emacs.d\snippets\" mkdir "%APPDATA%\.emacs.d\snippets\"

echo Compiling main scripts...
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\custom.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-cc.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-ruby.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-python.el"

:: Commented out scripts with warnings
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-elpa.el"

::echo Compiling 3rd party scripts...
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\lisp\window-numbering.el"
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\lisp\package.el"

::echo.
::echo POSTINSTALL:
::echo ------------
::echo 1. Build CEDET: %EMACS%\emacs.exe -Q -l cedet-build.el -f cedet-build
::echo.
::pause
::pushd .
::%systemdrive%
::cd %APPDATA%\.emacs.d\lisp\cedet\
::%EMACS%\emacs.exe -Q -l cedet-build.el -f cedet-build
::popd 

set EMACS=
echo.
echo Done.