From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Convert UMR CQ to new CQ API
Date: Thu, 3 Mar 2016 09:38:22 +0100
Message-ID: <20160303083822.GB13828@lst.de>
References: <1456565984-28998-1-git-send-email-hch@lst.de> <1456565984-28998-2-git-send-email-hch@lst.de> <56D2D731.5060904@dev.mellanox.co.il> <56D3F1EA.9090800@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D3F1EA.9090800-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks for the review Haggai.  I noticed I left a stray
ib_req_notify_cq in the code, which is harmless but not needed with
the new API.  Patch with that one line updated below.

Doug, can you picks this up for the mlx5 branch?

---
>From 0a24d6471d0d0f2d77120d502aa9b9384abecd28 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Date: Sat, 27 Feb 2016 10:37:20 +0100
Subject: IB/mlx5: Convert UMR CQ to new CQ API

Simplifies the code, and makes it more fair vs other users by using a
softirq for polling.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 10 +++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  8 +------
 drivers/infiniband/hw/mlx5/mr.c      | 43 +++++++++++++++++-------------------
 3 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 03c418c..97eb594 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1838,7 +1838,7 @@ static void destroy_umrc_res(struct mlx5_ib_dev *dev)
 		mlx5_ib_warn(dev, "mr cache cleanup failed\n");
 
 	mlx5_ib_destroy_qp(dev->umrc.qp);
-	ib_destroy_cq(dev->umrc.cq);
+	ib_free_cq(dev->umrc.cq);
 	ib_dealloc_pd(dev->umrc.pd);
 }
 
@@ -1853,7 +1853,6 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	struct ib_pd *pd;
 	struct ib_cq *cq;
 	struct ib_qp *qp;
-	struct ib_cq_init_attr cq_attr = {};
 	int ret;
 
 	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
@@ -1870,15 +1869,12 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 		goto error_0;
 	}
 
-	cq_attr.cqe = 128;
-	cq = ib_create_cq(&dev->ib_dev, mlx5_umr_cq_handler, NULL, NULL,
-			  &cq_attr);
+	cq = ib_alloc_cq(&dev->ib_dev, NULL, 128, 0, IB_POLL_SOFTIRQ);
 	if (IS_ERR(cq)) {
 		mlx5_ib_dbg(dev, "Couldn't create CQ for sync UMR QP\n");
 		ret = PTR_ERR(cq);
 		goto error_2;
 	}
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 
 	init_attr->send_cq = cq;
 	init_attr->recv_cq = cq;
@@ -1945,7 +1941,7 @@ error_4:
 	mlx5_ib_destroy_qp(qp);
 
 error_3:
-	ib_destroy_cq(cq);
+	ib_free_cq(cq);
 
 error_2:
 	ib_dealloc_pd(pd);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2d05bb5..5d0686e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -428,16 +428,11 @@ struct mlx5_ib_mr {
 };
 
 struct mlx5_ib_umr_context {
+	struct ib_cqe		cqe;
 	enum ib_wc_status	status;
 	struct completion	done;
 };
 
-static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
-{
-	context->status = -1;
-	init_completion(&context->done);
-}
-
 struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
@@ -699,7 +694,6 @@ int mlx5_ib_get_cqe_size(struct mlx5_ib_dev *dev, struct ib_cq *ibcq);
 int mlx5_mr_cache_init(struct mlx5_ib_dev *dev);
 int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev);
 int mlx5_mr_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift);
-void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context);
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status);
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 2afcb61..0822d907 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -734,26 +734,20 @@ static void prep_umr_unreg_wqe(struct mlx5_ib_dev *dev,
 	umrwr->mkey = key;
 }
 
-void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context)
+static void mlx5_ib_umr_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct mlx5_ib_umr_context *context;
-	struct ib_wc wc;
-	int err;
+	struct mlx5_ib_umr_context *context =
+		container_of(wc->wr_cqe, struct mlx5_ib_umr_context, cqe);
 
-	while (1) {
-		err = ib_poll_cq(cq, 1, &wc);
-		if (err < 0) {
-			pr_warn("poll cq error %d\n", err);
-			return;
-		}
-		if (err == 0)
-			break;
+	context->status = wc->status;
+	complete(&context->done);
+}
 
-		context = (struct mlx5_ib_umr_context *) (unsigned long) wc.wr_id;
-		context->status = wc.status;
-		complete(&context->done);
-	}
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
+{
+	context->cqe.done = mlx5_ib_umr_done;
+	context->status = -1;
+	init_completion(&context->done);
 }
 
 static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
@@ -811,12 +805,13 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 		goto free_pas;
 	}
 
+	mlx5_ib_init_umr_context(&umr_context);
+
 	memset(&umrwr, 0, sizeof(umrwr));
-	umrwr.wr.wr_id = (u64)(unsigned long)&umr_context;
+	umrwr.wr.wr_cqe = &umr_context.cqe;
 	prep_umr_reg_wqe(pd, &umrwr.wr, &sg, dma, npages, mr->mmr.key,
 			 page_shift, virt_addr, len, access_flags);
 
-	mlx5_ib_init_umr_context(&umr_context);
 	down(&umrc->sem);
 	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
 	if (err) {
@@ -929,8 +924,10 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 
 		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);
 
+		mlx5_ib_init_umr_context(&umr_context);
+
 		memset(&wr, 0, sizeof(wr));
-		wr.wr.wr_id = (u64)(unsigned long)&umr_context;
+		wr.wr.wr_cqe = &umr_context.cqe;
 
 		sg.addr = dma;
 		sg.length = ALIGN(npages * sizeof(u64),
@@ -947,7 +944,6 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 		wr.mkey = mr->mmr.key;
 		wr.target.offset = start_page_index;
 
-		mlx5_ib_init_umr_context(&umr_context);
 		down(&umrc->sem);
 		err = ib_post_send(umrc->qp, &wr.wr, &bad);
 		if (err) {
@@ -1139,11 +1135,12 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	struct ib_send_wr *bad;
 	int err;
 
+	mlx5_ib_init_umr_context(&umr_context);
+
 	memset(&umrwr.wr, 0, sizeof(umrwr));
-	umrwr.wr.wr_id = (u64)(unsigned long)&umr_context;
+	umrwr.wr.wr_cqe = &umr_context.cqe;
 	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmr.key);
 
-	mlx5_ib_init_umr_context(&umr_context);
 	down(&umrc->sem);
 	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
 	if (err) {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
