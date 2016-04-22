From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] RDMA/i40iw: Fix for a NOP WQE size
Date: Fri, 22 Apr 2016 14:14:25 -0500
Message-ID: <1461352469-16504-4-git-send-email-tatyana.e.nikolova@intel.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461352469-16504-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mohammad Khan <mohammad.a.khan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix for filling in the WQE size for NOP

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_uk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 6e0e327..2cd9091 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -56,6 +56,9 @@ static enum i40iw_status_code i40iw_nop_1(struct i40iw_qp_uk *qp)
 
 	wqe_idx = I40IW_RING_GETCURRENT_HEAD(qp->sq_ring);
 	wqe = qp->sq_base[wqe_idx].elem;
+
+	qp->sq_wrtrk_array[wqe_idx].wqe_size = I40IW_QP_WQE_MIN_SIZE;
+
 	peek_head = (qp->sq_ring.head + 1) % qp->sq_ring.size;
 	wqe_0 = qp->sq_base[peek_head].elem;
 	if (peek_head)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
