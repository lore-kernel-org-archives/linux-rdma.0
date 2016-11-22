From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Fix incorrect assignment of SQ head
Date: Tue, 22 Nov 2016 09:44:20 -0600
Message-ID: <20161122154420.32876-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The SQ head is incorrectly incremented when the number
of WQEs required is greater than the number available.
The fix is to use the I40IW_RING_MOV_HEAD_BY_COUNT
macro. This checks for the SQ full condition first and
only if SQ has room for the request, then we move the
head appropriately.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_uk.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 4d28c3c..3987cd8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -175,12 +175,10 @@ u64 *i40iw_qp_get_next_send_wqe(struct i40iw_qp_uk *qp,
 		if (!*wqe_idx)
 			qp->swqe_polarity = !qp->swqe_polarity;
 	}
-
-	for (i = 0; i < wqe_size / I40IW_QP_WQE_MIN_SIZE; i++) {
-		I40IW_RING_MOVE_HEAD(qp->sq_ring, ret_code);
-		if (ret_code)
-			return NULL;
-	}
+	I40IW_RING_MOVE_HEAD_BY_COUNT(qp->sq_ring,
+				      wqe_size / I40IW_QP_WQE_MIN_SIZE, ret_code);
+	if (ret_code)
+		return NULL;
 
 	wqe = qp->sq_base[*wqe_idx].elem;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
