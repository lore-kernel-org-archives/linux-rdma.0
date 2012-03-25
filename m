From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 03/15] ib_srp: Micro-optimize srp_queuecommand()
Date: Sun, 25 Mar 2012 14:50:21 +0000
Message-ID: <28993193.JhpOJ9jIEO@asus>
References: <5207288.nSt5MkVMpO@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5207288.nSt5MkVMpO@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Block the SCSI host while reconnecting instead of representing
the reconnect activity as a distinct SRP target state.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   16 ++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 -
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6279343..04fbc43 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -610,13 +610,16 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 
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
@@ -654,8 +657,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE))
-		ret = -EAGAIN;
+	scsi_target_unblock(&shost->shost_gendev);
 
 	return ret;
 
@@ -673,13 +675,15 @@ err:
 	 * the flush_scheduled_work() in srp_remove_one().
 	 */
 	spin_lock_irq(&target->lock);
-	if (target->state == SRP_TARGET_CONNECTING) {
+	if (target->state == SRP_TARGET_LIVE) {
 		target->state = SRP_TARGET_DEAD;
 		INIT_WORK(&target->work, srp_remove_work);
 		queue_work(ib_wq, &target->work);
 	}
 	spin_unlock_irq(&target->lock);
 
+	scsi_target_unblock(&shost->shost_gendev);
+
 	return ret;
 }
 
@@ -1268,9 +1272,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (target->state == SRP_TARGET_CONNECTING)
-		goto err;
-
 	if (target->state == SRP_TARGET_DEAD ||
 	    target->state == SRP_TARGET_REMOVED) {
 		scmnd->result = DID_BAD_TARGET << 16;
@@ -1334,7 +1335,6 @@ err_iu:
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
