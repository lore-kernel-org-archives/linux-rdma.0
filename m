From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: general protection fault in rdma_resolve_route
Date: Thu, 19 Apr 2018 10:23:10 -0600
Message-ID: <20180419162310.GC14063@ziepe.ca>
References: <0000000000005c2cc4056a35b85a@google.com>
 <VI1PR0502MB300899AC682257A6D3539E68D1B50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB300899AC682257A6D3539E68D1B50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: syzbot <syzbot+17c13600b3977aa8ef7f@syzkaller.appspotmail.com>, Daniel Jurgens <danielj@mellanox.com>, "dasaratharaman.chandramouli@intel.com" <dasaratharaman.chandramouli@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 19, 2018 at 04:12:20PM +0000, Parav Pandit wrote:
> 
> 
> > From: syzbot
> > [mailto:syzbot+17c13600b3977aa8ef7f@syzkaller.appspotmail.com]
> > Sent: Thursday, April 19, 2018 11:04 AM
> > To: Daniel Jurgens <danielj@mellanox.com>;
> > dasaratharaman.chandramouli@intel.com; dledford@redhat.com;
> > jgg@ziepe.ca; leon@kernel.org; linux-kernel@vger.kernel.org; linux-
> > rdma@vger.kernel.org; Moni Shoua <monis@mellanox.com>; Parav Pandit
> > <parav@mellanox.com>; swise@opengridcomputing.com; syzkaller-
> > bugs@googlegroups.com
> > Subject: general protection fault in rdma_resolve_route
> > 
> > Hello,
> > 
> > syzbot hit the following crash on upstream commit
> > a27fc14219f2e3c4a46ba9177b04d9b52c875532 (Mon Apr 16 21:07:39 2018
> > +0000) Merge branch 'parisc-4.17-3' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
> > syzbot dashboard link:
> > https://syzkaller.appspot.com/bug?extid=17c13600b3977aa8ef7f
> > 
> > So far this crash happened 2 times on upstream.
> > Unfortunately, I don't have any reproducer for this crash yet.
> > Raw console output:
> > https://syzkaller.appspot.com/x/log.txt?id=6198183931674624
> > Kernel config:
> > https://syzkaller.appspot.com/x/.config?id=-5914490758943236750
> > compiler: gcc (GCC) 8.0.1 20180413 (experimental)
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+17c13600b3977aa8ef7f@syzkaller.appspotmail.com
> > It will help syzbot understand when the bug is fixed. See footer for details.
> > If you forward the report, please keep this part and the footer.
> > 
> > kasan: CONFIG_KASAN_INLINE enabled
> > kasan: GPF could be caused by NULL-ptr deref or user memory access general
> > protection fault: 0000 [#1] SMP KASAN Dumping ftrace buffer:
> >     (ftrace buffer empty)
> > Modules linked in:
> > CPU: 1 PID: 750 Comm: syz-executor4 Not tainted 4.17.0-rc1+ #6 Hardware
> > name: Google Google Compute Engine/Google Compute Engine, BIOS Google
> > 01/01/2011
> > RIP: 0010:rdma_cap_ib_sa include/rdma/ib_verbs.h:2840 [inline]
> > RIP: 0010:rdma_resolve_route+0x134/0x2160
> > drivers/infiniband/core/cma.c:2668
> > RSP: 0018:ffff8801b3e87850 EFLAGS: 00010202
> > RAX: 0000000000000000 RBX: ffff8801abf92c00 RCX: 0000000000000029
> > RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000148
> > RBP: ffff8801b3e87a00 R08: ffffed00357f25e5 R09: ffffed00357f25e4
> > R10: ffffed00357f25e4 R11: ffff8801abf92f23 R12: 1ffff100367d0f12
> > R13: dffffc0000000000 R14: ffff8801abf92db8 R15: 0000000000000000
> > FS:  00007f673e752700(0000) GS:ffff8801db100000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000a3eab8 CR3: 00000001b10e7000 CR4: 00000000001426e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 Call
> > Trace:
> >   ucma_resolve_route+0x179/0x1c0 drivers/infiniband/core/ucma.c:741
> >   ucma_write+0x328/0x410 drivers/infiniband/core/ucma.c:1664
> >   __vfs_write+0x10b/0x880 fs/read_write.c:485
> >   vfs_write+0x1f8/0x560 fs/read_write.c:549
> >   ksys_write+0xf9/0x250 fs/read_write.c:598
> >   __do_sys_write fs/read_write.c:610 [inline]
> >   __se_sys_write fs/read_write.c:607 [inline]
> >   __x64_sys_write+0x73/0xb0 fs/read_write.c:607
> >   do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x455329
> > RSP: 002b:00007f673e751c68 EFLAGS: 00000246 ORIG_RAX:
> > 0000000000000001
> > RAX: ffffffffffffffda RBX: 00007f673e7526d4 RCX: 0000000000455329
> > RDX: 0000000000000010 RSI: 0000000020000100 RDI: 0000000000000014
> > RBP: 000000000072c010 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> > R13: 00000000000006c3 R14: 00000000006fd2e8 R15: 0000000000000002
> > Code: ff df 48 c1 ea 03 80 3c 02 00 0f 85 14 1c 00 00 48 ba 00 00 00 00 00 fc ff df
> > 48 8b 03 48 8d b8 48 01 00 00 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 d7 1b 00
> > 00 45 0f b6 ef 49 c1 e5 04 4c 03 a8
> > RIP: rdma_cap_ib_sa include/rdma/ib_verbs.h:2840 [inline] RSP:
> > ffff8801b3e87850
> > RIP: rdma_resolve_route+0x134/0x2160 drivers/infiniband/core/cma.c:2668
> > RSP: ffff8801b3e87850
> > 
> > 
> > This bug is generated by a dumb bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for details.
> > Direct all questions to syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this bug report.
> > If you forgot to add the Reported-by tag, once the fix for this bug is merged into
> > any tree, please reply to this email with:
> > #syz fix: exact-commit-title
> > To mark this as a duplicate of another syzbot report, please reply with:
> > #syz dup: exact-subject-of-another-report If it's a one-off invalid bug report,
> > please reply with:
> > #syz invalid
> > Note: if the crash happens again, it will cause creation of a new bug report.
> > Note: all commands must start from beginning of the line in the email body.
> 
> For short term, we need helper similar to ucma_get_ctx() as ucma_get_ctx_with_device() which performs NULL check for cm_id->device.
> Currently its done at several places in ucma commands such as ucma_set_ib_path, ucma_notify etc.

Like this?

https://patchwork.kernel.org/patch/10323727/

But I thought when I wrote this I couldn't find a case where the NULL
check was possible due to how the FSM was supposed to work :(

Ie how does this in rdma_resolve_route succeed without a cm_id->device?

if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED, RDMA_CM_ROUTE_QUERY))
                return -EINVAL;

Why hasn't state RDMA_CM_ADDR_RESOLVED set the device?

Is that the real bug here?

Jason
