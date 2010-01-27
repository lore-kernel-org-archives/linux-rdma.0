From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: Don't allocate the sw queue for user mode CQs.
Date: Wed, 27 Jan 2010 11:03:54 -0600
Message-ID: <20100127170353.19882.40656.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Only kernel mode CQs need the sw queue memory allocated.  The sw queue
for user mode CQs is allocated in user mode by libcxgb3.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c      |   20 +++++++++++---------
 drivers/infiniband/hw/cxgb3/cxio_hal.h      |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 +-
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 8837d56..396da7b 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -154,7 +154,7 @@ static int cxio_hal_clear_qp_ctx(struct cxio_rdev *rdev_p, u32 qpid)
 	return iwch_cxgb3_ofld_send(rdev_p->t3cdev_p, skb);
 }
 
-int cxio_create_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq)
+int cxio_create_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq, int kernel)
 {
 	struct rdma_cq_setup setup;
 	int size = (1UL << (cq->size_log2)) * sizeof(struct t3_cqe);
@@ -162,15 +162,16 @@ int cxio_create_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq)
 	cq->cqid = cxio_hal_get_cqid(rdev_p->rscp);
 	if (!cq->cqid)
 		return -ENOMEM;
-	cq->sw_queue = kzalloc(size, GFP_KERNEL);
-	if (!cq->sw_queue)
-		return -ENOMEM;
-	cq->queue = dma_alloc_coherent(&(rdev_p->rnic_info.pdev->dev),
-					     (1UL << (cq->size_log2)) *
-					     sizeof(struct t3_cqe),
+	if (kernel) {
+		cq->sw_queue = kzalloc(size, GFP_KERNEL);
+		if (!cq->sw_queue)
+			return -ENOMEM;
+	}
+	cq->queue = dma_alloc_coherent(&(rdev_p->rnic_info.pdev->dev), size,
 					     &(cq->dma_addr), GFP_KERNEL);
 	if (!cq->queue) {
-		kfree(cq->sw_queue);
+		if (kernel)
+			kfree(cq->sw_queue);
 		return -ENOMEM;
 	}
 	pci_unmap_addr_set(cq, mapping, cq->dma_addr);
@@ -320,7 +321,8 @@ int cxio_destroy_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq)
 {
 	int err;
 	err = cxio_hal_clear_cq_ctx(rdev_p, cq->cqid);
-	kfree(cq->sw_queue);
+	if (cq->sw_queue)
+		kfree(cq->sw_queue);
 	dma_free_coherent(&(rdev_p->rnic_info.pdev->dev),
 			  (1UL << (cq->size_log2))
 			  * sizeof(struct t3_cqe), cq->queue,
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index f3d440c..baa2867 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -157,7 +157,7 @@ int cxio_rdev_open(struct cxio_rdev *rdev);
 void cxio_rdev_close(struct cxio_rdev *rdev);
 int cxio_hal_cq_op(struct cxio_rdev *rdev, struct t3_cq *cq,
 		   enum t3_cq_opcode op, u32 credit);
-int cxio_create_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
+int cxio_create_cq(struct cxio_rdev *rdev, struct t3_cq *cq, int kernel);
 int cxio_destroy_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
 int cxio_resize_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
 void cxio_release_ucontext(struct cxio_rdev *rdev, struct cxio_ucontext *uctx);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index ed71755..47b35c6 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -187,7 +187,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
 	entries = roundup_pow_of_two(entries);
 	chp->cq.size_log2 = ilog2(entries);
 
-	if (cxio_create_cq(&rhp->rdev, &chp->cq)) {
+	if (cxio_create_cq(&rhp->rdev, &chp->cq, !ucontext)) {
 		kfree(chp);
 		return ERR_PTR(-ENOMEM);
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
