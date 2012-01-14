From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 15/18] ib_srp: Maintain a single connection per I_T nexus
Date: Sat, 14 Jan 2012 12:54:15 +0000
Message-ID: <6527223.rH6NsR1Dga@asus>
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

The sysfs attribute 'add_target' may be used to relogin to a
target. An SRP target that receives a second login request from
an initiator will disconnect the previous connection. So before
trying to reconnect, check whether another connection to the
same SRP target identifier already exists. If so, remove the
target port.  Add a target to the target list before connecting
instead of after such that this algorithm has a chance to work.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   97 +++++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |   10 ++++
 2 files changed, 86 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a8a3a2f..eb31a14 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -574,16 +574,20 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 
 static void srp_remove_target(struct srp_target_port *target)
 {
+	struct Scsi_Host *shost = target->scsi_host;
+
 	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
-	srp_del_scsi_host_attr(target->scsi_host);
-	srp_remove_host(target->scsi_host);
-	scsi_remove_host(target->scsi_host);
+	srp_del_scsi_host_attr(shost);
+	if (target->scsi_host_added) {
+		srp_remove_host(shost);
+		scsi_remove_host(shost);
+	}
 	srp_disconnect_target(target);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
-	scsi_host_put(target->scsi_host);
+	scsi_host_put(shost);
 }
 
 static void srp_remove_work(struct work_struct *work)
@@ -615,6 +619,32 @@ static void srp_rport_delete(struct srp_rport *rport)
 		queue_work(system_long_wq, &target->remove_work);
 }
 
+/**
+ * srp_conn_unique() - Check whether the connection to a target is unique.
+ *
+ * Connections are compared by their SCSI target port identifier: identifier
+ * extension + IO controller GUID. See also paragraph B.5 in the SRP spec.
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
+		    target->ioc_guid == t->ioc_guid) {
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
@@ -728,9 +758,21 @@ static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct ib_qp_attr qp_attr;
 	int i, ret;
+	bool unique;
 
-	if (target->state != SRP_TARGET_LIVE)
+	unique = srp_conn_unique(target->srp_host, target);
+	if (unique) {
+	} else if (srp_change_state_to_removed(target)) {
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "deleting SCSI host because obsolete.\n");
+		queue_work(system_long_wq, &target->remove_work);
+		return -ENXIO;
+	}
+	if (target->state == SRP_TARGET_REMOVED) {
+		shost_printk(KERN_DEBUG, target->scsi_host,
+			     PFX "Already removed\n");
 		return -EAGAIN;
+	}
 
 	srp_disconnect_target(target);
 	/*
@@ -2023,15 +2065,6 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	rport->lld_data = target;
 	target->rport = rport;
 
-	spin_lock(&host->target_lock);
-	list_add_tail(&target->list, &host->target_list);
-	spin_unlock(&host->target_lock);
-
-	target->state = SRP_TARGET_LIVE;
-	target->connected = false;
-
-	srp_scan_target(target);
-
 	return 0;
 }
 
@@ -2317,6 +2350,7 @@ static ssize_t srp_create_target(struct device *dev,
 			     sizeof (struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
+	mutex_init(&target->mutex);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
@@ -2363,24 +2397,45 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_ib;
 
+	target->connected = false;
+	target->rq_tmo_jiffies = 1 * HZ;
+	target->state = SRP_TARGET_CONNECTING;
+	target->scsi_host_added = false;
+
+	spin_lock(&host->target_lock);
+	list_add_tail(&target->list, &host->target_list);
+	spin_unlock(&host->target_lock);
+
+	mutex_lock(&target->mutex);
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
+	mutex_unlock(&target->mutex);
+
+	srp_scan_target(target);
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
+	if (srp_change_state_to_removed(target))
+		srp_remove_work(&target->remove_work);
+	return ret;
 
 err_free_ib:
 	srp_free_target_ib(target);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 22e0c5d..a603c6d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -78,7 +78,15 @@ enum {
 	SRP_MAP_NO_FMR		= 1,
 };
 
+/**
+ * enum srp_target_state - State of the SCSI host associated with an SRP target.
+ * @SRP_TARGET_CONNECTING: IB connection being established and SCSI host being
+ *                      added.
+ * @SRP_TARGET_LIVE: IB RC connection is established and SCSI host is unblocked.
+ * @SRP_TARGET_REMOVED: SCSI host removal is pending.
+ */
 enum srp_target_state {
+	SRP_TARGET_CONNECTING,
 	SRP_TARGET_LIVE,
 	SRP_TARGET_REMOVED,
 };
@@ -166,6 +174,7 @@ struct srp_target_port {
 
 	u32			rq_tmo_jiffies;
 	bool			connected;
+	bool			scsi_host_added;
 
 	struct ib_cm_id	       *cm_id;
 
@@ -186,6 +195,7 @@ struct srp_target_port {
 	bool			last_recv_wqe;
 	bool			last_send_wqe;
 	wait_queue_head_t	qp_wq;
+	struct mutex		mutex;
 
 	struct completion	tsk_mgmt_done;
 	u8			tsk_mgmt_status;
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
