From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 18/18] ib_srp: Rework error handling
Date: Sat, 14 Jan 2012 12:57:49 +0000
Message-ID: <2527465.kS0UWM2o6z@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add fast_io_fail_tmo and dev_loss_tmo sysfs attributes. Block
the SCSI target as soon as a transport layer error has been
detected (ping timeout, disconnect or IB error completion). Try
to reconnect until dev_loss_tmo elapses.

Disconnect the IB connection earlier in srp_remove_target() to
make sure that error recovery is not triggered during host
removal. Swap the "connected" and "removed" tests in
srp_queuecommand() because of this change.

Rescan LUNs after having unblocked a SCSI target controlled by
ib_srp.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-transport-srp |   35 ++++
 drivers/infiniband/ulp/srp/ib_srp.c          |  248 ++++++++++++++++++++++++--
 drivers/infiniband/ulp/srp/ib_srp.h          |    9 +
 3 files changed, 280 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index 9b78ace..85d1eba 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -5,6 +5,41 @@ Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	Instructs an SRP initiator to disconnect from a target and to
 		remove all LUNs imported from that target.
 
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/dev_loss_tmo
+Date:		January 1, 2012
+KernelVersion:	3.3
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before removing a target port.
+		Zero means immediate removal.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/fast_io_fail_tmo
+Date:		January 1, 2012
+KernelVersion:	3.3
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of seconds the SCSI layer will wait after a transport
+		layer error has been observed before failing I/O. Zero means
+		immediate removal. A negative value will disable this
+		behavior.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/ping_interval
+Date:		January 1, 2012
+KernelVersion:	3.3
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Time in seconds between two sucessive ping attempts. Setting
+		this parameter to zero or a negative value disables the ping
+		mechanism.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/ping_timeout
+Date:		January 1, 2012
+KernelVersion:	3.3
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	If more time has elapsed than the specified number of seconds
+		since the latest successful ping attempt, the SRP initiator
+		driver that enabled this feature is informed about a transport
+		layer timeout by invoking its rport_ping_timedout callback
+		function.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index eb31a14..36a55e0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2010-2011 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -446,7 +447,16 @@ static bool srp_change_state(struct srp_target_port *target,
 
 static bool srp_change_state_to_removed(struct srp_target_port *target)
 {
-	return srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_REMOVED);
+	bool changed = false;
+
+	spin_lock_irq(&target->lock);
+	if (target->state != SRP_TARGET_REMOVED) {
+		target->state = SRP_TARGET_REMOVED;
+		changed = true;
+	}
+	spin_unlock_irq(&target->lock);
+
+	return changed;
 }
 
 static bool srp_change_conn_state(struct srp_target_port *target,
@@ -511,7 +521,8 @@ static void srp_wait_last_send_wqe(struct srp_target_port *target)
 	WARN_ON(!target->last_send_wqe);
 }
 
-static void srp_disconnect_target(struct srp_target_port *target)
+static void srp_disconnect_target(struct srp_target_port *target,
+				  bool cancel_block_work)
 {
 	struct ib_qp_attr qp_attr;
 	int ret;
@@ -537,6 +548,9 @@ static void srp_disconnect_target(struct srp_target_port *target)
 
 		srp_wait_last_send_wqe(target);
 	}
+
+	if (cancel_block_work)
+		cancel_work_sync(&target->block_work);
 }
 
 static void srp_free_req_data(struct srp_target_port *target)
@@ -572,18 +586,72 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 		device_remove_file(&shost->shost_dev, *attr);
 }
 
+/**
+ * srp_disable_ping() - Stop pinging a target.
+ *
+ * Note: Can be invoked concurrently via the SCSI host sysfs attribute "delete"
+ * and one of the rport callback functions.
+ */
+static void srp_disable_ping(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct srp_target_port *target = host_to_target(shost);
+	struct srp_rport *rport = target->rport;
+
+	if (rport->sdev == sdev) {
+		shost_printk(KERN_DEBUG, target->scsi_host,
+			     PFX "Disabled pinging\n");
+		srp_rport_set_sdev(rport, NULL);
+		srp_rport_disable_ping(rport);
+	}
+}
+
+/*
+ * srp_remove_target() - Remove an SRP target.
+ *
+ * The strategy to remove a target is as follows:
+ * - The caller must have set target->state to SRP_TARGET_REMOVED before
+ *   invoking or queueing this function such that new calls to
+ *   srp_disconnect_target(), srp_reconnect_target() or srp_block_work() do
+ *   not have any effect.
+ * - Remove the sysfs attributes registered by ib_srp such that the registered
+ *   sysfs callback functions won't be invoked anymore.
+ * - Disconnect the IB connection, wait until processing completions finished
+ *   and cancel block_work.
+ * - Unblock the rport such that srp_stop_rport() doesn't deadlock.
+ * - Cancel any asynchronous work started by the SRP transport layer.
+ * - Invoke scsi_remove_host() such that all pending SCSI commands get killed.
+ *   See e.g. sd_probe().
+ * - Cancel any asynchronous work started by ib_srp.
+ * - Tear down the IB resources associated with the target.
+ * - Invoke scsi_host_put() which will also free the target structure.
+ */
 static void srp_remove_target(struct srp_target_port *target)
 {
-	struct Scsi_Host *shost = target->scsi_host;
+	struct Scsi_Host *shost;
+	struct srp_rport *rport;
 
 	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
-	srp_del_scsi_host_attr(shost);
+	/* Wait until any concurrent critical sections have finished. */
+	mutex_lock(&target->mutex);
+	mutex_unlock(&target->mutex);
+
+	shost = target->scsi_host;
+	rport = target->rport;
+	WARN_ON((rport != NULL) != target->scsi_host_added);
+
+	if (target->scsi_host_added)
+		srp_del_scsi_host_attr(shost);
+	srp_disconnect_target(target, true);
 	if (target->scsi_host_added) {
+		srp_resume_io(rport);
+		srp_stop_rport(rport);
 		srp_remove_host(shost);
 		scsi_remove_host(shost);
 	}
-	srp_disconnect_target(target);
+	cancel_work_sync(&target->scan_work);
+	cancel_delayed_work_sync(&target->reconnect_work);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
@@ -645,6 +713,21 @@ static bool srp_conn_unique(struct srp_host *host,
 	return ret;
 }
 
+static void srp_ping_timedout(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+
+	pr_debug("ping timeout: rport = %p; target = %p / state %d\n",
+		 rport, target, target->state);
+
+	mutex_lock(&target->mutex);
+	if (srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_BLOCKED)) {
+		srp_block_rport(rport);
+		srp_start_tl_fail_timers(target->rport);
+	}
+	mutex_unlock(&target->mutex);
+}
+
 static int srp_connect_target(struct srp_target_port *target)
 {
 	int retries = 3;
@@ -676,6 +759,7 @@ static int srp_connect_target(struct srp_target_port *target)
 		switch (target->status) {
 		case 0:
 			srp_change_conn_state(target, true);
+			target->failed_reconnects = 0;
 			return 0;
 
 		case SRP_PORT_REDIRECT:
@@ -754,7 +838,16 @@ static void srp_scan_target(struct srp_target_port *target)
 			 SCAN_WILD_CARD, 0);
 }
 
-static int srp_reconnect_target(struct srp_target_port *target)
+static void srp_scan_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(work, struct srp_target_port, scan_work);
+	srp_scan_target(target);
+}
+
+static int srp_reconnect_target(struct srp_target_port *target,
+				bool cancel_block_work)
 {
 	struct ib_qp_attr qp_attr;
 	int i, ret;
@@ -762,6 +855,11 @@ static int srp_reconnect_target(struct srp_target_port *target)
 
 	unique = srp_conn_unique(target->srp_host, target);
 	if (unique) {
+		mutex_lock(&target->mutex);
+		if (srp_change_state(target, SRP_TARGET_LIVE,
+				     SRP_TARGET_BLOCKED))
+			srp_block_rport(target->rport);
+		mutex_unlock(&target->mutex);
 	} else if (srp_change_state_to_removed(target)) {
 		shost_printk(KERN_INFO, target->scsi_host,
 			     PFX "deleting SCSI host because obsolete.\n");
@@ -774,7 +872,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 		return -EAGAIN;
 	}
 
-	srp_disconnect_target(target);
+	srp_disconnect_target(target, cancel_block_work);
 	/*
 	 * Now get a new local CM ID so that we avoid confusing the
 	 * target in case things are really fouled up.
@@ -806,10 +904,63 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
+	mutex_lock(&target->mutex);
+	if (srp_change_state(target, SRP_TARGET_BLOCKED, SRP_TARGET_LIVE))
+		srp_resume_io(target->rport);
+	else
+		ret = -EAGAIN;
+	mutex_unlock(&target->mutex);
+
+	/*
+	 * Since this code can be invoked from the context of the SCSI error
+	 * handler, invoke SCSI scanning asynchronously.
+	 */
+	if (ret == 0)
+		queue_work(system_long_wq, &target->scan_work);
+
 err:
 	return ret;
 }
 
+/**
+ * srp_reconnect_repeatedly() - Attempt to reconnect repeatedly.
+ *
+ * Return value: True if and only if the reconnect attempt hasn't succeeded
+ * and a subsequent reconnect attempt is scheduled. If the return value is
+ * true that also means that the target and the rport state have been changed
+ * from LIVE into BLOCKED.
+ */
+static void srp_reconnect_repeatedly(struct srp_target_port *target,
+				     bool cancel_block_work)
+{
+	int res, tmo;
+
+	res = srp_reconnect_target(target, cancel_block_work);
+	if (res == 0)
+		return;
+
+	++target->failed_reconnects;
+
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "reconnect attempt %d failed (%d).\n",
+		     target->failed_reconnects, res);
+
+	tmo = target->reconnect_tmo;
+	if (tmo > 0)
+		queue_delayed_work(system_long_wq, &target->reconnect_work,
+				   tmo * HZ);
+}
+
+static void srp_reconnect_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(to_delayed_work(work), struct srp_target_port,
+			      reconnect_work);
+
+	srp_reconnect_repeatedly(target, true);
+}
+
 static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
 			 unsigned int dma_len, u32 rkey)
 {
@@ -1343,15 +1494,30 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
+/*
+ * Start the transport layer failure timers, block the SCSI host and try to
+ * reconnect.
+ */
+static void srp_block_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(work, struct srp_target_port, block_work);
+	srp_start_tl_fail_timers(target->rport);
+	srp_reconnect_repeatedly(target, false);
+}
+
 static void srp_handle_qp_err(enum ib_wc_status wc_status,
 			      enum ib_wc_opcode wc_opcode,
 			      struct srp_target_port *target)
 {
-	if (target->connected && !target->qp_in_error)
+	if (target->connected && !target->qp_in_error) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "failed %s status %d\n",
 			     wc_opcode & IB_WC_RECV ? "receive" : "send",
 			     wc_status);
+		queue_work(system_long_wq, &target->block_work);
+	}
 	target->qp_in_error = true;
 }
 
@@ -1410,15 +1576,15 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (!target->connected)
-		goto err;
-
 	if (target->state == SRP_TARGET_REMOVED) {
 		scmnd->result = DID_BAD_TARGET << 16;
 		scmnd->scsi_done(scmnd);
 		return 0;
 	}
 
+	if (!target->connected)
+		goto err;
+
 	spin_lock_irqsave(&target->lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
 	if (!iu)
@@ -1730,6 +1896,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
+		queue_work(system_long_wq, &target->block_work);
 		break;
 
 	case IB_CM_TIMEWAIT_EXIT:
@@ -1857,7 +2024,7 @@ static int srp_reset_host(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
 
-	res = srp_reconnect_target(target);
+	res = srp_reconnect_target(target, true);
 	if (res == 0)
 		return SUCCESS;
 
@@ -1879,6 +2046,7 @@ static int srp_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct srp_target_port *target = host_to_target(shost);
+	struct srp_rport *rport = target->rport;
 	struct request_queue *q = sdev->request_queue;
 	unsigned long timeout;
 
@@ -1888,6 +2056,12 @@ static int srp_slave_configure(struct scsi_device *sdev)
 		blk_queue_rq_timeout(q, timeout);
 	}
 
+	if (!rport->sdev) {
+		shost_printk(KERN_DEBUG, target->scsi_host,
+			     PFX "Enabled pinging\n");
+		srp_rport_set_sdev(rport, sdev);
+	}
+
 	return 0;
 }
 
@@ -1990,6 +2164,45 @@ static ssize_t show_allow_ext_sg(struct device *dev,
 	return sprintf(buf, "%s\n", target->allow_ext_sg ? "true" : "false");
 }
 
+static ssize_t show_reconnect_tmo(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->reconnect_tmo);
+}
+
+static ssize_t store_reconnect_tmo(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, const size_t count)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+	char ch[16];
+	int res, tmo;
+
+	sprintf(ch, "%.*s", (int)min(sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &tmo);
+	if (res)
+		goto out;
+	target->reconnect_tmo = tmo;
+	if (tmo > 0 && target->state == SRP_TARGET_BLOCKED)
+		queue_delayed_work(system_long_wq, &target->reconnect_work,
+				   tmo * HZ);
+	else if (tmo <= 0)
+		cancel_delayed_work(&target->reconnect_work);
+	res = count;
+out:
+	return res;
+}
+
+static ssize_t show_failed_reconnects(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->failed_reconnects);
+}
+
 static DEVICE_ATTR(id_ext,	    S_IRUGO, show_id_ext,	   NULL);
 static DEVICE_ATTR(ioc_guid,	    S_IRUGO, show_ioc_guid,	   NULL);
 static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
@@ -2002,6 +2215,9 @@ static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
 static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
 static DEVICE_ATTR(allow_ext_sg,    S_IRUGO, show_allow_ext_sg,    NULL);
+static DEVICE_ATTR(reconnect_tmo,   S_IRUGO | S_IWUSR, show_reconnect_tmo,
+		   store_reconnect_tmo);
+static DEVICE_ATTR(failed_reconnects, S_IRUGO, show_failed_reconnects, NULL);
 
 static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_id_ext,
@@ -2016,6 +2232,8 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_local_ib_device,
 	&dev_attr_cmd_sg_entries,
 	&dev_attr_allow_ext_sg,
+	&dev_attr_reconnect_tmo,
+	&dev_attr_failed_reconnects,
 	NULL
 };
 
@@ -2024,6 +2242,7 @@ static struct scsi_host_template srp_template = {
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
 	.slave_configure		= srp_slave_configure,
+	.slave_delete			= srp_disable_ping,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.eh_abort_handler		= srp_abort,
@@ -2038,6 +2257,7 @@ static struct scsi_host_template srp_template = {
 };
 
 static struct srp_function_template ib_srp_transport_functions = {
+	.rport_ping_timedout	 = srp_ping_timedout,
 	.rport_delete		 = srp_rport_delete,
 };
 
@@ -2351,7 +2571,11 @@ static ssize_t srp_create_target(struct device *dev,
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
 	mutex_init(&target->mutex);
+	INIT_WORK(&target->block_work, srp_block_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
+	INIT_WORK(&target->scan_work, srp_scan_work);
+	INIT_DELAYED_WORK(&target->reconnect_work, srp_reconnect_work);
+	target->reconnect_tmo = 10;
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index a603c6d..e76000e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -83,11 +83,14 @@ enum {
  * @SRP_TARGET_CONNECTING: IB connection being established and SCSI host being
  *                      added.
  * @SRP_TARGET_LIVE: IB RC connection is established and SCSI host is unblocked.
+ * @SRP_TARGET_BLOCKED: An IB RC error occurred. Recovery timer may be running.
+ *                      SCSI host is blocked.
  * @SRP_TARGET_REMOVED: SCSI host removal is pending.
  */
 enum srp_target_state {
 	SRP_TARGET_CONNECTING,
 	SRP_TARGET_LIVE,
+	SRP_TARGET_BLOCKED,
 	SRP_TARGET_REMOVED,
 };
 
@@ -186,7 +189,13 @@ struct srp_target_port {
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
+	struct work_struct	block_work;
 	struct work_struct	remove_work;
+	struct work_struct	scan_work;
+
+	int			reconnect_tmo;
+	int			failed_reconnects;
+	struct delayed_work	reconnect_work;
 
 	struct list_head	list;
 	struct completion	done;
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
