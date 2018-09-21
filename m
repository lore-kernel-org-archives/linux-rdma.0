From: syzbot <syzbot+20c32fa6ff84a2d28c36@syzkaller.appspotmail.com>
Subject: general protection fault in addr_resolve
Date: Fri, 21 Sep 2018 01:35:03 -0700
Message-ID: <0000000000000d23fc05765d8484@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a0cb0cabe4bb Add linux-next specific files for 20180920
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14b14e2a400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=786006c5dafbadf6
dashboard link: https://syzkaller.appspot.com/bug?extid=20c32fa6ff84a2d28c36
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+20c32fa6ff84a2d28c36@syzkaller.appspotmail.com

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 976 Comm: syz-executor4 Not tainted 4.19.0-rc4-next-20180920+  
#76
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:copy_src_l2_addr drivers/infiniband/core/addr.c:489 [inline]
RIP: 0010:rdma_set_src_addr_rcu drivers/infiniband/core/addr.c:518 [inline]
RIP: 0010:addr_resolve+0x7c4/0x1c90 drivers/infiniband/core/addr.c:593
Code: 0f 84 dd 01 00 00 e8 9b 6c e9 fb 48 8b 85 d8 fd ff ff 48 8d b8 54 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 24
RSP: 0018:ffff8801c863f360 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8801c863f578 RCX: ffffc90003e76000
RDX: 000000000000003e RSI: ffffffff8593e355 RDI: 00000000000001f1
RBP: ffff8801c863f5a0 R08: ffff8801d95722c0 R09: ffffed003b585b57
R10: ffffed003b585b57 R11: ffff8801dac2dabb R12: ffff8801d78a1560
R13: 0000000000000001 R14: 000000000000000a R15: 0000000000000000
kobject: 'loop5' (000000009a4a0383): kobject_uevent_env
FS:  00007fefce9ca700(0000) GS:ffff8801dac00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000706158 CR3: 00000001d370a000 CR4: 00000000001406f0
Call Trace:
kobject: 'loop5' (000000009a4a0383): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
  rdma_resolve_ip+0x499/0x790 drivers/infiniband/core/addr.c:697
  rdma_resolve_addr+0x2d6/0x2870 drivers/infiniband/core/cma.c:2992
kobject: 'loop3' (00000000f158c859): kobject_uevent_env
kobject: 'loop3' (00000000f158c859): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
  ucma_resolve_ip+0x242/0x2a0 drivers/infiniband/core/ucma.c:713
  ucma_write+0x336/0x420 drivers/infiniband/core/ucma.c:1686
  __vfs_write+0x119/0x9f0 fs/read_write.c:485
kobject: 'loop2' (00000000ed1b199d): kobject_uevent_env
  vfs_write+0x1fc/0x560 fs/read_write.c:549
kobject: 'loop2' (00000000ed1b199d): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457679
Code: 1d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fefce9c9c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fefce9ca6d4 RCX: 0000000000457679
RDX: 0000000000000048 RSI: 0000000020000100 RDI: 0000000000000004
RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d8a48 R14: 00000000004cb698 R15: 0000000000000000
Modules linked in:
---[ end trace 416e29924dbdc1a0 ]---
RIP: 0010:copy_src_l2_addr drivers/infiniband/core/addr.c:489 [inline]
RIP: 0010:rdma_set_src_addr_rcu drivers/infiniband/core/addr.c:518 [inline]
RIP: 0010:addr_resolve+0x7c4/0x1c90 drivers/infiniband/core/addr.c:593
Code: 0f 84 dd 01 00 00 e8 9b 6c e9 fb 48 8b 85 d8 fd ff ff 48 8d b8 54 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 24
kobject: 'loop5' (000000009a4a0383): kobject_uevent_env
kobject: 'loop5' (000000009a4a0383): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
RSP: 0018:ffff8801c863f360 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8801c863f578 RCX: ffffc90003e76000
RDX: 000000000000003e RSI: ffffffff8593e355 RDI: 00000000000001f1
RBP: ffff8801c863f5a0 R08: ffff8801d95722c0 R09: ffffed003b585b57
R10: ffffed003b585b57 R11: ffff8801dac2dabb R12: ffff8801d78a1560
R13: 0000000000000001 R14: 000000000000000a R15: 0000000000000000
FS:  00007fefce9ca700(0000) GS:ffff8801dac00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffef CR3: 00000001d370a000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
