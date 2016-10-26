From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 8/9] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Wed, 26 Oct 2016 13:31:13 +0530
Message-ID: <1477468874-16328-9-git-send-email-binoy.jayan@linaro.org>
References: <1477468874-16328-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477468874-16328-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clean up the following common code (to post a list of work requests to the
send queue of the specified QP) at various places and add a helper function
'mlx5_ib_post_send_wait' to implement the same.

 - Initialize 'mlx5_ib_umr_context' on stack
 - Assign "mlx5_umr_wr:wr:wr_cqe to umr_context.cqe
 - Acquire the semaphore
 - call ib_post_send with a single ib_send_wr
 - wait_for_completion()
 - Check for umr_context.status
 - Release the semaphore

As semaphores are going away in the future, moving all of these into the
shared helper leaves only a single function using the semaphore, which
can then be rewritten to use something else.

Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 115 +++++++++++-----------------------------
 1 file changed, 32 insertions(+), 83 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d4ad672..19c292a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -856,16 +856,40 @@ static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
 	init_completion(&context->done);
 }
 
+static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
+					 struct mlx5_umr_wr *umrwr)
+{
+	struct umr_common *umrc = &dev->umrc;
+	struct ib_send_wr *bad;
+	int err;
+	struct mlx5_ib_umr_context umr_context;
+
+	mlx5_ib_init_umr_context(&umr_context);
+	umrwr->wr.wr_cqe = &umr_context.cqe;
+
+	down(&umrc->sem);
+	err = ib_post_send(umrc->qp, &umrwr->wr, &bad);
+	if (err) {
+		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
+	} else {
+		wait_for_completion(&umr_context.done);
+		if (umr_context.status != IB_WC_SUCCESS) {
+			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
+				     umr_context.status);
+			err = -EFAULT;
+		}
+	}
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
@@ -894,24 +918,12 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
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
+	err = mlx5_ib_post_send_wait(dev, &umrwr);
+	if (err != -EFAULT)
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
@@ -920,7 +932,6 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	mr->live = 1;
 
 unmap_dma:
-	up(&umrc->sem);
 	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 
 	kfree(mr_pas);
@@ -940,13 +951,10 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 {
 	struct mlx5_ib_dev *dev = mr->dev;
 	struct device *ddev = dev->ib_dev.dma_device;
-	struct umr_common *umrc = &dev->umrc;
-	struct mlx5_ib_umr_context umr_context;
 	struct ib_umem *umem = mr->umem;
 	int size;
 	__be64 *pas;
 	dma_addr_t dma;
-	struct ib_send_wr *bad;
 	struct mlx5_umr_wr wr;
 	struct ib_sge sg;
 	int err = 0;
@@ -1011,10 +1019,7 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 
 		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);
 
-		mlx5_ib_init_umr_context(&umr_context);
-
 		memset(&wr, 0, sizeof(wr));
-		wr.wr.wr_cqe = &umr_context.cqe;
 
 		sg.addr = dma;
 		sg.length = ALIGN(npages * sizeof(u64),
@@ -1031,19 +1036,7 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 		wr.mkey = mr->mmkey.key;
 		wr.target.offset = start_page_index;
 
-		down(&umrc->sem);
-		err = ib_post_send(umrc->qp, &wr.wr, &bad);
-		if (err) {
-			mlx5_ib_err(dev, "UMR post send failed, err %d\n", err);
-		} else {
-			wait_for_completion(&umr_context.done);
-			if (umr_context.status != IB_WC_SUCCESS) {
-				mlx5_ib_err(dev, "UMR completion failed, code %d\n",
-					    umr_context.status);
-				err = -EFAULT;
-			}
-		}
-		up(&umrc->sem);
+		err = mlx5_ib_post_send_wait(dev, &wr);
 	}
 	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 
@@ -1210,39 +1203,14 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
-	struct umr_common *umrc = &dev->umrc;
-	struct mlx5_ib_umr_context umr_context;
 	struct mlx5_umr_wr umrwr = {};
-	struct ib_send_wr *bad;
-	int err;
 
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
-	mlx5_ib_init_umr_context(&umr_context);
-
-	umrwr.wr.wr_cqe = &umr_context.cqe;
 	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmkey.key);
 
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
+	return mlx5_ib_post_send_wait(dev, &umrwr);
 }
 
 static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
@@ -1251,19 +1219,13 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
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
@@ -1291,21 +1253,8 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
 	}
 
 	/* post send request to UMR QP */
-	down(&umrc->sem);
-	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
+	err = mlx5_ib_post_send_wait(dev, &umrwr);
 
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
 	if (flags & IB_MR_REREG_TRANS) {
 		dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 		kfree(mr_pas);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
