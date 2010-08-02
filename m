From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/4] IB/srp: adjust can_queue
Date: Mon, 2 Aug 2010 17:32:48 +0200
Message-ID: <201008021732.48499.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Makes sure that the SCSI mid-layer never tries to queue more than
(SRP request limit) - 1 SCSI commands. Improves performance for targets whose
request limit is less than or equal to SRP_SQ_REQ_SIZE (63) by reducing the
number of BUSY responses.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1c40ac3..4efda6c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1436,7 +1436,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 			target->max_ti_iu_len = be32_to_cpu(rsp->max_ti_iu_len);
 			target->req_lim       = be32_to_cpu(rsp->req_lim_delta);
 
-			target->scsi_host->can_queue = min(target->req_lim,
+			target->scsi_host->can_queue = min(target->req_lim - 1,
 							   target->scsi_host->can_queue);
 		} else {
 			shost_printk(KERN_WARNING, target->scsi_host,
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
