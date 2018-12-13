From: syzbot <syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in addr_handler
Date: Thu, 13 Dec 2018 07:27:03 -0800
Message-ID: <00000000000055ee31057ce8f277@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f5d582777bcb Merge branch 'for-linus' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e556fb400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
dashboard link: https://syzkaller.appspot.com/bug?extid=b358909d8d01556b790b
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_UP): veth1: link is not ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
8021q: adding VLAN 0 to HW filter on device team0
==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20  
kernel/locking/lockdep.c:3218
Read of size 8 at addr ffff88818e1b5050 by task kworker/u4:3/394

CPU: 1 PID: 394 Comm: kworker/u4:3 Not tainted 4.20.0-rc6+ #274
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: ib_addr process_one_req
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
  lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
  __mutex_lock_common kernel/locking/mutex.c:925 [inline]
  __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  addr_handler+0xed/0x420 drivers/infiniband/core/cma.c:2967
  process_one_req+0x1a9/0x920 drivers/infiniband/core/addr.c:643
  process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 25482:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x750 mm/slab.c:3620
  kmalloc include/linux/slab.h:546 [inline]
  kzalloc include/linux/slab.h:741 [inline]
  __rdma_create_id+0xdf/0x650 drivers/infiniband/core/cma.c:876
  ucma_create_id+0x39b/0x990 drivers/infiniband/core/ucma.c:506
  ucma_write+0x365/0x460 drivers/infiniband/core/ucma.c:1689
  __vfs_write+0x119/0x9f0 fs/read_write.c:485
  vfs_write+0x1fc/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __ia32_sys_write+0x71/0xb0 fs/read_write.c:607
  do_syscall_32_irqs_on arch/x86/entry/common.c:326 [inline]
  do_fast_syscall_32+0x34d/0xfb2 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 25482:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3817
  rdma_destroy_id+0x835/0xcc0 drivers/infiniband/core/cma.c:1846
  ucma_destroy_id+0x3ae/0x550 drivers/infiniband/core/ucma.c:638
  ucma_write+0x365/0x460 drivers/infiniband/core/ucma.c:1689
  __vfs_write+0x119/0x9f0 fs/read_write.c:485
  vfs_write+0x1fc/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __ia32_sys_write+0x71/0xb0 fs/read_write.c:607
  do_syscall_32_irqs_on arch/x86/entry/common.c:326 [inline]
  do_fast_syscall_32+0x34d/0xfb2 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

The buggy address belongs to the object at ffff88818e1b4cc0
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 912 bytes inside of
  2048-byte region [ffff88818e1b4cc0, ffff88818e1b54c0)
The buggy address belongs to the page:
page:ffffea0006386d00 count:1 mapcount:0 mapping:ffff8881da800c40 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000010200(slab|head)
raw: 02fffc0000010200 ffffea00075df808 ffffea0006ffd708 ffff8881da800c40
raw: 0000000000000000 ffff88818e1b4440 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88818e1b4f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88818e1b4f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88818e1b5000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                  ^
  ffff88818e1b5080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88818e1b5100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
