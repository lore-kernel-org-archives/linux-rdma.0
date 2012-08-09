From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 10/20] ib_srp: Keep processing commands during scsi_remove_host()
Date: Thu, 09 Aug 2012 15:52:38 +0000
Message-ID: <5023DCC6.5080203@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some SCSI upper layer drivers, e.g. sd, issue SCSI commands from
inside scsi_remove_host() (see also the sd_shutdown() call in
sd_remove()). Make sure that these commands have a chance to reach
the SCSI device.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a7f42f3..0e7825a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1336,9 +1336,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (target->state == SRP_TARGET_REMOVED ||
-	    !target->connected ||
-	    target->qp_in_error) {
+	if (!target->connected || target->qp_in_error) {
 		scmnd->result = DID_BAD_TARGET << 16;
 		scmnd->scsi_done(scmnd);
 		return 0;
@@ -1688,9 +1686,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (target->state == SRP_TARGET_REMOVED ||
-	    !target->connected ||
-	    target->qp_in_error)
+	if (!target->connected || target->qp_in_error)
 		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
