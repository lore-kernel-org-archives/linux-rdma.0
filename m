From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Kernel panic under 3.2.14 Xen dom0 and SCST trunk
Date: Wed, 25 Jul 2012 01:16:14 +1000
Message-ID: <CAOzFzEjjbofQZyubdpH10WKeoE3-grMVdEOqJhJtbRtMdgCr=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi guys,

I have been seeing this KP occur about every 3 days on our staging cluster.
I am not exactly sure what the root cause would be.. I assume this
would be a bug in SCST.
The kernel is a 3.2.14 with Ubuntu patch series applied and Bart's SRP
HA patches.

The SRP connection settings are actually default at this stage we are
only using the added ability to delete srp connections without unload.

[35404.804901] IP: [<          (null)>]           (null)
[35404.804981] PGD 2ab2b067 PUD 75f5b067 PMD 0
[35404.805064] Oops: 0010 [#1] SMP
[35404.805140] CPU 0
[35404.805149] Modules linked in: tun xen_netback xen_blkback
dm_round_robin ib_srpt(O) scst_vdisk(O) scst(O) bonding dm_multipath
flashcache(O) raid0 raid1 md_mod
[35404.805463]
[35404.805528] Pid: 4585, comm: srpt_mlx4_0-2 Tainted: G           O
3.2.14+ #2 Dell                   PowerEdge C2100       /0P19C9
[35404.805690] RIP: e030:[<0000000000000000>]  [<          (null)>]
       (null)
[35404.805832] RSP: e02b:ffff8800bf42ace0  EFLAGS: 00010046
[35404.805910] RAX: ffff88001ac800c0 RBX: ffff88001ac0c4d0 RCX: ffff88001ac0d600
[35404.805994] RDX: ffff88001ac0dc30 RSI: ffff88001ac800c0 RDI: ffff88001654e900
[35404.806078] RBP: ffff8800bf42adb8 R08: ffff88001654e900 R09: ffff88001ac0d608
[35404.806162] R10: 0000000000000001 R11: ffff88001ac0d5f8 R12: ffff88009c443940
[35404.806263] R13: ffff88001b1a2000 R14: 00000000000004c8 R15: ffff88001ac0c4d0
[35404.806350] FS:  00007f2701406700(0000) GS:ffff8800bf427000(0000)
knlGS:0000000000000000
[35404.806492] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[35404.806571] CR2: 0000000000000000 CR3: 00000000830e0000 CR4: 0000000000002660
[35404.806655] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[35404.806740] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[35404.806825] Process srpt_mlx4_0-2 (pid: 4585, threadinfo
ffff8800b50f4000, task ffff880017faeea0)
[35404.806969] Stack:
[35404.807034]  ffffffff8150285e 0000000000000000 ffff88001ac0c998
ffff880000000001
[35404.807183]  ffff88001ac0d608 ffff88001654e900 ffff88001ac0e3f0
ffff88001ac0e3b8
[35404.807332]  ffff88001ac0c528 ffff880068a11600 ffff88001ac0c4e0
ffff88001ac0c4f0
[35404.807480] Call Trace:
[35404.807548]  <IRQ>
[35404.807637]  [<ffffffff8150285e>] ? srp_recv_completion+0x44e/0x650
[35404.807722]  [<ffffffff81009f52>] ? check_events+0x12/0x20
[35404.807803]  [<ffffffff814ea3c2>] mlx4_ib_cq_comp+0x12/0x20
[35404.807883]  [<ffffffff81433beb>] mlx4_cq_completion+0x3b/0x80
[35404.807964]  [<ffffffff81434aa4>] mlx4_eq_int+0x224/0x290
[35404.808043]  [<ffffffff81434b81>] mlx4_interrupt+0x51/0x80
[35404.808125]  [<ffffffff810b72bd>] handle_irq_event_percpu+0x5d/0x210
[35404.808208]  [<ffffffff810b74bc>] handle_irq_event+0x4c/0x80
[35404.808289]  [<ffffffff810ba233>] handle_fasteoi_irq+0x83/0x140
[35404.808371]  [<ffffffff8130f756>] __xen_evtchn_do_upcall+0x1a6/0x260
[35404.808455]  [<ffffffff813114fa>] xen_evtchn_do_upcall+0x2a/0x40
[35404.808538]  [<ffffffff816846fe>] xen_do_hypervisor_callback+0x1e/0x30
[35404.808620]  <EOI>
[35404.808691]  [<ffffffffa006b0e7>] ?
scst_register_virtual_device+0x5d7/0x750 [scst]
[35404.808833]  [<ffffffffa007a473>] ? scst_cmd_init_done+0xb3/0x5a0 [scst]
[35404.808917]  [<ffffffffa00f0bed>] ? 0xffffffffa00f0bec
[35404.809006]  [<ffffffffa0072a47>] ? scst_rx_cmd+0xe7/0xce0 [scst]
[35404.809088]  [<ffffffffa00f2872>] ? 0xffffffffa00f2871
[35404.809166]  [<ffffffffa00f08e3>] ? 0xffffffffa00f08e2
[35404.809245]  [<ffffffffa00f797f>] ? 0xffffffffa00f797e
[35404.810244]  [<ffffffffa00f081f>] ? 0xffffffffa00f081e
[35404.810323]  [<ffffffffa00f7af0>] ? 0xffffffffa00f7aef
[35404.810417]  [<ffffffffa00f873f>] ? 0xffffffffa00f873e
[35404.810495]  [<ffffffffa00f87a0>] ? 0xffffffffa00f879f
[35404.810573]  [<ffffffffa00f8880>] ? 0xffffffffa00f887f
[35404.810655]  [<ffffffff8167a8d9>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[35404.810739]  [<ffffffffa00f87a0>] ? 0xffffffffa00f879f
[35404.810818]  [<ffffffff81077246>] ? kthread+0x96/0xa0
[35404.810896]  [<ffffffff816845b4>] ? kernel_thread_helper+0x4/0x10
[35404.810979]  [<ffffffff81682673>] ? int_ret_from_sys_call+0x7/0x1b
[35404.811061]  [<ffffffff8167ab7c>] ? retint_restore_args+0x5/0x6
[35404.811142]  [<ffffffff816845b0>] ? gs_change+0x13/0x13
[35404.811219] Code:  Bad RIP value.
[35404.811297] RIP  [<          (null)>]           (null)
[35404.811377]  RSP <ffff8800bf42ace0>
[35404.811447] CR2: 0000000000000000
[35404.811739] ---[ end trace a002a9122b31526a ]---
[35404.811841] Kernel panic - not syncing: Fatal exception in interrupt
[35404.811950] Pid: 4585, comm: srpt_mlx4_0-2 Tainted: G      D    O 3.2.14+ #2
[35404.812061] Call Trace:
[35404.812155]  <IRQ>  [<ffffffff81677b48>] panic+0x8c/0x19d
[35404.812296]  [<ffffffff81009f52>] ? check_events+0x12/0x20
[35404.812402]  [<ffffffff8167b7fa>] oops_end+0xea/0xf0
[35404.812510]  [<ffffffff8103b5f2>] no_context+0xf2/0x270
[35404.812616]  [<ffffffff8103b895>] __bad_area_nosemaphore+0x125/0x210
[35404.812726]  [<ffffffff8103b98e>] bad_area_nosemaphore+0xe/0x10
[35404.812835]  [<ffffffff8167e135>] do_page_fault+0x335/0x4d0
[35404.812942]  [<ffffffff8100984d>] ? xen_force_evtchn_callback+0xd/0x10
[35404.813052]  [<ffffffff81009f52>] ? check_events+0x12/0x20
[35404.813174]  [<ffffffff8167adf5>] page_fault+0x25/0x30
[35404.813280]  [<ffffffff8150285e>] ? srp_recv_completion+0x44e/0x650
[35404.813390]  [<ffffffff81009f52>] ? check_events+0x12/0x20
[35404.813496]  [<ffffffff814ea3c2>] mlx4_ib_cq_comp+0x12/0x20
[35404.813603]  [<ffffffff81433beb>] mlx4_cq_completion+0x3b/0x80
[35404.813711]  [<ffffffff81434aa4>] mlx4_eq_int+0x224/0x290
[35404.813817]  [<ffffffff81434b81>] mlx4_interrupt+0x51/0x80
[35404.813924]  [<ffffffff810b72bd>] handle_irq_event_percpu+0x5d/0x210
[35404.814034]  [<ffffffff810b74bc>] handle_irq_event+0x4c/0x80
[35404.814141]  [<ffffffff810ba233>] handle_fasteoi_irq+0x83/0x140
[35404.814250]  [<ffffffff8130f756>] __xen_evtchn_do_upcall+0x1a6/0x260
[35404.814360]  [<ffffffff813114fa>] xen_evtchn_do_upcall+0x2a/0x40
[35404.814469]  [<ffffffff816846fe>] xen_do_hypervisor_callback+0x1e/0x30
[35404.814600]  <EOI>  [<ffffffffa006b0e7>] ?
scst_register_virtual_device+0x5d7/0x750 [scst]
[35404.814806]  [<ffffffffa007a473>] ? scst_cmd_init_done+0xb3/0x5a0 [scst]
[35404.814916]  [<ffffffffa00f0bed>] ? 0xffffffffa00f0bec
[35404.815022]  [<ffffffffa0072a47>] ? scst_rx_cmd+0xe7/0xce0 [scst]
[35404.815131]  [<ffffffffa00f2872>] ? 0xffffffffa00f2871
[35404.815236]  [<ffffffffa00f08e3>] ? 0xffffffffa00f08e2
[35404.815341]  [<ffffffffa00f797f>] ? 0xffffffffa00f797e
[35404.815447]  [<ffffffffa00f081f>] ? 0xffffffffa00f081e
[35404.815551]  [<ffffffffa00f7af0>] ? 0xffffffffa00f7aef
[35404.815656]  [<ffffffffa00f873f>] ? 0xffffffffa00f873e
[35404.815761]  [<ffffffffa00f87a0>] ? 0xffffffffa00f879f
[35404.815869]  [<ffffffffa00f8880>] ? 0xffffffffa00f887f
[35404.815985]  [<ffffffff8167a8d9>] ? _raw_spin_unlock_irqrestore+0x19/0x20
[35404.816096]  [<ffffffffa00f87a0>] ? 0xffffffffa00f879f
[35404.816201]  [<ffffffff81077246>] ? kthread+0x96/0xa0
[35404.816306]  [<ffffffff816845b4>] ? kernel_thread_helper+0x4/0x10
[35404.816414]  [<ffffffff81682673>] ? int_ret_from_sys_call+0x7/0x1b
[35404.816523]  [<ffffffff8167ab7c>] ? retint_restore_args+0x5/0x6
[35404.816631]  [<ffffffff816845b0>] ? gs_change+0x13/0x13

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
