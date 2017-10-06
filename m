From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 2/7] IB/srpt: Cache global L_Key
Date: Fri,  6 Oct 2017 14:42:38 -0700
Message-ID: <20171006214243.11296-3-bart.vanassche@wdc.com>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006214243.11296-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch is a micro-optimization for the hot path.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 6 ++++--
 drivers/infiniband/ulp/srpt/ib_srpt.h | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 76370e39857d..6cf95ad870cc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -766,7 +766,7 @@ static int srpt_post_recv(struct srpt_device *sdev,
 	BUG_ON(!sdev);
 	list.addr = ioctx->ioctx.dma;
 	list.length = srp_max_req_size;
-	list.lkey = sdev->pd->local_dma_lkey;
+	list.lkey = sdev->lkey;
 
 	ioctx->ioctx.cqe.done = srpt_recv_done;
 	wr.wr_cqe = &ioctx->ioctx.cqe;
@@ -2343,7 +2343,7 @@ static void srpt_queue_response(struct se_cmd *cmd)
 
 	sge.addr = ioctx->ioctx.dma;
 	sge.length = resp_len;
-	sge.lkey = sdev->pd->local_dma_lkey;
+	sge.lkey = sdev->lkey;
 
 	ioctx->ioctx.cqe.done = srpt_send_done;
 	send_wr.next = NULL;
@@ -2491,6 +2491,8 @@ static void srpt_add_one(struct ib_device *device)
 	if (IS_ERR(sdev->pd))
 		goto free_dev;
 
+	sdev->lkey = sdev->pd->local_dma_lkey;
+
 	sdev->srq_size = min(srpt_srq_size, sdev->device->attrs.max_srq_wr);
 
 	srq_attr.event_handler = srpt_srq_event;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 1b817e51b84b..976e924d7400 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -343,7 +343,7 @@ struct srpt_port {
  * struct srpt_device - Information associated by SRPT with a single HCA.
  * @device:        Backpointer to the struct ib_device managed by the IB core.
  * @pd:            IB protection domain.
- * @mr:            L_Key (local key) with write access to all local memory.
+ * @lkey:          L_Key (local key) with write access to all local memory.
  * @srq:           Per-HCA SRQ (shared receive queue).
  * @cm_id:         Connection identifier.
  * @srq_size:      SRQ size.
@@ -358,6 +358,7 @@ struct srpt_port {
 struct srpt_device {
 	struct ib_device	*device;
 	struct ib_pd		*pd;
+	u32			lkey;
 	struct ib_srq		*srq;
 	struct ib_cm_id		*cm_id;
 	int			srq_size;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
