From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 07/10] IB/mlx5: Add contiguous ODP support
Date: Mon,  3 Apr 2017 13:06:37 +0300
Message-ID: <20170403100640.3332-8-leon@kernel.org>
References: <20170403100640.3332-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403100640.3332-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currenlty ODP supports only regular MMU pages.
Add ODP support for regions consisting of physically contiguous chunks
of arbitrary order (huge pages for instance) to improve performance.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mem.c |  9 ++++-----
 drivers/infiniband/hw/mlx5/odp.c | 28 +++++++++++++++-------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index a0c2af964249..914f212e7ef6 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -61,13 +61,12 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,
 	int entry;
 	unsigned long page_shift = umem->page_shift;
 
-	/* With ODP we must always match OS page size. */
 	if (umem->odp_data) {
-		*count = ib_umem_page_count(umem);
-		*shift = PAGE_SHIFT;
-		*ncont = *count;
+		*ncont = ib_umem_page_count(umem);
+		*count = *ncont << (page_shift - PAGE_SHIFT);
+		*shift = page_shift;
 		if (order)
-			*order = ilog2(roundup_pow_of_two(*count));
+			*order = ilog2(roundup_pow_of_two(*ncont));
 
 		return;
 	}
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 0d52b72ff99b..eddabd6e6596 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -200,7 +200,7 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 	 */
 
 	for (addr = start; addr < end; addr += BIT(umem->page_shift)) {
-		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
+		idx = (addr - ib_umem_start(umem)) >> umem->page_shift;
 		/*
 		 * Strive to write the MTTs in chunks, but avoid overwriting
 		 * non-existing MTTs. The huristic here can be improved to
@@ -218,8 +218,7 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 
 			if (in_block && umr_offset == 0) {
 				mlx5_ib_update_xlt(mr, blk_start_idx,
-						   idx - blk_start_idx,
-						   PAGE_SHIFT,
+						   idx - blk_start_idx, 0,
 						   MLX5_IB_UPD_XLT_ZAP |
 						   MLX5_IB_UPD_XLT_ATOMIC);
 				in_block = 0;
@@ -228,8 +227,7 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 	}
 	if (in_block)
 		mlx5_ib_update_xlt(mr, blk_start_idx,
-				   idx - blk_start_idx + 1,
-				   PAGE_SHIFT,
+				   idx - blk_start_idx + 1, 0,
 				   MLX5_IB_UPD_XLT_ZAP |
 				   MLX5_IB_UPD_XLT_ATOMIC);
 	/*
@@ -516,7 +514,7 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 /*
  * Handle a single data segment in a page-fault WQE or RDMA region.
  *
- * Returns number of pages retrieved on success. The caller may continue to
+ * Returns number of OS pages retrieved on success. The caller may continue to
  * the next data segment.
  * Can return the following error codes:
  * -EAGAIN to designate a temporary error. The caller will abort handling the
@@ -531,13 +529,14 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 {
 	int srcu_key;
 	unsigned int current_seq = 0;
-	u64 start_idx;
+	u64 start_idx, page_mask;
 	int npages = 0, ret = 0;
 	struct mlx5_ib_mr *mr;
 	u64 access_mask = ODP_READ_ALLOWED_BIT;
 	struct ib_umem_odp *odp;
 	int implicit = 0;
 	size_t size;
+	int page_shift;
 
 	srcu_key = srcu_read_lock(&dev->mr_srcu);
 	mr = mlx5_ib_odp_find_mr_lkey(dev, key);
@@ -583,6 +582,9 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		odp = mr->umem->odp_data;
 	}
 
+	page_shift = mr->umem->page_shift;
+	page_mask = ~(BIT(page_shift) - 1);
+
 next_mr:
 	current_seq = READ_ONCE(odp->notifiers_seq);
 	/*
@@ -592,7 +594,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	smp_rmb();
 
 	size = min_t(size_t, bcnt, ib_umem_end(odp->umem) - io_virt);
-	start_idx = (io_virt - (mr->mmkey.iova & PAGE_MASK)) >> PAGE_SHIFT;
+	start_idx = (io_virt - (mr->mmkey.iova & page_mask)) >> page_shift;
 
 	if (mr->umem->writable)
 		access_mask |= ODP_WRITE_ALLOWED_BIT;
@@ -614,7 +616,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 			 * checks this.
 			 */
 			ret = mlx5_ib_update_xlt(mr, start_idx, np,
-						 PAGE_SHIFT,
+						 page_shift,
 						 MLX5_IB_UPD_XLT_ATOMIC);
 		} else {
 			ret = -EAGAIN;
@@ -625,14 +627,14 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 				mlx5_ib_err(dev, "Failed to update mkey page tables\n");
 			goto srcu_unlock;
 		}
-
 		if (bytes_mapped) {
-			u32 new_mappings = np * PAGE_SIZE -
-				(io_virt - round_down(io_virt, PAGE_SIZE));
+			u32 new_mappings = (np << page_shift) -
+				(io_virt - round_down(io_virt,
+						      1 << page_shift));
 			*bytes_mapped += min_t(u32, new_mappings, size);
 		}
 
-		npages += np;
+		npages += np << (page_shift - PAGE_SHIFT);
 	}
 
 	bcnt -= size;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
