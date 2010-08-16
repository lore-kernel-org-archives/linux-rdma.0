From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/3 v5] IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ
Date: Mon, 16 Aug 2010 20:55:02 +0200
Message-ID: <201008162055.02750.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implements SRP_CRED_REQ and SRP_AER_REQ, which are information units defined
in the SRP (draft) standard.  Adds declarations for the SRP_CRED_REQ,
SRP_CRED_RSP, SRP_AER_REQ and SRP_AER_RSP information units to
include/scsi/srp.h. Changes function definition order in ib_srp in order to
avoid having to add more forward declarations.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |  244 ++++++++++++++++++++++++++---------
 drivers/infiniband/ulp/srp/ib_srp.h |    7 +-
 include/scsi/srp.h                  |   38 ++++++
 3 files changed, 225 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 548ba5d..da62b57 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -896,6 +896,180 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
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
+ * - SRP_TX_IU_REQ_NORMAL: SRP_NORMAL_REQ_SQ_SIZE, since the SCSI mid-layer
+ *   never queues more than Scsi_Host.can_queue requests.
+ * - SRP_TX_IU_REQ_TASK_MGMT: SRP_TASK_MGMT_SQ_SIZE.
+ * - SRP_TX_IU_RSP: 1, since a conforming SRP target never sends more than
+ *   one unanswered SRP request to an initiator.
+ */
+static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
+				      enum srp_tx_iu_type tx_iu_type)
+{
+	s32 rsv;
+
+	srp_send_completion(target->send_cq, target);
+
+	rsv = (tx_iu_type == SRP_TX_IU_REQ_TASK_MGMT) ? 0 : SRP_TASK_MGMT_SQ_SIZE;
+
+	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
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
+/*
+ * Must be called with target->scsi_host->host_lock locked to protect
+ * target->req_lim.
+ */
+static int srp_handle_aer_req(struct srp_target_port *target,
+			      struct srp_aer_req *req,
+			      struct srp_aer_rsp *rsp)
+{
+	target->req_lim += be32_to_cpu(req->req_lim_delta);
+
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
+
+	memset(rsp, 0, sizeof *rsp);
+	rsp->opcode = SRP_AER_RSP;
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
+	case SRP_AER_REQ:
+		res = srp_handle_aer_req(target,
+					  (struct srp_aer_req *)req_buf,
+					  (struct srp_aer_rsp *)rsp_buf);
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
@@ -929,6 +1103,11 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Got target logout request\n");
 		break;
 
+	case SRP_CRED_REQ:
+	case SRP_AER_REQ:
+		srp_handle_req(target, iu);
+		break;
+
 	default:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Unhandled SRP opcode 0x%02x\n", opcode);
@@ -981,63 +1160,6 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
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
-	rsv = (req_type == SRP_REQ_TASK_MGMT) ? 0 : SRP_TASK_MGMT_SQ_SIZE;
-
-	srp_send_completion(target->send_cq, target);
-
-	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
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
@@ -1058,7 +1180,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		return 0;
 	}
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_NORMAL);
+	iu = __srp_get_tx_iu(target, SRP_TX_IU_REQ_NORMAL);
 	if (!iu)
 		goto err;
 
@@ -1095,7 +1217,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (__srp_post_send(target, iu, len)) {
+	if (__srp_post_send_req(target, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
@@ -1365,7 +1487,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	init_completion(&req->done);
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_TASK_MGMT);
+	iu = __srp_get_tx_iu(target, SRP_TX_IU_REQ_TASK_MGMT);
 	if (!iu)
 		goto out;
 
@@ -1378,7 +1500,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;
 
-	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
+	if (__srp_post_send_req(target, iu, sizeof *tsk_mgmt))
 		goto out;
 
 	req->tsk_mgmt = iu;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 3a566a7..f8e9bb4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -82,9 +82,10 @@ enum srp_target_state {
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
index ad178fa..1ae84db 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -239,4 +239,42 @@ struct srp_rsp {
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
+/*
+ * The SRP spec defines the fixed portion of the AER_REQ structure to be
+ * 36 bytes, so it needs to be packed to avoid having it padded to 40 bytes
+ * on 64-bit architectures.
+ */
+struct srp_aer_req {
+	u8	opcode;
+	u8	sol_not;
+	u8	reserved[2];
+	__be32	req_lim_delta;
+	u64	tag;
+	u32	reserved2;
+	__be64	lun;
+	__be32	sense_data_len;
+	u32	reserved3;
+	u8	sense_data[0];
+} __attribute__((packed));
+
+struct srp_aer_rsp {
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
