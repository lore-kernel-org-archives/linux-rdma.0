From: Emil Goode <emilgoode-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DMA/cxgb4: Fix error handling
Date: Sun, 19 Aug 2012 19:59:40 +0200
Message-ID: <1345399180-17132-1-git-send-email-emilgoode@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Emil Goode <emilgoode-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The variable ret is assigned return values in a couple
of places, but it's value is never returned.
This patch makes use of the ret variable so that the caller
get correct error codes returned.
The following changes are also introduced:

- The alloc_oc_sq function can return -ENOSYS or -ENOMEM so
  we want to get the return value from it.

- Change the lable names to improve readability.

Signed-off-by: Emil Goode <emilgoode-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c |   62 +++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 45aedf1..e2bf9c6 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -137,19 +137,25 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		return -ENOMEM;
 
 	wq->rq.qid = c4iw_get_qpid(rdev, uctx);
-	if (!wq->rq.qid)
-		goto err1;
+	if (!wq->rq.qid) {
+		ret = -ENOMEM;
+		goto free_sq_qid;
+	}
 
 	if (!user) {
 		wq->sq.sw_sq = kzalloc(wq->sq.size * sizeof *wq->sq.sw_sq,
 				 GFP_KERNEL);
-		if (!wq->sq.sw_sq)
-			goto err2;
+		if (!wq->sq.sw_sq) {
+			ret = -ENOMEM;
+			goto free_rq_qid;
+		}
 
 		wq->rq.sw_rq = kzalloc(wq->rq.size * sizeof *wq->rq.sw_rq,
 				 GFP_KERNEL);
-		if (!wq->rq.sw_rq)
-			goto err3;
+		if (!wq->rq.sw_rq) {
+			ret = -ENOMEM;
+			goto free_sw_sq;
+		}
 	}
 
 	/*
@@ -157,15 +163,23 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	 */
 	wq->rq.rqt_size = roundup_pow_of_two(wq->rq.size);
 	wq->rq.rqt_hwaddr = c4iw_rqtpool_alloc(rdev, wq->rq.rqt_size);
-	if (!wq->rq.rqt_hwaddr)
-		goto err4;
+	if (!wq->rq.rqt_hwaddr) {
+		ret = -ENOMEM;
+		goto free_sw_rq;
+	}
 
 	if (user) {
-		if (alloc_oc_sq(rdev, &wq->sq) && alloc_host_sq(rdev, &wq->sq))
-			goto err5;
+		ret = alloc_oc_sq(rdev, &wq->sq);
+		if (ret)
+			goto free_hwaddr;
+
+		ret = alloc_host_sq(rdev, &wq->sq);
+		if (ret)
+			goto free_sq;
 	} else
-		if (alloc_host_sq(rdev, &wq->sq))
-			goto err5;
+		ret = alloc_host_sq(rdev, &wq->sq);
+		if (ret)
+			goto free_hwaddr;
 	memset(wq->sq.queue, 0, wq->sq.memsize);
 	dma_unmap_addr_set(&wq->sq, mapping, wq->sq.dma_addr);
 
@@ -173,7 +187,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 					  wq->rq.memsize, &(wq->rq.dma_addr),
 					  GFP_KERNEL);
 	if (!wq->rq.queue)
-		goto err6;
+		goto free_sq;
 	PDBG("%s sq base va 0x%p pa 0x%llx rq base va 0x%p pa 0x%llx\n",
 		__func__, wq->sq.queue,
 		(unsigned long long)virt_to_phys(wq->sq.queue),
@@ -201,7 +215,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb) {
 		ret = -ENOMEM;
-		goto err7;
+		goto free_dma;
 	}
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
@@ -266,33 +280,33 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 
 	ret = c4iw_ofld_send(rdev, skb);
 	if (ret)
-		goto err7;
+		goto free_dma;
 	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, wq->sq.qid, __func__);
 	if (ret)
-		goto err7;
+		goto free_dma;
 
 	PDBG("%s sqid 0x%x rqid 0x%x kdb 0x%p squdb 0x%llx rqudb 0x%llx\n",
 	     __func__, wq->sq.qid, wq->rq.qid, wq->db,
 	     (unsigned long long)wq->sq.udb, (unsigned long long)wq->rq.udb);
 
 	return 0;
-err7:
+free_dma:
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  wq->rq.memsize, wq->rq.queue,
 			  dma_unmap_addr(&wq->rq, mapping));
-err6:
+free_sq:
 	dealloc_sq(rdev, &wq->sq);
-err5:
+free_hwaddr:
 	c4iw_rqtpool_free(rdev, wq->rq.rqt_hwaddr, wq->rq.rqt_size);
-err4:
+free_sw_rq:
 	kfree(wq->rq.sw_rq);
-err3:
+free_sw_sq:
 	kfree(wq->sq.sw_sq);
-err2:
+free_rq_qid:
 	c4iw_put_qpid(rdev, wq->rq.qid, uctx);
-err1:
+free_sq_qid:
 	c4iw_put_qpid(rdev, wq->sq.qid, uctx);
-	return -ENOMEM;
+	return ret;
 }
 
 static int build_immd(struct t4_sq *sq, struct fw_ri_immd *immdp,
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
