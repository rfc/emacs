@echo off
set EMACS=C:\Compiler\emacs-23.4\bin
echo ================================
echo  Installing .emacs and .emacs.d
echo ================================
echo Copying .emacs
xcopy /q /y /v ".emacs" "%APPDATA%\.emacs"
echo Copying .emacs.d/*
xcopy /q /y /v ".emacs.d\*.el" "%APPDATA%\.emacs.d\"
if not exist "%APPDATA%\.emacs.d\elpa" mkdir "%APPDATA%\.emacs.d\elpa"
xcopy /q /y /v ".emacs.d\elpa\*.el" "%APPDATA%\.emacs.d\elpa\"
if not exist "%APPDATA%\.emacs.d\vendor" mkdir "%APPDATA%\.emacs.d\vendor"
xcopy /q /y /v /s ".emacs.d\vendor\*" "%APPDATA%\.emacs.d\vendor\"
echo Compiling...
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\custom.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-bindings.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-display.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-cedet.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-elpa.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-cc.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-ruby.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-java.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\init-python.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\python-mode.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\elpa\package.el"

%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\auto-complete\auto-complete.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\auto-complete\auto-complete-config.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\auto-complete\fuzzy.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\auto-complete\popup.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\dropdown-list.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\minimap.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\linum+.el"
%EMACS%\emacs.exe -batch -f batch-byte-compile "%APPDATA%\.emacs.d\vendor\lambda-mode.el"

set EMACS=
echo.
echo Done.