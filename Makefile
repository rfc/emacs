PROFILE_FLAGS=-Q -l ./.emacs.d/lisp/profile-dotemacs.el -f profile-dotemacs
COMPILE_FLAGS1=-batch --eval "(require 'package)" --eval "(package-initialize)" --eval "(byte-compile-file (expand-file-name \"
COMPILE_FLAGS2=\")0)"

ifeq ($(OS),Windows_NT)
	CP=@copy
	ECHO=@echo
	EMACS=@								# echo off
	EMACS+=C:\Dev\Emacs\Bin\emacs.exe	# figure out a one-liner
	INSTALLDIR=${APPDATA}
	NORMALIZE_PATH=$(subst /,\,$1)
	RM=del
	RMDIR=rmdir /s
	SHELL=$(COMSPEC)
	TEST=$(shell /c for /f "tokens=4-5 delims=. " %%i in ('ver') do echo %%i.%%j)
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),$(filter $(UNAME_S),Linux FreeBSD Darwin))
		CP=cp
		ECHO=echo
		INSTALLDIR=~
		NORMALIZE_PATH=$1
		RM=rm
		RMDIR=rm -rf
		EMACS=$(shell which emacs)
    endif
endif

all: install compile

install:
	$(TEST)
#	$(error QUITTING)
ifneq ("$(wildcard ${INSTALLDIR}/.emacs.d/*.elc)","")
	${ECHO} Deleting ${INSTALLDIR}/.emacs.d/*.elc files.
	${RM} $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d/*.elc)
endif

ifneq ("$(wildcard ${INSTALLDIR}/.emacs.d/lisp/*.elc)","")
	${ECHO} Deleting ${INSTALLDIR}/.emacs.d/lisp/*.elc files.
	${RM} $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d/lisp/*.elc)
endif

ifeq ("$(wildcard ${INSTALLDIR}/.emacs.d/)","")
	${ECHO} Creating directory .emacs.d/
	mkdir $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d/)
endif

ifeq ("$(wildcard ${INSTALLDIR}/.emacs.d/elpa)","")
	${ECHO} Creating directory .emacs.d/elpa/
	mkdir $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d/elpa)
endif

ifeq ("$(wildcard ${INSTALLDIR}/.emacs.d/lisp)","")
	${ECHO} Creating directory .emacs.d/lisp/
	mkdir $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d/lisp)
endif

ifeq ("$(wildcard ${INSTALLDIR}/.emacs.d/snippets)","")
	${ECHO} Creating directory .emacs.d/snippets/
	mkdir $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d/snippets)
endif

	${ECHO} Copying emacs files.
	${CP} .emacs $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs)
	${CP} $(call NORMALIZE_PATH,.emacs.d/*.el) $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d)
	${CP} $(call NORMALIZE_PATH,.emacs.d/lisp/*.el) $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d/lisp)

compile:
ifneq ("$(wildcard ${EMACS})","")
	${ECHO} Byte compiling scripts.
	${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-cc.el${COMPILE_FLAGS2}
	${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-js.el${COMPILE_FLAGS2}
	${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-package.el${COMPILE_FLAGS2}
	${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-python.el${COMPILE_FLAGS2}
	${EMACS} ${COMPILE_FLAGS1}~/.emacs.d/init-ruby.el${COMPILE_FLAGS2}
else
	$(error Emacs not found (${EMACS}).)
endif

clean:
	${RMDIR} $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs.d)
	${RM} $(call NORMALIZE_PATH,${INSTALLDIR}/.emacs)

profile:
ifneq ("$(wildcard ${EMACS})","")
	${EMACS} ${PROFILE_FLAGS}
else
	$(error Emacs not found (${EMACS}).)
endif
