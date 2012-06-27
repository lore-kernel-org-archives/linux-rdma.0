From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] IB/qib: RCU locking for MR validation
Date: Wed, 27 Jun 2012 18:33:19 -0400
Message-ID: <20120627223319.12508.88664.stgit@kop-dev-sles11-04.qlogic.org>
References: <20120627223257.12508.1491.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120627223257.12508.1491.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Profiling indicates that MR validation locking is expensive.  The
MR table is largely read-only and is a suitable candidate for RCU
locking.

The patch uses RCU locking during validation to eliminate one
lock/unlock during that validation.

Reviewed-by: Mike Heinz <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c  |   98 +++++++++++++++++----------------
 drivers/infiniband/hw/qib/qib_mr.c    |    7 ++
 drivers/infiniband/hw/qib/qib_verbs.c |    4 +
 drivers/infiniband/hw/qib/qib_verbs.h |    7 ++
 4 files changed, 66 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 8b5ee3a..970165b 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -40,8 +40,7 @@
  *
  * Returns 0 if successful, otherwise returns -errno.
  *
- * Increments mr reference count and sets published
- * as required.
+ * Increments mr reference count as required.
  *
  * Sets the lkey field mr for non-dma regions.
  *
@@ -60,10 +59,12 @@ int qib_alloc_lkey(struct qib_mregion *mr, int dma_region)
 
 	/* special case for dma_mr lkey == 0 */
 	if (dma_region) {
-		/* should the dma_mr be relative to the pd? */
-		if (!dev->dma_mr) {
+		struct qib_mregion *tmr;
+
+		tmr = rcu_dereference(dev->dma_mr);
+		if (!tmr) {
 			qib_get_mr(mr);
-			dev->dma_mr = mr;
+			rcu_assign_pointer(dev->dma_mr, mr);
 			mr->lkey_published = 1;
 		}
 		goto success;
@@ -93,7 +94,7 @@ int qib_alloc_lkey(struct qib_mregion *mr, int dma_region)
 		rkt->gen++;
 	}
 	qib_get_mr(mr);
-	rkt->table[r] = mr;
+	rcu_assign_pointer(rkt->table[r], mr);
 	mr->lkey_published = 1;
 success:
 	spin_unlock_irqrestore(&rkt->lock, flags);
@@ -120,33 +121,30 @@ void qib_free_lkey(struct qib_mregion *mr)
 	spin_lock_irqsave(&rkt->lock, flags);
 	if (!mr->lkey_published)
 		goto out;
-	mr->lkey_published = 0;
-
-
-	spin_lock_irqsave(&dev->lk_table.lock, flags);
-	if (lkey == 0) {
-		if (dev->dma_mr && dev->dma_mr == mr) {
-			qib_put_mr(dev->dma_mr);
-			dev->dma_mr = NULL;
-		}
-	} else {
+	if (lkey == 0)
+		rcu_assign_pointer(dev->dma_mr, NULL);
+	else {
 		r = lkey >> (32 - ib_qib_lkey_table_size);
-		qib_put_mr(dev->dma_mr);
-		rkt->table[r] = NULL;
+		rcu_assign_pointer(rkt->table[r], NULL);
 	}
+	qib_put_mr(mr);
+	mr->lkey_published = 0;
 out:
-	spin_unlock_irqrestore(&dev->lk_table.lock, flags);
+	spin_unlock_irqrestore(&rkt->lock, flags);
 }
 
 /**
  * qib_lkey_ok - check IB SGE for validity and initialize
  * @rkt: table containing lkey to check SGE against
+ * @pd: protection domain
  * @isge: outgoing internal SGE
  * @sge: SGE to check
  * @acc: access flags
  *
  * Return 1 if valid and successful, otherwise returns 0.
  *
+ * increments the reference count upon success
+ *
  * Check the IB SGE for validity and initialize our internal version
  * of it.
  */
@@ -156,24 +154,25 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 	struct qib_mregion *mr;
 	unsigned n, m;
 	size_t off;
-	unsigned long flags;
 
 	/*
 	 * We use LKEY == zero for kernel virtual addresses
 	 * (see qib_get_dma_mr and qib_dma.c).
 	 */
-	spin_lock_irqsave(&rkt->lock, flags);
+	rcu_read_lock();
 	if (sge->lkey == 0) {
 		struct qib_ibdev *dev = to_idev(pd->ibpd.device);
 
 		if (pd->user)
 			goto bail;
-		if (!dev->dma_mr)
+		mr = rcu_dereference(dev->dma_mr);
+		if (!mr)
+			goto bail;
+		if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
 			goto bail;
-		qib_get_mr(dev->dma_mr);
-		spin_unlock_irqrestore(&rkt->lock, flags);
+		rcu_read_unlock();
 
-		isge->mr = dev->dma_mr;
+		isge->mr = mr;
 		isge->vaddr = (void *) sge->addr;
 		isge->length = sge->length;
 		isge->sge_length = sge->length;
@@ -181,18 +180,18 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 		isge->n = 0;
 		goto ok;
 	}
-	mr = rkt->table[(sge->lkey >> (32 - ib_qib_lkey_table_size))];
-	if (unlikely(mr == NULL || mr->lkey != sge->lkey ||
-		     mr->pd != &pd->ibpd))
+	mr = rcu_dereference(
+		rkt->table[(sge->lkey >> (32 - ib_qib_lkey_table_size))]);
+	if (unlikely(!mr || mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
 		goto bail;
 
 	off = sge->addr - mr->user_base;
-	if (unlikely(sge->addr < mr->user_base ||
-		     off + sge->length > mr->length ||
-		     (mr->access_flags & acc) != acc))
+	if (unlikely(sge->addr < mr->iova || off + sge->length > mr->length ||
+		     (mr->access_flags & acc) == 0))
 		goto bail;
-	qib_get_mr(mr);
-	spin_unlock_irqrestore(&rkt->lock, flags);
+	if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
+		goto bail;
+	rcu_read_unlock();
 
 	off += mr->offset;
 	if (mr->page_shift) {
@@ -228,20 +227,22 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 ok:
 	return 1;
 bail:
-	spin_unlock_irqrestore(&rkt->lock, flags);
+	rcu_read_unlock();
 	return 0;
 }
 
 /**
  * qib_rkey_ok - check the IB virtual address, length, and RKEY
- * @dev: infiniband device
- * @ss: SGE state
+ * @qp: qp for validation
+ * @sge: SGE state
  * @len: length of data
  * @vaddr: virtual address to place data
  * @rkey: rkey to check
  * @acc: access flags
  *
  * Return 1 if successful, otherwise 0.
+ *
+ * increments the reference count upon success
  */
 int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc)
@@ -250,25 +251,26 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 	struct qib_mregion *mr;
 	unsigned n, m;
 	size_t off;
-	unsigned long flags;
 
 	/*
 	 * We use RKEY == zero for kernel virtual addresses
 	 * (see qib_get_dma_mr and qib_dma.c).
 	 */
-	spin_lock_irqsave(&rkt->lock, flags);
+	rcu_read_lock();
 	if (rkey == 0) {
 		struct qib_pd *pd = to_ipd(qp->ibqp.pd);
 		struct qib_ibdev *dev = to_idev(pd->ibpd.device);
 
 		if (pd->user)
 			goto bail;
-		if (!dev->dma_mr)
+		mr = rcu_dereference(dev->dma_mr);
+		if (!mr)
 			goto bail;
-		qib_get_mr(dev->dma_mr);
-		spin_unlock_irqrestore(&rkt->lock, flags);
+		if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
+			goto bail;
+		rcu_read_unlock();
 
-		sge->mr = dev->dma_mr;
+		sge->mr = mr;
 		sge->vaddr = (void *) vaddr;
 		sge->length = len;
 		sge->sge_length = len;
@@ -277,16 +279,18 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 		goto ok;
 	}
 
-	mr = rkt->table[(rkey >> (32 - ib_qib_lkey_table_size))];
-	if (unlikely(mr == NULL || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
+	mr = rcu_dereference(
+		rkt->table[(rkey >> (32 - ib_qib_lkey_table_size))]);
+	if (unlikely(!mr || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
 		goto bail;
 
 	off = vaddr - mr->iova;
 	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
 		     (mr->access_flags & acc) == 0))
 		goto bail;
-	qib_get_mr(mr);
-	spin_unlock_irqrestore(&rkt->lock, flags);
+	if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
+		goto bail;
+	rcu_read_unlock();
 
 	off += mr->offset;
 	if (mr->page_shift) {
@@ -322,7 +326,7 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 ok:
 	return 1;
 bail:
-	spin_unlock_irqrestore(&rkt->lock, flags);
+	rcu_read_unlock();
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 6a2028a..e6687de 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -527,3 +527,10 @@ int qib_dealloc_fmr(struct ib_fmr *ibfmr)
 out:
 	return ret;
 }
+
+void mr_rcu_callback(struct rcu_head *list)
+{
+	struct qib_mregion *mr = container_of(list, struct qib_mregion, list);
+
+	complete(&mr->comp);
+}
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 76d7ce8..59cdea3 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2066,7 +2066,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
 		ret = -ENOMEM;
 		goto err_lk;
 	}
-	memset(dev->lk_table.table, 0, lk_tab_size);
+	RCU_INIT_POINTER(dev->dma_mr, NULL);
+	for (i = 0; i < dev->lk_table.max; i++)
+		RCU_INIT_POINTER(dev->lk_table.table[i], NULL);
 	INIT_LIST_HEAD(&dev->pending_mmaps);
 	spin_lock_init(&dev->pending_lock);
 	dev->mmap_offset = PAGE_SIZE;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 4a2277b..85751fd 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -303,8 +303,9 @@ struct qib_mregion {
 	u32 max_segs;           /* number of qib_segs in all the arrays */
 	u32 mapsz;              /* size of the map array */
 	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
-	u8  lkey_published;	/* in global table */
+	u8  lkey_published;     /* in global table */
 	struct completion comp; /* complete when refcount goes to zero */
+	struct rcu_head list;
 	atomic_t refcount;
 	struct qib_segarray *map[0];    /* the segments */
 };
@@ -1022,10 +1023,12 @@ static inline void qib_get_mr(struct qib_mregion *mr)
 	atomic_inc(&mr->refcount);
 }
 
+void mr_rcu_callback(struct rcu_head *list);
+
 static inline void qib_put_mr(struct qib_mregion *mr)
 {
 	if (unlikely(atomic_dec_and_test(&mr->refcount)))
-		complete(&mr->comp);
+		call_rcu(&mr->list, mr_rcu_callback);
 }
 
 static inline void qib_put_ss(struct qib_sge_state *ss)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
