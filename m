From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 07/10] IB/srp: Add periodic reconnect functionality
Date: Sat, 26 Oct 2013 14:37:17 +0200
Message-ID: <526BB77D.1090603@acm.org>
References: <526BB5AC.7010601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526BB5AC.7010601-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After a transport layer occurred, periodically try to reconnect
to the target until the dev_loss timer expires.  Protect the
callback functions that can be invoked from inside the SCSI EH
against concurrent invocation with srp_reconnect_rport() via the
rport mutex. Change the default dev_loss_tmo from 60s into 600s
to give the reconnect mechanism a chance to kick in.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 52 ++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a120658..4be3eb8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -88,6 +88,11 @@ MODULE_PARM_DESC(topspin_workarounds,
 
 static struct kernel_param_ops srp_tmo_ops;
 
+static int srp_reconnect_delay = 10;
+module_param_cb(reconnect_delay, &srp_tmo_ops, &srp_reconnect_delay,
+		S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(reconnect_delay, "Time between successive reconnect attempts");
+
 static int srp_fast_io_fail_tmo = 15;
 module_param_cb(fast_io_fail_tmo, &srp_tmo_ops, &srp_fast_io_fail_tmo,
 		S_IRUGO | S_IWUSR);
@@ -96,7 +101,7 @@ MODULE_PARM_DESC(fast_io_fail_tmo,
 		 " layer error and failing all I/O. \"off\" means that this"
 		 " functionality is disabled.");
 
-static int srp_dev_loss_tmo = 60;
+static int srp_dev_loss_tmo = 600;
 module_param_cb(dev_loss_tmo, &srp_tmo_ops, &srp_dev_loss_tmo,
 		S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,
@@ -144,10 +149,14 @@ static int srp_tmo_set(const char *val, const struct kernel_param *kp)
 	} else {
 		tmo = -1;
 	}
-	if (kp->arg == &srp_fast_io_fail_tmo)
-		res = srp_tmo_valid(-1, tmo, srp_dev_loss_tmo);
+	if (kp->arg == &srp_reconnect_delay)
+		res = srp_tmo_valid(tmo, srp_fast_io_fail_tmo,
+				    srp_dev_loss_tmo);
+	else if (kp->arg == &srp_fast_io_fail_tmo)
+		res = srp_tmo_valid(srp_reconnect_delay, tmo, srp_dev_loss_tmo);
 	else
-		res = srp_tmo_valid(-1, srp_fast_io_fail_tmo, tmo);
+		res = srp_tmo_valid(srp_reconnect_delay, srp_fast_io_fail_tmo,
+				    tmo);
 	if (res)
 		goto out;
 	*(int *)kp->arg = tmo;
@@ -1426,18 +1435,29 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(shost);
+	struct srp_rport *rport = target->rport;
 	struct srp_request *req;
 	struct srp_iu *iu;
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	unsigned long flags;
 	int len, result;
+	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
+
+	/*
+	 * The SCSI EH thread is the only context from which srp_queuecommand()
+	 * can get invoked for blocked devices (SDEV_BLOCK /
+	 * SDEV_CREATED_BLOCK). Avoid racing with srp_reconnect_rport() by
+	 * locking the rport mutex if invoked from inside the SCSI EH.
+	 */
+	if (in_scsi_eh)
+		mutex_lock(&rport->mutex);
 
 	result = srp_chkready(target->rport);
 	if (unlikely(result)) {
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
-		return 0;
+		goto unlock_rport;
 	}
 
 	spin_lock_irqsave(&target->lock, flags);
@@ -1482,6 +1502,10 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		goto err_unmap;
 	}
 
+unlock_rport:
+	if (in_scsi_eh)
+		mutex_unlock(&rport->mutex);
+
 	return 0;
 
 err_unmap:
@@ -1496,6 +1520,9 @@ err_iu:
 err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
+	if (in_scsi_eh)
+		mutex_unlock(&rport->mutex);
+
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
@@ -1780,6 +1807,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
 			     u64 req_tag, unsigned int lun, u8 func)
 {
+	struct srp_rport *rport = target->rport;
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
@@ -1789,12 +1817,20 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	init_completion(&target->tsk_mgmt_done);
 
+	/*
+	 * Lock the rport mutex to avoid that srp_create_target_ib() is
+	 * invoked while a task management function is being sent.
+	 */
+	mutex_lock(&rport->mutex);
 	spin_lock_irq(&target->lock);
 	iu = __srp_get_tx_iu(target, SRP_IU_TSK_MGMT);
 	spin_unlock_irq(&target->lock);
 
-	if (!iu)
+	if (!iu) {
+		mutex_unlock(&rport->mutex);
+
 		return -1;
+	}
 
 	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mgmt,
 				   DMA_TO_DEVICE);
@@ -1811,8 +1847,11 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 				      DMA_TO_DEVICE);
 	if (srp_post_send(target, iu, sizeof *tsk_mgmt)) {
 		srp_put_tx_iu(target, iu, SRP_IU_TSK_MGMT);
+		mutex_unlock(&rport->mutex);
+
 		return -1;
 	}
+	mutex_unlock(&rport->mutex);
 
 	if (!wait_for_completion_timeout(&target->tsk_mgmt_done,
 					 msecs_to_jiffies(SRP_ABORT_TIMEOUT_MS)))
@@ -2713,6 +2752,7 @@ static void srp_remove_one(struct ib_device *device)
 static struct srp_function_template ib_srp_transport_functions = {
 	.has_rport_state	 = true,
 	.reset_timer_if_blocked	 = true,
+	.reconnect_delay	 = &srp_reconnect_delay,
 	.fast_io_fail_tmo	 = &srp_fast_io_fail_tmo,
 	.dev_loss_tmo		 = &srp_dev_loss_tmo,
 	.reconnect		 = srp_rport_reconnect,
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
