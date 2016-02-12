From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next] iw_cxgb4: Max fastreg depth depends on DSGL support
Date: Fri, 12 Feb 2016 16:10:35 +0530
Message-ID: <1455273635-30410-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The max depth of a fastreg mr depends on whether the device supports
DSGL or not.  So compute it dynamically based on the device support and
the module use_dsgl option.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c      |  8 +++++---
 drivers/infiniband/hw/cxgb4/provider.c |  3 ++-
 drivers/infiniband/hw/cxgb4/qp.c       | 10 ++++------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 7849890c4781..9274c909cd19 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -617,12 +617,14 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 	int ret = 0;
 	int length = roundup(max_num_sg * sizeof(u64), 32);
 
+	php = to_c4iw_pd(pd);
+	rhp = php->rhp;
+
 	if (mr_type != IB_MR_TYPE_MEM_REG ||
-	    max_num_sg > t4_max_fr_depth(use_dsgl))
+	    max_num_sg > t4_max_fr_depth(&rhp->rdev.lldi.ulptx_memwrite_dsgl &&
+					 use_dsgl))
 		return ERR_PTR(-EINVAL);
 
-	php = to_c4iw_pd(pd);
-	rhp = php->rhp;
 	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
 	if (!mhp) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index ec04272fbdc2..8669f48ebd8e 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -339,7 +339,8 @@ static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
 	props->max_mr = c4iw_num_stags(&dev->rdev);
 	props->max_pd = T4_MAX_NUM_PD;
 	props->local_ca_ack_delay = 0;
-	props->max_fast_reg_page_list_len = t4_max_fr_depth(use_dsgl);
+	props->max_fast_reg_page_list_len =
+		t4_max_fr_depth(dev->rdev.lldi.ulptx_memwrite_dsgl && use_dsgl);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index dadf5f1855b3..d7293132ee86 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -606,7 +606,7 @@ static int build_rdma_recv(struct c4iw_qp *qhp, union t4_recv_wr *wqe,
 }
 
 static int build_memreg(struct t4_sq *sq, union t4_wr *wqe,
-			struct ib_reg_wr *wr, u8 *len16, u8 t5dev)
+			struct ib_reg_wr *wr, u8 *len16, bool dsgl_supported)
 {
 	struct c4iw_mr *mhp = to_c4iw_mr(wr->mr);
 	struct fw_ri_immd *imdp;
@@ -615,7 +615,7 @@ static int build_memreg(struct t4_sq *sq, union t4_wr *wqe,
 	int pbllen = roundup(mhp->mpl_len * sizeof(u64), 32);
 	int rem;
 
-	if (mhp->mpl_len > t4_max_fr_depth(use_dsgl))
+	if (mhp->mpl_len > t4_max_fr_depth(dsgl_supported && use_dsgl))
 		return -EINVAL;
 
 	wqe->fr.qpbinde_to_dcacpu = 0;
@@ -629,7 +629,7 @@ static int build_memreg(struct t4_sq *sq, union t4_wr *wqe,
 	wqe->fr.va_lo_fbo = cpu_to_be32(mhp->ibmr.iova &
 					0xffffffff);
 
-	if (t5dev && use_dsgl && (pbllen > max_fr_immd)) {
+	if (dsgl_supported && use_dsgl && (pbllen > max_fr_immd)) {
 		struct fw_ri_dsgl *sglp;
 
 		for (i = 0; i < mhp->mpl_len; i++)
@@ -808,9 +808,7 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			fw_opcode = FW_RI_FR_NSMR_WR;
 			swsqe->opcode = FW_RI_FAST_REGISTER;
 			err = build_memreg(&qhp->wq.sq, wqe, reg_wr(wr), &len16,
-					   is_t5(
-					   qhp->rhp->rdev.lldi.adapter_type) ?
-					   1 : 0);
+				qhp->rhp->rdev.lldi.ulptx_memwrite_dsgl);
 			break;
 		case IB_WR_LOCAL_INV:
 			if (wr->send_flags & IB_SEND_FENCE)
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
