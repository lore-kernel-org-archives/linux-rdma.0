From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 15/15] RDMA/bnxt_re: Disable FMR by default
Date: Wed, 17 May 2017 02:19:51 -0700
Message-ID: <1495012791-5053-16-git-send-email-selvin.xavier@broadcom.com>
References: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495012791-5053-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding a config mechanism to enable/disable FMR support.
There are some issues seen with FMR implementation during
stress traffic. So disabling it by default for now.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/Kconfig    | 8 ++++++++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +++++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h | 2 ++
 drivers/infiniband/hw/bnxt_re/main.c     | 2 ++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/Kconfig b/drivers/infiniband/hw/bnxt_re/Kconfig
index 19982a4..f1ea349 100644
--- a/drivers/infiniband/hw/bnxt_re/Kconfig
+++ b/drivers/infiniband/hw/bnxt_re/Kconfig
@@ -7,3 +7,11 @@ config INFINIBAND_BNXT_RE
 	  This driver supports Broadcom NetXtreme-E 10/25/40/50 gigabit
 	  RoCE HCAs.  To compile this driver as a module, choose M here:
 	  the module will be called bnxt_re.
+
+config BNXT_RE_FMR
+    bool "FMR Support for Netxtreme HCA (EXPERIMENTAL)"
+    default n
+    depends on INFINIBAND_BNXT_RE
+    ---help---
+	   Say Y here if you want enable FMR support for bnxt_re driver.
+	   If unsure say N.
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index aa3d2e6..8e3c1a3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -189,8 +189,10 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_total_mcast_qp_attach = 0;
 	ib_attr->max_ah = dev_attr->max_ah;
 
+#ifdef CONFIG_BNXT_RE_FMR
 	ib_attr->max_fmr = dev_attr->max_fmr;
-	ib_attr->max_map_per_fmr = 1;	/* ? */
+	ib_attr->max_map_per_fmr = 1;
+#endif
 
 	ib_attr->max_srq = dev_attr->max_srq;
 	ib_attr->max_srq_wr = dev_attr->max_srq_wqes;
@@ -3215,6 +3217,7 @@ int bnxt_re_dealloc_mw(struct ib_mw *ib_mw)
 }
 
 /* Fast Memory Regions */
+#ifdef CONFIG_BNXT_RE_FMR
 struct ib_fmr *bnxt_re_alloc_fmr(struct ib_pd *ib_pd, int mr_access_flags,
 				 struct ib_fmr_attr *fmr_attr)
 {
@@ -3307,6 +3310,7 @@ int bnxt_re_dealloc_fmr(struct ib_fmr *ib_fmr)
 	atomic_dec(&rdev->mr_count);
 	return rc;
 }
+#endif
 
 /* uverbs */
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 93539e3..279e7bf 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -195,12 +195,14 @@ int bnxt_re_dereg_mr(struct ib_mr *mr);
 struct ib_mw *bnxt_re_alloc_mw(struct ib_pd *ib_pd, enum ib_mw_type type,
 			       struct ib_udata *udata);
 int bnxt_re_dealloc_mw(struct ib_mw *mw);
+#ifdef CONFIG_BNXT_RE_FMR
 struct ib_fmr *bnxt_re_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 				 struct ib_fmr_attr *fmr_attr);
 int bnxt_re_map_phys_fmr(struct ib_fmr *fmr, u64 *page_list, int list_len,
 			 u64 iova);
 int bnxt_re_unmap_fmr(struct list_head *fmr_list);
 int bnxt_re_dealloc_fmr(struct ib_fmr *fmr);
+#endif
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int mr_access_flags,
 				  struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 00dab7c..eecb3de 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -510,10 +510,12 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 	ibdev->dereg_mr			= bnxt_re_dereg_mr;
 	ibdev->alloc_mr			= bnxt_re_alloc_mr;
 	ibdev->map_mr_sg		= bnxt_re_map_mr_sg;
+#ifdef CONFIG_BNXT_RE_FMR
 	ibdev->alloc_fmr		= bnxt_re_alloc_fmr;
 	ibdev->map_phys_fmr		= bnxt_re_map_phys_fmr;
 	ibdev->unmap_fmr		= bnxt_re_unmap_fmr;
 	ibdev->dealloc_fmr		= bnxt_re_dealloc_fmr;
+#endif
 
 	ibdev->reg_user_mr		= bnxt_re_reg_user_mr;
 	ibdev->alloc_ucontext		= bnxt_re_alloc_ucontext;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
