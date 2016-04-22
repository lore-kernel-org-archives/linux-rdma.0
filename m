From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] RDMA/i40iw: Fix for using one sge for RDMA READ
Date: Fri, 22 Apr 2016 14:14:27 -0500
Message-ID: <1461352469-16504-6-git-send-email-tatyana.e.nikolova@intel.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461352469-16504-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A check is added to validate the requested sge number.
iWARP doesn't support multiple sg elements for
RDMA READ work requests.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 2d832c7..45f70f5 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -74,7 +74,7 @@ static int i40iw_query_device(struct ib_device *ibdev,
 	props->max_cqe = iwdev->max_cqe;
 	props->max_mr = iwdev->max_mr;
 	props->max_pd = iwdev->max_pd;
-	props->max_sge_rd = 1;
+	props->max_sge_rd = I40IW_MAX_SGE_RD;
 	props->max_qp_rd_atom = I40IW_MAX_IRD_SIZE;
 	props->max_qp_init_rd_atom = props->max_qp_rd_atom;
 	props->atomic_cap = IB_ATOMIC_NONE;
@@ -2117,6 +2117,10 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			inv_stag = true;
 			/* fall-through*/
 		case IB_WR_RDMA_READ:
+			if (ib_wr->num_sge > I40IW_MAX_SGE_RD) {
+				err = -EINVAL;
+				break;
+			}
 			info.op_type = I40IW_OP_TYPE_RDMA_READ;
 			info.op.rdma_read.rem_addr.tag_off = rdma_wr(ib_wr)->remote_addr;
 			info.op.rdma_read.rem_addr.stag = rdma_wr(ib_wr)->rkey;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
