From: syzbot <syzbot+287843ad8a4d2870e538@syzkaller.appspotmail.com>
Subject: KASAN: out-of-bounds Read in rds_cong_queue_updates (2)
Date: Wed, 13 Jun 2018 00:51:02 -0700
Message-ID: <00000000000081bd9d056e813e48@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0adb32858b0b Linux 4.16
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=138f2d0b800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df0c336cc3b55d45
dashboard link: https://syzkaller.appspot.com/bug?extid=287843ad8a4d2870e538
compiler:       gcc (GCC) 7.1.1 20170620

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+287843ad8a4d2870e538@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: out-of-bounds in __read_once_size include/linux/compiler.h:188  
[inline]
BUG: KASAN: out-of-bounds in atomic_read arch/x86/include/asm/atomic.h:27  
[inline]
BUG: KASAN: out-of-bounds in refcount_read include/linux/refcount.h:42  
[inline]
BUG: KASAN: out-of-bounds in check_net include/net/net_namespace.h:228  
[inline]
BUG: KASAN: out-of-bounds in rds_destroy_pending net/rds/rds.h:868 [inline]
BUG: KASAN: out-of-bounds in rds_cong_queue_updates+0x4d3/0x4f0  
net/rds/cong.c:226
Read of size 4 at addr ffff88018d7f2204 by task kworker/u4:6/10561

CPU: 1 PID: 10561 Comm: kworker/u4:6 Not tainted 4.16.0+ #10
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krdsd rds_send_worker
Call Trace:
  __dump_stack lib/dump_stack.c:17 [inline]
  dump_stack+0x194/0x24d lib/dump_stack.c:53
kernel msg: ebtables bug: please report to author: Wrong len argument
  print_address_description+0x73/0x250 mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report+0x23c/0x360 mm/kasan/report.c:412
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
  __read_once_size include/linux/compiler.h:188 [inline]
  atomic_read arch/x86/include/asm/atomic.h:27 [inline]
  refcount_read include/linux/refcount.h:42 [inline]
  check_net include/net/net_namespace.h:228 [inline]
  rds_destroy_pending net/rds/rds.h:868 [inline]
  rds_cong_queue_updates+0x4d3/0x4f0 net/rds/cong.c:226
  rds_recv_rcvbuf_delta.part.2+0x289/0x320 net/rds/recv.c:118
  rds_recv_rcvbuf_delta net/rds/recv.c:377 [inline]
  rds_recv_incoming+0xeb4/0x11d0 net/rds/recv.c:377
  rds_loop_xmit+0x149/0x320 net/rds/loop.c:82
  rds_send_xmit+0xbcd/0x26b0 net/rds/send.c:355
  rds_send_worker+0x115/0x2a0 net/rds/threads.c:199
  process_one_work+0xc47/0x1bb0 kernel/workqueue.c:2113
  worker_thread+0x223/0x1990 kernel/workqueue.c:2247
  kthread+0x33c/0x400 kernel/kthread.c:238
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:406

The buggy address belongs to the page:
page:ffffea000635fc80 count:3 mapcount:2 mapping:0000000000000000 index:0x0
flags: 0x2fffc0000000000()
raw: 02fffc0000000000 0000000000000000 0000000000000000 0000000300000001
raw: dead000000000100 dead000000000200 0000000000000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88018d7f2100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88018d7f2180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff88018d7f2200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                       ^
  ffff88018d7f2280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88018d7f2300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
Kernel panic - not syncing: panic_on_warn set ...

CPU: 1 PID: 10561 Comm: kworker/u4:6 Tainted: G    B            4.16.0+ #10
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krdsd rds_send_worker
Call Trace:
  __dump_stack lib/dump_stack.c:17 [inline]
  dump_stack+0x194/0x24d lib/dump_stack.c:53
  panic+0x1e4/0x41c kernel/panic.c:183
  kasan_end_report+0x50/0x50 mm/kasan/report.c:180
  kasan_report_error mm/kasan/report.c:359 [inline]
  kasan_report+0x149/0x360 mm/kasan/report.c:412
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
  __read_once_size include/linux/compiler.h:188 [inline]
  atomic_read arch/x86/include/asm/atomic.h:27 [inline]
  refcount_read include/linux/refcount.h:42 [inline]
  check_net include/net/net_namespace.h:228 [inline]
  rds_destroy_pending net/rds/rds.h:868 [inline]
  rds_cong_queue_updates+0x4d3/0x4f0 net/rds/cong.c:226
  rds_recv_rcvbuf_delta.part.2+0x289/0x320 net/rds/recv.c:118
  rds_recv_rcvbuf_delta net/rds/recv.c:377 [inline]
  rds_recv_incoming+0xeb4/0x11d0 net/rds/recv.c:377
  rds_loop_xmit+0x149/0x320 net/rds/loop.c:82
  rds_send_xmit+0xbcd/0x26b0 net/rds/send.c:355
  rds_send_worker+0x115/0x2a0 net/rds/threads.c:199
  process_one_work+0xc47/0x1bb0 kernel/workqueue.c:2113
  worker_thread+0x223/0x1990 kernel/workqueue.c:2247
  kthread+0x33c/0x400 kernel/kthread.c:238
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:406
Dumping ftrace buffer:
    (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
