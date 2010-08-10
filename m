From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/3 v4] IB/srp: Reduce number of BUSY conditions
Date: Tue, 10 Aug 2010 20:34:10 +0200
Message-ID: <201008102034.10506.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The SRP (draft) standard specifies that an SRP initiator must never queue more
than (SRP request limit) - 1 unanswered SRP_CMD information units. This patch
makes sure that the SCSI mid-layer never tries to queue more than (SRP request
limit) - 1 SCSI commands to ib_srp. This improves performance for targets
whose request limit is less than or equal to
SRP_SQ_REQ_SIZE - SRP_TSK_MGMT_RSV (62) by reducing the number of BUSY
responses reported by ib_srp to the SCSI mid-layer.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cc6a713..93d6d0f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1354,8 +1354,13 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 			target->max_ti_iu_len = be32_to_cpu(rsp->max_ti_iu_len);
 			target->req_lim       = be32_to_cpu(rsp->req_lim_delta);
 
-			target->scsi_host->can_queue = min(target->req_lim,
-							   target->scsi_host->can_queue);
+			/*
+			 * Set can_queue such that the SCSI mid-layer
+			 * never causes __srp_get_tx_iu() to fail.
+			 */
+			target->scsi_host->can_queue
+				= min(target->req_lim - SRP_TSK_MGMT_RSV,
+				      target->scsi_host->can_queue);
 		} else {
 			shost_printk(KERN_WARNING, target->scsi_host,
 				    PFX "Unhandled RSP opcode %#x\n", opcode);
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
