From: j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 34/36] IB/mlx5/hmm: add mlx5 HMM device initialization and callback.
Date: Thu, 21 May 2015 15:23:51 -0400
Message-ID: <1432236233-4035-35-git-send-email-j.glisse@gmail.com>
References: <1432236233-4035-1-git-send-email-j.glisse@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432236233-4035-1-git-send-email-j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brendan Conoboy <blc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Donohue <jdonohue-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This add the core HMM callback for mlx5 device driver and initialize
the HMM device for the mlx5 infiniband device driver.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/umem_odp.c   |  12 ++-
 drivers/infiniband/hw/mlx5/main.c    |   5 +
 drivers/infiniband/hw/mlx5/mem.c     |  36 ++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  19 +++-
 drivers/infiniband/hw/mlx5/mr.c      |   9 +-
 drivers/infiniband/hw/mlx5/odp.c     | 177 +++++++++++++++++++++++++++=
+++++++-
 include/rdma/ib_umem_odp.h           |  20 +++-
 7 files changed, 268 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/co=
re/umem_odp.c
index d5d57a8..559542d 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -132,7 +132,7 @@ int ib_umem_odp_get(struct ib_ucontext *context, st=
ruct ib_umem *umem)
 			return -ENOMEM;
 		}
 		kref_init(&ib_mirror->kref);
-		init_rwsem(&ib_mirror->hmm_mr_rwsem);
+		init_rwsem(&ib_mirror->umem_rwsem);
 		ib_mirror->umem_tree =3D RB_ROOT;
 		ib_mirror->ib_device =3D ib_device;
=20
@@ -149,10 +149,11 @@ int ib_umem_odp_get(struct ib_ucontext *context, =
struct ib_umem *umem)
 		context->ib_mirror =3D ib_mirror_ref(ib_mirror);
 	}
 	mutex_unlock(&ib_device->hmm_mutex);
-	umem->odp_data.ib_mirror =3D ib_mirror;
+	umem->odp_data->ib_mirror =3D ib_mirror;
=20
 	down_write(&ib_mirror->umem_rwsem);
-	rbt_ib_umem_insert(&umem->odp_data->interval_tree, &mirror->umem_tree=
);
+	rbt_ib_umem_insert(&umem->odp_data->interval_tree,
+			   &ib_mirror->umem_tree);
 	up_write(&ib_mirror->umem_rwsem);
=20
 	mmput(mm);
@@ -161,7 +162,7 @@ int ib_umem_odp_get(struct ib_ucontext *context, st=
ruct ib_umem *umem)
=20
 void ib_umem_odp_release(struct ib_umem *umem)
 {
-	struct ib_mirror *ib_mirror =3D umem->odp_data;
+	struct ib_mirror *ib_mirror =3D umem->odp_data->ib_mirror;
=20
 	/*
 	 * Ensure that no more pages are mapped in the umem.
@@ -178,7 +179,8 @@ void ib_umem_odp_release(struct ib_umem *umem)
 	 * range covered by one and only one umem while holding the umem rwse=
m.
 	 */
 	down_write(&ib_mirror->umem_rwsem);
-	rbt_ib_umem_remove(&umem->odp_data->interval_tree, &mirror->umem_tree=
);
+	rbt_ib_umem_remove(&umem->odp_data->interval_tree,
+			   &ib_mirror->umem_tree);
 	up_write(&ib_mirror->umem_rwsem);
=20
 	ib_mirror_unref(ib_mirror);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/=
mlx5/main.c
index d553f90..eddabf0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1316,6 +1316,9 @@ static void *mlx5_ib_add(struct mlx5_core_dev *md=
ev)
 	if (err)
 		goto err_rsrc;
=20
+	/* If HMM initialization fails we just do not enable odp. */
+	mlx5_dev_init_odp_hmm(&dev->ib_dev, &mdev->pdev->dev);
+
 	err =3D ib_register_device(&dev->ib_dev, NULL);
 	if (err)
 		goto err_odp;
@@ -1340,6 +1343,7 @@ err_umrc:
=20
 err_dev:
 	ib_unregister_device(&dev->ib_dev);
+	mlx5_dev_fini_odp_hmm(&dev->ib_dev);
=20
 err_odp:
 	mlx5_ib_odp_remove_one(dev);
@@ -1359,6 +1363,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *=
mdev, void *context)
=20
 	ib_unregister_device(&dev->ib_dev);
 	destroy_umrc_res(dev);
+	mlx5_dev_fini_odp_hmm(&dev->ib_dev);
 	mlx5_ib_odp_remove_one(dev);
 	destroy_dev_resources(&dev->devr);
 	ib_dealloc_device(&dev->ib_dev);
diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/m=
lx5/mem.c
index 21084c7..f150825 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -164,7 +164,41 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *de=
v, struct ib_umem *umem,
 	int entry;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+	if (umem->odp_data) {
+		struct ib_mirror *ib_mirror =3D umem->odp_data->ib_mirror;
+		struct hmm_mirror *mirror =3D &ib_mirror->base;
+		struct hmm_pt_iter *iter =3D data, local_iter;
+		unsigned long addr;
+
+		if (iter =3D=3D NULL) {
+			iter =3D &local_iter;
+			hmm_pt_iter_init(iter);
+		}
+
+		for (i =3D 0, addr =3D ib_umem_start(umem) + (offset << PAGE_SHIFT);
+		     i < num_pages; ++i, addr +=3D PAGE_SIZE) {
+			dma_addr_t *ptep, pte;
+
+			/* Get and lock pointer to mirror page table. */
+			ptep =3D hmm_pt_iter_update(iter, &mirror->pt, addr);
+			pte =3D ptep ? *ptep : 0;
+			/* HMM will not have any page tables set up, if this
+			 * function is called before page faults have happened
+			 * on the MR. In that case, we don't have PA's yet, so
+			 * just set each one to zero and continue on. The hw
+			 * will trigger a page fault.
+			 */
+			if (hmm_pte_test_valid_dma(&pte))
+				pas[i] =3D cpu_to_be64(umem_dma_to_mtt(pte));
+			else
+				pas[i] =3D (__be64)0;
+		}
+
+		if (iter =3D=3D &local_iter)
+			hmm_pt_iter_fini(iter, &mirror->pt);
+
+		return;
+	}
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	const bool odp =3D umem->odp_data !=3D NULL;
=20
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
index a6d62be..f1bafd4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -615,6 +615,7 @@ int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32=
 check_mask,
 			    struct ib_mr_status *mr_status);
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+
 extern struct workqueue_struct *mlx5_ib_page_fault_wq;
=20
 int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev);
@@ -629,13 +630,18 @@ void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib=
_qp *qp);
 void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp);
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+void mlx5_dev_init_odp_hmm(struct ib_device *ib_dev, struct device *de=
v);
+void mlx5_dev_fini_odp_hmm(struct ib_device *ib_dev);
+int mlx5_ib_umem_invalidate(struct ib_umem *umem, u64 start,
+			    u64 end, void *cookie);
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long star=
t,
 			      unsigned long end);
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
=20
+
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
+
 static inline int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *=
dev)
 {
 	return 0;
@@ -671,4 +677,15 @@ static inline u8 convert_access(int acc)
 #define MLX5_MAX_UMR_SHIFT 16
 #define MLX5_MAX_UMR_PAGES (1 << MLX5_MAX_UMR_SHIFT)
=20
+#ifndef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+static inline void mlx5_dev_init_odp_hmm(struct ib_device *ib_dev,
+					 struct device *dev)
+{
+}
+
+static inline void mlx5_dev_fini_odp_hmm(struct ib_device *ib_dev)
+{
+}
+#endif /* ! CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/ml=
x5/mr.c
index 23cd123..7b2d84a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1210,7 +1210,14 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		/* Wait for all running page-fault handlers to finish. */
 		synchronize_srcu(&dev->mr_srcu);
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+		if (mlx5_ib_umem_invalidate(umem, ib_umem_start(umem),
+					    ib_umem_end(umem), NULL))
+			/*
+			 * FIXME do something to kill all mr and umem
+			 * in use by this process.
+			 */
+			pr_err("killing all mr with odp due to "
+			       "mtt update failure\n");
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 		/* Destroy all page mappings */
 		mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/m=
lx5/odp.c
index 1de4d13..bd29155 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -52,8 +52,183 @@ static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(=
struct mlx5_ib_dev *dev,
 	return container_of(mmr, struct mlx5_ib_mr, mmr);
 }
=20
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+
+
+int mlx5_ib_umem_invalidate(struct ib_umem *umem, u64 start,
+			    u64 end, void *cookie)
+{
+	const u64 umr_block_mask =3D (MLX5_UMR_MTT_ALIGNMENT / sizeof(u64)) -=
 1;
+	u64 idx =3D 0, blk_start_idx =3D 0;
+	struct hmm_pt_iter iter;
+	struct mlx5_ib_mr *mlx5_ib_mr;
+	struct hmm_mirror *mirror;
+	int in_block =3D 0;
+	u64 addr;
+	int ret =3D 0;
+
+	if (!umem || !umem->odp_data) {
+		pr_err("invalidation called on NULL umem or non-ODP umem\n");
+		return -EINVAL;
+	}
+
+	/* Is this ib_mr active and registered yet ? */
+	if (umem->odp_data->private =3D=3D NULL)
+		return 0;
+
+	mlx5_ib_mr =3D umem->odp_data->private;
+	if (!mlx5_ib_mr->ibmr.pd)
+		return 0;
+
+	start =3D max_t(u64, ib_umem_start(umem), start);
+	end =3D min_t(u64, ib_umem_end(umem), end);
+	hmm_pt_iter_init(&iter);
+	mirror =3D &umem->odp_data->ib_mirror->base;
+
+	/*
+	 * Iteration one - zap the HW's MTTs. HMM ensures that while we are
+	 * doing the invalidation, no page fault will attempt to overwrite th=
e
+	 * same MTTs.  Concurent invalidations might race us, but they will
+	 * write 0s as well, so no difference in the end result.
+	 */
+	for (addr =3D start; addr < end; addr +=3D (u64)umem->page_size) {
+		dma_addr_t *ptep;
+
+		/* Need to happen before ptep as ptep might break the loop and
+		 * idx might be use outside the loop.
+		 */
+		idx =3D (addr - ib_umem_start(umem)) / PAGE_SIZE;
+
+		/* Get and lock pointer to mirror page table. */
+		ptep =3D hmm_pt_iter_update(&iter, &mirror->pt, addr);
+		if (!ptep) {
+			addr =3D hmm_pt_iter_next(&iter, &mirror->pt, addr, end);
+			continue;
+		}
+
+		/*
+		 * Strive to write the MTTs in chunks, but avoid overwriting
+		 * non-existing MTTs. The huristic here can be improved to
+		 * estimate the cost of another UMR vs. the cost of bigger
+		 * UMR.
+		 */
+		if ((*ptep) & (ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT)) {
+			if ((*ptep) & ODP_WRITE_ALLOWED_BIT)
+				hmm_pte_set_dirty(ptep);
+			/*
+			 * Because there can not be concurrent overlapping
+			 * munmap, page migrate, page write protect then it
+			 * is safe here to clear those bits.
+			 */
+			hmm_pte_clear_bit(ptep, ODP_READ_ALLOWED_SHIFT);
+			hmm_pte_clear_bit(ptep, ODP_WRITE_ALLOWED_SHIFT);
+			if (!in_block) {
+				blk_start_idx =3D idx;
+				in_block =3D 1;
+			}
+		} else {
+			u64 umr_offset =3D idx & umr_block_mask;
+
+			if (in_block && umr_offset =3D=3D 0) {
+				ret =3D mlx5_ib_update_mtt(mlx5_ib_mr,
+							 blk_start_idx,
+							 idx - blk_start_idx, 1,
+							 &iter) || ret;
+				in_block =3D 0;
+			}
+		}
+	}
+	if (in_block)
+		ret =3D mlx5_ib_update_mtt(mlx5_ib_mr, blk_start_idx,
+					 idx - blk_start_idx + 1, 1,
+					 &iter) || ret;
+	hmm_pt_iter_fini(&iter, &mirror->pt);
+	return ret;
+}
+
+static int mlx5_hmm_invalidate_range(struct hmm_mirror *mirror,
+				     unsigned long start,
+				     unsigned long end)
+{
+	struct ib_mirror *ib_mirror;
+	int ret;
+
+	ib_mirror =3D container_of(mirror, struct ib_mirror, base);
+
+	/* Go over all memory region and invalidate them. */
+	down_read(&ib_mirror->umem_rwsem);
+	ret =3D rbt_ib_umem_for_each_in_range(&ib_mirror->umem_tree, start, e=
nd,
+					    mlx5_ib_umem_invalidate, NULL);
+	up_read(&ib_mirror->umem_rwsem);
+	return ret;
+}
+
+static void mlx5_hmm_release(struct hmm_mirror *mirror)
+{
+	struct ib_mirror *ib_mirror;
+
+	ib_mirror =3D container_of(mirror, struct ib_mirror, base);
+
+	/* Go over all memory region and invalidate them. */
+	mlx5_hmm_invalidate_range(mirror, 0, ULLONG_MAX);
+}
+
+static int mlx5_hmm_update(struct hmm_mirror *mirror,
+			   const struct hmm_event *event)
+{
+	struct device *device =3D mirror->device->dev;
+	int ret =3D 0;
+
+	switch (event->etype) {
+	case HMM_DEVICE_RFAULT:
+	case HMM_DEVICE_WFAULT:
+		/* FIXME implement. */
+		break;
+	case HMM_ISDIRTY:
+		hmm_mirror_range_dirty(mirror, event->start, event->end);
+		break;
+	case HMM_NONE:
+	default:
+		dev_warn(device, "Warning: unhandled HMM event (%d)"
+			 "defaulting to invalidation\n", event->etype);
+		/* Fallthrough. */
+	/* For write protect and fork we could only invalidate writeable mr. =
*/
+	case HMM_WRITE_PROTECT:
+	case HMM_MIGRATE:
+	case HMM_MUNMAP:
+	case HMM_FORK:
+		ret =3D mlx5_hmm_invalidate_range(mirror,
+						event->start,
+						event->end);
+		break;
+	}
+
+	return ret;
+}
+
+static const struct hmm_device_ops mlx5_hmm_ops =3D {
+	.release		=3D &mlx5_hmm_release,
+	.update			=3D &mlx5_hmm_update,
+};
+
+void mlx5_dev_init_odp_hmm(struct ib_device *ib_device, struct device =
*dev)
+{
+	INIT_LIST_HEAD(&ib_device->ib_mirrors);
+	ib_device->hmm_dev.dev =3D dev;
+	ib_device->hmm_dev.ops =3D &mlx5_hmm_ops;
+	ib_device->hmm_ready =3D !hmm_device_register(&ib_device->hmm_dev);
+	mutex_init(&ib_device->hmm_mutex);
+}
+
+void mlx5_dev_fini_odp_hmm(struct ib_device *ib_device)
+{
+	if (!ib_device->hmm_ready)
+		return;
+	hmm_device_unregister(&ib_device->hmm_dev);
+}
+
+
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
=20
=20
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index c7c2670..e982fd3 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -133,7 +133,25 @@ struct umem_odp_node *rbt_ib_umem_iter_next(struct=
 umem_odp_node *node,
=20
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+
+
+/*
+ * HMM have few bits reserved for hardware specific bits inside the mi=
rror page
+ * table. For IB we record the mapping protection per page there.
+ */
+#define ODP_READ_ALLOWED_SHIFT	(HMM_PTE_HW_SHIFT + 0)
+#define ODP_WRITE_ALLOWED_SHIFT	(HMM_PTE_HW_SHIFT + 1)
+#define ODP_READ_ALLOWED_BIT	(1 << ODP_READ_ALLOWED_SHIFT)
+#define ODP_WRITE_ALLOWED_BIT	(1 << ODP_WRITE_ALLOWED_SHIFT)
+
+/* Make sure we are not overwritting valid address bit on target arch.=
 */
+#if (HMM_PTE_HW_SHIFT + 2) > PAGE_SHIFT
+#error (HMM_PTE_HW_SHIFT + 2) > PAGE_SHIFT
+#endif
+
+#define ODP_DMA_ADDR_MASK HMM_PTE_DMA_MASK
+
+
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
=20
=20
--=20
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
