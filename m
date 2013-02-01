From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH for 3.8 v3, resend 3/3] IB/srp: Avoid endless SCSI error handling
 loop
Date: Fri, 01 Feb 2013 16:21:19 +0100
Message-ID: <510BDD6F.4060703@acm.org>
References: <510BDCAA.204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510BDCAA.204-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a SCSI command times out it is passed to the SCSI error
handler. The SCSI error handler will try to abort the commands
that timed out. If aborting failed a device reset will be
attempted. If the device reset also fails a host reset will
be attempted. If the host reset also fails the whole procedure
will be repeated.

srp_abort() and srp_reset_device() fail for a QP in the error
state. srp_reset_host() fails after host removal has started.
Hence if the SCSI error handler gets invoked after host removal
has started and with the QP in the error state an endless loop
will be triggered.

Modify the SCSI error handling functions in ib_srp as follows:
- Abort SCSI commands properly even if the QP is in the error
  state.
- Make srp_reset_host() reset SCSI requests even after host
  removal has already started or if reconnecting fails.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2633258..8a7eb9f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -700,23 +700,24 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	struct Scsi_Host *shost = target->scsi_host;
 	int i, ret;
 
-	if (target->state != SRP_TARGET_LIVE)
-		return -EAGAIN;
-
 	scsi_target_block(&shost->shost_gendev);
 
 	srp_disconnect_target(target);
 	/*
-	 * Now get a new local CM ID so that we avoid confusing the
-	 * target in case things are really fouled up.
+	 * Now get a new local CM ID so that we avoid confusing the target in
+	 * case things are really fouled up. Doing so also ensures that all CM
+	 * callbacks will have finished before a new QP is allocated.
 	 */
 	ret = srp_new_cm_id(target);
-	if (ret)
-		goto unblock;
-
-	ret = srp_create_target_ib(target);
-	if (ret)
-		goto unblock;
+	/*
+	 * Whether or not creating a new CM ID succeeded, create a new
+	 * QP. This guarantees that all completion callback function
+	 * invocations have finished before request resetting starts.
+	 */
+	if (ret == 0)
+		ret = srp_create_target_ib(target);
+	else
+		srp_create_target_ib(target);
 
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
@@ -728,9 +729,9 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
-	ret = srp_connect_target(target);
+	if (ret == 0)
+		ret = srp_connect_target(target);
 
-unblock:
 	scsi_target_unblock(&shost->shost_gendev, ret == 0 ? SDEV_RUNNING :
 			    SDEV_TRANSPORT_OFFLINE);
 
@@ -1739,7 +1740,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error || !srp_claim_req(target, req, scmnd))
+	if (!req || !srp_claim_req(target, req, scmnd))
 		return FAILED;
 	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			  SRP_TSK_ABORT_TASK);
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
