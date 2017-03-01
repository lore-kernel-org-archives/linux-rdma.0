From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/20] IB/hfi1: Eliminate synchronize_rcu() in mr delete
Date: Wed, 01 Mar 2017 10:24:09 -0800
Message-ID: <20170301182404.29989.63441.stgit@scvm10.sc.intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301181719.29989.31238.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The synchronize_rcu() call can be eliminated to improve memory deregistration
performance.

There are two key fields involved:
- The rcu pointer itself
- the lkey_published field

To close the window between the rcu read of the mregion pointer and the
reference count the code should:

1. To lkey/rkey validation (reader)

Read the rcu pointer.  If the pointer is non-NULL, get a reference.

To the current validation tests use a READ_ONCE() on the lkey_published.

Upon any failure release the reference.

2. To the remove logic (delete)

Insure the published is zeroed prior to setting the pointer to NULL.
This requires using rcu_assign_pointer() to insure lkey_published
is written prior to the NULL.

3. To the insert logic (add)

Insure the published is set use an rcu_assign_pointer() to insure the
pointer is after all MR fields.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |   49 +++++++++++++++++++++++++------------
 1 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index ae30b68..7c86955 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -191,8 +191,9 @@ static int rvt_alloc_lkey(struct rvt_mregion *mr, int dma_region)
 
 		tmr = rcu_access_pointer(dev->dma_mr);
 		if (!tmr) {
-			rcu_assign_pointer(dev->dma_mr, mr);
 			mr->lkey_published = 1;
+			/* Insure published written first */
+			rcu_assign_pointer(dev->dma_mr, mr);
 			rvt_get_mr(mr);
 		}
 		goto success;
@@ -224,8 +225,9 @@ static int rvt_alloc_lkey(struct rvt_mregion *mr, int dma_region)
 		mr->lkey |= 1 << 8;
 		rkt->gen++;
 	}
-	rcu_assign_pointer(rkt->table[r], mr);
 	mr->lkey_published = 1;
+	/* Insure published written first */
+	rcu_assign_pointer(rkt->table[r], mr);
 success:
 	spin_unlock_irqrestore(&rkt->lock, flags);
 out:
@@ -253,23 +255,24 @@ static void rvt_free_lkey(struct rvt_mregion *mr)
 	spin_lock_irqsave(&rkt->lock, flags);
 	if (!lkey) {
 		if (mr->lkey_published) {
-			RCU_INIT_POINTER(dev->dma_mr, NULL);
+			mr->lkey_published = 0;
+			/* insure published is written before pointer */
+			rcu_assign_pointer(dev->dma_mr, NULL);
 			rvt_put_mr(mr);
 		}
 	} else {
 		if (!mr->lkey_published)
 			goto out;
 		r = lkey >> (32 - dev->dparms.lkey_table_size);
-		RCU_INIT_POINTER(rkt->table[r], NULL);
+		mr->lkey_published = 0;
+		/* insure published is written before pointer */
+		rcu_assign_pointer(rkt->table[r], NULL);
 	}
-	mr->lkey_published = 0;
 	freed++;
 out:
 	spin_unlock_irqrestore(&rkt->lock, flags);
-	if (freed) {
-		synchronize_rcu();
+	if (freed)
 		percpu_ref_kill(&mr->refcount);
-	}
 }
 
 static struct rvt_mr *__rvt_alloc_mr(int count, struct ib_pd *pd)
@@ -822,16 +825,21 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		goto ok;
 	}
 	mr = rcu_dereference(rkt->table[sge->lkey >> rkt->shift]);
-	if (unlikely(!mr || atomic_read(&mr->lkey_invalid) ||
-		     mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
+	if (!mr)
 		goto bail;
+	rvt_get_mr(mr);
+	if (!READ_ONCE(mr->lkey_published))
+		goto bail_unref;
+
+	if (unlikely(atomic_read(&mr->lkey_invalid) ||
+		     mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
+		goto bail_unref;
 
 	off = sge->addr - mr->user_base;
 	if (unlikely(sge->addr < mr->user_base ||
 		     off + sge->length > mr->length ||
 		     (mr->access_flags & acc) != acc))
-		goto bail;
-	rvt_get_mr(mr);
+		goto bail_unref;
 	rcu_read_unlock();
 
 	off += mr->offset;
@@ -867,6 +875,8 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 	isge->n = n;
 ok:
 	return 1;
+bail_unref:
+	rvt_put_mr(mr);
 bail:
 	rcu_read_unlock();
 	return 0;
@@ -922,15 +932,20 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 	}
 
 	mr = rcu_dereference(rkt->table[rkey >> rkt->shift]);
-	if (unlikely(!mr || atomic_read(&mr->lkey_invalid) ||
-		     mr->lkey != rkey || qp->ibqp.pd != mr->pd))
+	if (!mr)
 		goto bail;
+	rvt_get_mr(mr);
+	/* insure mr read is before test */
+	if (!READ_ONCE(mr->lkey_published))
+		goto bail_unref;
+	if (unlikely(atomic_read(&mr->lkey_invalid) ||
+		     mr->lkey != rkey || qp->ibqp.pd != mr->pd))
+		goto bail_unref;
 
 	off = vaddr - mr->iova;
 	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
 		     (mr->access_flags & acc) == 0))
-		goto bail;
-	rvt_get_mr(mr);
+		goto bail_unref;
 	rcu_read_unlock();
 
 	off += mr->offset;
@@ -966,6 +981,8 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 	sge->n = n;
 ok:
 	return 1;
+bail_unref:
+	rvt_put_mr(mr);
 bail:
 	rcu_read_unlock();
 	return 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
