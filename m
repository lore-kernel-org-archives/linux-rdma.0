From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/3] IB/core: Add vendor's specific data to alloc mw
Date: Mon, 29 Feb 2016 18:05:29 +0200
Message-ID: <1456761930-11222-3-git-send-email-matanb@mellanox.com>
References: <1456761930-11222-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456761930-11222-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Passing udata to the vendor's driver in order to pass data from the
user-space driver to the kernel-space driver. This data will be
used in downstream patches.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c        | 8 +++++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 3 ++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      | 3 ++-
 drivers/infiniband/hw/cxgb4/mem.c           | 4 +++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h        | 3 ++-
 drivers/infiniband/hw/mlx4/mr.c             | 4 +++-
 drivers/infiniband/hw/nes/nes_verbs.c       | 3 ++-
 include/rdma/ib_verbs.h                     | 3 ++-
 8 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6ffc9c4..2bf751e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1174,6 +1174,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	struct ib_uobject             *uobj;
 	struct ib_pd                  *pd;
 	struct ib_mw                  *mw;
+	struct ib_udata		       udata;
 	int                            ret;
 
 	if (out_len < sizeof(resp))
@@ -1195,7 +1196,12 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		goto err_free;
 	}
 
-	mw = pd->device->alloc_mw(pd, cmd.mw_type);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long)cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
+
+	mw = pd->device->alloc_mw(pd, cmd.mw_type, &udata);
 	if (IS_ERR(mw)) {
 		ret = PTR_ERR(mw);
 		goto err_put;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 2734820..42a7b89 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -657,7 +657,8 @@ err:
 	return ERR_PTR(err);
 }
 
-static struct ib_mw *iwch_alloc_mw(struct ib_pd *pd, enum ib_mw_type type)
+static struct ib_mw *iwch_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+				   struct ib_udata *udata)
 {
 	struct iwch_dev *rhp;
 	struct iwch_pd *php;
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index fb2de75..423a3a9 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -961,7 +961,8 @@ int c4iw_map_mr_sg(struct ib_mr *ibmr,
 		   struct scatterlist *sg,
 		   int sg_nents);
 int c4iw_dealloc_mw(struct ib_mw *mw);
-struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
+struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+			    struct ib_udata *udata);
 struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
 					   u64 length, u64 virt, int acc,
 					   struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 7849890..766d39c 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -34,6 +34,7 @@
 #include <linux/moduleparam.h>
 #include <rdma/ib_umem.h>
 #include <linux/atomic.h>
+#include <rdma/ib_user_verbs.h>
 
 #include "iw_cxgb4.h"
 
@@ -552,7 +553,8 @@ err:
 	return ERR_PTR(err);
 }
 
-struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type)
+struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+			    struct ib_udata *udata)
 {
 	struct c4iw_dev *rhp;
 	struct c4iw_pd *php;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 52ce7b0..1eca01c 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -711,7 +711,8 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata);
 int mlx4_ib_dereg_mr(struct ib_mr *mr);
-struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
+struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+			       struct ib_udata *udata);
 int mlx4_ib_dealloc_mw(struct ib_mw *mw);
 struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 242b94e..ce0b5aa 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/slab.h>
+#include <rdma/ib_user_verbs.h>
 
 #include "mlx4_ib.h"
 
@@ -334,7 +335,8 @@ int mlx4_ib_dereg_mr(struct ib_mr *ibmr)
 	return 0;
 }
 
-struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type)
+struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+			       struct ib_udata *udata)
 {
 	struct mlx4_ib_dev *dev = to_mdev(pd->device);
 	struct mlx4_ib_mw *mw;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8c4daf7..5af19b4 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -56,7 +56,8 @@ static int nes_dereg_mr(struct ib_mr *ib_mr);
 /**
  * nes_alloc_mw
  */
-static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type)
+static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
+				  struct ib_udata *udata)
 {
 	struct nes_pd *nespd = to_nespd(ibpd);
 	struct nes_vnic *nesvnic = to_nesvnic(ibpd->device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 284b00c..3f79070 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1808,7 +1808,8 @@ struct ib_device {
 						struct scatterlist *sg,
 						int sg_nents);
 	struct ib_mw *             (*alloc_mw)(struct ib_pd *pd,
-					       enum ib_mw_type type);
+					       enum ib_mw_type type,
+					       struct ib_udata *udata);
 	int                        (*dealloc_mw)(struct ib_mw *mw);
 	struct ib_fmr *	           (*alloc_fmr)(struct ib_pd *pd,
 						int mr_access_flags,
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
