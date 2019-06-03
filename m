From: syzbot <syzbot+bad6e32808a3a97b1515-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: WARNING: suspicious RCU usage in in_dev_dump_addr
Date: Mon, 03 Jun 2019 11:51:05 -0700
Message-ID: <000000000000bec591058a6fd889@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: amitkarwar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anshuman.khandual-5wv7dgnIgG8@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, benedictwong-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, dbanerje-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, doshir-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, gbhat-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org, huxinming820-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jakub.kicinski-wFxRvT7yatFl57MIdRCFDg@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liuhangbin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lucien.xin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matwey-TTlVxmypnbovJsYlp49lxw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, neescoba@cisc
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b33bc2b8 nexthop: Add entry to MAINTAINERS
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13f46f52a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1004db091673bbaf
dashboard link: https://syzkaller.appspot.com/bug?extid=bad6e32808a3a97b1515
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11dc685aa00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16229e36a00000

The bug was bisected to:

commit 2638eb8b50cfc16240e0bb080b9afbf541a9b39d
Author: Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>
Date:   Fri May 31 16:27:09 2019 +0000

     net: ipv4: provide __rcu annotation for ifa_list

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170e1a0ea00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=148e1a0ea00000
console output: https://syzkaller.appspot.com/x/log.txt?x=108e1a0ea00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bad6e32808a3a97b1515-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")

=============================
WARNING: suspicious RCU usage
5.2.0-rc2+ #13 Not tainted
-----------------------------
net/ipv4/devinet.c:1766 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor924/9000:
  #0: 0000000087fe3874 (rtnl_mutex){+.+.}, at: netlink_dump+0xe7/0xfb0  
net/netlink/af_netlink.c:2208

stack backtrace:
CPU: 0 PID: 9000 Comm: syz-executor924 Not tainted 5.2.0-rc2+ #13
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  lockdep_rcu_suspicious+0x153/0x15d kernel/locking/lockdep.c:5250
  in_dev_dump_addr+0x36f/0x3d0 net/ipv4/devinet.c:1766
  inet_dump_ifaddr+0xa8f/0xca0 net/ipv4/devinet.c:1826
  rtnl_dump_all+0x295/0x490 net/core/rtnetlink.c:3444
  netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2253
  __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2361
  netlink_dump_start include/linux/netlink.h:226 [inline]
  rtnetlink_rcv_msg+0x73d/0xb00 net/core/rtnetlink.c:5181
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2486
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:671
  ___sys_sendmsg+0x803/0x920 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffe5f26f18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402a9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10:


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
