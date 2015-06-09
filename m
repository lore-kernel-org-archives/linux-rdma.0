From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.1 2/2] iw_cxgb4: support for bar2 qid densities exceeding the page size
Date: Tue,  9 Jun 2015 18:23:12 +0530
Message-ID: <1433854392-6531-3-git-send-email-hariprasad@chelsio.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433854392-6531-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Handle this configuration:

        Queues Per Page * SGE BAR2 Queue Register Area Size > Page Size

Use cxgb4_bar2_sge_qregs() to obtain the proper location within the
bar2 region for a given qid.

Rework the DB and GTS write functions to make use of this bar2 info.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       | 22 ++++++------
 drivers/infiniband/hw/cxgb4/device.c   | 16 +++------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  5 +--
 drivers/infiniband/hw/cxgb4/qp.c       | 64 ++++++++++++++++++++++------------
 drivers/infiniband/hw/cxgb4/t4.h       | 60 ++++++++++++++++++++-----------
 5 files changed, 98 insertions(+), 69 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 68ddb37..8e5bbcb 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -156,19 +156,17 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 		goto err4;
 
 	cq->gen = 1;
+	cq->gts = rdev->lldi.gts_reg;
 	cq->rdev = rdev;
-	if (user) {
-		u32 off = (cq->cqid << rdev->cqshift) & PAGE_MASK;
 
-		cq->ugts = (u64)rdev->bar2_pa + off;
-	} else if (is_t4(rdev->lldi.adapter_type)) {
-		cq->gts = rdev->lldi.gts_reg;
-		cq->qid_mask = -1U;
-	} else {
-		u32 off = ((cq->cqid << rdev->cqshift) & PAGE_MASK) + 12;
-
-		cq->gts = rdev->bar2_kva + off;
-		cq->qid_mask = rdev->qpmask;
+	cq->bar2_va = c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRESS,
+				      &cq->bar2_qid,
+				      user ? &cq->bar2_pa : NULL);
+	if (user && !cq->bar2_va) {
+		pr_warn(MOD "%s: cqid %u not in BAR2 range.\n",
+			pci_name(rdev->lldi.pdev), cq->cqid);
+		ret = -EINVAL;
+		goto err4;
 	}
 	return 0;
 err4:
@@ -971,7 +969,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 		insert_mmap(ucontext, mm);
 
 		mm2->key = uresp.gts_key;
-		mm2->addr = chp->cq.ugts;
+		mm2->addr = (u64)(uintptr_t)chp->cq.bar2_pa;
 		mm2->len = PAGE_SIZE;
 		insert_mmap(ucontext, mm2);
 	}
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 1ffbd03..ab36804 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -788,13 +788,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 		goto err1;
 	}
 
-	/*
-	 * qpshift is the number of bits to shift the qpid left in order
-	 * to get the correct address of the doorbell for that qp.
-	 */
-	rdev->qpshift = PAGE_SHIFT - ilog2(rdev->lldi.udb_density);
 	rdev->qpmask = rdev->lldi.udb_density - 1;
-	rdev->cqshift = PAGE_SHIFT - ilog2(rdev->lldi.ucq_density);
 	rdev->cqmask = rdev->lldi.ucq_density - 1;
 	PDBG("%s dev %s stag start 0x%0x size 0x%0x num stags %d "
 	     "pbl start 0x%0x size 0x%0x rq start 0x%0x size 0x%0x "
@@ -808,14 +802,12 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	     rdev->lldi.vr->qp.size,
 	     rdev->lldi.vr->cq.start,
 	     rdev->lldi.vr->cq.size);
-	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
-	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
+	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p "
+	     "qpmask 0x%x cqmask 0x%x\n",
 	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
 	     (void *)pci_resource_start(rdev->lldi.pdev, 2),
-	     rdev->lldi.db_reg,
-	     rdev->lldi.gts_reg,
-	     rdev->qpshift, rdev->qpmask,
-	     rdev->cqshift, rdev->cqmask);
+	     rdev->lldi.db_reg, rdev->lldi.gts_reg,
+	     rdev->qpmask, rdev->cqmask);
 
 	if (c4iw_num_stags(rdev) == 0) {
 		err = -EINVAL;
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index d87e165..7a1b675 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -164,9 +164,7 @@ struct wr_log_entry {
 
 struct c4iw_rdev {
 	struct c4iw_resource resource;
-	unsigned long qpshift;
 	u32 qpmask;
-	unsigned long cqshift;
 	u32 cqmask;
 	struct c4iw_dev_ucontext uctx;
 	struct gen_pool *pbl_pool;
@@ -1025,6 +1023,9 @@ void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe);
 
 extern struct cxgb4_client t4c_client;
 extern c4iw_handler_func c4iw_handlers[NUM_CPL_CMDS];
+void __iomem *c4iw_bar2_addrs(struct c4iw_rdev *rdev, unsigned int qid,
+			      enum cxgb4_bar2_qtype qtype,
+			      unsigned int *pbar2_qid, u64 *pbar2_pa);
 extern void c4iw_log_wr_stats(struct t4_wq *wq, struct t4_cqe *cqe);
 extern int c4iw_wr_log;
 extern int db_fc_threshold;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 389ced3..6517e12 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -165,6 +165,29 @@ static int destroy_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	return 0;
 }
 
+/*
+ * Determine the BAR2 virtual address and qid. If pbar2_pa is not NULL,
+ * then this is a user mapping so compute the page-aligned physical address
+ * for mapping.
+ */
+void __iomem *c4iw_bar2_addrs(struct c4iw_rdev *rdev, unsigned int qid,
+			      enum cxgb4_bar2_qtype qtype,
+			      unsigned int *pbar2_qid, u64 *pbar2_pa)
+{
+	u64 bar2_qoffset;
+	int ret;
+
+	ret = cxgb4_bar2_sge_qregs(rdev->lldi.ports[0], qid, qtype,
+				   pbar2_pa ? 1 : 0,
+				   &bar2_qoffset, pbar2_qid);
+	if (ret)
+		return NULL;
+
+	if (pbar2_pa)
+		*pbar2_pa = (rdev->bar2_pa + bar2_qoffset) & PAGE_MASK;
+	return rdev->bar2_kva + bar2_qoffset;
+}
+
 static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		     struct t4_cq *rcq, struct t4_cq *scq,
 		     struct c4iw_dev_ucontext *uctx)
@@ -236,25 +259,23 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	dma_unmap_addr_set(&wq->rq, mapping, wq->rq.dma_addr);
 
 	wq->db = rdev->lldi.db_reg;
-	wq->gts = rdev->lldi.gts_reg;
-	if (user || is_t5(rdev->lldi.adapter_type)) {
-		u32 off;
 
-		off = (wq->sq.qid << rdev->qpshift) & PAGE_MASK;
-		if (user) {
-			wq->sq.udb = (u64 __iomem *)(rdev->bar2_pa + off);
-		} else {
-			off += 128 * (wq->sq.qid & rdev->qpmask) + 8;
-			wq->sq.udb = (u64 __iomem *)(rdev->bar2_kva + off);
-		}
-		off = (wq->rq.qid << rdev->qpshift) & PAGE_MASK;
-		if (user) {
-			wq->rq.udb = (u64 __iomem *)(rdev->bar2_pa + off);
-		} else {
-			off += 128 * (wq->rq.qid & rdev->qpmask) + 8;
-			wq->rq.udb = (u64 __iomem *)(rdev->bar2_kva + off);
-		}
+	wq->sq.bar2_va = c4iw_bar2_addrs(rdev, wq->sq.qid, T4_BAR2_QTYPE_EGRESS,
+					 &wq->sq.bar2_qid,
+					 user ? &wq->sq.bar2_pa : NULL);
+	wq->rq.bar2_va = c4iw_bar2_addrs(rdev, wq->rq.qid, T4_BAR2_QTYPE_EGRESS,
+					 &wq->rq.bar2_qid,
+					 user ? &wq->rq.bar2_pa : NULL);
+
+	/*
+	 * User mode must have bar2 access.
+	 */
+	if (user && (!wq->sq.bar2_va || !wq->rq.bar2_va)) {
+		pr_warn(MOD "%s: sqid %u or rqid %u not in BAR2 range.\n",
+			pci_name(rdev->lldi.pdev), wq->sq.qid, wq->rq.qid);
+		goto free_dma;
 	}
+
 	wq->rdev = rdev;
 	wq->rq.msn = 1;
 
@@ -336,10 +357,9 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	if (ret)
 		goto free_dma;
 
-	PDBG("%s sqid 0x%x rqid 0x%x kdb 0x%p squdb 0x%lx rqudb 0x%lx\n",
+	PDBG("%s sqid 0x%x rqid 0x%x kdb 0x%p sq_bar2_addr %p rq_bar2_addr %p\n",
 	     __func__, wq->sq.qid, wq->rq.qid, wq->db,
-	     (__force unsigned long) wq->sq.udb,
-	     (__force unsigned long) wq->rq.udb);
+	     wq->sq.bar2_va, wq->rq.bar2_va);
 
 	return 0;
 free_dma:
@@ -1766,11 +1786,11 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 		mm2->len = PAGE_ALIGN(qhp->wq.rq.memsize);
 		insert_mmap(ucontext, mm2);
 		mm3->key = uresp.sq_db_gts_key;
-		mm3->addr = (__force unsigned long)qhp->wq.sq.udb;
+		mm3->addr = (__force unsigned long)qhp->wq.sq.bar2_pa;
 		mm3->len = PAGE_SIZE;
 		insert_mmap(ucontext, mm3);
 		mm4->key = uresp.rq_db_gts_key;
-		mm4->addr = (__force unsigned long)qhp->wq.rq.udb;
+		mm4->addr = (__force unsigned long)qhp->wq.rq.bar2_pa;
 		mm4->len = PAGE_SIZE;
 		insert_mmap(ucontext, mm4);
 		if (mm5) {
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 7f2a6c2..274a7ab 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -33,6 +33,7 @@
 
 #include "t4_hw.h"
 #include "t4_regs.h"
+#include "t4_values.h"
 #include "t4_msg.h"
 #include "t4fw_ri_api.h"
 
@@ -290,8 +291,10 @@ struct t4_sq {
 	unsigned long phys_addr;
 	struct t4_swsqe *sw_sq;
 	struct t4_swsqe *oldest_read;
-	u64 __iomem *udb;
+	void __iomem *bar2_va;
+	u64 bar2_pa;
 	size_t memsize;
+	u32 bar2_qid;
 	u32 qid;
 	u16 in_use;
 	u16 size;
@@ -314,8 +317,10 @@ struct t4_rq {
 	dma_addr_t dma_addr;
 	DEFINE_DMA_UNMAP_ADDR(mapping);
 	struct t4_swrqe *sw_rq;
-	u64 __iomem *udb;
+	void __iomem *bar2_va;
+	u64 bar2_pa;
 	size_t memsize;
+	u32 bar2_qid;
 	u32 qid;
 	u32 msn;
 	u32 rqt_hwaddr;
@@ -332,7 +337,6 @@ struct t4_wq {
 	struct t4_sq sq;
 	struct t4_rq rq;
 	void __iomem *db;
-	void __iomem *gts;
 	struct c4iw_rdev *rdev;
 	int flushed;
 };
@@ -457,15 +461,18 @@ static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc, u8 t5,
 
 	/* Flush host queue memory writes. */
 	wmb();
-	if (t5) {
-		if (inc == 1 && wqe) {
+	if (wq->sq.bar2_va) {
+		if (inc == 1 && wq->sq.bar2_qid == 0 && wqe) {
 			PDBG("%s: WC wq->sq.pidx = %d\n",
 			     __func__, wq->sq.pidx);
-			pio_copy(wq->sq.udb + 7, (void *)wqe);
+			pio_copy((u64 __iomem *)
+				 (wq->sq.bar2_va + SGE_UDB_WCDOORBELL),
+				 (u64 *)wqe);
 		} else {
 			PDBG("%s: DB wq->sq.pidx = %d\n",
 			     __func__, wq->sq.pidx);
-			writel(PIDX_T5_V(inc), wq->sq.udb);
+			writel(PIDX_T5_V(inc) | QID_V(wq->sq.bar2_qid),
+			       wq->sq.bar2_va + SGE_UDB_KDOORBELL);
 		}
 
 		/* Flush user doorbell area writes. */
@@ -481,15 +488,18 @@ static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc, u8 t5,
 
 	/* Flush host queue memory writes. */
 	wmb();
-	if (t5) {
-		if (inc == 1 && wqe) {
+	if (wq->rq.bar2_va) {
+		if (inc == 1 && wq->rq.bar2_qid == 0 && wqe) {
 			PDBG("%s: WC wq->rq.pidx = %d\n",
 			     __func__, wq->rq.pidx);
-			pio_copy(wq->rq.udb + 7, (void *)wqe);
+			pio_copy((u64 __iomem *)
+				 (wq->rq.bar2_va + SGE_UDB_WCDOORBELL),
+				 (void *)wqe);
 		} else {
 			PDBG("%s: DB wq->rq.pidx = %d\n",
 			     __func__, wq->rq.pidx);
-			writel(PIDX_T5_V(inc), wq->rq.udb);
+			writel(PIDX_T5_V(inc) | QID_V(wq->rq.bar2_qid),
+			       wq->rq.bar2_va + SGE_UDB_KDOORBELL);
 		}
 
 		/* Flush user doorbell area writes. */
@@ -534,8 +544,10 @@ struct t4_cq {
 	DEFINE_DMA_UNMAP_ADDR(mapping);
 	struct t4_cqe *sw_queue;
 	void __iomem *gts;
+	void __iomem *bar2_va;
+	u64 bar2_pa;
+	u32 bar2_qid;
 	struct c4iw_rdev *rdev;
-	u64 ugts;
 	size_t memsize;
 	__be64 bits_type_ts;
 	u32 cqid;
@@ -552,6 +564,15 @@ struct t4_cq {
 	unsigned long flags;
 };
 
+static inline void write_gts(struct t4_cq *cq, u32 val)
+{
+	if (cq->bar2_va)
+		writel(val | INGRESSQID_V(cq->bar2_qid),
+		       cq->bar2_va + SGE_UDB_GTS);
+	else
+		writel(val | INGRESSQID_V(cq->cqid), cq->gts);
+}
+
 static inline int t4_clear_cq_armed(struct t4_cq *cq)
 {
 	return test_and_clear_bit(CQ_ARMED, &cq->flags);
@@ -563,14 +584,12 @@ static inline int t4_arm_cq(struct t4_cq *cq, int se)
 
 	set_bit(CQ_ARMED, &cq->flags);
 	while (cq->cidx_inc > CIDXINC_M) {
-		val = SEINTARM_V(0) | CIDXINC_V(CIDXINC_M) | TIMERREG_V(7) |
-		      INGRESSQID_V(cq->cqid & cq->qid_mask);
-		writel(val, cq->gts);
+		val = SEINTARM_V(0) | CIDXINC_V(CIDXINC_M) | TIMERREG_V(7);
+		write_gts(cq, val);
 		cq->cidx_inc -= CIDXINC_M;
 	}
-	val = SEINTARM_V(se) | CIDXINC_V(cq->cidx_inc) | TIMERREG_V(6) |
-	      INGRESSQID_V(cq->cqid & cq->qid_mask);
-	writel(val, cq->gts);
+	val = SEINTARM_V(se) | CIDXINC_V(cq->cidx_inc) | TIMERREG_V(6);
+	write_gts(cq, val);
 	cq->cidx_inc = 0;
 	return 0;
 }
@@ -601,9 +620,8 @@ static inline void t4_hwcq_consume(struct t4_cq *cq)
 	if (++cq->cidx_inc == (cq->size >> 4) || cq->cidx_inc == CIDXINC_M) {
 		u32 val;
 
-		val = SEINTARM_V(0) | CIDXINC_V(cq->cidx_inc) | TIMERREG_V(7) |
-		      INGRESSQID_V(cq->cqid & cq->qid_mask);
-		writel(val, cq->gts);
+		val = SEINTARM_V(0) | CIDXINC_V(cq->cidx_inc) | TIMERREG_V(7);
+		write_gts(cq, val);
 		cq->cidx_inc = 0;
 	}
 	if (++cq->cidx == cq->size) {
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
