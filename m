From: syzbot <syzbot+da2591e115d57a9cbb8b@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in cma_bind_port
Date: Fri, 07 Sep 2018 01:38:02 -0700
Message-ID: <000000000000fca96a057543ecea@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b36fdc6853a3 Merge tag 'gpio-v4.19-2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1660c266400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c9564cd177daf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=da2591e115d57a9cbb8b
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+da2591e115d57a9cbb8b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cma_bind_port+0x35d/0x3f0  
drivers/infiniband/core/cma.c:3059
Read of size 2 at addr ffff8801b89fb320 by task syz-executor3/7584

CPU: 1 PID: 7584 Comm: syz-executor3 Not tainted 4.19.0-rc2+ #224
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
  __asan_report_load2_noabort+0x14/0x20 mm/kasan/report.c:431
  cma_bind_port+0x35d/0x3f0 drivers/infiniband/core/cma.c:3059
  cma_alloc_port+0x115/0x180 drivers/infiniband/core/cma.c:3095
  cma_alloc_any_port drivers/infiniband/core/cma.c:3160 [inline]
  cma_get_port drivers/infiniband/core/cma.c:3314 [inline]
  rdma_bind_addr+0x1765/0x23d0 drivers/infiniband/core/cma.c:3434
  cma_bind_addr drivers/infiniband/core/cma.c:2963 [inline]
  rdma_resolve_addr+0x4fa/0x27a0 drivers/infiniband/core/cma.c:2974
  ucma_resolve_ip+0x242/0x2a0 drivers/infiniband/core/ucma.c:711
  ucma_write+0x336/0x420 drivers/infiniband/core/ucma.c:1680
  __vfs_write+0x117/0x9d0 fs/read_write.c:485
  vfs_write+0x1fc/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457099
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f47da18ac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f47da18b6d4 RCX: 0000000000457099
RDX: 0000000000000048 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 00000000009300a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d8100 R14: 00000000004c1c28 R15: 0000000000000000

Allocated by task 7601:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x730 mm/slab.c:3620
  kmalloc include/linux/slab.h:513 [inline]
  kzalloc include/linux/slab.h:707 [inline]
  __rdma_create_id+0xdf/0x7a0 drivers/infiniband/core/cma.c:782
  ucma_create_id+0x399/0x9d0 drivers/infiniband/core/ucma.c:502
  ucma_write+0x336/0x420 drivers/infiniband/core/ucma.c:1680
  __vfs_write+0x117/0x9d0 fs/read_write.c:485
  vfs_write+0x1fc/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7583:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x210 mm/slab.c:3813
  rdma_destroy_id+0x848/0xce0 drivers/infiniband/core/cma.c:1737
  ucma_close+0x100/0x300 drivers/infiniband/core/ucma.c:1759
  __fput+0x38a/0xa40 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801b89fb300
  which belongs to the cache kmalloc-2048 of size 2048
The buggy address is located 32 bytes inside of
  2048-byte region [ffff8801b89fb300, ffff8801b89fbb00)
The buggy address belongs to the page:
page:ffffea0006e27e80 count:1 mapcount:0 mapping:ffff8801dac00c40 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffffea0006ec8108 ffffea0006e90288 ffff8801dac00c40
raw: 0000000000000000 ffff8801b89fa200 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b89fb200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b89fb280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8801b89fb300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                ^
  ffff8801b89fb380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b89fb400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
