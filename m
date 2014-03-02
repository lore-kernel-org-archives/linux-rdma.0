From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 06/20] IB/mlx5: Fix error handling in reg_umr
Date: Sun,  2 Mar 2014 12:49:24 +0200
Message-ID: <1393757378-16412-7-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If ib_post_send fails when posting the UMR work request in reg_umr, the code
doesn't release the temporary pas buffer allocated, and doesn't dma_unmap it.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 43fb96d..24a68aa 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -730,7 +730,7 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	struct mlx5_ib_mr *mr;
 	struct ib_sge sg;
 	int size = sizeof(u64) * npages;
-	int err;
+	int err = 0;
 	int i;
 
 	for (i = 0; i < 1; i++) {
@@ -751,7 +751,7 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	mr->pas = kmalloc(size + MLX5_UMR_ALIGN - 1, GFP_KERNEL);
 	if (!mr->pas) {
 		err = -ENOMEM;
-		goto error;
+		goto free_mr;
 	}
 
 	mlx5_ib_populate_pas(dev, umem, page_shift,
@@ -760,9 +760,8 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	mr->dma = dma_map_single(ddev, mr_align(mr->pas, MLX5_UMR_ALIGN), size,
 				 DMA_TO_DEVICE);
 	if (dma_mapping_error(ddev, mr->dma)) {
-		kfree(mr->pas);
 		err = -ENOMEM;
-		goto error;
+		goto free_pas;
 	}
 
 	memset(&wr, 0, sizeof(wr));
@@ -778,26 +777,28 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	err = ib_post_send(umrc->qp, &wr, &bad);
 	if (err) {
 		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
-		up(&umrc->sem);
-		goto error;
+		goto unmap_dma;
 	}
 	wait_for_completion(&mr->done);
-	up(&umrc->sem);
+	if (mr->status != IB_WC_SUCCESS) {
+		mlx5_ib_warn(dev, "reg umr failed\n");
+		err = -EFAULT;
+	}
 
+unmap_dma:
+	up(&umrc->sem);
 	dma_unmap_single(ddev, mr->dma, size, DMA_TO_DEVICE);
+
+free_pas:
 	kfree(mr->pas);
 
-	if (mr->status != IB_WC_SUCCESS) {
-		mlx5_ib_warn(dev, "reg umr failed\n");
-		err = -EFAULT;
-		goto error;
+free_mr:
+	if (err) {
+		free_cached_mr(dev, mr);
+		return ERR_PTR(err);
 	}
 
 	return mr;
-
-error:
-	free_cached_mr(dev, mr);
-	return ERR_PTR(err);
 }
 
 static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, u64 virt_addr,
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
