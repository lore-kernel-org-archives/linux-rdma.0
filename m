From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: [RFC PATCH 2/3] IB/srp: minimal support for SRP_CRED_REQ and SRP_AER_REQ
Date: Sun,  3 Jan 2010 20:43:36 -0500
Message-ID: <1262569417-20341-2-git-send-email-dave@thedillows.org>
References: <1262568846.13289.4.camel@obelisk.thedillows.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
In-Reply-To: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
References: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds support for SRP_CRED_REQ to avoid a lockup by targets
that use that mechanism to return credits to the initiator. This
prevents a lockup observed in the field where we would never add the
credits from the SRP_CRED_REQ to our current count, and would therefore
never send another command to the target.

Minimal support for SRP_AER_REQ is also added, as these messages can
also be used to convey additional credits to the initiator.

This should fix http://bugzilla.kernel.org/show_bug.cgi?id=14235

Reported-by: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   95 ++++++++++++++++++++++++++++++++---
 drivers/infiniband/ulp/srp/ib_srp.h |    8 +++-
 include/scsi/srp.h                  |   49 ++++++++++++++++++
 3 files changed, 143 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 82e7f9d..c0a5ccb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -82,6 +82,8 @@ static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
+static int srp_response_common(struct srp_target_port *target, s32 req_delta,
+			       void *rsp, int len);
 
 static struct scsi_transport_template *ib_srp_transport_template;
 
@@ -845,6 +847,37 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 }
 
+static void srp_process_cred_req(struct srp_target_port *target,
+				 struct srp_cred_req *req)
+{
+	struct srp_cred_rsp rsp = {
+		.opcode = SRP_CRED_RSP,
+		.tag = req->tag,
+	};
+	s32 delta = be32_to_cpu(req->req_lim_delta);
+
+	if (srp_response_common(target, delta, &rsp, sizeof rsp))
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "problems processing SRP_CRED_REQ\n");
+}
+
+static void srp_process_aer_req(struct srp_target_port *target,
+				 struct srp_aer_req *req)
+{
+	struct srp_aer_rsp rsp = {
+		.opcode = SRP_AER_RSP,
+		.tag = req->tag,
+	};
+	s32 delta = be32_to_cpu(req->req_lim_delta);
+
+	shost_printk(KERN_ERR, target->scsi_host, PFX
+		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
+
+	if (srp_response_common(target, delta, &rsp, sizeof rsp))
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "problems processing SRP_AER_REQ\n");
+}
+
 static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 {
 	struct ib_device *dev;
@@ -888,6 +921,14 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Got target logout request\n");
 		break;
 
+	case SRP_CRED_REQ:
+		srp_process_cred_req(target, iu->buf);
+		break;
+
+	case SRP_AER_REQ:
+		srp_process_aer_req(target, iu->buf);
+		break;
+
 	default:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Unhandled SRP opcode 0x%02x\n", opcode);
@@ -973,7 +1014,8 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 	if (target->tx_head - target->tx_tail >= SRP_SQ_FULL)
 		return NULL;
 
-	if (target->req_lim < min) {
+	/* SRP responses do not consume credits */
+	if (req_type != SRP_REQ_RESPONSE && target->req_lim < min) {
 		++target->zero_req_lim;
 		return NULL;
 	}
@@ -986,7 +1028,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
  * req_lim and tx_head.
  */
 static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len)
+			   struct srp_iu *iu, int len, int credits)
 {
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
@@ -1007,7 +1049,7 @@ static int __srp_post_send(struct srp_target_port *target,
 
 	if (!ret) {
 		++target->tx_head;
-		--target->req_lim;
+		target->req_lim -= credits;
 	}
 
 	return ret;
@@ -1075,7 +1117,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (__srp_post_send(target, iu, len)) {
+	if (__srp_post_send(target, iu, len, 1)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
@@ -1091,6 +1133,40 @@ err:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
+static int srp_response_common(struct srp_target_port *target, s32 req_delta,
+			       void *rsp, int len)
+{
+	struct ib_device *dev;
+	unsigned long flags;
+	struct srp_iu *iu;
+	int err = 1;
+
+	dev = target->srp_host->srp_dev->dev;
+
+	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+	target->req_lim += req_delta;
+
+	iu = __srp_get_tx_iu(target, SRP_REQ_RESPONSE);
+	if (!iu) {
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "no IU available to send response\n");
+		goto out;
+	}
+
+	ib_dma_sync_single_for_cpu(dev, iu->dma, len, DMA_TO_DEVICE);
+	memcpy(iu->buf, rsp, len);
+	ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
+
+	err = __srp_post_send(target, iu, len, 0);
+	if (err)
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "unable to post response: %d\n", err);
+
+out:
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+	return err;
+}
+
 static int srp_alloc_iu_bufs(struct srp_target_port *target)
 {
 	int i;
@@ -1214,6 +1290,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	int attr_mask = 0;
 	int comp = 0;
 	int opcode = 0;
+	int i;
 
 	switch (event->event) {
 	case IB_CM_REQ_ERROR:
@@ -1263,9 +1340,11 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (target->status)
 			break;
 
-		target->status = srp_post_recv(target);
-		if (target->status)
-			break;
+		for (i = 0; i < SRP_RESP_RESV; ++i) {
+			target->status = srp_post_recv(target);
+			if (target->status)
+				break;
+		}
 
 		qp_attr->qp_state = IB_QPS_RTS;
 		target->status = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
@@ -1353,7 +1432,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;
 
-	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
+	if (__srp_post_send(target, iu, sizeof *tsk_mgmt, 1))
 		goto out;
 
 	req->tsk_mgmt = iu;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 2742969..2ae3a8f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -57,14 +57,19 @@ enum {
 	SRP_MAX_LUN		= 512,
 	SRP_DEF_SG_TABLESIZE	= 12,
 
+	/* SRP_RQ_SHIFT sets the physical size of the TX/RX queues */
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
 	SRP_SQ_SIZE		= SRP_RQ_SIZE,
 	SRP_CQ_SIZE		= SRP_SQ_SIZE + SRP_RQ_SIZE,
 
+	/* SRP_RESP_RESV sets the number of queue entries reserved for
+	 * unsolicited messages from the target and the responses to them.
+	 */
+	SRP_RESP_RESV		= 2,
 	SRP_SQ_FULL		= SRP_SQ_SIZE - 1,
 	SRP_SQ_MASK		= SRP_SQ_SIZE - 1,
-	SRP_MAX_CREDIT		= SRP_SQ_SIZE - 1,
+	SRP_MAX_CREDIT		= SRP_SQ_SIZE - SRP_RESP_RESV - 1,
 
 	SRP_TAG_TSK_MGMT	= 1 << (SRP_RQ_SHIFT + 1),
 
@@ -85,6 +90,7 @@ enum srp_target_state {
 enum srp_request_type {
 	SRP_REQ_NORMAL,
 	SRP_REQ_TASK_MGMT,
+	SRP_REQ_RESPONSE,
 };
 
 struct srp_device {
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index ad178fa..ae7dcfd 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -239,4 +239,53 @@ struct srp_rsp {
 	u8	data[0];
 } __attribute__((packed));
 
+/*
+ * SRP_CRED_REQ information unit, as defined in section 6.10 of the
+ * T10 SRP r16a document.
+ */
+struct srp_cred_req {
+	u8	opcode;
+	u8	sol_not;
+	u8	reserved[2];
+	__be32	req_lim_delta;
+	u64	tag;
+} __attribute__((packed));
+
+/*
+ * SRP_CRED_RSP information unit, as defined in section 6.11 of the
+ * T10 SRP r16a document.
+ */
+struct srp_cred_rsp {
+	u8	opcode;
+	u8	reserved[7];
+	u64	tag;
+} __attribute__((packed));
+
+/*
+ * SRP_AER_REQ information unit, as defined in section 6.12 of the
+ * T10 SRP r16a document.
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
+/*
+ * SRP_AER_RSP information unit, as defined in section 6.13 of the
+ * T10 SRP r16a document.
+ */
+struct srp_aer_rsp {
+	u8	opcode;
+	u8	reserved[7];
+	u64	tag;
+} __attribute__((packed));
+
 #endif /* SCSI_SRP_H */
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
