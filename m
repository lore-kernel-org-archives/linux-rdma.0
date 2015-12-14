From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 05/15] IB/hfi1: Remove MR data structures from hfi1
Date: Mon, 14 Dec 2015 12:28:26 -0500
Message-ID: <20151214172824.11576.87974.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214172509.11576.19722.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove MR data structures from hfi1 and use the version in rdmavt

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/keys.c  |   30 +++++++++---------
 drivers/staging/rdma/hfi1/mr.c    |   22 ++++++-------
 drivers/staging/rdma/hfi1/ruc.c   |    4 +-
 drivers/staging/rdma/hfi1/sdma.h  |    2 +
 drivers/staging/rdma/hfi1/ud.c    |    2 +
 drivers/staging/rdma/hfi1/verbs.c |   16 +++++----
 drivers/staging/rdma/hfi1/verbs.h |   63 ++++++-------------------------------
 7 files changed, 48 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/keys.c b/drivers/staging/rdma/hfi1/keys.c
index 57a266f..ffaaa6f 100644
--- a/drivers/staging/rdma/hfi1/keys.c
+++ b/drivers/staging/rdma/hfi1/keys.c
@@ -63,21 +63,21 @@
  *
  */
 
-int hfi1_alloc_lkey(struct hfi1_mregion *mr, int dma_region)
+int hfi1_alloc_lkey(struct rvt_mregion *mr, int dma_region)
 {
 	unsigned long flags;
 	u32 r;
 	u32 n;
 	int ret = 0;
 	struct hfi1_ibdev *dev = to_idev(mr->pd->device);
-	struct hfi1_lkey_table *rkt = &dev->lk_table;
+	struct rvt_lkey_table *rkt = &dev->lk_table;
 
 	hfi1_get_mr(mr);
 	spin_lock_irqsave(&rkt->lock, flags);
 
 	/* special case for dma_mr lkey == 0 */
 	if (dma_region) {
-		struct hfi1_mregion *tmr;
+		struct rvt_mregion *tmr;
 
 		tmr = rcu_access_pointer(dev->dma_mr);
 		if (!tmr) {
@@ -133,13 +133,13 @@ bail:
  * hfi1_free_lkey - free an lkey
  * @mr: mr to free from tables
  */
-void hfi1_free_lkey(struct hfi1_mregion *mr)
+void hfi1_free_lkey(struct rvt_mregion *mr)
 {
 	unsigned long flags;
 	u32 lkey = mr->lkey;
 	u32 r;
 	struct hfi1_ibdev *dev = to_idev(mr->pd->device);
-	struct hfi1_lkey_table *rkt = &dev->lk_table;
+	struct rvt_lkey_table *rkt = &dev->lk_table;
 	int freed = 0;
 
 	spin_lock_irqsave(&rkt->lock, flags);
@@ -176,10 +176,10 @@ out:
  * Check the IB SGE for validity and initialize our internal version
  * of it.
  */
-int hfi1_lkey_ok(struct hfi1_lkey_table *rkt, struct rvt_pd *pd,
+int hfi1_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		 struct hfi1_sge *isge, struct ib_sge *sge, int acc)
 {
-	struct hfi1_mregion *mr;
+	struct rvt_mregion *mr;
 	unsigned n, m;
 	size_t off;
 
@@ -231,15 +231,15 @@ int hfi1_lkey_ok(struct hfi1_lkey_table *rkt, struct rvt_pd *pd,
 
 		entries_spanned_by_off = off >> mr->page_shift;
 		off -= (entries_spanned_by_off << mr->page_shift);
-		m = entries_spanned_by_off / HFI1_SEGSZ;
-		n = entries_spanned_by_off % HFI1_SEGSZ;
+		m = entries_spanned_by_off / RVT_SEGSZ;
+		n = entries_spanned_by_off % RVT_SEGSZ;
 	} else {
 		m = 0;
 		n = 0;
 		while (off >= mr->map[m]->segs[n].length) {
 			off -= mr->map[m]->segs[n].length;
 			n++;
-			if (n >= HFI1_SEGSZ) {
+			if (n >= RVT_SEGSZ) {
 				m++;
 				n = 0;
 			}
@@ -274,8 +274,8 @@ bail:
 int hfi1_rkey_ok(struct hfi1_qp *qp, struct hfi1_sge *sge,
 		 u32 len, u64 vaddr, u32 rkey, int acc)
 {
-	struct hfi1_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
-	struct hfi1_mregion *mr;
+	struct rvt_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
+	struct rvt_mregion *mr;
 	unsigned n, m;
 	size_t off;
 
@@ -328,15 +328,15 @@ int hfi1_rkey_ok(struct hfi1_qp *qp, struct hfi1_sge *sge,
 
 		entries_spanned_by_off = off >> mr->page_shift;
 		off -= (entries_spanned_by_off << mr->page_shift);
-		m = entries_spanned_by_off / HFI1_SEGSZ;
-		n = entries_spanned_by_off % HFI1_SEGSZ;
+		m = entries_spanned_by_off / RVT_SEGSZ;
+		n = entries_spanned_by_off % RVT_SEGSZ;
 	} else {
 		m = 0;
 		n = 0;
 		while (off >= mr->map[m]->segs[n].length) {
 			off -= mr->map[m]->segs[n].length;
 			n++;
-			if (n >= HFI1_SEGSZ) {
+			if (n >= RVT_SEGSZ) {
 				m++;
 				n = 0;
 			}
diff --git a/drivers/staging/rdma/hfi1/mr.c b/drivers/staging/rdma/hfi1/mr.c
index 02589b2..27f8081 100644
--- a/drivers/staging/rdma/hfi1/mr.c
+++ b/drivers/staging/rdma/hfi1/mr.c
@@ -56,7 +56,7 @@
 /* Fast memory region */
 struct hfi1_fmr {
 	struct ib_fmr ibfmr;
-	struct hfi1_mregion mr;        /* must be last */
+	struct rvt_mregion mr;        /* must be last */
 };
 
 static inline struct hfi1_fmr *to_ifmr(struct ib_fmr *ibfmr)
@@ -64,13 +64,13 @@ static inline struct hfi1_fmr *to_ifmr(struct ib_fmr *ibfmr)
 	return container_of(ibfmr, struct hfi1_fmr, ibfmr);
 }
 
-static int init_mregion(struct hfi1_mregion *mr, struct ib_pd *pd,
+static int init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
 			int count)
 {
 	int m, i = 0;
 	int rval = 0;
 
-	m = (count + HFI1_SEGSZ - 1) / HFI1_SEGSZ;
+	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
 	for (; i < m; i++) {
 		mr->map[i] = kzalloc(sizeof(*mr->map[0]), GFP_KERNEL);
 		if (!mr->map[i])
@@ -91,7 +91,7 @@ bail:
 	goto out;
 }
 
-static void deinit_mregion(struct hfi1_mregion *mr)
+static void deinit_mregion(struct rvt_mregion *mr)
 {
 	int i = mr->mapsz;
 
@@ -159,7 +159,7 @@ static struct hfi1_mr *alloc_mr(int count, struct ib_pd *pd)
 	int m;
 
 	/* Allocate struct plus pointers to first level page tables. */
-	m = (count + HFI1_SEGSZ - 1) / HFI1_SEGSZ;
+	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
 	mr = kzalloc(sizeof(*mr) + m * sizeof(mr->mr.map[0]), GFP_KERNEL);
 	if (!mr)
 		goto bail;
@@ -221,7 +221,7 @@ struct ib_mr *hfi1_reg_phys_mr(struct ib_pd *pd,
 		mr->mr.map[m]->segs[n].length = buffer_list[i].size;
 		mr->mr.length += buffer_list[i].size;
 		n++;
-		if (n == HFI1_SEGSZ) {
+		if (n == RVT_SEGSZ) {
 			m++;
 			n = 0;
 		}
@@ -294,7 +294,7 @@ struct ib_mr *hfi1_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		mr->mr.map[m]->segs[n].vaddr = vaddr;
 		mr->mr.map[m]->segs[n].length = umem->page_size;
 		n++;
-		if (n == HFI1_SEGSZ) {
+		if (n == RVT_SEGSZ) {
 			m++;
 			n = 0;
 		}
@@ -382,7 +382,7 @@ struct ib_fmr *hfi1_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 	int rval = -ENOMEM;
 
 	/* Allocate struct plus pointers to first level page tables. */
-	m = (fmr_attr->max_pages + HFI1_SEGSZ - 1) / HFI1_SEGSZ;
+	m = (fmr_attr->max_pages + RVT_SEGSZ - 1) / RVT_SEGSZ;
 	fmr = kzalloc(sizeof(*fmr) + m * sizeof(fmr->mr.map[0]), GFP_KERNEL);
 	if (!fmr)
 		goto bail;
@@ -434,7 +434,7 @@ int hfi1_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 		      int list_len, u64 iova)
 {
 	struct hfi1_fmr *fmr = to_ifmr(ibfmr);
-	struct hfi1_lkey_table *rkt;
+	struct rvt_lkey_table *rkt;
 	unsigned long flags;
 	int m, n, i;
 	u32 ps;
@@ -459,7 +459,7 @@ int hfi1_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 	for (i = 0; i < list_len; i++) {
 		fmr->mr.map[m]->segs[n].vaddr = (void *) page_list[i];
 		fmr->mr.map[m]->segs[n].length = ps;
-		if (++n == HFI1_SEGSZ) {
+		if (++n == RVT_SEGSZ) {
 			m++;
 			n = 0;
 		}
@@ -480,7 +480,7 @@ bail:
 int hfi1_unmap_fmr(struct list_head *fmr_list)
 {
 	struct hfi1_fmr *fmr;
-	struct hfi1_lkey_table *rkt;
+	struct rvt_lkey_table *rkt;
 	unsigned long flags;
 
 	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index eb7aea9..1c9c054 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -101,7 +101,7 @@ static int init_sge(struct hfi1_qp *qp, struct hfi1_rwqe *wqe)
 {
 	int i, j, ret;
 	struct ib_wc wc;
-	struct hfi1_lkey_table *rkt;
+	struct rvt_lkey_table *rkt;
 	struct rvt_pd *pd;
 	struct hfi1_sge_state *ss;
 
@@ -532,7 +532,7 @@ again:
 			if (--sqp->s_sge.num_sge)
 				*sge = *sqp->s_sge.sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= HFI1_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 85701ee..664b251 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -381,7 +381,7 @@ struct verbs_txreq {
 	struct sdma_txreq       txreq;
 	struct hfi1_qp           *qp;
 	struct hfi1_swqe         *wqe;
-	struct hfi1_mregion	*mr;
+	struct rvt_mregion	*mr;
 	struct hfi1_sge_state    *ss;
 	struct sdma_engine     *sde;
 	u16                     hdr_dwords;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 54ff1f5..969335a 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -211,7 +211,7 @@ static void ud_loopback(struct hfi1_qp *sqp, struct hfi1_swqe *swqe)
 			if (--ssge.num_sge)
 				*sge = *ssge.sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= HFI1_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 1390755..9abf691 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -300,7 +300,7 @@ void hfi1_copy_sge(
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= HFI1_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
@@ -341,7 +341,7 @@ void hfi1_skip_sge(struct hfi1_sge_state *ss, u32 length, int release)
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= HFI1_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
@@ -367,7 +367,7 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 	int i;
 	int j;
 	int acc;
-	struct hfi1_lkey_table *rkt;
+	struct rvt_lkey_table *rkt;
 	struct rvt_pd *pd;
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct hfi1_pportdata *ppd;
@@ -725,7 +725,7 @@ void update_sge(struct hfi1_sge_state *ss, u32 length)
 		if (--ss->num_sge)
 			*sge = *ss->sg_list++;
 	} else if (sge->length == 0 && sge->mr->lkey) {
-		if (++sge->n >= HFI1_SEGSZ) {
+		if (++sge->n >= RVT_SEGSZ) {
 			if (++sge->m >= sge->mr->mapsz)
 				return;
 			sge->n = 0;
@@ -1883,13 +1883,13 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	spin_lock_init(&dev->lk_table.lock);
 	dev->lk_table.max = 1 << hfi1_lkey_table_size;
 	/* ensure generation is at least 4 bits (keys.c) */
-	if (hfi1_lkey_table_size > MAX_LKEY_TABLE_BITS) {
+	if (hfi1_lkey_table_size > RVT_MAX_LKEY_TABLE_BITS) {
 		dd_dev_warn(dd, "lkey bits %u too large, reduced to %u\n",
-			      hfi1_lkey_table_size, MAX_LKEY_TABLE_BITS);
-		hfi1_lkey_table_size = MAX_LKEY_TABLE_BITS;
+			      hfi1_lkey_table_size, RVT_MAX_LKEY_TABLE_BITS);
+		hfi1_lkey_table_size = RVT_MAX_LKEY_TABLE_BITS;
 	}
 	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
-	dev->lk_table.table = (struct hfi1_mregion __rcu **)
+	dev->lk_table.table = (struct rvt_mregion __rcu **)
 		vmalloc(lk_tab_size);
 	if (dev->lk_table.table == NULL) {
 		ret = -ENOMEM;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 9043e5d..d80111f 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -285,44 +285,11 @@ struct hfi1_cq {
 };
 
 /*
- * A segment is a linear region of low physical memory.
- * Used by the verbs layer.
- */
-struct hfi1_seg {
-	void *vaddr;
-	size_t length;
-};
-
-/* The number of hfi1_segs that fit in a page. */
-#define HFI1_SEGSZ     (PAGE_SIZE / sizeof(struct hfi1_seg))
-
-struct hfi1_segarray {
-	struct hfi1_seg segs[HFI1_SEGSZ];
-};
-
-struct hfi1_mregion {
-	struct ib_pd *pd;       /* shares refcnt of ibmr.pd */
-	u64 user_base;          /* User's address for this region */
-	u64 iova;               /* IB start address of this region */
-	size_t length;
-	u32 lkey;
-	u32 offset;             /* offset (bytes) to start of region */
-	int access_flags;
-	u32 max_segs;           /* number of hfi1_segs in all the arrays */
-	u32 mapsz;              /* size of the map array */
-	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
-	u8  lkey_published;     /* in global table */
-	struct completion comp; /* complete when refcount goes to zero */
-	atomic_t refcount;
-	struct hfi1_segarray *map[0];    /* the segments */
-};
-
-/*
  * These keep track of the copy progress within a memory region.
  * Used by the verbs layer.
  */
 struct hfi1_sge {
-	struct hfi1_mregion *mr;
+	struct rvt_mregion *mr;
 	void *vaddr;            /* kernel virtual address of segment */
 	u32 sge_length;         /* length of the SGE */
 	u32 length;             /* remaining length of the segment */
@@ -334,7 +301,7 @@ struct hfi1_sge {
 struct hfi1_mr {
 	struct ib_mr ibmr;
 	struct ib_umem *umem;
-	struct hfi1_mregion mr;  /* must be last */
+	struct rvt_mregion mr;  /* must be last */
 };
 
 /*
@@ -500,7 +467,7 @@ struct hfi1_qp {
 	u32 s_flags;
 	struct hfi1_swqe *s_wqe;
 	struct hfi1_sge_state s_sge;     /* current send request data */
-	struct hfi1_mregion *s_rdma_mr;
+	struct rvt_mregion *s_rdma_mr;
 	struct sdma_engine *s_sde; /* current sde */
 	u32 s_cur_size;         /* size of send packet in bytes */
 	u32 s_len;              /* total length of s_sge */
@@ -655,16 +622,6 @@ static inline struct hfi1_rwqe *get_rwqe_ptr(struct hfi1_rq *rq, unsigned n)
 		  rq->max_sge * sizeof(struct ib_sge)) * n);
 }
 
-#define MAX_LKEY_TABLE_BITS 23
-
-struct hfi1_lkey_table {
-	spinlock_t lock; /* protect changes in this struct */
-	u32 next;               /* next unused index (speeds search) */
-	u32 gen;                /* generation count */
-	u32 max;                /* size of the table */
-	struct hfi1_mregion __rcu **table;
-};
-
 struct hfi1_opcode_stats {
 	u64 n_packets;          /* number of packets */
 	u64 n_bytes;            /* total number of bytes */
@@ -748,12 +705,12 @@ struct hfi1_ibdev {
 	struct list_head pending_mmaps;
 	spinlock_t mmap_offset_lock; /* protect mmap_offset */
 	u32 mmap_offset;
-	struct hfi1_mregion __rcu *dma_mr;
+	struct rvt_mregion __rcu *dma_mr;
 
 	struct hfi1_qp_ibdev *qp_dev;
 
 	/* QP numbers are shared by all IB ports */
-	struct hfi1_lkey_table lk_table;
+	struct rvt_lkey_table lk_table;
 	/* protect wait lists */
 	seqlock_t iowait_lock;
 	struct list_head txwait;        /* list for wait verbs_txreq */
@@ -966,11 +923,11 @@ void hfi1_ud_rcv(struct hfi1_packet *packet);
 
 int hfi1_lookup_pkey_idx(struct hfi1_ibport *ibp, u16 pkey);
 
-int hfi1_alloc_lkey(struct hfi1_mregion *mr, int dma_region);
+int hfi1_alloc_lkey(struct rvt_mregion *mr, int dma_region);
 
-void hfi1_free_lkey(struct hfi1_mregion *mr);
+void hfi1_free_lkey(struct rvt_mregion *mr);
 
-int hfi1_lkey_ok(struct hfi1_lkey_table *rkt, struct rvt_pd *pd,
+int hfi1_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		 struct hfi1_sge *isge, struct ib_sge *sge, int acc);
 
 int hfi1_rkey_ok(struct hfi1_qp *qp, struct hfi1_sge *sge,
@@ -1039,12 +996,12 @@ int hfi1_unmap_fmr(struct list_head *fmr_list);
 
 int hfi1_dealloc_fmr(struct ib_fmr *ibfmr);
 
-static inline void hfi1_get_mr(struct hfi1_mregion *mr)
+static inline void hfi1_get_mr(struct rvt_mregion *mr)
 {
 	atomic_inc(&mr->refcount);
 }
 
-static inline void hfi1_put_mr(struct hfi1_mregion *mr)
+static inline void hfi1_put_mr(struct rvt_mregion *mr)
 {
 	if (unlikely(atomic_dec_and_test(&mr->refcount)))
 		complete(&mr->comp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
