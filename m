From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 03/10] i40iw: Fix incorrect assignment of SQ head
Date: Fri,  9 Dec 2016 11:54:57 -0600
Message-ID: <1481306104-19352-4-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481306104-19352-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The SQ head is incorrectly incremented when the number
of WQEs required is greater than the number available.
The fix is to use the I40IW_RING_MOV_HEAD_BY_COUNT
macro. This checks for the SQ full condition first and
only if SQ has room for the request, then we move the
head appropriately.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_uk.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index 341772e..9b1a618 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -175,11 +175,10 @@ u64 *i40iw_qp_get_next_send_wqe(struct i40iw_qp_uk *qp,
 			qp->swqe_polarity = !qp->swqe_polarity;
 	}
 
-	for (i = 0; i < wqe_size / I40IW_QP_WQE_MIN_SIZE; i++) {
-		I40IW_RING_MOVE_HEAD(qp->sq_ring, ret_code);
-		if (ret_code)
-			return NULL;
-	}
+	I40IW_RING_MOVE_HEAD_BY_COUNT(qp->sq_ring,
+				      (wqe_size / I40IW_QP_WQE_MIN_SIZE), ret_code);
+	if (ret_code)
+		return NULL;
 
 	wqe = qp->sq_base[*wqe_idx].elem;
 
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
