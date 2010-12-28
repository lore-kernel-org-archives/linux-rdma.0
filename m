From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 20/24] IB/qib: RDMA lkey/rkey validation is inefficient for
	large MRs
Date: Tue, 28 Dec 2010 10:28:34 -0500
Message-ID: <20101228152834.19960.62290.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The current code loops during rkey/lkey validiation to isolate the mr
for the RDMA, which is expensive when the current operation is
inside a very large memory region.

This fix optimizes rkey/lkey validation routines for user memory regions and
fast memory regions.  The mr entry can be isolated by shifts/mods instead of
looping.  The existing loop is preserved for phys memory regions for now.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c  |   74 ++++++++++++++++++++++++---------
 drivers/infiniband/hw/qib/qib_mr.c    |    8 ++--
 drivers/infiniband/hw/qib/qib_verbs.h |    1 
 3 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 4b80eb1..756d160 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -158,31 +158,47 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 		isge->sge_length = sge->length;
 		isge->m = 0;
 		isge->n = 0;
+		spin_unlock_irqrestore(&rkt->lock, flags);
 		goto ok;
 	}
 	mr = rkt->table[(sge->lkey >> (32 - ib_qib_lkey_table_size))];
 	if (unlikely(mr == NULL || mr->lkey != sge->lkey ||
 		     mr->pd != &pd->ibpd))
 		goto bail;
+	atomic_inc(&mr->refcount);
+	spin_unlock_irqrestore(&rkt->lock, flags);
 
 	off = sge->addr - mr->user_base;
 	if (unlikely(sge->addr < mr->user_base ||
 		     off + sge->length > mr->length ||
 		     (mr->access_flags & acc) != acc))
-		goto bail;
+		return ret;
 
 	off += mr->offset;
-	m = 0;
-	n = 0;
-	while (off >= mr->map[m]->segs[n].length) {
-		off -= mr->map[m]->segs[n].length;
-		n++;
-		if (n >= QIB_SEGSZ) {
-			m++;
-			n = 0;
+	if (mr->page_shift) {
+		/*
+		page sizes are uniform power of 2 so no loop is necessary
+		entries_spanned_by_off is the number of times the loop below
+		would have executed.
+		*/
+		size_t entries_spanned_by_off;
+
+		entries_spanned_by_off = off >> mr->page_shift;
+		off -= (entries_spanned_by_off << mr->page_shift);
+		m = entries_spanned_by_off/QIB_SEGSZ;
+		n = entries_spanned_by_off%QIB_SEGSZ;
+	} else {
+		m = 0;
+		n = 0;
+		while (off >= mr->map[m]->segs[n].length) {
+			off -= mr->map[m]->segs[n].length;
+			n++;
+			if (n >= QIB_SEGSZ) {
+				m++;
+				n = 0;
+			}
 		}
 	}
-	atomic_inc(&mr->refcount);
 	isge->mr = mr;
 	isge->vaddr = mr->map[m]->segs[n].vaddr + off;
 	isge->length = mr->map[m]->segs[n].length - off;
@@ -191,6 +207,7 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 	isge->n = n;
 ok:
 	ret = 1;
+	return ret;
 bail:
 	spin_unlock_irqrestore(&rkt->lock, flags);
 	return ret;
@@ -237,30 +254,46 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 		sge->sge_length = len;
 		sge->m = 0;
 		sge->n = 0;
+		spin_unlock_irqrestore(&rkt->lock, flags);
 		goto ok;
 	}
 
 	mr = rkt->table[(rkey >> (32 - ib_qib_lkey_table_size))];
 	if (unlikely(mr == NULL || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
 		goto bail;
+	atomic_inc(&mr->refcount);
+	spin_unlock_irqrestore(&rkt->lock, flags);
 
 	off = vaddr - mr->iova;
 	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
 		     (mr->access_flags & acc) == 0))
-		goto bail;
+		return ret;
 
 	off += mr->offset;
-	m = 0;
-	n = 0;
-	while (off >= mr->map[m]->segs[n].length) {
-		off -= mr->map[m]->segs[n].length;
-		n++;
-		if (n >= QIB_SEGSZ) {
-			m++;
-			n = 0;
+	if (mr->page_shift) {
+		/*
+		page sizes are uniform power of 2 so no loop is necessary
+		entries_spanned_by_off is the number of times the loop below
+		would have executed.
+		*/
+		size_t entries_spanned_by_off;
+
+		entries_spanned_by_off = off >> mr->page_shift;
+		off -= (entries_spanned_by_off << mr->page_shift);
+		m = entries_spanned_by_off/QIB_SEGSZ;
+		n = entries_spanned_by_off%QIB_SEGSZ;
+	} else {
+		m = 0;
+		n = 0;
+		while (off >= mr->map[m]->segs[n].length) {
+			off -= mr->map[m]->segs[n].length;
+			n++;
+			if (n >= QIB_SEGSZ) {
+				m++;
+				n = 0;
+			}
 		}
 	}
-	atomic_inc(&mr->refcount);
 	sge->mr = mr;
 	sge->vaddr = mr->map[m]->segs[n].vaddr + off;
 	sge->length = mr->map[m]->segs[n].length - off;
@@ -269,6 +302,7 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 	sge->n = n;
 ok:
 	ret = 1;
+	return ret;
 bail:
 	spin_unlock_irqrestore(&rkt->lock, flags);
 	return ret;
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 5f95f0f..08944e2 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -39,7 +39,6 @@
 /* Fast memory region */
 struct qib_fmr {
 	struct ib_fmr ibfmr;
-	u8 page_shift;
 	struct qib_mregion mr;        /* must be last */
 };
 
@@ -107,6 +106,7 @@ static struct qib_mr *alloc_mr(int count, struct qib_lkey_table *lk_table)
 			goto bail;
 	}
 	mr->mr.mapsz = m;
+	mr->mr.page_shift = 0;
 	mr->mr.max_segs = count;
 
 	/*
@@ -231,6 +231,8 @@ struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->mr.access_flags = mr_access_flags;
 	mr->umem = umem;
 
+	if (is_power_of_2(umem->page_size))
+		mr->mr.page_shift = ilog2(umem->page_size);
 	m = 0;
 	n = 0;
 	list_for_each_entry(chunk, &umem->chunk_list, list) {
@@ -390,7 +392,7 @@ struct ib_fmr *qib_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 	fmr->mr.offset = 0;
 	fmr->mr.access_flags = mr_access_flags;
 	fmr->mr.max_segs = fmr_attr->max_pages;
-	fmr->page_shift = fmr_attr->page_shift;
+	fmr->mr.page_shift = fmr_attr->page_shift;
 
 	atomic_set(&fmr->mr.refcount, 0);
 	ret = &fmr->ibfmr;
@@ -437,7 +439,7 @@ int qib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 	spin_lock_irqsave(&rkt->lock, flags);
 	fmr->mr.user_base = iova;
 	fmr->mr.iova = iova;
-	ps = 1 << fmr->page_shift;
+	ps = 1 << fmr->mr.page_shift;
 	fmr->mr.length = list_len * ps;
 	m = 0;
 	n = 0;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index a08ceab..63b22a9 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -301,6 +301,7 @@ struct qib_mregion {
 	int access_flags;
 	u32 max_segs;           /* number of qib_segs in all the arrays */
 	u32 mapsz;              /* size of the map array */
+	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
 	atomic_t refcount;
 	struct qib_segarray *map[0];    /* the segments */
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
