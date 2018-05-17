From: DaeRyong Jeong <threeearcat@gmail.com>
Subject: KASAN: null-ptr-deref Read in rdma_listen
Date: Thu, 17 May 2018 22:23:10 +0900
Message-ID: <20180517132306.GA16708@dragonet.kaist.ac.kr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, parav@mellanox.com, danielj@mellanox.com, monis@mellanox.com, swise@opengridcomputing.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, byoungyoung@purdue.edu, kt0755@gmail.com, bammanag@purdue.edu
List-Id: linux-rdma@vger.kernel.org

We report the crash: KASAN: null-ptr-deref Read in rdma_listen

This crash has been found in v4.17-rc1 using RaceFuzzer (a modified
version of Syzkaller), which we describe more at the end of this
report. Our analysis shows that the race occurs when invoking two
write syscalls with the command 'listen' concurrently .


Diagnosis:
We think two concurrent execution of rdma_listen() causes the problem.
Scenario is as follows.
One thread executes rdma_listen(). and then it enters rdma_bind_addr() because
id_priv->state is RDMA_CM_IDLE at the beginning. it changes the value of
id_priv->state to RDMA_CM_ADDR_BOUND.
And then switch to the other thread. This thread also runs
rdma_listen(). Since the first thread changes the value of id_priv->state to
the RDMA_CM_ADDR_BOUND, the second thread can change the value of
id_priv->state to the RDMA_CM_LISTEN and can executes cma_bind_listen().
But since the first thread has not finished the rdma_bind_addr(),
id_priv->bind_list is still null. Therefore, null-ptr-deref occurs in
cma_bind_listen().


Thread interleaving:
CPU0 (rdma_listen)						CPU1 (rdma_listen)
=====								=====
id_priv = container_of(id, struct rdma_id_private, id);
if (id_priv->state == RDMA_CM_IDLE) {
	id->route.addr.src_addr.ss_family = AF_INET;
	ret = rdma_bind_addr(id, cma_src_addr(id_priv));
...
(in rdma_bind_addr)
id_priv = container_of(id, struct rdma_id_private, id);
if (!cma_comp_exch(id_priv, RDMA_CM_IDLE, RDMA_CM_ADDR_BOUND))

								id_priv = container_of(id, struct rdma_id_private, id);
								//  Here, id_priv->state is already RDMA_CM_ADDR_BOUND
								if (id_priv->state == RDMA_CM_IDLE) {
									...
								}

								if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN))
									return -EINVAL;

								if (id_priv->reuseaddr) {
									ret = cma_bind_listen(id_priv);
...
ret = cma_get_port(id_priv);


Call sequence (v4.17-rc1):
CPU0
ucma_listen
	rdma_listen
		rdma_bind_addr

CPU1
ucma_listen
	rdma_listen
		cma_bind_listen



Crash log:
==================================================================
BUG: KASAN: null-ptr-deref in cma_bind_listen drivers/infiniband/core/cma.c:3167 [inline]
BUG: KASAN: null-ptr-deref in rdma_listen+0x1f6/0x4f0 drivers/infiniband/core/cma.c:3281
Read of size 8 at addr 0000000000000008 by task syz-executor0/21413

CPU: 1 PID: 21413 Comm: syz-executor0 Not tainted 4.17.0-rc1 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.2-0-g33fbe13 by qemu-project.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x166/0x21c lib/dump_stack.c:113
 kasan_report_error mm/kasan/report.c:352 [inline]
 kasan_report+0x140/0x360 mm/kasan/report.c:412
 check_memory_region_inline mm/kasan/kasan.c:260 [inline]
 __asan_load8+0x54/0x90 mm/kasan/kasan.c:699
 cma_bind_listen drivers/infiniband/core/cma.c:3167 [inline]
 rdma_listen+0x1f6/0x4f0 drivers/infiniband/core/cma.c:3281
 ucma_listen+0xeb/0x150 drivers/infiniband/core/ucma.c:1079
 ucma_write+0x1d6/0x260 drivers/infiniband/core/ucma.c:1664
 __vfs_write+0xdd/0x480 fs/read_write.c:485
 vfs_write+0x12d/0x2d0 fs/read_write.c:549
 ksys_write+0xca/0x190 fs/read_write.c:598
 __do_sys_write fs/read_write.c:610 [inline]
 __se_sys_write fs/read_write.c:607 [inline]
 __x64_sys_write+0x43/0x50 fs/read_write.c:607
 do_syscall_64+0x15f/0x4a0 arch/x86/entry/common.c:287
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4563f9
RSP: 002b:00007fb1d41c6b28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000072bfa0 RCX: 00000000004563f9
RDX: 0000000000000010 RSI: 0000000020000140 RDI: 0000000000000016
RBP: 0000000000000720 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb1d41c76d4
R13: 00000000ffffffff R14: 00000000006ffba0 R15: 0000000000000000
==================================================================


= About RaceFuzzer

RaceFuzzer is a customized version of Syzkaller, specifically tailored
to find race condition bugs in the Linux kernel. While we leverage
many different technique, the notable feature of RaceFuzzer is in
leveraging a custom hypervisor (QEMU/KVM) to interleave the
scheduling. In particular, we modified the hypervisor to intentionally
stall a per-core execution, which is similar to supporting per-core
breakpoint functionality. This allows RaceFuzzer to force the kernel
to deterministically trigger racy condition (which may rarely happen
in practice due to randomness in scheduling).

RaceFuzzer's C repro always pinpoints two racy syscalls. Since C
repro's scheduling synchronization should be performed at the user
space, its reproducibility is limited (reproduction may take from 1
second to 10 minutes (or even more), depending on a bug). This is
because, while RaceFuzzer precisely interleaves the scheduling at the
kernel's instruction level when finding this bug, C repro cannot fully
utilize such a feature. Please disregard all code related to
"should_hypercall" in the C repro, as this is only for our debugging
purposes using our own hypervisor.
