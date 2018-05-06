From: syzbot <syzbot+8458d13b13562abf6b77@syzkaller.appspotmail.com>
Subject: Re: BUG: corrupted list in rdma_listen
Date: Sat, 05 May 2018 21:09:02 -0700
Message-ID: <0000000000009c49d7056b81b646@google.com>
References: <000000000000a366e2056a35c6fd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000a366e2056a35c6fd@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dasaratharaman.chandramouli@intel.com, dledford@redhat.com, jgg@ziepe.ca, leonro@mellanox.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, markb@mellanox.com, monis@mellanox.com, parav@mellanox.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    d2d741e5d189 kmsan: add initialization for shmem pages
git tree:       https://github.com/google/kmsan.git/master
console output: https://syzkaller.appspot.com/x/log.txt?x=126df297800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=48f9de3384bcd0f
dashboard link: https://syzkaller.appspot.com/bug?extid=8458d13b13562abf6b77
compiler:       clang version 7.0.0 (trunk 329391)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=168a7237800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176f5e07800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8458d13b13562abf6b77@syzkaller.appspotmail.com

list_add corruption. prev->next should be next (00000000f634c78e), but  
was           (null). (prev=000000004ec1b2e1).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:28!
invalid opcode: 0000 [#1] SMP PTI
Dumping ftrace buffer:
    (ftrace buffer empty)
Modules linked in:
CPU: 1 PID: 4686 Comm: syz-executor918 Not tainted 4.16.0+ #87
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_add_valid+0x43c/0x450 lib/list_debug.c:26
RSP: 0018:ffff8801af0df9e0 EFLAGS: 00010286
RAX: 0000000000000075 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: aaaaaaaaaaaab000 RDI: ffffea0000000000
RBP: ffff8801af0dfa48 R08: 0000000001080020 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8acd0d90
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88019d514418
FS:  0000000001259880(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006cc0a0 CR3: 000000019d4a4000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_add include/linux/list.h:60 [inline]
  list_add_tail include/linux/list.h:93 [inline]
  cma_listen_on_all drivers/infiniband/core/cma.c:2309 [inline]
  rdma_listen+0x65f/0x10f0 drivers/infiniband/core/cma.c:3333
  ucma_listen+0x4e9/0x630 drivers/infiniband/core/ucma.c:1074
  ucma_write+0x576/0x5e0 drivers/infiniband/core/ucma.c:1656
  __vfs_write+0x1a3/0x9f0 fs/read_write.c:480
  vfs_write+0x463/0x8d0 fs/read_write.c:544
  SYSC_write+0x172/0x360 fs/read_write.c:589
  SyS_write+0x55/0x80 fs/read_write.c:581
  do_syscall_64+0x309/0x430 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
RIP: 0033:0x4417b9
RSP: 002b:00007ffd97fcaf88 EFLAGS: 00000207 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004417b9
RDX: 0000000000000010 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000207 R12: 000000000000aa92
R13: 00000000006cd448 R14: 0000000000000000 R15: 0000000000000000
Code: 80 0c 00 00 00 00 00 00 41 c7 87 20 03 00 00 00 00 00 00 48 c7 c7 c8  
f6 82 8a 31 c0 4c 89 e6 4c 89 ea 48 8b 4d c0 e8 34 ab 51 fd <0f> 0b 66 90  
eb fe 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 55
RIP: __list_add_valid+0x43c/0x450 lib/list_debug.c:26 RSP: ffff8801af0df9e0
---[ end trace 0c643a8ef7cc369f ]---
