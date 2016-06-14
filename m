From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] i40iw: Return correct max_fast_reg_page_list_len
Date: Tue, 14 Jun 2016 16:54:18 -0500
Message-ID: <1465941259-4492-4-git-send-email-shiraz.saleem@intel.com>
References: <1465941259-4492-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465941259-4492-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Return correct value for max_fast_reg_page_list_len from
i40iw_query_device().

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       | 1 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 8b95320..14f16a2 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -113,6 +113,7 @@
 
 #define IW_HMC_OBJ_TYPE_NUM ARRAY_SIZE(iw_hmc_obj_types)
 #define IW_CFG_FPM_QP_COUNT		32768
+#define I40IW_MAX_PAGES_PER_FMR		512
 
 #define I40IW_MTU_TO_MSS		40
 #define I40IW_DEFAULT_MSS		1460
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 65bea9c..31eda323 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -79,6 +79,7 @@ static int i40iw_query_device(struct ib_device *ibdev,
 	props->max_qp_init_rd_atom = props->max_qp_rd_atom;
 	props->atomic_cap = IB_ATOMIC_NONE;
 	props->max_map_per_fmr = 1;
+	props->max_fast_reg_page_list_len = I40IW_MAX_PAGES_PER_FMR;
 	return 0;
 }
 
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
