From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 02/19] ib_srp: Eliminate state SRP_TARGET_CONNECTING
Date: Fri, 26 Oct 2012 14:46:22 +0200
Message-ID: <508A861E.4050303@acm.org>
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

Block the SCSI host while reconnecting instead of representing
the reconnection activity as a distinct SRP target state. This
allows to eliminate the target state SRP_TARGET_CONNECTING.

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   18 ++++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 -
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6c0cd66..ed89370 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -646,13 +646,16 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 
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
@@ -691,12 +694,15 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE))
-		ret = -EAGAIN;
+	scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
+
+	shost_printk(KERN_INFO, target->scsi_host, PFX "reconnect succeeded\n");
 
 	return ret;
 
 err:
+	scsi_target_unblock(&shost->shost_gendev, SDEV_TRANSPORT_OFFLINE);
+
 	shost_printk(KERN_ERR, target->scsi_host,
 		     PFX "reconnect failed (%d), removing target port.\n", ret);
 
@@ -710,7 +716,7 @@ err:
 	 * the flush_scheduled_work() in srp_remove_one().
 	 */
 	spin_lock_irq(&target->lock);
-	if (target->state == SRP_TARGET_CONNECTING) {
+	if (target->state == SRP_TARGET_LIVE) {
 		target->state = SRP_TARGET_DEAD;
 		INIT_WORK(&target->work, srp_remove_work);
 		queue_work(ib_wq, &target->work);
@@ -1311,9 +1317,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (target->state == SRP_TARGET_CONNECTING)
-		goto err;
-
 	if (target->state == SRP_TARGET_DEAD ||
 	    target->state == SRP_TARGET_REMOVED) {
 		scmnd->result = DID_BAD_TARGET << 16;
@@ -1377,7 +1380,6 @@ err_iu:
 err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
-err:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e3a6304..8b436ce 100644
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
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
