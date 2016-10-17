From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 8/8] IB/mlx5: Replace counting semaphore sem with wait condition
Date: Mon, 17 Oct 2016 22:01:02 +0530
Message-ID: <1476721862-7070-9-git-send-email-binoy.jayan@linaro.org>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Counting semaphores are going away in the future, so replace the semaphore
umr_common::sem with an open-coded implementation.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  3 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 ++-
 drivers/infiniband/hw/mlx5/mr.c      | 28 +++++++++++++++++++---------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2217477..5667ea8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2520,7 +2520,8 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	dev->umrc.cq = cq;
 	dev->umrc.pd = pd;
 
-	sema_init(&dev->umrc.sem, MAX_UMR_WR);
+	init_waitqueue_head(&dev->umrc.sem.wq);
+	atomic_set(&dev->umrc.sem.count, MAX_UMR_WR);
 	ret = mlx5_mr_cache_init(dev);
 	if (ret) {
 		mlx5_ib_warn(dev, "mr cache init failed %d\n", ret);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dcdcd19..60e2d29 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -45,6 +45,7 @@
 #include <linux/mlx5/transobj.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/mlx5-abi.h>
+#include <rdma/ib_sa.h>
 
 #define mlx5_ib_dbg(dev, format, arg...)				\
 pr_debug("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
@@ -533,7 +534,7 @@ struct umr_common {
 	struct ib_qp	*qp;
 	/* control access to UMR QP
 	 */
-	struct semaphore	sem;
+	struct ib_semaphore	sem;
 };
 
 enum {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d4ad672..7c2af26 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -900,7 +900,9 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	prep_umr_reg_wqe(pd, &umrwr.wr, &sg, dma, npages, mr->mmkey.key,
 			 page_shift, virt_addr, len, access_flags);
 
-	down(&umrc->sem);
+	wait_event(umrc->sem.wq,
+		   atomic_add_unless(&umrc->sem.count, -1, 0));
+
 	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
 	if (err) {
 		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
@@ -920,7 +922,8 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	mr->live = 1;
 
 unmap_dma:
-	up(&umrc->sem);
+	if (atomic_inc_return(&umrc->sem.count) == 1)
+		wake_up(&umrc->sem.wq);
 	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 
 	kfree(mr_pas);
@@ -1031,7 +1034,8 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 		wr.mkey = mr->mmkey.key;
 		wr.target.offset = start_page_index;
 
-		down(&umrc->sem);
+		wait_event(umrc->sem.wq,
+			   atomic_add_unless(&umrc->sem.count, -1, 0));
 		err = ib_post_send(umrc->qp, &wr.wr, &bad);
 		if (err) {
 			mlx5_ib_err(dev, "UMR post send failed, err %d\n", err);
@@ -1043,7 +1047,8 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 				err = -EFAULT;
 			}
 		}
-		up(&umrc->sem);
+		if (atomic_inc_return(&umrc->sem.count) == 1)
+			wake_up(&umrc->sem.wq);
 	}
 	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 
@@ -1224,15 +1229,18 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	umrwr.wr.wr_cqe = &umr_context.cqe;
 	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmkey.key);
 
-	down(&umrc->sem);
+	wait_event(umrc->sem.wq,
+		   atomic_add_unless(&umrc->sem.count, -1, 0));
 	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
 	if (err) {
-		up(&umrc->sem);
+		if (atomic_inc_return(&umrc->sem.count) == 1)
+			wake_up(&umrc->sem.wq);
 		mlx5_ib_dbg(dev, "err %d\n", err);
 		goto error;
 	} else {
 		wait_for_completion(&umr_context.done);
-		up(&umrc->sem);
+		if (atomic_inc_return(&umrc->sem.count) == 1)
+			wake_up(&umrc->sem.wq);
 	}
 	if (umr_context.status != IB_WC_SUCCESS) {
 		mlx5_ib_warn(dev, "unreg umr failed\n");
@@ -1291,7 +1299,8 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
 	}
 
 	/* post send request to UMR QP */
-	down(&umrc->sem);
+	wait_event(umrc->sem.wq,
+		   atomic_add_unless(&umrc->sem.count, -1, 0));
 	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
 
 	if (err) {
@@ -1305,7 +1314,8 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
 		}
 	}
 
-	up(&umrc->sem);
+	if (atomic_inc_return(&umrc->sem.count) == 1)
+		wake_up(&umrc->sem.wq);
 	if (flags & IB_MR_REREG_TRANS) {
 		dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
 		kfree(mr_pas);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
