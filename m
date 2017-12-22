From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 rdma-next 2/9] i40iw: Use utility function roundup_pow_of_two()
Date: Fri, 22 Dec 2017 14:29:25 -0600
Message-ID: <20171222202932.9324-3-shiraz.saleem@intel.com>
References: <20171222202932.9324-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222202932.9324-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Consolidate all power of 2 round calculations to
use kernel utility function roundup_pow_of_two().

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c   |  7 +------
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 14 +++-----------
 drivers/infiniband/hw/i40iw/i40iw_uk.c   | 18 ++----------------
 3 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 493d6ef..03e6fc6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -92,14 +92,9 @@ void i40iw_free_sqbuf(struct i40iw_sc_vsi *vsi, void *bufp)
 static u8 i40iw_derive_hw_ird_setting(u16 cm_ird)
 {
 	u8 encoded_ird_size;
-	u8 pof2_cm_ird = 1;
-
-	/* round-off to next powerof2 */
-	while (pof2_cm_ird < cm_ird)
-		pof2_cm_ird *= 2;
 
 	/* ird_size field is encoded in qp_ctx */
-	switch (pof2_cm_ird) {
+	switch (cm_ird ? roundup_pow_of_two(cm_ird) : 0) {
 	case I40IW_HW_IRD_SETTING_64:
 		encoded_ird_size = 3;
 		break;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index d88c6cf..1f9594e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -3855,7 +3855,6 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 	struct i40iw_virt_mem virt_mem;
 	u32 i, mem_size;
 	u32 qpwantedoriginal, qpwanted, mrwanted, pblewanted;
-	u32 powerof2;
 	u64 sd_needed;
 	u32 loop_count = 0;
 
@@ -3928,16 +3927,9 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 		if ((loop_count > 1000) ||
 		    ((!(loop_count % 10)) &&
 		    (qpwanted > qpwantedoriginal * 2 / 3))) {
-			if (qpwanted > FPM_MULTIPLIER) {
-				qpwanted -= FPM_MULTIPLIER;
-				powerof2 = 1;
-				while (powerof2 < qpwanted)
-					powerof2 *= 2;
-				powerof2 /= 2;
-				qpwanted = powerof2;
-			} else {
-				qpwanted /= 2;
-			}
+			if (qpwanted > FPM_MULTIPLIER)
+				qpwanted = roundup_pow_of_two(qpwanted - FPM_MULTIPLIER);
+			qpwanted >>= 1;
 		}
 		if (mrwanted > FPM_MULTIPLIER * 10)
 			mrwanted -= FPM_MULTIPLIER * 10;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 3ec5389..8afa5a6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -894,20 +894,6 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 }
 
 /**
- * i40iw_qp_roundup - return round up QP WQ depth
- * @wqdepth: WQ depth in quantas to round up
- */
-static int i40iw_qp_round_up(u32 wqdepth)
-{
-	int scount = 1;
-
-	for (wqdepth--; scount <= 16; scount *= 2)
-		wqdepth |= wqdepth >> scount;
-
-	return ++wqdepth;
-}
-
-/**
  * i40iw_get_wqe_shift - get shift count for maximum wqe size
  * @sge: Maximum Scatter Gather Elements wqe
  * @inline_data: Maximum inline data size
@@ -934,7 +920,7 @@ void i40iw_get_wqe_shift(u32 sge, u32 inline_data, u8 *shift)
  */
 enum i40iw_status_code i40iw_get_sqdepth(u32 sq_size, u8 shift, u32 *sqdepth)
 {
-	*sqdepth = i40iw_qp_round_up((sq_size << shift) + I40IW_SQ_RSVD);
+	*sqdepth = roundup_pow_of_two((sq_size << shift) + I40IW_SQ_RSVD);
 
 	if (*sqdepth < (I40IW_QP_SW_MIN_WQSIZE << shift))
 		*sqdepth = I40IW_QP_SW_MIN_WQSIZE << shift;
@@ -953,7 +939,7 @@ enum i40iw_status_code i40iw_get_sqdepth(u32 sq_size, u8 shift, u32 *sqdepth)
  */
 enum i40iw_status_code i40iw_get_rqdepth(u32 rq_size, u8 shift, u32 *rqdepth)
 {
-	*rqdepth = i40iw_qp_round_up((rq_size << shift) + I40IW_RQ_RSVD);
+	*rqdepth = roundup_pow_of_two((rq_size << shift) + I40IW_RQ_RSVD);
 
 	if (*rqdepth < (I40IW_QP_SW_MIN_WQSIZE << shift))
 		*rqdepth = I40IW_QP_SW_MIN_WQSIZE << shift;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
