From: "Dhanalakota, Venkata S" <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Re: [PATCH v2 for-next] IB/SA: Check dlid before SA agent
 queries for ClassPortInfo
Date: Wed, 10 Jan 2018 20:04:54 +0000
Message-ID: <8C8FAED8CED26F4C8245E7FC6A20F9063C552163@ORSMSX111.amr.corp.intel.com>
References: <20171222233908.GC17198@ziepe.ca>
 <bbf566a9-0d8d-c6f8-da54-8244cebdfea8@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bbf566a9-0d8d-c6f8-da54-8244cebdfea8-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,
Yes it is a bug to hang on bad SM lid. While root causing the hang, I thought it is better to add some logic that will prevent sending the packets with bad dlid in first place.

Thank you,
Sandeep
On Mon, Dec 18, 2017 at 07:26:58PM -0800, Dennis Dalessandro wrote:
> From: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> SA queries SM for class port info when there is a LID_CHANGE event.
> 
> When a base lid is configured before fm is started ie when smlid is 
> not yet assigned, SA handles the LID_CHANGE event and tries query SM 
> with lid 0. This will cause an hang.
> 
> [ 1106.958820] INFO: task kworker/2:0:23 blocked for more than 120 seconds.
> [ 1106.965082] Tainted: G O 4.12.0+ #1 [ 1106.969602] "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables  this message.
> [ 1106.977227] kworker/2:0 D 0 23 2 0x00000000 [ 1106.977250] 
> Workqueue: infiniband update_ib_cpi [ib_core] [ 1106.977261] Call 
> Trace:
> [ 1106.977273] __schedule+0x28e/0x860
> [ 1106.977285] schedule+0x36/0x80
> [ 1106.977298] schedule_timeout+0x1a3/0x2e0 [ 1106.977310] ? 
> radix_tree_iter_tag_clear+0x1b/0x20
> [ 1106.977322] ? idr_alloc+0x64/0x90
> [ 1106.977334] wait_for_completion+0xe3/0x140 [ 1106.977347] ? 
> wake_up_q+0x80/0x80 [ 1106.977369] update_ib_cpi+0x163/0x210 [ib_core] 
> [ 1106.977381] process_one_work+0x147/0x370 [ 1106.977394] 
> worker_thread+0x4a/0x390 [ 1106.977406] kthread+0x109/0x140 [ 
> 1106.977418] ? process_one_work+0x370/0x370 [ 1106.977430] ? 
> kthread_park+0x60/0x60 [ 1106.977443] ret_from_fork+0x22/0x30
> 
> Always ensure a proper smlid is assigned before querying SM for cpi.
> 
> Fixes: ee1c60b1bff ("IB/SA: Modify SA to implicitly cache Class Port 
> info")
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Venkata Sandeep Dhanalakota 
> <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Took it to for-next

Although I am unclear why a bad SM lid should cause a hang? Doesn't like seem like a bug unto itself?

Thanks,
Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
