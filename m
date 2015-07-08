From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Mlx4: BUG: unable to handle kernel at ffffffffa02be210
Date: Wed, 8 Jul 2015 15:19:46 +0300
Message-ID: <559D1562.2070309@mellanox.com>
References: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2015 12:42 PM, Jack Wang wrote:

> We're using MLX OFED 2.4-1.0.4 together on top of 3.18.14.

So this list is for upstream things.. still, let's see


> We hit bug below spontaneously, our test trigger this bug around 1 in 5 times.

and what is your test if I may ask?!


> HCA 'mlx4_0'
> CA type: MT26428
> Number of ports: 2
> Firmware version: 2.9.1000
> Hardware version: b0
>
> Could you offer some insight, could this be a old bug already fixed,
> if so, could you point me the link, I can port to our kernel. thanks.
>
> [  657.723842] BUG: unable to handle kernel  at ffffffffa02be210
> [  657.724245] IP: [<ffffffffa02be210>] 0xffffffffa02be210
> [  657.724539] PGD 1c15067
> [  657.725162] Oops: 0010 [#1]
> [  657.725657] Modules linked in: ib_ipoib ib_uverbs ib_umad mlx4_ib
> rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr ipv6 null_blk loop
> amd64_edac_mod k10temp fam15h_power edac
> _core button microcode hid_generic usbhid hid igb hwmon i2c_algo_bit
> i2c_core dca ahci ptp libahci ohci_pci pps_core mlx4_core ohci_hcd
> libata [last unloaded: ibtrs_server]
> [  657.731897] CPU: 0 PID: 337 Comm: kworker/u128:1 Tainted: G
>    O   3.18.14-1-ibnbd-debug #1
> [  657.732049] Hardware name: Supermicro BHQGE/BHQGE, BIOS 3.00       10/24/2012
> [  657.732199] Workqueue: ib_mad1 ib_mad_complete_send_wr [ib_mad]
> [  657.732464] task: ffff880415bea1f0 ti: ffff880415420000 task.ti: ffff880415420000
> [  657.732610] RIP: 0010:[<ffffffffa02be210>]  [<ffffffffa02be210>] 0xffffffffa02be210
> [  657.732959] RSP: 0018:ffff880417c03d00  EFLAGS: 00010006
> [  657.733193] RAX: ffff8803bc5fc4d8 RBX: ffff8803bc5fc4d8 RCX: 0000000000000000
> [  657.733416] RDX: ffff880415bea9e0 RSI: ffff8803d8dcd388 RDI: ffff8803bc5fc4a8
> [  657.736094] RBP: ffff880417c03d08 R08: 0000000000000000 R09: ffff880415bea9b8
> [  657.736317] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800d3b00000
> [  657.736543] R13: 00000000000000c5 R14: 0000000000000000 R15: 0000000000000020
> [  657.736800] FS:  00007f2f05b5f700(0000) GS:ffff880417c00000(0000) knlGS:0000000000000000
> [  657.737109] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  657.737330] CR2: ffffffffa02be210 CR3: 000000180d76f000 CR4: 00000000000407f0
> [  657.737555] Stack:
> [  657.737758]  ffffffffa01d84b7 ffff880417c03d48 ffffffffa004a486 ffffffffa004a3f5
> [  657.738546]  ffffffff81c194e0 0000000000000000 00000000c5000000 ffff8804136001c0
> [  657.739360]  ffff8800d3b00000 ffff880417c03e18 ffffffffa004c0ea 0000000000000002
> [  657.740149] Call Trace:
> [  657.740385]  <IRQ>
> [  657.740514]  [<ffffffffa01d84b7>] ? mlx4_ib_destroy_ah+0x37/0x360 [mlx4_ib]
> [  657.741093]  [<ffffffffa004a486>] mlx4_cq_completion+0x96/0xe0 [mlx4_core]
> [  657.741330]  [<ffffffffa004a3f5>] ? mlx4_cq_completion+0x5/0xe0 [mlx4_core]
> [  657.741594]  [<ffffffffa004c0ea>] mlx4_test_interrupts+0x84a/0x1100
> [mlx4_core]

mlx4_test_interrupts is called from the mlx4_en ethtool selftest handler, so you are
calling it while X (what?) is done in parallel?




> [  657.741908]  [<ffffffff8109f37a>] ? __lock_acquire.isra.28+0x3aa/0xcb0
> [  657.742142]  [<ffffffffa004c904>]
> mlx4_test_interrupts+0x1064/0x1100 [mlx4_core]
> [  657.742457]  [<ffffffff810aa678>] handle_irq_event_percpu+0x78/0x2b0
> [  657.742685]  [<ffffffff810aa8f8>] handle_irq_event+0x48/0x70
> [  657.742934]  [<ffffffff810adf58>] handle_edge_irq+0xc8/0x160
> [  657.743160]  [<ffffffff8100515e>] handle_irq+0x14e/0x200
> [  657.743384]  [<ffffffff815fea3e>] do_IRQ+0x5e/0x110
> [  657.743603]  [<ffffffff815fcf6a>] common_interrupt+0x6a/0x6a
> [  657.743826]  <EOI>
> [  657.743957]  [<ffffffff81197295>] ? __slab_alloc+0x615/0x710
> [  657.744513]  [<ffffffffa01d80de>] ? mlx4_ib_create_ah+0x2e/0x2a0 [mlx4_ib]
> [  657.744738]  [<ffffffffa0195603>] ? ib_create_send_mad+0xf3/0x330 [ib_mad]
> [  657.744968]  [<ffffffff81198f12>] __kmalloc+0x162/0x2e0
> [  657.745191]  [<ffffffffa0195603>] ? ib_create_send_mad+0xf3/0x330 [ib_mad]
> [  657.745420]  [<ffffffffa01d8100>] ? mlx4_ib_create_ah+0x50/0x2a0 [mlx4_ib]
> [  657.745650]  [<ffffffffa0195603>] ib_create_send_mad+0xf3/0x330 [ib_mad]
> [  657.745875]  [<ffffffffa019985b>] agent_send_response+0xbb/0x270 [ib_mad]
> [  657.746103]  [<ffffffffa0198bf4>] ?
> ib_mad_complete_send_wr+0x844/0xfa0 [ib_mad]
> [  657.746413]  [<ffffffffa0198f96>]
> ib_mad_complete_send_wr+0xbe6/0xfa0 [ib_mad]
> [  657.746729]  [<ffffffff8109f37a>] ? __lock_acquire.isra.28+0x3aa/0xcb0
> [  657.746959]  [<ffffffff8106c82d>] process_one_work+0x33d/0x6d0
> [  657.747181]  [<ffffffff8106c7a4>] ? process_one_work+0x2b4/0x6d0
> [  657.747434]  [<ffffffff8106d015>] worker_thread+0x55/0x6d0
> [  657.751224]  [<ffffffff8106cfc0>] ? rescuer_thread+0x3c0/0x3c0
> [  657.751482]  [<ffffffff81073e84>] kthread+0xe4/0x100
> [  657.751705]  [<ffffffff810792b4>] ? finish_task_switch+0x84/0x140
> [  657.751935]  [<ffffffff81073da0>] ? kthread_create_on_node+0x280/0x280
> [  657.752165]  [<ffffffff815fc3c8>] ret_from_fork+0x58/0x90
> [  657.752391]  [<ffffffff81073da0>] ? kthread_create_on_node+0x280/0x280
> [  657.752640] Code:  Bad RIP value.
> [  657.753095] RIP  [<ffffffffa02be210>] 0xffffffffa02be210
> [  657.753434]  RSP <ffff880417c03d00>
> [  657.753645] CR2: ffffffffa02be210
> [  657.753878] ---[ end trace 9c9225f5e490f806 ]---
> [  657.765754] Kernel panic - not syncing: Fatal exception in interrupt
> [  657.766089] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
> range: 0xffffffff80000000-0xffffffff9fffffff)
> [  657.778084] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
>
> Best regards,
> Jack Wang

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
