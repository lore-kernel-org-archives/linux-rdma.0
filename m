From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 01/20] ib_srp: Fix a race condition
Date: Thu, 09 Aug 2012 15:43:29 +0000
Message-ID: <5023DAA1.1040507@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the scmnd->scsi_done(scmnd) call in srp_process_rsp()
can trigger a crash by being invoked with scsi_done == NULL. That
could happen if a reply is received during or after a command abort.

BUG: unable to handle kernel NULL pointer dereference at (null)
Call Trace:
 <IRQ>
 [<ffffffffa04ab636>] ? srp_handle_recv+0x216/0x480 [ib_srp]
 [<ffffffffa04ab8ea>] srp_recv_completion+0x4a/0xb0 [ib_srp]
 [<ffffffffa032b497>] mlx4_ib_cq_comp+0x17/0x20 [mlx4_ib]
 [<ffffffffa02519f0>] mlx4_cq_completion+0x40/0x80 [mlx4_core]
 [<ffffffffa02529d3>] mlx4_eq_int+0x543/0x920 [mlx4_core]
 [<ffffffff81071acf>] ? local_clock+0x4f/0x60
 [<ffffffffa0252dc4>] mlx4_msi_x_interrupt+0x14/0x20 [mlx4_core]
 [<ffffffff810b82b5>] handle_irq_event_percpu+0x75/0x240
 [<ffffffff810b84ce>] handle_irq_event+0x4e/0x80
 [<ffffffff810badf5>] handle_edge_irq+0x85/0x130
 [<ffffffff81004355>] handle_irq+0x25/0x40
 [<ffffffff814153cd>] do_IRQ+0x5d/0xe0
 [<ffffffff8140b96c>] common_interrupt+0x6c/0x6c
 <EOI>
Kernel panic - not syncing: Fatal exception in interrupt

Reported-by: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Reference: http://marc.info/?l=linux-rdma&m=134314367801595
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   82 ++++++++++++++++++++++++----------
 1 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bcbf22e..9a61be2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -586,24 +586,61 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
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
+ * @req_lim_delta: target->req_lim_delta increment.
+ *
+ * Return value:
+ * Either NULL or a pointer to the SCSI command the caller became owner of.
+ */
+static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
+				       struct srp_request *req,
+				       struct scsi_cmnd *scmnd,
+				       s32 req_lim_delta)
 {
 	unsigned long flags;
 
-	srp_unmap_data(req->scmnd, target, req);
 	spin_lock_irqsave(&target->lock, flags);
 	target->req_lim += req_lim_delta;
-	req->scmnd = NULL;
+	if (!scmnd)
+		swap(scmnd, req->scmnd);
+	else if (req->scmnd == scmnd)
+		req->scmnd = NULL;
+	else
+		scmnd = NULL;
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	return scmnd;
+}
+
+/**
+ * srp_free_req() - Unmap data and add request to the free request list.
+ */
+static void srp_free_req(struct srp_target_port *target,
+			 struct srp_request *req, struct scsi_cmnd *scmnd)
+{
+	unsigned long flags;
+
+	srp_unmap_data(scmnd, target, req);
+
+	spin_lock_irqsave(&target->lock, flags);
 	list_add_tail(&req->list, &target->free_reqs);
 	spin_unlock_irqrestore(&target->lock, flags);
 }
 
 static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
 {
-	req->scmnd->result = DID_RESET << 16;
-	req->scmnd->scsi_done(req->scmnd);
-	srp_remove_req(target, req, 0);
+	struct scsi_cmnd *scmnd = req->scmnd;
+
+	if (srp_claim_req(target, req, scmnd, 0)) {
+		scmnd->result = DID_RESET << 16;
+		scmnd->scsi_done(scmnd);
+		srp_free_req(target, req, scmnd);
+	}
 }
 
 static int srp_reconnect_target(struct srp_target_port *target)
@@ -1073,11 +1110,14 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		complete(&target->tsk_mgmt_done);
 	} else {
 		req = &target->req_ring[rsp->tag];
-		scmnd = req->scmnd;
-		if (!scmnd)
+		scmnd = srp_claim_req(target, req, NULL,
+			       be32_to_cpu(rsp->req_lim_delta));
+		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %016llx\n",
 				     (unsigned long long) rsp->tag);
+			return;
+		}
 		scmnd->result = rsp->status;
 
 		if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
@@ -1092,7 +1132,8 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
 
-		srp_remove_req(target, req, be32_to_cpu(rsp->req_lim_delta));
+		srp_free_req(target, req, scmnd);
+
 		scmnd->host_scribble = NULL;
 		scmnd->scsi_done(scmnd);
 	}
@@ -1631,25 +1672,18 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
-	int ret = SUCCESS;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error)
+	if (!req || target->qp_in_error ||
+	    !srp_claim_req(target, req, scmnd, 0))
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
+	srp_free_req(target, req, scmnd);
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
