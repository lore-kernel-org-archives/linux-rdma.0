From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/10] IB/qib: Remove qp and mr functionality from qib
Date: Mon, 07 Dec 2015 15:49:25 -0500
Message-ID: <20151207204924.11219.77659.stgit@phlsvslse11.ph.intel.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204735.11219.68688.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove qp and mr support from qib and use rdmavt. These two changes
cannot be reasonably be split apart into separate patches because they
depend on eachother in multple places. This paves the way to remove
even more functions in subsequent patches.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Makefile          |    4 
 drivers/infiniband/hw/qib/qib.h             |   14 -
 drivers/infiniband/hw/qib/qib_cq.c          |    2 
 drivers/infiniband/hw/qib/qib_driver.c      |    4 
 drivers/infiniband/hw/qib/qib_keys.c        |  184 +--------
 drivers/infiniband/hw/qib/qib_mmap.c        |   18 -
 drivers/infiniband/hw/qib/qib_mr.c          |  539 ---------------------------
 drivers/infiniband/hw/qib/qib_qp.c          |   72 ++--
 drivers/infiniband/hw/qib/qib_rc.c          |   98 ++---
 drivers/infiniband/hw/qib/qib_ruc.c         |   58 +--
 drivers/infiniband/hw/qib/qib_sdma.c        |    8 
 drivers/infiniband/hw/qib/qib_srq.c         |   28 +
 drivers/infiniband/hw/qib/qib_uc.c          |    8 
 drivers/infiniband/hw/qib/qib_ud.c          |   16 -
 drivers/infiniband/hw/qib/qib_verbs.c       |  175 ++++-----
 drivers/infiniband/hw/qib/qib_verbs.h       |  436 +++-------------------
 drivers/infiniband/hw/qib/qib_verbs_mcast.c |    8 
 17 files changed, 308 insertions(+), 1364 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_mr.c

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
index 8a8f892..75140f5 100644
--- a/drivers/infiniband/hw/qib/Makefile
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -1,8 +1,8 @@
 obj-$(CONFIG_INFINIBAND_QIB) += ib_qib.o
 
 ib_qib-y := qib_cq.o qib_diag.o qib_driver.o qib_eeprom.o \
-	qib_file_ops.o qib_fs.o qib_init.o qib_intr.o qib_keys.o \
-	qib_mad.o qib_mmap.o qib_mr.o qib_pcie.o qib_pio_copy.o \
+	qib_file_ops.o qib_fs.o qib_init.o qib_intr.o \
+	qib_mad.o qib_mmap.o qib_pcie.o qib_pio_copy.o \
 	qib_qp.o qib_qsfp.o qib_rc.o qib_ruc.o qib_sdma.o qib_srq.o \
 	qib_sysfs.o qib_twsi.o qib_tx.o qib_uc.o qib_ud.o \
 	qib_user_pages.o qib_user_sdma.o qib_verbs_mcast.o qib_iba7220.o \
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index e610eaf..309b6f3 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -231,7 +231,7 @@ struct qib_ctxtdata {
 	/* ctxt rcvhdrq head offset */
 	u32 head;
 	/* lookaside fields */
-	struct qib_qp *lookaside_qp;
+	struct rvt_qp *lookaside_qp;
 	u32 lookaside_qpn;
 	/* QPs waiting for context processing */
 	struct list_head qp_wait_list;
@@ -241,7 +241,7 @@ struct qib_ctxtdata {
 #endif
 };
 
-struct qib_sge_state;
+struct rvt_sge_state;
 
 struct qib_sdma_txreq {
 	int                 flags;
@@ -259,14 +259,14 @@ struct qib_sdma_desc {
 
 struct qib_verbs_txreq {
 	struct qib_sdma_txreq   txreq;
-	struct qib_qp           *qp;
-	struct qib_swqe         *wqe;
+	struct rvt_qp           *qp;
+	struct rvt_swqe         *wqe;
 	u32                     dwords;
 	u16                     hdr_dwords;
 	u16                     hdr_inx;
 	struct qib_pio_header	*align_buf;
-	struct qib_mregion	*mr;
-	struct qib_sge_state    *ss;
+	struct rvt_mregion	*mr;
+	struct rvt_sge_state    *ss;
 };
 
 #define QIB_SDMA_TXREQ_F_USELARGEBUF  0x1
@@ -1324,7 +1324,7 @@ void __qib_sdma_intr(struct qib_pportdata *);
 void qib_sdma_intr(struct qib_pportdata *);
 void qib_user_sdma_send_desc(struct qib_pportdata *dd,
 			struct list_head *pktlist);
-int qib_sdma_verbs_send(struct qib_pportdata *, struct qib_sge_state *,
+int qib_sdma_verbs_send(struct qib_pportdata *, struct rvt_sge_state *,
 			u32, struct qib_verbs_txreq *);
 /* ppd->sdma_lock should be locked before calling this. */
 int qib_sdma_make_progress(struct qib_pportdata *dd);
diff --git a/drivers/infiniband/hw/qib/qib_cq.c b/drivers/infiniband/hw/qib/qib_cq.c
index 2b45d0b..c1ea21e 100644
--- a/drivers/infiniband/hw/qib/qib_cq.c
+++ b/drivers/infiniband/hw/qib/qib_cq.c
@@ -466,7 +466,7 @@ int qib_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 
 	if (cq->ip) {
 		struct qib_ibdev *dev = to_idev(ibcq->device);
-		struct qib_mmap_info *ip = cq->ip;
+		struct rvt_mmap_info *ip = cq->ip;
 
 		qib_update_mmap_info(dev, ip, sz, wc);
 
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index ae5a725..eafdee9 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -322,7 +322,7 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 		struct qib_ib_header *hdr = (struct qib_ib_header *) rhdr;
 		struct qib_other_headers *ohdr = NULL;
 		struct qib_ibport *ibp = &ppd->ibport_data;
-		struct qib_qp *qp = NULL;
+		struct rvt_qp *qp = NULL;
 		u32 tlen = qib_hdrget_length_in_bytes(rhf_addr);
 		u16 lid  = be16_to_cpu(hdr->lrh[1]);
 		int lnh = be16_to_cpu(hdr->lrh[0]) & 3;
@@ -472,7 +472,7 @@ u32 qib_kreceive(struct qib_ctxtdata *rcd, u32 *llic, u32 *npkts)
 	u32 eflags, etype, tlen, i = 0, updegr = 0, crcs = 0;
 	int last;
 	u64 lval;
-	struct qib_qp *qp, *nqp;
+	struct rvt_qp *qp, *nqp;
 
 	l = rcd->head;
 	rhf_addr = (__le32 *) rcd->rcvhdrq + l + dd->rhf_offset;
diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 04fa272..2c3c935 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -46,20 +46,20 @@
  *
  */
 
-int qib_alloc_lkey(struct qib_mregion *mr, int dma_region)
+int qib_alloc_lkey(struct rvt_mregion *mr, int dma_region)
 {
 	unsigned long flags;
 	u32 r;
 	u32 n;
 	int ret = 0;
 	struct qib_ibdev *dev = to_idev(mr->pd->device);
-	struct qib_lkey_table *rkt = &dev->lk_table;
+	struct rvt_lkey_table *rkt = &dev->lk_table;
 
 	spin_lock_irqsave(&rkt->lock, flags);
 
 	/* special case for dma_mr lkey == 0 */
 	if (dma_region) {
-		struct qib_mregion *tmr;
+		struct rvt_mregion *tmr;
 
 		tmr = rcu_access_pointer(dev->dma_mr);
 		if (!tmr) {
@@ -90,8 +90,8 @@ int qib_alloc_lkey(struct qib_mregion *mr, int dma_region)
 	 * bits are capped in qib_verbs.c to insure enough bits
 	 * for generation number
 	 */
-	mr->lkey = (r << (32 - ib_qib_lkey_table_size)) |
-		((((1 << (24 - ib_qib_lkey_table_size)) - 1) & rkt->gen)
+	mr->lkey = (r << (32 - ib_rvt_lkey_table_size)) |
+		((((1 << (24 - ib_rvt_lkey_table_size)) - 1) & rkt->gen)
 		 << 8);
 	if (mr->lkey == 0) {
 		mr->lkey |= 1 << 8;
@@ -114,13 +114,13 @@ bail:
  * qib_free_lkey - free an lkey
  * @mr: mr to free from tables
  */
-void qib_free_lkey(struct qib_mregion *mr)
+void qib_free_lkey(struct rvt_mregion *mr)
 {
 	unsigned long flags;
 	u32 lkey = mr->lkey;
 	u32 r;
 	struct qib_ibdev *dev = to_idev(mr->pd->device);
-	struct qib_lkey_table *rkt = &dev->lk_table;
+	struct rvt_lkey_table *rkt = &dev->lk_table;
 
 	spin_lock_irqsave(&rkt->lock, flags);
 	if (!mr->lkey_published)
@@ -128,7 +128,7 @@ void qib_free_lkey(struct qib_mregion *mr)
 	if (lkey == 0)
 		RCU_INIT_POINTER(dev->dma_mr, NULL);
 	else {
-		r = lkey >> (32 - ib_qib_lkey_table_size);
+		r = lkey >> (32 - ib_rvt_lkey_table_size);
 		RCU_INIT_POINTER(rkt->table[r], NULL);
 	}
 	qib_put_mr(mr);
@@ -138,105 +138,6 @@ out:
 }
 
 /**
- * qib_lkey_ok - check IB SGE for validity and initialize
- * @rkt: table containing lkey to check SGE against
- * @pd: protection domain
- * @isge: outgoing internal SGE
- * @sge: SGE to check
- * @acc: access flags
- *
- * Return 1 if valid and successful, otherwise returns 0.
- *
- * increments the reference count upon success
- *
- * Check the IB SGE for validity and initialize our internal version
- * of it.
- */
-int qib_lkey_ok(struct qib_lkey_table *rkt, struct rvt_pd *pd,
-		struct qib_sge *isge, struct ib_sge *sge, int acc)
-{
-	struct qib_mregion *mr;
-	unsigned n, m;
-	size_t off;
-
-	/*
-	 * We use LKEY == zero for kernel virtual addresses
-	 * (see qib_get_dma_mr and qib_dma.c).
-	 */
-	rcu_read_lock();
-	if (sge->lkey == 0) {
-		struct qib_ibdev *dev = to_idev(pd->ibpd.device);
-
-		if (pd->user)
-			goto bail;
-		mr = rcu_dereference(dev->dma_mr);
-		if (!mr)
-			goto bail;
-		if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
-			goto bail;
-		rcu_read_unlock();
-
-		isge->mr = mr;
-		isge->vaddr = (void *) sge->addr;
-		isge->length = sge->length;
-		isge->sge_length = sge->length;
-		isge->m = 0;
-		isge->n = 0;
-		goto ok;
-	}
-	mr = rcu_dereference(
-		rkt->table[(sge->lkey >> (32 - ib_qib_lkey_table_size))]);
-	if (unlikely(!mr || mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
-		goto bail;
-
-	off = sge->addr - mr->user_base;
-	if (unlikely(sge->addr < mr->user_base ||
-		     off + sge->length > mr->length ||
-		     (mr->access_flags & acc) != acc))
-		goto bail;
-	if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
-		goto bail;
-	rcu_read_unlock();
-
-	off += mr->offset;
-	if (mr->page_shift) {
-		/*
-		page sizes are uniform power of 2 so no loop is necessary
-		entries_spanned_by_off is the number of times the loop below
-		would have executed.
-		*/
-		size_t entries_spanned_by_off;
-
-		entries_spanned_by_off = off >> mr->page_shift;
-		off -= (entries_spanned_by_off << mr->page_shift);
-		m = entries_spanned_by_off/QIB_SEGSZ;
-		n = entries_spanned_by_off%QIB_SEGSZ;
-	} else {
-		m = 0;
-		n = 0;
-		while (off >= mr->map[m]->segs[n].length) {
-			off -= mr->map[m]->segs[n].length;
-			n++;
-			if (n >= QIB_SEGSZ) {
-				m++;
-				n = 0;
-			}
-		}
-	}
-	isge->mr = mr;
-	isge->vaddr = mr->map[m]->segs[n].vaddr + off;
-	isge->length = mr->map[m]->segs[n].length - off;
-	isge->sge_length = sge->length;
-	isge->m = m;
-	isge->n = n;
-ok:
-	return 1;
-bail:
-	rcu_read_unlock();
-	return 0;
-}
-
-/**
  * qib_rkey_ok - check the IB virtual address, length, and RKEY
  * @qp: qp for validation
  * @sge: SGE state
@@ -249,11 +150,11 @@ bail:
  *
  * increments the reference count upon success
  */
-int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
+int qib_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc)
 {
-	struct qib_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
-	struct qib_mregion *mr;
+	struct rvt_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
+	struct rvt_mregion *mr;
 	unsigned n, m;
 	size_t off;
 
@@ -285,7 +186,7 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 	}
 
 	mr = rcu_dereference(
-		rkt->table[(rkey >> (32 - ib_qib_lkey_table_size))]);
+		rkt->table[(rkey >> (32 - ib_rvt_lkey_table_size))]);
 	if (unlikely(!mr || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
 		goto bail;
 
@@ -308,15 +209,15 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 
 		entries_spanned_by_off = off >> mr->page_shift;
 		off -= (entries_spanned_by_off << mr->page_shift);
-		m = entries_spanned_by_off/QIB_SEGSZ;
-		n = entries_spanned_by_off%QIB_SEGSZ;
+		m = entries_spanned_by_off / RVT_SEGSZ;
+		n = entries_spanned_by_off % RVT_SEGSZ;
 	} else {
 		m = 0;
 		n = 0;
 		while (off >= mr->map[m]->segs[n].length) {
 			off -= mr->map[m]->segs[n].length;
 			n++;
-			if (n >= QIB_SEGSZ) {
+			if (n >= RVT_SEGSZ) {
 				m++;
 				n = 0;
 			}
@@ -335,58 +236,3 @@ bail:
 	return 0;
 }
 
-/*
- * Initialize the memory region specified by the work request.
- */
-int qib_reg_mr(struct qib_qp *qp, struct ib_reg_wr *wr)
-{
-	struct qib_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
-	struct rvt_pd *pd = ibpd_to_rvtpd(qp->ibqp.pd);
-	struct qib_mr *mr = to_imr(wr->mr);
-	struct qib_mregion *mrg;
-	u32 key = wr->key;
-	unsigned i, n, m;
-	int ret = -EINVAL;
-	unsigned long flags;
-	u64 *page_list;
-	size_t ps;
-
-	spin_lock_irqsave(&rkt->lock, flags);
-	if (pd->user || key == 0)
-		goto bail;
-
-	mrg = rcu_dereference_protected(
-		rkt->table[(key >> (32 - ib_qib_lkey_table_size))],
-		lockdep_is_held(&rkt->lock));
-	if (unlikely(mrg == NULL || qp->ibqp.pd != mrg->pd))
-		goto bail;
-
-	if (mr->npages > mrg->max_segs)
-		goto bail;
-
-	ps = mr->ibmr.page_size;
-	if (mr->ibmr.length > ps * mr->npages)
-		goto bail;
-
-	mrg->user_base = mr->ibmr.iova;
-	mrg->iova = mr->ibmr.iova;
-	mrg->lkey = key;
-	mrg->length = mr->ibmr.length;
-	mrg->access_flags = wr->access;
-	page_list = mr->pages;
-	m = 0;
-	n = 0;
-	for (i = 0; i < mr->npages; i++) {
-		mrg->map[m]->segs[n].vaddr = (void *) page_list[i];
-		mrg->map[m]->segs[n].length = ps;
-		if (++n == QIB_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-
-	ret = 0;
-bail:
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	return ret;
-}
diff --git a/drivers/infiniband/hw/qib/qib_mmap.c b/drivers/infiniband/hw/qib/qib_mmap.c
index 34927b7..c32078c 100644
--- a/drivers/infiniband/hw/qib/qib_mmap.c
+++ b/drivers/infiniband/hw/qib/qib_mmap.c
@@ -41,12 +41,12 @@
 
 /**
  * qib_release_mmap_info - free mmap info structure
- * @ref: a pointer to the kref within struct qib_mmap_info
+ * @ref: a pointer to the kref within struct rvt_mmap_info
  */
 void qib_release_mmap_info(struct kref *ref)
 {
-	struct qib_mmap_info *ip =
-		container_of(ref, struct qib_mmap_info, ref);
+	struct rvt_mmap_info *ip =
+		container_of(ref, struct rvt_mmap_info, ref);
 	struct qib_ibdev *dev = to_idev(ip->context->device);
 
 	spin_lock_irq(&dev->pending_lock);
@@ -63,14 +63,14 @@ void qib_release_mmap_info(struct kref *ref)
  */
 static void qib_vma_open(struct vm_area_struct *vma)
 {
-	struct qib_mmap_info *ip = vma->vm_private_data;
+	struct rvt_mmap_info *ip = vma->vm_private_data;
 
 	kref_get(&ip->ref);
 }
 
 static void qib_vma_close(struct vm_area_struct *vma)
 {
-	struct qib_mmap_info *ip = vma->vm_private_data;
+	struct rvt_mmap_info *ip = vma->vm_private_data;
 
 	kref_put(&ip->ref, qib_release_mmap_info);
 }
@@ -91,7 +91,7 @@ int qib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	struct qib_ibdev *dev = to_idev(context->device);
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long size = vma->vm_end - vma->vm_start;
-	struct qib_mmap_info *ip, *pp;
+	struct rvt_mmap_info *ip, *pp;
 	int ret = -EINVAL;
 
 	/*
@@ -128,11 +128,11 @@ done:
 /*
  * Allocate information for qib_mmap
  */
-struct qib_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev,
+struct rvt_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev,
 					   u32 size,
 					   struct ib_ucontext *context,
 					   void *obj) {
-	struct qib_mmap_info *ip;
+	struct rvt_mmap_info *ip;
 
 	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
 	if (!ip)
@@ -157,7 +157,7 @@ bail:
 	return ip;
 }
 
-void qib_update_mmap_info(struct qib_ibdev *dev, struct qib_mmap_info *ip,
+void qib_update_mmap_info(struct qib_ibdev *dev, struct rvt_mmap_info *ip,
 			  u32 size, void *obj)
 {
 	size = PAGE_ALIGN(size);
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
deleted file mode 100644
index 7fe4159..0000000
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ /dev/null
@@ -1,539 +0,0 @@
-/*
- * Copyright (c) 2006, 2007, 2008, 2009 QLogic Corporation. All rights reserved.
- * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#include <rdma/ib_umem.h>
-#include <rdma/ib_smi.h>
-
-#include "qib.h"
-
-/* Fast memory region */
-struct qib_fmr {
-	struct ib_fmr ibfmr;
-	struct qib_mregion mr;        /* must be last */
-};
-
-static inline struct qib_fmr *to_ifmr(struct ib_fmr *ibfmr)
-{
-	return container_of(ibfmr, struct qib_fmr, ibfmr);
-}
-
-static int init_qib_mregion(struct qib_mregion *mr, struct ib_pd *pd,
-	int count)
-{
-	int m, i = 0;
-	int rval = 0;
-
-	m = (count + QIB_SEGSZ - 1) / QIB_SEGSZ;
-	for (; i < m; i++) {
-		mr->map[i] = kzalloc(sizeof(*mr->map[0]), GFP_KERNEL);
-		if (!mr->map[i])
-			goto bail;
-	}
-	mr->mapsz = m;
-	init_completion(&mr->comp);
-	/* count returning the ptr to user */
-	atomic_set(&mr->refcount, 1);
-	mr->pd = pd;
-	mr->max_segs = count;
-out:
-	return rval;
-bail:
-	while (i)
-		kfree(mr->map[--i]);
-	rval = -ENOMEM;
-	goto out;
-}
-
-static void deinit_qib_mregion(struct qib_mregion *mr)
-{
-	int i = mr->mapsz;
-
-	mr->mapsz = 0;
-	while (i)
-		kfree(mr->map[--i]);
-}
-
-
-/**
- * qib_get_dma_mr - get a DMA memory region
- * @pd: protection domain for this memory region
- * @acc: access flags
- *
- * Returns the memory region on success, otherwise returns an errno.
- * Note that all DMA addresses should be created via the
- * struct ib_dma_mapping_ops functions (see qib_dma.c).
- */
-struct ib_mr *qib_get_dma_mr(struct ib_pd *pd, int acc)
-{
-	struct qib_mr *mr = NULL;
-	struct ib_mr *ret;
-	int rval;
-
-	if (ibpd_to_rvtpd(pd)->user) {
-		ret = ERR_PTR(-EPERM);
-		goto bail;
-	}
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr) {
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	rval = init_qib_mregion(&mr->mr, pd, 0);
-	if (rval) {
-		ret = ERR_PTR(rval);
-		goto bail;
-	}
-
-
-	rval = qib_alloc_lkey(&mr->mr, 1);
-	if (rval) {
-		ret = ERR_PTR(rval);
-		goto bail_mregion;
-	}
-
-	mr->mr.access_flags = acc;
-	ret = &mr->ibmr;
-done:
-	return ret;
-
-bail_mregion:
-	deinit_qib_mregion(&mr->mr);
-bail:
-	kfree(mr);
-	goto done;
-}
-
-static struct qib_mr *alloc_mr(int count, struct ib_pd *pd)
-{
-	struct qib_mr *mr;
-	int rval = -ENOMEM;
-	int m;
-
-	/* Allocate struct plus pointers to first level page tables. */
-	m = (count + QIB_SEGSZ - 1) / QIB_SEGSZ;
-	mr = kzalloc(sizeof(*mr) + m * sizeof(mr->mr.map[0]), GFP_KERNEL);
-	if (!mr)
-		goto bail;
-
-	rval = init_qib_mregion(&mr->mr, pd, count);
-	if (rval)
-		goto bail;
-	/*
-	 * ib_reg_phys_mr() will initialize mr->ibmr except for
-	 * lkey and rkey.
-	 */
-	rval = qib_alloc_lkey(&mr->mr, 0);
-	if (rval)
-		goto bail_mregion;
-	mr->ibmr.lkey = mr->mr.lkey;
-	mr->ibmr.rkey = mr->mr.lkey;
-done:
-	return mr;
-
-bail_mregion:
-	deinit_qib_mregion(&mr->mr);
-bail:
-	kfree(mr);
-	mr = ERR_PTR(rval);
-	goto done;
-}
-
-/**
- * qib_reg_phys_mr - register a physical memory region
- * @pd: protection domain for this memory region
- * @buffer_list: pointer to the list of physical buffers to register
- * @num_phys_buf: the number of physical buffers to register
- * @iova_start: the starting address passed over IB which maps to this MR
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_mr *qib_reg_phys_mr(struct ib_pd *pd,
-			      struct ib_phys_buf *buffer_list,
-			      int num_phys_buf, int acc, u64 *iova_start)
-{
-	struct qib_mr *mr;
-	int n, m, i;
-	struct ib_mr *ret;
-
-	mr = alloc_mr(num_phys_buf, pd);
-	if (IS_ERR(mr)) {
-		ret = (struct ib_mr *)mr;
-		goto bail;
-	}
-
-	mr->mr.user_base = *iova_start;
-	mr->mr.iova = *iova_start;
-	mr->mr.access_flags = acc;
-
-	m = 0;
-	n = 0;
-	for (i = 0; i < num_phys_buf; i++) {
-		mr->mr.map[m]->segs[n].vaddr = (void *) buffer_list[i].addr;
-		mr->mr.map[m]->segs[n].length = buffer_list[i].size;
-		mr->mr.length += buffer_list[i].size;
-		n++;
-		if (n == QIB_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-
-	ret = &mr->ibmr;
-
-bail:
-	return ret;
-}
-
-/**
- * qib_reg_user_mr - register a userspace memory region
- * @pd: protection domain for this memory region
- * @start: starting userspace address
- * @length: length of region to register
- * @mr_access_flags: access flags for this memory region
- * @udata: unused by the QLogic_IB driver
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-			      u64 virt_addr, int mr_access_flags,
-			      struct ib_udata *udata)
-{
-	struct qib_mr *mr;
-	struct ib_umem *umem;
-	struct scatterlist *sg;
-	int n, m, entry;
-	struct ib_mr *ret;
-
-	if (length == 0) {
-		ret = ERR_PTR(-EINVAL);
-		goto bail;
-	}
-
-	umem = ib_umem_get(pd->uobject->context, start, length,
-			   mr_access_flags, 0);
-	if (IS_ERR(umem))
-		return (void *) umem;
-
-	n = umem->nmap;
-
-	mr = alloc_mr(n, pd);
-	if (IS_ERR(mr)) {
-		ret = (struct ib_mr *)mr;
-		ib_umem_release(umem);
-		goto bail;
-	}
-
-	mr->mr.user_base = start;
-	mr->mr.iova = virt_addr;
-	mr->mr.length = length;
-	mr->mr.offset = ib_umem_offset(umem);
-	mr->mr.access_flags = mr_access_flags;
-	mr->umem = umem;
-
-	if (is_power_of_2(umem->page_size))
-		mr->mr.page_shift = ilog2(umem->page_size);
-	m = 0;
-	n = 0;
-	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-			void *vaddr;
-
-			vaddr = page_address(sg_page(sg));
-			if (!vaddr) {
-				ret = ERR_PTR(-EINVAL);
-				goto bail;
-			}
-			mr->mr.map[m]->segs[n].vaddr = vaddr;
-			mr->mr.map[m]->segs[n].length = umem->page_size;
-			n++;
-			if (n == QIB_SEGSZ) {
-				m++;
-				n = 0;
-			}
-	}
-	ret = &mr->ibmr;
-
-bail:
-	return ret;
-}
-
-/**
- * qib_dereg_mr - unregister and free a memory region
- * @ibmr: the memory region to free
- *
- * Returns 0 on success.
- *
- * Note that this is called to free MRs created by qib_get_dma_mr()
- * or qib_reg_user_mr().
- */
-int qib_dereg_mr(struct ib_mr *ibmr)
-{
-	struct qib_mr *mr = to_imr(ibmr);
-	int ret = 0;
-	unsigned long timeout;
-
-	kfree(mr->pages);
-	qib_free_lkey(&mr->mr);
-
-	qib_put_mr(&mr->mr); /* will set completion if last */
-	timeout = wait_for_completion_timeout(&mr->mr.comp,
-		5 * HZ);
-	if (!timeout) {
-		qib_get_mr(&mr->mr);
-		ret = -EBUSY;
-		goto out;
-	}
-	deinit_qib_mregion(&mr->mr);
-	if (mr->umem)
-		ib_umem_release(mr->umem);
-	kfree(mr);
-out:
-	return ret;
-}
-
-/*
- * Allocate a memory region usable with the
- * IB_WR_REG_MR send work request.
- *
- * Return the memory region on success, otherwise return an errno.
- */
-struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
-			   enum ib_mr_type mr_type,
-			   u32 max_num_sg)
-{
-	struct qib_mr *mr;
-
-	if (mr_type != IB_MR_TYPE_MEM_REG)
-		return ERR_PTR(-EINVAL);
-
-	mr = alloc_mr(max_num_sg, pd);
-	if (IS_ERR(mr))
-		return (struct ib_mr *)mr;
-
-	mr->pages = kcalloc(max_num_sg, sizeof(u64), GFP_KERNEL);
-	if (!mr->pages)
-		goto err;
-
-	return &mr->ibmr;
-
-err:
-	qib_dereg_mr(&mr->ibmr);
-	return ERR_PTR(-ENOMEM);
-}
-
-static int qib_set_page(struct ib_mr *ibmr, u64 addr)
-{
-	struct qib_mr *mr = to_imr(ibmr);
-
-	if (unlikely(mr->npages == mr->mr.max_segs))
-		return -ENOMEM;
-
-	mr->pages[mr->npages++] = addr;
-
-	return 0;
-}
-
-int qib_map_mr_sg(struct ib_mr *ibmr,
-		  struct scatterlist *sg,
-		  int sg_nents)
-{
-	struct qib_mr *mr = to_imr(ibmr);
-
-	mr->npages = 0;
-
-	return ib_sg_to_pages(ibmr, sg, sg_nents, qib_set_page);
-}
-
-/**
- * qib_alloc_fmr - allocate a fast memory region
- * @pd: the protection domain for this memory region
- * @mr_access_flags: access flags for this memory region
- * @fmr_attr: fast memory region attributes
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_fmr *qib_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			     struct ib_fmr_attr *fmr_attr)
-{
-	struct qib_fmr *fmr;
-	int m;
-	struct ib_fmr *ret;
-	int rval = -ENOMEM;
-
-	/* Allocate struct plus pointers to first level page tables. */
-	m = (fmr_attr->max_pages + QIB_SEGSZ - 1) / QIB_SEGSZ;
-	fmr = kzalloc(sizeof(*fmr) + m * sizeof(fmr->mr.map[0]), GFP_KERNEL);
-	if (!fmr)
-		goto bail;
-
-	rval = init_qib_mregion(&fmr->mr, pd, fmr_attr->max_pages);
-	if (rval)
-		goto bail;
-
-	/*
-	 * ib_alloc_fmr() will initialize fmr->ibfmr except for lkey &
-	 * rkey.
-	 */
-	rval = qib_alloc_lkey(&fmr->mr, 0);
-	if (rval)
-		goto bail_mregion;
-	fmr->ibfmr.rkey = fmr->mr.lkey;
-	fmr->ibfmr.lkey = fmr->mr.lkey;
-	/*
-	 * Resources are allocated but no valid mapping (RKEY can't be
-	 * used).
-	 */
-	fmr->mr.access_flags = mr_access_flags;
-	fmr->mr.max_segs = fmr_attr->max_pages;
-	fmr->mr.page_shift = fmr_attr->page_shift;
-
-	ret = &fmr->ibfmr;
-done:
-	return ret;
-
-bail_mregion:
-	deinit_qib_mregion(&fmr->mr);
-bail:
-	kfree(fmr);
-	ret = ERR_PTR(rval);
-	goto done;
-}
-
-/**
- * qib_map_phys_fmr - set up a fast memory region
- * @ibmfr: the fast memory region to set up
- * @page_list: the list of pages to associate with the fast memory region
- * @list_len: the number of pages to associate with the fast memory region
- * @iova: the virtual address of the start of the fast memory region
- *
- * This may be called from interrupt context.
- */
-
-int qib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		     int list_len, u64 iova)
-{
-	struct qib_fmr *fmr = to_ifmr(ibfmr);
-	struct qib_lkey_table *rkt;
-	unsigned long flags;
-	int m, n, i;
-	u32 ps;
-	int ret;
-
-	i = atomic_read(&fmr->mr.refcount);
-	if (i > 2)
-		return -EBUSY;
-
-	if (list_len > fmr->mr.max_segs) {
-		ret = -EINVAL;
-		goto bail;
-	}
-	rkt = &to_idev(ibfmr->device)->lk_table;
-	spin_lock_irqsave(&rkt->lock, flags);
-	fmr->mr.user_base = iova;
-	fmr->mr.iova = iova;
-	ps = 1 << fmr->mr.page_shift;
-	fmr->mr.length = list_len * ps;
-	m = 0;
-	n = 0;
-	for (i = 0; i < list_len; i++) {
-		fmr->mr.map[m]->segs[n].vaddr = (void *) page_list[i];
-		fmr->mr.map[m]->segs[n].length = ps;
-		if (++n == QIB_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	ret = 0;
-
-bail:
-	return ret;
-}
-
-/**
- * qib_unmap_fmr - unmap fast memory regions
- * @fmr_list: the list of fast memory regions to unmap
- *
- * Returns 0 on success.
- */
-int qib_unmap_fmr(struct list_head *fmr_list)
-{
-	struct qib_fmr *fmr;
-	struct qib_lkey_table *rkt;
-	unsigned long flags;
-
-	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
-		rkt = &to_idev(fmr->ibfmr.device)->lk_table;
-		spin_lock_irqsave(&rkt->lock, flags);
-		fmr->mr.user_base = 0;
-		fmr->mr.iova = 0;
-		fmr->mr.length = 0;
-		spin_unlock_irqrestore(&rkt->lock, flags);
-	}
-	return 0;
-}
-
-/**
- * qib_dealloc_fmr - deallocate a fast memory region
- * @ibfmr: the fast memory region to deallocate
- *
- * Returns 0 on success.
- */
-int qib_dealloc_fmr(struct ib_fmr *ibfmr)
-{
-	struct qib_fmr *fmr = to_ifmr(ibfmr);
-	int ret = 0;
-	unsigned long timeout;
-
-	qib_free_lkey(&fmr->mr);
-	qib_put_mr(&fmr->mr); /* will set completion if last */
-	timeout = wait_for_completion_timeout(&fmr->mr.comp,
-		5 * HZ);
-	if (!timeout) {
-		qib_get_mr(&fmr->mr);
-		ret = -EBUSY;
-		goto out;
-	}
-	deinit_qib_mregion(&fmr->mr);
-	kfree(fmr);
-out:
-	return ret;
-}
-
-void mr_rcu_callback(struct rcu_head *list)
-{
-	struct qib_mregion *mr = container_of(list, struct qib_mregion, list);
-
-	complete(&mr->comp);
-}
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 7e570be..143924d 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -220,7 +220,7 @@ static inline unsigned qpn_hash(struct qib_ibdev *dev, u32 qpn)
  * Put the QP into the hash table.
  * The hash table holds a reference to the QP.
  */
-static void insert_qp(struct qib_ibdev *dev, struct qib_qp *qp)
+static void insert_qp(struct qib_ibdev *dev, struct rvt_qp *qp)
 {
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	unsigned long flags;
@@ -245,7 +245,7 @@ static void insert_qp(struct qib_ibdev *dev, struct qib_qp *qp)
  * Remove the QP from the table so it can't be found asynchronously by
  * the receive interrupt routine.
  */
-static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
+static void remove_qp(struct qib_ibdev *dev, struct rvt_qp *qp)
 {
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	unsigned n = qpn_hash(dev, qp->ibqp.qp_num);
@@ -261,8 +261,8 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 			lockdep_is_held(&dev->qpt_lock)) == qp) {
 		RCU_INIT_POINTER(ibp->qp1, NULL);
 	} else {
-		struct qib_qp *q;
-		struct qib_qp __rcu **qpp;
+		struct rvt_qp *q;
+		struct rvt_qp __rcu **qpp;
 
 		removed = 0;
 		qpp = &dev->qp_table[n];
@@ -296,7 +296,7 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
 {
 	struct qib_ibdev *dev = &dd->verbs_dev;
 	unsigned long flags;
-	struct qib_qp *qp;
+	struct rvt_qp *qp;
 	unsigned n, qp_inuse = 0;
 
 	for (n = 0; n < dd->num_pports; n++) {
@@ -336,9 +336,9 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
  * The caller is responsible for decrementing the QP reference count
  * when done.
  */
-struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
+struct rvt_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
 {
-	struct qib_qp *qp = NULL;
+	struct rvt_qp *qp = NULL;
 
 	rcu_read_lock();
 	if (unlikely(qpn <= 1)) {
@@ -368,7 +368,7 @@ struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
  * @qp: the QP to reset
  * @type: the QP type
  */
-static void qib_reset_qp(struct qib_qp *qp, enum ib_qp_type type)
+static void qib_reset_qp(struct rvt_qp *qp, enum ib_qp_type type)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	qp->remote_qpn = 0;
@@ -416,7 +416,7 @@ static void qib_reset_qp(struct qib_qp *qp, enum ib_qp_type type)
 	qp->r_sge.num_sge = 0;
 }
 
-static void clear_mr_refs(struct qib_qp *qp, int clr_sends)
+static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 {
 	unsigned n;
 
@@ -427,13 +427,13 @@ static void clear_mr_refs(struct qib_qp *qp, int clr_sends)
 
 	if (clr_sends) {
 		while (qp->s_last != qp->s_head) {
-			struct qib_swqe *wqe = get_swqe_ptr(qp, qp->s_last);
+			struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_last);
 			unsigned i;
 
 			for (i = 0; i < wqe->wr.num_sge; i++) {
-				struct qib_sge *sge = &wqe->sg_list[i];
+				struct rvt_sge *sge = &wqe->sg_list[i];
 
-				qib_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			}
 			if (qp->ibqp.qp_type == IB_QPT_UD ||
 			    qp->ibqp.qp_type == IB_QPT_SMI ||
@@ -443,7 +443,7 @@ static void clear_mr_refs(struct qib_qp *qp, int clr_sends)
 				qp->s_last = 0;
 		}
 		if (qp->s_rdma_mr) {
-			qib_put_mr(qp->s_rdma_mr);
+			rvt_put_mr(qp->s_rdma_mr);
 			qp->s_rdma_mr = NULL;
 		}
 	}
@@ -452,11 +452,11 @@ static void clear_mr_refs(struct qib_qp *qp, int clr_sends)
 		return;
 
 	for (n = 0; n < ARRAY_SIZE(qp->s_ack_queue); n++) {
-		struct qib_ack_entry *e = &qp->s_ack_queue[n];
+		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
 
 		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
 		    e->rdma_sge.mr) {
-			qib_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 	}
@@ -472,7 +472,7 @@ static void clear_mr_refs(struct qib_qp *qp, int clr_sends)
  * The QP r_lock and s_lock should be held and interrupts disabled.
  * If we are already in error state, just return.
  */
-int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err)
+int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
@@ -502,7 +502,7 @@ int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err)
 	if (!(qp->s_flags & QIB_S_BUSY)) {
 		qp->s_hdrwords = 0;
 		if (qp->s_rdma_mr) {
-			qib_put_mr(qp->s_rdma_mr);
+			rvt_put_mr(qp->s_rdma_mr);
 			qp->s_rdma_mr = NULL;
 		}
 		if (priv->s_tx) {
@@ -529,7 +529,7 @@ int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err)
 	wc.status = IB_WC_WR_FLUSH_ERR;
 
 	if (qp->r_rq.wq) {
-		struct qib_rwq *wq;
+		struct rvt_rwq *wq;
 		u32 head;
 		u32 tail;
 
@@ -572,7 +572,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_udata *udata)
 {
 	struct qib_ibdev *dev = to_idev(ibqp->device);
-	struct qib_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct qib_qp_priv *priv = qp->priv;
 	enum ib_qp_state cur_state, new_state;
 	struct ib_event ev;
@@ -860,7 +860,7 @@ bail:
 int qib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		 int attr_mask, struct ib_qp_init_attr *init_attr)
 {
-	struct qib_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 
 	attr->qp_state = qp->state;
 	attr->cur_qp_state = attr->qp_state;
@@ -913,7 +913,7 @@ int qib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
  *
  * Returns the AETH.
  */
-__be32 qib_compute_aeth(struct qib_qp *qp)
+__be32 qib_compute_aeth(struct rvt_qp *qp)
 {
 	u32 aeth = qp->r_msn & QIB_MSN_MASK;
 
@@ -926,7 +926,7 @@ __be32 qib_compute_aeth(struct qib_qp *qp)
 	} else {
 		u32 min, max, x;
 		u32 credits;
-		struct qib_rwq *wq = qp->r_rq.wq;
+		struct rvt_rwq *wq = qp->r_rq.wq;
 		u32 head;
 		u32 tail;
 
@@ -981,9 +981,9 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata)
 {
-	struct qib_qp *qp;
+	struct rvt_qp *qp;
 	int err;
-	struct qib_swqe *swq = NULL;
+	struct rvt_swqe *swq = NULL;
 	struct qib_ibdev *dev;
 	struct qib_devdata *dd;
 	size_t sz;
@@ -1025,9 +1025,9 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 	case IB_QPT_UC:
 	case IB_QPT_RC:
 	case IB_QPT_UD:
-		sz = sizeof(struct qib_sge) *
+		sz = sizeof(struct rvt_sge) *
 			init_attr->cap.max_send_sge +
-			sizeof(struct qib_swqe);
+			sizeof(struct rvt_swqe);
 		swq = vmalloc((init_attr->cap.max_send_wr + 1) * sz);
 		if (swq == NULL) {
 			ret = ERR_PTR(-ENOMEM);
@@ -1071,8 +1071,8 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 			qp->r_rq.size = init_attr->cap.max_recv_wr + 1;
 			qp->r_rq.max_sge = init_attr->cap.max_recv_sge;
 			sz = (sizeof(struct ib_sge) * qp->r_rq.max_sge) +
-				sizeof(struct qib_rwqe);
-			qp->r_rq.wq = vmalloc_user(sizeof(struct qib_rwq) +
+				sizeof(struct rvt_rwqe);
+			qp->r_rq.wq = vmalloc_user(sizeof(struct rvt_rwq) +
 						   qp->r_rq.size * sz);
 			if (!qp->r_rq.wq) {
 				ret = ERR_PTR(-ENOMEM);
@@ -1138,7 +1138,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 				goto bail_ip;
 			}
 		} else {
-			u32 s = sizeof(struct qib_rwq) + qp->r_rq.size * sz;
+			u32 s = sizeof(struct rvt_rwq) + qp->r_rq.size * sz;
 
 			qp->ip = qib_create_mmap_info(dev, s,
 						      ibpd->uobject->context,
@@ -1204,7 +1204,7 @@ bail:
  */
 int qib_destroy_qp(struct ib_qp *ibqp)
 {
-	struct qib_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct qib_ibdev *dev = to_idev(ibqp->device);
 	struct qib_qp_priv *priv = qp->priv;
 
@@ -1280,7 +1280,7 @@ void qib_free_qpn_table(struct qib_qpn_table *qpt)
  *
  * The QP s_lock should be held.
  */
-void qib_get_credit(struct qib_qp *qp, u32 aeth)
+void qib_get_credit(struct rvt_qp *qp, u32 aeth)
 {
 	u32 credit = (aeth >> QIB_AETH_CREDIT_SHIFT) & QIB_AETH_CREDIT_MASK;
 
@@ -1314,7 +1314,7 @@ void qib_get_credit(struct qib_qp *qp, u32 aeth)
 
 struct qib_qp_iter {
 	struct qib_ibdev *dev;
-	struct qib_qp *qp;
+	struct rvt_qp *qp;
 	int n;
 };
 
@@ -1340,8 +1340,8 @@ int qib_qp_iter_next(struct qib_qp_iter *iter)
 	struct qib_ibdev *dev = iter->dev;
 	int n = iter->n;
 	int ret = 1;
-	struct qib_qp *pqp = iter->qp;
-	struct qib_qp *qp;
+	struct rvt_qp *pqp = iter->qp;
+	struct rvt_qp *qp;
 
 	for (; n < dev->qp_table_size; n++) {
 		if (pqp)
@@ -1364,8 +1364,8 @@ static const char * const qp_type_str[] = {
 
 void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter)
 {
-	struct qib_swqe *wqe;
-	struct qib_qp *qp = iter->qp;
+	struct rvt_swqe *wqe;
+	struct rvt_qp *qp = iter->qp;
 	struct qib_qp_priv *priv = qp->priv;
 
 	wqe = get_swqe_ptr(qp, qp->s_last);
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 1506c02..46e6c97 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -40,7 +40,7 @@
 
 static void rc_timeout(unsigned long arg);
 
-static u32 restart_sge(struct qib_sge_state *ss, struct qib_swqe *wqe,
+static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 		       u32 psn, u32 pmtu)
 {
 	u32 len;
@@ -54,7 +54,7 @@ static u32 restart_sge(struct qib_sge_state *ss, struct qib_swqe *wqe,
 	return wqe->length - len;
 }
 
-static void start_timer(struct qib_qp *qp)
+static void start_timer(struct rvt_qp *qp)
 {
 	qp->s_flags |= QIB_S_TIMER;
 	qp->s_timer.function = rc_timeout;
@@ -74,10 +74,10 @@ static void start_timer(struct qib_qp *qp)
  * Note that we are in the responder's side of the QP context.
  * Note the QP s_lock must be held.
  */
-static int qib_make_rc_ack(struct qib_ibdev *dev, struct qib_qp *qp,
+static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 			   struct qib_other_headers *ohdr, u32 pmtu)
 {
-	struct qib_ack_entry *e;
+	struct rvt_ack_entry *e;
 	u32 hwords;
 	u32 len;
 	u32 bth0;
@@ -95,7 +95,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct qib_qp *qp,
 	case OP(RDMA_READ_RESPONSE_ONLY):
 		e = &qp->s_ack_queue[qp->s_tail_ack_queue];
 		if (e->rdma_sge.mr) {
-			qib_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		/* FALLTHROUGH */
@@ -133,7 +133,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct qib_qp *qp,
 			/* Copy SGE state in case we need to resend */
 			qp->s_rdma_mr = e->rdma_sge.mr;
 			if (qp->s_rdma_mr)
-				qib_get_mr(qp->s_rdma_mr);
+				rvt_get_mr(qp->s_rdma_mr);
 			qp->s_ack_rdma_sge.sge = e->rdma_sge;
 			qp->s_ack_rdma_sge.num_sge = 1;
 			qp->s_cur_sge = &qp->s_ack_rdma_sge;
@@ -172,7 +172,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct qib_qp *qp,
 		qp->s_cur_sge = &qp->s_ack_rdma_sge;
 		qp->s_rdma_mr = qp->s_ack_rdma_sge.sge.mr;
 		if (qp->s_rdma_mr)
-			qib_get_mr(qp->s_rdma_mr);
+			rvt_get_mr(qp->s_rdma_mr);
 		len = qp->s_ack_rdma_sge.sge.sge_length;
 		if (len > pmtu)
 			len = pmtu;
@@ -228,13 +228,13 @@ bail:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int qib_make_rc_req(struct qib_qp *qp)
+int qib_make_rc_req(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
 	struct qib_other_headers *ohdr;
-	struct qib_sge_state *ss;
-	struct qib_swqe *wqe;
+	struct rvt_sge_state *ss;
+	struct rvt_swqe *wqe;
 	u32 hwords;
 	u32 len;
 	u32 bth0;
@@ -648,7 +648,7 @@ unlock:
  * Note that RDMA reads and atomics are handled in the
  * send side QP state and tasklet.
  */
-void qib_send_rc_ack(struct qib_qp *qp)
+void qib_send_rc_ack(struct rvt_qp *qp)
 {
 	struct qib_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
@@ -783,10 +783,10 @@ done:
  * for the given QP.
  * Called at interrupt level with the QP s_lock held.
  */
-static void reset_psn(struct qib_qp *qp, u32 psn)
+static void reset_psn(struct rvt_qp *qp, u32 psn)
 {
 	u32 n = qp->s_acked;
-	struct qib_swqe *wqe = get_swqe_ptr(qp, n);
+	struct rvt_swqe *wqe = get_swqe_ptr(qp, n);
 	u32 opcode;
 
 	qp->s_cur = n;
@@ -868,9 +868,9 @@ done:
  * Back up requester to resend the last un-ACKed request.
  * The QP r_lock and s_lock should be held and interrupts disabled.
  */
-static void qib_restart_rc(struct qib_qp *qp, u32 psn, int wait)
+static void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 {
-	struct qib_swqe *wqe = get_swqe_ptr(qp, qp->s_acked);
+	struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_acked);
 	struct qib_ibport *ibp;
 
 	if (qp->s_retry == 0) {
@@ -905,7 +905,7 @@ static void qib_restart_rc(struct qib_qp *qp, u32 psn, int wait)
  */
 static void rc_timeout(unsigned long arg)
 {
-	struct qib_qp *qp = (struct qib_qp *)arg;
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
 	struct qib_ibport *ibp;
 	unsigned long flags;
 
@@ -928,7 +928,7 @@ static void rc_timeout(unsigned long arg)
  */
 void qib_rc_rnr_retry(unsigned long arg)
 {
-	struct qib_qp *qp = (struct qib_qp *)arg;
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
@@ -944,9 +944,9 @@ void qib_rc_rnr_retry(unsigned long arg)
  * Set qp->s_sending_psn to the next PSN after the given one.
  * This would be psn+1 except when RDMA reads are present.
  */
-static void reset_sending_psn(struct qib_qp *qp, u32 psn)
+static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 {
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 	u32 n = qp->s_last;
 
 	/* Find the work request corresponding to the given PSN. */
@@ -969,10 +969,10 @@ static void reset_sending_psn(struct qib_qp *qp, u32 psn)
 /*
  * This should be called with the QP s_lock held and interrupts disabled.
  */
-void qib_rc_send_complete(struct qib_qp *qp, struct qib_ib_header *hdr)
+void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 {
 	struct qib_other_headers *ohdr;
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 	struct ib_wc wc;
 	unsigned i;
 	u32 opcode;
@@ -1013,9 +1013,9 @@ void qib_rc_send_complete(struct qib_qp *qp, struct qib_ib_header *hdr)
 		    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
 		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct qib_sge *sge = &wqe->sg_list[i];
+			struct rvt_sge *sge = &wqe->sg_list[i];
 
-			qib_put_mr(sge->mr);
+			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
 		if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
@@ -1044,7 +1044,7 @@ void qib_rc_send_complete(struct qib_qp *qp, struct qib_ib_header *hdr)
 	}
 }
 
-static inline void update_last_psn(struct qib_qp *qp, u32 psn)
+static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 {
 	qp->s_last_psn = psn;
 }
@@ -1054,8 +1054,8 @@ static inline void update_last_psn(struct qib_qp *qp, u32 psn)
  * This is similar to qib_send_complete but has to check to be sure
  * that the SGEs are not being referenced if the SWQE is being resent.
  */
-static struct qib_swqe *do_rc_completion(struct qib_qp *qp,
-					 struct qib_swqe *wqe,
+static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
+					 struct rvt_swqe *wqe,
 					 struct qib_ibport *ibp)
 {
 	struct ib_wc wc;
@@ -1069,9 +1069,9 @@ static struct qib_swqe *do_rc_completion(struct qib_qp *qp,
 	if (qib_cmp24(wqe->lpsn, qp->s_sending_psn) < 0 ||
 	    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
 		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct qib_sge *sge = &wqe->sg_list[i];
+			struct rvt_sge *sge = &wqe->sg_list[i];
 
-			qib_put_mr(sge->mr);
+			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
 		if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
@@ -1127,12 +1127,12 @@ static struct qib_swqe *do_rc_completion(struct qib_qp *qp,
  * Called at interrupt level with the QP s_lock held.
  * Returns 1 if OK, 0 if current operation should be aborted (NAK).
  */
-static int do_rc_ack(struct qib_qp *qp, u32 aeth, u32 psn, int opcode,
+static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		     u64 val, struct qib_ctxtdata *rcd)
 {
 	struct qib_ibport *ibp;
 	enum ib_wc_status status;
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 	int ret = 0;
 	u32 ack_psn;
 	int diff;
@@ -1350,10 +1350,10 @@ bail:
  * We have seen an out of sequence RDMA read middle or last packet.
  * This ACKs SENDs and RDMA writes up to the first RDMA read or atomic SWQE.
  */
-static void rdma_seq_err(struct qib_qp *qp, struct qib_ibport *ibp, u32 psn,
+static void rdma_seq_err(struct rvt_qp *qp, struct qib_ibport *ibp, u32 psn,
 			 struct qib_ctxtdata *rcd)
 {
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 
 	/* Remove QP from retry timer */
 	if (qp->s_flags & (QIB_S_TIMER | QIB_S_WAIT_RNR)) {
@@ -1400,12 +1400,12 @@ static void rdma_seq_err(struct qib_qp *qp, struct qib_ibport *ibp, u32 psn,
 static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 			    struct qib_other_headers *ohdr,
 			    void *data, u32 tlen,
-			    struct qib_qp *qp,
+			    struct rvt_qp *qp,
 			    u32 opcode,
 			    u32 psn, u32 hdrsize, u32 pmtu,
 			    struct qib_ctxtdata *rcd)
 {
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 	enum ib_wc_status status;
 	unsigned long flags;
@@ -1624,14 +1624,14 @@ bail:
  */
 static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 			    void *data,
-			    struct qib_qp *qp,
+			    struct rvt_qp *qp,
 			    u32 opcode,
 			    u32 psn,
 			    int diff,
 			    struct qib_ctxtdata *rcd)
 {
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct qib_ack_entry *e;
+	struct rvt_ack_entry *e;
 	unsigned long flags;
 	u8 i, prev;
 	int old_req;
@@ -1733,7 +1733,7 @@ static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 		if (unlikely(offset + len != e->rdma_sge.sge_length))
 			goto unlock_done;
 		if (e->rdma_sge.mr) {
-			qib_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		if (len != 0) {
@@ -1741,7 +1741,7 @@ static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 			u64 vaddr = be64_to_cpu(reth->vaddr);
 			int ok;
 
-			ok = qib_rkey_ok(qp, &e->rdma_sge, len, vaddr, rkey,
+			ok = rvt_rkey_ok(qp, &e->rdma_sge, len, vaddr, rkey,
 					 IB_ACCESS_REMOTE_READ);
 			if (unlikely(!ok))
 				goto unlock_done;
@@ -1819,7 +1819,7 @@ send_ack:
 	return 0;
 }
 
-void qib_rc_error(struct qib_qp *qp, enum ib_wc_status err)
+void qib_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
 {
 	unsigned long flags;
 	int lastwqe;
@@ -1838,7 +1838,7 @@ void qib_rc_error(struct qib_qp *qp, enum ib_wc_status err)
 	}
 }
 
-static inline void qib_update_ack_queue(struct qib_qp *qp, unsigned n)
+static inline void qib_update_ack_queue(struct rvt_qp *qp, unsigned n)
 {
 	unsigned next;
 
@@ -1863,7 +1863,7 @@ static inline void qib_update_ack_queue(struct qib_qp *qp, unsigned n)
  * Called at interrupt level.
  */
 void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
-		int has_grh, void *data, u32 tlen, struct qib_qp *qp)
+		int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
 	struct qib_ibport *ibp = &rcd->ppd->ibport_data;
 	struct qib_other_headers *ohdr;
@@ -2070,7 +2070,7 @@ send_last:
 			int ok;
 
 			/* Check rkey & NAK */
-			ok = qib_rkey_ok(qp, &qp->r_sge.sge, qp->r_len, vaddr,
+			ok = rvt_rkey_ok(qp, &qp->r_sge.sge, qp->r_len, vaddr,
 					 rkey, IB_ACCESS_REMOTE_WRITE);
 			if (unlikely(!ok))
 				goto nack_acc;
@@ -2097,7 +2097,7 @@ send_last:
 		goto send_last;
 
 	case OP(RDMA_READ_REQUEST): {
-		struct qib_ack_entry *e;
+		struct rvt_ack_entry *e;
 		u32 len;
 		u8 next;
 
@@ -2115,7 +2115,7 @@ send_last:
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
 		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
-			qib_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		reth = &ohdr->u.rc.reth;
@@ -2126,7 +2126,7 @@ send_last:
 			int ok;
 
 			/* Check rkey & NAK */
-			ok = qib_rkey_ok(qp, &e->rdma_sge, len, vaddr,
+			ok = rvt_rkey_ok(qp, &e->rdma_sge, len, vaddr,
 					 rkey, IB_ACCESS_REMOTE_READ);
 			if (unlikely(!ok))
 				goto nack_acc_unlck;
@@ -2167,7 +2167,7 @@ send_last:
 	case OP(COMPARE_SWAP):
 	case OP(FETCH_ADD): {
 		struct ib_atomic_eth *ateth;
-		struct qib_ack_entry *e;
+		struct rvt_ack_entry *e;
 		u64 vaddr;
 		atomic64_t *maddr;
 		u64 sdata;
@@ -2187,7 +2187,7 @@ send_last:
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
 		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
-			qib_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		ateth = &ohdr->u.atomic_eth;
@@ -2197,7 +2197,7 @@ send_last:
 			goto nack_inv_unlck;
 		rkey = be32_to_cpu(ateth->rkey);
 		/* Check rkey & NAK */
-		if (unlikely(!qib_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
+		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
 					  vaddr, rkey,
 					  IB_ACCESS_REMOTE_ATOMIC)))
 			goto nack_acc_unlck;
@@ -2209,7 +2209,7 @@ send_last:
 			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
 				      be64_to_cpu(ateth->compare_data),
 				      sdata);
-		qib_put_mr(qp->r_sge.sge.mr);
+		rvt_put_mr(qp->r_sge.sge.mr);
 		qp->r_sge.num_sge = 0;
 		e->opcode = opcode;
 		e->sent = 0;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 8985baa..0e1dba1 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -79,15 +79,15 @@ const u32 ib_qib_rnr_table[32] = {
  * Validate a RWQE and fill in the SGE state.
  * Return 1 if OK.
  */
-static int qib_init_sge(struct qib_qp *qp, struct qib_rwqe *wqe)
+static int qib_init_sge(struct rvt_qp *qp, struct rvt_rwqe *wqe)
 {
 	int i, j, ret;
 	struct ib_wc wc;
-	struct qib_lkey_table *rkt;
+	struct rvt_lkey_table *rkt;
 	struct rvt_pd *pd;
-	struct qib_sge_state *ss;
+	struct rvt_sge_state *ss;
 
-	rkt = &to_idev(qp->ibqp.device)->lk_table;
+	rkt = &to_idev(qp->ibqp.device)->rdi.lk_table;
 	pd = ibpd_to_rvtpd(qp->ibqp.srq ? qp->ibqp.srq->pd : qp->ibqp.pd);
 	ss = &qp->r_sge;
 	ss->sg_list = qp->r_sg_list;
@@ -96,7 +96,7 @@ static int qib_init_sge(struct qib_qp *qp, struct qib_rwqe *wqe)
 		if (wqe->sg_list[i].length == 0)
 			continue;
 		/* Check LKEY */
-		if (!qib_lkey_ok(rkt, pd, j ? &ss->sg_list[j - 1] : &ss->sge,
+		if (!rvt_lkey_ok(rkt, pd, j ? &ss->sg_list[j - 1] : &ss->sge,
 				 &wqe->sg_list[i], IB_ACCESS_LOCAL_WRITE))
 			goto bad_lkey;
 		qp->r_len += wqe->sg_list[i].length;
@@ -109,9 +109,9 @@ static int qib_init_sge(struct qib_qp *qp, struct qib_rwqe *wqe)
 
 bad_lkey:
 	while (j) {
-		struct qib_sge *sge = --j ? &ss->sg_list[j - 1] : &ss->sge;
+		struct rvt_sge *sge = --j ? &ss->sg_list[j - 1] : &ss->sge;
 
-		qib_put_mr(sge->mr);
+		rvt_put_mr(sge->mr);
 	}
 	ss->num_sge = 0;
 	memset(&wc, 0, sizeof(wc));
@@ -136,13 +136,13 @@ bail:
  *
  * Can be called from interrupt level.
  */
-int qib_get_rwqe(struct qib_qp *qp, int wr_id_only)
+int qib_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 {
 	unsigned long flags;
-	struct qib_rq *rq;
-	struct qib_rwq *wq;
+	struct rvt_rq *rq;
+	struct rvt_rwq *wq;
 	struct qib_srq *srq;
-	struct qib_rwqe *wqe;
+	struct rvt_rwqe *wqe;
 	void (*handler)(struct ib_event *, void *);
 	u32 tail;
 	int ret;
@@ -227,7 +227,7 @@ bail:
  * Switch to alternate path.
  * The QP s_lock should be held and interrupts disabled.
  */
-void qib_migrate_qp(struct qib_qp *qp)
+void qib_migrate_qp(struct rvt_qp *qp)
 {
 	struct ib_event ev;
 
@@ -266,7 +266,7 @@ static int gid_ok(union ib_gid *gid, __be64 gid_prefix, __be64 id)
  * The s_lock will be acquired around the qib_migrate_qp() call.
  */
 int qib_ruc_check_hdr(struct qib_ibport *ibp, struct qib_ib_header *hdr,
-		      int has_grh, struct qib_qp *qp, u32 bth0)
+		      int has_grh, struct rvt_qp *qp, u32 bth0)
 {
 	__be64 guid;
 	unsigned long flags;
@@ -353,12 +353,12 @@ err:
  * receive interrupts since this is a connected protocol and all packets
  * will pass through here.
  */
-static void qib_ruc_loopback(struct qib_qp *sqp)
+static void qib_ruc_loopback(struct rvt_qp *sqp)
 {
 	struct qib_ibport *ibp = to_iport(sqp->ibqp.device, sqp->port_num);
-	struct qib_qp *qp;
-	struct qib_swqe *wqe;
-	struct qib_sge *sge;
+	struct rvt_qp *qp;
+	struct rvt_swqe *wqe;
+	struct rvt_sge *sge;
 	unsigned long flags;
 	struct ib_wc wc;
 	u64 sdata;
@@ -458,7 +458,7 @@ again:
 			goto inv_err;
 		if (wqe->length == 0)
 			break;
-		if (unlikely(!qib_rkey_ok(qp, &qp->r_sge.sge, wqe->length,
+		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, wqe->length,
 					  wqe->rdma_wr.remote_addr,
 					  wqe->rdma_wr.rkey,
 					  IB_ACCESS_REMOTE_WRITE)))
@@ -471,7 +471,7 @@ again:
 	case IB_WR_RDMA_READ:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_READ)))
 			goto inv_err;
-		if (unlikely(!qib_rkey_ok(qp, &sqp->s_sge.sge, wqe->length,
+		if (unlikely(!rvt_rkey_ok(qp, &sqp->s_sge.sge, wqe->length,
 					  wqe->rdma_wr.remote_addr,
 					  wqe->rdma_wr.rkey,
 					  IB_ACCESS_REMOTE_READ)))
@@ -489,7 +489,7 @@ again:
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC)))
 			goto inv_err;
-		if (unlikely(!qib_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
+		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
 					  wqe->atomic_wr.remote_addr,
 					  wqe->atomic_wr.rkey,
 					  IB_ACCESS_REMOTE_ATOMIC)))
@@ -502,7 +502,7 @@ again:
 			(u64) atomic64_add_return(sdata, maddr) - sdata :
 			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
 				      sdata, wqe->atomic_wr.swap);
-		qib_put_mr(qp->r_sge.sge.mr);
+		rvt_put_mr(qp->r_sge.sge.mr);
 		qp->r_sge.num_sge = 0;
 		goto send_comp;
 
@@ -526,11 +526,11 @@ again:
 		sge->sge_length -= len;
 		if (sge->sge_length == 0) {
 			if (!release)
-				qib_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			if (--sqp->s_sge.num_sge)
 				*sge = *sqp->s_sge.sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= QIB_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
@@ -672,7 +672,7 @@ u32 qib_make_grh(struct qib_ibport *ibp, struct ib_grh *hdr,
 	return sizeof(struct ib_grh) / sizeof(u32);
 }
 
-void qib_make_ruc_header(struct qib_qp *qp, struct qib_other_headers *ohdr,
+void qib_make_ruc_header(struct rvt_qp *qp, struct qib_other_headers *ohdr,
 			 u32 bth0, u32 bth2)
 {
 	struct qib_qp_priv *priv = qp->priv;
@@ -721,10 +721,10 @@ void qib_do_send(struct work_struct *work)
 {
 	struct qib_qp_priv *priv = container_of(work, struct qib_qp_priv,
 						s_work);
-	struct qib_qp *qp = priv->owner;
+	struct rvt_qp *qp = priv->owner;
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
-	int (*make_req)(struct qib_qp *qp);
+	int (*make_req)(struct rvt_qp *qp);
 	unsigned long flags;
 
 	if ((qp->ibqp.qp_type == IB_QPT_RC ||
@@ -772,7 +772,7 @@ void qib_do_send(struct work_struct *work)
 /*
  * This should be called with s_lock held.
  */
-void qib_send_complete(struct qib_qp *qp, struct qib_swqe *wqe,
+void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		       enum ib_wc_status status)
 {
 	u32 old_last, last;
@@ -782,9 +782,9 @@ void qib_send_complete(struct qib_qp *qp, struct qib_swqe *wqe,
 		return;
 
 	for (i = 0; i < wqe->wr.num_sge; i++) {
-		struct qib_sge *sge = &wqe->sg_list[i];
+		struct rvt_sge *sge = &wqe->sg_list[i];
 
-		qib_put_mr(sge->mr);
+		rvt_put_mr(sge->mr);
 	}
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index ac4fcad..1395ed0 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -533,12 +533,12 @@ static void complete_sdma_err_req(struct qib_pportdata *ppd,
  * 3) The SGE addresses are suitable for passing to dma_map_single().
  */
 int qib_sdma_verbs_send(struct qib_pportdata *ppd,
-			struct qib_sge_state *ss, u32 dwords,
+			struct rvt_sge_state *ss, u32 dwords,
 			struct qib_verbs_txreq *tx)
 {
 	unsigned long flags;
-	struct qib_sge *sge;
-	struct qib_qp *qp;
+	struct rvt_sge *sge;
+	struct rvt_qp *qp;
 	int ret = 0;
 	u16 tail;
 	__le64 *descqp;
@@ -624,7 +624,7 @@ retry:
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= QIB_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
diff --git a/drivers/infiniband/hw/qib/qib_srq.c b/drivers/infiniband/hw/qib/qib_srq.c
index d623593..8547263 100644
--- a/drivers/infiniband/hw/qib/qib_srq.c
+++ b/drivers/infiniband/hw/qib/qib_srq.c
@@ -49,12 +49,12 @@ int qib_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 			 struct ib_recv_wr **bad_wr)
 {
 	struct qib_srq *srq = to_isrq(ibsrq);
-	struct qib_rwq *wq;
+	struct rvt_rwq *wq;
 	unsigned long flags;
 	int ret;
 
 	for (; wr; wr = wr->next) {
-		struct qib_rwqe *wqe;
+		struct rvt_rwqe *wqe;
 		u32 next;
 		int i;
 
@@ -132,8 +132,8 @@ struct ib_srq *qib_create_srq(struct ib_pd *ibpd,
 	srq->rq.size = srq_init_attr->attr.max_wr + 1;
 	srq->rq.max_sge = srq_init_attr->attr.max_sge;
 	sz = sizeof(struct ib_sge) * srq->rq.max_sge +
-		sizeof(struct qib_rwqe);
-	srq->rq.wq = vmalloc_user(sizeof(struct qib_rwq) + srq->rq.size * sz);
+		sizeof(struct rvt_rwqe);
+	srq->rq.wq = vmalloc_user(sizeof(struct rvt_rwq) + srq->rq.size * sz);
 	if (!srq->rq.wq) {
 		ret = ERR_PTR(-ENOMEM);
 		goto bail_srq;
@@ -145,7 +145,7 @@ struct ib_srq *qib_create_srq(struct ib_pd *ibpd,
 	 */
 	if (udata && udata->outlen >= sizeof(__u64)) {
 		int err;
-		u32 s = sizeof(struct qib_rwq) + srq->rq.size * sz;
+		u32 s = sizeof(struct rvt_rwq) + srq->rq.size * sz;
 
 		srq->ip =
 		    qib_create_mmap_info(dev, s, ibpd->uobject->context,
@@ -213,12 +213,12 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		   struct ib_udata *udata)
 {
 	struct qib_srq *srq = to_isrq(ibsrq);
-	struct qib_rwq *wq;
+	struct rvt_rwq *wq;
 	int ret = 0;
 
 	if (attr_mask & IB_SRQ_MAX_WR) {
-		struct qib_rwq *owq;
-		struct qib_rwqe *p;
+		struct rvt_rwq *owq;
+		struct rvt_rwqe *p;
 		u32 sz, size, n, head, tail;
 
 		/* Check that the requested sizes are below the limits. */
@@ -229,10 +229,10 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			goto bail;
 		}
 
-		sz = sizeof(struct qib_rwqe) +
+		sz = sizeof(struct rvt_rwqe) +
 			srq->rq.max_sge * sizeof(struct ib_sge);
 		size = attr->max_wr + 1;
-		wq = vmalloc_user(sizeof(struct qib_rwq) + size * sz);
+		wq = vmalloc_user(sizeof(struct rvt_rwq) + size * sz);
 		if (!wq) {
 			ret = -ENOMEM;
 			goto bail;
@@ -279,7 +279,7 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		n = 0;
 		p = wq->wq;
 		while (tail != head) {
-			struct qib_rwqe *wqe;
+			struct rvt_rwqe *wqe;
 			int i;
 
 			wqe = get_rwqe_ptr(&srq->rq, tail);
@@ -288,7 +288,7 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			for (i = 0; i < wqe->num_sge; i++)
 				p->sg_list[i] = wqe->sg_list[i];
 			n++;
-			p = (struct qib_rwqe *)((char *) p + sz);
+			p = (struct rvt_rwqe *)((char *)p + sz);
 			if (++tail >= srq->rq.size)
 				tail = 0;
 		}
@@ -303,9 +303,9 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		vfree(owq);
 
 		if (srq->ip) {
-			struct qib_mmap_info *ip = srq->ip;
+			struct rvt_mmap_info *ip = srq->ip;
 			struct qib_ibdev *dev = to_idev(srq->ibsrq.device);
-			u32 s = sizeof(struct qib_rwq) + size * sz;
+			u32 s = sizeof(struct rvt_rwq) + size * sz;
 
 			qib_update_mmap_info(dev, ip, s, wq);
 
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index d607656..1ae135a 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -43,11 +43,11 @@
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int qib_make_uc_req(struct qib_qp *qp)
+int qib_make_uc_req(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_other_headers *ohdr;
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 	unsigned long flags;
 	u32 hwords;
 	u32 bth0;
@@ -241,7 +241,7 @@ unlock:
  * Called at interrupt level.
  */
 void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
-		int has_grh, void *data, u32 tlen, struct qib_qp *qp)
+		int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
 	struct qib_other_headers *ohdr;
 	u32 opcode;
@@ -439,7 +439,7 @@ rdma_first:
 			int ok;
 
 			/* Check rkey */
-			ok = qib_rkey_ok(qp, &qp->r_sge.sge, qp->r_len,
+			ok = rvt_rkey_ok(qp, &qp->r_sge.sge, qp->r_len,
 					 vaddr, rkey, IB_ACCESS_REMOTE_WRITE);
 			if (unlikely(!ok))
 				goto drop;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 682403a..1d9d037 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -47,15 +47,15 @@
  * Note that the receive interrupt handler may be calling qib_ud_rcv()
  * while this is being called.
  */
-static void qib_ud_loopback(struct qib_qp *sqp, struct qib_swqe *swqe)
+static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 {
 	struct qib_ibport *ibp = to_iport(sqp->ibqp.device, sqp->port_num);
 	struct qib_pportdata *ppd;
-	struct qib_qp *qp;
+	struct rvt_qp *qp;
 	struct ib_ah_attr *ah_attr;
 	unsigned long flags;
-	struct qib_sge_state ssge;
-	struct qib_sge *sge;
+	struct rvt_sge_state ssge;
+	struct rvt_sge *sge;
 	struct ib_wc wc;
 	u32 length;
 	enum ib_qp_type sqptype, dqptype;
@@ -190,7 +190,7 @@ static void qib_ud_loopback(struct qib_qp *sqp, struct qib_swqe *swqe)
 			if (--ssge.num_sge)
 				*sge = *ssge.sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= QIB_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
@@ -233,14 +233,14 @@ drop:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int qib_make_ud_req(struct qib_qp *qp)
+int qib_make_ud_req(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_other_headers *ohdr;
 	struct ib_ah_attr *ah_attr;
 	struct qib_pportdata *ppd;
 	struct qib_ibport *ibp;
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 	unsigned long flags;
 	u32 nwords;
 	u32 extra_bytes;
@@ -429,7 +429,7 @@ static unsigned qib_lookup_pkey(struct qib_ibport *ibp, u16 pkey)
  * Called at interrupt level.
  */
 void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
-		int has_grh, void *data, u32 tlen, struct qib_qp *qp)
+		int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
 	struct qib_other_headers *ohdr;
 	int opcode;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index b7e03ae..71cf82d 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -50,8 +50,8 @@ static unsigned int ib_qib_qp_table_size = 256;
 module_param_named(qp_table_size, ib_qib_qp_table_size, uint, S_IRUGO);
 MODULE_PARM_DESC(qp_table_size, "QP table size");
 
-unsigned int ib_qib_lkey_table_size = 16;
-module_param_named(lkey_table_size, ib_qib_lkey_table_size, uint,
+static unsigned int qib_lkey_table_size = 16;
+module_param_named(lkey_table_size, qib_lkey_table_size, uint,
 		   S_IRUGO);
 MODULE_PARM_DESC(lkey_table_size,
 		 "LKEY table size in bits (2^n, 1 <= n <= 23)");
@@ -167,9 +167,9 @@ __be64 ib_qib_sys_image_guid;
  * @data: the data to copy
  * @length: the length of the data
  */
-void qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length, int release)
+void qib_copy_sge(struct rvt_sge_state *ss, void *data, u32 length, int release)
 {
-	struct qib_sge *sge = &ss->sge;
+	struct rvt_sge *sge = &ss->sge;
 
 	while (length) {
 		u32 len = sge->length;
@@ -185,11 +185,11 @@ void qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length, int release)
 		sge->sge_length -= len;
 		if (sge->sge_length == 0) {
 			if (release)
-				qib_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= QIB_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
@@ -209,9 +209,9 @@ void qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length, int release)
  * @ss: the SGE state
  * @length: the number of bytes to skip
  */
-void qib_skip_sge(struct qib_sge_state *ss, u32 length, int release)
+void qib_skip_sge(struct rvt_sge_state *ss, u32 length, int release)
 {
-	struct qib_sge *sge = &ss->sge;
+	struct rvt_sge *sge = &ss->sge;
 
 	while (length) {
 		u32 len = sge->length;
@@ -226,11 +226,11 @@ void qib_skip_sge(struct qib_sge_state *ss, u32 length, int release)
 		sge->sge_length -= len;
 		if (sge->sge_length == 0) {
 			if (release)
-				qib_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= QIB_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
@@ -249,10 +249,10 @@ void qib_skip_sge(struct qib_sge_state *ss, u32 length, int release)
  * Don't modify the qib_sge_state to get the count.
  * Return zero if any of the segments is not aligned.
  */
-static u32 qib_count_sge(struct qib_sge_state *ss, u32 length)
+static u32 qib_count_sge(struct rvt_sge_state *ss, u32 length)
 {
-	struct qib_sge *sg_list = ss->sg_list;
-	struct qib_sge sge = ss->sge;
+	struct rvt_sge *sg_list = ss->sg_list;
+	struct rvt_sge sge = ss->sge;
 	u8 num_sge = ss->num_sge;
 	u32 ndesc = 1;  /* count the header */
 
@@ -277,7 +277,7 @@ static u32 qib_count_sge(struct qib_sge_state *ss, u32 length)
 			if (--num_sge)
 				sge = *sg_list++;
 		} else if (sge.length == 0 && sge.mr->lkey) {
-			if (++sge.n >= QIB_SEGSZ) {
+			if (++sge.n >= RVT_SEGSZ) {
 				if (++sge.m >= sge.mr->mapsz)
 					break;
 				sge.n = 0;
@@ -295,9 +295,9 @@ static u32 qib_count_sge(struct qib_sge_state *ss, u32 length)
 /*
  * Copy from the SGEs to the data buffer.
  */
-static void qib_copy_from_sge(void *data, struct qib_sge_state *ss, u32 length)
+static void qib_copy_from_sge(void *data, struct rvt_sge_state *ss, u32 length)
 {
-	struct qib_sge *sge = &ss->sge;
+	struct rvt_sge *sge = &ss->sge;
 
 	while (length) {
 		u32 len = sge->length;
@@ -315,7 +315,7 @@ static void qib_copy_from_sge(void *data, struct qib_sge_state *ss, u32 length)
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= QIB_SEGSZ) {
+			if (++sge->n >= RVT_SEGSZ) {
 				if (++sge->m >= sge->mr->mapsz)
 					break;
 				sge->n = 0;
@@ -335,17 +335,17 @@ static void qib_copy_from_sge(void *data, struct qib_sge_state *ss, u32 length)
  * @qp: the QP to post on
  * @wr: the work request to send
  */
-static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
-	int *scheduled)
+static int qib_post_one_send(struct rvt_qp *qp, struct ib_send_wr *wr,
+			     int *scheduled)
 {
-	struct qib_swqe *wqe;
+	struct rvt_swqe *wqe;
 	u32 next;
 	int i;
 	int j;
 	int acc;
 	int ret;
 	unsigned long flags;
-	struct qib_lkey_table *rkt;
+	struct rvt_lkey_table *rkt;
 	struct rvt_pd *pd;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
@@ -364,7 +364,7 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 	 * Make sure buffer is large enough to hold the result for atomics.
 	 */
 	if (wr->opcode == IB_WR_REG_MR) {
-		if (qib_reg_mr(qp, reg_wr(wr)))
+		if (rvt_reg_mr(qp, reg_wr(wr)))
 			goto bail_inval;
 	} else if (qp->ibqp.qp_type == IB_QPT_UC) {
 		if ((unsigned) wr->opcode >= IB_WR_RDMA_READ)
@@ -395,7 +395,7 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 		goto bail;
 	}
 
-	rkt = &to_idev(qp->ibqp.device)->lk_table;
+	rkt = &to_idev(qp->ibqp.device)->rdi.lk_table;
 	pd = ibpd_to_rvtpd(qp->ibqp.pd);
 	wqe = get_swqe_ptr(qp, qp->s_head);
 
@@ -426,7 +426,7 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 
 			if (length == 0)
 				continue;
-			ok = qib_lkey_ok(rkt, pd, &wqe->sg_list[j],
+			ok = rvt_lkey_ok(rkt, pd, &wqe->sg_list[j],
 					 &wr->sg_list[i], acc);
 			if (!ok)
 				goto bail_inval_free;
@@ -452,9 +452,9 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 
 bail_inval_free:
 	while (j) {
-		struct qib_sge *sge = &wqe->sg_list[--j];
+		struct rvt_sge *sge = &wqe->sg_list[--j];
 
-		qib_put_mr(sge->mr);
+		rvt_put_mr(sge->mr);
 	}
 bail_inval:
 	ret = -EINVAL;
@@ -480,7 +480,7 @@ bail:
 static int qib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			 struct ib_send_wr **bad_wr)
 {
-	struct qib_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct qib_qp_priv *priv = qp->priv;
 	int err = 0;
 	int scheduled = 0;
@@ -512,8 +512,8 @@ bail:
 static int qib_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			    struct ib_recv_wr **bad_wr)
 {
-	struct qib_qp *qp = to_iqp(ibqp);
-	struct qib_rwq *wq = qp->r_rq.wq;
+	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_rwq *wq = qp->r_rq.wq;
 	unsigned long flags;
 	int ret;
 
@@ -525,7 +525,7 @@ static int qib_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	}
 
 	for (; wr; wr = wr->next) {
-		struct qib_rwqe *wqe;
+		struct rvt_rwqe *wqe;
 		u32 next;
 		int i;
 
@@ -576,7 +576,7 @@ bail:
  * Called at interrupt level.
  */
 static void qib_qp_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
-		       int has_grh, void *data, u32 tlen, struct qib_qp *qp)
+		       int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
 	struct qib_ibport *ibp = &rcd->ppd->ibport_data;
 
@@ -630,7 +630,7 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 	struct qib_ibport *ibp = &ppd->ibport_data;
 	struct qib_ib_header *hdr = rhdr;
 	struct qib_other_headers *ohdr;
-	struct qib_qp *qp;
+	struct rvt_qp *qp;
 	u32 qp_num;
 	int lnh;
 	u8 opcode;
@@ -725,7 +725,7 @@ static void mem_timer(unsigned long data)
 {
 	struct qib_ibdev *dev = (struct qib_ibdev *) data;
 	struct list_head *list = &dev->memwait;
-	struct qib_qp *qp = NULL;
+	struct rvt_qp *qp = NULL;
 	struct qib_qp_priv *priv = NULL;
 	unsigned long flags;
 
@@ -752,9 +752,9 @@ static void mem_timer(unsigned long data)
 	}
 }
 
-static void update_sge(struct qib_sge_state *ss, u32 length)
+static void update_sge(struct rvt_sge_state *ss, u32 length)
 {
-	struct qib_sge *sge = &ss->sge;
+	struct rvt_sge *sge = &ss->sge;
 
 	sge->vaddr += length;
 	sge->length -= length;
@@ -763,7 +763,7 @@ static void update_sge(struct qib_sge_state *ss, u32 length)
 		if (--ss->num_sge)
 			*sge = *ss->sg_list++;
 	} else if (sge->length == 0 && sge->mr->lkey) {
-		if (++sge->n >= QIB_SEGSZ) {
+		if (++sge->n >= RVT_SEGSZ) {
 			if (++sge->m >= sge->mr->mapsz)
 				return;
 			sge->n = 0;
@@ -809,7 +809,7 @@ static inline u32 clear_upper_bytes(u32 data, u32 n, u32 off)
 }
 #endif
 
-static void copy_io(u32 __iomem *piobuf, struct qib_sge_state *ss,
+static void copy_io(u32 __iomem *piobuf, struct rvt_sge_state *ss,
 		    u32 length, unsigned flush_wc)
 {
 	u32 extra = 0;
@@ -946,7 +946,7 @@ static void copy_io(u32 __iomem *piobuf, struct qib_sge_state *ss,
 }
 
 static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
-					   struct qib_qp *qp)
+					   struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_verbs_txreq *tx;
@@ -978,7 +978,7 @@ static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
 }
 
 static inline struct qib_verbs_txreq *get_txreq(struct qib_ibdev *dev,
-					 struct qib_qp *qp)
+					 struct rvt_qp *qp)
 {
 	struct qib_verbs_txreq *tx;
 	unsigned long flags;
@@ -1002,7 +1002,7 @@ static inline struct qib_verbs_txreq *get_txreq(struct qib_ibdev *dev,
 void qib_put_txreq(struct qib_verbs_txreq *tx)
 {
 	struct qib_ibdev *dev;
-	struct qib_qp *qp;
+	struct rvt_qp *qp;
 	struct qib_qp_priv *priv;
 	unsigned long flags;
 
@@ -1012,7 +1012,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 	if (atomic_dec_and_test(&qp->refcount))
 		wake_up(&qp->wait);
 	if (tx->mr) {
-		qib_put_mr(tx->mr);
+		rvt_put_mr(tx->mr);
 		tx->mr = NULL;
 	}
 	if (tx->txreq.flags & QIB_SDMA_TXREQ_F_FREEBUF) {
@@ -1058,9 +1058,9 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
  */
 void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 {
-	struct qib_qp *qp, *nqp;
+	struct rvt_qp *qp, *nqp;
 	struct qib_qp_priv *qpp, *nqpp;
-	struct qib_qp *qps[20];
+	struct rvt_qp *qps[20];
 	struct qib_ibdev *dev;
 	unsigned i, n;
 
@@ -1106,7 +1106,7 @@ static void sdma_complete(struct qib_sdma_txreq *cookie, int status)
 {
 	struct qib_verbs_txreq *tx =
 		container_of(cookie, struct qib_verbs_txreq, txreq);
-	struct qib_qp *qp = tx->qp;
+	struct rvt_qp *qp = tx->qp;
 	struct qib_qp_priv *priv = qp->priv;
 
 	spin_lock(&qp->s_lock);
@@ -1137,7 +1137,7 @@ static void sdma_complete(struct qib_sdma_txreq *cookie, int status)
 	qib_put_txreq(tx);
 }
 
-static int wait_kmem(struct qib_ibdev *dev, struct qib_qp *qp)
+static int wait_kmem(struct qib_ibdev *dev, struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	unsigned long flags;
@@ -1161,8 +1161,8 @@ static int wait_kmem(struct qib_ibdev *dev, struct qib_qp *qp)
 	return ret;
 }
 
-static int qib_verbs_send_dma(struct qib_qp *qp, struct qib_ib_header *hdr,
-			      u32 hdrwords, struct qib_sge_state *ss, u32 len,
+static int qib_verbs_send_dma(struct rvt_qp *qp, struct qib_ib_header *hdr,
+			      u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			      u32 plen, u32 dwords)
 {
 	struct qib_qp_priv *priv = qp->priv;
@@ -1266,7 +1266,7 @@ bail_tx:
  * If we are now in the error state, return zero to flush the
  * send work request.
  */
-static int no_bufs_available(struct qib_qp *qp)
+static int no_bufs_available(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
@@ -1298,8 +1298,8 @@ static int no_bufs_available(struct qib_qp *qp)
 	return ret;
 }
 
-static int qib_verbs_send_pio(struct qib_qp *qp, struct qib_ib_header *ibhdr,
-			      u32 hdrwords, struct qib_sge_state *ss, u32 len,
+static int qib_verbs_send_pio(struct rvt_qp *qp, struct qib_ib_header *ibhdr,
+			      u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			      u32 plen, u32 dwords)
 {
 	struct qib_devdata *dd = dd_from_ibdev(qp->ibqp.device);
@@ -1380,7 +1380,7 @@ done:
 	}
 	qib_sendbuf_done(dd, pbufn);
 	if (qp->s_rdma_mr) {
-		qib_put_mr(qp->s_rdma_mr);
+		rvt_put_mr(qp->s_rdma_mr);
 		qp->s_rdma_mr = NULL;
 	}
 	if (qp->s_wqe) {
@@ -1406,8 +1406,8 @@ done:
  * Return zero if packet is sent or queued OK.
  * Return non-zero and clear qp->s_flags QIB_S_BUSY otherwise.
  */
-int qib_verbs_send(struct qib_qp *qp, struct qib_ib_header *hdr,
-		   u32 hdrwords, struct qib_sge_state *ss, u32 len)
+int qib_verbs_send(struct rvt_qp *qp, struct qib_ib_header *hdr,
+		   u32 hdrwords, struct rvt_sge_state *ss, u32 len)
 {
 	struct qib_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	u32 plen;
@@ -1539,8 +1539,8 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 {
 	struct qib_ibdev *dev = &dd->verbs_dev;
 	struct list_head *list;
-	struct qib_qp *qps[5];
-	struct qib_qp *qp;
+	struct rvt_qp *qps[5];
+	struct rvt_qp *qp;
 	unsigned long flags;
 	unsigned i, n;
 	struct qib_qp_priv *priv;
@@ -1612,8 +1612,8 @@ static int qib_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_cq = ib_qib_max_cqs;
 	props->max_ah = ib_qib_max_ahs;
 	props->max_cqe = ib_qib_max_cqes;
-	props->max_mr = dev->lk_table.max;
-	props->max_fmr = dev->lk_table.max;
+	props->max_mr = dev->rdi.lk_table.max;
+	props->max_fmr = dev->rdi.lk_table.max;
 	props->max_map_per_fmr = 32767;
 	props->max_pd = dev->rdi.dparms.props.max_pd;
 	props->max_qp_rd_atom = QIB_MAX_RDMA_ATOMIC;
@@ -1843,7 +1843,7 @@ struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
 {
 	struct ib_ah_attr attr;
 	struct ib_ah *ah = ERR_PTR(-EINVAL);
-	struct qib_qp *qp0;
+	struct rvt_qp *qp0;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.dlid = dlid;
@@ -2050,7 +2050,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	struct qib_ibdev *dev = &dd->verbs_dev;
 	struct ib_device *ibdev = &dev->rdi.ibdev;
 	struct qib_pportdata *ppd = dd->pport;
-	unsigned i, lk_tab_size;
+	unsigned i;
 	int ret;
 
 	dev->qp_table_size = ib_qib_qp_table_size;
@@ -2082,29 +2082,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 
 	qib_init_qpn_table(dd, &dev->qpn_table);
 
-	/*
-	 * The top ib_qib_lkey_table_size bits are used to index the
-	 * table.  The lower 8 bits can be owned by the user (copied from
-	 * the LKEY).  The remaining bits act as a generation number or tag.
-	 */
-	spin_lock_init(&dev->lk_table.lock);
-	/* insure generation is at least 4 bits see keys.c */
-	if (ib_qib_lkey_table_size > MAX_LKEY_TABLE_BITS) {
-		qib_dev_warn(dd, "lkey bits %u too large, reduced to %u\n",
-			ib_qib_lkey_table_size, MAX_LKEY_TABLE_BITS);
-		ib_qib_lkey_table_size = MAX_LKEY_TABLE_BITS;
-	}
-	dev->lk_table.max = 1 << ib_qib_lkey_table_size;
-	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
-	dev->lk_table.table = (struct qib_mregion __rcu **)
-		vmalloc(lk_tab_size);
-	if (dev->lk_table.table == NULL) {
-		ret = -ENOMEM;
-		goto err_lk;
-	}
-	RCU_INIT_POINTER(dev->dma_mr, NULL);
-	for (i = 0; i < dev->lk_table.max; i++)
-		RCU_INIT_POINTER(dev->lk_table.table[i], NULL);
 	INIT_LIST_HEAD(&dev->pending_mmaps);
 	spin_lock_init(&dev->pending_lock);
 	dev->mmap_offset = PAGE_SIZE;
@@ -2216,16 +2193,16 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->resize_cq = qib_resize_cq;
 	ibdev->poll_cq = qib_poll_cq;
 	ibdev->req_notify_cq = qib_req_notify_cq;
-	ibdev->get_dma_mr = qib_get_dma_mr;
-	ibdev->reg_phys_mr = qib_reg_phys_mr;
-	ibdev->reg_user_mr = qib_reg_user_mr;
-	ibdev->dereg_mr = qib_dereg_mr;
-	ibdev->alloc_mr = qib_alloc_mr;
-	ibdev->map_mr_sg = qib_map_mr_sg;
-	ibdev->alloc_fmr = qib_alloc_fmr;
-	ibdev->map_phys_fmr = qib_map_phys_fmr;
-	ibdev->unmap_fmr = qib_unmap_fmr;
-	ibdev->dealloc_fmr = qib_dealloc_fmr;
+	ibdev->get_dma_mr = NULL;
+	ibdev->reg_phys_mr = NULL;
+	ibdev->reg_user_mr = NULL;
+	ibdev->dereg_mr = NULL;
+	ibdev->alloc_mr = NULL;
+	ibdev->map_mr_sg = NULL;
+	ibdev->alloc_fmr = NULL;
+	ibdev->map_phys_fmr = NULL;
+	ibdev->unmap_fmr = NULL;
+	ibdev->dealloc_fmr = NULL;
 	ibdev->attach_mcast = qib_multicast_attach;
 	ibdev->detach_mcast = qib_multicast_detach;
 	ibdev->process_mad = qib_process_mad;
@@ -2243,10 +2220,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_card_name = qib_get_card_name;
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
 	dd->verbs_dev.rdi.dparms.props.max_pd = ib_qib_max_pds;
-	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
-				   RVT_FLAG_QP_INIT_DRIVER |
+	dd->verbs_dev.rdi.flags = (RVT_FLAG_QP_INIT_DRIVER |
 				   RVT_FLAG_CQ_INIT_DRIVER);
-
+	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
 
 	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)
@@ -2282,8 +2258,6 @@ err_tx:
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 err_hdrs:
-	vfree(dev->lk_table.table);
-err_lk:
 	kfree(dev->qp_table);
 err_qpt:
 	qib_dev_err(dd, "cannot register verbs: %d!\n", -ret);
@@ -2295,7 +2269,6 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 {
 	struct qib_ibdev *dev = &dd->verbs_dev;
 	u32 qps_inuse;
-	unsigned lk_tab_size;
 
 	qib_verbs_unregister_sysfs(dd);
 
@@ -2311,8 +2284,6 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 		qib_dev_err(dd, "txwait list not empty!\n");
 	if (!list_empty(&dev->memwait))
 		qib_dev_err(dd, "memwait list not empty!\n");
-	if (dev->dma_mr)
-		qib_dev_err(dd, "DMA MR not NULL!\n");
 
 	qps_inuse = qib_free_all_qps(dd);
 	if (qps_inuse)
@@ -2334,15 +2305,13 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 				  dd->pport->sdma_descq_cnt *
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
-	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
-	vfree(dev->lk_table.table);
 	kfree(dev->qp_table);
 }
 
 /*
  * This must be called with s_lock held.
  */
-void qib_schedule_send(struct qib_qp *qp)
+void qib_schedule_send(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	if (qib_send_ok(qp)) {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 2fc28c3..c7399ff 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -210,7 +210,7 @@ struct qib_pio_header {
  */
 struct qib_mcast_qp {
 	struct list_head list;
-	struct qib_qp *qp;
+	struct rvt_qp *qp;
 };
 
 struct qib_mcast {
@@ -230,20 +230,6 @@ struct qib_ah {
 };
 
 /*
- * This structure is used by qib_mmap() to validate an offset
- * when an mmap() request is made.  The vm_area_struct then uses
- * this as its vm_private_data.
- */
-struct qib_mmap_info {
-	struct list_head pending_mmaps;
-	struct ib_ucontext *context;
-	void *obj;
-	__u64 offset;
-	struct kref ref;
-	unsigned size;
-};
-
-/*
  * This structure is used to contain the head pointer, tail pointer,
  * and completion queue entries as a single memory allocation so
  * it can be mmap'ed into user space.
@@ -269,154 +255,21 @@ struct qib_cq {
 	u8 notify;
 	u8 triggered;
 	struct qib_cq_wc *queue;
-	struct qib_mmap_info *ip;
-};
-
-/*
- * A segment is a linear region of low physical memory.
- * XXX Maybe we should use phys addr here and kmap()/kunmap().
- * Used by the verbs layer.
- */
-struct qib_seg {
-	void *vaddr;
-	size_t length;
-};
-
-/* The number of qib_segs that fit in a page. */
-#define QIB_SEGSZ     (PAGE_SIZE / sizeof(struct qib_seg))
-
-struct qib_segarray {
-	struct qib_seg segs[QIB_SEGSZ];
-};
-
-struct qib_mregion {
-	struct ib_pd *pd;       /* shares refcnt of ibmr.pd */
-	u64 user_base;          /* User's address for this region */
-	u64 iova;               /* IB start address of this region */
-	size_t length;
-	u32 lkey;
-	u32 offset;             /* offset (bytes) to start of region */
-	int access_flags;
-	u32 max_segs;           /* number of qib_segs in all the arrays */
-	u32 mapsz;              /* size of the map array */
-	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
-	u8  lkey_published;     /* in global table */
-	struct completion comp; /* complete when refcount goes to zero */
-	struct rcu_head list;
-	atomic_t refcount;
-	struct qib_segarray *map[0];    /* the segments */
-};
-
-/*
- * These keep track of the copy progress within a memory region.
- * Used by the verbs layer.
- */
-struct qib_sge {
-	struct qib_mregion *mr;
-	void *vaddr;            /* kernel virtual address of segment */
-	u32 sge_length;         /* length of the SGE */
-	u32 length;             /* remaining length of the segment */
-	u16 m;                  /* current index: mr->map[m] */
-	u16 n;                  /* current index: mr->map[m]->segs[n] */
-};
-
-/* Memory region */
-struct qib_mr {
-	struct ib_mr ibmr;
-	struct ib_umem *umem;
-	u64 *pages;
-	u32 npages;
-	struct qib_mregion mr;  /* must be last */
-};
-
-/*
- * Send work request queue entry.
- * The size of the sg_list is determined when the QP is created and stored
- * in qp->s_max_sge.
- */
-struct qib_swqe {
-	union {
-		struct ib_send_wr wr;   /* don't use wr.sg_list */
-		struct ib_ud_wr ud_wr;
-		struct ib_reg_wr reg_wr;
-		struct ib_rdma_wr rdma_wr;
-		struct ib_atomic_wr atomic_wr;
-	};
-	u32 psn;                /* first packet sequence number */
-	u32 lpsn;               /* last packet sequence number */
-	u32 ssn;                /* send sequence number */
-	u32 length;             /* total length of data in sg_list */
-	struct qib_sge sg_list[0];
-};
-
-/*
- * Receive work request queue entry.
- * The size of the sg_list is determined when the QP (or SRQ) is created
- * and stored in qp->r_rq.max_sge (or srq->rq.max_sge).
- */
-struct qib_rwqe {
-	u64 wr_id;
-	u8 num_sge;
-	struct ib_sge sg_list[0];
-};
-
-/*
- * This structure is used to contain the head pointer, tail pointer,
- * and receive work queue entries as a single memory allocation so
- * it can be mmap'ed into user space.
- * Note that the wq array elements are variable size so you can't
- * just index into the array to get the N'th element;
- * use get_rwqe_ptr() instead.
- */
-struct qib_rwq {
-	u32 head;               /* new work requests posted to the head */
-	u32 tail;               /* receives pull requests from here. */
-	struct qib_rwqe wq[0];
-};
-
-struct qib_rq {
-	struct qib_rwq *wq;
-	u32 size;               /* size of RWQE array */
-	u8 max_sge;
-	spinlock_t lock /* protect changes in this struct */
-		____cacheline_aligned_in_smp;
+	struct rvt_mmap_info *ip;
 };
 
 struct qib_srq {
 	struct ib_srq ibsrq;
-	struct qib_rq rq;
-	struct qib_mmap_info *ip;
+	struct rvt_rq rq;
+	struct rvt_mmap_info *ip;
 	/* send signal when number of RWQEs < limit */
 	u32 limit;
 };
 
-struct qib_sge_state {
-	struct qib_sge *sg_list;      /* next SGE to be used if any */
-	struct qib_sge sge;   /* progress state for the current SGE */
-	u32 total_len;
-	u8 num_sge;
-};
-
-/*
- * This structure holds the information that the send tasklet needs
- * to send a RDMA read response or atomic operation.
- */
-struct qib_ack_entry {
-	u8 opcode;
-	u8 sent;
-	u32 psn;
-	u32 lpsn;
-	union {
-		struct qib_sge rdma_sge;
-		u64 atomic_data;
-	};
-};
-
 /*
  * qib specific data structure that will be hidden from rvt after the queue pair
  * is made common.
  */
-struct qib_qp;
 struct qib_qp_priv {
 	struct qib_ib_header *s_hdr;    /* next packet header to send */
 	struct list_head iowait;        /* link for wait PIO buf */
@@ -424,121 +277,7 @@ struct qib_qp_priv {
 	struct qib_verbs_txreq *s_tx;
 	struct work_struct s_work;
 	wait_queue_head_t wait_dma;
-	struct qib_qp *owner;
-};
-
-/*
- * Variables prefixed with s_ are for the requester (sender).
- * Variables prefixed with r_ are for the responder (receiver).
- * Variables prefixed with ack_ are for responder replies.
- *
- * Common variables are protected by both r_rq.lock and s_lock in that order
- * which only happens in modify_qp() or changing the QP 'state'.
- */
-struct qib_qp {
-	struct ib_qp ibqp;
-	struct qib_qp_priv *priv;
-	/* read mostly fields above and below */
-	struct ib_ah_attr remote_ah_attr;
-	struct ib_ah_attr alt_ah_attr;
-	struct qib_qp __rcu *next;            /* link list for QPN hash table */
-	struct qib_swqe *s_wq;  /* send work queue */
-	struct qib_mmap_info *ip;
-	unsigned long timeout_jiffies;  /* computed from timeout */
-
-	enum ib_mtu path_mtu;
-	u32 remote_qpn;
-	u32 pmtu;		/* decoded from path_mtu */
-	u32 qkey;               /* QKEY for this QP (for UD or RD) */
-	u32 s_size;             /* send work queue size */
-	u32 s_rnr_timeout;      /* number of milliseconds for RNR timeout */
-
-	u8 state;               /* QP state */
-	u8 qp_access_flags;
-	u8 alt_timeout;         /* Alternate path timeout for this QP */
-	u8 timeout;             /* Timeout for this QP */
-	u8 s_srate;
-	u8 s_mig_state;
-	u8 port_num;
-	u8 s_pkey_index;        /* PKEY index to use */
-	u8 s_alt_pkey_index;    /* Alternate path PKEY index to use */
-	u8 r_max_rd_atomic;     /* max number of RDMA read/atomic to receive */
-	u8 s_max_rd_atomic;     /* max number of RDMA read/atomic to send */
-	u8 s_retry_cnt;         /* number of times to retry */
-	u8 s_rnr_retry_cnt;
-	u8 r_min_rnr_timer;     /* retry timeout value for RNR NAKs */
-	u8 s_max_sge;           /* size of s_wq->sg_list */
-	u8 s_draining;
-
-	/* start of read/write fields */
-
-	atomic_t refcount ____cacheline_aligned_in_smp;
-	wait_queue_head_t wait;
-
-
-	struct qib_ack_entry s_ack_queue[QIB_MAX_RDMA_ATOMIC + 1]
-		____cacheline_aligned_in_smp;
-	struct qib_sge_state s_rdma_read_sge;
-
-	spinlock_t r_lock ____cacheline_aligned_in_smp;      /* used for APM */
-	unsigned long r_aflags;
-	u64 r_wr_id;            /* ID for current receive WQE */
-	u32 r_ack_psn;          /* PSN for next ACK or atomic ACK */
-	u32 r_len;              /* total length of r_sge */
-	u32 r_rcv_len;          /* receive data len processed */
-	u32 r_psn;              /* expected rcv packet sequence number */
-	u32 r_msn;              /* message sequence number */
-
-	u8 r_state;             /* opcode of last packet received */
-	u8 r_flags;
-	u8 r_head_ack_queue;    /* index into s_ack_queue[] */
-
-	struct list_head rspwait;       /* link for waititing to respond */
-
-	struct qib_sge_state r_sge;     /* current receive data */
-	struct qib_rq r_rq;             /* receive work queue */
-
-	spinlock_t s_lock ____cacheline_aligned_in_smp;
-	struct qib_sge_state *s_cur_sge;
-	u32 s_flags;
-
-	struct qib_swqe *s_wqe;
-	struct qib_sge_state s_sge;     /* current send request data */
-	struct qib_mregion *s_rdma_mr;
-
-	u32 s_cur_size;         /* size of send packet in bytes */
-	u32 s_len;              /* total length of s_sge */
-	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
-	u32 s_next_psn;         /* PSN for next request */
-	u32 s_last_psn;         /* last response PSN processed */
-	u32 s_sending_psn;      /* lowest PSN that is being sent */
-	u32 s_sending_hpsn;     /* highest PSN that is being sent */
-	u32 s_psn;              /* current packet sequence number */
-	u32 s_ack_rdma_psn;     /* PSN for sending RDMA read responses */
-	u32 s_ack_psn;          /* PSN for acking sends and RDMA writes */
-	u32 s_head;             /* new entries added here */
-	u32 s_tail;             /* next entry to process */
-	u32 s_cur;              /* current work queue entry */
-	u32 s_acked;            /* last un-ACK'ed entry */
-	u32 s_last;             /* last completed entry */
-	u32 s_ssn;              /* SSN of tail entry */
-	u32 s_lsn;              /* limit sequence number (credit) */
-	u16 s_hdrwords;         /* size of s_hdr in 32 bit words */
-	u16 s_rdma_ack_cnt;
-	u8 s_state;             /* opcode of last packet sent */
-	u8 s_ack_state;         /* opcode of packet to ACK */
-	u8 s_nak_state;         /* non-zero if NAK is pending */
-	u8 r_nak_state;         /* non-zero if NAK is pending */
-	u8 s_retry;             /* requester retry counter */
-	u8 s_rnr_retry;         /* requester RNR retry counter */
-	u8 s_num_rd_atomic;     /* number of RDMA read/atomic pending */
-	u8 s_tail_ack_queue;    /* index into s_ack_queue[] */
-
-	struct qib_sge_state s_ack_rdma_sge;
-	struct timer_list s_timer;
-
-	struct qib_sge r_sg_list[0] /* verified SGEs */
-		____cacheline_aligned_in_smp;
+	struct rvt_qp *owner;
 };
 
 /*
@@ -616,27 +355,27 @@ struct qib_qp {
 #define QIB_PSN_CREDIT  16
 
 /*
- * Since struct qib_swqe is not a fixed size, we can't simply index into
- * struct qib_qp.s_wq.  This function does the array index computation.
+ * Since struct rvt_swqe is not a fixed size, we can't simply index into
+ * struct rvt_qp.s_wq.  This function does the array index computation.
  */
-static inline struct qib_swqe *get_swqe_ptr(struct qib_qp *qp,
-					      unsigned n)
+static inline struct rvt_swqe *get_swqe_ptr(struct rvt_qp *qp,
+					    unsigned n)
 {
-	return (struct qib_swqe *)((char *)qp->s_wq +
-				     (sizeof(struct qib_swqe) +
+	return (struct rvt_swqe *)((char *)qp->s_wq +
+				     (sizeof(struct rvt_swqe) +
 				      qp->s_max_sge *
-				      sizeof(struct qib_sge)) * n);
+				      sizeof(struct rvt_sge)) * n);
 }
 
 /*
- * Since struct qib_rwqe is not a fixed size, we can't simply index into
- * struct qib_rwq.wq.  This function does the array index computation.
+ * Since struct rvt_rwqe is not a fixed size, we can't simply index into
+ * struct rvt_rwq.wq.  This function does the array index computation.
  */
-static inline struct qib_rwqe *get_rwqe_ptr(struct qib_rq *rq, unsigned n)
+static inline struct rvt_rwqe *get_rwqe_ptr(struct rvt_rq *rq, unsigned n)
 {
-	return (struct qib_rwqe *)
+	return (struct rvt_rwqe *)
 		((char *) rq->wq->wq +
-		 (sizeof(struct qib_rwqe) +
+		 (sizeof(struct rvt_rwqe) +
 		  rq->max_sge * sizeof(struct ib_sge)) * n);
 }
 
@@ -660,16 +399,6 @@ struct qib_qpn_table {
 	struct qpn_map map[QPNMAP_ENTRIES];
 };
 
-#define MAX_LKEY_TABLE_BITS 23
-
-struct qib_lkey_table {
-	spinlock_t lock; /* protect changes in this struct */
-	u32 next;               /* next unused index (speeds search) */
-	u32 gen;                /* generation count */
-	u32 max;                /* size of the table */
-	struct qib_mregion __rcu **table;
-};
-
 struct qib_opcode_stats {
 	u64 n_packets;          /* number of packets */
 	u64 n_bytes;            /* total number of bytes */
@@ -687,8 +416,8 @@ struct qib_pma_counters {
 };
 
 struct qib_ibport {
-	struct qib_qp __rcu *qp0;
-	struct qib_qp __rcu *qp1;
+	struct rvt_qp __rcu *qp0;
+	struct rvt_qp __rcu *qp1;
 	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
 	struct qib_ah *sm_ah;
 	struct qib_ah *smi_ah;
@@ -761,18 +490,16 @@ struct qib_ibdev {
 	struct list_head pending_mmaps;
 	spinlock_t mmap_offset_lock; /* protect mmap_offset */
 	u32 mmap_offset;
-	struct qib_mregion __rcu *dma_mr;
 
 	/* QP numbers are shared by all IB ports */
 	struct qib_qpn_table qpn_table;
-	struct qib_lkey_table lk_table;
 	struct list_head piowait;       /* list for wait PIO buf */
 	struct list_head dmawait;	/* list for wait DMA */
 	struct list_head txwait;        /* list for wait qib_verbs_txreq */
 	struct list_head memwait;       /* list for wait kernel memory */
 	struct list_head txreq_free;
 	struct timer_list mem_timer;
-	struct qib_qp __rcu **qp_table;
+	struct rvt_qp __rcu **qp_table;
 	struct qib_pio_header *pio_hdrs;
 	dma_addr_t pio_hdrs_phys;
 	/* list of QPs waiting for RNR timer */
@@ -818,11 +545,6 @@ struct qib_verbs_counters {
 	u32 vl15_dropped;
 };
 
-static inline struct qib_mr *to_imr(struct ib_mr *ibmr)
-{
-	return container_of(ibmr, struct qib_mr, ibmr);
-}
-
 static inline struct qib_ah *to_iah(struct ib_ah *ibah)
 {
 	return container_of(ibah, struct qib_ah, ibah);
@@ -838,9 +560,9 @@ static inline struct qib_srq *to_isrq(struct ib_srq *ibsrq)
 	return container_of(ibsrq, struct qib_srq, ibsrq);
 }
 
-static inline struct qib_qp *to_iqp(struct ib_qp *ibqp)
+static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
 {
-	return container_of(ibqp, struct qib_qp, ibqp);
+	return container_of(ibqp, struct rvt_qp, ibqp);
 }
 
 static inline struct qib_ibdev *to_idev(struct ib_device *ibdev)
@@ -855,7 +577,7 @@ static inline struct qib_ibdev *to_idev(struct ib_device *ibdev)
  * Send if not busy or waiting for I/O and either
  * a RC response is pending or we can process send work requests.
  */
-static inline int qib_send_ok(struct qib_qp *qp)
+static inline int qib_send_ok(struct rvt_qp *qp)
 {
 	return !(qp->s_flags & (QIB_S_BUSY | QIB_S_ANY_WAIT_IO)) &&
 		(qp->s_hdrwords || (qp->s_flags & QIB_S_RESP_PENDING) ||
@@ -865,7 +587,7 @@ static inline int qib_send_ok(struct qib_qp *qp)
 /*
  * This must be called with s_lock held.
  */
-void qib_schedule_send(struct qib_qp *qp);
+void qib_schedule_send(struct rvt_qp *qp);
 
 static inline int qib_pkey_ok(u16 pkey1, u16 pkey2)
 {
@@ -916,9 +638,9 @@ int qib_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);
 
 int qib_mcast_tree_empty(struct qib_ibport *ibp);
 
-__be32 qib_compute_aeth(struct qib_qp *qp);
+__be32 qib_compute_aeth(struct rvt_qp *qp);
 
-struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn);
+struct rvt_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn);
 
 struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 			    struct ib_qp_init_attr *init_attr,
@@ -926,7 +648,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 
 int qib_destroy_qp(struct ib_qp *ibqp);
 
-int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err);
+int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
 
 int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_udata *udata);
@@ -952,7 +674,7 @@ void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter);
 
 #endif
 
-void qib_get_credit(struct qib_qp *qp, u32 aeth);
+void qib_get_credit(struct rvt_qp *qp, u32 aeth);
 
 unsigned qib_pkt_delay(u32 plen, u8 snd_mult, u8 rcv_mult);
 
@@ -960,19 +682,19 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail);
 
 void qib_put_txreq(struct qib_verbs_txreq *tx);
 
-int qib_verbs_send(struct qib_qp *qp, struct qib_ib_header *hdr,
-		   u32 hdrwords, struct qib_sge_state *ss, u32 len);
+int qib_verbs_send(struct rvt_qp *qp, struct qib_ib_header *hdr,
+		   u32 hdrwords, struct rvt_sge_state *ss, u32 len);
 
-void qib_copy_sge(struct qib_sge_state *ss, void *data, u32 length,
+void qib_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
 		  int release);
 
-void qib_skip_sge(struct qib_sge_state *ss, u32 length, int release);
+void qib_skip_sge(struct rvt_sge_state *ss, u32 length, int release);
 
 void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
-		int has_grh, void *data, u32 tlen, struct qib_qp *qp);
+		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 
 void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
-		int has_grh, void *data, u32 tlen, struct qib_qp *qp);
+		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 
@@ -980,24 +702,14 @@ struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid);
 
 void qib_rc_rnr_retry(unsigned long arg);
 
-void qib_rc_send_complete(struct qib_qp *qp, struct qib_ib_header *hdr);
+void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr);
 
-void qib_rc_error(struct qib_qp *qp, enum ib_wc_status err);
+void qib_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
 
-int qib_post_ud_send(struct qib_qp *qp, struct ib_send_wr *wr);
+int qib_post_ud_send(struct rvt_qp *qp, struct ib_send_wr *wr);
 
 void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
-		int has_grh, void *data, u32 tlen, struct qib_qp *qp);
-
-int qib_alloc_lkey(struct qib_mregion *mr, int dma_region);
-
-void qib_free_lkey(struct qib_mregion *mr);
-
-int qib_lkey_ok(struct qib_lkey_table *rkt, struct rvt_pd *pd,
-		struct qib_sge *isge, struct ib_sge *sge, int acc);
-
-int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
-		u32 len, u64 vaddr, u32 rkey, int acc);
+		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 
 int qib_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 			 struct ib_recv_wr **bad_wr);
@@ -1033,97 +745,53 @@ int qib_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags);
 
 int qib_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 
-struct ib_mr *qib_get_dma_mr(struct ib_pd *pd, int acc);
-
-struct ib_mr *qib_reg_phys_mr(struct ib_pd *pd,
-			      struct ib_phys_buf *buffer_list,
-			      int num_phys_buf, int acc, u64 *iova_start);
-
-struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-			      u64 virt_addr, int mr_access_flags,
-			      struct ib_udata *udata);
-
-int qib_dereg_mr(struct ib_mr *ibmr);
-
-struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
-			   enum ib_mr_type mr_type,
-			   u32 max_entries);
-
-int qib_map_mr_sg(struct ib_mr *ibmr,
-		  struct scatterlist *sg,
-		  int sg_nents);
-
-int qib_reg_mr(struct qib_qp *qp, struct ib_reg_wr *wr);
-
-struct ib_fmr *qib_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			     struct ib_fmr_attr *fmr_attr);
-
-int qib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		     int list_len, u64 iova);
-
-int qib_unmap_fmr(struct list_head *fmr_list);
-
-int qib_dealloc_fmr(struct ib_fmr *ibfmr);
-
-static inline void qib_get_mr(struct qib_mregion *mr)
-{
-	atomic_inc(&mr->refcount);
-}
-
 void mr_rcu_callback(struct rcu_head *list);
 
-static inline void qib_put_mr(struct qib_mregion *mr)
-{
-	if (unlikely(atomic_dec_and_test(&mr->refcount)))
-		call_rcu(&mr->list, mr_rcu_callback);
-}
-
-static inline void qib_put_ss(struct qib_sge_state *ss)
+static inline void qib_put_ss(struct rvt_sge_state *ss)
 {
 	while (ss->num_sge) {
-		qib_put_mr(ss->sge.mr);
+		rvt_put_mr(ss->sge.mr);
 		if (--ss->num_sge)
 			ss->sge = *ss->sg_list++;
 	}
 }
 
-
 void qib_release_mmap_info(struct kref *ref);
 
-struct qib_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev, u32 size,
+struct rvt_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev, u32 size,
 					   struct ib_ucontext *context,
 					   void *obj);
 
-void qib_update_mmap_info(struct qib_ibdev *dev, struct qib_mmap_info *ip,
+void qib_update_mmap_info(struct qib_ibdev *dev, struct rvt_mmap_info *ip,
 			  u32 size, void *obj);
 
 int qib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
-int qib_get_rwqe(struct qib_qp *qp, int wr_id_only);
+int qib_get_rwqe(struct rvt_qp *qp, int wr_id_only);
 
-void qib_migrate_qp(struct qib_qp *qp);
+void qib_migrate_qp(struct rvt_qp *qp);
 
 int qib_ruc_check_hdr(struct qib_ibport *ibp, struct qib_ib_header *hdr,
-		      int has_grh, struct qib_qp *qp, u32 bth0);
+		      int has_grh, struct rvt_qp *qp, u32 bth0);
 
 u32 qib_make_grh(struct qib_ibport *ibp, struct ib_grh *hdr,
 		 struct ib_global_route *grh, u32 hwords, u32 nwords);
 
-void qib_make_ruc_header(struct qib_qp *qp, struct qib_other_headers *ohdr,
+void qib_make_ruc_header(struct rvt_qp *qp, struct qib_other_headers *ohdr,
 			 u32 bth0, u32 bth2);
 
 void qib_do_send(struct work_struct *work);
 
-void qib_send_complete(struct qib_qp *qp, struct qib_swqe *wqe,
+void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		       enum ib_wc_status status);
 
-void qib_send_rc_ack(struct qib_qp *qp);
+void qib_send_rc_ack(struct rvt_qp *qp);
 
-int qib_make_rc_req(struct qib_qp *qp);
+int qib_make_rc_req(struct rvt_qp *qp);
 
-int qib_make_uc_req(struct qib_qp *qp);
+int qib_make_uc_req(struct rvt_qp *qp);
 
-int qib_make_ud_req(struct qib_qp *qp);
+int qib_make_ud_req(struct rvt_qp *qp);
 
 int qib_register_ib_device(struct qib_devdata *);
 
@@ -1161,7 +829,7 @@ extern const int ib_qib_state_ops[];
 
 extern __be64 ib_qib_sys_image_guid;    /* in network order */
 
-extern unsigned int ib_qib_lkey_table_size;
+extern unsigned int ib_rvt_lkey_table_size;
 
 extern unsigned int ib_qib_max_cqes;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs_mcast.c b/drivers/infiniband/hw/qib/qib_verbs_mcast.c
index f8ea069..73b487b 100644
--- a/drivers/infiniband/hw/qib/qib_verbs_mcast.c
+++ b/drivers/infiniband/hw/qib/qib_verbs_mcast.c
@@ -39,7 +39,7 @@
  * qib_mcast_qp_alloc - alloc a struct to link a QP to mcast GID struct
  * @qp: the QP to link
  */
-static struct qib_mcast_qp *qib_mcast_qp_alloc(struct qib_qp *qp)
+static struct qib_mcast_qp *qib_mcast_qp_alloc(struct rvt_qp *qp)
 {
 	struct qib_mcast_qp *mqp;
 
@@ -56,7 +56,7 @@ bail:
 
 static void qib_mcast_qp_free(struct qib_mcast_qp *mqp)
 {
-	struct qib_qp *qp = mqp->qp;
+	struct rvt_qp *qp = mqp->qp;
 
 	/* Notify qib_destroy_qp() if it is waiting. */
 	if (atomic_dec_and_test(&qp->refcount))
@@ -224,7 +224,7 @@ bail:
 
 int qib_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct qib_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct qib_ibdev *dev = to_idev(ibqp->device);
 	struct qib_ibport *ibp;
 	struct qib_mcast *mcast;
@@ -282,7 +282,7 @@ bail:
 
 int qib_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct qib_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct qib_ibdev *dev = to_idev(ibqp->device);
 	struct qib_ibport *ibp = to_iport(ibqp->device, qp->port_num);
 	struct qib_mcast *mcast = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
