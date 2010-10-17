From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 2/5] IB/srp: implement SRP_CRED_REQ and SRP_AER_REQ
Date: Sat, 16 Oct 2010 23:25:22 -0400
Message-ID: <1287285925-11710-3-git-send-email-dillowda@ornl.gov>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287285925-11710-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds support for SRP_CRED_REQ to avoid a lockup by targets
that use that mechanism to return credits to the initiator. This
prevents a lockup observed in the field where we would never add the
credits from the SRP_CRED_REQ to our current count, and would therefore
never send another command to the target.

Minimal support for SRP_AER_REQ is also added, as these messages can
also be used to convey additional credits to the initiator.

Based upon extensive debugging and code by Bart Van Assche and a bug
report by Chris Worley.

Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  105 ++++++++++++++++++++++++++++++++--
 drivers/infiniband/ulp/srp/ib_srp.h |    8 ++-
 include/scsi/srp.h                  |   38 +++++++++++++
 3 files changed, 141 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b8b09a4..a54eee9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -83,6 +83,10 @@ static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
+static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
+				      enum srp_iu_type iu_type);
+static int __srp_post_send(struct srp_target_port *target,
+			   struct srp_iu *iu, int len);
 
 static struct scsi_transport_template *ib_srp_transport_template;
 
@@ -896,6 +900,71 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
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
+	iu = __srp_get_tx_iu(target, SRP_IU_RSP);
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
+	err = __srp_post_send(target, iu, len);
+	if (err)
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "unable to post response: %d\n", err);
+
+out:
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+	return err;
+}
+
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
+				struct srp_aer_req *req)
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
@@ -923,6 +992,14 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 		srp_process_rsp(target, iu->buf);
 		break;
 
+	case SRP_CRED_REQ:
+		srp_process_cred_req(target, iu->buf);
+		break;
+
+	case SRP_AER_REQ:
+		srp_process_aer_req(target, iu->buf);
+		break;
+
 	case SRP_T_LOGOUT:
 		/* XXX Handle target logout */
 		shost_printk(KERN_WARNING, target->scsi_host,
@@ -985,23 +1062,36 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
  * Must be called with target->scsi_host->host_lock held to protect
  * req_lim and tx_head.  Lock cannot be dropped between call here and
  * call to __srp_post_send().
+ *
+ * Note:
+ * An upper limit for the number of allocated information units for each
+ * request type is:
+ * - SRP_IU_CMD: SRP_CMD_SQ_SIZE, since the SCSI mid-layer never queues
+ *   more than Scsi_Host.can_queue requests.
+ * - SRP_IU_TSK_MGMT: SRP_TSK_MGMT_SQ_SIZE.
+ * - SRP_IU_RSP: 1, since a conforming SRP target never sends more than
+ *   one unanswered SRP request to an initiator.
  */
 static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
-					enum srp_request_type req_type)
+				      enum srp_iu_type iu_type)
 {
-	s32 rsv = (req_type == SRP_REQ_TASK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
+	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
+	struct srp_iu *iu;
 
 	srp_send_completion(target->send_cq, target);
 
 	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
 		return NULL;
 
-	if (target->req_lim <= rsv) {
+	/* Initiator responses to target requests do not consume credits */
+	if (target->req_lim <= rsv && iu_type != SRP_IU_RSP) {
 		++target->zero_req_lim;
 		return NULL;
 	}
 
-	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
+	iu = target->tx_ring[target->tx_head & SRP_SQ_MASK];
+	iu->type = iu_type;
+	return iu;
 }
 
 /*
@@ -1030,7 +1120,8 @@ static int __srp_post_send(struct srp_target_port *target,
 
 	if (!ret) {
 		++target->tx_head;
-		--target->req_lim;
+		if (iu->type != SRP_IU_RSP)
+			--target->req_lim;
 	}
 
 	return ret;
@@ -1056,7 +1147,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		return 0;
 	}
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_NORMAL);
+	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
 	if (!iu)
 		goto err;
 
@@ -1363,7 +1454,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	init_completion(&req->done);
 
-	iu = __srp_get_tx_iu(target, SRP_REQ_TASK_MGMT);
+	iu = __srp_get_tx_iu(target, SRP_IU_TSK_MGMT);
 	if (!iu)
 		goto out;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 7a959d5..ed0dce9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -82,9 +82,10 @@ enum srp_target_state {
 	SRP_TARGET_REMOVED
 };
 
-enum srp_request_type {
-	SRP_REQ_NORMAL,
-	SRP_REQ_TASK_MGMT,
+enum srp_iu_type {
+	SRP_IU_CMD,
+	SRP_IU_TSK_MGMT,
+	SRP_IU_RSP,
 };
 
 struct srp_device {
@@ -171,6 +172,7 @@ struct srp_iu {
 	void		       *buf;
 	size_t			size;
 	enum dma_data_direction	direction;
+	enum srp_iu_type	type;
 };
 
 #endif /* IB_SRP_H */
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
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
