#########################################################################
# Simple makefile for packaging Roku Video Player example
#
# Makefile Usage:
# > make
# > make install
# > make remove
#
# Important Notes:
# To use the "install" and "remove" targets to install your
# application directly from the shell, you must do the following:
#
# 1) Make sure that you have the curl command line executable in your path
# 2) Set the variable ROKU_DEV_TARGET in your environment to the IP
#    address of your Roku box. (e.g. export ROKU_DEV_TARGET=192.168.1.1.
#    Set in your this variable in your shell startup (e.g. .bashrc)
##########################################################################
APPNAME = tealium-roku
VERSION = 1.0
ROKU_DEV_TARGET = 10.0.3.87
USER = rokudev
PASS = 1108
ZIP_EXCLUDE= -x xml/* -x artwork/* -x \*.pkg -x storeassets\* -x keys\* -x \*/.\* -x \*.git -x \*.project

include app.mk

BLANK_LINES_RE="/^[ \t]*'.*/d"
COMMENT_LINES_RE="/^[ ]*$$/d"
DISTDIR = ../dist
TEALDIR = ./source/tealium

dist:
	@if [ ! -d $(DISTDIR) ]; \
	then \
		mkdir -p $(DISTDIR); \
	fi
	#LEADING_WHITESPACE_RE is chopping off t's for the time being. need to fix it
	echo "" > $(DISTDIR)/tealium.brs
	cd $(TEALDIR) && ls | xargs -J % sed -E -e ${COMMENT_LINES_RE} -e ${BLANK_LINES_RE} % >> ../../$(DISTDIR)/tealium.brs