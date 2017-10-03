From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 4/5] i40iw: Add missing memory barriers
Date: Tue,  3 Oct 2017 11:11:49 -0500
Message-ID: <20171003161150.16172-5-shiraz.saleem@intel.com>
References: <20171003161150.16172-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171003161150.16172-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove duplicate set_64bit_val call to offset 24.
Replace some instances of set_64bit_val with
i40iw_insert_wqe_hdr as valid bit needs a write
barrier and should be the last write operation for the WQE.

Fixes: 786c6adb3a94 ("i40iw: add puda code")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_p.h    |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 11 ++++-------
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index d1f5345..42ca534 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -48,7 +48,7 @@
  * @wqe: cqp wqe for header
  * @header: header for the cqp wqe
  */
-static inline void i40iw_insert_wqe_hdr(u64 *wqe, u64 header)
+void i40iw_insert_wqe_hdr(u64 *wqe, u64 header)
 {
 	wmb();            /* make sure WQE is populated before polarity is set */
 	set_64bit_val(wqe, 24, header);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_p.h b/drivers/infiniband/hw/i40iw/i40iw_p.h
index e217a12..5498ad0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_p.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_p.h
@@ -59,6 +59,8 @@ enum i40iw_status_code i40iw_sc_mr_fast_register(struct i40iw_sc_qp *qp,
 						 struct i40iw_fast_reg_stag_info *info,
 						 bool post_sq);
 
+void i40iw_insert_wqe_hdr(u64 *wqe, u64 header);
+
 /* HMC/FPM functions */
 enum i40iw_status_code i40iw_sc_init_iw_hmc(struct i40iw_sc_dev *dev,
 					    u8 hmc_fn_id);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index c2cab20..59f7067 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -123,12 +123,11 @@ static void i40iw_puda_post_recvbuf(struct i40iw_puda_rsrc *rsrc, u32 wqe_idx,
 		get_64bit_val(wqe, 24, &offset24);
 
 	offset24 = (offset24) ? 0 : LS_64(1, I40IWQPSQ_VALID);
-	set_64bit_val(wqe, 24, offset24);
 
 	set_64bit_val(wqe, 0, buf->mem.pa);
 	set_64bit_val(wqe, 8,
 		      LS_64(buf->mem.size, I40IWQPSQ_FRAG_LEN));
-	set_64bit_val(wqe, 24, offset24);
+	i40iw_insert_wqe_hdr(wqe, offset24);
 }
 
 /**
@@ -409,9 +408,7 @@ enum i40iw_status_code i40iw_puda_send(struct i40iw_sc_qp *qp,
 	set_64bit_val(wqe, 8, LS_64(info->len, I40IWQPSQ_FRAG_LEN));
 	set_64bit_val(wqe, 16, header[0]);
 
-	/* Ensure all data is written before writing valid bit */
-	wmb();
-	set_64bit_val(wqe, 24, header[1]);
+	i40iw_insert_wqe_hdr(wqe, header[1]);
 
 	i40iw_debug_buf(qp->dev, I40IW_DEBUG_PUDA, "PUDA SEND WQE", wqe, 32);
 	i40iw_qp_post_wr(&qp->qp_uk);
@@ -539,7 +536,7 @@ static enum i40iw_status_code i40iw_puda_qp_wqe(struct i40iw_sc_dev *dev, struct
 		 LS_64(2, I40IW_CQPSQ_QP_NEXTIWSTATE) |
 		 LS_64(cqp->polarity, I40IW_CQPSQ_WQEVALID);
 
-	set_64bit_val(wqe, 24, header);
+	i40iw_insert_wqe_hdr(wqe, header);
 
 	i40iw_debug_buf(cqp->dev, I40IW_DEBUG_PUDA, "PUDA CQE", wqe, 32);
 	i40iw_sc_cqp_post_sq(cqp);
@@ -655,7 +652,7 @@ static enum i40iw_status_code i40iw_puda_cq_wqe(struct i40iw_sc_dev *dev, struct
 	    LS_64(1, I40IW_CQPSQ_CQ_ENCEQEMASK) |
 	    LS_64(1, I40IW_CQPSQ_CQ_CEQIDVALID) |
 	    LS_64(cqp->polarity, I40IW_CQPSQ_WQEVALID);
-	set_64bit_val(wqe, 24, header);
+	i40iw_insert_wqe_hdr(wqe, header);
 
 	i40iw_debug_buf(dev, I40IW_DEBUG_PUDA, "PUDA CQE",
 			wqe, I40IW_CQP_WQE_SIZE * 8);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
