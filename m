From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 7/7] IB/srp: Fix a race condition between failing I/O and
 I/O queueing
Date: Mon, 10 Mar 2014 12:47:19 +0100
Message-ID: <531DA647.1090206@acm.org>
References: <531DA483.3010400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531DA483.3010400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that srp_unmap_data() can get invoked concurrently by
srp_terminate_io() and from the error path in srp_queuecommand()
if srp_post_send() fails.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 46 +++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a64e469..c7091ef 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -783,6 +783,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
  * srp_claim_req - Take ownership of the scmnd associated with a request.
  * @target: SRP target port.
  * @req: SRP request.
+ * @sdev: If not NULL, only take ownership for this SCSI device.
  * @scmnd: If NULL, take ownership of @req->scmnd. If not NULL, only take
  *         ownership of @req->scmnd if it equals @scmnd.
  *
@@ -791,16 +792,17 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
  */
 static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
 				       struct srp_request *req,
+				       struct scsi_device *sdev,
 				       struct scsi_cmnd *scmnd)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&target->lock, flags);
-	if (!scmnd) {
+	if (req->scmnd &&
+	    (!sdev || req->scmnd->device == sdev) &&
+	    (!scmnd || req->scmnd == scmnd)) {
 		scmnd = req->scmnd;
 		req->scmnd = NULL;
-	} else if (req->scmnd == scmnd) {
-		req->scmnd = NULL;
 	} else {
 		scmnd = NULL;
 	}
@@ -827,9 +829,10 @@ static void srp_free_req(struct srp_target_port *target,
 }
 
 static void srp_finish_req(struct srp_target_port *target,
-			   struct srp_request *req, int result)
+			   struct srp_request *req, struct scsi_device *sdev,
+			   int result)
 {
-	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
+	struct scsi_cmnd *scmnd = srp_claim_req(target, req, sdev, NULL);
 
 	if (scmnd) {
 		srp_free_req(target, req, scmnd, 0);
@@ -845,7 +848,7 @@ static void srp_terminate_io(struct srp_rport *rport)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
-		srp_finish_req(target, req, DID_TRANSPORT_FAILFAST << 16);
+		srp_finish_req(target, req, NULL, DID_TRANSPORT_FAILFAST << 16);
 	}
 }
 
@@ -882,7 +885,7 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
-		srp_finish_req(target, req, DID_RESET << 16);
+		srp_finish_req(target, req, NULL, DID_RESET << 16);
 	}
 
 	INIT_LIST_HEAD(&target->free_tx);
@@ -1290,7 +1293,7 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		complete(&target->tsk_mgmt_done);
 	} else {
 		req = &target->req_ring[rsp->tag];
-		scmnd = srp_claim_req(target, req, NULL);
+		scmnd = srp_claim_req(target, req, NULL, NULL);
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %016llx\n",
@@ -1509,7 +1512,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	unsigned long flags;
-	int len, result;
+	int len, result, ret = 0;
 	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
 
 	/*
@@ -1552,8 +1555,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	cmd->tag    = req->index;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
-	req->scmnd    = scmnd;
-	req->cmd      = iu;
+	req->cmd = iu;
 
 	len = srp_map_data(scmnd, target, req);
 	if (len < 0) {
@@ -1565,7 +1567,14 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	ib_dma_sync_single_for_device(dev, iu->dma, target->max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (srp_post_send(target, iu, len)) {
+	spin_lock_irqsave(&target->lock, flags);
+	if (srp_post_send(target, iu, len) == 0)
+		req->scmnd = scmnd;
+	else
+		ret = SCSI_MLQUEUE_HOST_BUSY;
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
@@ -1574,7 +1583,7 @@ unlock_rport:
 	if (in_scsi_eh)
 		mutex_unlock(&rport->mutex);
 
-	return 0;
+	return ret;
 
 err_unmap:
 	srp_unmap_data(scmnd, target, req);
@@ -1588,10 +1597,8 @@ err_iu:
 err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
-	if (in_scsi_eh)
-		mutex_unlock(&rport->mutex);
-
-	return SCSI_MLQUEUE_HOST_BUSY;
+	ret = SCSI_MLQUEUE_HOST_BUSY;
+	goto unlock_rport;
 }
 
 /*
@@ -2008,7 +2015,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || !srp_claim_req(target, req, scmnd))
+	if (!req || !srp_claim_req(target, req, NULL, scmnd))
 		return SUCCESS;
 	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
@@ -2039,8 +2046,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
-		if (req->scmnd && req->scmnd->device == scmnd->device)
-			srp_finish_req(target, req, DID_RESET << 16);
+		srp_finish_req(target, req, scmnd->device, DID_RESET << 16);
 	}
 
 	return SUCCESS;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
