From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu,  8 Oct 2015 13:27:04 +0800
Message-ID: <1444282024-11425-1-git-send-email-wen.gang.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are several hits that WR buffer allocation(kmalloc) failed.
It failed at order 3 and/or 4 contigous pages allocation. At the same time
there are actually 100MB+ free memory but well fragmented.
So try vmalloc when kmalloc failed.

Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c  | 19 +++++++++++++------
 drivers/infiniband/hw/mlx4/srq.c | 11 ++++++++---
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4ad9be3..3ccbd3a 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -34,6 +34,7 @@
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/vmalloc.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
@@ -786,8 +787,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		qp->sq.wrid  = kmalloc(qp->sq.wqe_cnt * sizeof (u64), gfp);
-		qp->rq.wrid  = kmalloc(qp->rq.wqe_cnt * sizeof (u64), gfp);
+		qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(u64), gfp);
+		if (!qp->sq.wrid)
+			qp->sq.wrid = __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
+						gfp, PAGE_KERNEL);
+		qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(u64), gfp);
+		if (!qp->rq.wrid)
+			qp->rq.wrid = __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
+						gfp, PAGE_KERNEL);
 		if (!qp->sq.wrid || !qp->rq.wrid) {
 			err = -ENOMEM;
 			goto err_wrid;
@@ -874,8 +881,8 @@ err_wrid:
 		if (qp_has_rq(init_attr))
 			mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &qp->db);
 	} else {
-		kfree(qp->sq.wrid);
-		kfree(qp->rq.wrid);
+		kvfree(qp->sq.wrid);
+		kvfree(qp->rq.wrid);
 	}
 
 err_mtt:
@@ -1050,8 +1057,8 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 					      &qp->db);
 		ib_umem_release(qp->umem);
 	} else {
-		kfree(qp->sq.wrid);
-		kfree(qp->rq.wrid);
+		kvfree(qp->sq.wrid);
+		kvfree(qp->rq.wrid);
 		if (qp->mlx4_ib_qp_type & (MLX4_IB_QPT_PROXY_SMI_OWNER |
 		    MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI))
 			free_proxy_bufs(&dev->ib_dev, qp);
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index dce5dfe..8d133c4 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -34,6 +34,7 @@
 #include <linux/mlx4/qp.h>
 #include <linux/mlx4/srq.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 
 #include "mlx4_ib.h"
 #include "user.h"
@@ -172,8 +173,12 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 
 		srq->wrid = kmalloc(srq->msrq.max * sizeof (u64), GFP_KERNEL);
 		if (!srq->wrid) {
-			err = -ENOMEM;
-			goto err_mtt;
+			srq->wrid = __vmalloc(srq->msrq.max * sizeof(u64),
+					      GFP_KERNEL, PAGE_KERNEL);
+			if (!srq->wrid) {
+				err = -ENOMEM;
+				goto err_mtt;
+			}
 		}
 	}
 
@@ -204,7 +209,7 @@ err_wrid:
 	if (pd->uobject)
 		mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &srq->db);
 	else
-		kfree(srq->wrid);
+		kvfree(srq->wrid);
 
 err_mtt:
 	mlx4_mtt_cleanup(dev->dev, &srq->mtt);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
