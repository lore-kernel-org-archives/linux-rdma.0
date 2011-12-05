From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Fix terminate during AE
Date: Mon, 5 Dec 2011 11:39:12 -0600
Message-ID: <20111205173912.GA5492@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for reset which happens right after sending a terminate message.
Terminate timer is not deleted when the connection is closed.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index fc050aa..793ccd6 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2836,6 +2836,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 		issue_disconn = 1;
 		issue_close = 1;
 		nesqp->cm_id = NULL;
+		del_timer(&nesqp->terminate_timer);
 		if (nesqp->flush_issued == 0) {
 			nesqp->flush_issued = 1;
 			issue_flush = 1;
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 355786c..5bcd645 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3619,10 +3619,6 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 			}
 			break;
 		case NES_AEQE_AEID_LLP_CLOSE_COMPLETE:
-			if (nesqp->term_flags) {
-				nes_terminate_done(nesqp, 0);
-				return;
-			}
 			spin_lock_irqsave(&nesqp->lock, flags);
 			nesqp->hw_iwarp_state = iwarp_state;
 			nesqp->hw_tcp_state = tcp_state;
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
