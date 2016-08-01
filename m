From: Haggai Eran <haggaie@mellanox.com>
Subject: [RFC 1/7] IB/mlx5: Helper for posting work-requests on the UMR QP
Date: Mon,  1 Aug 2016 09:57:27 +0300
Message-ID: <1470034653-9097-2-git-send-email-haggaie@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: linux-pci@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Liran Liss <liranl@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Add mlx5_ib_post_umr_sync(), a helper function that posts work-requests
on the UMR QP, waits for their completion, and returns the result.
Modify several functions to use the new helper.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 98 ++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8cf2ce50511f..fb2bb25c6cf0 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -852,16 +852,41 @@ static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
 	init_completion(&context->done);
 }
 
+static int mlx5_ib_post_umr_sync(struct mlx5_ib_dev *dev, struct ib_send_wr *wr)
+{
+	struct umr_common *umrc = &dev->umrc;
+	struct mlx5_ib_umr_context umr_context;
+	struct ib_send_wr *bad;
+	int err;
+
+	mlx5_ib_init_umr_context(&umr_context);
+	wr->wr_cqe = &umr_context.cqe;
+
+	down(&umrc->sem);
+	err = ib_post_send(umrc->qp, wr, &bad);
+	if (err) {
+		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
+		goto out;
+	} else {
+		wait_for_completion(&umr_context.done);
+		if (umr_context.status != IB_WC_SUCCESS) {
+			mlx5_ib_warn(dev, "umr failed\n");
+			err = -EFAULT;
+			goto out;
+		}
+	}
+out:
+	up(&umrc->sem);
+	return err;
+}
+
 static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 				  u64 virt_addr, u64 len, int npages,
 				  int page_shift, int order, int access_flags)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct device *ddev = dev->ib_dev.dma_device;
-	struct umr_common *umrc = &dev->umrc;
-	struct mlx5_ib_umr_context umr_context;
 	struct mlx5_umr_wr umrwr = {};
-	struct ib_send_wr *bad;
 	struct mlx5_ib_mr *mr;
 	struct ib_sge sg;
 	int size;
@@ -890,24 +915,12 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	if (err)
 		goto free_mr;
 
-	mlx5_ib_init_umr_context(&umr_context);
-
-	umrwr.wr.wr_cqe = &umr_context.cqe;
 	prep_umr_reg_wqe(pd, &umrwr.wr, &sg, dma, npages, mr->mmkey.key,
 			 page_shift, virt_addr, len, access_flags);
 
-	down(&umrc->sem);
-	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
-	if (err) {
-		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
+	err = mlx5_ib_post_umr_sync(dev, &umrwr.wr);
+	if (err)
 		goto unmap_dma;
-	} else {
-		wait_for_completion(&umr_context.done);
-		if (umr_context.status != IB_WC_SUCCESS) {
-			mlx5_ib_warn(dev, "reg umr failed\n");
-			err = -EFAULT;
-		}
-	}
 
 	mr->mmkey.iova = virt_addr;
 	mr->mmkey.size = len;
@@ -916,7 +929,6 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	mr->live = 1;
 
 unmap_dma:
-	up(&umrc->sem);
 	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 
 	kfree(mr_pas);
@@ -1193,36 +1205,10 @@ error:
 
 static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
-	struct umr_common *umrc = &dev->umrc;
-	struct mlx5_ib_umr_context umr_context;
 	struct mlx5_umr_wr umrwr = {};
-	struct ib_send_wr *bad;
-	int err;
-
-	mlx5_ib_init_umr_context(&umr_context);
 
-	umrwr.wr.wr_cqe = &umr_context.cqe;
 	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmkey.key);
-
-	down(&umrc->sem);
-	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
-	if (err) {
-		up(&umrc->sem);
-		mlx5_ib_dbg(dev, "err %d\n", err);
-		goto error;
-	} else {
-		wait_for_completion(&umr_context.done);
-		up(&umrc->sem);
-	}
-	if (umr_context.status != IB_WC_SUCCESS) {
-		mlx5_ib_warn(dev, "unreg umr failed\n");
-		err = -EFAULT;
-		goto error;
-	}
-	return 0;
-
-error:
-	return err;
+	return mlx5_ib_post_umr_sync(dev, &umrwr.wr);
 }
 
 static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
@@ -1231,19 +1217,13 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct device *ddev = dev->ib_dev.dma_device;
-	struct mlx5_ib_umr_context umr_context;
-	struct ib_send_wr *bad;
 	struct mlx5_umr_wr umrwr = {};
 	struct ib_sge sg;
-	struct umr_common *umrc = &dev->umrc;
 	dma_addr_t dma = 0;
 	__be64 *mr_pas = NULL;
 	int size;
 	int err;
 
-	mlx5_ib_init_umr_context(&umr_context);
-
-	umrwr.wr.wr_cqe = &umr_context.cqe;
 	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_FAIL_IF_FREE;
 
 	if (flags & IB_MR_REREG_TRANS) {
@@ -1271,21 +1251,7 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
 	}
 
 	/* post send request to UMR QP */
-	down(&umrc->sem);
-	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
-
-	if (err) {
-		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
-	} else {
-		wait_for_completion(&umr_context.done);
-		if (umr_context.status != IB_WC_SUCCESS) {
-			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
-				     umr_context.status);
-			err = -EFAULT;
-		}
-	}
-
-	up(&umrc->sem);
+	err = mlx5_ib_post_umr_sync(dev, &umrwr.wr);
 	if (flags & IB_MR_REREG_TRANS) {
 		dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 		kfree(mr_pas);
-- 
1.7.11.2
