From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 08/18] ib_srp: Eliminate state SRP_TARGET_DEAD
Date: Sat, 14 Jan 2012 12:46:05 +0000
Message-ID: <1542335.oobt4mZRgv@asus>
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

Only queue removal work after having changed the target state
into SRP_TARGET_REMOVED and not if that state was already equal
to SRP_TARGET_REMOVED. That allows to remove the state
SRP_TARGET_DEAD. Add a call to srp_disconnect_target() in
srp_remove_target() - due to previous changes it is now safe to
invoke that last function even if the IB connection has already
been disconnected. Rename srp_target_port.work into
srp_target_port.remove_work and move function srp_change_state()
to just before srp_change_state_to_removed().

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   97 +++++++++++++---------------------
 drivers/infiniband/ulp/srp/ib_srp.h |    5 +-
 2 files changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 57f8a6f..67932aa 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -428,13 +428,15 @@ static int srp_send_req(struct srp_target_port *target)
 	return status;
 }
 
-static bool srp_change_state_to_removed(struct srp_target_port *target)
+static bool srp_change_state(struct srp_target_port *target,
+			     enum srp_target_state old,
+			     enum srp_target_state new)
 {
 	bool changed = false;
 
 	spin_lock_irq(&target->lock);
-	if (target->state != SRP_TARGET_REMOVED) {
-		target->state = SRP_TARGET_REMOVED;
+	if (target->state == old) {
+		target->state = new;
 		changed = true;
 	}
 	spin_unlock_irq(&target->lock);
@@ -442,6 +444,11 @@ static bool srp_change_state_to_removed(struct srp_target_port *target)
 	return changed;
 }
 
+static bool srp_change_state_to_removed(struct srp_target_port *target)
+{
+	return srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_REMOVED);
+}
+
 static bool srp_change_conn_state(struct srp_target_port *target,
 				  bool connected)
 {
@@ -532,21 +539,6 @@ static void srp_disconnect_target(struct srp_target_port *target)
 	}
 }
 
-static bool srp_change_state(struct srp_target_port *target,
-			    enum srp_target_state old,
-			    enum srp_target_state new)
-{
-	bool changed = false;
-
-	spin_lock_irq(&target->lock);
-	if (target->state == old) {
-		target->state = new;
-		changed = true;
-	}
-	spin_unlock_irq(&target->lock);
-	return changed;
-}
-
 static void srp_free_req_data(struct srp_target_port *target)
 {
 	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
@@ -582,9 +574,12 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 
 static void srp_remove_target(struct srp_target_port *target)
 {
+	WARN_ON(target->state != SRP_TARGET_REMOVED);
+
 	srp_del_scsi_host_attr(target->scsi_host);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
+	srp_disconnect_target(target);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
@@ -594,10 +589,9 @@ static void srp_remove_target(struct srp_target_port *target)
 static void srp_remove_work(struct work_struct *work)
 {
 	struct srp_target_port *target =
-		container_of(work, struct srp_target_port, work);
+		container_of(work, struct srp_target_port, remove_work);
 
-	if (!srp_change_state(target, SRP_TARGET_DEAD, SRP_TARGET_REMOVED))
-		return;
+	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
 	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
@@ -766,17 +760,9 @@ err:
 	 * However, we have to defer the real removal because we
 	 * are in the context of the SCSI error handler now, which
 	 * will deadlock if we call scsi_remove_host().
-	 *
-	 * Schedule our work inside the lock to avoid a race with
-	 * the flush_scheduled_work() in srp_remove_one().
 	 */
-	spin_lock_irq(&target->lock);
-	if (target->state == SRP_TARGET_LIVE) {
-		target->state = SRP_TARGET_DEAD;
-		INIT_WORK(&target->work, srp_remove_work);
-		queue_work(ib_wq, &target->work);
-	}
-	spin_unlock_irq(&target->lock);
+	if (srp_change_state_to_removed(target))
+		queue_work(ib_wq, &target->remove_work);
 
 	return ret;
 }
@@ -1384,8 +1370,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (!target->connected)
 		goto err;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED) {
+	if (target->state == SRP_TARGET_REMOVED) {
 		scmnd->result = DID_BAD_TARGET << 16;
 		scmnd->scsi_done(scmnd);
 		return 0;
@@ -1736,8 +1721,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
+	if (target->state == SRP_TARGET_REMOVED)
 		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
@@ -2312,6 +2296,7 @@ static ssize_t srp_create_target(struct device *dev,
 			     sizeof (struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
+	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
@@ -2546,8 +2531,7 @@ static void srp_remove_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
 	struct srp_host *host, *tmp_host;
-	LIST_HEAD(target_list);
-	struct srp_target_port *target, *tmp_target;
+	struct srp_target_port *target;
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
@@ -2560,32 +2544,25 @@ static void srp_remove_one(struct ib_device *device)
 		wait_for_completion(&host->released);
 
 		/*
-		 * Mark all target ports as removed, so we stop queueing
-		 * commands and don't try to reconnect.
+		 * Remove all target ports. Wait for any removal tasks that
+		 * may already have been started.
 		 */
 		spin_lock(&host->target_lock);
-		list_for_each_entry(target, &host->target_list, list)
-			srp_change_state_to_removed(target);
-		spin_unlock(&host->target_lock);
-
-		/*
-		 * Wait for any reconnection tasks that may have
-		 * started before we marked our target ports as
-		 * removed, and any target port removal tasks.
-		 */
-		flush_workqueue(ib_wq);
-
-		list_for_each_entry_safe(target, tmp_target,
-					 &host->target_list, list) {
-			srp_del_scsi_host_attr(target->scsi_host);
-			srp_remove_host(target->scsi_host);
-			scsi_remove_host(target->scsi_host);
-			srp_disconnect_target(target);
-			ib_destroy_cm_id(target->cm_id);
-			srp_free_target_ib(target);
-			srp_free_req_data(target);
-			scsi_host_put(target->scsi_host);
+		while (!list_empty(&host->target_list)) {
+			target = list_first_entry(&host->target_list,
+						  struct srp_target_port, list);
+			if (srp_change_state_to_removed(target)) {
+				list_del(&target->list);
+				spin_unlock(&host->target_lock);
+				srp_remove_target(target);
+				spin_lock(&host->target_lock);
+			} else {
+				spin_unlock(&host->target_lock);
+				flush_work_sync(&target->remove_work);
+				spin_lock(&host->target_lock);
+			}
 		}
+		spin_unlock(&host->target_lock);
 
 		kfree(host);
 	}
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index fc411ae..3882adf 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -80,8 +80,7 @@ enum {
 
 enum srp_target_state {
 	SRP_TARGET_LIVE,
-	SRP_TARGET_DEAD,
-	SRP_TARGET_REMOVED
+	SRP_TARGET_REMOVED,
 };
 
 enum srp_iu_type {
@@ -177,7 +176,7 @@ struct srp_target_port {
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
-	struct work_struct	work;
+	struct work_struct	remove_work;
 
 	struct list_head	list;
 	struct completion	done;
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
