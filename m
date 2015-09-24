From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mlx4: vmalloc for mlx4_ib_wq.wrid and mlx4_ib_srq.wrid
Date: Thu, 24 Sep 2015 10:10:54 +0800
Message-ID: <1443060654-10402-1-git-send-email-wen.gang.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use __vmalloc to allocate memory for mlx4_ib_wq.wrid and mlx4_ib_srq.wrid.

Several hits that the kmalloc for wrid failed with the following like
call back stack:

kworker/u:4: page allocation failure: order:4, mode:0x2000d0
Pid: 16388, comm: kworker/u:4 Not tainted
Call Trace:
 [<ffffffff81134893>] warn_alloc_failed+0xf3/0x160
 [<ffffffff811377fa>] ? __alloc_pages_direct_compact+0x1fa/0x200
 [<ffffffff81137ca6>] __alloc_pages_slowpath+0x4a6/0x7b0
 [<ffffffff811382ab>] __alloc_pages_nodemask+0x2fb/0x320
 [<ffffffff8117c427>] kmem_getpages+0x67/0x1c0
 [<ffffffff8117df27>] fallback_alloc+0x187/0x250
 [<ffffffff8117dcea>] ____cache_alloc_node+0x9a/0x150
 [<ffffffff8117eb2b>] __kmalloc+0x18b/0x340
 [<ffffffffa031e8f1>] ? create_qp_common+0x431/0x8e0 [mlx4_ib]
 [<ffffffffa031e8f1>] create_qp_common+0x431/0x8e0 [mlx4_ib]
 [<ffffffffa031b6de>] ? kzalloc.clone.1+0xe/0x10 [mlx4_ib]
 [<ffffffffa031efa7>] mlx4_ib_create_qp+0x207/0x310 [mlx4_ib]
 [<ffffffffa02f6811>] ib_create_qp+0x41/0x1c0 [ib_core]
 [<ffffffffa035f258>] ipoib_cm_create_tx_qp+0xc8/0x130 [ib_ipoib]
 [<ffffffff811685e5>] ? __vmalloc_node+0x35/0x40
 [<ffffffffa035f555>] ipoib_cm_tx_init+0x65/0x380 [ib_ipoib]
 [<ffffffff8109801d>] ? sched_clock_cpu+0xcd/0x110
 [<ffffffff81004ce0>] ? xen_mc_flush+0xb0/0x1b0
 [<ffffffffa0363df0>] ipoib_cm_tx_start+0x230/0x3d0 [ib_ipoib]
 [<ffffffff8107b900>] process_one_work+0x180/0x420
 [<ffffffff8107d93e>] worker_thread+0x12e/0x390
 [<ffffffff8107d810>] ? manage_workers+0x180/0x180
 [<ffffffff81082c8e>] kthread+0xce/0xe0
 [<ffffffff810038ce>] ? xen_end_context_switch+0x1e/0x30
 [<ffffffff81082bc0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff8159c0ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81082bc0>] ? kthread_freezable_should_stop+0x70/0x70

It needs 16 contigous pages and failed. At the time there actually is
100MB+ free memory:

Node 0 Normal: 10268*4kB (UM) 7443*8kB (UEM) 1647*16kB (UM) 35*32kB (UR)
1*64kB (R) 4*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB =
129944kB

I also hit same errors order 3.

Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c  | 15 +++++++++------
 drivers/infiniband/hw/mlx4/srq.c |  6 ++++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4ad9be3..754ceb9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -34,6 +34,7 @@
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/vmalloc.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
@@ -786,8 +787,10 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		qp->sq.wrid  = kmalloc(qp->sq.wqe_cnt * sizeof (u64), gfp);
-		qp->rq.wrid  = kmalloc(qp->rq.wqe_cnt * sizeof (u64), gfp);
+		qp->sq.wrid  = __vmalloc(qp->sq.wqe_cnt * sizeof(u64), gfp,
+					 PAGE_KERNEL);
+		qp->rq.wrid  = __vmalloc(qp->rq.wqe_cnt * sizeof(u64), gfp,
+					 PAGE_KERNEL);
 		if (!qp->sq.wrid || !qp->rq.wrid) {
 			err = -ENOMEM;
 			goto err_wrid;
@@ -874,8 +877,8 @@ err_wrid:
 		if (qp_has_rq(init_attr))
 			mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &qp->db);
 	} else {
-		kfree(qp->sq.wrid);
-		kfree(qp->rq.wrid);
+		vfree(qp->sq.wrid);
+		vfree(qp->rq.wrid);
 	}
 
 err_mtt:
@@ -1050,8 +1053,8 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 					      &qp->db);
 		ib_umem_release(qp->umem);
 	} else {
-		kfree(qp->sq.wrid);
-		kfree(qp->rq.wrid);
+		vfree(qp->sq.wrid);
+		vfree(qp->rq.wrid);
 		if (qp->mlx4_ib_qp_type & (MLX4_IB_QPT_PROXY_SMI_OWNER |
 		    MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI))
 			free_proxy_bufs(&dev->ib_dev, qp);
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index dce5dfe..6d21bb2 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -34,6 +34,7 @@
 #include <linux/mlx4/qp.h>
 #include <linux/mlx4/srq.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 
 #include "mlx4_ib.h"
 #include "user.h"
@@ -170,7 +171,8 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		srq->wrid = kmalloc(srq->msrq.max * sizeof (u64), GFP_KERNEL);
+		srq->wrid = __vmalloc(srq->msrq.max * sizeof(u64), GFP_KERNEL,
+				      PAGE_KERNEL);
 		if (!srq->wrid) {
 			err = -ENOMEM;
 			goto err_mtt;
@@ -204,7 +206,7 @@ err_wrid:
 	if (pd->uobject)
 		mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &srq->db);
 	else
-		kfree(srq->wrid);
+		vfree(srq->wrid);
 
 err_mtt:
 	mlx4_mtt_cleanup(dev->dev, &srq->mtt);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
