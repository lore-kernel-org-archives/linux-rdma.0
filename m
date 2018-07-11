From: syzbot <syzbot+0570fef57a5e020bdc87@syzkaller.appspotmail.com>
Subject: KASAN: slab-out-of-bounds Read in rds_cong_queue_updates (2)
Date: Wed, 11 Jul 2018 12:55:02 -0700
Message-ID: <0000000000005274c40570be9f48@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0026129c8629 rhashtable: add restart routine in rhashtable..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10b7ced0400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b88de6eac8694da6
dashboard link: https://syzkaller.appspot.com/bug?extid=0570fef57a5e020bdc87
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0570fef57a5e020bdc87@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in atomic_read  
include/asm-generic/atomic-instrumented.h:21 [inline]
BUG: KASAN: slab-out-of-bounds in refcount_read include/linux/refcount.h:42  
[inline]
BUG: KASAN: slab-out-of-bounds in check_net include/net/net_namespace.h:237  
[inline]
BUG: KASAN: slab-out-of-bounds in rds_destroy_pending net/rds/rds.h:902  
[inline]
BUG: KASAN: slab-out-of-bounds in rds_cong_queue_updates+0x25d/0x5b0  
net/rds/cong.c:226
Read of size 4 at addr ffff88019f8ec204 by task syz-executor1/27023

CPU: 0 PID: 27023 Comm: syz-executor1 Not tainted 4.18.0-rc3+ #5
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
netlink: 'syz-executor2': attribute type 18 has an invalid length.
  rds_loop_xmit+0x16a/0x340 net/rds/loop.c:95
  rds_send_xmit+0x1343/0x29c0 net/rds/send.c:355
netlink: 180 bytes leftover after parsing attributes in process  
`syz-executor5'.
  rds_sendmsg+0x229e/0x2a40 net/rds/send.c:1243
netlink: 180 bytes leftover after parsing attributes in process  
`syz-executor5'.
  sock_sendmsg_nosec net/socket.c:641 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:651
  __sys_sendto+0x3d7/0x670 net/socket.c:1797
  __do_sys_sendto net/socket.c:1809 [inline]
  __se_sys_sendto net/socket.c:1805 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1805
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x455e29
Code: 1d ba fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb b9 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd164b21c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fd164b226d4 RCX: 0000000000455e29
RDX: 0000000000000481 RSI: 0000000020000000 RDI: 0000000000000013
RBP: 000000000072bea0 R08: 000000002069affb R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004c14f2 R14: 00000000004d1a08 R15: 0000000000000000

Allocated by task 26052:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3554
  getname_flags+0xd0/0x5a0 fs/namei.c:140
  getname+0x19/0x20 fs/namei.c:211
  do_sys_open+0x3a2/0x760 fs/open.c:1095
  __do_sys_open fs/open.c:1119 [inline]
  __se_sys_open fs/open.c:1114 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1114
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 26052:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kmem_cache_free+0x86/0x2d0 mm/slab.c:3756
  putname+0xf2/0x130 fs/namei.c:261
  do_sys_open+0x569/0x760 fs/open.c:1110
  __do_sys_open fs/open.c:1119 [inline]
  __se_sys_open fs/open.c:1114 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1114
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88019f8ec280
  which belongs to the cache names_cache of size 4096
The buggy address is located 124 bytes to the left of
  4096-byte region [ffff88019f8ec280, ffff88019f8ed280)
The buggy address belongs to the page:
page:ffffea00067e3b00 count:1 mapcount:0 mapping:ffff8801da987dc0 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffffea0007609988 ffffea0006b4ce88 ffff8801da987dc0
raw: 0000000000000000 ffff88019f8ec280 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88019f8ec100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88019f8ec180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88019f8ec200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                    ^
  ffff88019f8ec280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88019f8ec300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
