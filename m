From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 11/20] IB/mlx5: Refactor UMR to have its own context struct
Date: Sun,  2 Mar 2014 12:49:29 +0200
Message-ID: <1393757378-16412-12-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Instead of having the UMR context part of each memory region,
allocate a struct on the stack. This allows queuing multiple UMRs that access
the same memory region.

Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 13 ++++++++++--
 drivers/infiniband/hw/mlx5/mr.c      | 40 ++++++++++++++++++------------------
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index afe39e7..29f58c1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -279,8 +279,6 @@ struct mlx5_ib_mr {
 	__be64			*pas;
 	dma_addr_t		dma;
 	int			npages;
-	struct completion	done;
-	enum ib_wc_status	status;
 	struct mlx5_ib_dev     *dev;
 	struct mlx5_create_mkey_mbox_out out;
 	struct mlx5_core_sig_ctx    *sig;
@@ -292,6 +290,17 @@ struct mlx5_ib_fast_reg_page_list {
 	dma_addr_t			map;
 };
 
+struct mlx5_ib_umr_context {
+	enum ib_wc_status	status;
+	struct completion	done;
+};
+
+static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
+{
+	context->status = -1;
+	init_completion(&context->done);
+}
+
 struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index dd6a4bb..fa0bcd6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -712,7 +712,7 @@ static void prep_umr_unreg_wqe(struct mlx5_ib_dev *dev,
 
 void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context)
 {
-	struct mlx5_ib_mr *mr;
+	struct mlx5_ib_umr_context *context;
 	struct ib_wc wc;
 	int err;
 
@@ -725,9 +725,9 @@ void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context)
 		if (err == 0)
 			break;
 
-		mr = (struct mlx5_ib_mr *)(unsigned long)wc.wr_id;
-		mr->status = wc.status;
-		complete(&mr->done);
+		context = (struct mlx5_ib_umr_context *)wc.wr_id;
+		context->status = wc.status;
+		complete(&context->done);
 	}
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 }
@@ -739,6 +739,7 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct device *ddev = dev->ib_dev.dma_device;
 	struct umr_common *umrc = &dev->umrc;
+	struct mlx5_ib_umr_context umr_context;
 	struct ib_send_wr wr, *bad;
 	struct mlx5_ib_mr *mr;
 	struct ib_sge sg;
@@ -778,24 +779,21 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 	}
 
 	memset(&wr, 0, sizeof(wr));
-	wr.wr_id = (u64)(unsigned long)mr;
+	wr.wr_id = (u64)(unsigned long)&umr_context;
 	prep_umr_reg_wqe(pd, &wr, &sg, mr->dma, npages, mr->mmr.key, page_shift, virt_addr, len, access_flags);
 
-	/* We serialize polls so one process does not kidnap another's
-	 * completion. This is not a problem since wr is completed in
-	 * around 1 usec
-	 */
+	mlx5_ib_init_umr_context(&umr_context);
 	down(&umrc->sem);
-	init_completion(&mr->done);
 	err = ib_post_send(umrc->qp, &wr, &bad);
 	if (err) {
 		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
 		goto unmap_dma;
-	}
-	wait_for_completion(&mr->done);
-	if (mr->status != IB_WC_SUCCESS) {
-		mlx5_ib_warn(dev, "reg umr failed\n");
-		err = -EFAULT;
+	} else {
+		wait_for_completion(&umr_context.done);
+		if (umr_context.status != IB_WC_SUCCESS) {
+			mlx5_ib_warn(dev, "reg umr failed\n");
+			err = -EFAULT;
+		}
 	}
 
 	mr->mmr.iova = virt_addr;
@@ -944,24 +942,26 @@ error:
 static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct umr_common *umrc = &dev->umrc;
+	struct mlx5_ib_umr_context umr_context;
 	struct ib_send_wr wr, *bad;
 	int err;
 
 	memset(&wr, 0, sizeof(wr));
-	wr.wr_id = (u64)(unsigned long)mr;
+	wr.wr_id = (u64)(unsigned long)&umr_context;
 	prep_umr_unreg_wqe(dev, &wr, mr->mmr.key);
 
+	mlx5_ib_init_umr_context(&umr_context);
 	down(&umrc->sem);
-	init_completion(&mr->done);
 	err = ib_post_send(umrc->qp, &wr, &bad);
 	if (err) {
 		up(&umrc->sem);
 		mlx5_ib_dbg(dev, "err %d\n", err);
 		goto error;
+	} else {
+		wait_for_completion(&umr_context.done);
+		up(&umrc->sem);
 	}
-	wait_for_completion(&mr->done);
-	up(&umrc->sem);
-	if (mr->status != IB_WC_SUCCESS) {
+	if (umr_context.status != IB_WC_SUCCESS) {
 		mlx5_ib_warn(dev, "unreg umr failed\n");
 		err = -EFAULT;
 		goto error;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
