From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/5 v7] IB/srp: Eliminate two forward declarations
Date: Mon, 30 Aug 2010 21:27:32 +0200
Message-ID: <201008302127.32964.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch eliminates the two forward declarations that were introduced
via the previous patch of this series by rearranging the function
definition order.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |  137 +++++++++++++++++------------------
 1 files changed, 66 insertions(+), 71 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e8be7b5..17e948d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -83,11 +83,6 @@ static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
-static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
-				      enum srp_tx_iu_type iu_type);
-static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len,
-			   enum srp_send_iu_type iu_type);
 
 static struct scsi_transport_template *ib_srp_transport_template;
 
@@ -902,6 +897,72 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 }
 
 /*
+ * Must be called with target->scsi_host->host_lock held to protect
+ * req_lim and tx_head.  Lock cannot be dropped between call here and
+ * call to __srp_post_send().
+ *
+ * Note:
+ * An upper limit for the number of allocated information units for each
+ * request type is:
+ * - SRP_IU_CMD: SRP_CMD_SQ_SIZE, since the SCSI mid-layer never queues
+ *   more than Scsi_Host.can_queue requests.
+ * - SRP_IU_TSK_MGMT: SRP_TSK_MGMT_SQ_SIZE.
+ * - SRP_IU_RSP: 1, since a conforming SRP target never sends more than
+ *   one unanswered SRP request to an initiator.
+ */
+static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
+				      enum srp_tx_iu_type iu_type)
+{
+	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
+
+	srp_send_completion(target->send_cq, target);
+
+	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
+		return NULL;
+
+	if (iu_type != SRP_IU_RSP && target->req_lim <= rsv) {
+		++target->zero_req_lim;
+		return NULL;
+	}
+
+	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock held to protect
+ * req_lim and tx_head.
+ */
+static int __srp_post_send(struct srp_target_port *target,
+			   struct srp_iu *iu, int len,
+			   enum srp_send_iu_type iu_type)
+{
+	struct ib_sge list;
+	struct ib_send_wr wr, *bad_wr;
+	int ret = 0;
+
+	list.addr   = iu->dma;
+	list.length = len;
+	list.lkey   = target->srp_host->srp_dev->mr->lkey;
+
+	wr.next       = NULL;
+	wr.wr_id      = target->tx_head & SRP_SQ_MASK;
+	wr.sg_list    = &list;
+	wr.num_sge    = 1;
+	wr.opcode     = IB_WR_SEND;
+	wr.send_flags = IB_SEND_SIGNALED;
+
+	ret = ib_post_send(target->qp, &wr, &bad_wr);
+
+	if (!ret) {
+		++target->tx_head;
+		if (iu_type == SRP_SEND_REQ)
+			--target->req_lim;
+	}
+
+	return ret;
+}
+
+/*
  * Must be called with target->scsi_host->host_lock locked to protect
  * target->req_lim.
  */
@@ -1068,72 +1129,6 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 	}
 }
 
-/*
- * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.  Lock cannot be dropped between call here and
- * call to __srp_post_send().
- *
- * Note:
- * An upper limit for the number of allocated information units for each
- * request type is:
- * - SRP_IU_CMD: SRP_CMD_SQ_SIZE, since the SCSI mid-layer never queues
- *   more than Scsi_Host.can_queue requests.
- * - SRP_IU_TSK_MGMT: SRP_TSK_MGMT_SQ_SIZE.
- * - SRP_IU_RSP: 1, since a conforming SRP target never sends more than
- *   one unanswered SRP request to an initiator.
- */
-static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
-				      enum srp_tx_iu_type iu_type)
-{
-	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
-
-	srp_send_completion(target->send_cq, target);
-
-	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
-		return NULL;
-
-	if (iu_type != SRP_IU_RSP && target->req_lim <= rsv) {
-		++target->zero_req_lim;
-		return NULL;
-	}
-
-	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
-}
-
-/*
- * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.
- */
-static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len,
-			   enum srp_send_iu_type iu_type)
-{
-	struct ib_sge list;
-	struct ib_send_wr wr, *bad_wr;
-	int ret = 0;
-
-	list.addr   = iu->dma;
-	list.length = len;
-	list.lkey   = target->srp_host->srp_dev->mr->lkey;
-
-	wr.next       = NULL;
-	wr.wr_id      = target->tx_head & SRP_SQ_MASK;
-	wr.sg_list    = &list;
-	wr.num_sge    = 1;
-	wr.opcode     = IB_WR_SEND;
-	wr.send_flags = IB_SEND_SIGNALED;
-
-	ret = ib_post_send(target->qp, &wr, &bad_wr);
-
-	if (!ret) {
-		++target->tx_head;
-		if (iu_type == SRP_SEND_REQ)
-			--target->req_lim;
-	}
-
-	return ret;
-}
-
 static int srp_queuecommand(struct scsi_cmnd *scmnd,
 			    void (*done)(struct scsi_cmnd *))
 {
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
