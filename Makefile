PROFILE_FLAGS=-Q -l ./.emacs.d/lisp/profile-dotemacs.el -f profile-dotemacs
COMPILE_FLAGS1=-batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-compile-file (expand-file-name \"
COMPILE_FLAGS2=\")0)"

ifeq ($(OS),Windows_NT)
	RM=del
	CP=copy
	SED=C:\Bin\Nix\sed.exe
	VER=$(shell ver)
	EMACS=C:\Dev\Emacs\Bin\emacs.exe
	INSTALLDIR=${APPDATA}
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),$(filter $(UNAME_S),Linux FreeBSD))
        @echo "Hello Linux"
		${BENCH}=/usr/bin/emacs
    endif
    ifeq ($(UNAME_S),Darwin)
        @echo "Hello Darwin"
    endif	
endif

all: install compile

install:

ifneq ("$(wildcard ${INSTALLDIR}\.emacs.d\*.elc)","") 
	@echo Deleting ${INSTALLDIR}\.emacs.d\*.elc files.
	del ${INSTALLDIR}\.emacs.d\*.elc 
endif

ifneq ("$(wildcard ${INSTALLDIR}\.emacs.d\lisp\*.elc)","") 
	@echo Deleting ${INSTALLDIR}\.emacs.d\lisp\*.elc files.
	del ${INSTALLDIR}\.emacs.d\lisp\*.elc
endif
	
	@echo Copying emacs files.
	@${CP} .emacs ${INSTALLDIR}\.emacs
	@${CP} .emacs.d\*.el ${INSTALLDIR}\.emacs.d

ifeq ("$(wildcard ${INSTALLDIR}\.emacs.d\elpa)","") 
	@echo Creating directory .emacs.d/elpa/
	@mkdir ${INSTALLDIR}\.emacs.d\elpa
endif

ifeq ("$(wildcard ${INSTALLDIR}\.emacs.d\snippets)","") 
	@echo Creating directory .emacs.d/snippets/
	@mkdir ${INSTALLDIR}\.emacs.d\snippets
endif
	

compile:
ifneq ("$(wildcard ${EMACS})","") 
	@echo Byte compiling scripts.
	@${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-cc.el${COMPILE_FLAGS2}
	@${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-js.el${COMPILE_FLAGS2}
	@${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-package.el${COMPILE_FLAGS2}
	@${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-python.el${COMPILE_FLAGS2}
	@${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-ruby.el${COMPILE_FLAGS2}
else
	$(error Emacs not found (${EMACS}).)
endif

clean:
	@rmdir /s ${INSTALLDIR}\.emacs.d
	@${RM} ${INSTALLDIR}\.emacs
	
profile:
ifneq ("$(wildcard ${EMACS})","") 
	${EMACS} ${PROFILE_FLAGS}
else
	$(error Emacs not found (${EMACS}).)
endif

	