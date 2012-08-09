From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 20/20] ib_srp: Add dev_loss_tmo support
Date: Thu, 09 Aug 2012 16:04:01 +0000
Message-ID: <5023DF71.5070601@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove an SRP host if either dev_loss_tmo expired or the target
closed the IB connection.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   53 +++++++++++++++++++++++++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b1af74a..81b4432 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -603,17 +603,23 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 static void srp_remove_target(struct srp_target_port *target)
 {
 	struct Scsi_Host *shost = target->scsi_host;
+	struct srp_rport *rport = target->rport;
+	bool scsi_host_added = false;
 
 	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
 	mutex_lock(&target->mutex);
-	if (target->scsi_host_added) {
+	swap(target->scsi_host_added, scsi_host_added);
+	mutex_unlock(&target->mutex);
+
+	if (scsi_host_added) {
 		srp_del_scsi_host_attr(shost);
+		srp_stop_rport(rport);
 		srp_remove_host(shost);
 		scsi_remove_host(shost);
 	}
-	mutex_unlock(&target->mutex);
 	srp_disconnect_target(target);
+	cancel_work_sync(&target->tl_err_work);
 
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
@@ -824,9 +830,19 @@ static int srp_reconnect_target(struct srp_target_port *target)
 		return -EAGAIN;
 	}
 
-	scsi_target_block(&shost->shost_gendev);
+	mutex_lock(&target->mutex);
+	if (target->scsi_host_added)
+		scsi_target_block(&shost->shost_gendev);
+	mutex_unlock(&target->mutex);
 
 	srp_disconnect_target(target);
+	cancel_work_sync(&target->tl_err_work);
+
+	mutex_lock(&target->mutex);
+	if (target->scsi_host_added)
+		srp_stop_tl_fail_timers(target->rport);
+	mutex_unlock(&target->mutex);
+
 	/*
 	 * Now get a new local CM ID so that we avoid confusing the
 	 * target in case things are really fouled up.
@@ -858,12 +874,16 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
+	mutex_lock(&target->mutex);
 	scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
+	mutex_unlock(&target->mutex);
 
 	return ret;
 
 err:
+	mutex_lock(&target->mutex);
 	scsi_target_unblock(&shost->shost_gendev, SDEV_TRANSPORT_OFFLINE);
+	mutex_unlock(&target->mutex);
 
 	shost_printk(KERN_ERR, target->scsi_host,
 		     PFX "reconnect failed (%d), removing target port.\n", ret);
@@ -1416,15 +1436,32 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
+/**
+ * srp_tl_err_work - Start the transport layer failure timers.
+ */
+static void srp_tl_err_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(work, struct srp_target_port, tl_err_work);
+
+	mutex_lock(&target->mutex);
+	if (target->scsi_host_added)
+		srp_start_tl_fail_timers(target->rport);
+	mutex_unlock(&target->mutex);
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
+		queue_work(system_long_wq, &target->tl_err_work);
+	}
 	target->qp_in_error = true;
 }
 
@@ -1791,15 +1828,13 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
+		queue_work(system_long_wq, &target->tl_err_work);
 		break;
 
 	case IB_CM_TIMEWAIT_EXIT:
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
-
-		if (!srp_conn_unique(target->srp_host, target))
-			srp_queue_remove_work(target);
-
+		srp_queue_remove_work(target);
 		comp = 1;
 		target->status = 0;
 		break;
@@ -2099,6 +2134,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	}
 
 	rport->lld_data = target;
+	target->rport = rport;
 
 	return 0;
 }
@@ -2386,6 +2422,7 @@ static ssize_t srp_create_target(struct device *dev,
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
 	mutex_init(&target->mutex);
+	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 9b225f1..ed22ddc 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -164,6 +164,7 @@ struct srp_target_port {
 	u16			io_class;
 	struct srp_host	       *srp_host;
 	struct Scsi_Host       *scsi_host;
+	struct srp_rport       *rport;
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
@@ -187,6 +188,7 @@ struct srp_target_port {
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
+	struct work_struct	tl_err_work;
 	struct work_struct	remove_work;
 
 	struct list_head	list;
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
