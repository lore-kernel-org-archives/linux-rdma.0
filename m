From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Send last streaming mode message for loopback connections
Date: Wed, 24 Aug 2016 13:59:17 -0500
Message-ID: <1472065157-56936-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Send a zero length last streaming mode message for loopback
connections to synchronize between accepting QP and connecting QP.
This avoids data transfer to start on the accepting QP before
the connecting QP is in RTS. Also remove function i40iw_loopback_nop()
as it is no longer used.

Fixes: f27b4746f378 ("i40iw: add connection management code")

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 6434398..7ca0638 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3347,26 +3347,6 @@ int i40iw_cm_disconn(struct i40iw_qp *iwqp)
 }
 
 /**
- * i40iw_loopback_nop - Send a nop
- * @qp: associated hw qp
- */
-static void i40iw_loopback_nop(struct i40iw_sc_qp *qp)
-{
-	u64 *wqe;
-	u64 header;
-
-	wqe = qp->qp_uk.sq_base->elem;
-	set_64bit_val(wqe, 0, 0);
-	set_64bit_val(wqe, 8, 0);
-	set_64bit_val(wqe, 16, 0);
-
-	header = LS_64(I40IWQP_OP_NOP, I40IWQPSQ_OPCODE) |
-	    LS_64(0, I40IWQPSQ_SIGCOMPL) |
-	    LS_64(qp->qp_uk.swqe_polarity, I40IWQPSQ_VALID);
-	set_64bit_val(wqe, 24, header);
-}
-
-/**
  * i40iw_qp_disconnect - free qp and close cm
  * @iwqp: associate qp for the connection
  */
@@ -3638,7 +3618,7 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	} else {
 		if (iwqp->page)
 			iwqp->sc_qp.qp_uk.sq_base = kmap(iwqp->page);
-		i40iw_loopback_nop(&iwqp->sc_qp);
+		dev->iw_priv_qp_ops->qp_send_lsmm(&iwqp->sc_qp, NULL, 0, 0);
 	}
 
 	if (iwqp->page)
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
