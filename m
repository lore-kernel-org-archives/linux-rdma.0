From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 07/20] ib_srp: Avoid that SCSI error handling triggers a crash
Date: Thu, 09 Aug 2012 15:49:49 +0000
Message-ID: <5023DC1D.8040808@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
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
 drivers/infiniband/ulp/srp/ib_srp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ff3e15a..b7a5e92 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1338,6 +1338,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	if (target->state == SRP_TARGET_DEAD ||
 	    target->state == SRP_TARGET_REMOVED ||
+	    !target->connected ||
 	    target->qp_in_error) {
 		scmnd->result = DID_BAD_TARGET << 16;
 		scmnd->scsi_done(scmnd);
@@ -1690,6 +1691,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	if (target->state == SRP_TARGET_DEAD ||
 	    target->state == SRP_TARGET_REMOVED ||
+	    !target->connected ||
 	    target->qp_in_error)
 		return -1;
 
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
