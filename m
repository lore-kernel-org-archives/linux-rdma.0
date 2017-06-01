From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Issue with Infiniband / MLX5 IB driver when running opensm
Date: Thu, 1 Jun 2017 19:40:21 +0100
Message-ID: <4bad8be6-4179-00e2-4ad9-7c2edad77810@synopsys.com>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>
 <20170531161819.GK5406@mtr-leonro.local>
 <20170531194426.GA23120@infradead.org>
 <20170601043013.GN5406@mtr-leonro.local>
 <09d8f6bc-5994-82d1-9a0f-59540b6c525f@synopsys.com>
 <fbb4b7cb-e3e4-b540-22e4-5d920857e8fe@synopsys.com>
 <52727D4A-F647-4924-8DF0-4D7F248626AA@mellanox.com>
 <7a4e8dce-f1af-d664-bb0b-062f84b45b60@synopsys.com>
 <E798E910-E897-4C14-9161-BE1220D412DF@mellanox.com>
 <455d9539-8284-7e8d-fe8b-17035b511e9d@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <455d9539-8284-7e8d-fe8b-17035b511e9d-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

I am trying to bring up a Connect-X 5 Ex and I am getting an issue when
executing opensm when the infiniband cables are connected (connected from one
port to the other). Could you please give me an hint of what might be hapenning?

# ibstat
CA 'mlx5_0'
        CA type: MT4119
        Number of ports: 1
        Firmware version: 16.19.2244
        Hardware version: 0
        Node GUID: 0x248a0703009ad906
        System image GUID: 0x248a0703009ad906
        Port 1:
                State: Initializing
                Physical state: LinkUp
                Rate: 56
                Base lid: 65535
                LMC: 0
                SM lid: 0
                Capability mask: 0x2651e848
                Port GUID: 0x248a0703009ad906
                Link layer: InfiniBand
CA 'mlx5_1'
        CA type: MT4119
        Number of ports: 1
        Firmware version: 16.19.2244
        Hardware version: 0
        Node GUID: 0x248a0703009ad907
        System image GUID: 0x248a0703009ad906
        Port 1:
                State: Initializing
                Physical state: LinkUp
                Rate: 56
                Base lid: 65535
                LMC: 0
                SM lid: 0
                Capability mask: 0x2651e848
                Port GUID: 0x248a0703009ad907
                Link layer: InfiniBand
#
#
# which opensm
/usr/sbin/opensm
# opensm -g 0x248a0703009ad906 &
# -------------------------------------------------
OpenSM 3.3.20
Command Line Arguments:
 Guid <0x248a0703009ad906>
 Log File: /var/log/opensm.log
-------------------------------------------------
OpenSM 3.3.20

Entering DISCOVERING state

------------[ cut here ]------------
WARNING: CPU: 0 PID: 128 at drivers/infiniband/hw/mlx5/mad.c:263
mlx5_ib_process_mad+0x1a6/0x64c
Modules linked in:
CPU: 0 PID: 128 Comm: kworker/0:1H Not tainted
4.12.0-MLNX20170524-ge176cc5-dirty #22
Workqueue: ib-comp-wq ib_cq_poll_work

Stack Trace:
  arc_unwind_core.constprop.2+0xb4/0x100
  warn_slowpath_null+0x48/0xe4
  mlx5_ib_process_mad+0x1a6/0x64c
  ib_mad_recv_done+0x352/0xa7c
  ib_cq_poll_work+0x72/0x130
  process_one_work+0x1c8/0x390
  worker_thread+0x120/0x540
  kthread+0x116/0x13c
  ret_from_fork+0x18/0x1c
---[ end trace 942bc9d60690df3b ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 128 at mm/page_alloc.c:3689
__alloc_pages_nodemask+0x18ec/0x24e4
Modules linked in:
CPU: 0 PID: 128 Comm: kworker/0:1H Tainted: G        W
4.12.0-MLNX20170524-ge176cc5-dirty #22
Workqueue: ib-comp-wq ib_cq_poll_work

Stack Trace:
  arc_unwind_core.constprop.2+0xb4/0x100
  warn_slowpath_null+0x48/0xe4
  __alloc_pages_nodemask+0x18ec/0x24e4
  kmalloc_order+0x16/0x28
  alloc_mad_private+0x12/0x20
  ib_mad_recv_done+0x2bc/0xa7c
  ib_cq_poll_work+0x72/0x130
  process_one_work+0x1c8/0x390
  worker_thread+0x120/0x540
  kthread+0x116/0x13c
  ret_from_fork+0x18/0x1c
---[ end trace 942bc9d60690df3c ]---
BUG: Bad rss-counter state mm:9672c000 idx:1 val:11
BUG: Bad rss-counter state mm:9672c000 idx:3 val:84
BUG: non-zero nr_ptes on freeing mm: 3
Path: /bin/busybox
CPU: 0 PID: 82 Comm: klogd Tainted: G        W
4.12.0-MLNX20170524-ge176cc5-dirty #22
task: 8fe0e3c0 task.stack: 8fe02000

[ECR   ]: 0x00220100 => Invalid Read @ 0x00008088 by insn @ 0x8124babc
[EFA   ]: 0x00008088
[BLINK ]: __d_alloc+0x2c/0x1cc
[ERET  ]: kmem_cache_alloc+0x4c/0xe8
------------[ cut here ]------------
WARNING: CPU: 0 PID: 128 at kernel/workqueue.c:1080 worker_thread+0x120/0x540
Modules linked in:
CPU: 0 PID: 128 Comm: kworker/0:1H Tainted: G        W
4.12.0-MLNX20170524-ge176cc5-dirty #22
------------[ cut here ]------------
WARNING: CPU: 0 PID: 128 at kernel/workqueue.c:1436 __queue_work+0x3e2/0x3e8
workqueue: per-cpu pwq for ib-comp-wq on cpu0 has 0 refcnt
Modules linked in:
CPU: 0 PID: 128 Comm: kworker/0:1H Tainted: G        W
4.12.0-MLNX20170524-ge176cc5-dirty #22

Stack Trace:
  arc_unwind_core.constprop.2+0xb4/0x100
  warn_slowpath_fmt+0x6c/0x110
  __queue_work+0x3e2/0x3e8
  queue_work_on+0x40/0x48
  mlx5_cq_completion+0x62/0xd8
  mlx5_eq_int+0x2dc/0x3a8
  __handle_irq_event_percpu+0xb8/0x150
  handle_irq_event+0x44/0x8c
  handle_simple_irq+0x5c/0xa4
  generic_handle_irq+0x1c/0x2c
  dw_handle_msi_irq+0x5a/0xd4
  dw_chained_msi_isr+0x26/0x78
  generic_handle_irq+0x1c/0x2c
  dw_apb_ictl_handler+0x7e/0xf8
  __handle_domain_irq+0x56/0x98
  handle_interrupt_level1+0xcc/0xd8
---[ end trace 942bc9d60690df3d ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 128 at kernel/workqueue.c:1064 __queue_work+0x31c/0x3e8
Modules linked in:
CPU: 0 PID: 128 Comm: kworker/0:1H Tainted: G        W
4.12.0-MLNX20170524-ge176cc5-dirty #22

Stack Trace:
  arc_unwind_core.constprop.2+0xb4/0x100
  warn_slowpath_null+0x48/0xe4
  __queue_work+0x31c/0x3e8
  queue_work_on+0x40/0x48
  mlx5_cq_completion+0x62/0xd8
  mlx5_eq_int+0x2dc/0x3a8
  __handle_irq_event_percpu+0xb8/0x150
  handle_irq_event+0x44/0x8c
  handle_simple_irq+0x5c/0xa4
  generic_handle_irq+0x1c/0x2c
  dw_handle_msi_irq+0x5a/0xd4
  dw_chained_msi_isr+0x26/0x78
  generic_handle_irq+0x1c/0x2c
  dw_apb_ictl_handler+0x7e/0xf8
  __handle_domain_irq+0x56/0x98
  handle_interrupt_level1+0xcc/0xd8
---[ end trace 942bc9d60690df3e ]---

Stack Trace:
  arc_unwind_core.constprop.2+0xb4/0x100
  warn_slowpath_null+0x48/0xe4
  worker_thread+0x120/0x540
  kthread+0x116/0x13c
  ret_from_fork+0x18/0x1c
---[ end trace 942bc9d60690df3f ]---
[STAT32]: 0x00000406 : K         E2 E1
BTA: 0x8124ba86  SP: 0x8fe03dec  FP: 0x00000000
LPS: 0x81274348 LPE: 0x81274354 LPC: 0x00000000
r00: 0x00008088 r01: 0x014000c0 r02: 0x00008088
r03: 0x00001b1a r04: 0x00000000 r05: 0x00000806
r06: 0x9a19cea0 r07: 0x00000005 r08: 0x00000054
r09: 0x00000000 r10: 0x00000000 r11: 0x2000a038
r12: 0x00000000

Stack Trace:
  kmem_cache_alloc+0x4c/0xe8
  __d_alloc+0x2c/0x1cc
  d_alloc_parallel+0x46/0x3f8
  path_openat+0xd48/0x132c
  do_filp_open+0x44/0xc0
  SyS_openat+0x144/0x1d4
  EV_Trap+0x11c/0x120


Thank you and best regards,

Joao Pinto

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
