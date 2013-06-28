@echo off
set EMACS=C:\Compiler\emacs\bin

echo ================================
echo  Installing .emacs and .emacs.d
echo ================================


if exist "%HOME%\.emacs.d\*.elc" del "%HOME%\.emacs.d\*.elc" 
if exist "%HOME%\.emacs.d\lisp\*.elc" del "%HOME%\.emacs.d\lisp\*.elc" 

echo Copying .emacs
xcopy /q /y /v ".emacs" "%HOME%\.emacs"
echo Copying .emacs.d/*
xcopy /q /y /v ".emacs.d\*.el" "%HOME%\.emacs.d\"
echo Copying .emacs.d/lisp/*
xcopy /q /y /v /s ".emacs.d\lisp\*" "%HOME%\.emacs.d\lisp\"
echo Creating .emacs.d/elpa/*
if not exist "%HOME%\.emacs.d\elpa\" mkdir "%HOME%\.emacs.d\elpa\"
echo Creating .emacs.d/snippets/*
if not exist "%HOME%\.emacs.d\snippets\" mkdir "%HOME%\.emacs.d\snippets\"

echo Compiling main scripts...
%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\custom.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\init.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\init-cc.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\init-ruby.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\init-python.el"

:: Commented out scripts with warnings
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\init-elpa.el"

::echo Compiling 3rd party scripts...
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\lisp\window-numbering.el"
::%EMACS%\emacs.exe -batch -f batch-byte-compile "%HOME%\.emacs.d\lisp\package.el"

echo.
echo POSTINSTALL:
echo ------------
echo 1. Build CEDET: %EMACS%\emacs.exe -Q -l cedet-build.el -f cedet-build
echo.

set EMACS=
echo.
echo Done.