From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 4/5] IB/srp: Reduce number of BUSY conditions
Date: Sat, 16 Oct 2010 23:25:24 -0400
Message-ID: <1287285925-11710-5-git-send-email-dillowda@ornl.gov>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287285925-11710-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

As proposed by the SRP (draft) standard, ib_srp reserves one ring
element for SRP_TSK_MGMT requests. This patch makes sure that the SCSI
mid-layer never tries to queue more than (SRP request limit) - 1 SCSI
commands to ib_srp. This improves performance for targets whose request
limit is less than or equal to SRP_NORMAL_REQ_SQ_SIZE by reducing the
number of BUSY responses reported by ib_srp to the SCSI mid-layer.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d4c08d6..4df8275 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1339,8 +1339,13 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 			target->max_ti_iu_len = be32_to_cpu(rsp->max_ti_iu_len);
 			target->req_lim       = be32_to_cpu(rsp->req_lim_delta);
 
-			target->scsi_host->can_queue = min(target->req_lim,
-							   target->scsi_host->can_queue);
+			/*
+			 * Reserve credits for task management so we don't
+			 * bounce requests back to the SCSI mid-layer.
+			 */
+			target->scsi_host->can_queue
+				= min(target->req_lim - SRP_TSK_MGMT_SQ_SIZE,
+				      target->scsi_host->can_queue);
 		} else {
 			shost_printk(KERN_WARNING, target->scsi_host,
 				    PFX "Unhandled RSP opcode %#x\n", opcode);
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
