From: syzbot <syzbot+6b46b135602a3f3ac99e@syzkaller.appspotmail.com>
Subject: general protection fault in rdma_listen (2)
Date: Wed, 07 Nov 2018 10:59:03 -0800
Message-ID: <000000000000396c09057a17b6fd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8053e5b93eca Merge tag 'trace-v4.20-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1539246d400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f559fee2fc3375a
dashboard link: https://syzkaller.appspot.com/bug?extid=6b46b135602a3f3ac99e
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6b46b135602a3f3ac99e@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 10185 Comm: syz-executor1 Not tainted 4.20.0-rc1+ #101
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:cma_bind_listen drivers/infiniband/core/cma.c:3355 [inline]
RIP: 0010:rdma_listen+0x357/0x990 drivers/infiniband/core/cma.c:3469
Code: 4c 8b ab c8 01 00 00 31 f6 48 c7 c7 a0 dc d9 89 e8 ae e9 25 02 48 b8  
00 00 00 00 00 fc ff df 49 8d 7d 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 64 05 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b
RSP: 0018:ffff8801871df970 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8801bc114200 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000008
RBP: ffff8801871dfa10 R08: fffffbfff13b3b9d R09: fffffbfff13b3b9c
R10: ffff8801871df960 R11: ffffffff89d9dce3 R12: 1ffff10030e3bf31
R13: 0000000000000000 R14: 00000000000003ff R15: ffff8801bca00a40
FS:  00007f99bde19700(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcd3fbba88 CR3: 00000001bed0c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ucma_listen+0x1a4/0x260 drivers/infiniband/core/ucma.c:1100
  ucma_write+0x365/0x460 drivers/infiniband/core/ucma.c:1689
  __vfs_write+0x119/0x9f0 fs/read_write.c:485
  vfs_write+0x1fc/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457569
Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f99bde18c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
RDX: 0000000000000010 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 000000000072bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f99bde196d4
R13: 00000000004c5637 R14: 00000000004d9130 R15: 00000000ffffffff
Modules linked in:
kobject: 'loop4' (00000000b75a0f1d): kobject_uevent_env
kobject: 'loop4' (00000000b75a0f1d): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (000000003fdcc2a7): kobject_uevent_env
kobject: 'loop5' (000000003fdcc2a7): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
---[ end trace 4cb66db176b8dee1 ]---
hfs: can't find a HFS filesystem on dev loop5
RIP: 0010:cma_bind_listen drivers/infiniband/core/cma.c:3355 [inline]
RIP: 0010:rdma_listen+0x357/0x990 drivers/infiniband/core/cma.c:3469
kobject: 'loop0' (00000000d690b7fc): kobject_uevent_env
kobject: 'loop0' (00000000d690b7fc): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000b75a0f1d): kobject_uevent_env
kobject: 'loop4' (00000000b75a0f1d): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (000000003fdcc2a7): kobject_uevent_env
kobject: 'loop5' (000000003fdcc2a7): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (000000006d980c29): kobject_uevent_env
kobject: 'loop2' (000000006d980c29): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
Code: 4c 8b ab c8 01 00 00 31 f6 48 c7 c7 a0 dc d9 89 e8 ae e9 25 02 48 b8  
00 00 00 00 00 fc ff df 49 8d 7d 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 64 05 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b
kobject: 'loop4' (00000000b75a0f1d): kobject_uevent_env
RSP: 0018:ffff8801871df970 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8801bc114200 RCX: 0000000000000000
kobject: 'loop4' (00000000b75a0f1d): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000008
RBP: ffff8801871dfa10 R08: fffffbfff13b3b9d R09: fffffbfff13b3b9c
kobject: 'loop0' (00000000d690b7fc): kobject_uevent_env
kobject: 'loop0' (00000000d690b7fc): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (000000003dffde6d): kobject_uevent_env
kobject: 'loop3' (000000003dffde6d): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (000000003fdcc2a7): kobject_uevent_env
kobject: 'loop5' (000000003fdcc2a7): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop5' (000000003fdcc2a7): kobject_uevent_env
hfs: can't find a HFS filesystem on dev loop3
kobject: 'loop5' (000000003fdcc2a7): kobject_uevent_env
kobject: 'loop5' (000000003fdcc2a7): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (00000000d690b7fc): kobject_uevent_env
kobject: 'loop5' (000000003fdcc2a7): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (00000000d690b7fc): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop2' (000000006d980c29): kobject_uevent_env
kobject: 'loop4' (00000000b75a0f1d): kobject_uevent_env
kobject: 'loop2' (000000006d980c29): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000b75a0f1d): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
hfs: can't find a HFS filesystem on dev loop5
kobject: 'loop3' (000000003dffde6d): kobject_uevent_env
R10: ffff8801871df960 R11: ffffffff89d9dce3 R12: 1ffff10030e3bf31
kobject: 'loop3' (000000003dffde6d): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
R13: 0000000000000000 R14: 00000000000003ff R15: ffff8801bca00a40
kobject: 'loop3' (000000003dffde6d): kobject_uevent_env
hfs: can't find a HFS filesystem on dev loop2
kobject: 'loop3' (000000003dffde6d): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (000000003fdcc2a7): kobject_uevent_env
FS:  00007f99bde19700(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
kobject: 'loop0' (00000000d690b7fc): kobject_uevent_env
kobject: 'loop5' (000000003fdcc2a7): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kobject: 'loop2' (000000006d980c29): kobject_uevent_env
kobject: 'loop0' (00000000d690b7fc): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop2' (000000006d980c29): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
CR2: 00000000004c4d0a CR3: 00000001bed0c000 CR4: 00000000001406e0
kobject: 'loop3' (000000003dffde6d): kobject_uevent_env
kobject: 'loop3' (000000003dffde6d): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kobject: 'loop5' (000000003fdcc2a7): kobject_uevent_env
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kobject: 'loop5' (000000003fdcc2a7): fill_kobj_path: path  
= '/devices/virtual/block/loop5'


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
