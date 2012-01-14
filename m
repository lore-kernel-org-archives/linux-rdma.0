From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 07/18] ib_srp: Introduce three helper functions
Date: Sat, 14 Jan 2012 12:45:07 +0000
Message-ID: <3639113.Zct32Hvp8M@asus>
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

Introduce srp_remove_target(), srp_change_state_to_removed() and
srp_scan_target().

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   49 +++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0265a10..57f8a6f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -428,6 +428,20 @@ static int srp_send_req(struct srp_target_port *target)
 	return status;
 }
 
+static bool srp_change_state_to_removed(struct srp_target_port *target)
+{
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
+}
+
 static bool srp_change_conn_state(struct srp_target_port *target,
 				  bool connected)
 {
@@ -566,6 +580,17 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 		device_remove_file(&shost->shost_dev, *attr);
 }
 
+static void srp_remove_target(struct srp_target_port *target)
+{
+	srp_del_scsi_host_attr(target->scsi_host);
+	srp_remove_host(target->scsi_host);
+	scsi_remove_host(target->scsi_host);
+	ib_destroy_cm_id(target->cm_id);
+	srp_free_target_ib(target);
+	srp_free_req_data(target);
+	scsi_host_put(target->scsi_host);
+}
+
 static void srp_remove_work(struct work_struct *work)
 {
 	struct srp_target_port *target =
@@ -578,13 +603,7 @@ static void srp_remove_work(struct work_struct *work)
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
 
-	srp_del_scsi_host_attr(target->scsi_host);
-	srp_remove_host(target->scsi_host);
-	scsi_remove_host(target->scsi_host);
-	ib_destroy_cm_id(target->cm_id);
-	srp_free_target_ib(target);
-	srp_free_req_data(target);
-	scsi_host_put(target->scsi_host);
+	srp_remove_target(target);
 }
 
 static int srp_connect_target(struct srp_target_port *target)
@@ -690,6 +709,12 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 	srp_remove_req(target, req, 0);
 }
 
+static void srp_scan_target(struct srp_target_port *target)
+{
+	scsi_scan_target(&target->scsi_host->shost_gendev, 0, target->scsi_id,
+			 SCAN_WILD_CARD, 0);
+}
+
 static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct ib_qp_attr qp_attr;
@@ -2000,8 +2025,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	target->state = SRP_TARGET_LIVE;
 	target->connected = false;
 
-	scsi_scan_target(&target->scsi_host->shost_gendev,
-			 0, target->scsi_id, SCAN_WILD_CARD, 0);
+	srp_scan_target(target);
 
 	return 0;
 }
@@ -2540,11 +2564,8 @@ static void srp_remove_one(struct ib_device *device)
 		 * commands and don't try to reconnect.
 		 */
 		spin_lock(&host->target_lock);
-		list_for_each_entry(target, &host->target_list, list) {
-			spin_lock_irq(&target->lock);
-			target->state = SRP_TARGET_REMOVED;
-			spin_unlock_irq(&target->lock);
-		}
+		list_for_each_entry(target, &host->target_list, list)
+			srp_change_state_to_removed(target);
 		spin_unlock(&host->target_lock);
 
 		/*
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
