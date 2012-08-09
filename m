From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 03/20] ib_srp: Move QP state check into srp_send_tsk_mgmt()
Date: Thu, 09 Aug 2012 15:45:43 +0000
Message-ID: <5023DB27.7060307@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Test the QP state inside srp_send_tsk_mgmt() instead of letting each
caller perform that test.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8444d36..f333705 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1660,7 +1660,8 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_tsk_mgmt *tsk_mgmt;
 
 	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
+	    target->state == SRP_TARGET_REMOVED ||
+	    target->qp_in_error)
 		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
@@ -1704,8 +1705,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error ||
-	    !srp_claim_req(target, req, scmnd, 0))
+	if (!req || !srp_claim_req(target, req, scmnd, 0))
 		return FAILED;
 	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			  SRP_TSK_ABORT_TASK);
@@ -1722,8 +1722,6 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
-	if (target->qp_in_error)
-		return FAILED;
 	if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
 			      SRP_TSK_LUN_RESET))
 		return FAILED;
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
