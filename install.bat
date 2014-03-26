::
:: install.bat - Install Emacs configuration files. (Win7/Win8 only)
::
:: TODO: Convert to Makefile
@echo off
set EMACS=C:\Dev\emacs\bin\emacs.exe

if not exist %EMACS% goto error_emacs_missing

:: Get OS version to determine install path.
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" GEQ "6.2" set INSTALLDIR=%APPDATA%
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
%EMACS% -batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-compile-file (expand-file-name \"~/.emacs.d/init-cc.el\")0)"
%EMACS% -batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-compile-file (expand-file-name \"~/.emacs.d/init-package.el\")0)"
%EMACS% -batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-compile-file (expand-file-name \"~/.emacs.d/init-js.el\")0)"
%EMACS% -batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-compile-file (expand-file-name \"~/.emacs.d/init-python.el\")0)"
%EMACS% -batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-compile-file (expand-file-name \"~/.emacs.d/init-ruby.el\")0)"

::%EMACS% -batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-recompile-directory (expand-file-name \"~/.emacs.d/\")0)"

echo Compiling 3rd party scripts...
:: Commented out scripts with warnings
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\poptoshell.el
::MACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\cycle-buffer.el
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\go-mode-load.el
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\lambda-mode.el
if "%1"=="build" goto build
goto end

:build
echo.
echo Building CEDET.
if not exist %INSTALLDIR%\.emacs.d\lisp\cedet\  goto error_cedet_missing
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

:error_cedet_missing
echo Warning: CEDET not found. This should not be an issue, unless you do not want to use Emacs CEDET.
goto end

:end
set EMACS=
set VERSION=
set INSTALLDIR=
echo.
echo Done.

:eof