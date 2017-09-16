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

include versions.mak

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
	mkdir -p $(prefix)/licenses
	@echo "" >> $(prefix)/licenses/$@
	@echo "This version of PRoot is statically linked to the following software." >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "glibc:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@$(glibc-license) >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "libtalloc:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@$(libtalloc-license) >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "The build-system, sources and licences are available on:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@echo "    https://github.com/cedric-vincent/proot-static-build">> $(prefix)/licenses/$@

care-licenses: $(all_libs_a)
	mkdir -p $(prefix)/licenses
	@echo "" >> $(prefix)/licenses/$@
	@echo "This version of CARE is statically linked to the following software." >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "proot:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@echo " * Copyright (C) 2013 STMicroelectronics" >> $(prefix)/licenses/$@
	@echo " *" >> $(prefix)/licenses/$@
	@echo " * This program is free software; you can redistribute it and/or" >> $(prefix)/licenses/$@
	@echo " * modify it under the terms of the GNU General Public License as" >> $(prefix)/licenses/$@
	@echo " * published by the Free Software Foundation; either version 2 of the" >> $(prefix)/licenses/$@
	@echo " * License, or (at your option) any later version." >> $(prefix)/licenses/$@
	@echo " *" >> $(prefix)/licenses/$@
	@echo " * This program is distributed in the hope that it will be useful, but" >> $(prefix)/licenses/$@
	@echo " * WITHOUT ANY WARRANTY; without even the implied warranty of" >> $(prefix)/licenses/$@
	@echo " * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU" >> $(prefix)/licenses/$@
	@echo " * General Public License for more details." >> $(prefix)/licenses/$@
	@echo " *" >> $(prefix)/licenses/$@
	@echo " * You should have received a copy of the GNU General Public License" >> $(prefix)/licenses/$@
	@echo " * along with this program; if not, write to the Free Software" >> $(prefix)/licenses/$@
	@echo " * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA" >> $(prefix)/licenses/$@
	@echo " * 02110-1301 USA." >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "glibc:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@$(glibc-license) >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "libtalloc:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@$(libtalloc-license) >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "libarchive:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@$(libarchive-license) >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "zlib:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@$(libz-license) >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "liblzo:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@$(liblzo-license) >> $(prefix)/licenses/$@
	@echo "------------------------------------------------------------------------" >> $(prefix)/licenses/$@
	@echo "The build-system, sources and licences are available on:" >> $(prefix)/licenses/$@
	@echo "" >> $(prefix)/licenses/$@
	@echo "    https://github.com/cedric-vincent/proot-static-build">> $(prefix)/licenses/$@


all_libs: $(all_libs_a) care-licenses proot-licenses

