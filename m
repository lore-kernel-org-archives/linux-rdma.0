From: syzbot <syzbot+adb15cf8c2798e4e0db4@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in rdma_listen (2)
Date: Fri, 29 Mar 2019 23:44:05 -0700
Message-ID: <00000000000012a4cd05854a1d0a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, danitg@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9936328b Merge tag 'pci-v5.1-fixes-1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16380473200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8dcdce25ea72bedf
dashboard link: https://syzkaller.appspot.com/bug?extid=adb15cf8c2798e4e0db4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11580c3f200000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b80c3f200000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16b80c3f200000
console output: https://syzkaller.appspot.com/x/log.txt?x=12b80c3f200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+adb15cf8c2798e4e0db4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_add_valid+0x9a/0xa0 lib/list_debug.c:26
Read of size 8 at addr ffff8880a5d2b3e0 by task syz-executor.0/7797

CPU: 1 PID: 7797 Comm: syz-executor.0 Not tainted 5.1.0-rc2+ #43
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __list_add_valid+0x9a/0xa0 lib/list_debug.c:26
  __list_add include/linux/list.h:60 [inline]
  list_add_tail include/linux/list.h:93 [inline]
  cma_listen_on_all drivers/infiniband/core/cma.c:2483 [inline]
  rdma_listen+0x6b7/0x970 drivers/infiniband/core/cma.c:3537
  ucma_listen+0x14d/0x1c0 drivers/infiniband/core/ucma.c:1100
  ucma_write+0x2da/0x3c0 drivers/infiniband/core/ucma.c:1696
  __vfs_write+0x8d/0x110 fs/read_write.c:485
  vfs_write+0x20c/0x580 fs/read_write.c:549
  ksys_write+0xea/0x1f0 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458209
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb9c2080c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458209
RDX: 0000000000000010 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb9c20816d4
R13: 00000000004c77c2 R14: 00000000004dd780 R15: 00000000ffffffff

Allocated by task 7794:
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

Freed by task 7789:
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

The buggy address belongs to the object at ffff8880a5d2b200
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 480 bytes inside of
  2048-byte region [ffff8880a5d2b200, ffff8880a5d2ba00)
The buggy address belongs to the page:
page:ffffea0002974a80 count:1 mapcount:0 mapping:ffff88812c3f0c40 index:0x0  
compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000231da88 ffff88812c3f1948 ffff88812c3f0c40
raw: 0000000000000000 ffff8880a5d2a100 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a5d2b280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a5d2b300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880a5d2b380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff8880a5d2b400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a5d2b480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
