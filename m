From: syzbot <syzbot+0049bebbf3042dbd2e8f@syzkaller.appspotmail.com>
Subject: Re: KMSAN: uninit-value in rds_connect
Date: Thu, 30 Aug 2018 18:25:02 -0700
Message-ID: <000000000000935bfc0574b10f14@google.com>
References: <00000000000005859b0574ab47e5@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000005859b0574ab47e5@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    25114c64b719 kmsan: unpoison pages moved from iov_iter to ..
git tree:       https://github.com/google/kmsan.git/master
console output: https://syzkaller.appspot.com/x/log.txt?x=14465da6400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3431f03869413153
dashboard link: https://syzkaller.appspot.com/bug?extid=0049bebbf3042dbd2e8f
compiler:       clang version 8.0.0 (trunk 339414)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b8513e400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d64e96400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0049bebbf3042dbd2e8f@syzkaller.appspotmail.com

random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
==================================================================
BUG: KMSAN: uninit-value in rds_connect+0x213/0x950 net/rds/af_rds.c:511
CPU: 0 PID: 4780 Comm: syz-executor239 Not tainted 4.19.0-rc1+ #38
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x14b/0x190 lib/dump_stack.c:113
  kmsan_report+0x183/0x2b0 mm/kmsan/kmsan.c:956
  __msan_warning+0x70/0xc0 mm/kmsan/kmsan_instr.c:645
  rds_connect+0x213/0x950 net/rds/af_rds.c:511
  __sys_connect+0x64e/0x750 net/socket.c:1662
  __do_sys_connect net/socket.c:1673 [inline]
  __se_sys_connect net/socket.c:1670 [inline]
  __x64_sys_connect+0xd8/0x120 net/socket.c:1670
  do_syscall_64+0x15b/0x220 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x440199
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff5f41c118 EFLAGS: 00000213 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440199
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000213 R12: 0000000000401a20
R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000

Local variable description: ----address@__sys_connect
Variable was created at:
  __sys_connect+0x6a/0x750 net/socket.c:1645
  __do_sys_connect net/socket.c:1673 [inline]
  __se_sys_connect net/socket.c:1670 [inline]
  __x64_sys_connect+0xd8/0x120 net/socket.c:1670
==================================================================
