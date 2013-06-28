From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 02/15] IB/srp: Fix race between srp_queuecommand() and
 srp_claim_req()
Date: Fri, 28 Jun 2013 14:48:04 +0200
Message-ID: <51CD8604.5010801@acm.org>
References: <51CD856A.3010102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD856A.3010102-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that srp_claim_command() can claim a command while
srp_queuecommand() is still busy queueing the same command.
Found this via source reading.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 368d160..035167b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1047,13 +1047,11 @@ map_complete:
 static void srp_put_tx_iu(struct srp_target_port *target, struct srp_iu *iu,
 			  enum srp_iu_type iu_type)
 {
-	unsigned long flags;
+	lockdep_assert_held(&target->lock);
 
-	spin_lock_irqsave(&target->lock, flags);
 	list_add(&iu->list, &target->free_tx);
 	if (iu_type != SRP_IU_RSP)
 		++target->req_lim;
-	spin_unlock_irqrestore(&target->lock, flags);
 }
 
 /*
@@ -1210,7 +1208,10 @@ static int srp_response_common(struct srp_target_port *target, s32 req_delta,
 	if (err) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX
 			     "unable to post response: %d\n", err);
+
+		spin_lock_irqsave(&target->lock, flags);
 		srp_put_tx_iu(target, iu, SRP_IU_RSP);
+		spin_unlock_irqrestore(&target->lock, flags);
 	}
 
 	return err;
@@ -1367,7 +1368,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	req = list_first_entry(&target->free_reqs, struct srp_request, list);
 	list_del(&req->list);
-	spin_unlock_irqrestore(&target->lock, flags);
 
 	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_iu_len,
@@ -1401,6 +1401,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
+	spin_unlock_irqrestore(&target->lock, flags);
 
 	return 0;
 
@@ -1409,8 +1410,6 @@ err_unmap:
 
 err_iu:
 	srp_put_tx_iu(target, iu, SRP_IU_CMD);
-
-	spin_lock_irqsave(&target->lock, flags);
 	list_add(&req->list, &target->free_reqs);
 
 err_unlock:
@@ -1729,7 +1728,10 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
 				      DMA_TO_DEVICE);
 	if (srp_post_send(target, iu, sizeof *tsk_mgmt)) {
+		spin_lock_irq(&target->lock);
 		srp_put_tx_iu(target, iu, SRP_IU_TSK_MGMT);
+		spin_unlock_irq(&target->lock);
+
 		return -1;
 	}
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
