From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target driver
Date: Tue, 14 Jun 2016 11:22:25 -0500
Message-ID: <00f701d1c658$efd720d0$cf856270$@opengridcomputing.com>
References: <1465248215-18186-1-git-send-email-hch@lst.de> <1465248215-18186-5-git-send-email-hch@lst.de> <5756B75C.9000409@lightbits.io> <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com> <00f501d1c657$483a74e0$d8af5ea0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00f501d1c657$483a74e0$d8af5ea0$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Armen Baloyan' <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jay Freyensee' <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ming Lin' <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Hey Sean,
> 
> Am I correct here?  IE: Is it ok for the rdma application to rdma_reject() and
> rmda_destroy_id() the CONNECT_REQUEST cm_id _inside_ its event handler as
> long
> as it returns 0?
> 
> Thanks,
> 
> Steve.


Looking at rdma_destroy_id(), I think it is invalid to call it from the event
handler:

void rdma_destroy_id(struct rdma_cm_id *id)
{

<snip>

        /*
         * Wait for any active callback to finish.  New callbacks will find
         * the id_priv state set to destroying and abort.
         */
        mutex_lock(&id_priv->handler_mutex);
        mutex_unlock(&id_priv->handler_mutex);

And indeed when I tried to destroy the CONNECT request cm_id in the nvmet event
handler, I see the event handler thread is stuck:

INFO: task kworker/u32:0:6275 blocked for more than 120 seconds.
      Tainted: G            E   4.7.0-rc2-nvmf-all.3+ #81
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u32:0   D ffff880f90737768     0  6275      2 0x10000080
Workqueue: iw_cm_wq cm_work_handler [iw_cm]
 ffff880f90737768 ffff880f907376d8 ffffffff81c0b500 0000000000000005
 ffff8810226a4940 ffff88102b894490 ffffffffa02cf4cd ffff880f00000000
 ffff880fcd917c00 ffff880f00000000 0000000000000004 ffff880f00000000
Call Trace:
 [<ffffffffa02cf4cd>] ? stop_ep_timer+0x2d/0xe0 [iw_cxgb4]
 [<ffffffff8163e6a7>] schedule+0x47/0xc0
 [<ffffffffa024d276>] ? iw_cm_reject+0x96/0xe0 [iw_cm]
 [<ffffffff8163e8e5>] schedule_preempt_disabled+0x15/0x20
 [<ffffffff8163fd78>] __mutex_lock_slowpath+0x108/0x310
 [<ffffffff8163ffb1>] mutex_lock+0x31/0x50
 [<ffffffffa0261498>] rdma_destroy_id+0x38/0x200 [rdma_cm]
 [<ffffffffa03145f0>] ? nvmet_rdma_queue_connect+0x1a0/0x1a0 [nvmet_rdma]
 [<ffffffffa0262fe1>] ? rdma_create_id+0x171/0x1a0 [rdma_cm]
 [<ffffffffa03146f8>] nvmet_rdma_cm_handler+0x108/0x168 [nvmet_rdma]
 [<ffffffffa026407a>] iw_conn_req_handler+0x1ca/0x240 [rdma_cm]
 [<ffffffffa024efc6>] cm_conn_req_handler+0x606/0x680 [iw_cm]
 [<ffffffffa024f109>] process_event+0xc9/0xf0 [iw_cm]
 [<ffffffffa024f277>] cm_work_handler+0x147/0x1c0 [iw_cm]
 [<ffffffff8107d4f6>] ? trace_event_raw_event_workqueue_execute_start+0x66/0xa0
 [<ffffffff81081736>] process_one_work+0x1c6/0x550
...

So I withdraw my comment about nvmet.  I think the code is fine as-is.  The 2nd
reject results in a no-op since the connection request was rejected by nvmet.

Steve. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
