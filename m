From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Tue, 1 Nov 2016 11:20:15 -0500
Message-ID: <01cc01d2345b$d445acd0$7cd10670$@opengridcomputing.com>
References: <01b401d23458$af277210$0d765630$@opengridcomputing.com> <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6f42d056-284d-00fc-2b98-189f54957980-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > I just hit an nvmf target NULL pointer deref BUG after a few hours of
keep-alive
> > timeout testing.  It appears that nvmet_rdma_cm_handler() was called with
> > cm_id->qp == NULL, so the local nvmet_rdma_queue * variable queue is left as
> > NULL.  But then nvmet_rdma_queue_disconnect() is called with queue == NULL
> which
> > causes the crash.
> 
> AFAICT, the only way cm_id->qp is NULL is for a scenario we didn't even
> get to allocate a queue-pair (e.g. calling rdma_create_qp). The teardown
> paths does not nullify cm_id->qp...

rdma_destroy_qp() nulls out cm_id->qp.

> 
> Are you sure that the flow is indeed DISCONNECTED event?
>

That is the only event I would expect during this test.  From
nvmet_rdma_cm_handler():

        case RDMA_CM_EVENT_ADDR_CHANGE:
        case RDMA_CM_EVENT_DISCONNECTED:
        case RDMA_CM_EVENT_TIMEWAIT_EXIT:
                nvmet_rdma_queue_disconnect(queue);
                break;

 
> > In the log, I see that the target side keep-alive fired:
> >
> > [20676.867545] eth2: link up, 40Gbps, full-duplex, Tx/Rx PAUSE
> > [20677.079669] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!
> > [20677.079684] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!
> 
> Wow, two keep-alive timeouts on the same controller? that is
> seriously wrong...
> 
> 
> > [20677.088402] nvmet_rdma: freeing queue 276
> > [20677.090981] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000120
> > [20677.090988] IP: [<ffffffffa084b6b4>]
> nvmet_rdma_queue_disconnect+0x24/0x90
> > [nvmet_rdma]
> 
> No stack trace?
> 

Sure:

[20677.090992] Oops: 0000 [#1] SMP
[20677.091030] Modules linked in: iw_cxgb4(OE) cxgb4(OE) null_blk brd nvmet_rdma
nvmet ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM
iptable_mangle iptable_filter ip_tables bridge 8021q mrp garp stp llc
ipmi_devintf cachefiles fscache rdma_ucm rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs
ib_umad ocrdma be2net iw_nes libcrc32c iw_cxgb3 cxgb3 mdio ib_qib rdmavt mlx5_ib
mlx5_core mlx4_ib mlx4_en mlx4_core ib_mthca ib_core binfmt_misc dm_mirror
dm_region_hash dm_log vhost_net macvtap macvlan vhost tun kvm irqbypass uinput
iTCO_wdt iTCO_vendor_support mxm_wmi pcspkr dm_mod i2c_i801 i2c_smbus sg ipmi_si
ipmi_msghandler nvme nvme_core lpc_ich mfd_core
[20677.091040]  mei_me mei igb dca ptp pps_core wmi ext4(E) mbcache(E) jbd2(E)
sd_mod(E) ahci(E) libahci(E) libata(E) mgag200(E) ttm(E) drm_kms_helper(E)
drm(E) fb_sys_fops(E) sysimgblt(E) sysfillrect(E) syscopyarea(E) i2c_algo_bit(E)
i2c_core(E) [last unloaded: cxgb4]
[20677.091043] CPU: 10 PID: 24331 Comm: kworker/u64:1 Tainted: G           OE
4.8.0 #130
[20677.091044] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
[20677.091049] Workqueue: iw_cm_wq cm_work_handler [iw_cm]
[20677.091050] task: ffff88102fa4ab80 task.stack: ffff880f111d8000
[20677.091053] RIP: 0010:[<ffffffffa084b6b4>]  [<ffffffffa084b6b4>]
nvmet_rdma_queue_disconnect+0x24/0x90 [nvmet_rdma]
[20677.091054] RSP: 0018:ffff880f111db968  EFLAGS: 00010296
[20677.091055] RAX: ffff88102fa4ab80 RBX: 0000000000000000 RCX: 0000000000000000
[20677.091056] RDX: 0000000000000005 RSI: 000000000000000a RDI: ffffffffa084f040
[20677.091056] RBP: ffff880f111db998 R08: ffff88102a30e358 R09: ffff880f111dba78
[20677.091058] R10: 0000000000000c2c R11: 0000000000000001 R12: 0000000000000000
[20677.091059] R13: ffff880805ca2c00 R14: ffff880f111db9e8 R15: ffff880f111dbc48
[20677.091060] FS:  0000000000000000(0000) GS:ffff88105f280000(0000)
knlGS:0000000000000000
[20677.091061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[20677.091062] CR2: 0000000000000120 CR3: 000000105a203000 CR4: 00000000000406e0
[20677.091063] Stack:
[20677.091065]  ffff881053f6c100 0000000000000046 000012ce42a8b7b3
ffff88105bdf7000
[20677.091067]  ffff880f111db9e8 0000000000000000 ffff880f111db9c8
ffffffffa084d484
[20677.091069]  ffff880f111dbb28 ffff880805ca2c00 ffff880805ca2e70
ffff880f111db9e8
[20677.091070] Call Trace:
[20677.091074]  [<ffffffffa084d484>] nvmet_rdma_cm_handler+0x154/0x1a0
[nvmet_rdma]
[20677.091078]  [<ffffffffa0737e90>] cma_iw_handler+0x110/0x1c0 [rdma_cm]
[20677.091084]  [<ffffffff8115575e>] ? ring_buffer_lock_reserve+0x7e/0xc0
[20677.091086]  [<ffffffffa07271b3>] cm_close_handler+0x93/0xc0 [iw_cm]
[20677.091089]  [<ffffffffa0729027>] process_event+0xd7/0xf0 [iw_cm]
[20677.091092]  [<ffffffffa0729170>] cm_work_handler+0x130/0x190 [iw_cm]
[20677.091097]  [<ffffffff8109d196>] ?
trace_event_raw_event_workqueue_execute_start+0x66/0xa0
[20677.091099]  [<ffffffff810a1483>] process_one_work+0x183/0x4d0
[20677.091103]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[20677.091106]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[20677.091108]  [<ffffffff810a211d>] worker_thread+0x16d/0x530
[20677.091110]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[20677.091115]  [<ffffffff810cb9b6>] ? __wake_up_common+0x56/0x90
[20677.091117]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[20677.091119]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[20677.091121]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[20677.091123]  [<ffffffff810a6c5c>] kthread+0xcc/0xf0
[20677.091126]  [<ffffffff810b1aae>] ? schedule_tail+0x1e/0xc0
[20677.091129]  [<ffffffff816e2eff>] ret_from_fork+0x1f/0x40
[20677.091131]  [<ffffffff810a6b90>] ? kthread_freezable_should_stop+0x70/0x70
[20677.091149] Code: 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d f0 4c
89 65 f8 66 66 66 66 90 48 89 fb 48 c7 c7 40 f0 84 a0 e8 1c 55 e9 e0 <48> 8b 83
20 01 00 00 4c 8d a3 20 01 00 00 49 39 c4 48 89 45 e0
[20677.091152] RIP  [<ffffffffa084b6b4>] nvmet_rdma_queue_disconnect+0x24/0x90
[nvmet_rdma]
[20677.091152]  RSP <ffff880f111db968>
[20677.091153] CR2: 0000000000000120

> >
> >
> > So maybe there is just a race in that keep-alive can free the queue and yet
a
> > DISCONNECTED event still received on the cm_id after the queue is freed?
> 
> rdma_destroy_id should barrier this scenario.

I'm guessing the cm_id hasn't been destroyed.  But the qp has...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
