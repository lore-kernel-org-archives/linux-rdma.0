From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/6] IB/mlx5: Move ODP initialization to the corresponding stage
Date: Sun, 24 Dec 2017 14:40:12 +0200
Message-ID: <20171224124015.31917-4-leon@kernel.org>
References: <20171224124015.31917-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224124015.31917-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Now that we have a stage just for ODP, move all relevant
initialization logic into one place.

In addition, ODP structs might not be always initialized, the
srcu which is used to sync between page faults and mkeys deletion
might not be initialized, wrap the call with a callback which
is only initialized when the ODP stage is used.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  6 +++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 21 ++++++++++++--------
 drivers/infiniband/hw/mlx5/mr.c      |  7 ++++---
 drivers/infiniband/hw/mlx5/odp.c     | 38 +++++++++++++++++++++---------------
 4 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ac72f62a9342..6fbd72b6d624 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -760,7 +760,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (MLX5_CAP_GEN(mdev, pg))
 		props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
-	props->odp_caps = dev->odp_caps;
+	props->odp_caps = dev->odp.caps;
 #endif
 
 	if (MLX5_CAP_GEN(mdev, cd))
@@ -4095,8 +4095,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 
 	dev->ib_dev.disassociate_ucontext = mlx5_ib_disassociate_ucontext;
 
-	mlx5_ib_internal_fill_odp_caps(dev);
-
 	dev->umr_fence = mlx5_get_umr_fence(MLX5_CAP_GEN(mdev, umr_fence));
 
 	if (MLX5_CAP_GEN(mdev, imaicl)) {
@@ -4197,6 +4195,8 @@ static void mlx5_ib_stage_dev_res_cleanup(struct mlx5_ib_dev *dev)
 
 static int mlx5_ib_stage_odp_init(struct mlx5_ib_dev *dev)
 {
+	mlx5_ib_internal_fill_odp_caps(dev);
+
 	return mlx5_ib_odp_init_one(dev);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8f97213e5b4c..e0d9c03f4432 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -735,6 +735,18 @@ struct mlx5_ib_profile {
 	struct mlx5_ib_stage stage[MLX5_IB_STAGE_MAX];
 };
 
+struct mlx5_ib_odp {
+	struct ib_odp_caps	caps;
+	u64			max_size;
+	/*
+	 * Sleepable RCU that prevents destruction of MRs while they are still
+	 * being used by a page fault handler.
+	 */
+	struct srcu_struct      mr_srcu;
+	u32			null_mkey;
+	void			(*sync)(struct mlx5_ib_dev *dev);
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -754,14 +766,7 @@ struct mlx5_ib_dev {
 	struct mutex			slow_path_mutex;
 	int				fill_delay;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	struct ib_odp_caps	odp_caps;
-	u64			odp_max_size;
-	/*
-	 * Sleepable RCU that prevents destruction of MRs while they are still
-	 * being used by a page fault handler.
-	 */
-	struct srcu_struct      mr_srcu;
-	u32			null_mkey;
+	struct mlx5_ib_odp		odp;
 #endif
 	struct mlx5_ib_flow_db	flow_db;
 	/* protect resources needed as part of reset flow */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ad37d8441fa2..059771bfb415 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -58,7 +58,8 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	/* Wait until all page fault handlers using the mr complete. */
-	synchronize_srcu(&dev->mr_srcu);
+	if (dev->odp.sync)
+		dev->odp.sync(dev);
 #endif
 
 	return err;
@@ -1215,7 +1216,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (!start && length == U64_MAX) {
 		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
-		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
+		    !(dev->odp.caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 			return ERR_PTR(-EINVAL);
 
 		mr = mlx5_ib_alloc_implicit_mr(to_mpd(pd), access_flags);
@@ -1521,7 +1522,7 @@ static int dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		/* Prevent new page faults from succeeding */
 		mr->live = 0;
 		/* Wait for all running page-fault handlers to finish. */
-		synchronize_srcu(&dev->mr_srcu);
+		dev->odp.sync(dev);
 		/* Destroy all page mappings */
 		if (umem->odp_data->page_list)
 			mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index e2197bdda89c..117f87d06919 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -125,7 +125,7 @@ void mlx5_odp_populate_klm(struct mlx5_klm *pklm, size_t offset,
 	if (flags & MLX5_IB_UPD_XLT_ZAP) {
 		for (i = 0; i < nentries; i++, pklm++) {
 			pklm->bcount = cpu_to_be32(MLX5_IMR_MTT_SIZE);
-			pklm->key = cpu_to_be32(dev->null_mkey);
+			pklm->key = cpu_to_be32(dev->odp.null_mkey);
 			pklm->va = 0;
 		}
 		return;
@@ -143,7 +143,7 @@ void mlx5_odp_populate_klm(struct mlx5_klm *pklm, size_t offset,
 			pklm->key = cpu_to_be32(mtt->ibmr.lkey);
 			odp = odp_next(odp);
 		} else {
-			pklm->key = cpu_to_be32(dev->null_mkey);
+			pklm->key = cpu_to_be32(dev->odp.null_mkey);
 		}
 		mlx5_ib_dbg(dev, "[%d] va %lx key %x\n",
 			    i, va, be32_to_cpu(pklm->key));
@@ -157,7 +157,7 @@ static void mr_leaf_free_action(struct work_struct *work)
 	struct mlx5_ib_mr *mr = odp->private, *imr = mr->parent;
 
 	mr->parent = NULL;
-	synchronize_srcu(&mr->dev->mr_srcu);
+	mr->dev->odp.sync(mr->dev);
 
 	ib_umem_release(odp->umem);
 	if (imr->live)
@@ -249,7 +249,7 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 
 void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 {
-	struct ib_odp_caps *caps = &dev->odp_caps;
+	struct ib_odp_caps *caps = &dev->odp.caps;
 
 	memset(caps, 0, sizeof(*caps));
 
@@ -259,9 +259,9 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	caps->general_caps = IB_ODP_SUPPORT;
 
 	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
-		dev->odp_max_size = U64_MAX;
+		dev->odp.max_size = U64_MAX;
 	else
-		dev->odp_max_size = BIT_ULL(MLX5_MAX_UMR_SHIFT + PAGE_SHIFT);
+		dev->odp.max_size = BIT_ULL(MLX5_MAX_UMR_SHIFT + PAGE_SHIFT);
 
 	if (MLX5_CAP_ODP(dev->mdev, ud_odp_caps.send))
 		caps->per_transport_caps.ud_odp_caps |= IB_ODP_SUPPORT_SEND;
@@ -641,7 +641,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	u32 *out = NULL;
 	size_t offset;
 
-	srcu_key = srcu_read_lock(&dev->mr_srcu);
+	srcu_key = srcu_read_lock(&dev->odp.mr_srcu);
 
 	io_virt += *bytes_committed;
 	bcnt -= *bytes_committed;
@@ -754,7 +754,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	}
 	kfree(out);
 
-	srcu_read_unlock(&dev->mr_srcu, srcu_key);
+	srcu_read_unlock(&dev->odp.mr_srcu, srcu_key);
 	*bytes_committed = 0;
 	return ret ? ret : npages;
 }
@@ -919,10 +919,10 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_RC:
-		transport_caps = dev->odp_caps.per_transport_caps.rc_odp_caps;
+		transport_caps = dev->odp.caps.per_transport_caps.rc_odp_caps;
 		break;
 	case IB_QPT_UD:
-		transport_caps = dev->odp_caps.per_transport_caps.ud_odp_caps;
+		transport_caps = dev->odp.caps.per_transport_caps.ud_odp_caps;
 		break;
 	default:
 		mlx5_ib_err(dev, "ODP fault on QP of an unsupported transport 0x%x\n",
@@ -989,7 +989,7 @@ static int mlx5_ib_mr_responder_pfault_handler(
 
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_RC:
-		if (!(dev->odp_caps.per_transport_caps.rc_odp_caps &
+		if (!(dev->odp.caps.per_transport_caps.rc_odp_caps &
 		      IB_ODP_SUPPORT_RECV))
 			goto invalid_transport_or_opcode;
 		break;
@@ -1179,7 +1179,7 @@ void mlx5_ib_pfault(struct mlx5_core_dev *mdev, void *context,
 
 void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
 {
-	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
+	if (!(ent->dev->odp.caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 		return;
 
 	switch (ent->order - 2) {
@@ -1203,28 +1203,34 @@ void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
 	}
 }
 
+static void mlx5_ib_odp_sync(struct mlx5_ib_dev *dev)
+{
+	synchronize_srcu(&dev->odp.mr_srcu);
+}
+
 int mlx5_ib_odp_init_one(struct mlx5_ib_dev *dev)
 {
 	int ret;
 
-	ret = init_srcu_struct(&dev->mr_srcu);
+	ret = init_srcu_struct(&dev->odp.mr_srcu);
 	if (ret)
 		return ret;
 
-	if (dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT) {
-		ret = mlx5_cmd_null_mkey(dev->mdev, &dev->null_mkey);
+	if (dev->odp.caps.general_caps & IB_ODP_SUPPORT_IMPLICIT) {
+		ret = mlx5_cmd_null_mkey(dev->mdev, &dev->odp.null_mkey);
 		if (ret) {
 			mlx5_ib_err(dev, "Error getting null_mkey %d\n", ret);
 			return ret;
 		}
 	}
+	dev->odp.sync = mlx5_ib_odp_sync;
 
 	return 0;
 }
 
 void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *dev)
 {
-	cleanup_srcu_struct(&dev->mr_srcu);
+	cleanup_srcu_struct(&dev->odp.mr_srcu);
 }
 
 int mlx5_ib_odp_init(void)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
