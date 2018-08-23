From: syzbot <syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in __rhashtable_lookup (2)
Date: Thu, 23 Aug 2018 07:35:03 -0700
Message-ID: <00000000000027a1e605741b2afa@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ad1d69735878 Merge tag 'fuse-update-4.19' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100e3b36400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a24c33b9ed66aa
dashboard link: https://syzkaller.appspot.com/bug?extid=8967084bcac563795dc6
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcmp+0xe8/0x150 lib/string.c:861
Read of size 1 at addr ffff8801b5201bf0 by task syz-executor5/14889

CPU: 0 PID: 14889 Comm: syz-executor5 Not tainted 4.18.0+ #202
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/report.c:430
  memcmp+0xe8/0x150 lib/string.c:861
  memcmp include/linux/string.h:386 [inline]
  rhashtable_compare include/linux/rhashtable.h:462 [inline]
  __rhashtable_lookup.isra.8.constprop.19+0x70f/0xd50  
include/linux/rhashtable.h:484
  rhashtable_lookup include/linux/rhashtable.h:516 [inline]
  rhashtable_lookup_fast include/linux/rhashtable.h:542 [inline]
  rds_add_bound net/rds/bind.c:117 [inline]
  rds_bind+0x7c9/0x1510 net/rds/bind.c:238
  __sys_bind+0x331/0x440 net/socket.c:1481
  __do_sys_bind net/socket.c:1492 [inline]
  __se_sys_bind net/socket.c:1490 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1490
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457089
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fdf40632c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007fdf406336d4 RCX: 0000000000457089
RDX: 0000000000000010 RSI: 0000000020000840 RDI: 0000000000000009
RBP: 00000000009300a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004caff8 R14: 00000000004c2de7 R15: 0000000000000000

Allocated by task 14887:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  kmem_cache_alloc+0x12e/0x710 mm/slab.c:3554
  sk_prot_alloc+0x69/0x2e0 net/core/sock.c:1462
  sk_alloc+0x106/0x17b0 net/core/sock.c:1522
  rds_create+0x14f/0x770 net/rds/af_rds.c:666
  __sock_create+0x53c/0x940 net/socket.c:1275
  sock_create net/socket.c:1315 [inline]
  __sys_socket+0x106/0x260 net/socket.c:1345
  __do_sys_socket net/socket.c:1354 [inline]
  __se_sys_socket net/socket.c:1352 [inline]
  __x64_sys_socket+0x73/0xb0 net/socket.c:1352
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 14886:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kmem_cache_free+0x86/0x280 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1503 [inline]
  __sk_destruct+0x70a/0xa60 net/core/sock.c:1587
  sk_destruct+0x78/0x90 net/core/sock.c:1595
  __sk_free+0xcf/0x300 net/core/sock.c:1606
  sk_free+0x42/0x50 net/core/sock.c:1617
  sock_put include/net/sock.h:1691 [inline]
  rds_release+0x3e9/0x570 net/rds/af_rds.c:91
  __sock_release+0xd7/0x250 net/socket.c:579
  sock_close+0x19/0x20 net/socket.c:1139
  __fput+0x36e/0x8c0 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801b5201780
  which belongs to the cache RDS(76:syz7) of size 1608
The buggy address is located 1136 bytes inside of
  1608-byte region [ffff8801b5201780, ffff8801b5201dc8)
The buggy address belongs to the page:
page:ffffea0006d48040 count:1 mapcount:0 mapping:ffff8801d75e2c80 index:0x0
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffffea0006e74188 ffff8801ca20ef48 ffff8801d75e2c80
raw: 0000000000000000 ffff8801b5201080 0000000100000002 ffff8801acaa4640
page dumped because: kasan: bad access detected
page->mem_cgroup:ffff8801acaa4640

Memory state around the buggy address:
  ffff8801b5201a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b5201b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801b5201b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                              ^
  ffff8801b5201c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b5201c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
