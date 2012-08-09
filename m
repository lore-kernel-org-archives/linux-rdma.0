From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 05/20] ib_srp: Eliminate state SRP_TARGET_CONNECTING
Date: Thu, 09 Aug 2012 15:48:02 +0000
Message-ID: <5023DBB2.2040207@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Block the SCSI host while reconnecting instead of representing
the reconnection activity as a distinct SRP target state. This
allows to eliminate the target state SRP_TARGET_CONNECTING.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   16 ++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 -
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 28a044e..35e1220 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -647,13 +647,16 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 
 static int srp_reconnect_target(struct srp_target_port *target)
 {
+	struct Scsi_Host *shost = target->scsi_host;
 	struct ib_qp_attr qp_attr;
 	struct ib_wc wc;
 	int i, ret;
 
-	if (!srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_CONNECTING))
+	if (target->state != SRP_TARGET_LIVE)
 		return -EAGAIN;
 
+	scsi_target_block(&shost->shost_gendev);
+
 	srp_disconnect_target(target);
 	/*
 	 * Now get a new local CM ID so that we avoid confusing the
@@ -691,12 +694,13 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE))
-		ret = -EAGAIN;
+	scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
 
 	return ret;
 
 err:
+	scsi_target_unblock(&shost->shost_gendev, SDEV_TRANSPORT_OFFLINE);
+
 	shost_printk(KERN_ERR, target->scsi_host,
 		     PFX "reconnect failed (%d), removing target port.\n", ret);
 
@@ -710,7 +714,7 @@ err:
 	 * the flush_scheduled_work() in srp_remove_one().
 	 */
 	spin_lock_irq(&target->lock);
-	if (target->state == SRP_TARGET_CONNECTING) {
+	if (target->state == SRP_TARGET_LIVE) {
 		target->state = SRP_TARGET_DEAD;
 		INIT_WORK(&target->work, srp_remove_work);
 		queue_work(ib_wq, &target->work);
@@ -1309,9 +1313,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (target->state == SRP_TARGET_CONNECTING)
-		goto err;
-
 	if (target->state == SRP_TARGET_DEAD ||
 	    target->state == SRP_TARGET_REMOVED ||
 	    target->qp_in_error) {
@@ -1376,7 +1377,6 @@ err_iu:
 err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
-err:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index f0daeb3..02dc3ac 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -80,7 +80,6 @@ enum {
 
 enum srp_target_state {
 	SRP_TARGET_LIVE,
-	SRP_TARGET_CONNECTING,
 	SRP_TARGET_DEAD,
 	SRP_TARGET_REMOVED
 };
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
