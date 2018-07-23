From: syzbot <syzbot+470ae97a39f16146af45@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in rds_cong_queue_updates (2)
Date: Mon, 23 Jul 2018 10:30:01 -0700
Message-ID: <000000000000cdb5450571adfe40@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fcf4793e278e tls: check RCV_SHUTDOWN in tls_wait_data
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1738cb2c400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0bdc4175608181c
dashboard link: https://syzkaller.appspot.com/bug?extid=470ae97a39f16146af45
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+470ae97a39f16146af45@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:21 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:42  
[inline]
BUG: KASAN: use-after-free in check_net include/net/net_namespace.h:237  
[inline]
BUG: KASAN: use-after-free in rds_destroy_pending net/rds/rds.h:902 [inline]
BUG: KASAN: use-after-free in rds_cong_queue_updates+0x25d/0x5b0  
net/rds/cong.c:226
Read of size 4 at addr ffff88019f180144 by task kworker/u4:1/23

CPU: 1 PID: 23 Comm: kworker/u4:1 Not tainted 4.18.0-rc5+ #18
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krdsd rds_send_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
  kasan_check_read+0x11/0x20 mm/kasan/kasan.c:272
  atomic_read include/asm-generic/atomic-instrumented.h:21 [inline]
  refcount_read include/linux/refcount.h:42 [inline]
  check_net include/net/net_namespace.h:237 [inline]
  rds_destroy_pending net/rds/rds.h:902 [inline]
  rds_cong_queue_updates+0x25d/0x5b0 net/rds/cong.c:226
  rds_recv_rcvbuf_delta.part.3+0x332/0x3e0 net/rds/recv.c:123
  rds_recv_rcvbuf_delta net/rds/recv.c:382 [inline]
  rds_recv_incoming+0x85a/0x1320 net/rds/recv.c:382
  rds_loop_xmit+0x16a/0x340 net/rds/loop.c:95
  rds_send_xmit+0x1343/0x29c0 net/rds/send.c:355
  rds_send_worker+0x153/0x300 net/rds/threads.c:199
  process_one_work+0xc73/0x1ba0 kernel/workqueue.c:2153
  worker_thread+0x189/0x13c0 kernel/workqueue.c:2296
  kthread+0x345/0x410 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

Allocated by task 4564:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3554
  kmem_cache_zalloc include/linux/slab.h:697 [inline]
  net_alloc net/core/net_namespace.c:383 [inline]
  copy_net_ns+0x15b/0x4d0 net/core/net_namespace.c:423
  create_new_namespaces+0x6ad/0x900 kernel/nsproxy.c:107
  unshare_nsproxy_namespaces+0xc3/0x1f0 kernel/nsproxy.c:206
  ksys_unshare+0x723/0xfb0 kernel/fork.c:2419
  __do_sys_unshare kernel/fork.c:2487 [inline]
  __se_sys_unshare kernel/fork.c:2485 [inline]
  __x64_sys_unshare+0x31/0x40 kernel/fork.c:2485
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 23:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kmem_cache_free+0x86/0x2d0 mm/slab.c:3756
  net_free net/core/net_namespace.c:399 [inline]
  net_drop_ns.part.14+0x129/0x150 net/core/net_namespace.c:406
  net_drop_ns net/core/net_namespace.c:405 [inline]
  cleanup_net+0x6bb/0xb50 net/core/net_namespace.c:541
  process_one_work+0xc73/0x1ba0 kernel/workqueue.c:2153
  worker_thread+0x189/0x13c0 kernel/workqueue.c:2296
  kthread+0x345/0x410 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

The buggy address belongs to the object at ffff88019f180140
  which belongs to the cache net_namespace of size 8704
The buggy address is located 4 bytes inside of
  8704-byte region [ffff88019f180140, ffff88019f182340)
The buggy address belongs to the page:
page:ffffea00067c6000 count:1 mapcount:0 mapping:ffff8801d9be9e40 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffffea00067d5a08 ffffea00067b3a08 ffff8801d9be9e40
raw: 0000000000000000 ffff88019f180140 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88019f180000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88019f180080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88019f180100: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                            ^
  ffff88019f180180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88019f180200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
