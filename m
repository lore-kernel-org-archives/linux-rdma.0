From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in rds_cong_queue_updates
Date: Mon, 19 Mar 2018 09:29:12 +0300
Message-ID: <CACT4Y+Y_K_GQq0ZgwMNEWuHx6k3BWQZKCoNT8BOWsB-mxL2Szw@mail.gmail.com>
References: <001a114aacf82781120565c9f4fe@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a114aacf82781120565c9f4fe@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+80c06fb3aabfa386bc06@syzkaller.appspotmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 22, 2018 at 12:49 PM, syzbot
<syzbot+80c06fb3aabfa386bc06@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot hit the following crash on upstream commit
> 79c0ef3e85c015b0921a8fd5dd539d1480e9cd6c (Mon Feb 19 19:58:19 2018 +0000)
> Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
>
> So far this crash happened 28 times on
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/master.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> user-space arch: i386


This looks the same as:

#syz dup: KASAN: use-after-free Read in rds_cong_queue_updates

> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+80c06fb3aabfa386bc06@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
>
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in __read_once_size
> include/linux/compiler.h:183 [inline]
> BUG: KASAN: slab-out-of-bounds in atomic_read
> arch/x86/include/asm/atomic.h:27 [inline]
> BUG: KASAN: slab-out-of-bounds in refcount_read include/linux/refcount.h:42
> [inline]
> BUG: KASAN: slab-out-of-bounds in check_net include/net/net_namespace.h:228
> [inline]
> BUG: KASAN: slab-out-of-bounds in rds_destroy_pending net/rds/rds.h:868
> [inline]
> BUG: KASAN: slab-out-of-bounds in rds_cong_queue_updates+0x4d2/0x4f0
> net/rds/cong.c:226
> Read of size 4 at addr ffff8801d31a0044 by task syz-executor1/21851
>
> CPU: 1 PID: 21851 Comm: syz-executor1 Not tainted 4.16.0-rc2+ #232
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report+0x23b/0x360 mm/kasan/report.c:412
>  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
>  __read_once_size include/linux/compiler.h:183 [inline]
>  atomic_read arch/x86/include/asm/atomic.h:27 [inline]
>  refcount_read include/linux/refcount.h:42 [inline]
>  check_net include/net/net_namespace.h:228 [inline]
>  rds_destroy_pending net/rds/rds.h:868 [inline]
>  rds_cong_queue_updates+0x4d2/0x4f0 net/rds/cong.c:226
>  rds_recv_rcvbuf_delta.part.2+0x289/0x320 net/rds/recv.c:118
>  rds_recv_rcvbuf_delta net/rds/recv.c:377 [inline]
>  rds_recv_incoming+0xeb4/0x11d0 net/rds/recv.c:377
>  rds_loop_xmit+0x149/0x320 net/rds/loop.c:82
>  rds_send_xmit+0xbcc/0x26b0 net/rds/send.c:355
>  rds_sendmsg+0x1fcb/0x2390 net/rds/send.c:1208
>  sock_sendmsg_nosec net/socket.c:630 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:640
>  SYSC_sendto+0x361/0x5c0 net/socket.c:1747
>  SyS_sendto+0x40/0x50 net/socket.c:1715
>  do_syscall_32_irqs_on arch/x86/entry/common.c:330 [inline]
>  do_fast_syscall_32+0x3ec/0xf9f arch/x86/entry/common.c:392
>  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
> RIP: 0023:0xf7f9ac79
> RSP: 002b:00000000f779609c EFLAGS: 00000286 ORIG_RAX: 0000000000000171
> RAX: ffffffffffffffda RBX: 0000000000000013 RCX: 0000000020f7db7f
> RDX: 0000000000000481 RSI: 0000000000000000 RDI: 000000002069affb
> RBP: 0000000000000010 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>
> Allocated by task 20583:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:552
>  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:489
>  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3541
>  getname_flags+0xcb/0x580 fs/namei.c:138
>  user_path_at_empty+0x2d/0x50 fs/namei.c:2568
>  user_path_at include/linux/namei.h:57 [inline]
>  SYSC_chdir fs/open.c:440 [inline]
>  SyS_chdir+0xb0/0x200 fs/open.c:434
>  do_syscall_32_irqs_on arch/x86/entry/common.c:330 [inline]
>  do_fast_syscall_32+0x3ec/0xf9f arch/x86/entry/common.c:392
>  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
>
> Freed by task 20583:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:520
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:527
>  __cache_free mm/slab.c:3485 [inline]
>  kmem_cache_free+0x83/0x2a0 mm/slab.c:3743
>  putname+0xee/0x130 fs/namei.c:258
>  filename_lookup+0x315/0x500 fs/namei.c:2323
>  user_path_at_empty+0x40/0x50 fs/namei.c:2568
>  user_path_at include/linux/namei.h:57 [inline]
>  SYSC_chdir fs/open.c:440 [inline]
>  SyS_chdir+0xb0/0x200 fs/open.c:434
>  do_syscall_32_irqs_on arch/x86/entry/common.c:330 [inline]
>  do_fast_syscall_32+0x3ec/0xf9f arch/x86/entry/common.c:392
>  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
>
> The buggy address belongs to the object at ffff8801d31a0a00
>  which belongs to the cache names_cache of size 4096
> The buggy address is located 2492 bytes to the left of
>  4096-byte region [ffff8801d31a0a00, ffff8801d31a1a00)
> The buggy address belongs to the page:
> page:ffffea00074c6800 count:1 mapcount:0 mapping:ffff8801d31a0a00 index:0x0
> compound_mapcount: 0
> flags: 0x2fffc0000008100(slab|head)
> raw: 02fffc0000008100 ffff8801d31a0a00 0000000000000000 0000000100000001
> raw: ffffea0006d3b820 ffffea0006cf3920 ffff8801da9d4600 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8801d319ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8801d319ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>
>> ffff8801d31a0000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>
>                                            ^
>  ffff8801d31a0080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8801d31a0100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/001a114aacf82781120565c9f4fe%40google.com.
> For more options, visit https://groups.google.com/d/optout.
