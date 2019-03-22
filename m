From: syzbot <syzbot+bd034f3fdc0402e942ed@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in addr_resolve
Date: Fri, 22 Mar 2019 01:11:04 -0700
Message-ID: <0000000000006d637a0584aa6520@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    54c49016 Merge tag 'arc-5.1-rc2' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16a8323b200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31fb246de2a622
dashboard link: https://syzkaller.appspot.com/bug?extid=bd034f3fdc0402e942ed
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bd034f3fdc0402e942ed@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in addr_resolve+0x14f7/0x1730  
drivers/infiniband/core/addr.c:561
Read of size 8 at addr ffff88809dafeed0 by task kworker/u4:4/2568

CPU: 0 PID: 2568 Comm: kworker/u4:4 Not tainted 5.1.0-rc1+ #31
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: ib_addr process_one_req
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  addr_resolve+0x14f7/0x1730 drivers/infiniband/core/addr.c:561
  process_one_req+0x31f/0x680 drivers/infiniband/core/addr.c:628
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 17026:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
  kmem_cache_alloc_trace+0x151/0x760 mm/slab.c:3621
  kmalloc include/linux/slab.h:545 [inline]
  kzalloc include/linux/slab.h:740 [inline]
  __rdma_create_id+0x5f/0x4e0 drivers/infiniband/core/cma.c:878
  ucma_create_id+0x1de/0x640 drivers/infiniband/core/ucma.c:506
  ucma_write+0x2da/0x3c0 drivers/infiniband/core/ucma.c:1696
  __vfs_write+0x8d/0x110 fs/read_write.c:485
  vfs_write+0x20c/0x580 fs/read_write.c:549
  ksys_write+0xea/0x1f0 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 17025:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3821
  rdma_destroy_id+0x719/0xaa0 drivers/infiniband/core/cma.c:1852
  ucma_close+0x115/0x320 drivers/infiniband/core/ucma.c:1777
  __fput+0x2e5/0x8d0 fs/file_table.c:278
  ____fput+0x16/0x20 fs/file_table.c:309
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809dafed40
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 400 bytes inside of
  2048-byte region [ffff88809dafed40, ffff88809daff540)
The buggy address belongs to the page:
page:ffffea000276bf80 count:1 mapcount:0 mapping:ffff88812c3f0c40 index:0x0  
compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000172c108 ffffea000173a288 ffff88812c3f0c40
raw: 0000000000000000 ffff88809dafe4c0 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809dafed80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809dafee00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88809dafee80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                  ^
  ffff88809dafef00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809dafef80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
