From: syzbot <syzbot+c92378b32760a4eef756@syzkaller.appspotmail.com>
Subject: KASAN: slab-out-of-bounds Read in rdma_listen
Date: Sun, 19 Aug 2018 21:13:02 -0700
Message-ID: <0000000000001de4b70573d62017@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5c60a7389d79 Merge tag 'for-linus-4.19-ofs1' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10bf9aee400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4fd89f99c889a184
dashboard link: https://syzkaller.appspot.com/bug?extid=c92378b32760a4eef756
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c92378b32760a4eef756@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __list_add_valid+0x8f/0xb0  
lib/list_debug.c:26
Read of size 8 at addr ffff880188b13098 by task syz-executor6/27383

CPU: 1 PID: 27383 Comm: syz-executor6 Not tainted 4.18.0+ #193
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  __list_add_valid+0x8f/0xb0 lib/list_debug.c:26
  __list_add include/linux/list.h:60 [inline]
  list_add_tail include/linux/list.h:93 [inline]
  cma_listen_on_all drivers/infiniband/core/cma.c:2328 [inline]
  rdma_listen+0x6dc/0x990 drivers/infiniband/core/cma.c:3354
  ucma_listen+0x1a4/0x260 drivers/infiniband/core/ucma.c:1096
  ucma_write+0x336/0x420 drivers/infiniband/core/ucma.c:1680
  __vfs_write+0x117/0x9d0 fs/read_write.c:485
  vfs_write+0x1f8/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457089
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f211d28dc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f211d28e6d4 RCX: 0000000000457089
RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 00000000009300a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d7448 R14: 00000000004ca592 R15: 0000000000000000

Allocated by task 2291:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3554
  getname_flags+0xd0/0x5a0 fs/namei.c:140
  getname+0x19/0x20 fs/namei.c:211
  do_sys_open+0x3a2/0x760 fs/open.c:1055
  __do_sys_open fs/open.c:1079 [inline]
  __se_sys_open fs/open.c:1074 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1074
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2291:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kmem_cache_free+0x86/0x2d0 mm/slab.c:3756
  putname+0xf2/0x130 fs/namei.c:261
  do_sys_open+0x569/0x760 fs/open.c:1070
  __do_sys_open fs/open.c:1079 [inline]
  __se_sys_open fs/open.c:1074 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1074
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff880188b12000
  which belongs to the cache names_cache of size 4096
The buggy address is located 152 bytes to the right of
  4096-byte region [ffff880188b12000, ffff880188b13000)
The buggy address belongs to the page:
page:ffffea000622c480 count:1 mapcount:0 mapping:ffff8801dad85dc0 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffffea00074e8708 ffffea00073cdb08 ffff8801dad85dc0
raw: 0000000000000000 ffff880188b12000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff880188b12f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff880188b13000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff880188b13080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                             ^
  ffff880188b13100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff880188b13180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
