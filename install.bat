@echo off
set EMACS=C:\Compiler\emacs-23.2\bin
echo ================================
echo  Installing .emacs and .emacs.d
echo ================================
echo Copying .emacs
xcopy /q /y /v ".emacs" "%APPDATA%\.emacs"
echo Copying .emacs.d/*
xcopy /q /y /v ".emacs.d\*.el" "%APPDATA%\.emacs.d\"
echo Compiling...
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\custom.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-display.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-cedet.el"
set EMACS=
echo.
echo Done.