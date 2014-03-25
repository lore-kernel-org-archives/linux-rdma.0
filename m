From: Egor Medvedev <methodx-w/L3Ro8pDhisTnJN9+BGXg@public.gmane.org>
Subject: ib_srpt error
Date: Tue, 25 Mar 2014 12:19:29 +0400
Message-ID: <CAK4NFoEhJPx6YBpa7OMV_jo2YmAcV1LcquQiC4-2+LPCSz4cQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello everyone!

Looks like I've got a problem. Suddenly, srp connection failed.
Here is dmesg from my node:
===
[Tue Mar 25 11:36:43 2014] INFO: task blkback.1.xvda:20168 blocked for
more than 120 seconds.
[Tue Mar 25 11:36:43 2014] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Mar 25 11:36:43 2014] blkback.1.xvda  D ffff8801b9a53f40     0
20168      2 0x00000000
[Tue Mar 25 11:36:43 2014]  ffff88012dd84040 0000000000000246
00000000001c001c ffff880176244040
[Tue Mar 25 11:36:43 2014]  0000000000013f40 ffff88016aae7fd8
ffff88016aae7fd8 ffff88012dd84040
[Tue Mar 25 11:36:43 2014]  ffffffff813907d4 ffff88015c2bb000
ffff88016aae79b0 ffff88015c2bb290
[Tue Mar 25 11:36:43 2014] Call Trace:
[Tue Mar 25 11:36:43 2014]  [<ffffffff813907d4>] ?
_raw_spin_unlock_irqrestore+0xc/0xd
[Tue Mar 25 11:36:43 2014]  [<ffffffffa0297ef5>] ?
md_write_start+0x131/0x147 [md_mod]
[Tue Mar 25 11:36:43 2014]  [<ffffffff811bd8f7>] ?
arch_local_irq_restore+0x7/0x8
[Tue Mar 25 11:36:43 2014]  [<ffffffff8105858f>] ?
abort_exclusive_wait+0x79/0x79
[Tue Mar 25 11:36:43 2014]  [<ffffffffa047171d>] ?
make_request+0x37/0xa63 [raid1]
[Tue Mar 25 11:36:43 2014]  [<ffffffff811ad689>] ? blk_peek_request+0x1c2/0x209
[Tue Mar 25 11:36:43 2014]  [<ffffffff8107f67f>] ?
arch_local_irq_disable+0x7/0x8
[Tue Mar 25 11:36:43 2014]  [<ffffffff81390691>] ?
_raw_read_lock_irqsave+0x21/0x2a
[Tue Mar 25 11:36:43 2014]  [<ffffffff8107f677>] ?
arch_local_irq_restore+0x7/0x8
[Tue Mar 25 11:36:43 2014]  [<ffffffff8139083f>] ?
_raw_read_unlock_irqrestore+0xb/0xc
[Tue Mar 25 11:36:43 2014]  [<ffffffffa02d320a>] ?
dm_get_live_table+0x35/0x3d [dm_mod]
[Tue Mar 25 11:36:43 2014]  [<ffffffffa029caf7>] ?
md_make_request+0xee/0x1df [md_mod]
[Tue Mar 25 11:36:43 2014]  [<ffffffff811ac10f>] ?
generic_make_request+0x96/0xd5
[Tue Mar 25 11:36:43 2014]  [<ffffffff811acd1a>] ? submit_bio+0x10a/0x13b
[Tue Mar 25 11:36:43 2014]  [<ffffffffa0460dfb>] ?
dispatch_rw_block_io+0x32d/0x3d7 [xen_blkback]
[Tue Mar 25 11:36:43 2014]  [<ffffffff81067c91>] ? load_balance+0xb1/0x5de
[Tue Mar 25 11:36:43 2014]  [<ffffffff8100413f>] ?
arch_local_irq_restore+0x7/0x8
[Tue Mar 25 11:36:43 2014]  [<ffffffff810042e3>] ? xen_mc_flush+0x11e/0x161
[Tue Mar 25 11:36:43 2014]  [<ffffffff81003173>] ?
xen_end_context_switch+0xe/0x1c
[Tue Mar 25 11:36:43 2014]  [<ffffffff8100383f>] ?
xen_mc_issue.constprop.22+0x27/0x4d
[Tue Mar 25 11:36:43 2014]  [<ffffffffa04610fd>] ?
__do_block_io_op+0x258/0x390 [xen_blkback]
[Tue Mar 25 11:36:43 2014]  [<ffffffff8105f63c>] ? mmdrop+0xd/0x1c
[Tue Mar 25 11:36:43 2014]  [<ffffffff810602aa>] ? finish_task_switch+0x83/0xae
[Tue Mar 25 11:36:43 2014]  [<ffffffffa0461568>] ?
xen_blkif_schedule+0x30b/0x417 [xen_blkback]
[Tue Mar 25 11:36:43 2014]  [<ffffffff8105858f>] ?
abort_exclusive_wait+0x79/0x79
[Tue Mar 25 11:36:43 2014]  [<ffffffffa046125d>] ?
xen_blkif_be_int+0x28/0x28 [xen_blkback]
[Tue Mar 25 11:36:43 2014]  [<ffffffffa046125d>] ?
xen_blkif_be_int+0x28/0x28 [xen_blkback]
[Tue Mar 25 11:36:43 2014]  [<ffffffff81057bf5>] ? kthread+0x81/0x89
[Tue Mar 25 11:36:43 2014]  [<ffffffff8100383f>] ?
xen_mc_issue.constprop.22+0x27/0x4d
[Tue Mar 25 11:36:43 2014]  [<ffffffff81057b74>] ? __kthread_parkme+0x5d/0x5d
[Tue Mar 25 11:36:43 2014]  [<ffffffff81395bbc>] ? ret_from_fork+0x7c/0xb0
[Tue Mar 25 11:36:43 2014]  [<ffffffff81057b74>] ? __kthread_parkme+0x5d/0x5d
[Tue Mar 25 11:37:17 2014] scsi host7: ib_srp: DREQ received - connection closed
[Tue Mar 25 11:37:19 2014] scsi host7: ib_srp: connection closed
===

Looks like node just closed connection. I assume, this is normal behaviour.

So, I've checked target node (storage) for errors:

===
[Tue Mar 25 11:35:26 2014] ib_srpt: RDMA t 5 for idx 16 failed with status 12
[Tue Mar 25 11:35:26 2014] ib_srpt: sending response for idx 16 failed
with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: RDMA t 5 for idx 6 failed with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: sending response for idx 6 failed
with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: RDMA t 5 for idx 21 failed with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: sending response for idx 21 failed
with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: RDMA t 5 for idx 14 failed with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: sending response for idx 14 failed
with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: RDMA t 5 for idx 29 failed with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: sending response for idx 29 failed
with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: RDMA t 4 for idx 28 failed with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: sending response for idx 24 failed
with status 5
[Tue Mar 25 11:35:26 2014] ib_srpt: sending response for idx 28 failed
with status 5
[Tue Mar 25 11:36:22 2014] ib_srpt: Received SRP_LOGIN_REQ with
i_port_id 31ad:1f00:03c9:0200:0025:90ff:ff90:4081, t_port_id
0002:c903:001f:ad30:0002:c903:001f:ad30 and it_iu_len 260 on port 1
(guid=fe80:0000:0000:0000:0002:c903:001f:ad31)
[Tue Mar 25 11:36:22 2014] scst: Using security group
"ib_srpt_target_0" for initiator "0x31ad1f0003c90200002590ffff904081"
(target ib_srpt_target_0)
[Tue Mar 25 11:37:01 2014] ib_srpt: RDMA t 5 for idx 0 failed with status 12
[Tue Mar 25 11:37:01 2014] ib_srpt: sending response for idx 3 failed
with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: sending response for idx 0 failed
with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: RDMA t 5 for idx 2 failed with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: RDMA t 4 for idx 5 failed with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: sending response for idx 2 failed
with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: RDMA t 5 for idx 4 failed with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: sending response for idx 4 failed
with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: RDMA t 5 for idx 1 failed with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: sending response for idx 1 failed
with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: sending response for idx 6 failed
with status 5
[Tue Mar 25 11:37:01 2014] ib_srpt: sending response for idx 5 failed
with status 5
===

I can't  understand  what does status 5 means.

Also, I googled for this error, and managed to find some information
from mailing lists:

===
mlx4_0/ports/1/counters/excessive_buffer_overrun_errors:0
mlx4_0/ports/1/counters/link_error_recovery:0
mlx4_0/ports/1/counters/local_link_integrity_errors:0
mlx4_0/ports/1/counters/port_rcv_constraint_errors:0
mlx4_0/ports/1/counters/port_rcv_errors:117
mlx4_0/ports/1/counters/port_rcv_remote_physical_errors:0
mlx4_0/ports/1/counters/port_rcv_switch_relay_errors:0
mlx4_0/ports/1/counters/port_xmit_constraint_errors:0
mlx4_0/ports/1/counters/symbol_error:177
===

Thanks
-- 
Best regards,
Egor
http://aylium.net
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
