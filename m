From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Code cleanup, remove check of PBLE pages
Date: Wed, 30 Nov 2016 15:13:47 -0600
Message-ID: <20161130211347.18276-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove check for zero 'pages' of unallocated pbles calculated in
add_pble_pool(); as it can never be true.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_pble.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_pble.c b/drivers/infiniband/hw/i40iw/i40iw_pble.c
index 85993dc..c87ba16 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_pble.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_pble.c
@@ -353,10 +353,6 @@ static enum i40iw_status_code add_pble_pool(struct i40iw_sc_dev *dev,
 	pages = (idx->rel_pd_idx) ? (I40IW_HMC_PD_CNT_IN_SD -
 			idx->rel_pd_idx) : I40IW_HMC_PD_CNT_IN_SD;
 	pages = min(pages, pble_rsrc->unallocated_pble >> PBLE_512_SHIFT);
-	if (!pages) {
-		ret_code = I40IW_ERR_NO_PBLCHUNKS_AVAILABLE;
-		goto error;
-	}
 	info.chunk = chunk;
 	info.hmc_info = hmc_info;
 	info.pages = pages;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
