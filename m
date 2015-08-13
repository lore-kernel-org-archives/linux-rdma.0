From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [RFC PATCH 6/8 v2] IB/mlx5/hmm: add mlx5 HMM device initialization and callback v3.
Date: Thu, 13 Aug 2015 15:20:51 -0400
Message-ID: <1439493653-1191-7-git-send-email-jglisse@redhat.com>
References: <1439493653-1191-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439493653-1191-1-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christophe Harle <charle@nvidia.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Mark Hairgrove <mhairgrove@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Haggai Eran <haggaie@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Liran Liss <liranl@mellanox.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
List-Id: linux-rdma@vger.kernel.org

This add the core HMM callback for mlx5 device driver and initialize
the HMM device for the mlx5 infiniband device driver.

Changed since v1:
  - Adapt to new hmm_mirror lifetime rules.
  - HMM_ISDIRTY no longer exist.

Changed since v2:
  - Adapt to HMM page table changes.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c   |  10 +-
 drivers/infiniband/hw/mlx5/main.c    |   5 +
 drivers/infiniband/hw/mlx5/mem.c     |  38 ++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  17 ++++
 drivers/infiniband/hw/mlx5/mr.c      |   7 ++
 drivers/infiniband/hw/mlx5/odp.c     | 174 +++++++++++++++++++++++++++=
++++++++
 include/rdma/ib_umem_odp.h           |  17 ++++
 7 files changed, 264 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/co=
re/umem_odp.c
index bcbc2c2..b7dd8228 100644
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
index da31c70..32ed2f1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1530,6 +1530,9 @@ static void *mlx5_ib_add(struct mlx5_core_dev *md=
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
@@ -1554,6 +1557,7 @@ err_umrc:
=20
 err_dev:
 	ib_unregister_device(&dev->ib_dev);
+	mlx5_dev_fini_odp_hmm(&dev->ib_dev);
=20
 err_odp:
 	mlx5_ib_odp_remove_one(dev);
@@ -1573,6 +1577,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *=
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
index 19354b6..0d74eac 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -154,6 +154,8 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev=
, struct ib_umem *umem,
 			    __be64 *pas, int access_flags, void *data)
 {
 	unsigned long umem_page_shift =3D ilog2(umem->page_size);
+	unsigned long start =3D ib_umem_start(umem) + (offset << PAGE_SHIFT);
+	unsigned long end =3D start + (num_pages << PAGE_SHIFT);
 	int shift =3D page_shift - umem_page_shift;
 	int mask =3D (1 << shift) - 1;
 	int i, k;
@@ -164,6 +166,42 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *de=
v, struct ib_umem *umem,
 	int entry;
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
+	if (umem->odp_data) {
+		struct ib_mirror *ib_mirror =3D umem->odp_data->ib_mirror;
+		struct hmm_mirror *mirror =3D &ib_mirror->base;
+		struct hmm_pt_iter *iter =3D data, local_iter;
+		unsigned long addr;
+
+		if (iter =3D=3D NULL) {
+			iter =3D &local_iter;
+			hmm_pt_iter_init(iter, &mirror->pt);
+		}
+
+		for (i=3D0, addr=3Dstart; i < num_pages; ++i, addr+=3DPAGE_SIZE) {
+			unsigned long next =3D end;
+			dma_addr_t *ptep, pte;
+
+			/* Get and lock pointer to mirror page table. */
+			ptep =3D hmm_pt_iter_lookup(iter, addr, &next);
+			pte =3D ptep ? *ptep : 0;
+			/*
+			 * HMM will not have any page tables set up, if this
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
+			hmm_pt_iter_fini(iter);
+
+		return;
+	}
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	const bool odp =3D umem->odp_data !=3D NULL;
=20
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
index 28b500a..ba2d46e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -635,6 +635,7 @@ int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32=
 check_mask,
 			    struct ib_mr_status *mr_status);
=20
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)
+
 extern struct workqueue_struct *mlx5_ib_page_fault_wq;
=20
 void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev);
@@ -649,11 +650,16 @@ void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib=
_qp *qp);
 void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp);
=20
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
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
 static inline void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *=
dev)
 {
@@ -690,4 +696,15 @@ static inline u8 convert_access(int acc)
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
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/ml=
x5/mr.c
index 18893611..ae71b78 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1209,6 +1209,13 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		/* Wait for all running page-fault handlers to finish. */
 		synchronize_srcu(&dev->mr_srcu);
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
+		if (mlx5_ib_umem_invalidate(umem, ib_umem_start(umem),
+					    ib_umem_end(umem), NULL))
+			/*
+			 * FIXME do something to kill all mr and umem
+			 * in use by this process.
+			 */
+			pr_err("killing all mr with odp due to mtt update failure\n");
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 		/* Destroy all page mappings */
 		mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/m=
lx5/odp.c
index 7299542..5ef31da 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -53,6 +53,180 @@ static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(=
struct mlx5_ib_dev *dev,
 }
=20
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
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
+	unsigned long addr;
+	int in_block =3D 0;
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
+	mirror =3D &umem->odp_data->ib_mirror->base;
+	start =3D max_t(u64, ib_umem_start(umem), start);
+	end =3D min_t(u64, ib_umem_end(umem), end);
+	hmm_pt_iter_init(&iter, &mirror->pt);
+
+	/*
+	 * Iteration one - zap the HW's MTTs. HMM ensures that while we are
+	 * doing the invalidation, no page fault will attempt to overwrite th=
e
+	 * same MTTs.  Concurent invalidations might race us, but they will
+	 * write 0s as well, so no difference in the end result.
+	 */
+	for (addr =3D start; addr < end; addr +=3D (u64)umem->page_size) {
+		unsigned long next =3D end;
+		dma_addr_t *ptep;
+
+		/* Get and lock pointer to mirror page table. */
+		ptep =3D hmm_pt_iter_walk(&iter, &addr, &next);
+		for (; ptep && addr < next; addr +=3D PAGE_SIZE, ptep++) {
+			idx =3D (addr - ib_umem_start(umem)) / PAGE_SIZE;
+			/*
+			 * Strive to write the MTTs in chunks, but avoid
+			 * overwriting non-existing MTTs. The huristic here can
+			 * be improved to estimate the cost of another UMR vs.
+			 * the cost of bigger UMR.
+			 */
+			if ((*ptep) & (ODP_READ_ALLOWED_BIT |
+				       ODP_WRITE_ALLOWED_BIT)) {
+				if ((*ptep) & ODP_WRITE_ALLOWED_BIT)
+					hmm_pte_set_dirty(ptep);
+				/*
+				 * Because there can not be concurrent overlapping
+				 * munmap, page migrate, page write protect then it
+				 * is safe here to clear those bits.
+				 */
+				hmm_pte_clear_bit(ptep, ODP_READ_ALLOWED_SHIFT);
+				hmm_pte_clear_bit(ptep, ODP_WRITE_ALLOWED_SHIFT);
+				if (!in_block) {
+					blk_start_idx =3D idx;
+					in_block =3D 1;
+				}
+			} else {
+				u64 umr_offset =3D idx & umr_block_mask;
+
+				if (in_block && umr_offset =3D=3D 0) {
+					ret =3D mlx5_ib_update_mtt(mlx5_ib_mr,
+							 blk_start_idx,
+							 idx - blk_start_idx,
+							 1, &iter) || ret;
+					in_block =3D 0;
+				}
+			}
+		}
+	}
+	if (in_block)
+		ret =3D mlx5_ib_update_mtt(mlx5_ib_mr, blk_start_idx,
+					 idx - blk_start_idx + 1, 1,
+					 &iter) || ret;
+	hmm_pt_iter_fini(&iter);
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
+static void mlx5_hmm_free(struct hmm_mirror *mirror)
+{
+	struct ib_mirror *ib_mirror;
+
+	ib_mirror =3D container_of(mirror, struct ib_mirror, base);
+	kfree(ib_mirror);
+}
+
+static int mlx5_hmm_update(struct hmm_mirror *mirror,
+			    struct hmm_event *event)
+{
+	struct device *device =3D mirror->device->dev;
+	int ret =3D 0;
+
+	switch (event->etype) {
+	case HMM_DEVICE_RFAULT:
+	case HMM_DEVICE_WFAULT:
+		/* FIXME implement. */
+		break;
+	case HMM_NONE:
+	default:
+		dev_warn(device, "Warning: unhandled HMM event (%d) defaulting to in=
validation\n",
+			 event->etype);
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
+	.free			=3D &mlx5_hmm_free,
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
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
=20
=20
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 36b72f0..fccbf36 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -133,6 +133,23 @@ struct umem_odp_node *rbt_ib_umem_iter_next(struct=
 umem_odp_node *node,
=20
=20
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
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
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
=20
=20
--=20
1.9.3
