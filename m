From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 26/36] IB/rdmavt: Move memory registration into rdmavt
Date: Wed, 06 Jan 2016 10:03:31 -0800
Message-ID: <20160106180312.8747.52217.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the memory registration routines in hfi1 and move them to rdmavt.
A follow on patch will address removing the duplicated code in the
hfi1 and qib drivers.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Remove rvt_reg_phys_mr

 drivers/infiniband/sw/rdmavt/mr.c |  683 ++++++++++++++++++++++++++++++++++++-
 drivers/infiniband/sw/rdmavt/mr.h |   23 +
 drivers/infiniband/sw/rdmavt/vt.c |   24 +
 include/rdma/rdma_vt.h            |   19 +
 4 files changed, 734 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index c672043..f1dcaf4 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -46,8 +46,252 @@
  */
 
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <rdma/ib_umem.h>
+#include <rdma/rdma_vt.h>
+#include "vt.h"
 #include "mr.h"
 
+/*
+ * Do any intilization needed when a driver registers with rdmavt.
+ */
+int rvt_driver_mr_init(struct rvt_dev_info *rdi)
+{
+	unsigned int lkey_table_size = rdi->dparms.lkey_table_size;
+	unsigned lk_tab_size;
+	int i;
+
+	if (rdi->flags & RVT_FLAG_MR_INIT_DRIVER) {
+		rvt_pr_info(rdi, "Driver is doing MR init.\n");
+		return 0;
+	}
+
+	/*
+	 * The top hfi1_lkey_table_size bits are used to index the
+	 * table.  The lower 8 bits can be owned by the user (copied from
+	 * the LKEY).  The remaining bits act as a generation number or tag.
+	 */
+	if (!lkey_table_size)
+		return -EINVAL;
+
+	spin_lock_init(&rdi->lkey_table.lock);
+
+	rdi->lkey_table.max = 1 << lkey_table_size;
+
+	/* ensure generation is at least 4 bits */
+	if (lkey_table_size > RVT_MAX_LKEY_TABLE_BITS) {
+		rvt_pr_warn(rdi, "lkey bits %u too large, reduced to %u\n",
+			    lkey_table_size, RVT_MAX_LKEY_TABLE_BITS);
+		rdi->dparms.lkey_table_size = RVT_MAX_LKEY_TABLE_BITS;
+		lkey_table_size = rdi->dparms.lkey_table_size;
+	}
+	lk_tab_size = rdi->lkey_table.max * sizeof(*rdi->lkey_table.table);
+	rdi->lkey_table.table = (struct rvt_mregion __rcu **)
+			       vmalloc(lk_tab_size);
+	if (!rdi->lkey_table.table)
+		return -ENOMEM;
+
+	RCU_INIT_POINTER(rdi->dma_mr, NULL);
+	for (i = 0; i < rdi->lkey_table.max; i++)
+		RCU_INIT_POINTER(rdi->lkey_table.table[i], NULL);
+
+	return 0;
+}
+
+/*
+ * called when drivers have unregistered or perhaps failed to register with us
+ */
+void rvt_mr_exit(struct rvt_dev_info *rdi)
+{
+	if (rdi->dma_mr)
+		rvt_pr_err(rdi, "DMA MR not null!\n");
+
+	vfree(rdi->lkey_table.table);
+}
+
+static void rvt_deinit_mregion(struct rvt_mregion *mr)
+{
+	int i = mr->mapsz;
+
+	mr->mapsz = 0;
+	while (i)
+		kfree(mr->map[--i]);
+}
+
+static int rvt_init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
+			    int count)
+{
+	int m, i = 0;
+
+	mr->mapsz = 0;
+	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
+	for (; i < m; i++) {
+		mr->map[i] = kzalloc(sizeof(*mr->map[0]), GFP_KERNEL);
+		if (!mr->map[i]) {
+			rvt_deinit_mregion(mr);
+			return -ENOMEM;
+		}
+		mr->mapsz++;
+	}
+	init_completion(&mr->comp);
+	/* count returning the ptr to user */
+	atomic_set(&mr->refcount, 1);
+	mr->pd = pd;
+	mr->max_segs = count;
+	return 0;
+}
+
+/**
+ * rvt_alloc_lkey - allocate an lkey
+ * @mr: memory region that this lkey protects
+ * @dma_region: 0->normal key, 1->restricted DMA key
+ *
+ * Returns 0 if successful, otherwise returns -errno.
+ *
+ * Increments mr reference count as required.
+ *
+ * Sets the lkey field mr for non-dma regions.
+ *
+ */
+static int rvt_alloc_lkey(struct rvt_mregion *mr, int dma_region)
+{
+	unsigned long flags;
+	u32 r;
+	u32 n;
+	int ret = 0;
+	struct rvt_dev_info *dev = ib_to_rvt(mr->pd->device);
+	struct rvt_lkey_table *rkt = &dev->lkey_table;
+
+	rvt_get_mr(mr);
+	spin_lock_irqsave(&rkt->lock, flags);
+
+	/* special case for dma_mr lkey == 0 */
+	if (dma_region) {
+		struct rvt_mregion *tmr;
+
+		tmr = rcu_access_pointer(dev->dma_mr);
+		if (!tmr) {
+			rcu_assign_pointer(dev->dma_mr, mr);
+			mr->lkey_published = 1;
+		} else {
+			rvt_put_mr(mr);
+		}
+		goto success;
+	}
+
+	/* Find the next available LKEY */
+	r = rkt->next;
+	n = r;
+	for (;;) {
+		if (!rcu_access_pointer(rkt->table[r]))
+			break;
+		r = (r + 1) & (rkt->max - 1);
+		if (r == n)
+			goto bail;
+	}
+	rkt->next = (r + 1) & (rkt->max - 1);
+	/*
+	 * Make sure lkey is never zero which is reserved to indicate an
+	 * unrestricted LKEY.
+	 */
+	rkt->gen++;
+	/*
+	 * bits are capped to ensure enough bits for generation number
+	 */
+	mr->lkey = (r << (32 - dev->dparms.lkey_table_size)) |
+		((((1 << (24 - dev->dparms.lkey_table_size)) - 1) & rkt->gen)
+		 << 8);
+	if (mr->lkey == 0) {
+		mr->lkey |= 1 << 8;
+		rkt->gen++;
+	}
+	rcu_assign_pointer(rkt->table[r], mr);
+	mr->lkey_published = 1;
+success:
+	spin_unlock_irqrestore(&rkt->lock, flags);
+out:
+	return ret;
+bail:
+	rvt_put_mr(mr);
+	spin_unlock_irqrestore(&rkt->lock, flags);
+	ret = -ENOMEM;
+	goto out;
+}
+
+/**
+ * rvt_free_lkey - free an lkey
+ * @mr: mr to free from tables
+ */
+static void rvt_free_lkey(struct rvt_mregion *mr)
+{
+	unsigned long flags;
+	u32 lkey = mr->lkey;
+	u32 r;
+	struct rvt_dev_info *dev = ib_to_rvt(mr->pd->device);
+	struct rvt_lkey_table *rkt = &dev->lkey_table;
+	int freed = 0;
+
+	spin_lock_irqsave(&rkt->lock, flags);
+	if (!mr->lkey_published)
+		goto out;
+	if (lkey == 0) {
+		RCU_INIT_POINTER(dev->dma_mr, NULL);
+	} else {
+		r = lkey >> (32 - dev->dparms.lkey_table_size);
+		RCU_INIT_POINTER(rkt->table[r], NULL);
+	}
+	mr->lkey_published = 0;
+	freed++;
+out:
+	spin_unlock_irqrestore(&rkt->lock, flags);
+	if (freed) {
+		synchronize_rcu();
+		rvt_put_mr(mr);
+	}
+}
+
+static struct rvt_mr *__rvt_alloc_mr(int count, struct ib_pd *pd)
+{
+	struct rvt_mr *mr;
+	int rval = -ENOMEM;
+	int m;
+
+	/* Allocate struct plus pointers to first level page tables. */
+	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
+	mr = kzalloc(sizeof(*mr) + m * sizeof(mr->mr.map[0]), GFP_KERNEL);
+	if (!mr)
+		goto bail;
+
+	rval = rvt_init_mregion(&mr->mr, pd, count);
+	if (rval)
+		goto bail;
+	/*
+	 * ib_reg_phys_mr() will initialize mr->ibmr except for
+	 * lkey and rkey.
+	 */
+	rval = rvt_alloc_lkey(&mr->mr, 0);
+	if (rval)
+		goto bail_mregion;
+	mr->ibmr.lkey = mr->mr.lkey;
+	mr->ibmr.rkey = mr->mr.lkey;
+done:
+	return mr;
+
+bail_mregion:
+	rvt_deinit_mregion(&mr->mr);
+bail:
+	kfree(mr);
+	mr = ERR_PTR(rval);
+	goto done;
+}
+
+static void __rvt_free_mr(struct rvt_mr *mr)
+{
+	rvt_deinit_mregion(&mr->mr);
+	rvt_free_lkey(&mr->mr);
+	vfree(mr);
+}
+
 /**
  * rvt_get_dma_mr - get a DMA memory region
  * @pd: protection domain for this memory region
@@ -59,11 +303,41 @@
  */
 struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc)
 {
-	/*
-	 * Alloc mr and init it.
-	 * Alloc lkey.
-	 */
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_mr *mr;
+	struct ib_mr *ret;
+	int rval;
+
+	if (ibpd_to_rvtpd(pd)->user)
+		return ERR_PTR(-EPERM);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr) {
+		ret = ERR_PTR(-ENOMEM);
+		goto bail;
+	}
+
+	rval = rvt_init_mregion(&mr->mr, pd, 0);
+	if (rval) {
+		ret = ERR_PTR(rval);
+		goto bail;
+	}
+
+	rval = rvt_alloc_lkey(&mr->mr, 1);
+	if (rval) {
+		ret = ERR_PTR(rval);
+		goto bail_mregion;
+	}
+
+	mr->mr.access_flags = acc;
+	ret = &mr->ibmr;
+done:
+	return ret;
+
+bail_mregion:
+	rvt_deinit_mregion(&mr->mr);
+bail:
+	kfree(mr);
+	goto done;
 }
 
 /**
@@ -80,7 +354,64 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			      u64 virt_addr, int mr_access_flags,
 			      struct ib_udata *udata)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_mr *mr;
+	struct ib_umem *umem;
+	struct scatterlist *sg;
+	int n, m, entry;
+	struct ib_mr *ret;
+
+	if (length == 0)
+		return ERR_PTR(-EINVAL);
+
+	umem = ib_umem_get(pd->uobject->context, start, length,
+			   mr_access_flags, 0);
+	if (IS_ERR(umem))
+		return (void *)umem;
+
+	n = umem->nmap;
+
+	mr = __rvt_alloc_mr(n, pd);
+	if (IS_ERR(mr)) {
+		ret = (struct ib_mr *)mr;
+		goto bail_umem;
+	}
+
+	mr->mr.user_base = start;
+	mr->mr.iova = virt_addr;
+	mr->mr.length = length;
+	mr->mr.offset = ib_umem_offset(umem);
+	mr->mr.access_flags = mr_access_flags;
+	mr->umem = umem;
+
+	if (is_power_of_2(umem->page_size))
+		mr->mr.page_shift = ilog2(umem->page_size);
+	m = 0;
+	n = 0;
+	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
+		void *vaddr;
+
+		vaddr = page_address(sg_page(sg));
+		if (!vaddr) {
+			ret = ERR_PTR(-EINVAL);
+			goto bail_inval;
+		}
+		mr->mr.map[m]->segs[n].vaddr = vaddr;
+		mr->mr.map[m]->segs[n].length = umem->page_size;
+		n++;
+		if (n == RVT_SEGSZ) {
+			m++;
+			n = 0;
+		}
+	}
+	return &mr->ibmr;
+
+bail_inval:
+	__rvt_free_mr(mr);
+
+bail_umem:
+	ib_umem_release(umem);
+
+	return ret;
 }
 
 /**
@@ -94,7 +425,29 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
  */
 int rvt_dereg_mr(struct ib_mr *ibmr)
 {
-	return -EOPNOTSUPP;
+	struct rvt_mr *mr = to_imr(ibmr);
+	struct rvt_dev_info *rdi = ib_to_rvt(ibmr->pd->device);
+	int ret = 0;
+	unsigned long timeout;
+
+	rvt_free_lkey(&mr->mr);
+
+	rvt_put_mr(&mr->mr); /* will set completion if last */
+	timeout = wait_for_completion_timeout(&mr->mr.comp, 5 * HZ);
+	if (!timeout) {
+		rvt_pr_err(rdi,
+			   "rvt_dereg_mr timeout mr %p pd %p refcount %u\n",
+			   mr, mr->mr.pd, atomic_read(&mr->mr.refcount));
+		rvt_get_mr(&mr->mr);
+		ret = -EBUSY;
+		goto out;
+	}
+	rvt_deinit_mregion(&mr->mr);
+	if (mr->umem)
+		ib_umem_release(mr->umem);
+	kfree(mr);
+out:
+	return ret;
 }
 
 /**
@@ -109,7 +462,16 @@ struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
 			   enum ib_mr_type mr_type,
 			   u32 max_num_sg)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_mr *mr;
+
+	if (mr_type != IB_MR_TYPE_MEM_REG)
+		return ERR_PTR(-EINVAL);
+
+	mr = __rvt_alloc_mr(max_num_sg, pd);
+	if (IS_ERR(mr))
+		return (struct ib_mr *)mr;
+
+	return &mr->ibmr;
 }
 
 /**
@@ -123,7 +485,48 @@ struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
 struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 			     struct ib_fmr_attr *fmr_attr)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_fmr *fmr;
+	int m;
+	struct ib_fmr *ret;
+	int rval = -ENOMEM;
+
+	/* Allocate struct plus pointers to first level page tables. */
+	m = (fmr_attr->max_pages + RVT_SEGSZ - 1) / RVT_SEGSZ;
+	fmr = kzalloc(sizeof(*fmr) + m * sizeof(fmr->mr.map[0]), GFP_KERNEL);
+	if (!fmr)
+		goto bail;
+
+	rval = rvt_init_mregion(&fmr->mr, pd, fmr_attr->max_pages);
+	if (rval)
+		goto bail;
+
+	/*
+	 * ib_alloc_fmr() will initialize fmr->ibfmr except for lkey &
+	 * rkey.
+	 */
+	rval = rvt_alloc_lkey(&fmr->mr, 0);
+	if (rval)
+		goto bail_mregion;
+	fmr->ibfmr.rkey = fmr->mr.lkey;
+	fmr->ibfmr.lkey = fmr->mr.lkey;
+	/*
+	 * Resources are allocated but no valid mapping (RKEY can't be
+	 * used).
+	 */
+	fmr->mr.access_flags = mr_access_flags;
+	fmr->mr.max_segs = fmr_attr->max_pages;
+	fmr->mr.page_shift = fmr_attr->page_shift;
+
+	ret = &fmr->ibfmr;
+done:
+	return ret;
+
+bail_mregion:
+	rvt_deinit_mregion(&fmr->mr);
+bail:
+	kfree(fmr);
+	ret = ERR_PTR(rval);
+	goto done;
 }
 
 /**
@@ -139,7 +542,38 @@ struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 		     int list_len, u64 iova)
 {
-	return -EOPNOTSUPP;
+	struct rvt_fmr *fmr = to_ifmr(ibfmr);
+	struct rvt_lkey_table *rkt;
+	unsigned long flags;
+	int m, n, i;
+	u32 ps;
+	struct rvt_dev_info *rdi = ib_to_rvt(ibfmr->device);
+
+	i = atomic_read(&fmr->mr.refcount);
+	if (i > 2)
+		return -EBUSY;
+
+	if (list_len > fmr->mr.max_segs)
+		return -EINVAL;
+
+	rkt = &rdi->lkey_table;
+	spin_lock_irqsave(&rkt->lock, flags);
+	fmr->mr.user_base = iova;
+	fmr->mr.iova = iova;
+	ps = 1 << fmr->mr.page_shift;
+	fmr->mr.length = list_len * ps;
+	m = 0;
+	n = 0;
+	for (i = 0; i < list_len; i++) {
+		fmr->mr.map[m]->segs[n].vaddr = (void *)page_list[i];
+		fmr->mr.map[m]->segs[n].length = ps;
+		if (++n == RVT_SEGSZ) {
+			m++;
+			n = 0;
+		}
+	}
+	spin_unlock_irqrestore(&rkt->lock, flags);
+	return 0;
 }
 
 /**
@@ -150,7 +584,21 @@ int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
  */
 int rvt_unmap_fmr(struct list_head *fmr_list)
 {
-	return -EOPNOTSUPP;
+	struct rvt_fmr *fmr;
+	struct rvt_lkey_table *rkt;
+	unsigned long flags;
+	struct rvt_dev_info *rdi;
+
+	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
+		rdi = ib_to_rvt(fmr->ibfmr.device);
+		rkt = &rdi->lkey_table;
+		spin_lock_irqsave(&rkt->lock, flags);
+		fmr->mr.user_base = 0;
+		fmr->mr.iova = 0;
+		fmr->mr.length = 0;
+		spin_unlock_irqrestore(&rkt->lock, flags);
+	}
+	return 0;
 }
 
 /**
@@ -161,5 +609,216 @@ int rvt_unmap_fmr(struct list_head *fmr_list)
  */
 int rvt_dealloc_fmr(struct ib_fmr *ibfmr)
 {
-	return -EOPNOTSUPP;
+	struct rvt_fmr *fmr = to_ifmr(ibfmr);
+	int ret = 0;
+	unsigned long timeout;
+
+	rvt_free_lkey(&fmr->mr);
+	rvt_put_mr(&fmr->mr); /* will set completion if last */
+	timeout = wait_for_completion_timeout(&fmr->mr.comp, 5 * HZ);
+	if (!timeout) {
+		rvt_get_mr(&fmr->mr);
+		ret = -EBUSY;
+		goto out;
+	}
+	rvt_deinit_mregion(&fmr->mr);
+	kfree(fmr);
+out:
+	return ret;
+}
+
+/**
+ * rvt_lkey_ok - check IB SGE for validity and initialize
+ * @rkt: table containing lkey to check SGE against
+ * @pd: protection domain
+ * @isge: outgoing internal SGE
+ * @sge: SGE to check
+ * @acc: access flags
+ *
+ * Return 1 if valid and successful, otherwise returns 0.
+ *
+ * increments the reference count upon success
+ *
+ * Check the IB SGE for validity and initialize our internal version
+ * of it.
+ */
+int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
+		struct rvt_sge *isge, struct ib_sge *sge, int acc)
+{
+	struct rvt_mregion *mr;
+	unsigned n, m;
+	size_t off;
+	struct rvt_dev_info *dev = ib_to_rvt(pd->ibpd.device);
+
+	/*
+	 * We use LKEY == zero for kernel virtual addresses
+	 * (see rvt_get_dma_mr and dma.c).
+	 */
+	rcu_read_lock();
+	if (sge->lkey == 0) {
+		if (pd->user)
+			goto bail;
+		mr = rcu_dereference(dev->dma_mr);
+		if (!mr)
+			goto bail;
+		atomic_inc(&mr->refcount);
+		rcu_read_unlock();
+
+		isge->mr = mr;
+		isge->vaddr = (void *)sge->addr;
+		isge->length = sge->length;
+		isge->sge_length = sge->length;
+		isge->m = 0;
+		isge->n = 0;
+		goto ok;
+	}
+	mr = rcu_dereference(
+		rkt->table[(sge->lkey >> (32 - dev->dparms.lkey_table_size))]);
+	if (unlikely(!mr || mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
+		goto bail;
+
+	off = sge->addr - mr->user_base;
+	if (unlikely(sge->addr < mr->user_base ||
+		     off + sge->length > mr->length ||
+		     (mr->access_flags & acc) != acc))
+		goto bail;
+	atomic_inc(&mr->refcount);
+	rcu_read_unlock();
+
+	off += mr->offset;
+	if (mr->page_shift) {
+		/*
+		 * page sizes are uniform power of 2 so no loop is necessary
+		 * entries_spanned_by_off is the number of times the loop below
+		 * would have executed.
+		*/
+		size_t entries_spanned_by_off;
+
+		entries_spanned_by_off = off >> mr->page_shift;
+		off -= (entries_spanned_by_off << mr->page_shift);
+		m = entries_spanned_by_off / RVT_SEGSZ;
+		n = entries_spanned_by_off % RVT_SEGSZ;
+	} else {
+		m = 0;
+		n = 0;
+		while (off >= mr->map[m]->segs[n].length) {
+			off -= mr->map[m]->segs[n].length;
+			n++;
+			if (n >= RVT_SEGSZ) {
+				m++;
+				n = 0;
+			}
+		}
+	}
+	isge->mr = mr;
+	isge->vaddr = mr->map[m]->segs[n].vaddr + off;
+	isge->length = mr->map[m]->segs[n].length - off;
+	isge->sge_length = sge->length;
+	isge->m = m;
+	isge->n = n;
+ok:
+	return 1;
+bail:
+	rcu_read_unlock();
+	return 0;
+}
+EXPORT_SYMBOL(rvt_lkey_ok);
+
+/**
+ * rvt_rkey_ok - check the IB virtual address, length, and RKEY
+ * @qp: qp for validation
+ * @sge: SGE state
+ * @len: length of data
+ * @vaddr: virtual address to place data
+ * @rkey: rkey to check
+ * @acc: access flags
+ *
+ * Return 1 if successful, otherwise 0.
+ *
+ * increments the reference count upon success
+ */
+int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
+		u32 len, u64 vaddr, u32 rkey, int acc)
+{
+	struct rvt_dev_info *dev = ib_to_rvt(qp->ibqp.device);
+	struct rvt_lkey_table *rkt = &dev->lkey_table;
+	struct rvt_mregion *mr;
+	unsigned n, m;
+	size_t off;
+
+	/*
+	 * We use RKEY == zero for kernel virtual addresses
+	 * (see rvt_get_dma_mr and dma.c).
+	 */
+	rcu_read_lock();
+	if (rkey == 0) {
+		struct rvt_pd *pd = ibpd_to_rvtpd(qp->ibqp.pd);
+		struct rvt_dev_info *rdi = ib_to_rvt(pd->ibpd.device);
+
+		if (pd->user)
+			goto bail;
+		mr = rcu_dereference(rdi->dma_mr);
+		if (!mr)
+			goto bail;
+		atomic_inc(&mr->refcount);
+		rcu_read_unlock();
+
+		sge->mr = mr;
+		sge->vaddr = (void *)vaddr;
+		sge->length = len;
+		sge->sge_length = len;
+		sge->m = 0;
+		sge->n = 0;
+		goto ok;
+	}
+
+	mr = rcu_dereference(
+		rkt->table[(rkey >> (32 - dev->dparms.lkey_table_size))]);
+	if (unlikely(!mr || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
+		goto bail;
+
+	off = vaddr - mr->iova;
+	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
+		     (mr->access_flags & acc) == 0))
+		goto bail;
+	atomic_inc(&mr->refcount);
+	rcu_read_unlock();
+
+	off += mr->offset;
+	if (mr->page_shift) {
+		/*
+		 * page sizes are uniform power of 2 so no loop is necessary
+		 * entries_spanned_by_off is the number of times the loop below
+		 * would have executed.
+		*/
+		size_t entries_spanned_by_off;
+
+		entries_spanned_by_off = off >> mr->page_shift;
+		off -= (entries_spanned_by_off << mr->page_shift);
+		m = entries_spanned_by_off / RVT_SEGSZ;
+		n = entries_spanned_by_off % RVT_SEGSZ;
+	} else {
+		m = 0;
+		n = 0;
+		while (off >= mr->map[m]->segs[n].length) {
+			off -= mr->map[m]->segs[n].length;
+			n++;
+			if (n >= RVT_SEGSZ) {
+				m++;
+				n = 0;
+			}
+		}
+	}
+	sge->mr = mr;
+	sge->vaddr = mr->map[m]->segs[n].vaddr + off;
+	sge->length = mr->map[m]->segs[n].length - off;
+	sge->sge_length = len;
+	sge->m = m;
+	sge->n = n;
+ok:
+	return 1;
+bail:
+	rcu_read_unlock();
+	return 0;
 }
+EXPORT_SYMBOL(rvt_rkey_ok);
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index f19e9da..c5339aa 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -49,6 +49,29 @@
  */
 
 #include <rdma/rdma_vt.h>
+struct rvt_fmr {
+	struct ib_fmr ibfmr;
+	struct rvt_mregion mr;        /* must be last */
+};
+
+struct rvt_mr {
+	struct ib_mr ibmr;
+	struct ib_umem *umem;
+	struct rvt_mregion mr;  /* must be last */
+};
+
+static inline struct rvt_fmr *to_ifmr(struct ib_fmr *ibfmr)
+{
+	return container_of(ibfmr, struct rvt_fmr, ibfmr);
+}
+
+static inline struct rvt_mr *to_imr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct rvt_mr, ibmr);
+}
+
+int rvt_driver_mr_init(struct rvt_dev_info *rdi);
+void rvt_mr_exit(struct rvt_dev_info *rdi);
 
 /* Mem Regions */
 struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc);
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 2a13e36..516c810 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -214,6 +214,8 @@ static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,
 int rvt_register_device(struct rvt_dev_info *rdi)
 {
 	/* Validate that drivers have provided the right information */
+	int ret = 0;
+
 	if (!rdi)
 		return -EINVAL;
 
@@ -262,6 +264,12 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, detach_mcast);
 
 	/* Mem Region */
+	ret = rvt_driver_mr_init(rdi);
+	if (ret) {
+		rvt_pr_err(rdi, "Error in driver MR init.\n");
+		goto bail_no_mr;
+	}
+
 	CHECK_DRIVER_OVERRIDE(rdi, get_dma_mr);
 	CHECK_DRIVER_OVERRIDE(rdi, reg_user_mr);
 	CHECK_DRIVER_OVERRIDE(rdi, dereg_mr);
@@ -289,10 +297,21 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	spin_lock_init(&rdi->n_pds_lock);
 	rdi->n_pds_allocated = 0;
 
+	/* We are now good to announce we exist */
+	ret =  ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
+	if (ret) {
+		rvt_pr_err(rdi, "Failed to register driver with ib core.\n");
+		goto bail_mr;
+	}
+
 	rvt_pr_info(rdi, "Registration with rdmavt done.\n");
+	return ret;
 
-	/* We are now good to announce we exist */
-	return ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
+bail_mr:
+	rvt_mr_exit(rdi);
+
+bail_no_mr:
+	return ret;
 }
 EXPORT_SYMBOL(rvt_register_device);
 
@@ -302,5 +321,6 @@ void rvt_unregister_device(struct rvt_dev_info *rdi)
 		return;
 
 	ib_unregister_device(&rdi->ibdev);
+	rvt_mr_exit(rdi);
 }
 EXPORT_SYMBOL(rvt_unregister_device);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index b44ac17..9a47957 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -391,6 +391,7 @@ struct rvt_driver_params {
 	 * Anything driver specific that is not covered by props
 	 * For instance special module parameters. Goes here.
 	 */
+	unsigned int lkey_table_size;
 };
 
 /*
@@ -416,6 +417,8 @@ struct rvt_pd {
 };
 
 struct rvt_dev_info {
+	struct ib_device ibdev; /* Keep this first. Nothing above here */
+
 	/*
 	 * Prior to calling for registration the driver will be responsible for
 	 * allocating space for this structure.
@@ -423,7 +426,6 @@ struct rvt_dev_info {
 	 * The driver will also be responsible for filling in certain members of
 	 * dparms.props
 	 */
-	struct ib_device ibdev;
 
 	/* Driver specific properties */
 	struct rvt_driver_params dparms;
@@ -453,7 +455,22 @@ static inline struct rvt_dev_info *ib_to_rvt(struct ib_device *ibdev)
 	return  container_of(ibdev, struct rvt_dev_info, ibdev);
 }
 
+static inline void rvt_put_mr(struct rvt_mregion *mr)
+{
+	if (unlikely(atomic_dec_and_test(&mr->refcount)))
+		complete(&mr->comp);
+}
+
+static inline void rvt_get_mr(struct rvt_mregion *mr)
+{
+	atomic_inc(&mr->refcount);
+}
+
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
+int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
+		u32 len, u64 vaddr, u32 rkey, int acc);
+int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
+		struct rvt_sge *isge, struct ib_sge *sge, int acc);
 
 #endif          /* DEF_RDMA_VT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
