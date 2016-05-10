From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Could use some help getting SIW compiling on latest kernels
Date: Tue, 10 May 2016 16:30:06 -0600
Message-ID: <CAANLjFrhNathEQViOTePpjphWLqaXLTjPu=XrUiM3GAyD9yktA@mail.gmail.com>
References: <CAANLjFpmhtdfBsVCwAsLkmOx-mmTv9fb4u9VMM7ps3_c50s53Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpmhtdfBsVCwAsLkmOx-mmTv9fb4u9VMM7ps3_c50s53Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

I've figured out the error for the stack trace. Apparently iWARP
doesn't need/use MADs and removing

immutable->max_mad_size = IB_MGMT_MAD_SIZE;

fixes it. I still don't get a device to show up with ibv_devices so I
have some more digging to do. This is a minimal VM, so I could just be
missing some libraries or something.
-----BEGIN PGP SIGNATURE-----
Version: Mailvelope v1.4.0
Comment: https://www.mailvelope.com

wsFcBAEBCAAQBQJXMmB9CRDmVDuy+mK58QAA9twP/064YugqixRYBXMRRROS
ZTqIouXHi7PLdjO8oRZrnS284xz9H7WH0BQqWLRORwyBTUwni9sUsY9zAhO8
g/JFA651kk1W6wJ3ViYC1D/rfkR76zhW2A88ExphSmvwZgs8kL4DzSWusUaN
CjMwfH8EYDT8GUhJfKWdhCoj7N723WaUItM0P4dham1EpTkjt8gUMQ2kc0sd
7jvxxa3ovFeuhUlUkxMWi+2qpQlFVx2w2rmz2qmIqpoR1JuGu0lbBngHtkc3
juihAqB25sdt7G+cm88m7uJAZy5qEPUKUU6pb65egztTfWdcW5CIMEMPaX2m
edLTtUdKg0zU8RQNwJ1ew68lOcwPih/Ev0Q/wAiox1zi6u+PtGm+UjDAQ0dX
3xYhVPFMuUNpKRuxH8JYZw4YkqwfGQP4glOccXqn5fhmW+dGC54VW4qwyaUe
TPZm0HJO9dIH8UjCa4wVWuLs1tPnUpjnrsXwOyLFbj803RkZn1Re2FKsOFz4
nv/G6ZgY6Yz0aYGVrSY5wXXuCUJQ6gXeP5igeSalo1f9Qqkw/w5+3/hRDmdE
uWU/PgeuOzT1ffcHbJwdXbtvZHtIMJ13UvdV1rPo/tfhbQ02V2m5id3rquzj
ek4oH6LV6vkSpmPF6/GXNctQPDvl+IVyE0sr1OHPyuzDS5NgXj5HFDN31hD0
WQo/
=tUEh
-----END PGP SIGNATURE-----
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Tue, May 10, 2016 at 11:14 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
> I'm trying to get Soft iWARP compiling on the latest kernels and I'm
> running to an issue that I don't understand with port_immutable. I've
> added the struct and callback (is that the right term) as based on
> several other drivers, but I get a stack trace when I insert the
> module. If someone can give me some pointers would be helpful. The
> code is located at [0] in the siw branch. The siw driver is located in
> drivers/staging/rdma/siw.
>
> This is the stack trace I'm getting:
>
> [Tue May 10 10:59:27 2016] siw: module is from the staging directory,
> the quality is unknown, you have been warned.
> [Tue May 10 10:59:27 2016] ------------[ cut here ]------------
> [Tue May 10 10:59:27 2016] WARNING: CPU: 0 PID: 616 at
> drivers/infiniband/core/device.c:279 ib_register_device+0x2a6/0x4a0
> [ib_core]
> [Tue May 10 10:59:27 2016] Modules linked in: siw(C+) rdma_ucm rdma_cm
> configfs iw_cm ib_umad ib_ucm ib_uverbs ib_cm ib_sa ib_mad ib_core
> ib_addr snd_hda_codec_generic snd_hda_intel crct10dif_pclmul
> crc32_pclmul ghash_clmul
> ni_intel snd_hda_codec jitterentropy_rng sha256_ssse3 snd_hda_core
> sha256_generic hmac drbg ansi_cprng snd_hwdep snd_pcm snd_timer snd
> aesni_intel qxl acpi_cpufreq tpm_tis tpm ttm ppdev aes_x86_64 lrw
> soundcore gf128mul drm
> _kms_helper glue_helper virtio_console drm ablk_helper button pcspkr
> cryptd processor parport_pc i2c_piix4 serio_raw virtio_balloon parport
> sg 8250_fintek evdev autofs4 ext4 crc16 jbd2 mbcache dm_mod sr_mod
> cdrom ata_generi
> c virtio_blk crc32c_intel psmouse 8139too ata_piix ehci_pci uhci_hcd
> ehci_hcd usbcore usb_common virtio_pci virtio_ring virtio 8139cp mii
> libata scsi_mod
> [Tue May 10 10:59:27 2016]  floppy [last unloaded: ib_addr]
> [Tue May 10 10:59:27 2016] CPU: 0 PID: 616 Comm: modprobe Tainted: G
>      WC      4.6.0-rc5 #2
> [Tue May 10 10:59:27 2016] Hardware name: QEMU Standard PC (i440FX +
> PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> [Tue May 10 10:59:27 2016]  0000000000000286 00000000783c356c
> ffffffff81309705 0000000000000000
> [Tue May 10 10:59:27 2016]  0000000000000000 ffffffff8107a40e
> ffff88002c0d3370 ffff88002cacd000
> [Tue May 10 10:59:27 2016]  ffff88002cacd008 00000000ffffffea
> 0000000000000000 0000000000000001
> [Tue May 10 10:59:27 2016] Call Trace:
> [Tue May 10 10:59:27 2016]  [] ? dump_stack+0x5c/0x77
> [Tue May 10 10:59:27 2016]  [] ? __warn+0xbe/0xe0
> [Tue May 10 10:59:27 2016]  [] ? ib_register_device+0x2a6/0x4a0 [ib_core]
> [Tue May 10 10:59:27 2016]  [] ? complete_all+0x31/0x40
> [Tue May 10 10:59:27 2016]  [] ? siw_netdev_event+0xd7/0x7a0 [siw]
> [Tue May 10 10:59:27 2016]  [] ? register_netdevice_notifier+0x1b4/0x1c0
> [Tue May 10 10:59:27 2016]  [] ? 0xffffffffa0565000
> [Tue May 10 10:59:27 2016]  [] ? siw_init_module+0x5c/0xae [siw]
> [Tue May 10 10:59:27 2016]  [] ? do_one_initcall+0xb2/0x200
> [Tue May 10 10:59:27 2016]  [] ? do_init_module+0x5b/0x1d6
> [Tue May 10 10:59:27 2016]  [] ? load_module+0x21f7/0x2800
> [Tue May 10 10:59:27 2016]  [] ? __symbol_put+0x60/0x60
> [Tue May 10 10:59:27 2016]  [] ? vfs_read+0x109/0x120
> [Tue May 10 10:59:27 2016]  [] ? security_capable+0x41/0x60
> [Tue May 10 10:59:27 2016]  [] ? SYSC_finit_module+0xc9/0x100
> [Tue May 10 10:59:27 2016]  [] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
> [Tue May 10 10:59:27 2016] ---[ end trace 940cc966bc2a32cf ]---
> [Tue May 10 10:59:27 2016] Couldn't create per port immutable data siw_lo
> [Tue May 10 10:59:27 2016] ------------[ cut here ]------------
> [Tue May 10 10:59:27 2016] WARNING: CPU: 0 PID: 616 at
> drivers/infiniband/core/device.c:279 ib_register_device+0x2a6/0x4a0
> [ib_core]
> [Tue May 10 10:59:27 2016] Modules linked in: siw(C+) rdma_ucm rdma_cm
> configfs iw_cm ib_umad ib_ucm ib_uverbs ib_cm ib_sa ib_mad ib_core
> ib_addr snd_hda_codec_generic snd_hda_intel crct10dif_pclmul
> crc32_pclmul ghash_clmul
> ni_intel snd_hda_codec jitterentropy_rng sha256_ssse3 snd_hda_core
> sha256_generic hmac drbg ansi_cprng snd_hwdep snd_pcm snd_timer snd
> aesni_intel qxl acpi_cpufreq tpm_tis tpm ttm ppdev aes_x86_64 lrw
> soundcore gf128mul drm
> _kms_helper glue_helper virtio_console drm ablk_helper button pcspkr
> cryptd processor parport_pc i2c_piix4 serio_raw virtio_balloon parport
> sg 8250_fintek evdev autofs4 ext4 crc16 jbd2 mbcache dm_mod sr_mod
> cdrom ata_generi
> c virtio_blk crc32c_intel psmouse 8139too ata_piix ehci_pci uhci_hcd
> ehci_hcd usbcore usb_common virtio_pci virtio_ring virtio 8139cp mii
> libata scsi_mod
> [Tue May 10 10:59:27 2016]  floppy [last unloaded: ib_addr]
> [Tue May 10 10:59:27 2016] CPU: 0 PID: 616 Comm: modprobe Tainted: G
>      WC      4.6.0-rc5 #2
> [Tue May 10 10:59:27 2016] Hardware name: QEMU Standard PC (i440FX +
> PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> [Tue May 10 10:59:27 2016]  0000000000000286 00000000783c356c
> ffffffff81309705 0000000000000000
> [Tue May 10 10:59:27 2016]  0000000000000000 ffffffff8107a40e
> ffff880036b5a5b0 ffff880036b5f000
> [Tue May 10 10:59:27 2016]  ffff880036b5f008 00000000ffffffea
> 0000000000000000 0000000000000001
> [Tue May 10 10:59:27 2016] Call Trace:
> [Tue May 10 10:59:27 2016]  [] ? dump_stack+0x5c/0x77
> [Tue May 10 10:59:27 2016]  [] ? __warn+0xbe/0xe0
> [Tue May 10 10:59:27 2016]  [] ? ib_register_device+0x2a6/0x4a0 [ib_core]
> [Tue May 10 10:59:27 2016]  [] ? complete_all+0x31/0x40
> [Tue May 10 10:59:27 2016]  [] ? siw_netdev_event+0xd7/0x7a0 [siw]
> [Tue May 10 10:59:27 2016]  [] ? register_netdevice_notifier+0x1b4/0x1c0
> [Tue May 10 10:59:27 2016]  [] ? 0xffffffffa0565000
> [Tue May 10 10:59:27 2016]  [] ? siw_init_module+0x5c/0xae [siw]
> [Tue May 10 10:59:27 2016]  [] ? do_one_initcall+0xb2/0x200
> [Tue May 10 10:59:27 2016]  [] ? do_init_module+0x5b/0x1d6
> [Tue May 10 10:59:27 2016]  [] ? load_module+0x21f7/0x2800
> [Tue May 10 10:59:27 2016]  [] ? __symbol_put+0x60/0x60
> [Tue May 10 10:59:27 2016]  [] ? vfs_read+0x109/0x120
> [Tue May 10 10:59:27 2016]  [] ? security_capable+0x41/0x60
> [Tue May 10 10:59:27 2016]  [] ? SYSC_finit_module+0xc9/0x100
> [Tue May 10 10:59:27 2016]  [] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
> [Tue May 10 10:59:27 2016] ---[ end trace 940cc966bc2a32d0 ]---
> [Tue May 10 10:59:27 2016] Couldn't create per port immutable data siw_ens3
> [Tue May 10 10:59:27 2016] SoftIWARP attached
>
>
> [0] https://github.com/rldleblanc/linux/tree/siw
>
> Thanks,
> - ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> -----BEGIN PGP SIGNATURE-----
> Version: Mailvelope v1.4.0
> Comment: https://www.mailvelope.com
>
> wsFcBAEBCAAQBQJXMhbpCRDmVDuy+mK58QAA8BYP/RZlRzEw0Wqra+nK1xT5
> BqREHrSwCdrlzpynabWNeFYQtFWjfNDBL9+6Q7TUDX2w7eE7je0Pchhf2VOA
> OKnB/FZ9B2tTbtV2uok9NPvzbn82IeKANB7gdrzxG3356gOWFPmeYIyvZXIt
> oL6NEuc3HL5NOxQieM2f2RuxMtxvty1sEp5N4P104hFONyPySgFAc89kUEu+
> R+/DDiQvUJMKhItKLkYKpiHEmu1dP/GnrzEDp18liPrpziY30biaF+Ugc0so
> esqKmBDal6sjYnE9Zk4PR98ynAX9t7DgcM8pLoKEAEM5qKR6yK0oFrFTx5eK
> rmo1Zj7HNOKYf7EJM7ExgcdKzFmp9ST9jXpXwJ+YDG4MvCHn+5xA+oEni6oz
> xYYu+UePEwrZssRVmTSyfOjUnopvPkK7iyL6CVmvMIebo/kocVcyltdoQzOi
> QWGlHfWs4DpUZnPjTHpcNAiutgvzc9/Mozv5sTrqnwXS7yVGp1uUMDn9Rzjj
> wwYKZeMQRjwHB56WJlfEYu8rjsvZjFnpdRUg2HhNloA2h3slboAVUksmd7oI
> +WAqDWfh08ZwQv1875aXyFwgqIeeN4wIKIP/nT2zQ6HdPHoM9fqOc/HtL5L0
> o8WltNgd+gO2ql5WTs4nyr/WjvaMyQugJRHRqyH6p4RIxbKkKR/tPrK877fZ
> WIys
> =e53M
> -----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
