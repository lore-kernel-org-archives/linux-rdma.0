From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Tue, 1 Nov 2016 14:42:12 -0500
Message-ID: <026401d23478$0ac3a700$204af500$@opengridcomputing.com>
References: <01b401d23458$af277210$0d765630$@opengridcomputing.com> <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me> <01cc01d2345b$d445acd0$7cd10670$@opengridcomputing.com> <4cc25277-429a-4ab9-470c-b3af1428ce93@grimberg.me> <01d101d2345e$2f054390$8d0fcab0$@opengridcomputing.com> <dbe5f18d-7928-f065-920f-753b30fb99a2@grimberg.me> <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com> <1d09c064-1cbe-7e6e-43d2-cfa6cf0c19ea@grimberg.me> <025201d23476$66812290$338367b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <025201d23476$66812290$338367b0$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > But:  I'll try this patch and run for a few hours and see what
happens.  I
> > believe regardless of a keep alive issue, the above patch is still
needed.
> 
> In your tests, can you enable dynamic debug on:
> nvmet_start_keep_alive_timer
> nvmet_stop_keep_alive_timer
> nvmet_execute_keep_alive

Hey Sagi.  I hit another crash on the target.  This was with 4.8.0 + the
patch to skip disconnect events if the cm_id->qp is NULL. This time the
crash is in _raw_spin_lock_irqsave() called by nvmet_rdma_recv_done().
The log is too big to include everything inline, but I'm attaching the
full log as an attachment.  Looks like at around 4988.169 seconds in the
log, we see 5 controllers created, all named "controller 1"!  And 32
queues assigned to controller 1 5 times!  And shortly after that we hit
the BUG.

Snipits:

[ 4988.035500] nvmet_start_keep_alive_timer: nvmet: ctrl 1 start
keep-alive timer for 15 secs
[ 4988.035507] nvmet: creating controller 1 for NQN
nqn.2014-08.org.nvmexpress:NVMf:uuid:0c8e193a-9c77-4e40-adff-07a7b8a352af.
[ 4988.040872] nvmet_start_keep_alive_timer: nvmet: ctrl 1 start
keep-alive timer for 15 secs
[ 4988.040877] nvmet: creating controller 1 for NQN
nqn.2014-08.org.nvmexpress:NVMf:uuid:0c8e193a-9c77-4e40-adff-07a7b8a352af.
[ 4988.044614] nvmet_start_keep_alive_timer: nvmet: ctrl 1 start
keep-alive timer for 15 secs
[ 4988.044619] nvmet: creating controller 1 for NQN
nqn.2014-08.org.nvmexpress:NVMf:uuid:0c8e193a-9c77-4e40-adff-07a7b8a352af.
[ 4988.054419] nvmet_start_keep_alive_timer: nvmet: ctrl 1 start
keep-alive timer for 15 secs
[ 4988.054423] nvmet: creating controller 1 for NQN
nqn.2014-08.org.nvmexpress:NVMf:uuid:0c8e193a-9c77-4e40-adff-07a7b8a352af.
[ 4988.054428] nvmet_start_keep_alive_timer: nvmet: ctrl 1 start
keep-alive timer for 15 secs
[ 4988.054433] nvmet: creating controller 1 for NQN
nqn.2014-08.org.nvmexpress:NVMf:uuid:0c8e193a-9c77-4e40-adff-07a7b8a352af.

Queues assigned to the same controller multiple times:

[ 4988.371465] nvmet: adding queue 1 to ctrl 1.
[ 4988.376144] nvmet: adding queue 2 to ctrl 1.
[ 4988.380790] nvmet: adding queue 3 to ctrl 1.
[ 4988.386110] nvmet: adding queue 1 to ctrl 1.
[ 4988.390751] nvmet: adding queue 2 to ctrl 1.
[ 4988.416056] nvmet: adding queue 4 to ctrl 1.
[ 4988.420658] nvmet: adding queue 3 to ctrl 1.
[ 4988.425257] nvmet: adding queue 1 to ctrl 1.
[ 4988.429841] nvmet: adding queue 1 to ctrl 1.
[ 4988.434402] nvmet: adding queue 5 to ctrl 1.
[ 4988.438957] nvmet: adding queue 4 to ctrl 1.
[ 4988.443497] nvmet: adding queue 2 to ctrl 1.
[ 4988.448041] nvmet: adding queue 2 to ctrl 1.

And the BUG in the middle of all this:

[ 4988.964835] BUG: unable to handle kernel
[ 4988.964877] nvmet: adding queue 32 to ctrl 1.
[ 4988.973233] NULL pointer dereference
[ 4988.977047]  at 00000000000000b8
[ 4988.978932] nvmet: adding queue 1 to ctrl 1.
[ 4988.978977] nvmet: adding queue 2 to ctrl 1.
...
[ 4988.980539] nvmet: adding queue 32 to ctrl 1.
[ 4989.051155] nvmet_start_keep_alive_timer: nvmet: ctrl 1 start
keep-alive timer for 15 secs
[ 4989.051158] nvmet: creating controller 1 for NQN
nqn.2014-08.org.nvmexpress:NVMf:uuid:0c8e193a-9c77-4e40-adff-07a7b8a352af.
[ 4989.149157] IP: [<ffffffff816e2b32>] _raw_spin_lock_irqsave+0x22/0x40
[ 4989.155978] PGD 858398067 PUD 858109067 PMD 0
[ 4989.160844] Oops: 0002 [#1] SMP
[ 4989.164359] Modules linked in: iw_cxgb4(OE) cxgb4(OE) null_blk brd
nvmet_rdma nvmet ip6table_filter ip6_tables ebtable_nat ebtables
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
nf_reject_ipv4
[ 4989.189404] nvmet: adding queue 1 to ctrl 1.
...
[ 4989.825586] nvmet: adding queue 30 to ctrl 1.
[ 4989.825643] nvmet: adding queue 31 to ctrl 1.
[ 4989.825700] nvmet: adding queue 32 to ctrl 1.
[ 4989.979826]  [<ffffffff816e2b32>] _raw_spin_lock_irqsave+0x22/0x40
[ 4989.987220] RSP: 0018:ffff880fb5e6bbe0  EFLAGS: 00010046
[ 4989.993071] RAX: 0000000000000000 RBX: 0000000000000006 RCX:
dead000000000200
[ 4990.000777] RDX: 0000000000000001 RSI: 0000000000000212 RDI:
00000000000000b8
[ 4990.008492] RBP: ffff880fb5e6bbe8 R08: ffff880fac0c0228 R09:
ffff880fb5e6bb64
[ 4990.016219] R10: 000000000000086c R11: 0000000000000000 R12:
ffff880fac0c0228
[ 4990.023936] R13: ffff880fb5935828 R14: 0000000000000297 R15:
ffff880fac0c0000
[ 4990.031627] FS:  0000000000000000(0000) GS:ffff88105f380000(0000)
knlGS:0000000000000000
[ 4990.040274] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4990.046538] CR2: 00000000000000b8 CR3: 00000008587e9000 CR4:
00000000000406e0
[ 4990.054178] Stack:
[ 4990.056665]  ffff880fb5935800 ffff880fb5e6bc38 ffffffffa0853642
ffff880fb5937cf0
[ 4990.064633]  0000000000000212 0000000000000000 ffff880fb5937c00
0000000000000000
[ 4990.072598]  0000000000010000 0000000000000000 0000000000000000
ffff880fb5e6bc88
[ 4990.080562] Call Trace:
[ 4990.083495]  [<ffffffffa0853642>] nvmet_rdma_recv_done+0x162/0x19c
[nvmet_rdma]
[ 4990.091291]  [<ffffffffa0255d48>] __ib_process_cq+0x48/0xc0 [ib_core]
[ 4990.098235]  [<ffffffffa0255f1a>] ib_cq_poll_work+0x2a/0x70 [ib_core]
[ 4990.105191]  [<ffffffff810a1483>] process_one_work+0x183/0x4d0
[ 4990.111555]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[ 4990.117566]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[ 4990.123243]  [<ffffffff810a211d>] worker_thread+0x16d/0x530
[ 4990.129367]  [<ffffffff810b4785>] ?
trace_event_raw_event_sched_switch+0xe5/0x130
[ 4990.137418]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[ 4990.143492]  [<ffffffff810cb9b6>] ? __wake_up_common+0x56/0x90
[ 4990.149916]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[ 4990.156784]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[ 4990.162535]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[ 4990.169441]  [<ffffffff810a6c5c>] kthread+0xcc/0xf0
[ 4990.174954]  [<ffffffff810b1aae>] ? schedule_tail+0x1e/0xc0
[ 4990.181173]  [<ffffffff816e2eff>] ret_from_fork+0x1f/0x40
[ 4990.187237]  [<ffffffff810a6b90>] ?
kthread_freezable_should_stop+0x70/0x70
[ 4990.194876] Code: 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 66 66 66 66
90 9c 58 66 66 90 66 90 48 89 c3 fa 66 66 90 66 66 90 31 c0 ba 01 00 00 00
<f0> 0f b1 17 85 c0 75 06 48 89 d8 5b c9 c3 89 c6 e8 39 f9 9e ff
[ 4990.216376] RIP  [<ffffffff816e2b32>] _raw_spin_lock_irqsave+0x22/0x40
[ 4990.223711]  RSP <ffff880fb5e6bbe0>
[ 4990.227996] CR2: 00000000000000b8


Given the way the BUG and stack trace are interleaved with "adding queue"
messages, I guess this was happening on multiple cores.  (the nodes have
32 cores). 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
