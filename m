From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 01/20 v4b] ib_srp: Fix a race condition
Date: Tue, 14 Aug 2012 13:18:53 +0000
Message-ID: <502A503D.5030604@acm.org>
References: <5023DA39.7020000@acm.org> <5023DAA1.1040507@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DAA1.1040507-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the scmnd->scsi_done(scmnd) call in srp_process_rsp()
can trigger a crash by being invoked with scsi_done == NULL. That
could happen if a reply is received during or after a command abort.

Reported-by: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Reference: http://marc.info/?l=linux-rdma&m=134314367801595
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   87 +++++++++++++++++++++++++----------
 1 files changed, 63 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bcbf22e..1b5b0c7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -586,24 +586,62 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 			scmnd->sc_data_direction);
 }
 
-static void srp_remove_req(struct srp_target_port *target,
-			   struct srp_request *req, s32 req_lim_delta)
+/**
+ * srp_claim_req - Take ownership of the scmnd associated with a request.
+ * @target: SRP target port.
+ * @req: SRP request.
+ * @scmnd: If NULL, take ownership of @req->scmnd. If not NULL, only take
+ *         ownership of @req->scmnd if it equals @scmnd.
+ *
+ * Return value:
+ * Either NULL or a pointer to the SCSI command the caller became owner of.
+ */
+static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
+				       struct srp_request *req,
+				       struct scsi_cmnd *scmnd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&target->lock, flags);
+	if (!scmnd) {
+		scmnd = req->scmnd;
+		req->scmnd = NULL;
+	} else if (req->scmnd == scmnd) {
+		req->scmnd = NULL;
+	} else {
+		scmnd = NULL;
+	}
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	return scmnd;
+}
+
+/**
+ * srp_free_req() - Unmap data and add request to the free request list.
+ */
+static void srp_free_req(struct srp_target_port *target,
+			 struct srp_request *req, struct scsi_cmnd *scmnd,
+			 s32 req_lim_delta)
 {
 	unsigned long flags;
 
-	srp_unmap_data(req->scmnd, target, req);
+	srp_unmap_data(scmnd, target, req);
+
 	spin_lock_irqsave(&target->lock, flags);
 	target->req_lim += req_lim_delta;
-	req->scmnd = NULL;
 	list_add_tail(&req->list, &target->free_reqs);
 	spin_unlock_irqrestore(&target->lock, flags);
 }
 
 static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
 {
-	req->scmnd->result = DID_RESET << 16;
-	req->scmnd->scsi_done(req->scmnd);
-	srp_remove_req(target, req, 0);
+	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
+
+	if (scmnd) {
+		scmnd->result = DID_RESET << 16;
+		scmnd->scsi_done(scmnd);
+		srp_free_req(target, req, scmnd, 0);
+	}
 }
 
 static int srp_reconnect_target(struct srp_target_port *target)
@@ -1073,11 +1111,18 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		complete(&target->tsk_mgmt_done);
 	} else {
 		req = &target->req_ring[rsp->tag];
-		scmnd = req->scmnd;
-		if (!scmnd)
+		scmnd = srp_claim_req(target, req, NULL);
+		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %016llx\n",
 				     (unsigned long long) rsp->tag);
+
+			spin_lock_irqsave(&target->lock, flags);
+			target->req_lim += be32_to_cpu(rsp->req_lim_delta);
+			spin_unlock_irqrestore(&target->lock, flags);
+
+			return;
+		}
 		scmnd->result = rsp->status;
 
 		if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
@@ -1092,7 +1137,9 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
 
-		srp_remove_req(target, req, be32_to_cpu(rsp->req_lim_delta));
+		srp_free_req(target, req, scmnd,
+			     be32_to_cpu(rsp->req_lim_delta));
+
 		scmnd->host_scribble = NULL;
 		scmnd->scsi_done(scmnd);
 	}
@@ -1631,25 +1678,17 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
-	int ret = SUCCESS;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error)
+	if (!req || target->qp_in_error || !srp_claim_req(target, req, scmnd))
 		return FAILED;
-	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
-			      SRP_TSK_ABORT_TASK))
-		return FAILED;
-
-	if (req->scmnd) {
-		if (!target->tsk_mgmt_status) {
-			srp_remove_req(target, req, 0);
-			scmnd->result = DID_ABORT << 16;
-		} else
-			ret = FAILED;
-	}
+	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
+			  SRP_TSK_ABORT_TASK);
+	srp_free_req(target, req, scmnd, 0);
+	scmnd->result = DID_ABORT << 16;
 
-	return ret;
+	return SUCCESS;
 }
 
 static int srp_reset_device(struct scsi_cmnd *scmnd)
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
