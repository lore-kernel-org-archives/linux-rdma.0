From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 07/14] ib_srp: Introduce srp_handle_qp_err()
Date: Thu, 1 Dec 2011 20:02:56 +0100
Message-ID: <201112012002.56307.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011954.25811.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Factor out common code into a new function.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e6d1aef..44c810b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1217,6 +1217,15 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
+static void srp_handle_qp_err(enum ib_wc_status wc_status,
+			      enum ib_wc_opcode wc_opcode,
+			      struct srp_target_port *target)
+{
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "failed receive status %d\n", wc_status);
+	target->qp_in_error = 1;
+}
+
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
@@ -1227,10 +1236,7 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 		if (wc.status == IB_WC_SUCCESS) {
 			srp_handle_recv(target, &wc);
 		} else {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed receive status %d\n",
-				     wc.status);
-			target->qp_in_error = 1;
+			srp_handle_qp_err(wc.status, wc.opcode, target);
 			break;
 		}
 	}
@@ -1247,10 +1253,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &target->free_tx);
 		} else {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed send status %d\n",
-				     wc.status);
-			target->qp_in_error = 1;
+			srp_handle_qp_err(wc.status, wc.opcode, target);
 			break;
 		}
 	}
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
