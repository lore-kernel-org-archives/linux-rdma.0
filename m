From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: rxe oops
Date: Fri, 28 Jul 2017 12:10:15 -0600
Message-ID: <20170728181015.GA29390@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Was testing ibacm with rxe loaded and the kernel oops'd after starting
ibacm. This is 4.13-rc2:

[71622.872134] BUG: unable to handle kernel NULL pointer dereference at           (null)
[71622.873509] IP:           (null)
[71622.874046] PGD 22dca8067 
[71622.874047] P4D 22dca8067 
[71622.874493] PUD 22dca7067 
[71622.874947] PMD 0 
[71622.875396] 
[71622.876001] Oops: 0010 [#1] SMP
[71622.876524] Modules linked in: rdma_rxe ib_srp scsi_transport_srp scsi_mod rdma_ucm ib_umad ib_ipoib ib_uverbs mlx4_ib mlx4_core
[71622.878395] CPU: 0 PID: 7 Comm: ksoftirqd/0 Tainted: G        W       4.13.0-rc2+ #3
[71622.879644] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[71622.881125] task: ffff88022ec84b00 task.stack: ffffc9000003c000
[71622.882084] RIP: 0010:          (null)
[71622.882699] RSP: 0018:ffffc9000003fca0 EFLAGS: 00010282
[71622.883554] RAX: ffffffff81a5d84c RBX: ffff880228d3b700 RCX: ffff880228d3b700
[71622.884710] RDX: ffffc9000003fcd8 RSI: ffff880228d3b700 RDI: 81a664c000000000
[71622.885860] RBP: ffffc9000003fcc8 R08: ffff880227a73400 R09: ffff880227a72c3c
[71622.887013] R10: ffffc9000033d338 R11: 0000000000000100 R12: ffffc9000003fcd8
[71622.888167] R13: ffff880228dbfc00 R14: ffff880227820000 R15: ffffc9000033d280
[71622.889318] FS:  0000000000000000(0000) GS:ffff880236e00000(0000) knlGS:0000000000000000
[71622.890626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[71622.891556] CR2: 0000000000000000 CR3: 000000022dca9000 CR4: 00000000000406b0
[71622.892698] Call Trace:
[71622.893109]  ? nf_hook_slow+0x25/0xa0
[71622.893713]  __ip6_local_out+0xa1/0xb0
[71622.894330]  ? inet6_unregister_icmp_sender+0x30/0x30
[71622.895161]  ip6_local_out+0x17/0x40
[71622.895750]  rxe_send+0x76/0x100 [rdma_rxe]
[71622.896435]  rxe_requester+0x9e1/0x11d0 [rdma_rxe]
[71622.897222]  rxe_do_task+0x82/0xf0 [rdma_rxe]
[71622.897938]  tasklet_action+0xa9/0xc0
[71622.898546]  __do_softirq+0xdd/0x1e0
[71622.899132]  run_ksoftirqd+0x24/0x40
[71622.899732]  smpboot_thread_fn+0x105/0x160
[71622.900398]  kthread+0xfe/0x140
[71622.900918]  ? sort_range+0x20/0x20
[71622.901496]  ? kthread_create_on_node+0x40/0x40
[71622.902242]  ret_from_fork+0x25/0x30
[71622.902837] Code:  Bad RIP value.
[71622.903384] RIP:           (null) RSP: ffffc9000003fca0
[71622.904236] CR2: 0000000000000000
[71622.904789] ---[ end trace 7744317ce238bd28 ]---
[71622.905547] Kernel panic - not syncing: Fatal exception in interrupt
[71622.906701] Kernel Offset: disabled
[71622.907272] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
