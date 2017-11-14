From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/6] IB/SA: Check dlid before SA agent queries for
 ClassPortInfo
Date: Tue, 14 Nov 2017 04:34:31 -0800
Message-ID: <20171114123428.10579.94740.stgit@scvm10.sc.intel.com>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114122859.10579.79788.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

SA queries SM for class port info when there is a LID_CHANGE event.

When a base lid is configured before fm is started ie when smlid is
not yet assigned, SA handles the LID_CHANGE event and tries query SM
with lid 0. This will cause an hang.

[ 1106.958820] INFO: task kworker/2:0:23 blocked for more than 120 seconds.
[ 1106.965082] Tainted: G O 4.12.0+ #1
[ 1106.969602] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
 this message.
[ 1106.977227] kworker/2:0 D 0 23 2 0x00000000
[ 1106.977250] Workqueue: infiniband update_ib_cpi [ib_core]
[ 1106.977261] Call Trace:
[ 1106.977273] __schedule+0x28e/0x860
[ 1106.977285] schedule+0x36/0x80
[ 1106.977298] schedule_timeout+0x1a3/0x2e0
[ 1106.977310] ? radix_tree_iter_tag_clear+0x1b/0x20
[ 1106.977322] ? idr_alloc+0x64/0x90
[ 1106.977334] wait_for_completion+0xe3/0x140
[ 1106.977347] ? wake_up_q+0x80/0x80
[ 1106.977369] update_ib_cpi+0x163/0x210 [ib_core]
[ 1106.977381] process_one_work+0x147/0x370
[ 1106.977394] worker_thread+0x4a/0x390
[ 1106.977406] kthread+0x109/0x140
[ 1106.977418] ? process_one_work+0x370/0x370
[ 1106.977430] ? kthread_park+0x60/0x60
[ 1106.977443] ret_from_fork+0x22/0x30

Always ensure a proper smlid is assigned before querying SM for cpi.

Fixes: ee1c60b1bff ("IB/SA: Modify SA to implicitly cache Class Port info")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index ab5e102..24b9b5f 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1345,6 +1345,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 
 static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask)
 {
+	struct rdma_ah_attr ah_attr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&query->port->ah_lock, flags);
@@ -1356,6 +1357,15 @@ static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask)
 	query->sm_ah = query->port->sm_ah;
 	spin_unlock_irqrestore(&query->port->ah_lock, flags);
 
+	/*
+	 * Always check if sm_ah has valid dlid assigned,
+	 * before querying for class port info
+	 */
+	if ((rdma_query_ah(query->sm_ah->ah, &ah_attr) < 0) ||
+	    !rdma_ah_get_dlid(&ah_attr)) {
+		kref_put(&query->sm_ah->ref, free_sm_ah);
+		return -EAGAIN;
+	}
 	query->mad_buf = ib_create_send_mad(query->port->agent, 1,
 					    query->sm_ah->pkey_index,
 					    0, IB_MGMT_SA_HDR, IB_MGMT_SA_DATA,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
