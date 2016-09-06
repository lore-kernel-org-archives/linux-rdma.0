From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 07/13] IB/hfi1: Fix user-space buffers mapping with
 IOMMU enabled
Date: Tue, 06 Sep 2016 04:35:54 -0700
Message-ID: <20160906113542.27413.41968.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The dma_XXX API functions return bus addresses which are
physical addresses when IOMMU is disabled. Buffer
mapping to user-space is done via remap_pfn_range() with PFN
based on bus address instead of physical. This results in
wrong pages being mapped to user-space when IOMMU is enabled.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c        |   12 ++++----
 drivers/infiniband/hw/hfi1/file_ops.c    |   41 ++++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/hfi.h         |   10 +++----
 drivers/infiniband/hw/hfi1/init.c        |   44 +++++++++++++++---------------
 drivers/infiniband/hw/hfi1/pio.c         |   20 +++++++-------
 drivers/infiniband/hw/hfi1/pio.h         |    2 +
 drivers/infiniband/hw/hfi1/trace_ctxts.h |   13 ++++-----
 7 files changed, 79 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index cdc388c..eaa3a9f 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -11553,10 +11553,10 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 	    !(rcvctrl & RCV_CTXT_CTRL_ENABLE_SMASK)) {
 		/* reset the tail and hdr addresses, and sequence count */
 		write_kctxt_csr(dd, ctxt, RCV_HDR_ADDR,
-				rcd->rcvhdrq_phys);
+				rcd->rcvhdrq_dma);
 		if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL))
 			write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
-					rcd->rcvhdrqtailaddr_phys);
+					rcd->rcvhdrqtailaddr_dma);
 		rcd->seq_cnt = 1;
 
 		/* reset the cached receive header queue head value */
@@ -11621,9 +11621,9 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		 * update with a dummy tail address and then disable
 		 * receive context.
 		 */
-		if (dd->rcvhdrtail_dummy_physaddr) {
+		if (dd->rcvhdrtail_dummy_dma) {
 			write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
-					dd->rcvhdrtail_dummy_physaddr);
+					dd->rcvhdrtail_dummy_dma);
 			/* Enabling RcvCtxtCtrl.TailUpd is intentional. */
 			rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
 		}
@@ -11634,7 +11634,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		rcvctrl |= RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
 	if (op & HFI1_RCVCTRL_INTRAVAIL_DIS)
 		rcvctrl &= ~RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
-	if (op & HFI1_RCVCTRL_TAILUPD_ENB && rcd->rcvhdrqtailaddr_phys)
+	if (op & HFI1_RCVCTRL_TAILUPD_ENB && rcd->rcvhdrqtailaddr_dma)
 		rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
 	if (op & HFI1_RCVCTRL_TAILUPD_DIS) {
 		/* See comment on RcvCtxtCtrl.TailUpd above */
@@ -11706,7 +11706,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		 * so it doesn't contain an address that is invalid.
 		 */
 		write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
-				dd->rcvhdrtail_dummy_physaddr);
+				dd->rcvhdrtail_dummy_dma);
 }
 
 u32 hfi1_read_cntrs(struct hfi1_devdata *dd, char **namep, u64 **cntrp)
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 7e03ccd..335796f 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -440,9 +440,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd;
-	unsigned long flags, pfn;
+	unsigned long flags;
 	u64 token = vma->vm_pgoff << PAGE_SHIFT,
 		memaddr = 0;
+	void *memvirt = NULL;
 	u8 subctxt, mapio = 0, vmf = 0, type;
 	ssize_t memlen = 0;
 	int ret = 0;
@@ -493,7 +494,8 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * second or third page allocated for credit returns (if number
 		 * of enabled contexts > 64 and 128 respectively).
 		 */
-		memaddr = dd->cr_base[uctxt->numa_id].pa +
+		memvirt = dd->cr_base[uctxt->numa_id].va;
+		memaddr = virt_to_phys(memvirt) +
 			(((u64)uctxt->sc->hw_free -
 			  (u64)dd->cr_base[uctxt->numa_id].va) & PAGE_MASK);
 		memlen = PAGE_SIZE;
@@ -508,8 +510,8 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		mapio = 1;
 		break;
 	case RCV_HDRQ:
-		memaddr = uctxt->rcvhdrq_phys;
 		memlen = uctxt->rcvhdrq_size;
+		memvirt = uctxt->rcvhdrq;
 		break;
 	case RCV_EGRBUF: {
 		unsigned long addr;
@@ -533,14 +535,21 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		vma->vm_flags &= ~VM_MAYWRITE;
 		addr = vma->vm_start;
 		for (i = 0 ; i < uctxt->egrbufs.numbufs; i++) {
+			memlen = uctxt->egrbufs.buffers[i].len;
+			memvirt = uctxt->egrbufs.buffers[i].addr;
 			ret = remap_pfn_range(
 				vma, addr,
-				uctxt->egrbufs.buffers[i].phys >> PAGE_SHIFT,
-				uctxt->egrbufs.buffers[i].len,
+				/*
+				 * virt_to_pfn() does the same, but
+				 * it's not available on x86_64
+				 * when CONFIG_MMU is enabled.
+				 */
+				PFN_DOWN(__pa(memvirt)),
+				memlen,
 				vma->vm_page_prot);
 			if (ret < 0)
 				goto done;
-			addr += uctxt->egrbufs.buffers[i].len;
+			addr += memlen;
 		}
 		ret = 0;
 		goto done;
@@ -596,8 +605,8 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
-		memaddr = uctxt->rcvhdrqtailaddr_phys;
 		memlen = PAGE_SIZE;
+		memvirt = (void *)uctxt->rcvhdrtail_kvaddr;
 		flags &= ~VM_MAYWRITE;
 		break;
 	case SUBCTXT_UREGS:
@@ -650,16 +659,24 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		  "%u:%u type:%u io/vf:%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx\n",
 		    ctxt, subctxt, type, mapio, vmf, memaddr, memlen,
 		    vma->vm_end - vma->vm_start, vma->vm_flags);
-	pfn = (unsigned long)(memaddr >> PAGE_SHIFT);
 	if (vmf) {
-		vma->vm_pgoff = pfn;
+		vma->vm_pgoff = PFN_DOWN(memaddr);
 		vma->vm_ops = &vm_ops;
 		ret = 0;
 	} else if (mapio) {
-		ret = io_remap_pfn_range(vma, vma->vm_start, pfn, memlen,
+		ret = io_remap_pfn_range(vma, vma->vm_start,
+					 PFN_DOWN(memaddr),
+					 memlen,
 					 vma->vm_page_prot);
+	} else if (memvirt) {
+		ret = remap_pfn_range(vma, vma->vm_start,
+				      PFN_DOWN(__pa(memvirt)),
+				      memlen,
+				      vma->vm_page_prot);
 	} else {
-		ret = remap_pfn_range(vma, vma->vm_start, pfn, memlen,
+		ret = remap_pfn_range(vma, vma->vm_start,
+				      PFN_DOWN(memaddr),
+				      memlen,
 				      vma->vm_page_prot);
 	}
 done:
@@ -1260,7 +1277,7 @@ static int get_base_info(struct file *fp, void __user *ubase, __u32 len)
 					       uctxt->rcvhdrq);
 	binfo.rcvegr_bufbase = HFI1_MMAP_TOKEN(RCV_EGRBUF, uctxt->ctxt,
 					       fd->subctxt,
-					       uctxt->egrbufs.rcvtids[0].phys);
+					       uctxt->egrbufs.rcvtids[0].dma);
 	binfo.sdma_comp_bufbase = HFI1_MMAP_TOKEN(SDMA_COMP, uctxt->ctxt,
 						 fd->subctxt, 0);
 	/*
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 791d7a2..52ffd11 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -172,12 +172,12 @@ struct ctxt_eager_bufs {
 	u32 threshold;           /* head update threshold */
 	struct eager_buffer {
 		void *addr;
-		dma_addr_t phys;
+		dma_addr_t dma;
 		ssize_t len;
 	} *buffers;
 	struct {
 		void *addr;
-		dma_addr_t phys;
+		dma_addr_t dma;
 	} *rcvtids;
 };
 
@@ -208,8 +208,8 @@ struct hfi1_ctxtdata {
 	/* size of each of the rcvhdrq entries */
 	u16 rcvhdrqentsize;
 	/* mmap of hdrq, must fit in 44 bits */
-	dma_addr_t rcvhdrq_phys;
-	dma_addr_t rcvhdrqtailaddr_phys;
+	dma_addr_t rcvhdrq_dma;
+	dma_addr_t rcvhdrqtailaddr_dma;
 	struct ctxt_eager_bufs egrbufs;
 	/* this receive context's assigned PIO ACK send context */
 	struct send_context *sc;
@@ -1165,7 +1165,7 @@ struct hfi1_devdata {
 
 	/* receive context tail dummy address */
 	__le64 *rcvhdrtail_dummy_kvaddr;
-	dma_addr_t rcvhdrtail_dummy_physaddr;
+	dma_addr_t rcvhdrtail_dummy_dma;
 
 	bool eprom_available;	/* true if EPROM is available for this device */
 	bool aspm_supported;	/* Does HW support ASPM */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 384b43d..ab2f221 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -709,7 +709,7 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 	/* allocate dummy tail memory for all receive contexts */
 	dd->rcvhdrtail_dummy_kvaddr = dma_zalloc_coherent(
 		&dd->pcidev->dev, sizeof(u64),
-		&dd->rcvhdrtail_dummy_physaddr,
+		&dd->rcvhdrtail_dummy_dma,
 		GFP_KERNEL);
 
 	if (!dd->rcvhdrtail_dummy_kvaddr) {
@@ -942,12 +942,12 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 
 	if (rcd->rcvhdrq) {
 		dma_free_coherent(&dd->pcidev->dev, rcd->rcvhdrq_size,
-				  rcd->rcvhdrq, rcd->rcvhdrq_phys);
+				  rcd->rcvhdrq, rcd->rcvhdrq_dma);
 		rcd->rcvhdrq = NULL;
 		if (rcd->rcvhdrtail_kvaddr) {
 			dma_free_coherent(&dd->pcidev->dev, PAGE_SIZE,
 					  (void *)rcd->rcvhdrtail_kvaddr,
-					  rcd->rcvhdrqtailaddr_phys);
+					  rcd->rcvhdrqtailaddr_dma);
 			rcd->rcvhdrtail_kvaddr = NULL;
 		}
 	}
@@ -956,11 +956,11 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	kfree(rcd->egrbufs.rcvtids);
 
 	for (e = 0; e < rcd->egrbufs.alloced; e++) {
-		if (rcd->egrbufs.buffers[e].phys)
+		if (rcd->egrbufs.buffers[e].dma)
 			dma_free_coherent(&dd->pcidev->dev,
 					  rcd->egrbufs.buffers[e].len,
 					  rcd->egrbufs.buffers[e].addr,
-					  rcd->egrbufs.buffers[e].phys);
+					  rcd->egrbufs.buffers[e].dma);
 	}
 	kfree(rcd->egrbufs.buffers);
 
@@ -1354,7 +1354,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 	if (dd->rcvhdrtail_dummy_kvaddr) {
 		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
 				  (void *)dd->rcvhdrtail_dummy_kvaddr,
-				  dd->rcvhdrtail_dummy_physaddr);
+				  dd->rcvhdrtail_dummy_dma);
 		dd->rcvhdrtail_dummy_kvaddr = NULL;
 	}
 
@@ -1577,7 +1577,7 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	u64 reg;
 
 	if (!rcd->rcvhdrq) {
-		dma_addr_t phys_hdrqtail;
+		dma_addr_t dma_hdrqtail;
 		gfp_t gfp_flags;
 
 		/*
@@ -1590,7 +1590,7 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 		gfp_flags = (rcd->ctxt >= dd->first_user_ctxt) ?
 			GFP_USER : GFP_KERNEL;
 		rcd->rcvhdrq = dma_zalloc_coherent(
-			&dd->pcidev->dev, amt, &rcd->rcvhdrq_phys,
+			&dd->pcidev->dev, amt, &rcd->rcvhdrq_dma,
 			gfp_flags | __GFP_COMP);
 
 		if (!rcd->rcvhdrq) {
@@ -1602,11 +1602,11 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 
 		if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL)) {
 			rcd->rcvhdrtail_kvaddr = dma_zalloc_coherent(
-				&dd->pcidev->dev, PAGE_SIZE, &phys_hdrqtail,
+				&dd->pcidev->dev, PAGE_SIZE, &dma_hdrqtail,
 				gfp_flags);
 			if (!rcd->rcvhdrtail_kvaddr)
 				goto bail_free;
-			rcd->rcvhdrqtailaddr_phys = phys_hdrqtail;
+			rcd->rcvhdrqtailaddr_dma = dma_hdrqtail;
 		}
 
 		rcd->rcvhdrq_size = amt;
@@ -1634,7 +1634,7 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	 * before enabling any receive context
 	 */
 	write_kctxt_csr(dd, rcd->ctxt, RCV_HDR_TAIL_ADDR,
-			dd->rcvhdrtail_dummy_physaddr);
+			dd->rcvhdrtail_dummy_dma);
 
 	return 0;
 
@@ -1645,7 +1645,7 @@ bail_free:
 	vfree(rcd->user_event_mask);
 	rcd->user_event_mask = NULL;
 	dma_free_coherent(&dd->pcidev->dev, amt, rcd->rcvhdrq,
-			  rcd->rcvhdrq_phys);
+			  rcd->rcvhdrq_dma);
 	rcd->rcvhdrq = NULL;
 bail:
 	return -ENOMEM;
@@ -1706,15 +1706,15 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 		rcd->egrbufs.buffers[idx].addr =
 			dma_zalloc_coherent(&dd->pcidev->dev,
 					    rcd->egrbufs.rcvtid_size,
-					    &rcd->egrbufs.buffers[idx].phys,
+					    &rcd->egrbufs.buffers[idx].dma,
 					    gfp_flags);
 		if (rcd->egrbufs.buffers[idx].addr) {
 			rcd->egrbufs.buffers[idx].len =
 				rcd->egrbufs.rcvtid_size;
 			rcd->egrbufs.rcvtids[rcd->egrbufs.alloced].addr =
 				rcd->egrbufs.buffers[idx].addr;
-			rcd->egrbufs.rcvtids[rcd->egrbufs.alloced].phys =
-				rcd->egrbufs.buffers[idx].phys;
+			rcd->egrbufs.rcvtids[rcd->egrbufs.alloced].dma =
+				rcd->egrbufs.buffers[idx].dma;
 			rcd->egrbufs.alloced++;
 			alloced_bytes += rcd->egrbufs.rcvtid_size;
 			idx++;
@@ -1755,14 +1755,14 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 			for (i = 0, j = 0, offset = 0; j < idx; i++) {
 				if (i >= rcd->egrbufs.count)
 					break;
-				rcd->egrbufs.rcvtids[i].phys =
-					rcd->egrbufs.buffers[j].phys + offset;
+				rcd->egrbufs.rcvtids[i].dma =
+					rcd->egrbufs.buffers[j].dma + offset;
 				rcd->egrbufs.rcvtids[i].addr =
 					rcd->egrbufs.buffers[j].addr + offset;
 				rcd->egrbufs.alloced++;
-				if ((rcd->egrbufs.buffers[j].phys + offset +
+				if ((rcd->egrbufs.buffers[j].dma + offset +
 				     new_size) ==
-				    (rcd->egrbufs.buffers[j].phys +
+				    (rcd->egrbufs.buffers[j].dma +
 				     rcd->egrbufs.buffers[j].len)) {
 					j++;
 					offset = 0;
@@ -1814,7 +1814,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 
 	for (idx = 0; idx < rcd->egrbufs.alloced; idx++) {
 		hfi1_put_tid(dd, rcd->eager_base + idx, PT_EAGER,
-			     rcd->egrbufs.rcvtids[idx].phys, order);
+			     rcd->egrbufs.rcvtids[idx].dma, order);
 		cond_resched();
 	}
 	goto bail;
@@ -1826,9 +1826,9 @@ bail_rcvegrbuf_phys:
 		dma_free_coherent(&dd->pcidev->dev,
 				  rcd->egrbufs.buffers[idx].len,
 				  rcd->egrbufs.buffers[idx].addr,
-				  rcd->egrbufs.buffers[idx].phys);
+				  rcd->egrbufs.buffers[idx].dma);
 		rcd->egrbufs.buffers[idx].addr = NULL;
-		rcd->egrbufs.buffers[idx].phys = 0;
+		rcd->egrbufs.buffers[idx].dma = 0;
 		rcd->egrbufs.buffers[idx].len = 0;
 	}
 bail:
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index ac1bf4a..50a3a36 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -551,11 +551,11 @@ static inline u32 group_size(u32 group)
 }
 
 /*
- * Obtain the credit return addresses, kernel virtual and physical, for the
+ * Obtain the credit return addresses, kernel virtual and bus, for the
  * given sc.
  *
  * To understand this routine:
- * o va and pa are arrays of struct credit_return.  One for each physical
+ * o va and dma are arrays of struct credit_return.  One for each physical
  *   send context, per NUMA.
  * o Each send context always looks in its relative location in a struct
  *   credit_return for its credit return.
@@ -563,14 +563,14 @@ static inline u32 group_size(u32 group)
  *   with the same value.  Use the address of the first send context in the
  *   group.
  */
-static void cr_group_addresses(struct send_context *sc, dma_addr_t *pa)
+static void cr_group_addresses(struct send_context *sc, dma_addr_t *dma)
 {
 	u32 gc = group_context(sc->hw_context, sc->group);
 	u32 index = sc->hw_context & 0x7;
 
 	sc->hw_free = &sc->dd->cr_base[sc->node].va[gc].cr[index];
-	*pa = (unsigned long)
-	       &((struct credit_return *)sc->dd->cr_base[sc->node].pa)[gc];
+	*dma = (unsigned long)
+	       &((struct credit_return *)sc->dd->cr_base[sc->node].dma)[gc];
 }
 
 /*
@@ -710,7 +710,7 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 {
 	struct send_context_info *sci;
 	struct send_context *sc = NULL;
-	dma_addr_t pa;
+	dma_addr_t dma;
 	unsigned long flags;
 	u64 reg;
 	u32 thresh;
@@ -763,7 +763,7 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 
 	sc->sw_index = sw_index;
 	sc->hw_context = hw_context;
-	cr_group_addresses(sc, &pa);
+	cr_group_addresses(sc, &dma);
 	sc->credits = sci->credits;
 
 /* PIO Send Memory Address details */
@@ -805,7 +805,7 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 			((u64)opval << SC(CHECK_OPCODE_VALUE_SHIFT)));
 
 	/* set up credit return */
-	reg = pa & SC(CREDIT_RETURN_ADDR_ADDRESS_SMASK);
+	reg = dma & SC(CREDIT_RETURN_ADDR_ADDRESS_SMASK);
 	write_kctxt_csr(dd, hw_context, SC(CREDIT_RETURN_ADDR), reg);
 
 	/*
@@ -2064,7 +2064,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 		dd->cr_base[i].va = dma_zalloc_coherent(
 					&dd->pcidev->dev,
 					bytes,
-					&dd->cr_base[i].pa,
+					&dd->cr_base[i].dma,
 					GFP_KERNEL);
 		if (!dd->cr_base[i].va) {
 			set_dev_node(&dd->pcidev->dev, dd->node);
@@ -2097,7 +2097,7 @@ void free_credit_return(struct hfi1_devdata *dd)
 					  TXE_NUM_CONTEXTS *
 					  sizeof(struct credit_return),
 					  dd->cr_base[i].va,
-					  dd->cr_base[i].pa);
+					  dd->cr_base[i].dma);
 		}
 	}
 	kfree(dd->cr_base);
diff --git a/drivers/infiniband/hw/hfi1/pio.h b/drivers/infiniband/hw/hfi1/pio.h
index 464cbd2..e709eaf 100644
--- a/drivers/infiniband/hw/hfi1/pio.h
+++ b/drivers/infiniband/hw/hfi1/pio.h
@@ -154,7 +154,7 @@ struct credit_return {
 /* NUMA indexed credit return array */
 struct credit_return_base {
 	struct credit_return *va;
-	dma_addr_t pa;
+	dma_addr_t dma;
 };
 
 /* send context configuration sizes (one per type) */
diff --git a/drivers/infiniband/hw/hfi1/trace_ctxts.h b/drivers/infiniband/hw/hfi1/trace_ctxts.h
index 31654bb..26ae789 100644
--- a/drivers/infiniband/hw/hfi1/trace_ctxts.h
+++ b/drivers/infiniband/hw/hfi1/trace_ctxts.h
@@ -67,9 +67,9 @@ TRACE_EVENT(hfi1_uctxtdata,
 			     __field(u64, hw_free)
 			     __field(void __iomem *, piobase)
 			     __field(u16, rcvhdrq_cnt)
-			     __field(u64, rcvhdrq_phys)
+			     __field(u64, rcvhdrq_dma)
 			     __field(u32, eager_cnt)
-			     __field(u64, rcvegr_phys)
+			     __field(u64, rcvegr_dma)
 			     ),
 	    TP_fast_assign(DD_DEV_ASSIGN(dd);
 			   __entry->ctxt = uctxt->ctxt;
@@ -77,10 +77,9 @@ TRACE_EVENT(hfi1_uctxtdata,
 			   __entry->hw_free = le64_to_cpu(*uctxt->sc->hw_free);
 			   __entry->piobase = uctxt->sc->base_addr;
 			   __entry->rcvhdrq_cnt = uctxt->rcvhdrq_cnt;
-			   __entry->rcvhdrq_phys = uctxt->rcvhdrq_phys;
+			   __entry->rcvhdrq_dma = uctxt->rcvhdrq_dma;
 			   __entry->eager_cnt = uctxt->egrbufs.alloced;
-			   __entry->rcvegr_phys =
-			   uctxt->egrbufs.rcvtids[0].phys;
+			   __entry->rcvegr_dma = uctxt->egrbufs.rcvtids[0].dma;
 			   ),
 	    TP_printk("[%s] ctxt %u " UCTXT_FMT,
 		      __get_str(dev),
@@ -89,9 +88,9 @@ TRACE_EVENT(hfi1_uctxtdata,
 		      __entry->hw_free,
 		      __entry->piobase,
 		      __entry->rcvhdrq_cnt,
-		      __entry->rcvhdrq_phys,
+		      __entry->rcvhdrq_dma,
 		      __entry->eager_cnt,
-		      __entry->rcvegr_phys
+		      __entry->rcvegr_dma
 		      )
 );
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
