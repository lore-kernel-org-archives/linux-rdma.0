From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] ib_srp: Test once whether iu allocation succeeded
Date: Thu, 13 Jan 2011 20:02:25 +0100
Message-ID: <201101132002.26052.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Merge the two tests whether information unit allocation succeeded into
one. An intended side effect of this change is that gcc 4.4.4 does no
longer complain that the variable 'req' might be used uninitialized in
the function srp_queuecommand() when ib_srp is built with
CONFIG_CC_OPTIMIZE_FOR_SIZE=y. This was reported by Roland Dreier.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 4b62105..72d1b96 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1132,15 +1132,11 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	spin_lock_irqsave(&target->lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
-	if (iu) {
-		req = list_first_entry(&target->free_reqs, struct srp_request,
-				      list);
-		list_del(&req->list);
-	}
-	spin_unlock_irqrestore(&target->lock, flags);
-
 	if (!iu)
-		goto err;
+		goto err_unlock;
+	req = list_first_entry(&target->free_reqs, struct srp_request, list);
+	list_del(&req->list);
+	spin_unlock_irqrestore(&target->lock, flags);
 
 	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
@@ -1185,6 +1181,8 @@ err_iu:
 
 	spin_lock_irqsave(&target->lock, flags);
 	list_add(&req->list, &target->free_reqs);
+
+err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
 err:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
