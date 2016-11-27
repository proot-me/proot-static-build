# How to build PRoot and CARE statically on Slackware64-14.1:
#
# for x86_64:	proot -R slackware64-14.0/		\
#			-b /usr/include/linux/prctl.h	\
#			-b /usr/include/linux/seccomp.h	\
#			make ...
#
# for x86:	proot -R slackware-14.0/
#			-b /usr/include/linux/prctl.h	\
#			-b /usr/include/linux/seccomp.h	\
#			make ...
#
# for arm:	proot -R slackwarearm-14.1/		\
#			-b $(which cmake)		\
#			-q qemu-arm			\
#			make glibc-version=glibc-2.18 ...
#
# for sh4:	proot -R gentoo-stage3-sh4a-20130614/	\
#			-b $(which cmake)		\
#			-b /usr/share/cmake-2.8		\
#			-b $(which python)		\
#			`python -c 'import sys; print " ".join(map(lambda x: "-b " + x, filter(bool, sys.path)))'` \
#			-q qemu-sh4
#			make ...

proot-version      = proot-v5.1.1
care-version       = care-v2.2.2
glibc-version      = glibc-2.19
libtalloc-version  = talloc-2.1.1
libarchive-version = libarchive-3.1.2
libz-version       = zlib-1.2.8
liblzo-version     = lzo-2.06

glibc-license      = sh -c '$(prefix)/lib/libc.so.6; cat $(glibc-version)/LICENSES; head -n 16 $(glibc-version)/io/open.c'
libtalloc-license  = head -n 27 $(libtalloc-version)/talloc.c
libarchive-license = cat $(libarchive-version)/COPYING
libz-license       = head -n 29 $(libz-version)/zlib.h
liblzo-license     = head -n 41 $(liblzo-version)/src/lzo1.c

libc_a       = $(prefix)/lib/libc.a
libtalloc_a  = $(prefix)/lib/libtalloc.a
libarchive_a = $(prefix)/lib/libarchive.a
libz_a       = $(prefix)/lib/libz.a
liblzo_a     = $(prefix)/lib/liblzo2.a

env = CFLAGS="-g -O2 -isystem $(prefix)/include" LDFLAGS="-L$(prefix)/lib"

VPATH := $(dir $(lastword $(MAKEFILE_LIST)))
packages = $(VPATH)/packages
prefix = $(PWD)/prefix
$(prefix):
	mkdir $@

$(libc_a):
	tar -xzf $(packages)/$(glibc-version).tar.gz
	mkdir $(glibc-version)/build
	cd $(glibc-version)/build 					&& \
	  ../configure --enable-kernel=2.6.0 --prefix=$(prefix)		&& \
	  $(MAKE)							&& \
	  $(MAKE) install

$(libtalloc_a): $(libc_a)
	tar -xzf $(packages)/$(libtalloc-version).tar.gz
	cd $(libtalloc-version) 					&& \
	  $(env) ./configure --prefix=$(prefix)				&& \
	  $(MAKE) 							&& \
	  $(MAKE) install						&& \
	  ar qf $@ bin/default/talloc_3.o

$(libarchive_a): $(libc_a) $(libz_a) $(liblzo_a)
	tar -xzf $(packages)/$(libarchive-version).tar.gz
	cd $(libarchive-version) 					&& \
	  $(env) cmake	-D HAVE_FUTIMESAT:INTERNAL=0	\
			-D HAVE_FUTIMENSAT:INTERNAL=0	\
			-D HAVE_FUTIMES:INTERNAL=0	\
			-D HAVE_LUTIMES:INTERNAL=0	\
			-D HAVE_FUTIMENS:INTERNAL=0	\
			-D HAVE_UTIMENSAT:INTERNAL=0	\
			-DCMAKE_INSTALL_PREFIX:PATH=$(prefix) .		&& \
	  $(MAKE)							&& \
	  $(MAKE) install

$(libz_a): $(libc_a)
	tar -xzf $(packages)/$(libz-version).tar.gz
	cd $(libz-version) 						&& \
	  $(env) ./configure --prefix=$(prefix)				&& \
	  $(MAKE)							&& \
	  $(MAKE) install

$(liblzo_a): $(libc_a)
	tar -xzf $(packages)/$(liblzo-version).tar.gz
	cd $(liblzo-version) 						&& \
	  $(env) ./configure --enable-shared --prefix=$(prefix)		&& \
	  $(MAKE)							&& \
	  $(MAKE) install

all_libs_a = $(libc_a) $(libtalloc_a) $(libarchive_a) $(libz_a) $(liblzo_a)

proot-licenses: $(libc_a) $(libtalloc_a)
	@echo "" >> $@
	@echo "This version of PRoot is statically linked to the following software." >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "glibc:" >> $@
	@echo "" >> $@
	@$(glibc-license) >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "libtalloc:" >> $@
	@echo "" >> $@
	@$(libtalloc-license) >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "The build-system, sources and licences are available on:" >> $@
	@echo "" >> $@
	@echo "    https://github.com/cedric-vincent/proot-static-build">> $@

care-licenses: $(all_libs_a)
	@echo "" >> $@
	@echo "This version of CARE is statically linked to the following software." >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "proot:" >> $@
	@echo "" >> $@
	@echo " * Copyright (C) 2013 STMicroelectronics" >> $@
	@echo " *" >> $@
	@echo " * This program is free software; you can redistribute it and/or" >> $@
	@echo " * modify it under the terms of the GNU General Public License as" >> $@
	@echo " * published by the Free Software Foundation; either version 2 of the" >> $@
	@echo " * License, or (at your option) any later version." >> $@
	@echo " *" >> $@
	@echo " * This program is distributed in the hope that it will be useful, but" >> $@
	@echo " * WITHOUT ANY WARRANTY; without even the implied warranty of" >> $@
	@echo " * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU" >> $@
	@echo " * General Public License for more details." >> $@
	@echo " *" >> $@
	@echo " * You should have received a copy of the GNU General Public License" >> $@
	@echo " * along with this program; if not, write to the Free Software" >> $@
	@echo " * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA" >> $@
	@echo " * 02110-1301 USA." >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "glibc:" >> $@
	@echo "" >> $@
	@$(glibc-license) >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "libtalloc:" >> $@
	@echo "" >> $@
	@$(libtalloc-license) >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "libarchive:" >> $@
	@echo "" >> $@
	@$(libarchive-license) >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "zlib:" >> $@
	@echo "" >> $@
	@$(libz-license) >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "liblzo:" >> $@
	@echo "" >> $@
	@$(liblzo-license) >> $@
	@echo "------------------------------------------------------------------------" >> $@
	@echo "The build-system, sources and licences are available on:" >> $@
	@echo "" >> $@
	@echo "    https://github.com/cedric-vincent/proot-static-build">> $@

care: $(all_libs_a) care-licenses
	tar -xzf $(packages)/$(care-version).tar.gz
	cp care-licenses $(care-version)/src/licenses
	env OBJECTS="cli/care-licenses.o" LDFLAGS="-static -L$(prefix)/lib -larchive -lz -llzo2" CPPFLAGS="-isystem $(prefix)/include -DCARE_BINARY_IS_PORTABLE " $(MAKE) -C $(care-version)/src/ care GIT=false
	cp $(care-version)/src/$@ .

proot: $(libc_a) $(libtalloc_a) proot-licenses
	tar -xzf $(packages)/$(proot-version).tar.gz
	cp proot-licenses $(proot-version)/src/licenses
	env OBJECTS="cli/proot-licenses.o" LDFLAGS="-static -L$(prefix)/lib" CPPFLAGS="-isystem $(prefix)/include" $(MAKE) -C $(proot-version)/src/ GIT=false
	cp $(proot-version)/src/$@ .
