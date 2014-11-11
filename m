From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 01/17] IB/mlx5: Remove per-MR pas and dma pointers
Date: Tue, 11 Nov 2014 18:36:07 +0200
Message-ID: <1415723783-2138-2-git-send-email-haggaie@mellanox.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since UMR code now uses its own context struct on the stack, the pas and dma
pointers for the UMR operation that remained in the mlx5_ib_mr struct are not
necessary.  This patch removes them.

Fixes: a74d24168d2d ("IB/mlx5: Refactor UMR to have its own context struct")
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 --
 drivers/infiniband/hw/mlx5/mr.c      | 21 ++++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 386780f0d1e1..29da55222070 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -261,8 +261,6 @@ struct mlx5_ib_mr {
 	struct list_head	list;
 	int			order;
 	int			umred;
-	__be64			*pas;
-	dma_addr_t		dma;
 	int			npages;
 	struct mlx5_ib_dev     *dev;
 	struct mlx5_create_mkey_mbox_out out;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8ee7cb46e059..610500810f75 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -740,6 +740,8 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	struct mlx5_ib_mr *mr;
 	struct ib_sge sg;
 	int size = sizeof(u64) * npages;
+	__be64 *mr_pas;
+	dma_addr_t dma;
 	int err = 0;
 	int i;
 
@@ -758,25 +760,26 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	if (!mr)
 		return ERR_PTR(-EAGAIN);
 
-	mr->pas = kmalloc(size + MLX5_UMR_ALIGN - 1, GFP_KERNEL);
-	if (!mr->pas) {
+	mr_pas = kmalloc(size + MLX5_UMR_ALIGN - 1, GFP_KERNEL);
+	if (!mr_pas) {
 		err = -ENOMEM;
 		goto free_mr;
 	}
 
 	mlx5_ib_populate_pas(dev, umem, page_shift,
-			     mr_align(mr->pas, MLX5_UMR_ALIGN), 1);
+			     mr_align(mr_pas, MLX5_UMR_ALIGN), 1);
 
-	mr->dma = dma_map_single(ddev, mr_align(mr->pas, MLX5_UMR_ALIGN), size,
-				 DMA_TO_DEVICE);
-	if (dma_mapping_error(ddev, mr->dma)) {
+	dma = dma_map_single(ddev, mr_align(mr_pas, MLX5_UMR_ALIGN), size,
+			     DMA_TO_DEVICE);
+	if (dma_mapping_error(ddev, dma)) {
 		err = -ENOMEM;
 		goto free_pas;
 	}
 
 	memset(&wr, 0, sizeof(wr));
 	wr.wr_id = (u64)(unsigned long)&umr_context;
-	prep_umr_reg_wqe(pd, &wr, &sg, mr->dma, npages, mr->mmr.key, page_shift, virt_addr, len, access_flags);
+	prep_umr_reg_wqe(pd, &wr, &sg, dma, npages, mr->mmr.key, page_shift,
+			 virt_addr, len, access_flags);
 
 	mlx5_ib_init_umr_context(&umr_context);
 	down(&umrc->sem);
@@ -798,10 +801,10 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 
 unmap_dma:
 	up(&umrc->sem);
-	dma_unmap_single(ddev, mr->dma, size, DMA_TO_DEVICE);
+	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 
 free_pas:
-	kfree(mr->pas);
+	kfree(mr_pas);
 
 free_mr:
 	if (err) {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
