From: syzbot <syzbot+52140d69ac6dc6b927a9@syzkaller.appspotmail.com>
Subject: possible deadlock in rds_wake_sk_sleep
Date: Tue, 07 Aug 2018 13:47:02 -0700
Message-ID: <000000000000fb5cd90572de7ebd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    afb41bb03965 drivers: net: lmc: fix case value for target ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=103e0a54400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2dc0cd7c2eefb46f
dashboard link: https://syzkaller.appspot.com/bug?extid=52140d69ac6dc6b927a9
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+52140d69ac6dc6b927a9@syzkaller.appspotmail.com


validate_nla: 5 callbacks suppressed
netlink: 'syz-executor1': attribute type 1 has an invalid length.
======================================================
WARNING: possible circular locking dependency detected
4.18.0-rc7+ #40 Not tainted
------------------------------------------------------
syz-executor4/2910 is trying to acquire lock:
00000000cd5fd083 (&rs->rs_recv_lock){..--}, at:  
rds_wake_sk_sleep+0x7c/0x1a0 net/rds/af_rds.c:108

but task is already holding lock:
00000000b1279274 (&(&rm->m_rs_lock)->rlock){..-.}, at:  
rds_send_remove_from_sock+0x260/0xba0 net/rds/send.c:618

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&rm->m_rs_lock)->rlock){..-.}:
        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
        _raw_spin_lock_irqsave+0x96/0xc0 kernel/locking/spinlock.c:152
        rds_message_purge net/rds/message.c:138 [inline]
        rds_message_put+0x3aa/0x1020 net/rds/message.c:180
        rds_loop_inc_free+0x16/0x20 net/rds/loop.c:114
        rds_inc_put+0x1ed/0x2b0 net/rds/recv.c:87
        rds_clear_recv_queue+0x224/0x4d0 net/rds/recv.c:744
        rds_release+0x162/0x570 net/rds/af_rds.c:72
        __sock_release+0xd7/0x260 net/socket.c:600
        sock_close+0x19/0x20 net/socket.c:1151
        __fput+0x355/0x8b0 fs/file_table.c:209
        ____fput+0x15/0x20 fs/file_table.c:243
        task_work_run+0x1ec/0x2a0 kernel/task_work.c:113
        tracehook_notify_resume include/linux/tracehook.h:192 [inline]
        exit_to_usermode_loop+0x313/0x370 arch/x86/entry/common.c:166
        prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
        syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
        do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&rs->rs_recv_lock){..--}:
        lock_acquire+0x1e4/0x540 kernel/locking/lockdep.c:3924
        __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:159 [inline]
        _raw_read_lock_irqsave+0x99/0xc2 kernel/locking/spinlock.c:224
        rds_wake_sk_sleep+0x7c/0x1a0 net/rds/af_rds.c:108
        rds_send_remove_from_sock+0x2f7/0xba0 net/rds/send.c:624
        rds_send_path_drop_acked+0x4b1/0x600 net/rds/send.c:700
        rds_tcp_write_space+0x1e9/0x84a net/rds/tcp_send.c:203
        tcp_new_space net/ipv4/tcp_input.c:5115 [inline]
        tcp_check_space+0x551/0x930 net/ipv4/tcp_input.c:5126
        tcp_data_snd_check net/ipv4/tcp_input.c:5136 [inline]
        tcp_rcv_established+0x14f3/0x2060 net/ipv4/tcp_input.c:5532
        tcp_v4_do_rcv+0x5a9/0x850 net/ipv4/tcp_ipv4.c:1531
        sk_backlog_rcv include/net/sock.h:914 [inline]
        __release_sock+0x12f/0x3a0 net/core/sock.c:2342
        release_sock+0xad/0x2c0 net/core/sock.c:2851
        do_tcp_setsockopt.isra.41+0x48e/0x2720 net/ipv4/tcp.c:3055
        tcp_setsockopt+0xc1/0xe0 net/ipv4/tcp.c:3067
        sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3040
        kernel_setsockopt+0x10f/0x1d0 net/socket.c:3323
        rds_tcp_cork net/rds/tcp_send.c:43 [inline]
        rds_tcp_xmit_path_complete+0xf1/0x150 net/rds/tcp_send.c:57
        rds_send_xmit+0x1806/0x29c0 net/rds/send.c:410
        rds_sendmsg+0x22b4/0x2ad0 net/rds/send.c:1245
        sock_sendmsg_nosec net/socket.c:642 [inline]
        sock_sendmsg+0xd5/0x120 net/socket.c:652
        __sys_sendto+0x3d7/0x670 net/socket.c:1798
        __do_sys_sendto net/socket.c:1810 [inline]
        __se_sys_sendto net/socket.c:1806 [inline]
        __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1806
        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&(&rm->m_rs_lock)->rlock);
                                lock(&rs->rs_recv_lock);
                                lock(&(&rm->m_rs_lock)->rlock);
   lock(&rs->rs_recv_lock);

  *** DEADLOCK ***

3 locks held by syz-executor4/2910:
  #0: 00000000fc201287 (k-sk_lock-AF_INET){+.+.}, at: lock_sock  
include/net/sock.h:1474 [inline]
  #0: 00000000fc201287 (k-sk_lock-AF_INET){+.+.}, at:  
do_tcp_setsockopt.isra.41+0x18e/0x2720 net/ipv4/tcp.c:2779
  #1: 000000009677f579 (k-clock-AF_INET){++.-}, at:  
rds_tcp_write_space+0x9a/0x84a net/rds/tcp_send.c:189
  #2: 00000000b1279274 (&(&rm->m_rs_lock)->rlock){..-.}, at:  
rds_send_remove_from_sock+0x260/0xba0 net/rds/send.c:618

stack backtrace:
CPU: 0 PID: 2910 Comm: syz-executor4 Not tainted 4.18.0-rc7+ #40
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_circular_bug.isra.36.cold.57+0x1bd/0x27d  
kernel/locking/lockdep.c:1227
  check_prev_add kernel/locking/lockdep.c:1867 [inline]
  check_prevs_add kernel/locking/lockdep.c:1980 [inline]
  validate_chain kernel/locking/lockdep.c:2421 [inline]
  __lock_acquire+0x3449/0x5020 kernel/locking/lockdep.c:3435
  lock_acquire+0x1e4/0x540 kernel/locking/lockdep.c:3924
  __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:159 [inline]
  _raw_read_lock_irqsave+0x99/0xc2 kernel/locking/spinlock.c:224
  rds_wake_sk_sleep+0x7c/0x1a0 net/rds/af_rds.c:108
  rds_send_remove_from_sock+0x2f7/0xba0 net/rds/send.c:624
  rds_send_path_drop_acked+0x4b1/0x600 net/rds/send.c:700
  rds_tcp_write_space+0x1e9/0x84a net/rds/tcp_send.c:203
  tcp_new_space net/ipv4/tcp_input.c:5115 [inline]
  tcp_check_space+0x551/0x930 net/ipv4/tcp_input.c:5126
  tcp_data_snd_check net/ipv4/tcp_input.c:5136 [inline]
  tcp_rcv_established+0x14f3/0x2060 net/ipv4/tcp_input.c:5532
  tcp_v4_do_rcv+0x5a9/0x850 net/ipv4/tcp_ipv4.c:1531
  sk_backlog_rcv include/net/sock.h:914 [inline]
  __release_sock+0x12f/0x3a0 net/core/sock.c:2342
  release_sock+0xad/0x2c0 net/core/sock.c:2851
  do_tcp_setsockopt.isra.41+0x48e/0x2720 net/ipv4/tcp.c:3055
  tcp_setsockopt+0xc1/0xe0 net/ipv4/tcp.c:3067
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3040
  kernel_setsockopt+0x10f/0x1d0 net/socket.c:3323
  rds_tcp_cork net/rds/tcp_send.c:43 [inline]
  rds_tcp_xmit_path_complete+0xf1/0x150 net/rds/tcp_send.c:57
  rds_send_xmit+0x1806/0x29c0 net/rds/send.c:410
  rds_sendmsg+0x22b4/0x2ad0 net/rds/send.c:1245
  sock_sendmsg_nosec net/socket.c:642 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:652
  __sys_sendto+0x3d7/0x670 net/socket.c:1798
  __do_sys_sendto net/socket.c:1810 [inline]
  __se_sys_sendto net/socket.c:1806 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1806
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x456b29
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8e28a68c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f8e28a696d4 RCX: 0000000000456b29
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000016
RBP: 0000000000930140 R08: 00000000202b4000 R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d3608 R14: 00000000004c8297 R15: 0000000000000001
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
validate_nla: 24 callbacks suppressed
netlink: 'syz-executor6': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor5': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor6': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
netlink: 'syz-executor6': attribute type 1 has an invalid length.
netlink: 'syz-executor6': attribute type 1 has an invalid length.
netlink: 'syz-executor1': attribute type 1 has an invalid length.
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 1 PID: 4446 Comm: syz-executor3 Not tainted 4.18.0-rc7+ #40
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  fail_dump lib/fault-inject.c:51 [inline]
  should_fail.cold.4+0xa/0x1a lib/fault-inject.c:149
  __should_failslab+0x124/0x180 mm/failslab.c:32
  should_failslab+0x9/0x14 mm/slab_common.c:1557
  slab_pre_alloc_hook mm/slab.h:423 [inline]
  slab_alloc_node mm/slab.c:3299 [inline]
  kmem_cache_alloc_node_trace+0x26f/0x770 mm/slab.c:3661
  kmalloc_node include/linux/slab.h:551 [inline]
  kzalloc_node include/linux/slab.h:718 [inline]
  __get_vm_area_node+0x12d/0x390 mm/vmalloc.c:1389
  __vmalloc_node_range+0xc4/0x760 mm/vmalloc.c:1741
  __vmalloc_node mm/vmalloc.c:1791 [inline]
  __vmalloc+0x45/0x50 mm/vmalloc.c:1797
  bpf_prog_alloc+0xe3/0x3e0 kernel/bpf/core.c:85
  bpf_prog_load+0x435/0x1c90 kernel/bpf/syscall.c:1308
  __do_sys_bpf kernel/bpf/syscall.c:2307 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:2269 [inline]
  __x64_sys_bpf+0x36c/0x510 kernel/bpf/syscall.c:2269
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x456b29
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f06ce4a2c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f06ce4a36d4 RCX: 0000000000456b29
RDX: 0000000000000048 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 00000000009300a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000013
R13: 00000000004ca9c8 R14: 00000000004c2932 R15: 0000000000000000
syz-executor3: vmalloc: allocation failure: 4096 bytes,  
mode:0x6280c0(GFP_USER|__GFP_ZERO), nodemask=(null)
syz-executor3 cpuset=/ mems_allowed=0
CPU: 1 PID: 4446 Comm: syz-executor3 Not tainted 4.18.0-rc7+ #40
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  warn_alloc.cold.117+0xb7/0x1bd mm/page_alloc.c:3426
  __vmalloc_node_range+0x472/0x760 mm/vmalloc.c:1762
  __vmalloc_node mm/vmalloc.c:1791 [inline]
  __vmalloc+0x45/0x50 mm/vmalloc.c:1797
  bpf_prog_alloc+0xe3/0x3e0 kernel/bpf/core.c:85
  bpf_prog_load+0x435/0x1c90 kernel/bpf/syscall.c:1308
  __do_sys_bpf kernel/bpf/syscall.c:2307 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:2269 [inline]
  __x64_sys_bpf+0x36c/0x510 kernel/bpf/syscall.c:2269
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x456b29
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f06ce4a2c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f06ce4a36d4 RCX: 0000000000456b29
RDX: 0000000000000048 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 00000000009300a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000013
R13: 00000000004ca9c8 R14: 00000000004c2932 R15: 0000000000000000
Mem-Info:
active_anon:43614 inactive_anon:330 isolated_anon:0
  active_file:5291 inactive_file:10584 isolated_file:0
  unevictable:0 dirty:122 writeback:0 unstable:0
  slab_reclaimable:12423 slab_unreclaimable:150511
  mapped:71830 shmem:345 pagetables:872 bounce:0
  free:1304880 free_pcp:474 free_cma:0
Node 0 active_anon:174456kB inactive_anon:1320kB active_file:21164kB  
inactive_file:42336kB unevictable:0kB isolated(anon):0kB isolated(file):0kB  
mapped:287320kB dirty:488kB writeback:0kB shmem:1380kB shmem_thp: 0kB  
shmem_pmdmapped: 0kB anon_thp: 167936kB writeback_tmp:0kB unstable:0kB  
all_unreclaimable? no
Node 0 DMA free:15908kB min:164kB low:204kB high:244kB active_anon:0kB  
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB  
writepending:0kB present:15992kB managed:15908kB mlocked:0kB  
kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB  
free_cma:0kB
lowmem_reserve[]: 0 2844 6351 6351
Node 0 DMA32 free:2916060kB min:30192kB low:37740kB high:45288kB  
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB  
unevictable:0kB writepending:0kB present:3129292kB managed:2916680kB  
mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:620kB  
local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 0 3507 3507
Node 0 Normal free:2287552kB min:37224kB low:46528kB high:55832kB  
active_anon:174456kB inactive_anon:1320kB active_file:21164kB  
inactive_file:42336kB unevictable:0kB writepending:488kB present:4718592kB  
managed:3591240kB mlocked:0kB kernel_stack:39744kB pagetables:3488kB  
bounce:0kB free_pcp:1276kB local_pcp:556kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 2*64kB (U) 1*128kB (U)  
1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15908kB
Node 0 DMA32: 3*4kB (M) 2*8kB (M) 4*16kB (M) 4*32kB (M) 2*64kB (M) 3*128kB  
(M) 2*256kB (M) 3*512kB (M) 1*1024kB (M) 2*2048kB (M) 710*4096kB (M) =  
2916060kB
Node 0 Normal: 128*4kB (UM) 690*8kB (UM) 610*16kB (M) 455*32kB (UME)  
184*64kB (UME) 38*128kB (UME) 12*256kB (UME) 66*512kB (UME) 70*1024kB (UME)  
3*2048kB (UM) 519*4096kB (UM) = 2287504kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0  
hugepages_size=2048kB
16219 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
1965969 pages RAM
0 pages HighMem/MovableOnly
335012 pages reserved
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 1 PID: 4502 Comm: syz-executor6 Not tainted 4.18.0-rc7+ #40
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  fail_dump lib/fault-inject.c:51 [inline]
  should_fail.cold.4+0xa/0x1a lib/fault-inject.c:149
  __should_failslab+0x124/0x180 mm/failslab.c:32
  should_failslab+0x9/0x14 mm/slab_common.c:1557
  slab_pre_alloc_hook mm/slab.h:423 [inline]
  slab_alloc_node mm/slab.c:3299 [inline]
  kmem_cache_alloc_node+0x272/0x780 mm/slab.c:3642
  __alloc_skb+0x119/0x770 net/core/skbuff.c:193
  alloc_skb include/linux/skbuff.h:987 [inline]
  netlink_alloc_large_skb net/netlink/af_netlink.c:1189 [inline]
  netlink_sendmsg+0xb29/0xfd0 net/netlink/af_netlink.c:1883
  sock_sendmsg_nosec net/socket.c:642 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:652
  ___sys_sendmsg+0x7fd/0x930 net/socket.c:2126


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
