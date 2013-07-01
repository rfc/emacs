::
:: install.bat - Install Emacs configuration files. (Win7/Win8 only)
::
@echo off
set EMACS=C:\Dev\emacs\bin\emacs.exe

if not exist %EMACS% goto error_emacs_missing

:: Get OS version to determine install path.
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "6.2" set INSTALLDIR=%APPDATA%
if "%version%" == "6.1" set INSTALLDIR=%HOME%
if "%version%" LSS "6.0" error_unsupported_os

echo ================================
echo  Installing .emacs and .emacs.d
echo ================================

if exist "%INSTALLDIR%\.emacs.d\*.elc" del "%INSTALLDIR%\.emacs.d\*.elc" 
if exist "%INSTALLDIR%\.emacs.d\lisp\*.elc" del "%INSTALLDIR%\.emacs.d\lisp\*.elc" 

echo Copying .emacs
xcopy /q /y /v ".emacs" "%INSTALLDIR%\.emacs"
echo Copying .emacs.d/*
xcopy /q /y /v ".emacs.d\*.el" "%INSTALLDIR%\.emacs.d\"
echo Copying .emacs.d/lisp/*
xcopy /q /y /v /s ".emacs.d\lisp\*" "%INSTALLDIR%\.emacs.d\lisp\"
echo Creating .emacs.d/elpa/*
if not exist "%INSTALLDIR%\.emacs.d\elpa\" mkdir "%INSTALLDIR%\.emacs.d\elpa\"
echo Creating .emacs.d/snippets/*
if not exist "%INSTALLDIR%\.emacs.d\snippets\" mkdir "%INSTALLDIR%\.emacs.d\snippets\"

echo Compiling main scripts...
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\custom.el"
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\init.el"
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\init-cc.el"
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\init-ruby.el"
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\init-python.el"

:: Commented out scripts with warnings
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\init-elpa.el"

::echo Compiling 3rd party scripts...
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\window-numbering.el"
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\package.el"
if "%1"=="build" goto build
goto end

:build
echo.
echo Building CEDET.
::echo 1. Build CEDET: %EMACS%\emacs.exe -Q -l cedet-build.el -f cedet-build
::echo.

pushd .
%systemdrive%
cd %INSTALLDIR%\.emacs.d\lisp\cedet\
%EMACS% -Q -l cedet-build.el -f cedet-build
popd 
goto end

:error_unsupported_os
echo Error: Windows version not supported.
goto eof

:error_emacs_missing
echo Error: Emacs executable not found (%EMACS%).
goto eof

:end
set EMACS=
set VERSION=
set INSTALLDIR=
echo.
echo Done.

:eof