From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/4 v3] IB/srp: implement SRP_CRED_REQ
Date: Tue, 3 Aug 2010 16:08:38 +0200
Message-ID: <201008031608.38361.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
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

About the implementation: both request and response information units are now
allocated from the same send queue. New variables tx_req and tx_rsp are
introduced to track the number of requests and responses allocated on the send
ring because tx_head - tx_tail now represents the total of the number of
allocated requests and responses.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |  157 +++++++++++++++++++++++++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h |   14 +++-
 include/scsi/srp.h                  |   14 +++
 3 files changed, 159 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1284bc3..b7bcbfc 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -93,6 +93,10 @@ static void srp_notify_recv_thread(struct ib_cq *cq, void *target_ptr);
 static int srp_compl_thread(void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
+static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
+				      enum srp_tx_iu_type tx_iu_type);
+static int __srp_post_send_rsp(struct srp_target_port *target,
+			       struct srp_iu *iu, int len);
 
 static struct scsi_transport_template *ib_srp_transport_template;
 
@@ -628,6 +632,8 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	target->rx_head	 = 0;
 	target->tx_head	 = 0;
 	target->tx_tail  = 0;
+	target->tx_req   = 0;
+	target->tx_rsp   = 0;
 
 	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
@@ -933,6 +939,69 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 }
 
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
+	if (res == 0) {
+		ib_dma_sync_single_for_device(dev, rsp_iu->dma, srp_max_iu_len,
+					      DMA_TO_DEVICE);
+
+		res = __srp_post_send_rsp(target, rsp_iu, sizeof *rsp_iu);
+		if (res)
+			shost_printk(KERN_ERR, target->scsi_host,
+				PFX "Sending response failed -- res = %d\n",
+				     res);
+	}
+
+out_unlock:
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+}
+
 static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 {
 	struct ib_device *dev;
@@ -966,6 +1035,10 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Got target logout request\n");
 		break;
 
+	case SRP_CRED_REQ:
+		srp_handle_req(target, iu);
+		break;
+
 	default:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Unhandled SRP opcode 0x%02x\n", opcode);
@@ -1022,6 +1095,10 @@ static int srp_compl_thread(void *target_ptr)
 	return 0;
 }
 
+/*
+ * Must be called with target->scsi_host->host_lock held to protect
+ * tx_tail, tx_rsp and tx_req.
+ */
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
@@ -1037,38 +1114,42 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 		}
 
 		++target->tx_tail;
+		if (wc.wr_id & SRP_OP_RSP)
+			--target->tx_rsp;
+		else
+			--target->tx_req;
 	}
 }
 
 /*
  * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.  Lock cannot be dropped between call here and
- * call to __srp_post_send().
+ * req_lim, tx_head and tx_req.  Lock cannot be dropped between call here and
+ * call to __srp_post_send_iu().
  */
 static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
-					enum srp_request_type req_type)
+				      enum srp_tx_iu_type tx_iu_type)
 {
-	s32 min = (req_type == SRP_REQ_TASK_MGMT) ? 1 : 2;
-
 	srp_send_completion(target->send_cq, target);
 
-	if (target->tx_head - target->tx_tail >= SRP_REQ_SQ_SIZE)
-		return NULL;
+	if (tx_iu_type == SRP_TX_IU_RSP) {
+		if (target->tx_rsp >= SRP_RSP_SQ_SIZE)
+			return NULL;
+	} else {
+		s32 min = (tx_iu_type == SRP_TX_IU_REQ_TASK_MGMT) ? 1 : 2;
 
-	if (target->req_lim < min) {
-		++target->zero_req_lim;
-		return NULL;
-	}
+		if (target->tx_req >= SRP_REQ_SQ_SIZE)
+			return NULL;
 
+		if (target->req_lim < min) {
+			++target->zero_req_lim;
+			return NULL;
+		}
+	}
 	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
 }
 
-/*
- * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.
- */
-static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len)
+static int __srp_post_send_iu(struct srp_target_port *target,
+			      struct srp_iu *iu, int len, int wr_id_flags)
 {
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
@@ -1079,7 +1160,7 @@ static int __srp_post_send(struct srp_target_port *target,
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next       = NULL;
-	wr.wr_id      = target->tx_head & SRP_SQ_MASK;
+	wr.wr_id      = (target->tx_head & SRP_SQ_MASK) | wr_id_flags;
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
@@ -1087,11 +1168,41 @@ static int __srp_post_send(struct srp_target_port *target,
 
 	ret = ib_post_send(target->qp, &wr, &bad_wr);
 
-	if (!ret) {
+	if (!ret)
 		++target->tx_head;
+
+	return ret;
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock held to protect
+ * req_lim, tx_head and tx_req.
+ */
+static int __srp_post_send_req(struct srp_target_port *target,
+			       struct srp_iu *iu, int len)
+{
+	int ret;
+
+	ret = __srp_post_send_iu(target, iu, len, 0);
+	if (ret == 0) {
+		++target->tx_req;
 		--target->req_lim;
 	}
+	return ret;
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock held to protect
+ * tx_head and tx_rsp.
+ */
+static int __srp_post_send_rsp(struct srp_target_port *target,
+			       struct srp_iu *iu, int len)
+{
+	int ret;
 
+	ret = __srp_post_send_iu(target, iu, len, SRP_OP_RSP);
+	if (ret == 0)
+		++target->tx_rsp;
 	return ret;
 }
 
@@ -1115,7 +1226,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		return 0;
 	}
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_NORMAL);
+	iu = __srp_get_tx_iu(target, SRP_TX_IU_REQ_NORMAL);
 	if (!iu)
 		goto err;
 
@@ -1152,7 +1263,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (__srp_post_send(target, iu, len)) {
+	if (__srp_post_send_req(target, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
@@ -1422,7 +1533,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	init_completion(&req->done);
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_TASK_MGMT);
+	iu = __srp_get_tx_iu(target, SRP_TX_IU_REQ_TASK_MGMT);
 	if (!iu)
 		goto out;
 
@@ -1435,7 +1546,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;
 
-	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
+	if (__srp_post_send_req(target, iu, sizeof *tsk_mgmt))
 		goto out;
 
 	req->tsk_mgmt = iu;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 9efff05..86261f3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -73,6 +73,11 @@ enum {
 	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4
 };
 
+/* wr_id for marking responses sent by the initiator to the target. */
+enum {
+	SRP_OP_RSP		= (1 << 30),
+};
+
 enum srp_target_state {
 	SRP_TARGET_LIVE,
 	SRP_TARGET_CONNECTING,
@@ -80,9 +85,10 @@ enum srp_target_state {
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
@@ -151,6 +157,8 @@ struct srp_target_port {
 
 	unsigned		tx_head;
 	unsigned		tx_tail;
+	unsigned		tx_req;
+	unsigned		tx_rsp;
 	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
 	struct list_head	free_reqs;
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
