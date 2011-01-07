From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: fix refcount leak in lkey/rkey validation
Date: Fri, 07 Jan 2011 08:21:40 -0500
Message-ID: <20110107132140.22914.42246.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-l8fZCXd1Rtodnm+yROfE0A@public.gmane.org>

The mr optimization introduced a reference count leak on an exception test.
The lock/refcount manipulation is moved down and the problematic exception
test now calls bail to insure that the lock is released.

Additional fixes as suggested by Ralph Campbell <ralph.campbell-l8fZCXd1Rtodnm+yROfE0A@public.gmane.org>:
- reduce lock scope of dma regions
- use explicit values on returns vs. automatic ret value

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 756d160..8fd19a4 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -136,7 +136,6 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 	struct qib_mregion *mr;
 	unsigned n, m;
 	size_t off;
-	int ret = 0;
 	unsigned long flags;
 
 	/*
@@ -152,27 +151,28 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 		if (!dev->dma_mr)
 			goto bail;
 		atomic_inc(&dev->dma_mr->refcount);
+		spin_unlock_irqrestore(&rkt->lock, flags);
+
 		isge->mr = dev->dma_mr;
 		isge->vaddr = (void *) sge->addr;
 		isge->length = sge->length;
 		isge->sge_length = sge->length;
 		isge->m = 0;
 		isge->n = 0;
-		spin_unlock_irqrestore(&rkt->lock, flags);
 		goto ok;
 	}
 	mr = rkt->table[(sge->lkey >> (32 - ib_qib_lkey_table_size))];
 	if (unlikely(mr == NULL || mr->lkey != sge->lkey ||
 		     mr->pd != &pd->ibpd))
 		goto bail;
-	atomic_inc(&mr->refcount);
-	spin_unlock_irqrestore(&rkt->lock, flags);
 
 	off = sge->addr - mr->user_base;
 	if (unlikely(sge->addr < mr->user_base ||
 		     off + sge->length > mr->length ||
 		     (mr->access_flags & acc) != acc))
-		return ret;
+		goto bail;
+	atomic_inc(&mr->refcount);
+	spin_unlock_irqrestore(&rkt->lock, flags);
 
 	off += mr->offset;
 	if (mr->page_shift) {
@@ -206,11 +206,10 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 	isge->m = m;
 	isge->n = n;
 ok:
-	ret = 1;
-	return ret;
+	return 1;
 bail:
 	spin_unlock_irqrestore(&rkt->lock, flags);
-	return ret;
+	return 0;
 }
 
 /**
@@ -231,7 +230,6 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 	struct qib_mregion *mr;
 	unsigned n, m;
 	size_t off;
-	int ret = 0;
 	unsigned long flags;
 
 	/*
@@ -248,26 +246,27 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 		if (!dev->dma_mr)
 			goto bail;
 		atomic_inc(&dev->dma_mr->refcount);
+		spin_unlock_irqrestore(&rkt->lock, flags);
+
 		sge->mr = dev->dma_mr;
 		sge->vaddr = (void *) vaddr;
 		sge->length = len;
 		sge->sge_length = len;
 		sge->m = 0;
 		sge->n = 0;
-		spin_unlock_irqrestore(&rkt->lock, flags);
 		goto ok;
 	}
 
 	mr = rkt->table[(rkey >> (32 - ib_qib_lkey_table_size))];
 	if (unlikely(mr == NULL || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
 		goto bail;
-	atomic_inc(&mr->refcount);
-	spin_unlock_irqrestore(&rkt->lock, flags);
 
 	off = vaddr - mr->iova;
 	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
 		     (mr->access_flags & acc) == 0))
-		return ret;
+		goto bail;
+	atomic_inc(&mr->refcount);
+	spin_unlock_irqrestore(&rkt->lock, flags);
 
 	off += mr->offset;
 	if (mr->page_shift) {
@@ -301,11 +300,10 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 	sge->m = m;
 	sge->n = n;
 ok:
-	ret = 1;
-	return ret;
+	return 1;
 bail:
 	spin_unlock_irqrestore(&rkt->lock, flags);
-	return ret;
+	return 0;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
