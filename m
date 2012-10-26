From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 15/19] ib_srp: Maintain a single connection per I_T nexus
Date: Fri, 26 Oct 2012 14:55:40 +0200
Message-ID: <508A884C.1000308@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The sysfs attribute 'add_target' may be used to relogin to a
target. An SRP target that receives a second login request from
an initiator will disconnect the previous connection. So before
trying to reconnect, check whether another connection to the
same SRP target identifier already exists. If so, remove the
target port.  Add a target to the target list before connecting
instead of after such that this algorithm has a chance to work.

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  145 +++++++++++++++++++++++++++++------
 drivers/infiniband/ulp/srp/ib_srp.h |   12 +++
 2 files changed, 133 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 96e9bc2..b3a09e9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -430,6 +430,24 @@ static int srp_send_req(struct srp_target_port *target)
 	return status;
 }
 
+static bool srp_change_state(struct srp_target_port *target,
+			     enum srp_target_state old,
+			     enum srp_target_state new)
+{
+	bool changed = false;
+
+	BUG_ON(old == SRP_TARGET_REMOVED);
+
+	spin_lock_irq(&target->lock);
+	if (target->state == old) {
+		target->state = new;
+		changed = true;
+	}
+	spin_unlock_irq(&target->lock);
+
+	return changed;
+}
+
 static bool srp_queue_remove_work(struct srp_target_port *target)
 {
 	bool changed = false;
@@ -584,15 +602,24 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 
 static void srp_remove_target(struct srp_target_port *target)
 {
+	struct Scsi_Host *shost = target->scsi_host;
+	bool scsi_host_added = false;
+
 	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
-	srp_del_scsi_host_attr(target->scsi_host);
-	srp_remove_host(target->scsi_host);
-	scsi_remove_host(target->scsi_host);
+	mutex_lock(&target->mutex);
+	swap(target->scsi_host_added, scsi_host_added);
+	mutex_unlock(&target->mutex);
+
+	if (scsi_host_added) {
+		srp_del_scsi_host_attr(shost);
+		srp_remove_host(shost);
+		scsi_remove_host(shost);
+	}
 	srp_disconnect_target(target);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
-	scsi_host_put(target->scsi_host);
+	scsi_host_put(shost);
 }
 
 static void srp_remove_work(struct work_struct *work)
@@ -616,6 +643,30 @@ static void srp_rport_delete(struct srp_rport *rport)
 	srp_queue_remove_work(target);
 }
 
+/**
+ * srp_conn_unique() - Check whether the connection to a target is unique.
+ */
+static bool srp_conn_unique(struct srp_host *host,
+			    struct srp_target_port *target)
+{
+	struct srp_target_port *t;
+	bool ret = true;
+
+	spin_lock(&host->target_lock);
+	list_for_each_entry(t, &host->target_list, list) {
+		if (t != target &&
+		    target->id_ext == t->id_ext &&
+		    target->ioc_guid == t->ioc_guid &&
+		    target->initiator_ext == t->initiator_ext) {
+			ret = false;
+			break;
+		}
+	}
+	spin_unlock(&host->target_lock);
+
+	return ret;
+}
+
 static int srp_connect_target(struct srp_target_port *target)
 {
 	int retries = 3;
@@ -763,10 +814,24 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	struct ib_qp_attr qp_attr;
 	int i, ret;
 
-	if (target->state != SRP_TARGET_LIVE)
+	if (!srp_conn_unique(target->srp_host, target) &&
+	    srp_queue_remove_work(target)) {
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "Deleting SCSI host because obsolete\n");
+		return -ENXIO;
+	}
+
+	if (target->state == SRP_TARGET_REMOVED) {
+		shost_printk(KERN_DEBUG, target->scsi_host,
+			     PFX "Removal already scheduled\n");
 		return -EAGAIN;
+	}
 
-	scsi_target_block(&shost->shost_gendev);
+	mutex_lock(&target->mutex);
+	if (target->scsi_host_added)
+		scsi_target_block(&shost->shost_gendev);
+	target->reconnecting = true;
+	mutex_unlock(&target->mutex);
 
 	srp_disconnect_target(target);
 	/*
@@ -796,18 +861,27 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
-	ret = srp_connect_target(target);
+	mutex_lock(&target->mutex);
+	ret = target->scsi_host_added ? srp_connect_target(target) : -ENODEV;
+	mutex_unlock(&target->mutex);
+
 	if (ret)
 		goto err;
 
+	mutex_lock(&target->mutex);
+	target->reconnecting = false;
 	scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
+	mutex_unlock(&target->mutex);
 
 	shost_printk(KERN_INFO, target->scsi_host, PFX "reconnect succeeded\n");
 
 	return ret;
 
 err:
+	mutex_lock(&target->mutex);
+	target->reconnecting = false;
 	scsi_target_unblock(&shost->shost_gendev, SDEV_TRANSPORT_OFFLINE);
+	mutex_unlock(&target->mutex);
 
 	shost_printk(KERN_ERR, target->scsi_host,
 		     PFX "reconnect failed (%d), removing target port.\n", ret);
@@ -1740,6 +1814,9 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
 
+		if (!target->reconnecting)
+			srp_queue_remove_work(target);
+
 		comp = 1;
 		target->status = 0;
 		break;
@@ -2043,16 +2120,6 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 
 	rport->lld_data = target;
 
-	spin_lock(&host->target_lock);
-	list_add_tail(&target->list, &host->target_list);
-	spin_unlock(&host->target_lock);
-
-	target->state = SRP_TARGET_LIVE;
-	target->connected = false;
-
-	scsi_scan_target(&target->scsi_host->shost_gendev,
-			 0, target->scsi_id, SCAN_WILD_CARD, 0);
-
 	return 0;
 }
 
@@ -2338,6 +2405,7 @@ static ssize_t srp_create_target(struct device *dev,
 			     sizeof (struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
+	mutex_init(&target->mutex);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
@@ -2384,24 +2452,53 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_ib;
 
+	target->connected = false;
+	target->reconnecting = false;
+	target->rq_tmo_jiffies = 1 * HZ;
+	target->state = SRP_TARGET_CONNECTING;
+	target->scsi_host_added = false;
+
+	mutex_lock(&target->mutex);
+	spin_lock(&host->target_lock);
+	list_add_tail(&target->list, &host->target_list);
+	spin_unlock(&host->target_lock);
+
+	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE)) {
+		ret = -ENOENT;
+		goto err_unlock_remove;
+	}
+
 	ret = srp_connect_target(target);
 	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Connection failed\n");
-		goto err_cm_id;
+		goto err_unlock_remove;
 	}
 
 	ret = srp_add_target(host, target);
+	target->scsi_host_added = ret == 0;
+
+	WARN_ON(!scsi_host_get(target_host));
+	mutex_unlock(&target->mutex);
+
+	if (ret == 0)
+		scsi_scan_target(&target->scsi_host->shost_gendev, 0,
+				 target->scsi_id, SCAN_WILD_CARD, 0);
+
+	scsi_host_put(target_host);
+
 	if (ret)
-		goto err_disconnect;
+		goto err_remove;
 
 	return count;
 
-err_disconnect:
-	srp_disconnect_target(target);
-
-err_cm_id:
-	ib_destroy_cm_id(target->cm_id);
+err_unlock_remove:
+	mutex_unlock(&target->mutex);
+err_remove:
+	if (srp_queue_remove_work(target))
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "deleting SCSI host (ret = %d).\n", ret);
+	return ret;
 
 err_free_ib:
 	srp_free_target_ib(target);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 1b11117..4e0b413 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -81,7 +81,16 @@ enum {
 	SRP_LAST_SEND		= 0,
 };
 
+/**
+ * enum srp_target_state - State of an SRP target.
+ * @SRP_TARGET_CONNECTING: IB connection being established and SCSI host being
+ *                      added.
+ * @SRP_TARGET_LIVE: IB RC connection has been established.
+ * @SRP_TARGET_REMOVED: IB RC connection is about to be closed and SCSI host
+ *                      removal is pending.
+ */
 enum srp_target_state {
+	SRP_TARGET_CONNECTING,
 	SRP_TARGET_LIVE,
 	SRP_TARGET_REMOVED,
 };
@@ -166,6 +175,8 @@ struct srp_target_port {
 
 	u32			rq_tmo_jiffies;
 	bool			connected;
+	bool			reconnecting;
+	bool			scsi_host_added;
 
 	struct ib_cm_id	       *cm_id;
 
@@ -186,6 +197,7 @@ struct srp_target_port {
 	bool			last_recv_wqe;
 	bool			last_send_wqe;
 	wait_queue_head_t	qp_wq;
+	struct mutex		mutex;
 
 	struct completion	tsk_mgmt_done;
 	u8			tsk_mgmt_status;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
