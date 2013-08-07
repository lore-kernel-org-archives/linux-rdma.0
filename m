From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] RDMA/ocrdma: Cache recv DB till QP moved to RTR.
Date: Wed, 7 Aug 2013 12:52:37 +0530
Message-ID: <605f9558-485d-4ff0-9ba8-f81df79dbade@CMEXHTCAS1.ad.emulex.com>
References: <1375860157-10588-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375860157-10588-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Following things are addressed in this patch.
1) In the post recv, dont ring the DB doorbell if the QP is not yet
   moved to RTR state. Cache the DB calls, till the QP is moved to RTS state.
2) Added max_rd_sge support to dev->attr.
3) Code cleanup in alloc_pd path.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  3 +++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 29 +++++++++++++++++++++++------
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 8d54dc7..e798837 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -60,6 +60,7 @@ struct ocrdma_dev_attr {
 	int max_send_sge;
 	int max_recv_sge;
 	int max_srq_sge;
+	int max_rdma_sge;
 	int max_mr;
 	u64 max_mr_size;
 	u32 max_num_mr_pbl;
@@ -287,6 +288,7 @@ struct ocrdma_qp {
 	u32 qkey;
 	bool dpp_enabled;
 	u8 *ird_q_va;
+	u16 db_cache;
 };
 
 struct ocrdma_hw_mr {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index c4bb29c..97bb1ce 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -992,6 +992,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_srq_sge = (rsp->max_srq_rqe_sge &
 			      OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_OFFSET;
+	attr->max_rdma_sge = (rsp->max_write_send_sge &
+			      OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_MASK) >>
+	    OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT;
 	attr->max_ord_per_qp = (rsp->max_ird_ord_per_qp &
 				OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 96a9629..0184009 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1306,7 +1306,7 @@ struct ocrdma_reg_nsmr_cont {
 	u32 last;
 
 	struct ocrdma_pa pbl[MAX_OCRDMA_NSMR_PBL];
-} __packed;
+};
 
 struct ocrdma_pbe {
 	u32 pa_hi;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 8bf9748..0caa411 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -84,7 +84,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 					IB_DEVICE_SYS_IMAGE_GUID |
 					IB_DEVICE_LOCAL_DMA_LKEY;
 	attr->max_sge = min(dev->attr.max_send_sge, dev->attr.max_srq_sge);
-	attr->max_sge_rd = 0;
+	attr->max_sge_rd = dev->attr.max_rdma_sge;
 	attr->max_cq = dev->attr.max_cq;
 	attr->max_cqe = dev->attr.max_cqe;
 	attr->max_mr = dev->attr.max_mr;
@@ -326,7 +326,7 @@ int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	return status;
 }
 
-static int ocrdma_copy_pd_uresp(struct ocrdma_pd *pd,
+static int ocrdma_copy_pd_uresp(struct ocrdma_dev *dev, struct ocrdma_pd *pd,
 				struct ib_ucontext *ib_ctx,
 				struct ib_udata *udata)
 {
@@ -336,7 +336,6 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_pd *pd,
 	u32 db_page_size;
 	struct ocrdma_alloc_pd_uresp rsp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ib_ctx);
-	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 
 	rsp.id = pd->id;
 	rsp.dpp_enabled = pd->dpp_enabled;
@@ -398,14 +397,15 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 	}
 
 	if (udata && context) {
-		status = ocrdma_copy_pd_uresp(pd, context, udata);
+		status = ocrdma_copy_pd_uresp(dev, pd, context, udata);
 		if (status)
 			goto err;
 	}
 	return &pd->ibpd;
 
 err:
-	ocrdma_dealloc_pd(&pd->ibpd);
+	status = ocrdma_mbx_dealloc_pd(dev, pd);
+	kfree(pd);
 	return ERR_PTR(status);
 }
 
@@ -1087,6 +1087,17 @@ gen_err:
 	return ERR_PTR(status);
 }
 
+
+static void ocrdma_flush_rq_db(struct ocrdma_qp *qp)
+{
+	if (qp->db_cache) {
+		u32 val = qp->rq.dbid | (qp->db_cache <<
+				ocrdma_get_num_posted_shift(qp));
+		iowrite32(val, qp->rq_db);
+		qp->db_cache = 0;
+	}
+}
+
 int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask)
 {
@@ -1105,6 +1116,9 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (status < 0)
 		return status;
 	status = ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask, old_qps);
+	if (!status && attr_mask & IB_QP_STATE && attr->qp_state == IB_QPS_RTR)
+		ocrdma_flush_rq_db(qp);
+
 	return status;
 }
 
@@ -1818,7 +1832,10 @@ static void ocrdma_ring_rq_db(struct ocrdma_qp *qp)
 {
 	u32 val = qp->rq.dbid | (1 << ocrdma_get_num_posted_shift(qp));
 
-	iowrite32(val, qp->rq_db);
+	if (qp->state != OCRDMA_QPS_INIT)
+		iowrite32(val, qp->rq_db);
+	else
+		qp->db_cache++;
 }
 
 static void ocrdma_build_rqe(struct ocrdma_hdr_wqe *rqe, struct ib_recv_wr *wr,
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
