From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 14/20] IB/mlx5: Changes in memory region creation to support on-demand paging
Date: Sun,  2 Mar 2014 12:49:32 +0200
Message-ID: <1393757378-16412-15-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch wraps together several changes needed for on-demand paging support
in the mlx5_ib_populate_pas function, and when registering memory regions.

* Instead of accepting a UMR bit telling the function to enable all access
  flags, the function now accepts the access flags themselves.
* For on-demand paging memory regions, fill the memory tables from the
  correct list, and enable/disable the access flags per-page according to
  whether the page is present.
* A new bit is set to enable writing of access flags when using the firmware
  create_mkey command.
* Disable contig pages when on-demand paging is enabled.

In addition the patch changes the UMR code to use PTR_ALIGN instead of our own
macro.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mem.c     | 54 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 12 +++++++-
 drivers/infiniband/hw/mlx5/mr.c      | 32 +++++++++++----------
 include/linux/mlx5/device.h          |  3 ++
 4 files changed, 83 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 8499aec..d760bfb 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -32,6 +32,7 @@
 
 #include <linux/module.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_umem_odp.h>
 #include "mlx5_ib.h"
 
 /* @umem: umem object to scan
@@ -56,6 +57,17 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 	struct scatterlist *sg;
 	int entry;
 
+	/* With ODP we must always match OS page size. */
+	if (umem->odp_data) {
+		*count = ib_umem_page_count(umem);
+		*shift = PAGE_SHIFT;
+		*ncont = *count;
+		if (order)
+			*order = ilog2(roundup_pow_of_two(*count));
+
+		return;
+	}
+
 	addr = addr >> PAGE_SHIFT;
 	tmp = (unsigned long)addr;
 	m = find_first_bit(&tmp, sizeof(tmp));
@@ -107,8 +119,31 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 	*count = i;
 }
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+static u64 umem_dma_to_mtt(dma_addr_t umem_dma)
+{
+	u64 mtt_entry = umem_dma & ODP_DMA_ADDR_MASK;
+
+	if (umem_dma & ODP_READ_ALLOWED_BIT)
+		mtt_entry |= MLX5_IB_MTT_READ;
+	if (umem_dma & ODP_WRITE_ALLOWED_BIT)
+		mtt_entry |= MLX5_IB_MTT_WRITE;
+
+	return mtt_entry;
+}
+#endif
+
+/*
+ * Populate the given array with bus addresses from the umem.
+ *
+ * dev - mlx5_ib device
+ * umem - umem to use to fill the pages
+ * page_shift - determines the page size used in the resulting array
+ * pas - bus addresses array to fill
+ * access_flags - access flags to set on all present pages
+ */
 void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
-			  int page_shift, __be64 *pas, int umr)
+			  int page_shift, __be64 *pas, int access_flags)
 {
 	int shift = page_shift - PAGE_SHIFT;
 	int mask = (1 << shift) - 1;
@@ -118,6 +153,20 @@ void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 	int len;
 	struct scatterlist *sg;
 	int entry;
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	const bool odp = umem->odp_data != NULL;
+
+	if (odp) {
+		int num_pages = ib_umem_num_pages(umem);
+		WARN_ON(shift != 0);
+		WARN_ON(access_flags != (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE));
+		for (i = 0; i < num_pages; ++i) {
+			dma_addr_t pa = umem->odp_data->dma_list[i];
+			pas[i] = cpu_to_be64(umem_dma_to_mtt(pa));
+		}
+		return;
+	}
+#endif
 
 	i = 0;
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
@@ -126,8 +175,7 @@ void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 		for (k = 0; k < len; k++) {
 			if (!(i & mask)) {
 				cur = base + (k << PAGE_SHIFT);
-				if (umr)
-					cur |= 3;
+				cur |= access_flags;
 
 				pas[i >> shift] = cpu_to_be64(cur);
 				mlx5_ib_dbg(dev, "pas[%d] 0x%llx\n",
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 767e791..dd93790 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -268,6 +268,13 @@ struct mlx5_ib_xrcd {
 	u32			xrcdn;
 };
 
+enum mlx5_ib_mtt_access_flags {
+	MLX5_IB_MTT_READ  = (1 << 0),
+	MLX5_IB_MTT_WRITE = (1 << 1),
+};
+
+#define MLX5_IB_MTT_PRESENT (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE)
+
 struct mlx5_ib_mr {
 	struct ib_mr		ibmr;
 	struct mlx5_core_mr	mmr;
@@ -562,7 +569,7 @@ void mlx5_ib_cleanup_fmr(struct mlx5_ib_dev *dev);
 void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 			int *ncont, int *order);
 void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
-			  int page_shift, __be64 *pas, int umr);
+			  int page_shift, __be64 *pas, int access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
 int mlx5_ib_get_cqe_size(struct mlx5_ib_dev *dev, struct ib_cq *ibcq);
 int mlx5_mr_cache_init(struct mlx5_ib_dev *dev);
@@ -594,4 +601,7 @@ static inline u8 convert_access(int acc)
 	       MLX5_PERM_LOCAL_READ;
 }
 
+#define MLX5_MAX_UMR_SHIFT 17
+#define MLX5_MAX_UMR_PAGES (1 << MLX5_MAX_UMR_SHIFT)
+
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d1e8426..5ea099e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -48,13 +48,6 @@ enum {
 	MLX5_UMR_ALIGN	= 2048
 };
 
-static __be64 *mr_align(__be64 *ptr, int align)
-{
-	unsigned long mask = align - 1;
-
-	return (__be64 *)(((unsigned long)ptr + mask) & ~mask);
-}
-
 static int order2idx(struct mlx5_ib_dev *dev, int order)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
@@ -666,7 +659,7 @@ static int get_octo_len(u64 addr, u64 len, int page_size)
 
 static int use_umr(int order)
 {
-	return order <= 17;
+	return order <= MLX5_MAX_UMR_SHIFT;
 }
 
 static void prep_umr_reg_wqe(struct ib_pd *pd, struct ib_send_wr *wr,
@@ -743,7 +736,8 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	struct ib_send_wr wr, *bad;
 	struct mlx5_ib_mr *mr;
 	struct ib_sge sg;
-	int size = sizeof(u64) * npages;
+	int size;
+	__be64 *pas;
 	int err = 0;
 	int i;
 
@@ -762,17 +756,22 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	if (!mr)
 		return ERR_PTR(-EAGAIN);
 
+	/* UMR copies MTTs in units of MLX5_UMR_MTT_ALIGNMENT bytes.
+	 * To avoid copying garbage after the pas array, we allocate
+	 * a little more. */
+	size = ALIGN(sizeof(u64) * npages, MLX5_UMR_MTT_ALIGNMENT);
 	mr->pas = kmalloc(size + MLX5_UMR_ALIGN - 1, GFP_KERNEL);
 	if (!mr->pas) {
 		err = -ENOMEM;
 		goto free_mr;
 	}
 
-	mlx5_ib_populate_pas(dev, umem, page_shift,
-			     mr_align(mr->pas, MLX5_UMR_ALIGN), 1);
+	pas = PTR_ALIGN(mr->pas, MLX5_UMR_ALIGN);
+	mlx5_ib_populate_pas(dev, umem, page_shift, pas, MLX5_IB_MTT_PRESENT);
+	/* Clear padding after the actual pages. */
+	memset(pas + npages, 0, size - npages * sizeof(u64));
 
-	mr->dma = dma_map_single(ddev, mr_align(mr->pas, MLX5_UMR_ALIGN), size,
-				 DMA_TO_DEVICE);
+	mr->dma = dma_map_single(ddev, pas, size, DMA_TO_DEVICE);
 	if (dma_mapping_error(ddev, mr->dma)) {
 		err = -ENOMEM;
 		goto free_pas;
@@ -826,6 +825,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, u64 virt_addr,
 	struct mlx5_ib_mr *mr;
 	int inlen;
 	int err;
+	bool pg_cap = !!(dev->mdev.caps.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG);
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
@@ -837,8 +837,12 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, u64 virt_addr,
 		err = -ENOMEM;
 		goto err_1;
 	}
-	mlx5_ib_populate_pas(dev, umem, page_shift, in->pas, 0);
+	mlx5_ib_populate_pas(dev, umem, page_shift, in->pas,
+			     pg_cap ? MLX5_IB_MTT_PRESENT : 0);
 
+	/* The MLX5_MKEY_INBOX_PG_ACCESS bit allows setting the access flags
+	 * in the page list submitted with the command. */
+	in->flags = pg_cap ? cpu_to_be32(MLX5_MKEY_INBOX_PG_ACCESS) : 0;
 	in->seg.flags = convert_access(access_flags) |
 		MLX5_ACCESS_MODE_MTT;
 	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0a6fe1b..e0abd4e 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -149,6 +149,9 @@ enum {
 	MLX5_UMR_INLINE			= (1 << 7),
 };
 
+#define MLX5_UMR_MTT_ALIGNMENT 0x40
+#define MLX5_UMR_MTT_MASK      (MLX5_UMR_MTT_ALIGNMENT - 1)
+
 enum mlx5_event {
 	MLX5_EVENT_TYPE_COMP		   = 0x0,
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
