From: syzbot <syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in __rhashtable_lookup (2)
Date: Sat, 08 Sep 2018 15:07:03 -0700
Message-ID: <000000000000154f6a05756358eb@google.com>
References: <00000000000027a1e605741b2afa@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000027a1e605741b2afa@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, dvyukov@google.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, sowmini.varadhan@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    d7b686ebf704 Merge branch 'i2c/for-current' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1132d70a400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f59875069d721b6
dashboard link: https://syzkaller.appspot.com/bug?extid=8967084bcac563795dc6
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b67e49400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11119e49400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcmp+0xe3/0x160 lib/string.c:861
Read of size 1 at addr ffff8801ce73eb70 by task syz-executor383/11736

CPU: 1 PID: 11736 Comm: syz-executor383 Not tainted 4.19.0-rc2+ #228
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c4/0x2b4 lib/dump_stack.c:113
  print_address_description.cold.8+0x9/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.9+0x242/0x309 mm/kasan/report.c:412
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/report.c:430
  memcmp+0xe3/0x160 lib/string.c:861
  memcmp include/linux/string.h:386 [inline]
  rhashtable_compare include/linux/rhashtable.h:462 [inline]
  __rhashtable_lookup.isra.8.constprop.20+0x73a/0xd00  
include/linux/rhashtable.h:484
  rhashtable_lookup include/linux/rhashtable.h:516 [inline]
  rhashtable_lookup_fast include/linux/rhashtable.h:542 [inline]
  rds_add_bound net/rds/bind.c:117 [inline]
  rds_bind+0x7d2/0x1520 net/rds/bind.c:238
  __sys_bind+0x331/0x440 net/socket.c:1481
  __do_sys_bind net/socket.c:1492 [inline]
  __se_sys_bind net/socket.c:1490 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1490
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x444e29
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 2b ce fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffec4b12988 EFLAGS: 00000217 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000444e29
RDX: 0000000000000010 RSI: 00000000200002c0 RDI: 0000000000000006
RBP: 0000000000000000 R08: 00000000004002e0 R09: 00000000004002e0
R10: 0000000000000004 R11: 0000000000000217 R12: 00000000000333a3
R13: 0000000000402170 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 11738:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  kmem_cache_alloc+0x12e/0x730 mm/slab.c:3554
  sk_prot_alloc+0x69/0x2e0 net/core/sock.c:1462
  sk_alloc+0x10d/0x1690 net/core/sock.c:1522
  rds_create+0x14f/0x740 net/rds/af_rds.c:666
  __sock_create+0x536/0x930 net/socket.c:1275
  sock_create net/socket.c:1315 [inline]
  __sys_socket+0x106/0x260 net/socket.c:1345
  __do_sys_socket net/socket.c:1354 [inline]
  __se_sys_socket net/socket.c:1352 [inline]
  __x64_sys_socket+0x73/0xb0 net/socket.c:1352
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 11738:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kmem_cache_free+0x83/0x290 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1503 [inline]
  __sk_destruct+0x766/0xbd0 net/core/sock.c:1587
  sk_destruct+0x78/0x90 net/core/sock.c:1595
  __sk_free+0xcf/0x300 net/core/sock.c:1606
  sk_free+0x42/0x50 net/core/sock.c:1617
  sock_put include/net/sock.h:1691 [inline]
  rds_release+0x3e8/0x570 net/rds/af_rds.c:91
  __sock_release+0xd7/0x250 net/socket.c:579
  sock_close+0x19/0x20 net/socket.c:1139
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801ce73e700
  which belongs to the cache RDS of size 1608
The buggy address is located 1136 bytes inside of
  1608-byte region [ffff8801ce73e700, ffff8801ce73ed48)
The buggy address belongs to the page:
page:ffffea000739cf80 count:1 mapcount:0 mapping:ffff8801cb1c0c40 index:0x0
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffffea00073a5348 ffffea000738ea48 ffff8801cb1c0c40
raw: 0000000000000000 ffff8801ce73e000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801ce73ea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801ce73ea80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801ce73eb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                              ^
  ffff8801ce73eb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801ce73ec00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
