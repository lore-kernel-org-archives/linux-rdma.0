From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 01/43] IB: Modify ib_create_mr API
Date: Wed, 22 Jul 2015 09:55:01 +0300
Message-ID: <1437548143-24893-2-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use ib_alloc_mr with specific parameters.
Change the existing callers.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c          | 20 ++++++++++++------
 drivers/infiniband/hw/mlx5/main.c        |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  6 ++++--
 drivers/infiniband/hw/mlx5/mr.c          | 21 ++++++++++++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c |  4 +---
 drivers/infiniband/ulp/isert/ib_isert.c  |  6 +-----
 include/rdma/ib_verbs.h                  | 36 ++++++++++----------------------
 7 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8197ce7..23d73bd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1235,16 +1235,24 @@ int ib_dereg_mr(struct ib_mr *mr)
 }
 EXPORT_SYMBOL(ib_dereg_mr);
 
-struct ib_mr *ib_create_mr(struct ib_pd *pd,
-			   struct ib_mr_init_attr *mr_init_attr)
+/**
+ * ib_alloc_mr() - Allocates a memory region
+ * @pd:            protection domain associated with the region
+ * @mr_type:       memory region type
+ * @max_entries:   maximum registration entries available
+ * @flags:         create flags
+ */
+struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
+			  enum ib_mr_type mr_type,
+			  u32 max_entries,
+			  u32 flags)
 {
 	struct ib_mr *mr;
 
-	if (!pd->device->create_mr)
+	if (!pd->device->alloc_mr)
 		return ERR_PTR(-ENOSYS);
 
-	mr = pd->device->create_mr(pd, mr_init_attr);
-
+	mr = pd->device->alloc_mr(pd, mr_type, max_entries, flags);
 	if (!IS_ERR(mr)) {
 		mr->device  = pd->device;
 		mr->pd      = pd;
@@ -1255,7 +1263,7 @@ struct ib_mr *ib_create_mr(struct ib_pd *pd,
 
 	return mr;
 }
-EXPORT_SYMBOL(ib_create_mr);
+EXPORT_SYMBOL(ib_alloc_mr);
 
 struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
 {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 48f02da..82a371f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1502,7 +1502,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.attach_mcast	= mlx5_ib_mcg_attach;
 	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
 	dev->ib_dev.process_mad		= mlx5_ib_process_mad;
-	dev->ib_dev.create_mr		= mlx5_ib_create_mr;
+	dev->ib_dev.alloc_mr		= mlx5_ib_alloc_mr;
 	dev->ib_dev.alloc_fast_reg_mr	= mlx5_ib_alloc_fast_reg_mr;
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 29c74e9..cd6fb5d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -573,8 +573,10 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index,
 		       int npages, int zap);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
-struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
-				struct ib_mr_init_attr *mr_init_attr);
+struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
+			       enum ib_mr_type mr_type,
+			       u32 max_entries,
+			       u32 flags);
 struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len);
 struct ib_fast_reg_page_list *mlx5_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 3197c00..185c963 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1247,14 +1247,19 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 	return 0;
 }
 
-struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
-				struct ib_mr_init_attr *mr_init_attr)
+struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
+			       enum ib_mr_type mr_type,
+			       u32 max_entries,
+			       u32 flags)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_create_mkey_mbox_in *in;
 	struct mlx5_ib_mr *mr;
 	int access_mode, err;
-	int ndescs = roundup(mr_init_attr->max_reg_descriptors, 4);
+	int ndescs = roundup(max_entries, 4);
+
+	if (flags)
+		return ERR_PTR(-EINVAL);
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
@@ -1270,9 +1275,11 @@ struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
 	in->seg.xlt_oct_size = cpu_to_be32(ndescs);
 	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
 	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
-	access_mode = MLX5_ACCESS_MODE_MTT;
 
-	if (mr_init_attr->flags & IB_MR_SIGNATURE_EN) {
+	if (mr_type == IB_MR_TYPE_FAST_REG) {
+		access_mode = MLX5_ACCESS_MODE_MTT;
+		in->seg.log2_page_size = PAGE_SHIFT;
+	} else if (mr_type == IB_MR_TYPE_SIGNATURE) {
 		u32 psv_index[2];
 
 		in->seg.flags_pd = cpu_to_be32(be32_to_cpu(in->seg.flags_pd) |
@@ -1298,6 +1305,10 @@ struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
 		mr->sig->sig_err_exists = false;
 		/* Next UMR, Arm SIGERR */
 		++mr->sig->sigerr_count;
+	} else {
+		mlx5_ib_warn(dev, "Invalid mr type %d\n", mr_type);
+		err = -EINVAL;
+		goto err_free_in;
 	}
 
 	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 7a5c49f..6be4d4a 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -326,8 +326,6 @@ iser_alloc_pi_ctx(struct ib_device *ib_device,
 		  unsigned int size)
 {
 	struct iser_pi_context *pi_ctx = NULL;
-	struct ib_mr_init_attr mr_init_attr = {.max_reg_descriptors = 2,
-					       .flags = IB_MR_SIGNATURE_EN};
 	int ret;
 
 	desc->pi_ctx = kzalloc(sizeof(*desc->pi_ctx), GFP_KERNEL);
@@ -342,7 +340,7 @@ iser_alloc_pi_ctx(struct ib_device *ib_device,
 		goto alloc_reg_res_err;
 	}
 
-	pi_ctx->sig_mr = ib_create_mr(pd, &mr_init_attr);
+	pi_ctx->sig_mr = ib_alloc_mr(pd, IB_MR_TYPE_SIGNATURE, 2, 0);
 	if (IS_ERR(pi_ctx->sig_mr)) {
 		ret = PTR_ERR(pi_ctx->sig_mr);
 		goto sig_mr_failure;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e59228d..f0b7c9b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -508,7 +508,6 @@ isert_create_pi_ctx(struct fast_reg_descriptor *desc,
 		    struct ib_device *device,
 		    struct ib_pd *pd)
 {
-	struct ib_mr_init_attr mr_init_attr;
 	struct pi_context *pi_ctx;
 	int ret;
 
@@ -536,10 +535,7 @@ isert_create_pi_ctx(struct fast_reg_descriptor *desc,
 	}
 	desc->ind |= ISERT_PROT_KEY_VALID;
 
-	memset(&mr_init_attr, 0, sizeof(mr_init_attr));
-	mr_init_attr.max_reg_descriptors = 2;
-	mr_init_attr.flags |= IB_MR_SIGNATURE_EN;
-	pi_ctx->sig_mr = ib_create_mr(pd, &mr_init_attr);
+	pi_ctx->sig_mr = ib_alloc_mr(pd, IB_MR_TYPE_SIGNATURE, 2, 0);
 	if (IS_ERR(pi_ctx->sig_mr)) {
 		isert_err("Failed to allocate signature enabled mr err=%ld\n",
 			  PTR_ERR(pi_ctx->sig_mr));
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4468a64..5ec9a70 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -556,20 +556,9 @@ __attribute_const__ int ib_rate_to_mult(enum ib_rate rate);
  */
 __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
 
-enum ib_mr_create_flags {
-	IB_MR_SIGNATURE_EN = 1,
-};
-
-/**
- * ib_mr_init_attr - Memory region init attributes passed to routine
- *     ib_create_mr.
- * @max_reg_descriptors: max number of registration descriptors that
- *     may be used with registration work requests.
- * @flags: MR creation flags bit mask.
- */
-struct ib_mr_init_attr {
-	int	    max_reg_descriptors;
-	u32	    flags;
+enum ib_mr_type {
+	IB_MR_TYPE_FAST_REG,
+	IB_MR_TYPE_SIGNATURE,
 };
 
 /**
@@ -1668,8 +1657,10 @@ struct ib_device {
 	int                        (*query_mr)(struct ib_mr *mr,
 					       struct ib_mr_attr *mr_attr);
 	int                        (*dereg_mr)(struct ib_mr *mr);
-	struct ib_mr *		   (*create_mr)(struct ib_pd *pd,
-						struct ib_mr_init_attr *mr_init_attr);
+	struct ib_mr *		   (*alloc_mr)(struct ib_pd *pd,
+					       enum ib_mr_type mr_type,
+					       u32 max_entries,
+					       u32 flags);
 	struct ib_mr *		   (*alloc_fast_reg_mr)(struct ib_pd *pd,
 					       int max_page_list_len);
 	struct ib_fast_reg_page_list * (*alloc_fast_reg_page_list)(struct ib_device *device,
@@ -2806,15 +2797,10 @@ int ib_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr);
  */
 int ib_dereg_mr(struct ib_mr *mr);
 
-
-/**
- * ib_create_mr - Allocates a memory region that may be used for
- *     signature handover operations.
- * @pd: The protection domain associated with the region.
- * @mr_init_attr: memory region init attributes.
- */
-struct ib_mr *ib_create_mr(struct ib_pd *pd,
-			   struct ib_mr_init_attr *mr_init_attr);
+struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
+			  enum ib_mr_type mr_type,
+			  u32 max_entries,
+			  u32 flags);
 
 /**
  * ib_alloc_fast_reg_mr - Allocates memory region usable with the
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
