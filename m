From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/5 v6] IB/srp: IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ
Date: Sun, 22 Aug 2010 18:56:29 +0200
Message-ID: <201008221856.29895.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implements SRP_CRED_REQ and SRP_AER_REQ, which are information units defined
in the SRP (draft) standard.  Adds declarations for the SRP_CRED_REQ,
SRP_CRED_RSP, SRP_AER_REQ and SRP_AER_RSP information units to
include/scsi/srp.h.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |  114 ++++++++++++++++++++++++++++++++---
 drivers/infiniband/ulp/srp/ib_srp.h |   12 +++-
 include/scsi/srp.h                  |   38 ++++++++++++
 3 files changed, 153 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b2e04b7..dac7a09 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -83,6 +83,11 @@ static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
+static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
+				      enum srp_tx_iu_type iu_type);
+static int __srp_post_send(struct srp_target_port *target,
+			   struct srp_iu *iu, int len,
+			   enum srp_send_iu_type iu_type);
 
 static struct scsi_transport_template *ib_srp_transport_template;
 
@@ -896,6 +901,80 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 }
 
+/*
+ * Must be called with target->scsi_host->host_lock locked to protect
+ * target->req_lim.
+ */
+static void __srp_handle_cred_req(struct srp_target_port *target,
+				  void *req_ptr, void *rsp_ptr)
+{
+	struct srp_cred_req *req = req_ptr;
+	struct srp_cred_rsp *rsp = rsp_ptr;
+
+	target->req_lim += be32_to_cpu(req->req_lim_delta);
+
+	memset(rsp, 0, sizeof *rsp);
+	rsp->opcode = SRP_CRED_RSP;
+	rsp->tag    = req->tag;
+}
+
+/*
+ * Must be called with target->scsi_host->host_lock locked to protect
+ * target->req_lim.
+ */
+static void __srp_handle_aer_req(struct srp_target_port *target,
+				 void *req_ptr, void *rsp_ptr)
+{
+	struct srp_aer_req *req = req_ptr;
+	struct srp_aer_rsp *rsp = rsp_ptr;
+
+	target->req_lim += be32_to_cpu(req->req_lim_delta);
+
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
+
+	memset(rsp, 0, sizeof *rsp);
+	rsp->opcode = SRP_AER_RSP;
+	rsp->tag    = req->tag;
+}
+
+static void srp_handle_req(struct srp_target_port *target,
+			   struct srp_iu *req_iu,
+			   void (*req_fn)(struct srp_target_port *,
+					  void *, void *))
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
+	rsp_iu = __srp_get_tx_iu(target, SRP_IU_RSP);
+	if (!rsp_iu)
+		goto out_unlock;
+
+	rsp_buf = rsp_iu->buf;
+
+	(*req_fn)(target, req_buf, rsp_buf);
+
+	ib_dma_sync_single_for_device(dev, rsp_iu->dma, srp_max_iu_len,
+				      DMA_TO_DEVICE);
+
+	res = __srp_post_send(target, rsp_iu, sizeof *rsp_iu, SRP_SEND_RSP);
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
@@ -929,6 +1008,14 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Got target logout request\n");
 		break;
 
+	case SRP_CRED_REQ:
+		srp_handle_req(target, iu, &__srp_handle_cred_req);
+		break;
+
+	case SRP_AER_REQ:
+		srp_handle_req(target, iu, &__srp_handle_aer_req);
+		break;
+
 	default:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Unhandled SRP opcode 0x%02x\n", opcode);
@@ -985,11 +1072,20 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
  * Must be called with target->scsi_host->host_lock held to protect
  * req_lim and tx_head.  Lock cannot be dropped between call here and
  * call to __srp_post_send().
+ *
+ * Note:
+ * An upper limit for the number of allocated information units for each
+ * request type is:
+ * - SRP_IU_REQ_NORMAL: SRP_NORMAL_REQ_SQ_SIZE, since the SCSI mid-layer
+ *   never queues more than Scsi_Host.can_queue requests.
+ * - SRP_IU_REQ_TSK_MGMT: SRP_TSK_MGMT_SQ_SIZE.
+ * - SRP_IU_RSP: 1, since a conforming SRP target never sends more than
+ *   one unanswered SRP request to an initiator.
  */
 static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
-					enum srp_request_type req_type)
+				      enum srp_tx_iu_type iu_type)
 {
-	s32 rsv = (req_type == SRP_REQ_TASK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
+	s32 rsv = (iu_type == SRP_IU_REQ_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
 
 	srp_send_completion(target->send_cq, target);
 
@@ -1009,7 +1105,8 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
  * req_lim and tx_head.
  */
 static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len)
+			   struct srp_iu *iu, int len,
+			   enum srp_send_iu_type iu_type)
 {
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
@@ -1030,7 +1127,8 @@ static int __srp_post_send(struct srp_target_port *target,
 
 	if (!ret) {
 		++target->tx_head;
-		--target->req_lim;
+		if (iu_type == SRP_SEND_REQ)
+			--target->req_lim;
 	}
 
 	return ret;
@@ -1056,7 +1154,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		return 0;
 	}
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_NORMAL);
+	iu = __srp_get_tx_iu(target, SRP_IU_REQ_NORMAL);
 	if (!iu)
 		goto err;
 
@@ -1093,7 +1191,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (__srp_post_send(target, iu, len)) {
+	if (__srp_post_send(target, iu, len, SRP_SEND_REQ)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
@@ -1363,7 +1461,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	init_completion(&req->done);
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_TASK_MGMT);
+	iu = __srp_get_tx_iu(target, SRP_IU_REQ_TSK_MGMT);
 	if (!iu)
 		goto out;
 
@@ -1376,7 +1474,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;
 
-	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
+	if (__srp_post_send(target, iu, sizeof *tsk_mgmt, SRP_SEND_REQ))
 		goto out;
 
 	req->tsk_mgmt = iu;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 65be406..e0ec00f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -82,9 +82,15 @@ enum srp_target_state {
 	SRP_TARGET_REMOVED
 };
 
-enum srp_request_type {
-	SRP_REQ_NORMAL,
-	SRP_REQ_TASK_MGMT,
+enum srp_tx_iu_type {
+	SRP_IU_REQ_NORMAL,
+	SRP_IU_REQ_TSK_MGMT,
+	SRP_IU_RSP,
+};
+
+enum srp_send_iu_type {
+	SRP_SEND_REQ,
+	SRP_SEND_RSP,
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
