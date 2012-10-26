From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 05/19] ib_srp: Avoid that SCSI error handling causes trouble
Date: Fri, 26 Oct 2012 14:48:26 +0200
Message-ID: <508A869A.1080209@acm.org>
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

Sending data over a queue pair after the corresponding cm_id has
been destroyed is wrong. The HCA will send the data anyway and
the data may be sent to another system to a queue pair that is in
use. The data will get processed and a response will be sent back.
An application will receive data that it did not expect. This can
result in a kernel oops.

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 01b6cd7..abcefa1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1695,8 +1695,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
+	if (!target->connected)
 		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
