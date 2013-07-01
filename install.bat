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
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\init-elpa.el"
echo ATTN: Ignore init-elpa.el warning above.

echo Compiling 3rd party scripts...
:: Commented out scripts with warnings
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\window-numbering.el"
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\package.el"
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\poptoshell.el
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\python-pep8.el
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\python-pylint.el
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\window-numbering.el
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\window-numbering-tests.el
::%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\zenburn.el
%EMACS% -batch -f batch-byte-compile "%INSTALLDIR%\.emacs.d\lisp\cycle-buffer.el
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