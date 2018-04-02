From: syzbot <syzbot+f3ce716af730c8f96637@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in rdma_listen
Date: Sun, 01 Apr 2018 23:01:03 -0700
Message-ID: <000000000000a2a25b0568d750c3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dasaratharaman.chandramouli@intel.com, dledford@redhat.com, jgg@ziepe.ca, leonro@mellanox.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, markb@mellanox.com, monis@mellanox.com, parav@mellanox.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot hit the following crash on upstream commit
10b84daddbec72c6b440216a69de9a9605127f7a (Sat Mar 31 17:59:00 2018 +0000)
Merge branch 'perf-urgent-for-linus' of  
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
syzbot dashboard link:  
https://syzkaller.appspot.com/bug?extid=f3ce716af730c8f96637

So far this crash happened 4 times on upstream.
C reproducer: https://syzkaller.appspot.com/x/repro.c?id=6306348723601408
syzkaller reproducer:  
https://syzkaller.appspot.com/x/repro.syz?id=6405720039751680
Raw console output:  
https://syzkaller.appspot.com/x/log.txt?id=6416847360491520
Kernel config:  
https://syzkaller.appspot.com/x/.config?id=-2760467897697295172
compiler: gcc (GCC) 7.1.1 20170620

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f3ce716af730c8f96637@syzkaller.appspotmail.com
It will help syzbot understand when the bug is fixed. See footer for  
details.
If you forward the report, please keep this part and the footer.

==================================================================
BUG: KASAN: use-after-free in __list_add_valid+0xc6/0xd0 lib/list_debug.c:26
Read of size 8 at addr ffff8801d7ba9cd8 by task syzkaller817651/5232

CPU: 1 PID: 5232 Comm: syzkaller817651 Not tainted 4.16.0-rc7+ #374
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:17 [inline]
  dump_stack+0x194/0x24d lib/dump_stack.c:53
  print_address_description+0x73/0x250 mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report+0x23c/0x360 mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  __list_add_valid+0xc6/0xd0 lib/list_debug.c:26
  __list_add include/linux/list.h:60 [inline]
  list_add_tail include/linux/list.h:93 [inline]
  cma_listen_on_all drivers/infiniband/core/cma.c:2309 [inline]
  rdma_listen+0x581/0x8e0 drivers/infiniband/core/cma.c:3333
  ucma_listen+0x172/0x1f0 drivers/infiniband/core/ucma.c:1074
  ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1656
  __vfs_write+0xef/0x970 fs/read_write.c:480
  vfs_write+0x189/0x510 fs/read_write.c:544
  SYSC_write fs/read_write.c:589 [inline]
  SyS_write+0xef/0x220 fs/read_write.c:581
  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x4415e9
RSP: 002b:00007fffa7eaaf98 EFLAGS: 00000207 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004415e9
RDX: 00000000fffffd4e RSI: 00000000200008c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000a7eab118 R09: 00000000a7eab118
R10: 00000000a7eab118 R11: 0000000000000207 R12: 0000000000006463
R13: 00000000006cd448 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 5230:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
  set_track mm/kasan/kasan.c:459 [inline]
  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:552
  kmem_cache_alloc_trace+0x136/0x740 mm/slab.c:3608
  kmalloc include/linux/slab.h:512 [inline]
  kzalloc include/linux/slab.h:701 [inline]
  rdma_create_id+0xd0/0x630 drivers/infiniband/core/cma.c:787
  ucma_create_id+0x35f/0x920 drivers/infiniband/core/ucma.c:480
  ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1656
  __vfs_write+0xef/0x970 fs/read_write.c:480
  vfs_write+0x189/0x510 fs/read_write.c:544
  SYSC_write fs/read_write.c:589 [inline]
  SyS_write+0xef/0x220 fs/read_write.c:581
  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x42/0xb7

Freed by task 5230:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
  set_track mm/kasan/kasan.c:459 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:520
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:527
  __cache_free mm/slab.c:3486 [inline]
  kfree+0xd9/0x260 mm/slab.c:3801
  rdma_destroy_id+0x821/0xda0 drivers/infiniband/core/cma.c:1691
  ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1735
  __fput+0x327/0x7e0 fs/file_table.c:209
  ____fput+0x15/0x20 fs/file_table.c:243
  task_work_run+0x199/0x270 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x9bb/0x1ad0 kernel/exit.c:865
  do_group_exit+0x149/0x400 kernel/exit.c:968
  SYSC_exit_group kernel/exit.c:979 [inline]
  SyS_exit_group+0x1d/0x20 kernel/exit.c:977
  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x42/0xb7

The buggy address belongs to the object at ffff8801d7ba9b00
  which belongs to the cache kmalloc-1024 of size 1024
The buggy address is located 472 bytes inside of
  1024-byte region [ffff8801d7ba9b00, ffff8801d7ba9f00)
The buggy address belongs to the page:
page:ffffea00075eea00 count:1 mapcount:0 mapping:ffff8801d7ba8000 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffff8801d7ba8000 0000000000000000 0000000100000007
raw: ffffea0006b2af20 ffffea00075f6520 ffff8801dac00ac0 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801d7ba9b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801d7ba9c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801d7ba9c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                     ^
  ffff8801d7ba9d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801d7ba9d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a dumb bot. It may contain errors.
See https://goo.gl/tpsmEJ for details.
Direct all questions to syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is  
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
If you want to test a patch for this bug, please reply with:
#syz test: git://repo/address.git branch
and provide the patch inline or as an attachment.
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug  
report.
Note: all commands must start from beginning of the line in the email body.
