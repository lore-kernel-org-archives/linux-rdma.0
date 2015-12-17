From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH 2/2] IB/mlx4: Convert kmalloc to be kmalloc_array to fix checkpatch warnings
Date: Thu, 17 Dec 2015 09:31:53 +0200
Message-ID: <1450337513-22609-2-git-send-email-leon@leon.nu>
References: <1450337513-22609-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450337513-22609-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Convert kmalloc to be kmalloc_array to fix warnings below:

WARNING: Prefer kmalloc_array over kmalloc with multiply
+               qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(u64),

WARNING: Prefer kmalloc_array over kmalloc with multiply
+               qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(u64),

WARNING: Prefer kmalloc_array over kmalloc with multiply
+               srq->wrid = kmalloc(srq->msrq.max * sizeof(u64),

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c  | 4 ++--
 drivers/infiniband/hw/mlx4/srq.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index dc86975fe1a9..70de13ed9da7 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -796,12 +796,12 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(u64),
+		qp->sq.wrid = kmalloc_array(qp->sq.wqe_cnt, sizeof(u64),
 					gfp | __GFP_NOWARN);
 		if (!qp->sq.wrid)
 			qp->sq.wrid = __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
 						gfp, PAGE_KERNEL);
-		qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(u64),
+		qp->rq.wrid = kmalloc_array(qp->rq.wqe_cnt, sizeof(u64),
 					gfp | __GFP_NOWARN);
 		if (!qp->rq.wrid)
 			qp->rq.wrid = __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index f416c7463827..68d5a5fda271 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -171,7 +171,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		srq->wrid = kmalloc(srq->msrq.max * sizeof(u64),
+		srq->wrid = kmalloc_array(srq->msrq.max, sizeof(u64),
 					GFP_KERNEL | __GFP_NOWARN);
 		if (!srq->wrid) {
 			srq->wrid = __vmalloc(srq->msrq.max * sizeof(u64),
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
