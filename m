From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mad: Use ID allocator routines to allocate agent
 number
Date: Tue, 29 May 2018 12:54:45 +0300
Message-ID: <20180529095445.GG3697@mtr-leonro.mtl.com>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180529085459.GF3697@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529085459.GF3697@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Hakon Bugge <haakon.bugge@oracle.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 29, 2018 at 11:54:59AM +0300, Leon Romanovsky wrote:
> On Tue, May 29, 2018 at 09:38:08AM +0200, Hans Westgaard Ry wrote:
> > The agent TID is a 64 bit value split in two dwords.  The least
> > significant dword is the TID running counter. The most significant
> > dword is the agent number. In the CX-3 shared port model, the mlx4
> > driver uses the most significant byte of the agent number to store the
> > slave number, making agent numbers greater and equal to 2^24 (3 bytes)
> > unusable.  The current codebase uses a variable which is incremented
> > atomically for each new agent number giving too large agent numbers
> > over time.  The IDA set of functions are used instead of the simple
> > counter approach. This allows re-use of agent numbers. A sysctl
> > variable is also introduced, to control the max agent number.
>
> Why don't you simply limit this number per-driver? By default, any
> variable is allowed and mlx4_ib will set something else.
>
> What is the advantage of having sysctl?

Anyway, it doesn't pass smoke test.

[  126.428407] RPC: Unregistered rdma transport module.
[  126.428513] RPC: Unregistered rdma backchannel transport module.
[  194.664081] IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
[  209.068702] BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
[  209.068858] PGD 80000000341cf067 P4D 80000000341cf067 PUD 34188067 PMD 0
[  209.068941] Oops: 0002 [#1] SMP PTI
[  209.069006] Modules linked in: netconsole nfsv3 nfs fscache
mlx4_ib(-) mlx4_en mlx4_core devlink ib_ipoib rdma_ucm ib_ucm ib_uverbs
ib_umad rdma_cm ib_cm iw_cm ib_core dm_mirror dm_region_hash dm_log
dm_mod nfsd pcspkr i2c_piix4 auth_rpcgss nfs_acl lockd grace sunrpc
ip_tables ata_generic cirrus drm_kms_helper pata_acpi syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm drm e1000 virtio_console i2c_core
serio_raw ata_piix floppy [last unloaded: mlxfw]
[  209.069312] CPU: 4 PID: 11048 Comm: modprobe Not tainted 4.17.0-rc7-2018-05-29_11-04-56_Hans_Westgaard_Ry__hans_westga #1
[  209.069413] Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
[  209.069486] RIP: 0010:_raw_spin_lock_irqsave+0x1e/0x40
[  209.069536] RSP: 0018:ffffc90000b4fd70 EFLAGS: 00010046
[  209.069591] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffffea0004d7ed00
[  209.069653] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000070
[  209.069717] RBP: 0000000000000000 R08: ffff88013446fc00 R09: 000000018010000f
[  209.069778] R10: 0000000000000001 R11: ffff88013446fc00 R12: 0000000000000070
[  209.069849] R13: 0000000000000202 R14: 0000000000000000 R15: 0000000000000000
[  209.069915] FS:  00007fc34caf7740(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
[  209.069987] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  209.070043] CR2: 0000000000000070 CR3: 000000008853e000 CR4: 00000000000006e0
[  209.070128] Call Trace:
[  209.070189]  ib_unregister_mad_agent+0x2d/0x540 [ib_core]
[  209.070260]  ? __slab_free+0x9a/0x2d0
[  209.070332]  ib_agent_port_close+0xad/0xf0 [ib_core]
[  209.070396]  ib_mad_remove_device+0x59/0xb0 [ib_core]
[  209.070466]  ib_unregister_device+0xd4/0x180 [ib_core]
[  209.070537]  mlx4_ib_remove+0x67/0x1f0 [mlx4_ib]
[  209.070594]  mlx4_remove_device+0x93/0xa0 [mlx4_core]
[  209.070648]  mlx4_unregister_interface+0x37/0x90 [mlx4_core]
[  209.070705]  mlx4_ib_cleanup+0xc/0x4db [mlx4_ib]
[  209.072113]  __x64_sys_delete_module+0x15b/0x260
[  209.073567]  ? exit_to_usermode_loop+0x7f/0x95
[  209.074945]  do_syscall_64+0x48/0x100
[  209.076448]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  209.077799] RIP: 0033:0x7fc34bfe36b7
[  209.079122] RSP: 002b:00007ffc8ffa98b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  209.080500] RAX: ffffffffffffffda RBX: 00000000013455c0 RCX: 00007fc34bfe36b7
[  209.081875] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000000001345628
[  209.083265] RBP: 0000000000000000 R08: 00007fc34c2a8060 R09: 00007fc34c053a40
[  209.084655] R10: 00007ffc8ffa9640 R11: 0000000000000206 R12: 0000000000000000
[  209.086028] R13: 0000000000000001 R14: 0000000001345628 R15: 0000000000000000
[  209.087416] Code: 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
00 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba 01 00
00 00 <f0> 0f b1 17 85 c0 75 05 48 89 d8 5b c3 89 c6 e8 1e c9 81 ff eb
[  209.090262] RIP: _raw_spin_lock_irqsave+0x1e/0x40 RSP: ffffc90000b4fd70
[  209.091720] CR2: 0000000000000070
[  209.093137] ---[ end trace 7b8a6faa27868861 ]---
[  209.094546] Kernel panic - not syncing: Fatal exception
[  209.096910] Kernel Offset: disabled
[  209.098291] ---[ end Kernel panic - not syncing: Fatal exception ]---

Thanks

>
> Thanks



--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbDSNlAAoJEORje4g2clin8AMQALwvb8EGT0pBWmz2ec3hCW2S
kqEynJc22mXk3O2Pz7R4rFG0UoUwTTVYYcYY7SMiJWV59M+BnpQ9jEihJ2Ng1ZlH
cEvRS9+Y53LRYYadWn0JHGeSEBKGugaPIB4grTnIF3Nvik+zvFsWCE2/2lkidATc
ExB4D8Or0tgkV+wCg3/sQmtAfQYFx6pzzftr5YKlVjSNUx3kMmM1VTjqIP9i96n7
jPWiW1rjSTG+9Mi6nMJKdjOZA7sjWBDDOrFGkYYmapVcuprEWQ7nWhhuylpCErJi
Gl1hiDlD1hfLQUoPI0F2LZ1Rx4ZADhxLBkZ3jFQVcfRgsmL/M/tP+Qd2CcZdsegI
0GBXd/fzkKAy2TTlpnUeQ3q6l21SI7mq1AKnSB87sd9fllTTvwgm3/9d7Qz/6Zlf
2GFDDDZOTbkgh/f5+oVnggWyR86GaAdIl0zVTkz33gP0OrVKIYe98GPqM7l5j0b9
ggc8hGMg83ReaWTby9K/VjelRJUTqOlaNNdmDn1Qv2KfyMVZTZq62VKU1dZY5nmw
fGk7++PKzDe+fHDTFQHIU3jIPxhsjyJQw2thwxlLK+kjqFjoUf3MMrgq7ymHz4Ho
mTHtFlyg35x2cMGvnvZXzzez8kTNu7/WFlvm6V4UZIoNGAgMeujWACey5bgupWAs
gXTtGXJg3Eayy1AR+0OF
=STt8
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
