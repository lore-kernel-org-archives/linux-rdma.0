From: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Subject: [PATCH v2 2/2] IB/mlx4: use kvmalloc_array to allocate wrid
Date: Wed, 16 Aug 2017 23:31:23 +1000
Message-ID: <20170816133123.20497-2-dongyang.li@anu.edu.au>
References: <20170816133123.20497-1-dongyang.li@anu.edu.au>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170816133123.20497-1-dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We could use kvmalloc_array instead of the
kmalloc and __vmalloc combination.
After this we don't need to include linux/vmalloc.h

Signed-off-by: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c  | 15 ++++-----------
 drivers/infiniband/hw/mlx4/srq.c | 13 ++++---------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 75c0e6c5dd56..76ae772cfbf9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -36,7 +36,6 @@
 #include <net/ip.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
-#include <linux/vmalloc.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
@@ -812,16 +811,10 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		qp->sq.wrid = kmalloc_array(qp->sq.wqe_cnt, sizeof(u64),
-					GFP_KERNEL | __GFP_NOWARN);
-		if (!qp->sq.wrid)
-			qp->sq.wrid = __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
-						GFP_KERNEL, PAGE_KERNEL);
-		qp->rq.wrid = kmalloc_array(qp->rq.wqe_cnt, sizeof(u64),
-					GFP_KERNEL | __GFP_NOWARN);
-		if (!qp->rq.wrid)
-			qp->rq.wrid = __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
-						GFP_KERNEL, PAGE_KERNEL);
+		qp->sq.wrid = kvmalloc_array(qp->sq.wqe_cnt,
+					     sizeof(u64), GFP_KERNEL);
+		qp->rq.wrid = kvmalloc_array(qp->rq.wqe_cnt,
+					     sizeof(u64), GFP_KERNEL);
 		if (!qp->sq.wrid || !qp->rq.wrid) {
 			err = -ENOMEM;
 			goto err_wrid;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 0facaf5f6d23..dd7a2fce9df4 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -34,7 +34,6 @@
 #include <linux/mlx4/qp.h>
 #include <linux/mlx4/srq.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 
 #include "mlx4_ib.h"
 #include <rdma/mlx4-abi.h>
@@ -171,15 +170,11 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		srq->wrid = kmalloc_array(srq->msrq.max, sizeof(u64),
-					GFP_KERNEL | __GFP_NOWARN);
+		srq->wrid = kvmalloc_array(srq->msrq.max,
+					   sizeof(u64), GFP_KERNEL);
 		if (!srq->wrid) {
-			srq->wrid = __vmalloc(srq->msrq.max * sizeof(u64),
-					      GFP_KERNEL, PAGE_KERNEL);
-			if (!srq->wrid) {
-				err = -ENOMEM;
-				goto err_mtt;
-			}
+			err = -ENOMEM;
+			goto err_mtt;
 		}
 	}
 
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
