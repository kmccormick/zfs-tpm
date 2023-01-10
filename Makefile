scripts := $(wildcard scripts/*/*)
hooks := $(wildcard hooks/*)

install: /etc/initramfs-tools/scripts/zfs-tpm $(addprefix /etc/initramfs-tools/,$(scripts) $(hooks))
.PHONY: install

/etc/initramfs-tools/scripts/zfs-tpm: scripts/zfs-tpm
	install -o root -g root -m 0644 $< $@

/etc/initramfs-tools/%: %
	install -o root -g root -m 0755 $< $@
