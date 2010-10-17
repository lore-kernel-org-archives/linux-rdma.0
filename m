From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 3/5] IB/srp: eliminate two forward declarations
Date: Sat, 16 Oct 2010 23:25:23 -0400
Message-ID: <1287285925-11710-4-git-send-email-dillowda@ornl.gov>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287285925-11710-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  142 +++++++++++++++++------------------
 1 files changed, 69 insertions(+), 73 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a54eee9..d4c08d6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -83,10 +83,6 @@ static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
-static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
-				      enum srp_iu_type iu_type);
-static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len);
 
 static struct scsi_transport_template *ib_srp_transport_template;
 
@@ -815,6 +811,75 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	return len;
 }
 
+/*
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
+				      enum srp_iu_type iu_type)
+{
+	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
+	struct srp_iu *iu;
+
+	srp_send_completion(target->send_cq, target);
+
+	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
+		return NULL;
+
+	/* Initiator responses to target requests do not consume credits */
+	if (target->req_lim <= rsv && iu_type != SRP_IU_RSP) {
+		++target->zero_req_lim;
+		return NULL;
+	}
+
+	iu = target->tx_ring[target->tx_head & SRP_SQ_MASK];
+	iu->type = iu_type;
+	return iu;
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock held to protect
+ * req_lim and tx_head.
+ */
+static int __srp_post_send(struct srp_target_port *target,
+			   struct srp_iu *iu, int len)
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
+		if (iu->type != SRP_IU_RSP)
+			--target->req_lim;
+	}
+
+	return ret;
+}
+
 static int srp_post_recv(struct srp_target_port *target)
 {
 	unsigned long flags;
@@ -1058,75 +1123,6 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
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
-				      enum srp_iu_type iu_type)
-{
-	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
-	struct srp_iu *iu;
-
-	srp_send_completion(target->send_cq, target);
-
-	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
-		return NULL;
-
-	/* Initiator responses to target requests do not consume credits */
-	if (target->req_lim <= rsv && iu_type != SRP_IU_RSP) {
-		++target->zero_req_lim;
-		return NULL;
-	}
-
-	iu = target->tx_ring[target->tx_head & SRP_SQ_MASK];
-	iu->type = iu_type;
-	return iu;
-}
-
-/*
- * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.
- */
-static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len)
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
-		if (iu->type != SRP_IU_RSP)
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
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
