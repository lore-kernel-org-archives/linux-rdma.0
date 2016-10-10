From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] IB/hfi1: Optimize lkey validation structures
Date: Mon, 10 Oct 2016 06:14:39 -0700
Message-ID: <20161010131439.17586.29496.stgit@scvm10.sc.intel.com>
References: <20161010131249.17586.23789.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010131249.17586.23789.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Profiling shows that the key validation is susceptible
to cache line trading when accessing the lkey table.

Fix by separating out the read mostly fields from the write
fields.   In addition the shift amount, which is function
of the lkey table size, is precomputed and stored with the
table pointer.   Since both the shift and table pointer
are in the same read mostly cacheline, this saves a cache
line in this hot path.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |   10 +++++-----
 include/rdma/rdmavt_mr.h          |   10 +++++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 46b6497..4acf179 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -84,6 +84,7 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 		lkey_table_size = rdi->dparms.lkey_table_size;
 	}
 	rdi->lkey_table.max = 1 << lkey_table_size;
+	rdi->lkey_table.shift = 32 - lkey_table_size;
 	lk_tab_size = rdi->lkey_table.max * sizeof(*rdi->lkey_table.table);
 	rdi->lkey_table.table = (struct rvt_mregion __rcu **)
 			       vmalloc_node(lk_tab_size, rdi->dparms.node);
@@ -774,7 +775,6 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 	struct rvt_mregion *mr;
 	unsigned n, m;
 	size_t off;
-	struct rvt_dev_info *dev = ib_to_rvt(pd->ibpd.device);
 
 	/*
 	 * We use LKEY == zero for kernel virtual addresses
@@ -782,6 +782,8 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 	 */
 	rcu_read_lock();
 	if (sge->lkey == 0) {
+		struct rvt_dev_info *dev = ib_to_rvt(pd->ibpd.device);
+
 		if (pd->user)
 			goto bail;
 		mr = rcu_dereference(dev->dma_mr);
@@ -798,8 +800,7 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		isge->n = 0;
 		goto ok;
 	}
-	mr = rcu_dereference(
-		rkt->table[(sge->lkey >> (32 - dev->dparms.lkey_table_size))]);
+	mr = rcu_dereference(rkt->table[sge->lkey >> rkt->shift]);
 	if (unlikely(!mr || atomic_read(&mr->lkey_invalid) ||
 		     mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
 		goto bail;
@@ -899,8 +900,7 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		goto ok;
 	}
 
-	mr = rcu_dereference(
-		rkt->table[(rkey >> (32 - dev->dparms.lkey_table_size))]);
+	mr = rcu_dereference(rkt->table[rkey >> rkt->shift]);
 	if (unlikely(!mr || atomic_read(&mr->lkey_invalid) ||
 		     mr->lkey != rkey || qp->ibqp.pd != mr->pd))
 		goto bail;
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
index 6b3c6c8..de59de2 100644
--- a/include/rdma/rdmavt_mr.h
+++ b/include/rdma/rdmavt_mr.h
@@ -90,11 +90,15 @@ struct rvt_mregion {
 #define RVT_MAX_LKEY_TABLE_BITS 23
 
 struct rvt_lkey_table {
-	spinlock_t lock; /* protect changes in this struct */
-	u32 next;               /* next unused index (speeds search) */
-	u32 gen;                /* generation count */
+	/* read mostly fields */
 	u32 max;                /* size of the table */
+	u32 shift;              /* lkey/rkey shift */
 	struct rvt_mregion __rcu **table;
+	/* writeable fields */
+	/* protect changes in this struct */
+	spinlock_t lock ____cacheline_aligned_in_smp;
+	u32 next;               /* next unused index (speeds search) */
+	u32 gen;                /* generation count */
 };
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
