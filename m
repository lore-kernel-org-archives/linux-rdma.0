From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_valid
 (4)
Date: Wed, 22 Aug 2018 23:16:31 -0700
Message-ID: <20180823061630.GB736@sol.localdomain>
References: <001a1141551246502d056845782e@google.com>
 <001a1140f6ac1677460568489287@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a1140f6ac1677460568489287@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: dasaratharaman.chandramouli@intel.com, leonro@mellanox.com, linux-kernel@vger.kernel.org, markb@mellanox.com, monis@mellanox.com, parav@mellanox.com, syzkaller-bugs@googlegroups.com, syzbot <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
List-Id: linux-rdma@vger.kernel.org

Hello RDMA / InfiniBand maintainers,

This is an RDMA bug and it still occurs on Linus' tree as of today
(commit 815f0ddb346c1960).

I've also simplified the reproducer for it; see below after the original report.
Apparently it involves a race between RDMA_USER_CM_CMD_RESOLVE_IP and
RDMA_USER_CM_CMD_LISTEN.

On Sun, Mar 25, 2018 at 08:43:01PM -0700, syzbot wrote:
> syzbot has found reproducer for the following crash on upstream commit
> 3eb2ce825ea1ad89d20f7a3b5780df850e4be274 (Sun Mar 25 22:44:30 2018 +0000)
> Linux 4.16-rc7
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=29ee8f76017ce6cf03da
> 
> So far this crash happened 4 times on upstream.
> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=4763014771245056
> syzkaller reproducer:
> https://syzkaller.appspot.com/x/repro.syz?id=5870647779524608
> Raw console output:
> https://syzkaller.appspot.com/x/log.txt?id=4652258302099456
> Kernel config:
> https://syzkaller.appspot.com/x/.config?id=-2340295454854568752
> compiler: gcc (GCC) 7.1.1 20170620
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed.
> 
> IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
> 8021q: adding VLAN 0 to HW filter on device bond0
> IPv6: ADDRCONF(NETDEV_UP): veth0: link is not ready
> IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> ==================================================================
> BUG: KASAN: use-after-free in __list_del_entry_valid+0x144/0x150
> lib/list_debug.c:54
> Read of size 8 at addr ffff8801b6022fa0 by task syzkaller871713/4346
> 
> CPU: 1 PID: 4346 Comm: syzkaller871713 Not tainted 4.16.0-rc7+ #2
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x24d lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report+0x23c/0x360 mm/kasan/report.c:412
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
>  __list_del_entry_valid+0x144/0x150 lib/list_debug.c:54
>  __list_del_entry include/linux/list.h:117 [inline]
>  list_del include/linux/list.h:125 [inline]
>  cma_cancel_listens drivers/infiniband/core/cma.c:1569 [inline]
>  cma_cancel_operation+0x455/0xd60 drivers/infiniband/core/cma.c:1597
>  rdma_destroy_id+0xff/0xda0 drivers/infiniband/core/cma.c:1661
>  ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1728
>  __fput+0x327/0x7e0 fs/file_table.c:209
>  ____fput+0x15/0x20 fs/file_table.c:243
>  task_work_run+0x199/0x270 kernel/task_work.c:113
>  exit_task_work include/linux/task_work.h:22 [inline]
>  do_exit+0x9bb/0x1ad0 kernel/exit.c:865
>  do_group_exit+0x149/0x400 kernel/exit.c:968
>  get_signal+0x73a/0x16d0 kernel/signal.c:2469
>  do_signal+0x90/0x1e90 arch/x86/kernel/signal.c:809
>  exit_to_usermode_loop+0x258/0x2f0 arch/x86/entry/common.c:162
>  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
>  do_syscall_64+0x6ec/0x940 arch/x86/entry/common.c:292
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x447529
> RSP: 002b:00007f782c2b0cf8 EFLAGS: 00000202 ORIG_RAX: 00000000000000ca
> RAX: 0000000000000001 RBX: 00000000006ddc5c RCX: 0000000000447529
> RDX: 0000000000447529 RSI: 0000000000000001 RDI: 00000000006ddc5c
> RBP: 00000000006ddc58 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> R13: 00007fff8bb3d8cf R14: 00007f782c2b19c0 R15: 0000000000000005
> 
> Allocated by task 4343:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:552
>  kmem_cache_alloc_trace+0x136/0x740 mm/slab.c:3607
>  kmalloc include/linux/slab.h:512 [inline]
>  kzalloc include/linux/slab.h:701 [inline]
>  rdma_create_id+0xd0/0x630 drivers/infiniband/core/cma.c:787
>  ucma_create_id+0x35f/0x920 drivers/infiniband/core/ucma.c:480
>  ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1649
>  __vfs_write+0xef/0x970 fs/read_write.c:480
>  vfs_write+0x189/0x510 fs/read_write.c:544
>  SYSC_write fs/read_write.c:589 [inline]
>  SyS_write+0xef/0x220 fs/read_write.c:581
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> 
> Freed by task 4346:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:520
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:527
>  __cache_free mm/slab.c:3485 [inline]
>  kfree+0xd9/0x260 mm/slab.c:3800
>  rdma_destroy_id+0x821/0xda0 drivers/infiniband/core/cma.c:1691
>  ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1728
>  __fput+0x327/0x7e0 fs/file_table.c:209
>  ____fput+0x15/0x20 fs/file_table.c:243
>  task_work_run+0x199/0x270 kernel/task_work.c:113
>  exit_task_work include/linux/task_work.h:22 [inline]
>  do_exit+0x9bb/0x1ad0 kernel/exit.c:865
>  do_group_exit+0x149/0x400 kernel/exit.c:968
>  get_signal+0x73a/0x16d0 kernel/signal.c:2469
>  do_signal+0x90/0x1e90 arch/x86/kernel/signal.c:809
>  exit_to_usermode_loop+0x258/0x2f0 arch/x86/entry/common.c:162
>  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
>  do_syscall_64+0x6ec/0x940 arch/x86/entry/common.c:292
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> 
> The buggy address belongs to the object at ffff8801b6022dc0
>  which belongs to the cache kmalloc-1024 of size 1024
> The buggy address is located 480 bytes inside of
>  1024-byte region [ffff8801b6022dc0, ffff8801b60231c0)
> The buggy address belongs to the page:
> page:ffffea0006d80880 count:1 mapcount:0 mapping:ffff8801b6022040 index:0x0
> compound_mapcount: 0
> flags: 0x2fffc0000008100(slab|head)
> raw: 02fffc0000008100 ffff8801b6022040 0000000000000000 0000000100000007
> raw: ffffea0006dca520 ffffea0006d88720 ffff8801dac00ac0 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8801b6022e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b6022f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff8801b6022f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                ^
>  ffff8801b6023000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b6023080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/001a1140f6ac1677460568489287%40google.com.
> For more options, visit https://groups.google.com/d/optout.

Here's my simplified reproducer:

#include <fcntl.h>
#include <pthread.h>
#include <rdma/rdma_user_cm.h>
#include <sys/socket.h>
#include <unistd.h>

#define RDMA_PS_UDP	0x111

static int cmfd;
static volatile int id;

static void *resolve_ip_thread(void *_ignored)
{
	for (;;) {
		struct {
			struct rdma_ucm_cmd_hdr hdr;
			struct rdma_ucm_resolve_ip resolve_ip;
		} cmd = {
			.hdr.cmd = RDMA_USER_CM_CMD_RESOLVE_IP,
			.resolve_ip = {
				.src_addr = { .sin6_family = AF_INET6,
					      .sin6_addr.s6_addr = { [15] = 0xff } },
				.dst_addr = { .sin6_family = AF_INET6 },
				.id = id,
			},
		};
		write(cmfd, &cmd, sizeof(cmd));
	}
}

int main()
{
	pthread_t t;
	int i;

	cmfd = open("/dev/infiniband/rdma_cm", O_WRONLY);

	pthread_create(&t, NULL, resolve_ip_thread, NULL);

	for (i = 0; i < 1000; i++) {
		struct {
			struct rdma_ucm_cmd_hdr hdr;
			struct rdma_ucm_create_id create;
		} create_cmd = {
			.hdr.cmd = RDMA_USER_CM_CMD_CREATE_ID,
			.hdr.out = sizeof(id),
			.create.response = (__u64)&id,
			.create.ps = RDMA_PS_UDP,
		};
		struct {
			struct rdma_ucm_cmd_hdr hdr;
			struct rdma_ucm_listen listen;
		} listen_cmd = {
			.hdr.cmd = RDMA_USER_CM_CMD_LISTEN,
			.listen.id = id,
		};

		write(cmfd, &create_cmd, sizeof(create_cmd));
		write(cmfd, &listen_cmd, sizeof(listen_cmd));
	}
}

It causes:

BUG: KASAN: use-after-free in __list_del_entry_valid+0xf1/0xf3 lib/list_debug.c:51
Read of size 8 at addr ffff88006779ece0 by task syz_ucma/2781

CPU: 2 PID: 2781 Comm: syz_ucma Not tainted 4.18.0+ #8
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-20171110_100015-anatol 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1af/0x294 lib/dump_stack.c:113
 print_address_description+0x6c/0x20b mm/kasan/report.c:256
 kasan_report_error mm/kasan/report.c:354 [inline]
 kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
 __list_del_entry_valid+0xf1/0xf3 lib/list_debug.c:51
 __list_del_entry include/linux/list.h:117 [inline]
 list_del include/linux/list.h:125 [inline]
 cma_cancel_listens drivers/infiniband/core/cma.c:1610 [inline]
 cma_cancel_operation+0x407/0xd80 drivers/infiniband/core/cma.c:1638
 rdma_destroy_id+0x10b/0xcb0 drivers/infiniband/core/cma.c:1702
 ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1759
 __fput+0x305/0x800 fs/file_table.c:278
 ____fput+0x15/0x20 fs/file_table.c:309
 task_work_run+0x1b5/0x270 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xecd/0x24e0 kernel/exit.c:867
 do_group_exit+0x153/0x400 kernel/exit.c:970
 __do_sys_exit_group kernel/exit.c:981 [inline]
 __se_sys_exit_group kernel/exit.c:979 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:979
 do_syscall_64+0x18c/0x750 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f1698d4dee8
Code: Bad RIP value.
RSP: 002b:00007ffdeeec1e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1698d4dee8
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007f16990376d8 R08: 00000000000000e7 R09: ffffffffffffff80
R10: 00007f1699244100 R11: 0000000000000246 R12: 00007f16990376d8
R13: 00007f169903cbe0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 2781:
 save_stack+0x43/0xd0 mm/kasan/kasan.c:448
 set_track mm/kasan/kasan.c:460 [inline]
 kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
 kmem_cache_alloc_trace+0x152/0x730 mm/slab.c:3620
 kmalloc include/linux/slab.h:513 [inline]
 kzalloc include/linux/slab.h:707 [inline]
 __rdma_create_id+0xdf/0x790 drivers/infiniband/core/cma.c:782
 ucma_create_id+0x35c/0x950 drivers/infiniband/core/ucma.c:502
 ucma_write+0x2e8/0x3f0 drivers/infiniband/core/ucma.c:1680
 __vfs_write+0x110/0x830 fs/read_write.c:485
 vfs_write+0x187/0x4e0 fs/read_write.c:549
 ksys_write+0xfa/0x240 fs/read_write.c:598
 __do_sys_write fs/read_write.c:610 [inline]
 __se_sys_write fs/read_write.c:607 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:607
 do_syscall_64+0x18c/0x750 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2781:
 save_stack+0x43/0xd0 mm/kasan/kasan.c:448
 set_track mm/kasan/kasan.c:460 [inline]
 __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
 kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
 __cache_free mm/slab.c:3498 [inline]
 kfree+0xd9/0x210 mm/slab.c:3813
 rdma_destroy_id+0x809/0xcb0 drivers/infiniband/core/cma.c:1737
 ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1759
 __fput+0x305/0x800 fs/file_table.c:278
 ____fput+0x15/0x20 fs/file_table.c:309
 task_work_run+0x1b5/0x270 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xecd/0x24e0 kernel/exit.c:867
 do_group_exit+0x153/0x400 kernel/exit.c:970
 __do_sys_exit_group kernel/exit.c:981 [inline]
 __se_sys_exit_group kernel/exit.c:979 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:979
 do_syscall_64+0x18c/0x750 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88006779eb00
 which belongs to the cache kmalloc-2048 of size 2048
The buggy address is located 480 bytes inside of
 2048-byte region [ffff88006779eb00, ffff88006779f300)
The buggy address belongs to the page:
page:ffffea00019de780 count:1 mapcount:0 mapping:ffff88006c400c40 index:0x0 compound_mapcount: 0
flags: 0x1fffc0000008100(slab|head)
raw: 01fffc0000008100 ffffea0001a87888 ffffea00019c2308 ffff88006c400c40
raw: 0000000000000000 ffff88006779e280 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88006779eb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006779ec00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88006779ec80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff88006779ed00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006779ed80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
Disabling lock debugging due to kernel taint
