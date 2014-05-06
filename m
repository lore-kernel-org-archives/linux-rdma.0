From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 7/9] IB/srp: Avoid triggering an infinite loop if memory mapping
 fails
Date: Tue, 06 May 2014 14:55:33 +0200
Message-ID: <5368DBC5.6070609@acm.org>
References: <5368DA5B.80609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368DA5B.80609-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Only request the SCSI mid-layer to retry a SCSI command after a
temporary mapping failure (-ENOMEM) but not after a permanent
mapping failure. This patch avoids that SCSI commands are retried
indefinitely if a permanent memory mapping failure occurs.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1c4b0d3..af94381 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1564,7 +1564,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	unsigned long flags;
-	int len, result;
+	int len, result, ret = SCSI_MLQUEUE_HOST_BUSY;
 	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
 
 	/*
@@ -1580,6 +1580,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(result)) {
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
+		ret = 0;
 		goto unlock_rport;
 	}
 
@@ -1613,7 +1614,12 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	len = srp_map_data(scmnd, target, req);
 	if (len < 0) {
 		shost_printk(KERN_ERR, target->scsi_host,
-			     PFX "Failed to map data\n");
+			     PFX "Failed to map data (%d)\n", len);
+		if (len != -ENOMEM) {
+			scmnd->result = DID_ERROR << 16;
+			scmnd->scsi_done(scmnd);
+			ret = 0;
+		}
 		goto err_iu;
 	}
 
@@ -1625,11 +1631,13 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		goto err_unmap;
 	}
 
+	ret = 0;
+
 unlock_rport:
 	if (in_scsi_eh)
 		mutex_unlock(&rport->mutex);
 
-	return 0;
+	return ret;
 
 err_unmap:
 	srp_unmap_data(scmnd, target, req);
@@ -1643,10 +1651,7 @@ err_iu:
 err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
-	if (in_scsi_eh)
-		mutex_unlock(&rport->mutex);
-
-	return SCSI_MLQUEUE_HOST_BUSY;
+	goto unlock_rport;
 }
 
 /*
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
