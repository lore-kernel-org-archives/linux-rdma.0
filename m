From: Mohammed Naser <mnaser-0fRLFNSEtVVWk0Htik3J/w@public.gmane.org>
Subject: iSER + CentOS 5.7 + Xen lockup
Date: Mon, 7 Nov 2011 20:14:57 -0500
Message-ID: <CAEs876g0rRBzZN59ZWZ4AQTauVbip82BYAXVNOzahojODfO3Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello everyone,

We had this server crash a couple of times because of (what seems to
me) some iSER problems.  This node runs all the default drivers that
ship with CentOS 5.7

BUG: soft lockup - CPU#0 stuck for 60s! [blkback.4.hda:12797]
CPU 0:
Modules linked in: fuse sch_tbf xt_multiport tun xt_state ip_conntrack
nfnetlink xt_physdev arptable_filter arp_tables ip6table_filter
ip6_tables iptable_filter ip_tables x_tables be2iscsi ib_iser rdma_cm
iw_cm ib_addr iscsi_tcp bnx2i cnic cxgb3i bridge netloop netbk blktap
blkbk nfs nfs_acl lockd sunrpc uio libcxgbi cxgb3 8021q libiscsi_tcp
libiscsi2 scsi_transport_iscsi2 scsi_transport_iscsi dm_round_robin
dm_multipath scsi_dh video backlight sbs power_meter hwmon i2c_ec
dell_wmi wmi button battery asus_acpi ac parport_pc lp parport loop
ib_ipoib ipoib_helper ib_cm ib_sa ipv6 xfrm_nalgo crypto_api sg
ib_mthca ib_mad i2c_i801 ib_core i2c_core tpm_tis tpm shpchp serio_raw
e1000e tpm_bios serial_core pcspkr dm_raid45 dm_message dm_region_hash
dm_mem_cache dm_snapshot dm_zero dm_mirror dm_log dm_mod usb_storage
ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 12797, comm: blkback.4.hda Not tainted 2.6.18-274.7.1.el5xen #1
RIP: e030:[<ffffffff80263a5d>]  [<ffffffff80263a5d>]
.text.lock.spinlock+0x2/0x30
RSP: e02b:ffffffff80797e48  EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff88007a40fa90 RCX: 0000000000000000
RDX: ffff8800756fa14c RSI: ffff8800756fa11c RDI: ffff880078cb4d40
RBP: ffff88007a346110 R08: 00000000004b3afa R09: 0000000000080800
R10: 0000000000000300 R11: 0000000000000002 R12: 0000000000000000
R13: ffff8800756fa14c R14: ffff8800756fa11c R15: 000000000000004c
FS:  00002ab9cb58d890(0000) GS:ffffffff80630000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000

Call Trace:
 <IRQ>  [<ffffffff882858a7>] :ib_mthca:mthca_eq_int+0x7c/0x3b3
 [<ffffffff884a31ad>] :libiscsi2:iscsi2_complete_pdu+0x27/0x52
 [<ffffffff803b72dd>] unmask_evtchn+0x2d/0xd9
 [<ffffffff885a3dc8>] :ib_iser:iscsi_iser_recv+0x45/0x5d
 [<ffffffff885a22f7>] :ib_iser:iser_rcv_completion+0xbf/0x165
 [<ffffffff885a1695>] :ib_iser:iser_cq_tasklet_fn+0x5c/0x126
 [<ffffffff802941ff>] run_timer_softirq+0x233/0x242
 [<ffffffff8029130a>] tasklet_action+0x97/0x13b
 [<ffffffff80212f28>] __do_softirq+0x8d/0x13b
 [<ffffffff8025fda4>] call_softirq+0x1c/0x278
 [<ffffffff8026db69>] do_softirq+0x31/0x90
 [<ffffffff8025f8d6>] do_hypervisor_callback+0x1e/0x2c
 <EOI>  [<ffffffff8020622a>] hypercall_page+0x22a/0x1000
 [<ffffffff8020622a>] hypercall_page+0x22a/0x1000
 [<ffffffff8036253a>] vgacon_cursor+0x0/0x1a5
 [<ffffffff803b6f22>] force_evtchn_callback+0xa/0xb
 [<ffffffff80274512>] smp_send_stop+0x63/0x98
 [<ffffffff8028d97b>] panic+0x94/0x1db
 [<ffffffff8023f4ed>] lock_timer_base+0x1b/0x3c
 [<ffffffff8021d34f>] __mod_timer+0xff/0x10e
 [<ffffffff80362b8b>] vgacon_blank+0x1af/0x587
 [<ffffffff80263909>] _spin_lock_irqsave+0x9/0x14
 [<ffffffff803624a2>] vgacon_set_cursor_size+0x36/0xce
 [<ffffffff802640fc>] oops_end+0x5e/0x60
 [<ffffffff8026700f>] do_page_fault+0x120d/0x131b
 [<ffffffff8811d179>] :dm_mod:__split_bio+0x39f/0x3b7
 [<ffffffff80263909>] _spin_lock_irqsave+0x9/0x14
 [<ffffffff8025f82b>] error_exit+0x0/0x6e
 [<ffffffff885a2f14>] :ib_iser:iser_reg_rdma_mem+0x115/0x762
 [<ffffffff885a2a1d>] :ib_iser:iser_send_command+0x1ea/0x304
 [<ffffffff885a37ce>] :ib_iser:iscsi_iser_task_xmit+0xcf/0x18b
 [<ffffffff884a409d>] :libiscsi2:iscsi2_queuecommand+0x258/0x3ef
 [<ffffffff880756b7>] :scsi_mod:scsi_done+0x0/0x18
 [<ffffffff8021d34f>] __mod_timer+0xff/0x10e
 [<ffffffff88075db2>] :scsi_mod:scsi_dispatch_cmd+0x2ac/0x366
 [<ffffffff8807b329>] :scsi_mod:scsi_request_fn+0x2c7/0x39e
 [<ffffffff8025c892>] generic_unplug_device+0x22/0x37
 [<ffffffff8811ec98>] :dm_mod:dm_table_unplug_all+0x3f/0x83
 [<ffffffff8811cd98>] :dm_mod:dm_unplug_all+0x1d/0x28
 [<ffffffff8811ec98>] :dm_mod:dm_table_unplug_all+0x3f/0x83
 [<ffffffff8020622a>] hypercall_page+0x22a/0x1000
 [<ffffffff8811cd98>] :dm_mod:dm_unplug_all+0x1d/0x28
 [<ffffffff8866b407>] :blkbk:unplug_queue+0x1e/0x37
 [<ffffffff8866bd88>] :blkbk:blkif_schedule+0x3b4/0x478
 [<ffffffff8866b9d4>] :blkbk:blkif_schedule+0x0/0x478
 [<ffffffff8029d502>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8023398b>] kthread+0xfe/0x132
 [<ffffffff8025fb2c>] child_rip+0xa/0x12
 [<ffffffff8029d502>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8023388d>] kthread+0x0/0x132
 [<ffffffff8025fb22>] child_rip+0x0/0x12

We hope someone can help us find the root of this issue.

Thanks!

--
Mohammed Naser
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
