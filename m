From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 13/17] IB/mlx5: Add mlx5_ib_update_mtt to update page tables after creation
Date: Tue, 11 Nov 2014 18:36:19 +0200
Message-ID: <1415723783-2138-14-git-send-email-haggaie@mellanox.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new function allows updating the page tables of a memory region after it
was created. This can be used to handle page faults and page invalidations.

Since mlx5_ib_update_mtt will need to work from within page invalidation, so
it must not block on memory allocation. It employs an atomic memory allocation
mechanism that is used as a fallback when kmalloc(GFP_ATOMIC) fails.

In order to reuse code from mlx5_ib_populate_pas, the patch splits this
function and add the needed parameters.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mem.c     |  19 +++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   5 ++
 drivers/infiniband/hw/mlx5/mr.c      | 132 ++++++++++++++++++++++++++++++++++-
 include/linux/mlx5/device.h          |   1 +
 4 files changed, 149 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 5f7b30147180..b56e4c5593ee 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -140,12 +140,16 @@ static u64 umem_dma_to_mtt(dma_addr_t umem_dma)
  * dev - mlx5_ib device
  * umem - umem to use to fill the pages
  * page_shift - determines the page size used in the resulting array
+ * offset - offset into the umem to start from,
+ *          only implemented for ODP umems
+ * num_pages - total number of pages to fill
  * pas - bus addresses array to fill
  * access_flags - access flags to set on all present pages.
 		  use enum mlx5_ib_mtt_access_flags for this.
  */
-void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
-			  int page_shift, __be64 *pas, int access_flags)
+void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+			    int page_shift, size_t offset, size_t num_pages,
+			    __be64 *pas, int access_flags)
 {
 	unsigned long umem_page_shift = ilog2(umem->page_size);
 	int shift = page_shift - umem_page_shift;
@@ -160,13 +164,11 @@ void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 	const bool odp = umem->odp_data != NULL;
 
 	if (odp) {
-		int num_pages = ib_umem_num_pages(umem);
-
 		WARN_ON(shift != 0);
 		WARN_ON(access_flags != (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE));
 
 		for (i = 0; i < num_pages; ++i) {
-			dma_addr_t pa = umem->odp_data->dma_list[i];
+			dma_addr_t pa = umem->odp_data->dma_list[offset + i];
 
 			pas[i] = cpu_to_be64(umem_dma_to_mtt(pa));
 		}
@@ -194,6 +196,13 @@ void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 	}
 }
 
+void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+			  int page_shift, __be64 *pas, int access_flags)
+{
+	return __mlx5_ib_populate_pas(dev, umem, page_shift, 0,
+				      ib_umem_num_pages(umem), pas,
+				      access_flags);
+}
 int mlx5_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset)
 {
 	u64 page_size;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 83c1690e9dd0..6856e27bfb6a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -527,6 +527,8 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc);
 struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata);
+int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index,
+		       int npages, int zap);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 int mlx5_ib_destroy_mr(struct ib_mr *ibmr);
 struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
@@ -558,6 +560,9 @@ int mlx5_ib_init_fmr(struct mlx5_ib_dev *dev);
 void mlx5_ib_cleanup_fmr(struct mlx5_ib_dev *dev);
 void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 			int *ncont, int *order);
+void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+			    int page_shift, size_t offset, size_t num_pages,
+			    __be64 *pas, int access_flags);
 void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 			  int page_shift, __be64 *pas, int access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fcd531e0758b..e9675325af41 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -44,9 +44,13 @@ enum {
 	MAX_PENDING_REG_MR = 8,
 };
 
-enum {
-	MLX5_UMR_ALIGN	= 2048
-};
+#define MLX5_UMR_ALIGN 2048
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+static __be64 mlx5_ib_update_mtt_emergency_buffer[
+		MLX5_UMR_MTT_MIN_CHUNK_SIZE/sizeof(__be64)]
+	__aligned(MLX5_UMR_ALIGN);
+static DEFINE_MUTEX(mlx5_ib_update_mtt_emergency_buffer_mutex);
+#endif
 
 static int order2idx(struct mlx5_ib_dev *dev, int order)
 {
@@ -819,6 +823,128 @@ free_mr:
 	return mr;
 }
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
+		       int zap)
+{
+	struct mlx5_ib_dev *dev = mr->dev;
+	struct device *ddev = dev->ib_dev.dma_device;
+	struct umr_common *umrc = &dev->umrc;
+	struct mlx5_ib_umr_context umr_context;
+	struct ib_umem *umem = mr->umem;
+	int size;
+	__be64 *pas;
+	dma_addr_t dma;
+	struct ib_send_wr wr, *bad;
+	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr.wr.fast_reg;
+	struct ib_sge sg;
+	int err = 0;
+	const int page_index_alignment = MLX5_UMR_MTT_ALIGNMENT / sizeof(u64);
+	const int page_index_mask = page_index_alignment - 1;
+	size_t pages_mapped = 0;
+	size_t pages_to_map = 0;
+	size_t pages_iter = 0;
+	int use_emergency_buf = 0;
+
+	/* UMR copies MTTs in units of MLX5_UMR_MTT_ALIGNMENT bytes,
+	 * so we need to align the offset and length accordingly */
+	if (start_page_index & page_index_mask) {
+		npages += start_page_index & page_index_mask;
+		start_page_index &= ~page_index_mask;
+	}
+
+	pages_to_map = ALIGN(npages, page_index_alignment);
+
+	if (start_page_index + pages_to_map > MLX5_MAX_UMR_PAGES)
+		return -EINVAL;
+
+	size = sizeof(u64) * pages_to_map;
+	size = min_t(int, PAGE_SIZE, size);
+	/* We allocate with GFP_ATOMIC to avoid recursion into page-reclaim
+	 * code, when we are called from an invalidation. The pas buffer must
+	 * be 2k-aligned for Connect-IB. */
+	pas = (__be64 *)get_zeroed_page(GFP_ATOMIC);
+	if (!pas) {
+		mlx5_ib_warn(dev, "unable to allocate memory during MTT update, falling back to slower chunked mechanism.\n");
+		pas = mlx5_ib_update_mtt_emergency_buffer;
+		size = MLX5_UMR_MTT_MIN_CHUNK_SIZE;
+		use_emergency_buf = 1;
+		mutex_lock(&mlx5_ib_update_mtt_emergency_buffer_mutex);
+		memset(pas, 0, size);
+	}
+	pages_iter = size / sizeof(u64);
+	dma = dma_map_single(ddev, pas, size, DMA_TO_DEVICE);
+	if (dma_mapping_error(ddev, dma)) {
+		mlx5_ib_err(dev, "unable to map DMA during MTT update.\n");
+		err = -ENOMEM;
+		goto free_pas;
+	}
+
+	for (pages_mapped = 0;
+	     pages_mapped < pages_to_map && !err;
+	     pages_mapped += pages_iter, start_page_index += pages_iter) {
+		dma_sync_single_for_cpu(ddev, dma, size, DMA_TO_DEVICE);
+
+		npages = min_t(size_t,
+			       pages_iter,
+			       ib_umem_num_pages(umem) - start_page_index);
+
+		if (!zap) {
+			__mlx5_ib_populate_pas(dev, umem, PAGE_SHIFT,
+					       start_page_index, npages, pas,
+					       MLX5_IB_MTT_PRESENT);
+			/* Clear padding after the pages brought from the
+			 * umem. */
+			memset(pas + npages, 0, size - npages * sizeof(u64));
+		}
+
+		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);
+
+		memset(&wr, 0, sizeof(wr));
+		wr.wr_id = (u64)(unsigned long)&umr_context;
+
+		sg.addr = dma;
+		sg.length = ALIGN(npages * sizeof(u64),
+				MLX5_UMR_MTT_ALIGNMENT);
+		sg.lkey = dev->umrc.mr->lkey;
+
+		wr.send_flags = MLX5_IB_SEND_UMR_FAIL_IF_FREE |
+				MLX5_IB_SEND_UMR_UPDATE_MTT;
+		wr.sg_list = &sg;
+		wr.num_sge = 1;
+		wr.opcode = MLX5_IB_WR_UMR;
+		umrwr->npages = sg.length / sizeof(u64);
+		umrwr->page_shift = PAGE_SHIFT;
+		umrwr->mkey = mr->mmr.key;
+		umrwr->target.offset = start_page_index;
+
+		mlx5_ib_init_umr_context(&umr_context);
+		down(&umrc->sem);
+		err = ib_post_send(umrc->qp, &wr, &bad);
+		if (err) {
+			mlx5_ib_err(dev, "UMR post send failed, err %d\n", err);
+		} else {
+			wait_for_completion(&umr_context.done);
+			if (umr_context.status != IB_WC_SUCCESS) {
+				mlx5_ib_err(dev, "UMR completion failed, code %d\n",
+					    umr_context.status);
+				err = -EFAULT;
+			}
+		}
+		up(&umrc->sem);
+	}
+	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
+
+free_pas:
+	if (!use_emergency_buf)
+		free_page((unsigned long)pas);
+	else
+		mutex_unlock(&mlx5_ib_update_mtt_emergency_buffer_mutex);
+
+	return err;
+}
+#endif
+
 static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, u64 virt_addr,
 				     u64 length, struct ib_umem *umem,
 				     int npages, int page_shift,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index c56b108a3cde..321957d0dcfe 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -200,6 +200,7 @@ enum {
 
 #define MLX5_UMR_MTT_ALIGNMENT 0x40
 #define MLX5_UMR_MTT_MASK      (MLX5_UMR_MTT_ALIGNMENT - 1)
+#define MLX5_UMR_MTT_MIN_CHUNK_SIZE MLX5_UMR_MTT_ALIGNMENT
 
 enum mlx5_event {
 	MLX5_EVENT_TYPE_COMP		   = 0x0,
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
