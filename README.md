# zfs-tpm

Extends Ubuntu's zfs-initramfs package with a boot script that can unlock
native ZFS encryption with help from TPM 1.2.

Accomplished by overriding the `decrypt_fs()` function in the upstream zfs
script. Adds a section to unlock via TPM prior to the interactive unlock.

This version uses TPM 1.2 as that's the hardware I have, but extending to 2.0
may be simple.

Needs trousers and tpm-tools installed.

## Save key in TPM-sealed file

I prefer to seal to PCRs 0-3, 5-9, 11-12

```
umask 077; tpm_sealdata -p0 -p1 -p2 -p3 -p5 -p6 -p7 -p8 -p9 -p11 -p12 -z -o /.private/$POOL.tpm
```

## PCR values

[Source](https://wiki.archlinux.org/title/Trusted_Platform_Module)

|PCR    |Use                                                    |Notes
|---    |---                                                    |---
|PCR0   |Core System Firmware executable code (aka Firmware)    |May change if you upgrade your UEFI
|PCR1   |Core System Firmware data (aka UEFI settings)          |
|PCR2   |Extended or pluggable executable code                  |
|PCR3   |Extended or pluggable firmware data                    |Set during Boot Device Select UEFI boot phase
|PCR4   |Boot Manager Code and Boot Attempts                    |Measures the boot manager and the devices that the firmware tried to boot from
|PCR5   |Boot Manager Configuration and Data                    |Can measure configuration of boot loaders; includes the GPT Partition Table
|PCR6   |Resume from S4 and S5 Power State Events               |
|PCR7   |Secure Boot State                                      |Contains the full contents of PK/KEK/db, as well as the specific certificates used to validate each boot application[4]
|PCR8   |Hash of the kernel command line                        |Supported by grub and systemd-boot
|PCR9   |Hash of the initrd                                     |Kernel 6.1 might measure the kernel cmdline
|PCR10  |Reserved for Future Use                                |
|PCR11  |Hash of the Unified kernel image                       |see systemd-stub
|PCR12  |Overridden kernel command line, Credentials            |see systemd-stub
|PCR13  |System Extensions                                      |see systemd-stub
|PCR14  |Unused                                                 |
|PCR15  |Unused                                                 |
|PCR16  |Debug                                                  |May be used and reset at any time. May be absent from an official firmware release.
|PCR23  |Application Support                                    |The OS can set and reset this PCR.
