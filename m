From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/3 v4] IB/srp: Implement SRP_CRED_REQ
Date: Fri, 13 Aug 2010 15:55:20 -0400
Message-ID: <1281729320.2437.142.camel@lap75545.ornl.gov>
References: <201008102033.57038.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008102033.57038.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-10 at 20:33 +0200, Bart Van Assche wrote:
> Implements SRP_CRED_REQ, which is an information unit defined in the SRP
> (draft) standard and that allows an SRP target to inform an SRP initiator that
> more requests may be sent by the initiator. Adds declarations for the
> SRP_CRED_REQ and SRP_CRED_RSP information units to include/scsi/srp.h.

I don't seem to be communicating my comments very clearly, so let me try
the language of code. Here's a proposed alternative version. Compile
tested only, based on your patch 1/3 v4, with the __srp_get_tx_iu()
changes partially reverted. It would need to be rebased once you send a
revised 1/3 and would need testing.

And, again, I don't care who's name this goes in under.
---
IB/srp: minimal support for SRP_CRED_REQ and SRP_AER_REQ

This patch adds support for SRP_CRED_REQ to avoid a lockup by targets
that use that mechanism to return credits to the initiator. This
prevents a lockup observed in the field where we would never add the
credits from the SRP_CRED_REQ to our current count, and would therefore
never send another command to the target.

Minimal support for SRP_AER_REQ is also added, as these messages can
also be used to convey additional credits to the initiator.

Based upon extensive debugging work and initial code by Bart Van Assche
and a bug report by Chris Worley.

 drivers/infiniband/ulp/srp/ib_srp.c |   82 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 include/scsi/srp.h                  |   38 ++++++++++++++++
 3 files changed, 119 insertions(+), 2 deletions(-)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 9716e72..91e5a54 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -83,6 +83,8 @@ static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
+static int srp_response_common(struct srp_target_port *target, s32 req_delta,
+			       void *rsp, int len);
 
 static struct scsi_transport_template *ib_srp_transport_template;
 
@@ -896,6 +898,37 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
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
@@ -923,6 +956,14 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
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
@@ -996,7 +1037,8 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
 		return NULL;
 
-	if (target->req_lim < min) {
+	/* Initiator responses to target requests do not consume credits */
+	if (req_type != SRP_RESPONSE && target->req_lim < min) {
 		++target->zero_req_lim;
 		return NULL;
 	}
@@ -1013,6 +1055,7 @@ static int __srp_post_send(struct srp_target_port *target,
 {
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
+	u8 opcode = *(u8 *)iu->buf;
 	int ret = 0;
 
 	list.addr   = iu->dma;
@@ -1030,7 +1073,8 @@ static int __srp_post_send(struct srp_target_port *target,
 
 	if (!ret) {
 		++target->tx_head;
-		--target->req_lim;
+		if (opcode == SRP_CMD || opcode == SRP_TSK_MGMT)
+			--target->req_lim;
 	}
 
 	return ret;
@@ -1109,6 +1153,40 @@ err:
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
+	iu = __srp_get_tx_iu(target, SRP_RESPONSE);
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
 static int srp_alloc_iu_bufs(struct srp_target_port *target)
 {
 	int i;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 3ff38b2..6226479 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -84,6 +84,7 @@ enum srp_target_state {
 enum srp_request_type {
 	SRP_REQ_NORMAL,
 	SRP_REQ_TASK_MGMT,
+	SRP_RESPONSE,
 };
 
 struct srp_device {
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index ad178fa..f0de85d 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -237,6 +237,44 @@ struct srp_rsp {
 	__be32	sense_data_len;
 	__be32	resp_data_len;
 	u8	data[0];
+};
+
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
 } __attribute__((packed));
 
+struct srp_aer_rsp {
+	u8	opcode;
+	u8	reserved[7];
+	u64	tag;
+};
+
 #endif /* SCSI_SRP_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
