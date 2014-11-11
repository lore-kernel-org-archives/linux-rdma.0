From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 17/17] IB/mlx5: Implement on demand paging by adding support for MMU notifiers
Date: Tue, 11 Nov 2014 18:36:23 +0200
Message-ID: <1415723783-2138-18-git-send-email-haggaie@mellanox.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

* Implement the relevant invalidation functions (zap MTTs as needed)
* Implement interlocking (and rollback in the page fault handlers) for cases of a racing notifier and fault.
* With this patch we can now enable the capability bits for supporting RC
  send/receive/RDMA read/RDMA write, and UD send.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |   4 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   3 +
 drivers/infiniband/hw/mlx5/mr.c      |  79 +++++++++++++++++++--
 drivers/infiniband/hw/mlx5/odp.c     | 128 ++++++++++++++++++++++++++++++++---
 4 files changed, 198 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a801baa79c8e..8a87404e9c76 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -574,6 +574,10 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 			goto out_count;
 	}
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
+#endif
+
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c6ceec3e3d6a..83f22fe297c8 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -325,6 +325,7 @@ struct mlx5_ib_mr {
 	struct mlx5_ib_dev     *dev;
 	struct mlx5_create_mkey_mbox_out out;
 	struct mlx5_core_sig_ctx    *sig;
+	int			live;
 };
 
 struct mlx5_ib_fast_reg_page_list {
@@ -629,6 +630,8 @@ int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
 void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib_qp *qp);
 void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp);
+void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
+			      unsigned long end);
 
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 static inline int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 9c9e16cca043..a2dd7bfc129b 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -37,6 +37,7 @@
 #include <linux/export.h>
 #include <linux/delay.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_umem_odp.h>
 #include <rdma/ib_verbs.h>
 #include "mlx5_ib.h"
 
@@ -54,6 +55,18 @@ static DEFINE_MUTEX(mlx5_ib_update_mtt_emergency_buffer_mutex);
 
 static int clean_mr(struct mlx5_ib_mr *mr);
 
+static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
+{
+	int err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmr);
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	/* Wait until all page fault handlers using the mr complete. */
+	synchronize_srcu(&dev->mr_srcu);
+#endif
+
+	return err;
+}
+
 static int order2idx(struct mlx5_ib_dev *dev, int order)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
@@ -188,7 +201,7 @@ static void remove_keys(struct mlx5_ib_dev *dev, int c, int num)
 		ent->cur--;
 		ent->size--;
 		spin_unlock_irq(&ent->lock);
-		err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmr);
+		err = destroy_mkey(dev, mr);
 		if (err)
 			mlx5_ib_warn(dev, "failed destroy mkey\n");
 		else
@@ -479,7 +492,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 		ent->cur--;
 		ent->size--;
 		spin_unlock_irq(&ent->lock);
-		err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmr);
+		err = destroy_mkey(dev, mr);
 		if (err)
 			mlx5_ib_warn(dev, "failed destroy mkey\n");
 		else
@@ -809,6 +822,8 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	mr->mmr.size = len;
 	mr->mmr.pd = to_mpd(pd)->pdn;
 
+	mr->live = 1;
+
 unmap_dma:
 	up(&umrc->sem);
 	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
@@ -994,6 +1009,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, u64 virt_addr,
 		goto err_2;
 	}
 	mr->umem = umem;
+	mr->live = 1;
 	mlx5_vfree(in);
 
 	mlx5_ib_dbg(dev, "mkey = 0x%x\n", mr->mmr.key);
@@ -1071,10 +1087,47 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.rkey = mr->mmr.key;
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	if (umem->odp_data) {
+		/*
+		 * This barrier prevents the compiler from moving the
+		 * setting of umem->odp_data->private to point to our
+		 * MR, before reg_umr finished, to ensure that the MR
+		 * initialization have finished before starting to
+		 * handle invalidations.
+		 */
+		smp_wmb();
+		mr->umem->odp_data->private = mr;
+		/*
+		 * Make sure we will see the new
+		 * umem->odp_data->private value in the invalidation
+		 * routines, before we can get page faults on the
+		 * MR. Page faults can happen once we put the MR in
+		 * the tree, below this line. Without the barrier,
+		 * there can be a fault handling and an invalidation
+		 * before umem->odp_data->private == mr is visible to
+		 * the invalidation handler.
+		 */
+		smp_wmb();
+	}
+#endif
+
 	return &mr->ibmr;
 
 error:
+	/*
+	 * Destroy the umem *before* destroying the MR, to ensure we
+	 * will not have any in-flight notifiers when destroying the
+	 * MR.
+	 *
+	 * As the MR is completely invalid to begin with, and this
+	 * error path is only taken if we can't push the mr entry into
+	 * the pagefault tree, this is safe.
+	 */
+
 	ib_umem_release(umem);
+	/* Kill the MR, and return an error code. */
+	clean_mr(mr);
 	return ERR_PTR(err);
 }
 
@@ -1118,7 +1171,7 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 	int err;
 
 	if (!umred) {
-		err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmr);
+		err = destroy_mkey(dev, mr);
 		if (err) {
 			mlx5_ib_warn(dev, "failed to destroy mkey 0x%x (%d)\n",
 				     mr->mmr.key, err);
@@ -1147,9 +1200,25 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 	struct ib_umem *umem = mr->umem;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (umem)
+	if (umem && umem->odp_data) {
+		/* Prevent new page faults from succeeding */
+		mr->live = 0;
 		/* Wait for all running page-fault handlers to finish. */
 		synchronize_srcu(&dev->mr_srcu);
+		/* Destroy all page mappings */
+		mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
+					 ib_umem_end(umem));
+		/*
+		 * We kill the umem before the MR for ODP,
+		 * so that there will not be any invalidations in
+		 * flight, looking at the *mr struct.
+		 */
+		ib_umem_release(umem);
+		atomic_sub(npages, &dev->mdev->priv.reg_pages);
+
+		/* Avoid double-freeing the umem. */
+		umem = NULL;
+	}
 #endif
 
 	clean_mr(mr);
@@ -1266,7 +1335,7 @@ int mlx5_ib_destroy_mr(struct ib_mr *ibmr)
 		kfree(mr->sig);
 	}
 
-	err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmr);
+	err = destroy_mkey(dev, mr);
 	if (err) {
 		mlx5_ib_warn(dev, "failed to destroy mkey 0x%x (%d)\n",
 			     mr->mmr.key, err);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 936a6cd4ecc7..a2c541c4809a 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -37,8 +37,78 @@
 
 #define MAX_PREFETCH_LEN (4*1024*1024U)
 
+/* Timeout in ms to wait for an active mmu notifier to complete when handling
+ * a pagefault. */
+#define MMU_NOTIFIER_TIMEOUT 1000
+
 struct workqueue_struct *mlx5_ib_page_fault_wq;
 
+void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
+			      unsigned long end)
+{
+	struct mlx5_ib_mr *mr;
+	const u64 umr_block_mask = (MLX5_UMR_MTT_ALIGNMENT / sizeof(u64)) - 1;
+	u64 idx = 0, blk_start_idx = 0;
+	int in_block = 0;
+	u64 addr;
+
+	if (!umem || !umem->odp_data) {
+		pr_err("invalidation called on NULL umem or non-ODP umem\n");
+		return;
+	}
+
+	mr = umem->odp_data->private;
+
+	if (!mr || !mr->ibmr.pd)
+		return;
+
+	start = max_t(u64, ib_umem_start(umem), start);
+	end = min_t(u64, ib_umem_end(umem), end);
+
+	/*
+	 * Iteration one - zap the HW's MTTs. The notifiers_count ensures that
+	 * while we are doing the invalidation, no page fault will attempt to
+	 * overwrite the same MTTs.  Concurent invalidations might race us,
+	 * but they will write 0s as well, so no difference in the end result.
+	 */
+
+	for (addr = start; addr < end; addr += (u64)umem->page_size) {
+		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
+		/*
+		 * Strive to write the MTTs in chunks, but avoid overwriting
+		 * non-existing MTTs. The huristic here can be improved to
+		 * estimate the cost of another UMR vs. the cost of bigger
+		 * UMR.
+		 */
+		if (umem->odp_data->dma_list[idx] &
+		    (ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT)) {
+			if (!in_block) {
+				blk_start_idx = idx;
+				in_block = 1;
+			}
+		} else {
+			u64 umr_offset = idx & umr_block_mask;
+
+			if (in_block && umr_offset == 0) {
+				mlx5_ib_update_mtt(mr, blk_start_idx,
+						   idx - blk_start_idx, 1);
+				in_block = 0;
+			}
+		}
+	}
+	if (in_block)
+		mlx5_ib_update_mtt(mr, blk_start_idx, idx - blk_start_idx + 1,
+				   1);
+
+	/*
+	 * We are now sure that the device will not access the
+	 * memory. We can safely unmap it, and mark it as dirty if
+	 * needed.
+	 */
+
+	ib_umem_odp_unmap_dma_pages(umem, start, end);
+}
+
 #define COPY_ODP_BIT_MLX_TO_IB(reg, ib_caps, field_name, bit_name) do {	\
 	if (be32_to_cpu(reg.field_name) & MLX5_ODP_SUPPORT_##bit_name)	\
 		ib_caps->field_name |= IB_ODP_SUPPORT_##bit_name;	\
@@ -59,9 +129,18 @@ int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev)
 	if (err)
 		goto out;
 
-	/* At this point we would copy the capability bits that the driver
-	 * supports from the hw_caps struct to the caps struct. However, no
-	 * such capabilities are supported so far. */
+	caps->general_caps = IB_ODP_SUPPORT;
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.ud_odp_caps,
+			       SEND);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       SEND);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       RECV);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       WRITE);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       READ);
+
 out:
 	return err;
 }
@@ -71,8 +150,9 @@ static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(struct mlx5_ib_dev *dev,
 {
 	u32 base_key = mlx5_base_mkey(key);
 	struct mlx5_core_mr *mmr = __mlx5_mr_lookup(dev->mdev, base_key);
+	struct mlx5_ib_mr *mr = container_of(mmr, struct mlx5_ib_mr, mmr);
 
-	if (!mmr || mmr->key != key)
+	if (!mmr || mmr->key != key || !mr->live)
 		return NULL;
 
 	return container_of(mmr, struct mlx5_ib_mr, mmr);
@@ -143,6 +223,11 @@ static int pagefault_single_data_segment(struct mlx5_ib_qp *qp,
 	}
 
 	current_seq = ACCESS_ONCE(mr->umem->odp_data->notifiers_seq);
+	/*
+	 * Ensure the sequence number is valid for some time before we call
+	 * gup.
+	 */
+	smp_rmb();
 
 	/*
 	 * Avoid branches - this code will perform correctly
@@ -165,15 +250,20 @@ static int pagefault_single_data_segment(struct mlx5_ib_qp *qp,
 
 	if (npages > 0) {
 		mutex_lock(&mr->umem->odp_data->umem_mutex);
-		/*
-		 * No need to check whether the MTTs really belong to
-		 * this MR, since ib_umem_odp_map_dma_pages already
-		 * checks this.
-		 */
-		ret = mlx5_ib_update_mtt(mr, start_idx, npages, 0);
+		if (!ib_umem_mmu_notifier_retry(mr->umem, current_seq)) {
+			/*
+			 * No need to check whether the MTTs really belong to
+			 * this MR, since ib_umem_odp_map_dma_pages already
+			 * checks this.
+			 */
+			ret = mlx5_ib_update_mtt(mr, start_idx, npages, 0);
+		} else {
+			ret = -EAGAIN;
+		}
 		mutex_unlock(&mr->umem->odp_data->umem_mutex);
 		if (ret < 0) {
-			pr_err("Failed to update mkey page tables\n");
+			if (ret != -EAGAIN)
+				pr_err("Failed to update mkey page tables\n");
 			goto srcu_unlock;
 		}
 
@@ -185,6 +275,22 @@ static int pagefault_single_data_segment(struct mlx5_ib_qp *qp,
 	}
 
 srcu_unlock:
+	if (ret == -EAGAIN) {
+		if (!mr->umem->odp_data->dying) {
+			struct ib_umem_odp *odp_data = mr->umem->odp_data;
+			unsigned long timeout =
+				msecs_to_jiffies(MMU_NOTIFIER_TIMEOUT);
+
+			if (!wait_for_completion_timeout(
+					&odp_data->notifier_completion,
+					timeout)) {
+				pr_warn("timeout waiting for mmu notifier completion\n");
+			}
+		} else {
+			/* The MR is being killed, kill the QP as well. */
+			ret = -EFAULT;
+		}
+	}
 	srcu_read_unlock(&mib_dev->mr_srcu, srcu_key);
 	pfault->mpfault.bytes_committed = 0;
 	return ret ? ret : npages;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
