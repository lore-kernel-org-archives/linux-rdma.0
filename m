From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v3 09/13] IB/srp: Use SRP transport layer error recovery
Date: Wed, 03 Jul 2013 14:56:47 +0200
Message-ID: <51D41F8F.4030303@acm.org>
References: <51D41C03.4020607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D41C03.4020607-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enable reconnect_delay, fast_io_fail_tmo and dev_loss_tmo
functionality for the IB SRP initiator. Add kernel module
parameters that allow to specify default values for these
three parameters.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  123 +++++++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 -
 2 files changed, 88 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8ba4e9c..0f69ae1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -86,6 +86,31 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
+static int srp_reconnect_delay = 10;
+module_param_named(reconnect_delay, srp_reconnect_delay, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(reconnect_delay, "Time between successive reconnect attempts");
+
+static struct kernel_param_ops srp_tmo_ops;
+
+static int srp_fast_io_fail_tmo = 15;
+module_param_cb(fast_io_fail_tmo, &srp_tmo_ops, &srp_fast_io_fail_tmo,
+		S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fast_io_fail_tmo,
+		 "Number of seconds between the observation of a transport"
+		 " layer error and failing all I/O. \"off\" means that this"
+		 " functionality is disabled.");
+
+static int srp_dev_loss_tmo = 600;
+module_param_cb(dev_loss_tmo, &srp_tmo_ops, &srp_dev_loss_tmo,
+		S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(dev_loss_tmo,
+		 "Maximum number of seconds that the SRP transport should"
+		 " insulate transport layer errors. After this time has been"
+		 " exceeded the SCSI target is removed. Should be"
+		 " between 1 and " __stringify(SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		 " if fast_io_fail_tmo has not been set. \"off\" means that"
+		 " this functionality is disabled.");
+
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
@@ -102,6 +127,44 @@ static struct ib_client srp_client = {
 
 static struct ib_sa_client srp_sa_client;
 
+static int srp_tmo_get(char *buffer, const struct kernel_param *kp)
+{
+	int tmo = *(int *)kp->arg;
+
+	if (tmo >= 0)
+		return sprintf(buffer, "%d", tmo);
+	else
+		return sprintf(buffer, "off");
+}
+
+static int srp_tmo_set(const char *val, const struct kernel_param *kp)
+{
+	int tmo, res;
+
+	if (strncmp(val, "off", 3) != 0) {
+		res = kstrtoint(val, 0, &tmo);
+		if (res)
+			goto out;
+	} else {
+		tmo = -1;
+	}
+	if (kp->arg == &srp_fast_io_fail_tmo)
+		res = srp_tmo_valid(tmo, srp_dev_loss_tmo);
+	else
+		res = srp_tmo_valid(srp_fast_io_fail_tmo, tmo);
+	if (res)
+		goto out;
+	*(int *)kp->arg = tmo;
+
+out:
+	return res;
+}
+
+static struct kernel_param_ops srp_tmo_ops = {
+	.get = srp_tmo_get,
+	.set = srp_tmo_set,
+};
+
 static inline struct srp_target_port *host_to_target(struct Scsi_Host *host)
 {
 	return (struct srp_target_port *) host->hostdata;
@@ -709,13 +772,20 @@ static void srp_terminate_io(struct srp_rport *rport)
 	}
 }
 
-static int srp_reconnect_target(struct srp_target_port *target)
+/*
+ * It is up to the caller to ensure that srp_rport_reconnect() calls are
+ * serialized and that no concurrent srp_queuecommand(), srp_abort(),
+ * srp_reset_device() or srp_reset_host() calls will occur while this function
+ * is in progress. One way to realize that is not to call this function
+ * directly but to call srp_reconnect_rport() instead since that last function
+ * serializes calls of this function via rport->mutex and also blocks
+ * srp_queuecommand() calls before invoking this function.
+ */
+static int srp_rport_reconnect(struct srp_rport *rport)
 {
-	struct Scsi_Host *shost = target->scsi_host;
+	struct srp_target_port *target = rport->lld_data;
 	int i, ret;
 
-	scsi_target_block(&shost->shost_gendev);
-
 	srp_disconnect_target(target);
 	/*
 	 * Now get a new local CM ID so that we avoid confusing the target in
@@ -745,28 +815,9 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret == 0)
 		ret = srp_connect_target(target);
 
-	scsi_target_unblock(&shost->shost_gendev, ret == 0 ? SDEV_RUNNING :
-			    SDEV_TRANSPORT_OFFLINE);
-	target->transport_offline = !!ret;
-
-	if (ret)
-		goto err;
-
-	shost_printk(KERN_INFO, target->scsi_host, PFX "reconnect succeeded\n");
-
-	return ret;
-
-err:
-	shost_printk(KERN_ERR, target->scsi_host,
-		     PFX "reconnect failed (%d), removing target port.\n", ret);
-
-	/*
-	 * We couldn't reconnect, so kill our target port off.
-	 * However, we have to defer the real removal because we
-	 * are in the context of the SCSI error handler now, which
-	 * will deadlock if we call scsi_remove_host().
-	 */
-	srp_queue_remove_work(target);
+	if (ret == 0)
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "reconnect succeeded\n");
 
 	return ret;
 }
@@ -1365,10 +1416,11 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	unsigned long flags;
-	int len;
+	int len, result;
 
-	if (unlikely(target->transport_offline)) {
-		scmnd->result = DID_NO_CONNECT << 16;
+	result = srp_chkready(target->rport);
+	if (unlikely(result)) {
+		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 		return 0;
 	}
@@ -1766,7 +1818,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
-	else if (target->transport_offline)
+	else if (target->rport->state == SRP_RPORT_LOST)
 		ret = FAST_IO_FAIL;
 	else
 		ret = FAILED;
@@ -1802,14 +1854,10 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 static int srp_reset_host(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	int ret = FAILED;
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
 
-	if (!srp_reconnect_target(target))
-		ret = SUCCESS;
-
-	return ret;
+	return srp_reconnect_rport(target->rport) == 0 ? SUCCESS : FAILED;
 }
 
 static int srp_slave_configure(struct scsi_device *sdev)
@@ -2604,6 +2652,11 @@ static void srp_remove_one(struct ib_device *device)
 }
 
 static struct srp_function_template ib_srp_transport_functions = {
+	.has_rport_state	 = true,
+	.reconnect_delay	 = &srp_reconnect_delay,
+	.fast_io_fail_tmo	 = &srp_fast_io_fail_tmo,
+	.dev_loss_tmo		 = &srp_dev_loss_tmo,
+	.reconnect		 = srp_rport_reconnect,
 	.rport_delete		 = srp_rport_delete,
 	.terminate_rport_io	 = srp_terminate_io,
 };
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 1817ed5..fda82f7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -140,7 +140,6 @@ struct srp_target_port {
 	unsigned int		cmd_sg_cnt;
 	unsigned int		indirect_size;
 	bool			allow_ext_sg;
-	bool			transport_offline;
 
 	/* Everything above this point is used in the hot path of
 	 * command processing. Try to keep them packed into cachelines.
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
