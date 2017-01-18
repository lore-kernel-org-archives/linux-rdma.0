From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/6] IB/mlx5: Add implicit MR support
Date: Wed, 18 Jan 2017 16:58:11 +0200
Message-ID: <20170118145811.9136-7-leon@kernel.org>
References: <20170118145811.9136-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118145811.9136-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add implicit MR, covering entire user address space.
The MR is implemented as an indirect KSM MR consisting of
1GB direct MRs.
Pages and direct MRs are added/removed to MR by ODP.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |   2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  20 +-
 drivers/infiniband/hw/mlx5/mr.c      |  33 ++-
 drivers/infiniband/hw/mlx5/odp.c     | 505 ++++++++++++++++++++++++++++++++---
 include/linux/mlx5/driver.h          |   2 +
 5 files changed, 513 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a191b93..475a458 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3424,6 +3424,8 @@ static int __init mlx5_ib_init(void)
 	if (deprecated_prof_sel != 2)
 		pr_warn("prof_sel is deprecated for mlx5_ib, set it for mlx5_core\n");
 
+	mlx5_ib_odp_init();
+
 	err = mlx5_register_interface(&mlx5_ib_interface);
 
 	return err;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0eda2de..560dae0c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -202,6 +202,7 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_UPD_XLT_ADDR	      BIT(3)
 #define MLX5_IB_UPD_XLT_PD	      BIT(4)
 #define MLX5_IB_UPD_XLT_ACCESS	      BIT(5)
+#define MLX5_IB_UPD_XLT_INDIRECT      BIT(6)
 
 /* Private QP creation flags to be passed in ib_qp_init_attr.create_flags.
  *
@@ -497,6 +498,10 @@ struct mlx5_ib_mr {
 	int			live;
 	void			*descs_alloc;
 	int			access_flags; /* Needed for rereg MR */
+
+	struct mlx5_ib_mr      *parent;
+	atomic_t		num_leaf_free;
+	wait_queue_head_t       q_leaf_free;
 };
 
 struct mlx5_ib_mw {
@@ -624,6 +629,7 @@ struct mlx5_ib_dev {
 	 * being used by a page fault handler.
 	 */
 	struct srcu_struct      mr_srcu;
+	u32			null_mkey;
 #endif
 	struct mlx5_ib_flow_db	flow_db;
 	/* protect resources needed as part of reset flow */
@@ -776,6 +782,9 @@ struct ib_mw *mlx5_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 int mlx5_ib_dealloc_mw(struct ib_mw *mw);
 int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 		       int page_shift, int flags);
+struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
+					     int access_flags);
+void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *mr);
 int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			  u64 length, u64 virt_addr, int access_flags,
 			  struct ib_pd *pd, struct ib_udata *udata);
@@ -855,6 +864,9 @@ int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
 void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 			      unsigned long end);
+void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent);
+void mlx5_odp_populate_klm(struct mlx5_klm *pklm, size_t offset,
+			   size_t nentries, struct mlx5_ib_mr *mr, int flags);
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 static inline void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 {
@@ -862,9 +874,13 @@ static inline void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 }
 
 static inline int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev) { return 0; }
-static inline void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev)	{}
+static inline void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev)	    {}
 static inline int mlx5_ib_odp_init(void) { return 0; }
-static inline void mlx5_ib_odp_cleanup(void)				{}
+static inline void mlx5_ib_odp_cleanup(void)				    {}
+static inline void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent) {}
+static inline void mlx5_odp_populate_klm(struct mlx5_klm *pklm, size_t offset,
+					 size_t nentries, struct mlx5_ib_mr *mr,
+					 int flags) {}
 
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8f5b94d..3c1f483 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -469,7 +469,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev, int entry)
 			spin_unlock_irq(&ent->lock);
 
 			err = add_keys(dev, entry, 1);
-			if (err)
+			if (err && err != -EAGAIN)
 				return ERR_PTR(err);
 
 			wait_for_completion(&ent->compl);
@@ -669,8 +669,10 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
 		queue_work(cache->wq, &ent->work);
 
-		if (i > MAX_UMR_CACHE_ENTRY)
+		if (i > MAX_UMR_CACHE_ENTRY) {
+			mlx5_odp_init_mr_cache_entry(ent);
 			continue;
+		}
 
 		if (!use_umr(dev, ent->order))
 			continue;
@@ -935,6 +937,10 @@ static inline int populate_xlt(struct mlx5_ib_mr *mr, int idx, int npages,
 {
 	struct mlx5_ib_dev *dev = mr->dev;
 	struct ib_umem *umem = mr->umem;
+	if (flags & MLX5_IB_UPD_XLT_INDIRECT) {
+		mlx5_odp_populate_klm(xlt, idx, npages, mr, flags);
+		return npages;
+	}
 
 	npages = min_t(size_t, npages, ib_umem_num_pages(umem) - idx);
 
@@ -968,7 +974,9 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	struct mlx5_umr_wr wr;
 	struct ib_sge sg;
 	int err = 0;
-	int desc_size = sizeof(struct mlx5_mtt);
+	int desc_size = (flags & MLX5_IB_UPD_XLT_INDIRECT)
+			       ? sizeof(struct mlx5_klm)
+			       : sizeof(struct mlx5_mtt);
 	const int page_align = MLX5_UMR_MTT_ALIGNMENT / desc_size;
 	const int page_mask = page_align - 1;
 	size_t pages_mapped = 0;
@@ -1186,6 +1194,18 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, virt_addr, length, access_flags);
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	if (!start && length == U64_MAX) {
+		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
+		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
+			return ERR_PTR(-EINVAL);
+
+		mr = mlx5_ib_alloc_implicit_mr(to_mpd(pd), access_flags);
+		return &mr->ibmr;
+	}
+#endif
+
 	err = mr_umem_get(pd, start, length, access_flags, &umem, &npages,
 			   &page_shift, &ncont, &order);
 
@@ -1471,8 +1491,11 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		/* Wait for all running page-fault handlers to finish. */
 		synchronize_srcu(&dev->mr_srcu);
 		/* Destroy all page mappings */
-		mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
-					 ib_umem_end(umem));
+		if (umem->odp_data->page_list)
+			mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
+						 ib_umem_end(umem));
+		else
+			mlx5_ib_free_implicit_mr(mr);
 		/*
 		 * We kill the umem before the MR for ODP,
 		 * so that there will not be any invalidations in
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index e5bc267..d7b12f0 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -34,6 +34,7 @@
 #include <rdma/ib_umem_odp.h>
 
 #include "mlx5_ib.h"
+#include "cmd.h"
 
 #define MAX_PREFETCH_LEN (4*1024*1024U)
 
@@ -41,6 +42,140 @@
  * a pagefault. */
 #define MMU_NOTIFIER_TIMEOUT 1000
 
+#define MLX5_IMR_MTT_BITS (30 - PAGE_SHIFT)
+#define MLX5_IMR_MTT_SHIFT (MLX5_IMR_MTT_BITS + PAGE_SHIFT)
+#define MLX5_IMR_MTT_ENTRIES BIT_ULL(MLX5_IMR_MTT_BITS)
+#define MLX5_IMR_MTT_SIZE BIT_ULL(MLX5_IMR_MTT_SHIFT)
+#define MLX5_IMR_MTT_MASK (~(MLX5_IMR_MTT_SIZE - 1))
+
+#define MLX5_KSM_PAGE_SHIFT MLX5_IMR_MTT_SHIFT
+
+static u64 mlx5_imr_ksm_entries;
+
+static int check_parent(struct ib_umem_odp *odp,
+			       struct mlx5_ib_mr *parent)
+{
+	struct mlx5_ib_mr *mr = odp->private;
+
+	return mr && mr->parent == parent;
+}
+
+static struct ib_umem_odp *odp_next(struct ib_umem_odp *odp)
+{
+	struct mlx5_ib_mr *mr = odp->private, *parent = mr->parent;
+	struct ib_ucontext *ctx = odp->umem->context;
+	struct rb_node *rb;
+
+	down_read(&ctx->umem_rwsem);
+	while (1) {
+		rb = rb_next(&odp->interval_tree.rb);
+		if (!rb)
+			goto not_found;
+		odp = rb_entry(rb, struct ib_umem_odp, interval_tree.rb);
+		if (check_parent(odp, parent))
+			goto end;
+	}
+not_found:
+	odp = NULL;
+end:
+	up_read(&ctx->umem_rwsem);
+	return odp;
+}
+
+static struct ib_umem_odp *odp_lookup(struct ib_ucontext *ctx,
+				      u64 start, u64 length,
+				      struct mlx5_ib_mr *parent)
+{
+	struct ib_umem_odp *odp;
+	struct rb_node *rb;
+
+	down_read(&ctx->umem_rwsem);
+	odp = rbt_ib_umem_lookup(&ctx->umem_tree, start, length);
+	if (!odp)
+		goto end;
+
+	while (1) {
+		if (check_parent(odp, parent))
+			goto end;
+		rb = rb_next(&odp->interval_tree.rb);
+		if (!rb)
+			goto not_found;
+		odp = rb_entry(rb, struct ib_umem_odp, interval_tree.rb);
+		if (ib_umem_start(odp->umem) > start + length)
+			goto not_found;
+	}
+not_found:
+	odp = NULL;
+end:
+	up_read(&ctx->umem_rwsem);
+	return odp;
+}
+
+void mlx5_odp_populate_klm(struct mlx5_klm *pklm, size_t offset,
+			   size_t nentries, struct mlx5_ib_mr *mr, int flags)
+{
+	struct ib_pd *pd = mr->ibmr.pd;
+	struct ib_ucontext *ctx = pd->uobject->context;
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct ib_umem_odp *odp;
+	unsigned long va;
+	int i;
+
+	if (flags & MLX5_IB_UPD_XLT_ZAP) {
+		for (i = 0; i < nentries; i++, pklm++) {
+			pklm->bcount = cpu_to_be32(MLX5_IMR_MTT_SIZE);
+			pklm->key = cpu_to_be32(dev->null_mkey);
+			pklm->va = 0;
+		}
+		return;
+	}
+
+	odp = odp_lookup(ctx, offset * MLX5_IMR_MTT_SIZE,
+			     nentries * MLX5_IMR_MTT_SIZE, mr);
+
+	for (i = 0; i < nentries; i++, pklm++) {
+		pklm->bcount = cpu_to_be32(MLX5_IMR_MTT_SIZE);
+		va = (offset + i) * MLX5_IMR_MTT_SIZE;
+		if (odp && odp->umem->address == va) {
+			struct mlx5_ib_mr *mtt = odp->private;
+
+			pklm->key = cpu_to_be32(mtt->ibmr.lkey);
+			odp = odp_next(odp);
+		} else {
+			pklm->key = cpu_to_be32(dev->null_mkey);
+		}
+		mlx5_ib_dbg(dev, "[%d] va %lx key %x\n",
+			    i, va, be32_to_cpu(pklm->key));
+	}
+}
+
+static void mr_leaf_free_action(struct work_struct *work)
+{
+	struct ib_umem_odp *odp = container_of(work, struct ib_umem_odp, work);
+	int idx = ib_umem_start(odp->umem) >> MLX5_IMR_MTT_SHIFT;
+	struct mlx5_ib_mr *mr = odp->private, *imr = mr->parent;
+
+	mr->parent = NULL;
+	synchronize_srcu(&mr->dev->mr_srcu);
+
+	if (!READ_ONCE(odp->dying)) {
+		mr->parent = imr;
+		if (atomic_dec_and_test(&imr->num_leaf_free))
+			wake_up(&imr->q_leaf_free);
+		return;
+	}
+
+	ib_umem_release(odp->umem);
+	if (imr->live)
+		mlx5_ib_update_xlt(imr, idx, 1, 0,
+				   MLX5_IB_UPD_XLT_INDIRECT |
+				   MLX5_IB_UPD_XLT_ATOMIC);
+	mlx5_mr_cache_free(mr->dev, mr);
+
+	if (atomic_dec_and_test(&imr->num_leaf_free))
+		wake_up(&imr->q_leaf_free);
+}
+
 void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 			      unsigned long end)
 {
@@ -111,6 +246,13 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 	 */
 
 	ib_umem_odp_unmap_dma_pages(umem, start, end);
+
+	if (unlikely(!umem->npages && mr->parent &&
+		     !umem->odp_data->dying)) {
+		WRITE_ONCE(umem->odp_data->dying, 1);
+		atomic_inc(&mr->parent->num_leaf_free);
+		schedule_work(&umem->odp_data->work);
+	}
 }
 
 void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
@@ -147,6 +289,11 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	if (MLX5_CAP_ODP(dev->mdev, rc_odp_caps.atomic))
 		caps->per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_ATOMIC;
 
+	if (MLX5_CAP_GEN(dev->mdev, fixed_buffer_size) &&
+	    MLX5_CAP_GEN(dev->mdev, null_mkey) &&
+	    MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
+		caps->general_caps |= IB_ODP_SUPPORT_IMPLICIT;
+
 	return;
 }
 
@@ -184,6 +331,197 @@ static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
 			    wq_num);
 }
 
+static struct mlx5_ib_mr *implicit_mr_alloc(struct ib_pd *pd,
+					    struct ib_umem *umem,
+					    bool ksm, int access_flags)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_mr *mr;
+	int err;
+
+	mr = mlx5_mr_cache_alloc(dev, ksm ? MLX5_IMR_KSM_CACHE_ENTRY :
+					    MLX5_IMR_MTT_CACHE_ENTRY);
+
+	if (IS_ERR(mr))
+		return mr;
+
+	mr->ibmr.pd = pd;
+
+	mr->dev = dev;
+	mr->access_flags = access_flags;
+	mr->mmkey.iova = 0;
+	mr->umem = umem;
+
+	if (ksm) {
+		err = mlx5_ib_update_xlt(mr, 0,
+					 mlx5_imr_ksm_entries,
+					 MLX5_KSM_PAGE_SHIFT,
+					 MLX5_IB_UPD_XLT_INDIRECT |
+					 MLX5_IB_UPD_XLT_ZAP |
+					 MLX5_IB_UPD_XLT_ENABLE);
+
+	} else {
+		err = mlx5_ib_update_xlt(mr, 0,
+					 MLX5_IMR_MTT_ENTRIES,
+					 PAGE_SHIFT,
+					 MLX5_IB_UPD_XLT_ZAP |
+					 MLX5_IB_UPD_XLT_ENABLE |
+					 MLX5_IB_UPD_XLT_ATOMIC);
+	}
+
+	if (err)
+		goto fail;
+
+	mr->ibmr.lkey = mr->mmkey.key;
+	mr->ibmr.rkey = mr->mmkey.key;
+
+	mr->live = 1;
+
+	mlx5_ib_dbg(dev, "key %x dev %p mr %p\n",
+		    mr->mmkey.key, dev->mdev, mr);
+
+	return mr;
+
+fail:
+	mlx5_ib_err(dev, "Failed to register MKEY %d\n", err);
+	mlx5_mr_cache_free(dev, mr);
+
+	return ERR_PTR(err);
+}
+
+static struct ib_umem_odp *implicit_mr_get_data(struct mlx5_ib_mr *mr,
+						u64 io_virt, size_t bcnt)
+{
+	struct ib_ucontext *ctx = mr->ibmr.pd->uobject->context;
+	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.pd->device);
+	struct ib_umem_odp *odp, *result = NULL;
+	u64 addr = io_virt & MLX5_IMR_MTT_MASK;
+	int nentries = 0, start_idx = 0, ret;
+	struct mlx5_ib_mr *mtt;
+	struct ib_umem *umem;
+
+	mutex_lock(&mr->umem->odp_data->umem_mutex);
+	odp = odp_lookup(ctx, addr, 1, mr);
+
+	mlx5_ib_dbg(dev, "io_virt:%llx bcnt:%zx addr:%llx odp:%p\n",
+		    io_virt, bcnt, addr, odp);
+
+next_mr:
+	if (likely(odp)) {
+		if (nentries)
+			nentries++;
+	} else {
+		umem = ib_alloc_odp_umem(ctx, addr, MLX5_IMR_MTT_SIZE);
+		if (IS_ERR(umem)) {
+			mutex_unlock(&mr->umem->odp_data->umem_mutex);
+			return ERR_CAST(umem);
+		}
+
+		mtt = implicit_mr_alloc(mr->ibmr.pd, umem, 0, mr->access_flags);
+		if (IS_ERR(mtt)) {
+			mutex_unlock(&mr->umem->odp_data->umem_mutex);
+			ib_umem_release(umem);
+			return ERR_CAST(mtt);
+		}
+
+		odp = umem->odp_data;
+		odp->private = mtt;
+		mtt->umem = umem;
+		mtt->mmkey.iova = addr;
+		mtt->parent = mr;
+		INIT_WORK(&odp->work, mr_leaf_free_action);
+
+		if (!nentries)
+			start_idx = addr >> MLX5_IMR_MTT_SHIFT;
+		nentries++;
+	}
+
+	odp->dying = 0;
+
+	/* Return first odp if region not covered by single one */
+	if (likely(!result))
+		result = odp;
+
+	addr += MLX5_IMR_MTT_SIZE;
+	if (unlikely(addr < io_virt + bcnt)) {
+		odp = odp_next(odp);
+		if (odp && odp->umem->address != addr)
+			odp = NULL;
+		goto next_mr;
+	}
+
+	if (unlikely(nentries)) {
+		ret = mlx5_ib_update_xlt(mr, start_idx, nentries, 0,
+					 MLX5_IB_UPD_XLT_INDIRECT |
+					 MLX5_IB_UPD_XLT_ATOMIC);
+		if (ret) {
+			mlx5_ib_err(dev, "Failed to update PAS\n");
+			result = ERR_PTR(ret);
+		}
+	}
+
+	mutex_unlock(&mr->umem->odp_data->umem_mutex);
+	return result;
+}
+
+struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
+					     int access_flags)
+{
+	struct ib_ucontext *ctx = pd->ibpd.uobject->context;
+	struct mlx5_ib_mr *imr;
+	struct ib_umem *umem;
+
+	umem = ib_umem_get(ctx, 0, 0, IB_ACCESS_ON_DEMAND, 0);
+	if (IS_ERR(umem))
+		return ERR_CAST(umem);
+
+	imr = implicit_mr_alloc(&pd->ibpd, umem, 1, access_flags);
+	if (IS_ERR(imr)) {
+		ib_umem_release(umem);
+		return ERR_CAST(imr);
+	}
+
+	imr->umem = umem;
+	init_waitqueue_head(&imr->q_leaf_free);
+	atomic_set(&imr->num_leaf_free, 0);
+
+	return imr;
+}
+
+static int mr_leaf_free(struct ib_umem *umem, u64 start,
+			u64 end, void *cookie)
+{
+	struct mlx5_ib_mr *mr = umem->odp_data->private, *imr = cookie;
+
+	if (mr->parent != imr)
+		return 0;
+
+	ib_umem_odp_unmap_dma_pages(umem,
+				    ib_umem_start(umem),
+				    ib_umem_end(umem));
+
+	if (umem->odp_data->dying)
+		return 0;
+
+	WRITE_ONCE(umem->odp_data->dying, 1);
+	atomic_inc(&imr->num_leaf_free);
+	schedule_work(&umem->odp_data->work);
+
+	return 0;
+}
+
+void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
+{
+	struct ib_ucontext *ctx = imr->ibmr.pd->uobject->context;
+
+	down_read(&ctx->umem_rwsem);
+	rbt_ib_umem_for_each_in_range(&ctx->umem_tree, 0, ULLONG_MAX,
+				      mr_leaf_free, imr);
+	up_read(&ctx->umem_rwsem);
+
+	wait_event(imr->q_leaf_free, !atomic_read(&imr->num_leaf_free));
+}
+
 /*
  * Handle a single data segment in a page-fault WQE or RDMA region.
  *
@@ -195,47 +533,43 @@ static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
  * -EFAULT when there's an error mapping the requested pages. The caller will
  *  abort the page fault handling.
  */
-static int pagefault_single_data_segment(struct mlx5_ib_dev *mib_dev,
+static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 					 u32 key, u64 io_virt, size_t bcnt,
 					 u32 *bytes_committed,
 					 u32 *bytes_mapped)
 {
 	int srcu_key;
-	unsigned int current_seq;
+	unsigned int current_seq = 0;
 	u64 start_idx;
 	int npages = 0, ret = 0;
 	struct mlx5_ib_mr *mr;
 	u64 access_mask = ODP_READ_ALLOWED_BIT;
+	struct ib_umem_odp *odp;
+	int implicit = 0;
+	size_t size;
 
-	srcu_key = srcu_read_lock(&mib_dev->mr_srcu);
-	mr = mlx5_ib_odp_find_mr_lkey(mib_dev, key);
+	srcu_key = srcu_read_lock(&dev->mr_srcu);
+	mr = mlx5_ib_odp_find_mr_lkey(dev, key);
 	/*
 	 * If we didn't find the MR, it means the MR was closed while we were
 	 * handling the ODP event. In this case we return -EFAULT so that the
 	 * QP will be closed.
 	 */
 	if (!mr || !mr->ibmr.pd) {
-		pr_err("Failed to find relevant mr for lkey=0x%06x, probably the MR was destroyed\n",
-		       key);
+		mlx5_ib_dbg(dev, "Failed to find relevant mr for lkey=0x%06x, probably the MR was destroyed\n",
+			    key);
 		ret = -EFAULT;
 		goto srcu_unlock;
 	}
 	if (!mr->umem->odp_data) {
-		pr_debug("skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
-			 key);
+		mlx5_ib_dbg(dev, "skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
+			    key);
 		if (bytes_mapped)
 			*bytes_mapped +=
 				(bcnt - *bytes_committed);
 		goto srcu_unlock;
 	}
 
-	current_seq = ACCESS_ONCE(mr->umem->odp_data->notifiers_seq);
-	/*
-	 * Ensure the sequence number is valid for some time before we call
-	 * gup.
-	 */
-	smp_rmb();
-
 	/*
 	 * Avoid branches - this code will perform correctly
 	 * in all iterations (in iteration 2 and above,
@@ -244,63 +578,109 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *mib_dev,
 	io_virt += *bytes_committed;
 	bcnt -= *bytes_committed;
 
+	if (!mr->umem->odp_data->page_list) {
+		odp = implicit_mr_get_data(mr, io_virt, bcnt);
+
+		if (IS_ERR(odp)) {
+			ret = PTR_ERR(odp);
+			goto srcu_unlock;
+		}
+		mr = odp->private;
+		implicit = 1;
+
+	} else {
+		odp = mr->umem->odp_data;
+	}
+
+next_mr:
+	current_seq = READ_ONCE(odp->notifiers_seq);
+	/*
+	 * Ensure the sequence number is valid for some time before we call
+	 * gup.
+	 */
+	smp_rmb();
+
+	size = min_t(size_t, bcnt, ib_umem_end(odp->umem) - io_virt);
 	start_idx = (io_virt - (mr->mmkey.iova & PAGE_MASK)) >> PAGE_SHIFT;
 
 	if (mr->umem->writable)
 		access_mask |= ODP_WRITE_ALLOWED_BIT;
-	npages = ib_umem_odp_map_dma_pages(mr->umem, io_virt, bcnt,
-					   access_mask, current_seq);
-	if (npages < 0) {
-		ret = npages;
+
+	ret = ib_umem_odp_map_dma_pages(mr->umem, io_virt, size,
+					access_mask, current_seq);
+
+	if (ret < 0)
 		goto srcu_unlock;
-	}
 
-	if (npages > 0) {
-		mutex_lock(&mr->umem->odp_data->umem_mutex);
+	if (ret > 0) {
+		int np = ret;
+
+		mutex_lock(&odp->umem_mutex);
 		if (!ib_umem_mmu_notifier_retry(mr->umem, current_seq)) {
 			/*
 			 * No need to check whether the MTTs really belong to
 			 * this MR, since ib_umem_odp_map_dma_pages already
 			 * checks this.
 			 */
-			ret = mlx5_ib_update_xlt(mr, start_idx, npages,
+			ret = mlx5_ib_update_xlt(mr, start_idx, np,
 						 PAGE_SHIFT,
 						 MLX5_IB_UPD_XLT_ATOMIC);
 		} else {
 			ret = -EAGAIN;
 		}
-		mutex_unlock(&mr->umem->odp_data->umem_mutex);
+		mutex_unlock(&odp->umem_mutex);
 		if (ret < 0) {
 			if (ret != -EAGAIN)
-				pr_err("Failed to update mkey page tables\n");
+				mlx5_ib_err(dev, "Failed to update mkey page tables\n");
 			goto srcu_unlock;
 		}
 
 		if (bytes_mapped) {
-			u32 new_mappings = npages * PAGE_SIZE -
+			u32 new_mappings = np * PAGE_SIZE -
 				(io_virt - round_down(io_virt, PAGE_SIZE));
-			*bytes_mapped += min_t(u32, new_mappings, bcnt);
+			*bytes_mapped += min_t(u32, new_mappings, size);
 		}
+
+		npages += np;
+	}
+
+	bcnt -= size;
+	if (unlikely(bcnt)) {
+		struct ib_umem_odp *next;
+
+		io_virt += size;
+		next = odp_next(odp);
+		if (unlikely(!next || next->umem->address != io_virt)) {
+			mlx5_ib_dbg(dev, "next implicit leaf removed at 0x%llx. got %p\n",
+				    io_virt, next);
+			ret = -EAGAIN;
+			goto srcu_unlock_no_wait;
+		}
+		odp = next;
+		mr = odp->private;
+		goto next_mr;
 	}
 
 srcu_unlock:
 	if (ret == -EAGAIN) {
-		if (!mr->umem->odp_data->dying) {
-			struct ib_umem_odp *odp_data = mr->umem->odp_data;
+		if (implicit || !odp->dying) {
 			unsigned long timeout =
 				msecs_to_jiffies(MMU_NOTIFIER_TIMEOUT);
 
 			if (!wait_for_completion_timeout(
-					&odp_data->notifier_completion,
+					&odp->notifier_completion,
 					timeout)) {
-				pr_warn("timeout waiting for mmu notifier completion\n");
+				mlx5_ib_warn(dev, "timeout waiting for mmu notifier. seq %d against %d\n",
+					     current_seq, odp->notifiers_seq);
 			}
 		} else {
 			/* The MR is being killed, kill the QP as well. */
 			ret = -EFAULT;
 		}
 	}
-	srcu_read_unlock(&mib_dev->mr_srcu, srcu_key);
+
+srcu_unlock_no_wait:
+	srcu_read_unlock(&dev->mr_srcu, srcu_key);
 	*bytes_committed = 0;
 	return ret ? ret : npages;
 }
@@ -618,8 +998,8 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	} else if (ret < 0 || total_wqe_bytes > bytes_mapped) {
 		if (ret != -ENOENT)
-			mlx5_ib_err(dev, "Error getting user pages for page fault. Error: %d\n",
-				    ret);
+			mlx5_ib_err(dev, "PAGE FAULT error: %d. QP 0x%x. type: 0x%x\n",
+				    ret, pfault->wqe.wq_num, pfault->type);
 		goto resolve_page_fault;
 	}
 
@@ -627,7 +1007,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 resolve_page_fault:
 	mlx5_ib_page_fault_resume(dev, pfault, resume_with_error);
 	mlx5_ib_dbg(dev, "PAGE FAULT completed. QP 0x%x resume_with_error=%d, type: 0x%x\n",
-		    pfault->token, resume_with_error,
+		    pfault->wqe.wq_num, resume_with_error,
 		    pfault->type);
 	free_page((unsigned long)buffer);
 }
@@ -700,10 +1080,9 @@ static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,
 		ret = pagefault_single_data_segment(dev, rkey, address,
 						    prefetch_len,
 						    &bytes_committed, NULL);
-		if (ret < 0) {
+		if (ret < 0 && ret != -EAGAIN) {
 			mlx5_ib_warn(dev, "Prefetch failed. ret: %d, QP 0x%x, address: 0x%.16llx, length = 0x%.16x\n",
-				     ret, pfault->token, address,
-				     prefetch_len);
+				     ret, pfault->token, address, prefetch_len);
 		}
 	}
 }
@@ -728,19 +1107,61 @@ void mlx5_ib_pfault(struct mlx5_core_dev *mdev, void *context,
 	}
 }
 
-int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev)
+void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
+{
+	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
+		return;
+
+	switch (ent->order - 2) {
+	case MLX5_IMR_MTT_CACHE_ENTRY:
+		ent->page = PAGE_SHIFT;
+		ent->xlt = MLX5_IMR_MTT_ENTRIES *
+			   sizeof(struct mlx5_mtt) /
+			   MLX5_IB_UMR_OCTOWORD;
+		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
+		ent->limit = 0;
+		break;
+
+	case MLX5_IMR_KSM_CACHE_ENTRY:
+		ent->page = MLX5_KSM_PAGE_SHIFT;
+		ent->xlt = mlx5_imr_ksm_entries *
+			   sizeof(struct mlx5_klm) /
+			   MLX5_IB_UMR_OCTOWORD;
+		ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
+		ent->limit = 0;
+		break;
+	}
+}
+
+int mlx5_ib_odp_init_one(struct mlx5_ib_dev *dev)
 {
 	int ret;
 
-	ret = init_srcu_struct(&ibdev->mr_srcu);
+	ret = init_srcu_struct(&dev->mr_srcu);
 	if (ret)
 		return ret;
 
+	if (dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT) {
+		ret = mlx5_cmd_null_mkey(dev->mdev, &dev->null_mkey);
+		if (ret) {
+			mlx5_ib_err(dev, "Error getting null_mkey %d\n", ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
-void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev)
+void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *dev)
+{
+	cleanup_srcu_struct(&dev->mr_srcu);
+}
+
+int mlx5_ib_odp_init(void)
 {
-	cleanup_srcu_struct(&ibdev->mr_srcu);
+	mlx5_imr_ksm_entries = BIT_ULL(get_order(TASK_SIZE) -
+				       MLX5_IMR_MTT_BITS);
+
+	return 0;
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a78ee73..d9f928c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1053,6 +1053,8 @@ enum {
 
 enum {
 	MAX_UMR_CACHE_ENTRY = 20,
+	MLX5_IMR_MTT_CACHE_ENTRY,
+	MLX5_IMR_KSM_CACHE_ENTRY,
 	MAX_MR_CACHE_ENTRIES
 };
 
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
