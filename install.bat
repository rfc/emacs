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

echo Compiling main scripts...
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\custom.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-bindings.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-display.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-cedet.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-elpa.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-cc.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-ruby.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-python.el"

set EMACS=
echo.
echo Done.