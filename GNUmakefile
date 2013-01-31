proot-version  = proot-v2.3.2-rc0
talloc-version = talloc-2.0.8
python-version = Python-2.7.3

package-rootfs-x86_64 = packages/stage3-amd64-2005.0.tar.bz2
package-rootfs-x86    = packages/stage3-x86-2005.0.tar.bz2
package-rootfs-sh4    = packages/stage3-sh4-2006.1.tar.bz2
package-rootfs-arm    = packages/fc6-arm-root-with-gcc.tar.bz2

package-proot  = packages/$(proot-version).tar.gz
package-talloc = packages/$(talloc-version).tar.gz
package-python = packages/$(python-version).tar.xz

talloc-objects = bin/default/talloc_3.o bin/default/lib/replace/replace_2.o bin/default/lib/replace/getpass_2.o

targets = x86_64 x86 arm sh4

all: $(addprefix proot-,$(targets))

clean:
	rm -f $(addprefix proot-,$(targets))
	rm -fr $(addprefix rootfs-,$(targets))

%-arm: skip-python = true
%-sh4: skip-python = true

# Note: it requires a fixed version of QEMU/SH4
%-arm: extra-opts = -q qemu-arm -b $(shell which make)
%-sh4: extra-opts = -q qemu-sh4

proot = proot -B $(extra-opts)

proot-%: rootfs-%
	tar -C $< -xf $(package-proot)
	$(proot) -w /$(proot-version) $< make -j 2 -C src LDFLAGS="-static /$(talloc-version)/libtalloc.a"
	cp $</$(proot-version)/src/proot $@

rootfs-%:
	mkdir $@
	tar -C $@ -xjf $(package-rootfs-$*) 2>/dev/null || true
	cp packages/queue.h $@/usr/include/sys/queue.h

	$(skip-python) tar -C $@ -xf $(package-python)
	$(skip-python) $(proot) -w /$(python-version) $@ ./configure
	$(skip-python) $(proot) -w /$(python-version) $@ make -j 2 install

	tar -C $@ -xf $(package-talloc)
	$(proot) -w /$(talloc-version) $@ ./configure --disable-python
	$(proot) -w /$(talloc-version) $@ make -j 2 install
	$(proot) -w /$(talloc-version) $@ ar qf libtalloc.a $(talloc-objects)
