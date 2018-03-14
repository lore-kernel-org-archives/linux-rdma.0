From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: WARNING in __local_bh_enable_ip (2)
Date: Wed, 14 Mar 2018 14:28:02 -0700
Message-ID: <1686ceff-9b7e-592e-8607-b3b8add6a6a3@gmail.com>
References: <001a113de654ad181e056764f936@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a113de654ad181e056764f936@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+c68e51bb5e699d3f8d91@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org



On 03/14/2018 01:11 PM, syzbot wrote:
> Hello,
> 
> syzbot hit the following crash on net-next commit
> be9fc0971a5c27b791608cf9705a04fe96dbd395 (Tue Mar 13 11:44:53 2018 +0000)
> net: fix sysctl_fb_tunnels_only_for_init_net link error
> 
> So far this crash happened 2 times on net-next.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c68e51bb5e699d3f8d91@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for 
> details.
> If you forward the report, please keep this part and the footer.
> 
> ------------[ cut here ]------------
> IRQs not enabled as expected
> WARNING: CPU: 1 PID: 21587 at kernel/softirq.c:162 
> __local_bh_enable_ip+0x1bb/0x230 kernel/softirq.c:162
> Kernel panic - not syncing: panic_on_warn set ...
> 
> CPU: 1 PID: 21587 Comm: syz-executor6 Not tainted 4.16.0-rc4+ #264
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:17 [inline]
>   dump_stack+0x194/0x24d lib/dump_stack.c:53
>   panic+0x1e4/0x41c kernel/panic.c:183
>   __warn+0x1dc/0x200 kernel/panic.c:547
> syz-executor7: vmalloc: allocation failure: 17045651456 bytes, 
> mode:0x14080c0(GFP_KERNEL|__GFP_ZERO), nodemask=(null)
>   report_bug+0x211/0x2d0 lib/bug.c:184
>   fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
>   fixup_bug arch/x86/kernel/traps.c:247 [inline]
>   do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
> syz-executor7 cpuset=
> /
>   do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
>   mems_allowed=0
>   invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:986
> RIP: 0010:__local_bh_enable_ip+0x1bb/0x230 kernel/softirq.c:162
> RSP: 0018:ffff8801c95f71e0 EFLAGS: 00010082
> RAX: dffffc0000000008 RBX: 0000000000000201 RCX: ffffffff815abf2e
> RDX: 00000000000037b0 RSI: ffffc900045ec000 RDI: 1ffff100392bedc1
> RBP: ffff8801c95f71f8 R08: 0000000000000000 R09: 1ffff100392bed93
> R10: ffff8801c95f70d8 R11: 0000000000000002 R12: ffffffff85638c44
> R13: ffff8801bb9fc080 R14: ffff8801c95f7290 R15: 1ffff100392bee4a
>   __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:176 [inline]
>   _raw_spin_unlock_bh+0x30/0x40 kernel/locking/spinlock.c:200
>   spin_unlock_bh include/linux/spinlock.h:355 [inline]
>   rds_tcp_conn_free+0xa4/0x2d0 net/rds/tcp.c:281
>   __rds_conn_create+0x148f/0x1b60 net/rds/connection.c:277
>   rds_conn_create_outgoing+0x3f/0x50 net/rds/connection.c:309
>   rds_sendmsg+0xe63/0x2590 net/rds/send.c:1156
>   sock_sendmsg_nosec net/socket.c:629 [inline]
>   sock_sendmsg+0xca/0x110 net/socket.c:639
>   ___sys_sendmsg+0x767/0x8b0 net/socket.c:2047
>   __sys_sendmsg+0xe5/0x210 net/socket.c:2081
>   SYSC_sendmsg net/socket.c:2092 [inline]
>   SyS_sendmsg+0x2d/0x50 net/socket.c:2088
>   do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>   entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x453e69
> RSP: 002b:00007f102cbd0c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f102cbd16d4 RCX: 0000000000453e69
> RDX: 0000000000000000 RSI: 0000000020001580 RDI: 0000000000000014
> RBP: 000000000072bf58 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00000000000004b9 R14: 00000000006f71f8 R15: 0000000000000001
> CPU: 0 PID: 21594 Comm: syz-executor7 Not tainted 4.16.0-rc4+ #264
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:17 [inline]
>   dump_stack+0x194/0x24d lib/dump_stack.c:53
>   warn_alloc+0x19a/0x2b0 mm/page_alloc.c:3310
>   __vmalloc_node_range+0x4f0/0x650 mm/vmalloc.c:1775
>   __vmalloc_node mm/vmalloc.c:1804 [inline]
>   __vmalloc_node_flags_caller+0x50/0x60 mm/vmalloc.c:1826
>   kvmalloc_node+0x82/0xd0 mm/util.c:428
>   kvmalloc include/linux/mm.h:541 [inline]
>   kvmalloc_array include/linux/mm.h:557 [inline]
>   xt_alloc_entry_offsets+0x21/0x30 net/netfilter/x_tables.c:778
>   translate_table+0x235/0x1690 net/ipv6/netfilter/ip6_tables.c:703
>   do_replace net/ipv6/netfilter/ip6_tables.c:1164 [inline]
>   do_ip6t_set_ctl+0x370/0x5f0 net/ipv6/netfilter/ip6_tables.c:1690
>   nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>   nf_setsockopt+0x67/0xc0 net/netfilter/nf_sockopt.c:115
>   ipv6_setsockopt+0x10b/0x130 net/ipv6/ipv6_sockglue.c:927
>   tcp_setsockopt+0x82/0xd0 net/ipv4/tcp.c:2878
>   sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2980
>   SYSC_setsockopt net/socket.c:1850 [inline]
>   SyS_setsockopt+0x189/0x360 net/socket.c:1829
>   do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>   entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x453e69
> RSP: 002b:00007f0cd3439c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007f0cd343a6d4 RCX: 0000000000453e69
> RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000014
> RBP: 000000000072bea0 R08: 0000000000000004 R09: 0000000000000000
> R10: 0000000020001fde R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000520 R14: 00000000006f7ba0 R15: 0000000000000000
> Dumping ftrace buffer:
>     (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is 
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug 
> report.
> Note: all commands must start from beginning of the line in the email body.


spin_lock_bh(&rds_tcp_conn_lock);/spin_unlock_bh(&rds_tcp_conn_lock); 
in rds_tcp_conn_free()

is in conflict with the spin_lock_irqsave(&rds_conn_lock, flags);
in __rds_conn_create()

Hard to understand why RDS is messing with hard irqs really.
