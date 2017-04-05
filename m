From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 09/10] IB/mlx5: Extract page fault code
Date: Wed,  5 Apr 2017 09:23:58 +0300
Message-ID: <20170405062359.26623-10-leon@kernel.org>
References: <20170405062359.26623-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405062359.26623-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To make page fault handling code more flexible
split pagefault_single_data_segment() function.
Keep MR resolution in pagefault_single_data_segment() and
move actual updates into pagefault_single_mr().

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 203 ++++++++++++++++++++-------------------
 1 file changed, 104 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index eddabd6e6596..842e1dbb50b8 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -511,81 +511,38 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 	wait_event(imr->q_leaf_free, !atomic_read(&imr->num_leaf_free));
 }
 
-/*
- * Handle a single data segment in a page-fault WQE or RDMA region.
- *
- * Returns number of OS pages retrieved on success. The caller may continue to
- * the next data segment.
- * Can return the following error codes:
- * -EAGAIN to designate a temporary error. The caller will abort handling the
- *  page fault and resolve it.
- * -EFAULT when there's an error mapping the requested pages. The caller will
- *  abort the page fault handling.
- */
-static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
-					 u32 key, u64 io_virt, size_t bcnt,
-					 u32 *bytes_committed,
-					 u32 *bytes_mapped)
+static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
+			u64 io_virt, size_t bcnt, u32 *bytes_mapped)
 {
-	int srcu_key;
-	unsigned int current_seq = 0;
-	u64 start_idx, page_mask;
-	int npages = 0, ret = 0;
-	struct mlx5_ib_mr *mr;
 	u64 access_mask = ODP_READ_ALLOWED_BIT;
+	int npages = 0, page_shift, np;
+	u64 start_idx, page_mask;
 	struct ib_umem_odp *odp;
-	int implicit = 0;
+	int current_seq;
 	size_t size;
-	int page_shift;
-
-	srcu_key = srcu_read_lock(&dev->mr_srcu);
-	mr = mlx5_ib_odp_find_mr_lkey(dev, key);
-	/*
-	 * If we didn't find the MR, it means the MR was closed while we were
-	 * handling the ODP event. In this case we return -EFAULT so that the
-	 * QP will be closed.
-	 */
-	if (!mr || !mr->ibmr.pd) {
-		mlx5_ib_dbg(dev, "Failed to find relevant mr for lkey=0x%06x, probably the MR was destroyed\n",
-			    key);
-		ret = -EFAULT;
-		goto srcu_unlock;
-	}
-	if (!mr->umem->odp_data) {
-		mlx5_ib_dbg(dev, "skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
-			    key);
-		if (bytes_mapped)
-			*bytes_mapped +=
-				(bcnt - *bytes_committed);
-		goto srcu_unlock;
-	}
-
-	/*
-	 * Avoid branches - this code will perform correctly
-	 * in all iterations (in iteration 2 and above,
-	 * bytes_committed == 0).
-	 */
-	io_virt += *bytes_committed;
-	bcnt -= *bytes_committed;
+	int ret;
 
 	if (!mr->umem->odp_data->page_list) {
 		odp = implicit_mr_get_data(mr, io_virt, bcnt);
 
-		if (IS_ERR(odp)) {
-			ret = PTR_ERR(odp);
-			goto srcu_unlock;
-		}
+		if (IS_ERR(odp))
+			return PTR_ERR(odp);
 		mr = odp->private;
-		implicit = 1;
 
 	} else {
 		odp = mr->umem->odp_data;
 	}
 
+next_mr:
+	size = min_t(size_t, bcnt, ib_umem_end(odp->umem) - io_virt);
+
 	page_shift = mr->umem->page_shift;
 	page_mask = ~(BIT(page_shift) - 1);
+	start_idx = (io_virt - (mr->mmkey.iova & page_mask)) >> page_shift;
+
+	if (mr->umem->writable)
+		access_mask |= ODP_WRITE_ALLOWED_BIT;
 
-next_mr:
 	current_seq = READ_ONCE(odp->notifiers_seq);
 	/*
 	 * Ensure the sequence number is valid for some time before we call
@@ -593,51 +550,43 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	 */
 	smp_rmb();
 
-	size = min_t(size_t, bcnt, ib_umem_end(odp->umem) - io_virt);
-	start_idx = (io_virt - (mr->mmkey.iova & page_mask)) >> page_shift;
-
-	if (mr->umem->writable)
-		access_mask |= ODP_WRITE_ALLOWED_BIT;
-
 	ret = ib_umem_odp_map_dma_pages(mr->umem, io_virt, size,
 					access_mask, current_seq);
 
 	if (ret < 0)
-		goto srcu_unlock;
+		goto out;
 
-	if (ret > 0) {
-		int np = ret;
-
-		mutex_lock(&odp->umem_mutex);
-		if (!ib_umem_mmu_notifier_retry(mr->umem, current_seq)) {
-			/*
-			 * No need to check whether the MTTs really belong to
-			 * this MR, since ib_umem_odp_map_dma_pages already
-			 * checks this.
-			 */
-			ret = mlx5_ib_update_xlt(mr, start_idx, np,
-						 page_shift,
-						 MLX5_IB_UPD_XLT_ATOMIC);
-		} else {
-			ret = -EAGAIN;
-		}
-		mutex_unlock(&odp->umem_mutex);
-		if (ret < 0) {
-			if (ret != -EAGAIN)
-				mlx5_ib_err(dev, "Failed to update mkey page tables\n");
-			goto srcu_unlock;
-		}
-		if (bytes_mapped) {
-			u32 new_mappings = (np << page_shift) -
-				(io_virt - round_down(io_virt,
-						      1 << page_shift));
-			*bytes_mapped += min_t(u32, new_mappings, size);
-		}
+	np = ret;
 
-		npages += np << (page_shift - PAGE_SHIFT);
+	mutex_lock(&odp->umem_mutex);
+	if (!ib_umem_mmu_notifier_retry(mr->umem, current_seq)) {
+		/*
+		 * No need to check whether the MTTs really belong to
+		 * this MR, since ib_umem_odp_map_dma_pages already
+		 * checks this.
+		 */
+		ret = mlx5_ib_update_xlt(mr, start_idx, np,
+					 page_shift, MLX5_IB_UPD_XLT_ATOMIC);
+	} else {
+		ret = -EAGAIN;
 	}
+	mutex_unlock(&odp->umem_mutex);
 
+	if (ret < 0) {
+		if (ret != -EAGAIN)
+			mlx5_ib_err(dev, "Failed to update mkey page tables\n");
+		goto out;
+	}
+
+	if (bytes_mapped) {
+		u32 new_mappings = (np << page_shift) -
+			(io_virt - round_down(io_virt, 1 << page_shift));
+		*bytes_mapped += min_t(u32, new_mappings, size);
+	}
+
+	npages += np << (page_shift - PAGE_SHIFT);
 	bcnt -= size;
+
 	if (unlikely(bcnt)) {
 		struct ib_umem_odp *next;
 
@@ -646,17 +595,18 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		if (unlikely(!next || next->umem->address != io_virt)) {
 			mlx5_ib_dbg(dev, "next implicit leaf removed at 0x%llx. got %p\n",
 				    io_virt, next);
-			ret = -EAGAIN;
-			goto srcu_unlock_no_wait;
+			return -EAGAIN;
 		}
 		odp = next;
 		mr = odp->private;
 		goto next_mr;
 	}
 
-srcu_unlock:
+	return npages;
+
+out:
 	if (ret == -EAGAIN) {
-		if (implicit || !odp->dying) {
+		if (mr->parent || !odp->dying) {
 			unsigned long timeout =
 				msecs_to_jiffies(MMU_NOTIFIER_TIMEOUT);
 
@@ -672,7 +622,62 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		}
 	}
 
-srcu_unlock_no_wait:
+	return ret;
+}
+
+/*
+ * Handle a single data segment in a page-fault WQE or RDMA region.
+ *
+ * Returns number of OS pages retrieved on success. The caller may continue to
+ * the next data segment.
+ * Can return the following error codes:
+ * -EAGAIN to designate a temporary error. The caller will abort handling the
+ *  page fault and resolve it.
+ * -EFAULT when there's an error mapping the requested pages. The caller will
+ *  abort the page fault handling.
+ */
+static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
+					 u32 key, u64 io_virt, size_t bcnt,
+					 u32 *bytes_committed,
+					 u32 *bytes_mapped)
+{
+	int npages = 0, srcu_key, ret;
+	struct mlx5_ib_mr *mr;
+	size_t size;
+
+	srcu_key = srcu_read_lock(&dev->mr_srcu);
+	mr = mlx5_ib_odp_find_mr_lkey(dev, key);
+	/*
+	 * If we didn't find the MR, it means the MR was closed while we were
+	 * handling the ODP event. In this case we return -EFAULT so that the
+	 * QP will be closed.
+	 */
+	if (!mr || !mr->ibmr.pd) {
+		mlx5_ib_dbg(dev, "Failed to find relevant mr for lkey=0x%06x, probably the MR was destroyed\n",
+			    key);
+		ret = -EFAULT;
+		goto srcu_unlock;
+	}
+	if (!mr->umem->odp_data) {
+		mlx5_ib_dbg(dev, "skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
+			    key);
+		if (bytes_mapped)
+			*bytes_mapped +=
+				(bcnt - *bytes_committed);
+		goto srcu_unlock;
+	}
+
+	/*
+	 * Avoid branches - this code will perform correctly
+	 * in all iterations (in iteration 2 and above,
+	 * bytes_committed == 0).
+	 */
+	io_virt += *bytes_committed;
+	bcnt -= *bytes_committed;
+
+	npages = pagefault_mr(dev, mr, io_virt, size, bytes_mapped);
+
+srcu_unlock:
 	srcu_read_unlock(&dev->mr_srcu, srcu_key);
 	*bytes_committed = 0;
 	return ret ? ret : npages;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
