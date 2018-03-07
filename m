From: Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING: kmalloc bug in memdup_user
Date: Wed, 7 Mar 2018 09:23:12 +0200
Message-ID: <20180307072311.GL15340@mtr-leonro.local>
References: <001a1140e0de22a4900566cd1851@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tSiBuZsJmMXpnp7T"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a1140e0de22a4900566cd1851@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+a38b0e9f694c379ca7ce@syzkaller.appspotmail.com>
Cc: dasaratharaman.chandramouli@intel.com, dledford@redhat.com, don.hiatt@intel.com, ira.weiny@intel.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
List-Id: linux-rdma@vger.kernel.org


--tSiBuZsJmMXpnp7T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 06, 2018 at 10:59:02PM -0800, syzbot wrote:
> Hello,
>
> syzbot hit the following crash on upstream commit
> ce380619fab99036f5e745c7a865b21c59f005f6 (Tue Mar 6 04:31:14 2018 +0000)
> Merge tag 'please-pull-ia64_misc' of
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
>
> So far this crash happened 52 times on upstream.
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a38b0e9f694c379ca7ce@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
>
> audit: type=1400 audit(1520367364.281:6): avc:  denied  { map } for
> pid=4138 comm="bash" path="/bin/bash" dev="sda1" ino=1457
> scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=system_u:object_r:file_t:s0 tclass=file permissive=1
> audit: type=1400 audit(1520367370.605:7): avc:  denied  { map } for
> pid=4152 comm="syzkaller100190" path="/root/syzkaller100190328" dev="sda1"
> ino=16481 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> WARNING: CPU: 0 PID: 4152 at mm/slab_common.c:1012 kmalloc_slab+0x5d/0x70
> mm/slab_common.c:1012
> Kernel panic - not syncing: panic_on_warn set ...
>
> CPU: 0 PID: 4152 Comm: syzkaller100190 Not tainted 4.16.0-rc4+ #343
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x24d lib/dump_stack.c:53
>  panic+0x1e4/0x41c kernel/panic.c:183
>  __warn+0x1dc/0x200 kernel/panic.c:547
>  report_bug+0x211/0x2d0 lib/bug.c:184
>  fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
>  fixup_bug arch/x86/kernel/traps.c:247 [inline]
>  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
>  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
>  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:986
> RIP: 0010:kmalloc_slab+0x5d/0x70 mm/slab_common.c:1012
> RSP: 0018:ffff8801bf76f970 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: fffffffffffffff4 RCX: ffffffff819733cb
> RDX: ffffffff8423372f RSI: 0000000000000000 RDI: 000000003efef4b4
> RBP: ffff8801bf76f970 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff88613380 R11: 0000000000000000 R12: 000000003efef4b4
> R13: 0000000020000080 R14: 00000000014200c0 R15: ffff8801bf76fa68
>  __do_kmalloc mm/slab.c:3700 [inline]
>  __kmalloc_track_caller+0x21/0x760 mm/slab.c:3720
>  memdup_user+0x2c/0x90 mm/util.c:160
>  ucma_set_option+0x11f/0x4d0 drivers/infiniband/core/ucma.c:1297
>  ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1627
>  __vfs_write+0xef/0x970 fs/read_write.c:480
>  vfs_write+0x189/0x510 fs/read_write.c:544
>  SYSC_write fs/read_write.c:589 [inline]
>  SyS_write+0xef/0x220 fs/read_write.c:581
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x43fe69
> RSP: 002b:00007ffe099a6388 EFLAGS: 00000217 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 000000000043fe69
> RDX: 000000000000006b RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
> R10: 00000000004002c8 R11: 0000000000000217 R12: 0000000000401790
> R13: 0000000000401820 R14: 0000000000000000 R15: 0000000000000000
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

I'm surprised that it surfed only now.
It is clear bug, user's input wasn't checked.
But it is not clear to me why optval wasn't declared as u64.

Thanks

--tSiBuZsJmMXpnp7T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqfk18ACgkQ5GN7iDZy
WKe8TBAArP2M22Y28PZs+HyBE8xLdTl6MiMAdrKS1fTAYXZflCc0XHvWpwVz5p8Z
0kXsTclrhza8b4dHuRu5rhgUryQM3TiIlsE9t6xjJyeQWo69NSdmOU6nD8IvBWPF
2JUX/akVkx7K+pnneWhR9TV8hz/6Fue5k1AzhRTHE4YneNLMjuG3EdqsslxUHN6y
NBszrD9BU9P6jc8MDhqUaJRonDOHds7Inleljm42781e35TxHIQKLlCbo2Spe3ws
dwtAzIme8315zgjyQGsRCLa88kH+4YYGaRLiNcWsd8X8RaVAsAqPkQ2G/xWMyG1Q
RIg6Iu3OGrM7Ffr+Dv40WwdSGuZAovtJmpPM8MJhia5+yj8+yWdZS6e2s/4xfmSm
Y2CiNoLTflMfxTkqHTLaIk5z8jri6XrJwgkW+U0KkAh3e7XxdI0dbD4vvNZxFQh7
RlYHgxL7K5VcbB6aOmHbstwYFIBLsGKnp0ElFRHV0S2aeDmIup2EENenThL9cEz8
qAON/HLAXnu0SWLphHDLdw9WjuFvhbJPR37kJkdNUYSLqVWn1++wDFprFXKYhOyz
EuI+APv2R1QZSiJ2Eqh1mJ1db5mq3CjAqQq0x119ZWlotyGs/v1SZWrPdI+0dUEy
pboQRJ9ffv2loh665ps1kW6gsi7xbUYOR/kM7dU0I2NaZIcQmt8=
=Y23e
-----END PGP SIGNATURE-----

--tSiBuZsJmMXpnp7T--
