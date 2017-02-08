From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/27] IB/rdmavt: Use per-CPU reference count for MRs
Date: Wed, 08 Feb 2017 05:26:31 -0800
Message-ID: <20170208132630.16442.88555.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Having per-CPU reference count for each MR prevents
cache-line bouncing across the system. Thus, it
prevents bottlenecks. Use per-CPU reference counts
per MR.

The per-CPU reference count for FMRs is used in
atomic mode to allow accurate testing of the busy
state. Other MR types run in per-CPU mode MR until
they're freed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |   59 ++++++++++++++++++++++++-------------
 include/rdma/rdmavt_mr.h          |   10 +++---
 2 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 52fd152..c80a69b 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -120,10 +120,19 @@ static void rvt_deinit_mregion(struct rvt_mregion *mr)
 	mr->mapsz = 0;
 	while (i)
 		kfree(mr->map[--i]);
+	percpu_ref_exit(&mr->refcount);
+}
+
+static void __rvt_mregion_complete(struct percpu_ref *ref)
+{
+	struct rvt_mregion *mr = container_of(ref, struct rvt_mregion,
+					      refcount);
+
+	complete(&mr->comp);
 }
 
 static int rvt_init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
-			    int count)
+			    int count, unsigned int percpu_flags)
 {
 	int m, i = 0;
 	struct rvt_dev_info *dev = ib_to_rvt(pd->device);
@@ -133,19 +142,23 @@ static int rvt_init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
 	for (; i < m; i++) {
 		mr->map[i] = kzalloc_node(sizeof(*mr->map[0]), GFP_KERNEL,
 					  dev->dparms.node);
-		if (!mr->map[i]) {
-			rvt_deinit_mregion(mr);
-			return -ENOMEM;
-		}
+		if (!mr->map[i])
+			goto bail;
 		mr->mapsz++;
 	}
 	init_completion(&mr->comp);
 	/* count returning the ptr to user */
-	atomic_set(&mr->refcount, 1);
+	if (percpu_ref_init(&mr->refcount, &__rvt_mregion_complete,
+			    percpu_flags, GFP_KERNEL))
+		goto bail;
+
 	atomic_set(&mr->lkey_invalid, 0);
 	mr->pd = pd;
 	mr->max_segs = count;
 	return 0;
+bail:
+	rvt_deinit_mregion(mr);
+	return -ENOMEM;
 }
 
 /**
@@ -180,8 +193,7 @@ static int rvt_alloc_lkey(struct rvt_mregion *mr, int dma_region)
 		if (!tmr) {
 			rcu_assign_pointer(dev->dma_mr, mr);
 			mr->lkey_published = 1;
-		} else {
-			rvt_put_mr(mr);
+			rvt_get_mr(mr);
 		}
 		goto success;
 	}
@@ -239,11 +251,14 @@ static void rvt_free_lkey(struct rvt_mregion *mr)
 	int freed = 0;
 
 	spin_lock_irqsave(&rkt->lock, flags);
-	if (!mr->lkey_published)
-		goto out;
-	if (lkey == 0) {
-		RCU_INIT_POINTER(dev->dma_mr, NULL);
+	if (!lkey) {
+		if (mr->lkey_published) {
+			RCU_INIT_POINTER(dev->dma_mr, NULL);
+			rvt_put_mr(mr);
+		}
 	} else {
+		if (!mr->lkey_published)
+			goto out;
 		r = lkey >> (32 - dev->dparms.lkey_table_size);
 		RCU_INIT_POINTER(rkt->table[r], NULL);
 	}
@@ -253,7 +268,7 @@ static void rvt_free_lkey(struct rvt_mregion *mr)
 	spin_unlock_irqrestore(&rkt->lock, flags);
 	if (freed) {
 		synchronize_rcu();
-		rvt_put_mr(mr);
+		percpu_ref_kill(&mr->refcount);
 	}
 }
 
@@ -269,7 +284,7 @@ static void rvt_free_lkey(struct rvt_mregion *mr)
 	if (!mr)
 		goto bail;
 
-	rval = rvt_init_mregion(&mr->mr, pd, count);
+	rval = rvt_init_mregion(&mr->mr, pd, count, 0);
 	if (rval)
 		goto bail;
 	/*
@@ -294,8 +309,8 @@ static void rvt_free_lkey(struct rvt_mregion *mr)
 
 static void __rvt_free_mr(struct rvt_mr *mr)
 {
-	rvt_deinit_mregion(&mr->mr);
 	rvt_free_lkey(&mr->mr);
+	rvt_deinit_mregion(&mr->mr);
 	kfree(mr);
 }
 
@@ -323,7 +338,7 @@ struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc)
 		goto bail;
 	}
 
-	rval = rvt_init_mregion(&mr->mr, pd, 0);
+	rval = rvt_init_mregion(&mr->mr, pd, 0, 0);
 	if (rval) {
 		ret = ERR_PTR(rval);
 		goto bail;
@@ -445,8 +460,8 @@ int rvt_dereg_mr(struct ib_mr *ibmr)
 	timeout = wait_for_completion_timeout(&mr->mr.comp, 5 * HZ);
 	if (!timeout) {
 		rvt_pr_err(rdi,
-			   "rvt_dereg_mr timeout mr %p pd %p refcount %u\n",
-			   mr, mr->mr.pd, atomic_read(&mr->mr.refcount));
+			   "rvt_dereg_mr timeout mr %p pd %p\n",
+			   mr, mr->mr.pd);
 		rvt_get_mr(&mr->mr);
 		ret = -EBUSY;
 		goto out;
@@ -623,7 +638,8 @@ struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 	if (!fmr)
 		goto bail;
 
-	rval = rvt_init_mregion(&fmr->mr, pd, fmr_attr->max_pages);
+	rval = rvt_init_mregion(&fmr->mr, pd, fmr_attr->max_pages,
+				PERCPU_REF_INIT_ATOMIC);
 	if (rval)
 		goto bail;
 
@@ -674,11 +690,12 @@ int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 	struct rvt_fmr *fmr = to_ifmr(ibfmr);
 	struct rvt_lkey_table *rkt;
 	unsigned long flags;
-	int m, n, i;
+	int m, n;
+	unsigned long i;
 	u32 ps;
 	struct rvt_dev_info *rdi = ib_to_rvt(ibfmr->device);
 
-	i = atomic_read(&fmr->mr.refcount);
+	i = atomic_long_read(&fmr->mr.refcount.count);
 	if (i > 2)
 		return -EBUSY;
 
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
index de59de2..05698d8 100644
--- a/include/rdma/rdmavt_mr.h
+++ b/include/rdma/rdmavt_mr.h
@@ -52,6 +52,7 @@
  * For Memory Regions. This stuff should probably be moved into rdmavt/mr.h once
  * drivers no longer need access to the MR directly.
  */
+#include <linux/percpu-refcount.h>
 
 /*
  * A segment is a linear region of low physical memory.
@@ -79,11 +80,11 @@ struct rvt_mregion {
 	int access_flags;
 	u32 max_segs;           /* number of rvt_segs in all the arrays */
 	u32 mapsz;              /* size of the map array */
+	atomic_t lkey_invalid;	/* true if current lkey is invalid */
 	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
 	u8  lkey_published;     /* in global table */
-	atomic_t lkey_invalid;	/* true if current lkey is invalid */
+	struct percpu_ref refcount;
 	struct completion comp; /* complete when refcount goes to zero */
-	atomic_t refcount;
 	struct rvt_segarray *map[0];    /* the segments */
 };
 
@@ -123,13 +124,12 @@ struct rvt_sge_state {
 
 static inline void rvt_put_mr(struct rvt_mregion *mr)
 {
-	if (unlikely(atomic_dec_and_test(&mr->refcount)))
-		complete(&mr->comp);
+	percpu_ref_put(&mr->refcount);
 }
 
 static inline void rvt_get_mr(struct rvt_mregion *mr)
 {
-	atomic_inc(&mr->refcount);
+	percpu_ref_get(&mr->refcount);
 }
 
 static inline void rvt_put_ss(struct rvt_sge_state *ss)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
