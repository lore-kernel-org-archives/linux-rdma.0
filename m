From: Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING: kmalloc bug in memdup_user
Date: Wed, 7 Mar 2018 14:02:15 +0200
Message-ID: <20180307120215.GM15340@mtr-leonro.local>
References: <001a1140e0de22a4900566cd1851@google.com>
 <20180307072311.GL15340@mtr-leonro.local>
 <CACT4Y+a1HGE4Cb_faXswH2yrFbVAJtPmS1CbWLS1+Z8qzTZbdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+a1HGE4Cb_faXswH2yrFbVAJtPmS1CbWLS1+Z8qzTZbdA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+a38b0e9f694c379ca7ce@syzkaller.appspotmail.com>, dasaratharaman.chandramouli@intel.com, dledford@redhat.com, don.hiatt@intel.com, ira.weiny@intel.com, Jason Gunthorpe <jgg@ziepe.ca>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, parav@mellanox.com, syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-rdma@vger.kernel.org


--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2018 at 09:44:23AM +0100, Dmitry Vyukov wrote:
> On Wed, Mar 7, 2018 at 8:23 AM, Leon Romanovsky <leon@kernel.org> wrote:
> > On Tue, Mar 06, 2018 at 10:59:02PM -0800, syzbot wrote:
> >> Hello,
> >>
> >> syzbot hit the following crash on upstream commit
> >> ce380619fab99036f5e745c7a865b21c59f005f6 (Tue Mar 6 04:31:14 2018 +0000)
> >> Merge tag 'please-pull-ia64_misc' of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
> >>
> >> So far this crash happened 52 times on upstream.
> >> C reproducer is attached.
> >> syzkaller reproducer is attached.
> >> Raw console output is attached.
> >> compiler: gcc (GCC) 7.1.1 20170620
> >> .config is attached.
> >>
> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> Reported-by: syzbot+a38b0e9f694c379ca7ce@syzkaller.appspotmail.com
> >> It will help syzbot understand when the bug is fixed. See footer for
> >> details.
> >> If you forward the report, please keep this part and the footer.
> >>
> >> audit: type=1400 audit(1520367364.281:6): avc:  denied  { map } for
> >> pid=4138 comm="bash" path="/bin/bash" dev="sda1" ino=1457
> >> scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> >> tcontext=system_u:object_r:file_t:s0 tclass=file permissive=1
> >> audit: type=1400 audit(1520367370.605:7): avc:  denied  { map } for
> >> pid=4152 comm="syzkaller100190" path="/root/syzkaller100190328" dev="sda1"
> >> ino=16481 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> >> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> >> WARNING: CPU: 0 PID: 4152 at mm/slab_common.c:1012 kmalloc_slab+0x5d/0x70
> >> mm/slab_common.c:1012
> >> Kernel panic - not syncing: panic_on_warn set ...
> >>
> >> CPU: 0 PID: 4152 Comm: syzkaller100190 Not tainted 4.16.0-rc4+ #343
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> >> Google 01/01/2011
> >> Call Trace:
> >>  __dump_stack lib/dump_stack.c:17 [inline]
> >>  dump_stack+0x194/0x24d lib/dump_stack.c:53
> >>  panic+0x1e4/0x41c kernel/panic.c:183
> >>  __warn+0x1dc/0x200 kernel/panic.c:547
> >>  report_bug+0x211/0x2d0 lib/bug.c:184
> >>  fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
> >>  fixup_bug arch/x86/kernel/traps.c:247 [inline]
> >>  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
> >>  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
> >>  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:986
> >> RIP: 0010:kmalloc_slab+0x5d/0x70 mm/slab_common.c:1012
> >> RSP: 0018:ffff8801bf76f970 EFLAGS: 00010246
> >> RAX: 0000000000000000 RBX: fffffffffffffff4 RCX: ffffffff819733cb
> >> RDX: ffffffff8423372f RSI: 0000000000000000 RDI: 000000003efef4b4
> >> RBP: ffff8801bf76f970 R08: 0000000000000000 R09: 0000000000000000
> >> R10: ffffffff88613380 R11: 0000000000000000 R12: 000000003efef4b4
> >> R13: 0000000020000080 R14: 00000000014200c0 R15: ffff8801bf76fa68
> >>  __do_kmalloc mm/slab.c:3700 [inline]
> >>  __kmalloc_track_caller+0x21/0x760 mm/slab.c:3720
> >>  memdup_user+0x2c/0x90 mm/util.c:160
> >>  ucma_set_option+0x11f/0x4d0 drivers/infiniband/core/ucma.c:1297
> >>  ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1627
> >>  __vfs_write+0xef/0x970 fs/read_write.c:480
> >>  vfs_write+0x189/0x510 fs/read_write.c:544
> >>  SYSC_write fs/read_write.c:589 [inline]
> >>  SyS_write+0xef/0x220 fs/read_write.c:581
> >>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
> >>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> >> RIP: 0033:0x43fe69
> >> RSP: 002b:00007ffe099a6388 EFLAGS: 00000217 ORIG_RAX: 0000000000000001
> >> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 000000000043fe69
> >> RDX: 000000000000006b RSI: 00000000200000c0 RDI: 0000000000000003
> >> RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
> >> R10: 00000000004002c8 R11: 0000000000000217 R12: 0000000000401790
> >> R13: 0000000000401820 R14: 0000000000000000 R15: 0000000000000000
> >> Dumping ftrace buffer:
> >>    (ftrace buffer empty)
> >> Kernel Offset: disabled
> >> Rebooting in 86400 seconds..
> >
> > I'm surprised that it surfed only now.
> > It is clear bug, user's input wasn't checked.
>
>
> This is very simple. syzkaller did not test rdma_cm before.

:), Dmitry, this complain was addressed to my RDMA colleagues and not to you.

> Just yesterday I added descriptions for /dev/infiniband/rdma_cm API:
> https://github.com/google/syzkaller/blob/master/sys/linux/rdma_cm.txt
> This gave me ~10 different crashes immediately, but syzkaller wasn't
> able to progress too far because for now all VMs crash on these
> previous bugs within seconds.

Expected, we had similar thing with /dev/infiniband/uverbs.
See all my latest patches to RDMA with fixes.

>
> I am pretty sure syzkaller still does not test lots of other
> rdma-related things, but there is no reason to believe that they
> contain fewer bugs (like these easily exploitable bugs on
> world-writable device).

Right

> In order to teach syzkaller to test other rdma stuff one needs to add
> descriptions similar to the one above.
>
>
> > But it is not clear to me why optval wasn't declared as u64.
>
> After deciphering the API (headers and sources really) I came to
> conclusion that this is a pointer declared as u64 so that compat
> interface is not different from normal one.
>
> This API deciphering is hard for somebody who has absolutely no idea
> what's rdma whatsoever. So syzkaller descriptions not written by you
> (rdma developers) tend to be low quality, e.g. one needs to figure out
> that rdma_ucm_destroy_id.id needs to be an id of rdma_cm context of
> mcast group id depending on command that that's previously returned in
> this and that fields of responses to this and that commands. And if
> this is messed up, syzkaller won't be able to chain meaningful syscall
> sequences.

Believe me, this RDMA thing is hard for RDMA developers too :)

Thanks for doing it.


--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqf1McACgkQ5GN7iDZy
WKfEqxAAoBclbgP05tQ5ThHrRSI5q4D4uvlfQeFHwxlZPbmR3kGOiiBE+AlxxAb3
HHMzeuu60ZgN+cvw6KKs560BP1TJ1SoW8xGlc1dX78Nk1w+dYwB/RM6kuft3JtlW
bVCcsD1oZsL37zT5u7L+2OcvLAPsv9uc3+Exi3prUZc8yZpZv1Wy8JHg4k7gH29u
8tQvq12x3i8HTexEJm3G5V0gawrQMwuV/iHh/P7l7BiE6xdQ27DhPvXTHuYM12Y7
wnRsZCl6Dmjxxio2SgBQZlabxrQIrG8hTwuy4rZaYTGuh8Zd9tEnNOk44UhqkWxy
aVfvpR4RhDS+0vHLy/bbujJytZTjRTovytOXVV4qt7tlRZUAjVoh6RSd+YqfzfA1
D3fE9lq+dz2SnzpIWGExkLfa7SWLpZui0bOT/ZXGKhMrZqscmHwUH+H/Pld4HWBj
EYqo0VOlrDgEgh1BEKZDydrrJDT0glOBlDt5GV9IW2mlxxuexIqIfyq66cdyLOli
QlJySjIS3GQ0Rd13+95gByJXPZDjrwRRjG4GlLCFH4Y9/KiTy1XSQIcWCi1vPP0R
FMOSTb73jckDY53YzLJBomzJr5wEiTNsWJDLzjXi9ZvlXesce+WcR3reg1mjMufT
8eNgcj2uZaNJquBeEfF4dA1+qqVSCSkeYuvgRUl5K6AQx94oEh8=
=4ueH
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
