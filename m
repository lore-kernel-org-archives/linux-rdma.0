From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 05/15] ib_srp: Avoid that SCSI error handling triggers a crash
Date: Sun, 25 Mar 2012 14:53:23 +0000
Message-ID: <4903375.rt8yAAnAoX@asus>
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

Sending any data over a queue pair associated with a closed
connection is wrong. The HCA will send the data anyway and such
data may be sent to another system to a queue pair that is in use.
The data will get processed and a response will be sent back. That
can result in ib_srp complaining about "Null scmnd for RSP ..."
followed by a kernel oops.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c88dde3..2c265ae 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1296,7 +1296,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	int len;
 
 	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED) {
+	    target->state == SRP_TARGET_REMOVED ||
+	    !target->connected) {
 		scmnd->result = DID_BAD_TARGET << 16;
 		scmnd->scsi_done(scmnd);
 		return 0;
@@ -1647,7 +1648,8 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_tsk_mgmt *tsk_mgmt;
 
 	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
+	    target->state == SRP_TARGET_REMOVED ||
+	    !target->connected)
 		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
