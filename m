From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH 1/2] IB/mlx4: Suppress memory allocations warnings in kmalloc->__vmalloc flows
Date: Thu, 17 Dec 2015 09:31:52 +0200
Message-ID: <1450337513-22609-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Failure in kmalloc memory allocations will throw a warning about it.
Such warnings are not needed anymore, since in commit 0ef2f05c7e02
("IB/mlx4: Use vmalloc for WR buffers when needed"), fallback mechanism
from kmalloc() to __vmalloc() was added.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c  | 6 ++++--
 drivers/infiniband/hw/mlx4/srq.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 13eaaf45288f..dc86975fe1a9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -796,11 +796,13 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(u64), gfp);
+		qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(u64),
+					gfp | __GFP_NOWARN);
 		if (!qp->sq.wrid)
 			qp->sq.wrid = __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
 						gfp, PAGE_KERNEL);
-		qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(u64), gfp);
+		qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(u64),
+					gfp | __GFP_NOWARN);
 		if (!qp->rq.wrid)
 			qp->rq.wrid = __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
 						gfp, PAGE_KERNEL);
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 8d133c40fa0e..f416c7463827 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -171,7 +171,8 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		srq->wrid = kmalloc(srq->msrq.max * sizeof (u64), GFP_KERNEL);
+		srq->wrid = kmalloc(srq->msrq.max * sizeof(u64),
+					GFP_KERNEL | __GFP_NOWARN);
 		if (!srq->wrid) {
 			srq->wrid = __vmalloc(srq->msrq.max * sizeof(u64),
 					      GFP_KERNEL, PAGE_KERNEL);
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
