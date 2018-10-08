From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in __put_task_struct (2)
Date: Mon, 8 Oct 2018 18:15:22 +0200
Message-ID: <CACT4Y+bfqk8Fczw4dJHhVzM63YhYNSovEE-KygZ1XmgUQVGCWQ@mail.gmail.com>
References: <000000000000b3d5610577b9e12c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000b3d5610577b9e12c@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com>, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, swise@opengridcomputing.com, markb@mellanox.com, linux-rdma@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, guro@fb.com, Kees Cook <keescook@chromium.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, marcos.souza.org@gmail.com, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Will Drewry <wad@chromium.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 8, 2018 at 6:12 PM, syzbot
<syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    ae16eea39a86 Add linux-next specific files for 20181008
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12e7c6a1400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=42525ce985d1a955
> dashboard link: https://syzkaller.appspot.com/bug?extid=1ed9dfaa984c88cf0ef8
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com


This was triggered by the following program, all is rdma-related, so
+rdma maintainers.

10:27:26 executing program 5:
r0 = openat$rdma_cm(0xffffffffffffff9c,
&(0x7f0000000380)='/dev/infiniband/rdma_cm\x00', 0x2, 0x0)
write$RDMA_USER_CM_CMD_CREATE_ID(r0, &(0x7f0000000080)={0x0, 0x18,
0xfa00, {0x0, &(0x7f0000000040)={<r1=>0xffffffffffffffff}, 0x13f}},
0x12d)
write$RDMA_USER_CM_CMD_RESOLVE_IP(r0, &(0x7f0000000200)={0x3, 0x40,
0xfa00, {{0xa, 0x4e21}, {0xa, 0x0, 0x0, @mcast1}, r1}}, 0x48)
write$RDMA_USER_CM_CMD_CREATE_ID(r0, &(0x7f0000000340)={0x0, 0x18,
0xfa00, {0x0, &(0x7f0000000300)={<r2=>0xffffffffffffffff}, 0x13f}},
0x20)
write$RDMA_USER_CM_CMD_SET_OPTION(r0, &(0x7f00000002c0)={0xe, 0x18,
0xfa00, @id_afonly={&(0x7f0000000000)=0x1, r1, 0x0, 0x2, 0x4}}, 0x20)
write$RDMA_USER_CM_CMD_RESOLVE_IP(r0, &(0x7f0000000100)={0x3, 0x40,
0xfa00, {{0x2, 0x4e21}, {0xa, 0x0, 0x0, @local}, r2}}, 0x1ff)
write$RDMA_USER_CM_CMD_DESTROY_ID(r0, &(0x7f0000000180)={0x1, 0x10,
0xfa00, {&(0x7f00000000c0), r2}}, 0x18)



> WARNING: CPU: 1 PID: 16271 at kernel/fork.c:718
> __put_task_struct+0x3ef/0x620 kernel/fork.c:718
> Kernel panic - not syncing: panic_on_warn set ...
>
> CPU: 1 PID: 16271 Comm: syz-executor5 Not tainted 4.19.0-rc7-next-20181008+
> #89
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x244/0x3ab lib/dump_stack.c:113
>  panic+0x238/0x4e7 kernel/panic.c:184
>  __warn.cold.8+0x163/0x1ba kernel/panic.c:536
>  report_bug+0x254/0x2d0 lib/bug.c:186
>  fixup_bug arch/x86/kernel/traps.c:178 [inline]
>  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
>  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:290
>  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:969
> RIP: 0010:__put_task_struct+0x3ef/0x620 kernel/fork.c:718
> Code: 4c 89 ee e8 d3 9d 7b 00 e9 a1 fe ff ff e8 89 53 37 00 0f 0b e9 7c fd
> ff ff e8 7d 53 37 00 0f 0b e9 87 fd ff ff e8 71 53 37 00 <0f> 0b e9 d0 fc ff
> ff e8 65 53 37 00 49 8d 87 90 05 00 00 31 f6 48
> RSP: 0018:ffff88018dbcf808 EFLAGS: 00010293
> RAX: ffff880187474180 RBX: ffff88018cc7a1c0 RCX: ffffffff8147298d
> RDX: 0000000000000000 RSI: ffffffff81472cbf RDI: 0000000000000005
> RBP: ffff88018dbcf8e8 R08: ffff880187474180 R09: ffffed003198f43c
> R10: ffffed003198f43c R11: ffff88018cc7a1e3 R12: 1ffff10031b79f04
> R13: 0000000000000000 R14: ffff88018dbcf8c0 R15: ffff88018daceb40
>  put_task_struct include/linux/sched/task.h:96 [inline]
>  rdma_restrack_del+0x2e0/0x3b0 drivers/infiniband/core/restrack.c:243
>  rdma_destroy_id+0x126/0xcc0 drivers/infiniband/core/cma.c:1820
>  ucma_close+0x114/0x310 drivers/infiniband/core/ucma.c:1767
>  __fput+0x3bc/0xa70 fs/file_table.c:279
>  ____fput+0x15/0x20 fs/file_table.c:312
>  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
>  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
>  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x411051
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 34 19 00 00 c3 48
> 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89
> c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:00007ffd6e8617b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000411051
> RDX: 0000000000000000 RSI: 0000000000731850 RDI: 0000000000000004
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 00007ffd6e8616e0 R11: 0000000000000293 R12: 0000000000000000
> R13: 0000000000000001 R14: 0000000000000156 R15: 0000000000000005
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/000000000000b3d5610577b9e12c%40google.com.
> For more options, visit https://groups.google.com/d/optout.
