From: syzbot <syzbot+20c32fa6ff84a2d28c36@syzkaller.appspotmail.com>
Subject: Re: general protection fault in addr_resolve
Date: Thu, 27 Sep 2018 15:06:03 -0700
Message-ID: <0000000000007af94d0576e18b26@google.com>
References: <0000000000000d23fc05765d8484@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000000d23fc05765d8484@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: danielj@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    9e27e2c2d003 Add linux-next specific files for 20180927
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11192181400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a5d69f8adce7f4
dashboard link: https://syzkaller.appspot.com/bug?extid=20c32fa6ff84a2d28c36
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134b814e400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1792f32a400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+20c32fa6ff84a2d28c36@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device team0
IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
netlink: 9 bytes leftover after parsing attributes in process  
`syz-executor811'.
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 6313 Comm: syz-executor811 Not tainted  
4.19.0-rc5-next-20180927+ #82
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:copy_src_l2_addr drivers/infiniband/core/addr.c:489 [inline]
RIP: 0010:rdma_set_src_addr_rcu drivers/infiniband/core/addr.c:520 [inline]
RIP: 0010:addr_resolve+0x7bd/0x1b80 drivers/infiniband/core/addr.c:594
Code: 0f 84 da 01 00 00 e8 e2 ff e8 fb 48 8b 85 d0 fd ff ff 48 8d b8 54 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 95
RSP: 0018:ffff8801ce897368 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8801ce897578 RCX: ffffffff859459d0
RDX: 000000000000003e RSI: ffffffff859459de RDI: 00000000000001f1
RBP: ffff8801ce8975a0 R08: ffff8801ce192300 R09: 0000000000000000
R10: ffffed0039d12e60 R11: 0000000000000000 R12: ffff8801bf2fcd20
R13: 00000000ffffff9d R14: 0000000000000001 R15: 000000000000000a
FS:  00000000011ea880(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006cd0a0 CR3: 00000001cdff3000 CR4: 00000000001406e0
Call Trace:
  rdma_resolve_ip+0x499/0x790 drivers/infiniband/core/addr.c:698
  rdma_resolve_addr+0x2d6/0x2870 drivers/infiniband/core/cma.c:2992
  ucma_resolve_ip+0x242/0x2a0 drivers/infiniband/core/ucma.c:713
  ucma_write+0x336/0x420 drivers/infiniband/core/ucma.c:1686
  __vfs_write+0x119/0x9f0 fs/read_write.c:485
  vfs_write+0x1fc/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441ff9
Code: e8 0c ac 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 04 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffceec770c8 EFLAGS: 00000213 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000020000140 RCX: 0000000000441ff9
RDX: 0000000000000048 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 0000000000011a59 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000213 R12: 0000000000000000
R13: 0000000000402a10 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 1ee654df4023a5cc ]---
RIP: 0010:copy_src_l2_addr drivers/infiniband/core/addr.c:489 [inline]
RIP: 0010:rdma_set_src_addr_rcu drivers/infiniband/core/addr.c:520 [inline]
RIP: 0010:addr_resolve+0x7bd/0x1b80 drivers/infiniband/core/addr.c:594
Code: 0f 84 da 01 00 00 e8 e2 ff e8 fb 48 8b 85 d0 fd ff ff 48 8d b8 54 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 95
RSP: 0018:ffff8801ce897368 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8801ce897578 RCX: ffffffff859459d0
RDX: 000000000000003e RSI: ffffffff859459de RDI: 00000000000001f1
RBP: ffff8801ce8975a0 R08: ffff8801ce192300 R09: 0000000000000000
R10: ffffed0039d12e60 R11: 0000000000000000 R12: ffff8801bf2fcd20
R13: 00000000ffffff9d R14: 0000000000000001 R15: 000000000000000a
FS:  00000000011ea880(0000) GS:ffff8801dac00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c0ba8 CR3: 00000001cdff3000 CR4: 00000000001406f0
