From: syzbot <syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in addr_handler
Date: Mon, 18 Feb 2019 20:09:03 -0800
Message-ID: <000000000000d8cfe60582376608@google.com>
References: <00000000000055ee31057ce8f277@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000055ee31057ce8f277@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    a3b22b9f11d9 Linux 5.0-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c5df58c00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
dashboard link: https://syzkaller.appspot.com/bug?extid=b358909d8d01556b790b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1493d4d0c00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x30e0/0x4700  
kernel/locking/lockdep.c:3215
Read of size 8 at addr ffff88808bfc1150 by task kworker/u4:5/7685

CPU: 1 PID: 7685 Comm: kworker/u4:5 Not tainted 5.0.0-rc7 #77
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: ib_addr process_one_req
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
  __lock_acquire+0x30e0/0x4700 kernel/locking/lockdep.c:3215
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:3841
  __mutex_lock_common kernel/locking/mutex.c:925 [inline]
  __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  addr_handler+0xa5/0x300 drivers/infiniband/core/cma.c:2970
  process_one_req+0x109/0x680 drivers/infiniband/core/addr.c:643
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2173
  worker_thread+0x98/0xe40 kernel/workqueue.c:2319
  kthread+0x357/0x430 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 27464:
  save_stack+0x45/0xd0 mm/kasan/common.c:73
  set_track mm/kasan/common.c:85 [inline]
  __kasan_kmalloc mm/kasan/common.c:496 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:469
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:504
  kmem_cache_alloc_trace+0x151/0x760 mm/slab.c:3609
  kmalloc include/linux/slab.h:545 [inline]
  kzalloc include/linux/slab.h:740 [inline]
  __rdma_create_id+0x5f/0x4e0 drivers/infiniband/core/cma.c:879
  ucma_create_id+0x1de/0x640 drivers/infiniband/core/ucma.c:506
  ucma_write+0x2da/0x3c0 drivers/infiniband/core/ucma.c:1689
  __vfs_write+0x116/0x8e0 fs/read_write.c:485
  vfs_write+0x20c/0x580 fs/read_write.c:549
  ksys_write+0xea/0x1f0 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 27463:
  save_stack+0x45/0xd0 mm/kasan/common.c:73
  set_track mm/kasan/common.c:85 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:458
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:466
  __cache_free mm/slab.c:3487 [inline]
  kfree+0xcf/0x230 mm/slab.c:3806
  rdma_destroy_id+0x723/0xab0 drivers/infiniband/core/cma.c:1849
  ucma_close+0x115/0x320 drivers/infiniband/core/ucma.c:1770
  __fput+0x2df/0x8d0 fs/file_table.c:278
  ____fput+0x16/0x20 fs/file_table.c:309
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88808bfc0dc0
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 912 bytes inside of
  2048-byte region [ffff88808bfc0dc0, ffff88808bfc15c0)
The buggy address belongs to the page:
page:ffffea00022ff000 count:1 mapcount:0 mapping:ffff88812c3f0c40 index:0x0  
compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000281a888 ffffea0002999e08 ffff88812c3f0c40
raw: 0000000000000000 ffff88808bfc0540 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808bfc1000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808bfc1080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808bfc1100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                  ^
  ffff88808bfc1180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808bfc1200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
