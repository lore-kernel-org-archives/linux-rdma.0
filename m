From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in cma_cancel_operation
Date: Wed, 20 Feb 2019 16:29:19 +0100
Message-ID: <CACT4Y+ZW6GfgG64BY0ehusoOBKJ0Nv-trzMW0u7zuT56tc1z4w@mail.gmail.com>
References: <94eb2c054604ad40010568e8ea21@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94eb2c054604ad40010568e8ea21@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+6956235342b7317ec564@syzkaller.appspotmail.com>
Cc: dasaratharaman.chandramouli@intel.com, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leonro@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, markb@mellanox.com, monis@mellanox.com, parav@mellanox.com, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 3, 2018 at 5:01 AM syzbot
<syzbot+6956235342b7317ec564@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot hit the following crash on upstream commit
> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
> Merge branch 'ras-core-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=6956235342b7317ec564
>
> So far this crash happened 4 times on upstream.
> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=6621340819783680
> syzkaller reproducer:
> https://syzkaller.appspot.com/x/repro.syz?id=6075521074987008
> Raw console output:
> https://syzkaller.appspot.com/x/log.txt?id=6447569127342080
> Kernel config:
> https://syzkaller.appspot.com/x/.config?id=6801295859785128502
> compiler: gcc (GCC) 7.1.1 20170620
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6956235342b7317ec564@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.

First crash: 323d, last: 12h23m

https://syzkaller.appspot.com/bug?extid=6956235342b7317ec564

> ==================================================================
> BUG: KASAN: use-after-free in __list_del_entry_valid+0x144/0x150
> lib/list_debug.c:54
> Read of size 8 at addr ffff8801d8dc7d20 by task syzkaller468166/4496
>
> CPU: 0 PID: 4496 Comm: syzkaller468166 Not tainted 4.16.0+ #376
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:17 [inline]
>   dump_stack+0x1a7/0x27d lib/dump_stack.c:53
>   print_address_description+0x73/0x250 mm/kasan/report.c:256
>   kasan_report_error mm/kasan/report.c:354 [inline]
>   kasan_report+0x23c/0x360 mm/kasan/report.c:412
>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
>   __list_del_entry_valid+0x144/0x150 lib/list_debug.c:54
>   __list_del_entry include/linux/list.h:117 [inline]
>   list_del include/linux/list.h:125 [inline]
>   cma_cancel_listens drivers/infiniband/core/cma.c:1569 [inline]
>   cma_cancel_operation+0x455/0xd60 drivers/infiniband/core/cma.c:1597
>   rdma_destroy_id+0xff/0xda0 drivers/infiniband/core/cma.c:1661
>   ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1735
>   __fput+0x327/0x7f0 fs/file_table.c:209
>   ____fput+0x15/0x20 fs/file_table.c:243
>   task_work_run+0x1ab/0x280 kernel/task_work.c:113
>   exit_task_work include/linux/task_work.h:22 [inline]
>   do_exit+0x1986/0x2700 kernel/exit.c:865
>   do_group_exit+0x149/0x400 kernel/exit.c:968
>   get_signal+0x74c/0x16e0 kernel/signal.c:2469
>   do_signal+0x90/0x1e90 arch/x86/kernel/signal.c:809
>   exit_to_usermode_loop+0x258/0x2f0 arch/x86/entry/common.c:162
>   prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
>   do_syscall_64+0x6ec/0x940 arch/x86/entry/common.c:292
>   entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x446b09
> RSP: 002b:00007f2b89150da8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00000000006e29fc RCX: 0000000000446b09
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000006e29fc
> RBP: 00000000006e29f8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 006d635f616d6472
> R13: 2f646e6162696e69 R14: 666e692f7665642f R15: 0000000000000005
>
> Allocated by task 4493:
>   save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>   set_track mm/kasan/kasan.c:459 [inline]
>   kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:552
>   kmem_cache_alloc_trace+0x136/0x740 mm/slab.c:3608
>   kmalloc include/linux/slab.h:512 [inline]
>   kzalloc include/linux/slab.h:701 [inline]
>   rdma_create_id+0xd0/0x640 drivers/infiniband/core/cma.c:787
>   ucma_create_id+0x35f/0x920 drivers/infiniband/core/ucma.c:480
>   ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1656
>   __vfs_write+0xef/0x970 fs/read_write.c:480
>   vfs_write+0x189/0x510 fs/read_write.c:544
>   SYSC_write fs/read_write.c:589 [inline]
>   SyS_write+0xef/0x220 fs/read_write.c:581
>   do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>   entry_SYSCALL_64_after_hwframe+0x42/0xb7
>
> Freed by task 4496:
>   save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>   set_track mm/kasan/kasan.c:459 [inline]
>   __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:520
>   kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:527
>   __cache_free mm/slab.c:3486 [inline]
>   kfree+0xd9/0x260 mm/slab.c:3801
>   rdma_destroy_id+0x821/0xda0 drivers/infiniband/core/cma.c:1691
>   ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1735
>   __fput+0x327/0x7f0 fs/file_table.c:209
>   ____fput+0x15/0x20 fs/file_table.c:243
>   task_work_run+0x1ab/0x280 kernel/task_work.c:113
>   exit_task_work include/linux/task_work.h:22 [inline]
>   do_exit+0x1986/0x2700 kernel/exit.c:865
>   do_group_exit+0x149/0x400 kernel/exit.c:968
>   get_signal+0x74c/0x16e0 kernel/signal.c:2469
>   do_signal+0x90/0x1e90 arch/x86/kernel/signal.c:809
>   exit_to_usermode_loop+0x258/0x2f0 arch/x86/entry/common.c:162
>   prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
>   do_syscall_64+0x6ec/0x940 arch/x86/entry/common.c:292
>   entry_SYSCALL_64_after_hwframe+0x42/0xb7
>
> The buggy address belongs to the object at ffff8801d8dc7b40
>   which belongs to the cache kmalloc-1024 of size 1024
> The buggy address is located 480 bytes inside of
>   1024-byte region [ffff8801d8dc7b40, ffff8801d8dc7f40)
> The buggy address belongs to the page:
> page:ffffea0007637180 count:1 mapcount:0 mapping:ffff8801d8dc6040 index:0x0
> compound_mapcount: 0
> flags: 0x2fffc0000008100(slab|head)
> raw: 02fffc0000008100 ffff8801d8dc6040 0000000000000000 0000000100000007
> raw: ffffea0007635ea0 ffff8801dac01848 ffff8801dac00ac0 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8801d8dc7c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8801d8dc7c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff8801d8dc7d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                 ^
>   ffff8801d8dc7d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8801d8dc7e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> If you want to test a patch for this bug, please reply with:
> #syz test: git://repo/address.git branch
> and provide the patch inline or as an attachment.
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/94eb2c054604ad40010568e8ea21%40google.com.
> For more options, visit https://groups.google.com/d/optout.
