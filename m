From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/3 v4] IB/srp: Implement SRP_CRED_REQ
Date: Tue, 10 Aug 2010 20:33:57 +0200
Message-ID: <201008102033.57038.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implements SRP_CRED_REQ, which is an information unit defined in the SRP
(draft) standard and that allows an SRP target to inform an SRP initiator that
more requests may be sent by the initiator. Adds declarations for the
SRP_CRED_REQ and SRP_CRED_RSP information units to include/scsi/srp.h.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |  222 +++++++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h |    7 +-
 include/scsi/srp.h                  |   14 +++
 3 files changed, 177 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6946012..cc6a713 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -898,6 +898,157 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 }
 
+/*
+ * Must be called with target->scsi_host->host_lock held to protect
+ * tx_head.  Lock cannot be dropped between call here and call to
+ * __srp_post_send_iu().
+ *
+ * Note:
+ * An upper limit for the number of allocated information units for each
+ * request type is:
+ * - SRP_TX_IU_REQ_NORMAL: SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_RSV, since the
+ *   SCSI mid-layer never queues more than Scsi_Host.can_queue requests.
+ * - SRP_TX_IU_REQ_TASK_MGMT: SRP_TSK_MGMT_RSV.
+ * - SRP_TX_IU_RSP: 1, since a conforming SRP target never sends more than
+ *   one unanswered SRP request to an initiator.
+ */
+static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
+				      enum srp_tx_iu_type tx_iu_type)
+{
+	s32 rsv;
+
+	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_SQ_MASK + 1);
+
+	srp_send_completion(target->send_cq, target);
+
+	rsv = (tx_iu_type == SRP_TX_IU_REQ_NORMAL) ? SRP_TSK_MGMT_RSV : 0;
+
+	if (SRP_SQ_SIZE - (target->tx_head - target->tx_tail) <= rsv)
+		return NULL;
+
+	if (tx_iu_type != SRP_TX_IU_RSP && target->req_lim <= rsv) {
+		++target->zero_req_lim;
+		return NULL;
+	}
+
+	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock held to protect tx_head.
+ */
+static int __srp_post_send_iu(struct srp_target_port *target,
+			      struct srp_iu *iu, int len)
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
+	if (!ret)
+		++target->tx_head;
+
+	return ret;
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock held to protect req_lim.
+ */
+static int __srp_post_send_req(struct srp_target_port *target,
+			       struct srp_iu *iu, int len)
+{
+	int ret;
+
+	ret = __srp_post_send_iu(target, iu, len);
+	if (ret == 0)
+		--target->req_lim;
+	return ret;
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock held.
+ */
+static int __srp_post_send_rsp(struct srp_target_port *target,
+			       struct srp_iu *iu, int len)
+{
+	return __srp_post_send_iu(target, iu, len);
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock locked to protect
+ * target->req_lim.
+ */
+static int srp_handle_cred_req(struct srp_target_port *target,
+			       struct srp_cred_req *req,
+			       struct srp_cred_rsp *rsp)
+{
+	target->req_lim += be32_to_cpu(req->req_lim_delta);
+
+	memset(rsp, 0, sizeof *rsp);
+	rsp->opcode = SRP_CRED_RSP;
+	rsp->tag    = req->tag;
+
+	return 0;
+}
+
+static void srp_handle_req(struct srp_target_port *target,
+			   struct srp_iu *req_iu)
+{
+	struct ib_device *dev;
+	u8 *req_buf;
+	unsigned long flags;
+	struct srp_iu *rsp_iu;
+	u8 *rsp_buf;
+	int res;
+
+	dev = target->srp_host->srp_dev->dev;
+	req_buf = req_iu->buf;
+
+	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+
+	rsp_iu = __srp_get_tx_iu(target, SRP_TX_IU_RSP);
+	if (!rsp_iu)
+		goto out_unlock;
+
+	rsp_buf = rsp_iu->buf;
+
+	res = -EINVAL;
+
+	switch (req_buf[0]) {
+	case SRP_CRED_REQ:
+		res = srp_handle_cred_req(target,
+					  (struct srp_cred_req *)req_buf,
+					  (struct srp_cred_rsp *)rsp_buf);
+		break;
+	}
+
+	if (res)
+		goto out_unlock;
+
+	ib_dma_sync_single_for_device(dev, rsp_iu->dma, srp_max_iu_len,
+				      DMA_TO_DEVICE);
+
+	res = __srp_post_send_rsp(target, rsp_iu, sizeof *rsp_iu);
+	if (res)
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "Sending response failed -- res = %d\n", res);
+
+out_unlock:
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+}
+
 static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 {
 	struct ib_device *dev;
@@ -931,6 +1082,10 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Got target logout request\n");
 		break;
 
+	case SRP_CRED_REQ:
+		srp_handle_req(target, iu);
+		break;
+
 	default:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Unhandled SRP opcode 0x%02x\n", opcode);
@@ -983,65 +1138,6 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 	}
 }
 
-/*
- * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.  Lock cannot be dropped between call here and
- * call to __srp_post_send().
- */
-static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
-					enum srp_request_type req_type)
-{
-	s32 rsv;
-
-	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_SQ_MASK + 1);
-
-	rsv = (req_type == SRP_REQ_NORMAL) ? SRP_TSK_MGMT_RSV : 0;
-
-	srp_send_completion(target->send_cq, target);
-
-	if (target->tx_head - target->tx_tail >= SRP_REQ_SQ_SIZE - rsv)
-		return NULL;
-
-	if (target->req_lim <= rsv) {
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
-		--target->req_lim;
-	}
-
-	return ret;
-}
-
 static int srp_queuecommand(struct scsi_cmnd *scmnd,
 			    void (*done)(struct scsi_cmnd *))
 {
@@ -1062,7 +1158,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		return 0;
 	}
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_NORMAL);
+	iu = __srp_get_tx_iu(target, SRP_TX_IU_REQ_NORMAL);
 	if (!iu)
 		goto err;
 
@@ -1099,7 +1195,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (__srp_post_send(target, iu, len)) {
+	if (__srp_post_send_req(target, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
@@ -1369,7 +1465,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	init_completion(&req->done);
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_TASK_MGMT);
+	iu = __srp_get_tx_iu(target, SRP_TX_IU_REQ_TASK_MGMT);
 	if (!iu)
 		goto out;
 
@@ -1382,7 +1478,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;
 
-	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
+	if (__srp_post_send_req(target, iu, sizeof *tsk_mgmt))
 		goto out;
 
 	req->tsk_mgmt = iu;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 3ff38b2..3588923 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -81,9 +81,10 @@ enum srp_target_state {
 	SRP_TARGET_REMOVED
 };
 
-enum srp_request_type {
-	SRP_REQ_NORMAL,
-	SRP_REQ_TASK_MGMT,
+enum srp_tx_iu_type {
+	SRP_TX_IU_REQ_NORMAL,
+	SRP_TX_IU_REQ_TASK_MGMT,
+	SRP_TX_IU_RSP,
 };
 
 struct srp_device {
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index ad178fa..535eb4f 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -239,4 +239,18 @@ struct srp_rsp {
 	u8	data[0];
 } __attribute__((packed));
 
+struct srp_cred_req {
+	u8	opcode;
+	u8	sol_not;
+	u8	reserved[2];
+	__be32	req_lim_delta;
+	u64	tag;
+};
+
+struct srp_cred_rsp {
+	u8	opcode;
+	u8	reserved[7];
+	u64	tag;
+};
+
 #endif /* SCSI_SRP_H */
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
