From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH] IB/hfi1: Fix user context tail allocation for DMA_RTAIL
Date: Mon, 02 Jul 2018 08:33:25 -0700
Message-ID: <20180702153323.2598.36535.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

commit 1bc0299d976e000ececc6acd76e33b4582646cb7 upstream.

The following code fails to allocate a buffer for the
tail address that the hardware DMAs into when the user
context DMA_RTAIL is set.

if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL)) {
	rcd->rcvhdrtail_kvaddr = dma_zalloc_coherent(
		&dd->pcidev->dev, PAGE_SIZE, &dma_hdrqtail,
                gfp_flags);
	if (!rcd->rcvhdrtail_kvaddr)
		goto bail_free;
	rcd->rcvhdrqtailaddr_dma = dma_hdrqtail;
}

So the rcvhdrtail_kvaddr would then be NULL.

The mmap logic fails to check for a NULL rcvhdrtail_kvaddr.

The fix is to test for both user and kernel DMA_TAIL options
during the allocation as well as testing for a NULL
rcvhdrtail_kvaddr during the mmap processing.

Additionally, all downstream testing of the capmask for DMA_RTAIL
have been eliminated in favor of testing rcvhdrtail_kvaddr.

The patch had to be adjusted for lack of VNIC and interating
contexts differently in the 4.9 code base.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/hfi1/chip.c     |    8 ++++----
 drivers/infiniband/hw/hfi1/file_ops.c |    2 +-
 drivers/infiniband/hw/hfi1/init.c     |    9 ++++-----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 148b313..d30b3b9 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6717,7 +6717,7 @@ static void rxe_kernel_unfreeze(struct hfi1_devdata *dd)
 	for (i = 0; i < dd->n_krcv_queues; i++) {
 		rcvmask = HFI1_RCVCTRL_CTXT_ENB;
 		/* HFI1_RCVCTRL_TAILUPD_[ENB|DIS] needs to be set explicitly */
-		rcvmask |= HFI1_CAP_KGET_MASK(dd->rcd[i]->flags, DMA_RTAIL) ?
+		rcvmask |= dd->rcd[i]->rcvhdrtail_kvaddr ?
 			HFI1_RCVCTRL_TAILUPD_ENB : HFI1_RCVCTRL_TAILUPD_DIS;
 		hfi1_rcvctrl(dd, rcvmask, i);
 	}
@@ -8211,7 +8211,7 @@ static inline int check_packet_present(struct hfi1_ctxtdata *rcd)
 	u32 tail;
 	int present;
 
-	if (!HFI1_CAP_IS_KSET(DMA_RTAIL))
+	if (!rcd->rcvhdrtail_kvaddr)
 		present = (rcd->seq_cnt ==
 				rhf_rcv_seq(rhf_to_cpu(get_rhf_addr(rcd))));
 	else /* is RDMA rtail */
@@ -11550,7 +11550,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		/* reset the tail and hdr addresses, and sequence count */
 		write_kctxt_csr(dd, ctxt, RCV_HDR_ADDR,
 				rcd->rcvhdrq_dma);
-		if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL))
+		if (rcd->rcvhdrtail_kvaddr)
 			write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
 					rcd->rcvhdrqtailaddr_dma);
 		rcd->seq_cnt = 1;
@@ -11630,7 +11630,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		rcvctrl |= RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
 	if (op & HFI1_RCVCTRL_INTRAVAIL_DIS)
 		rcvctrl &= ~RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
-	if (op & HFI1_RCVCTRL_TAILUPD_ENB && rcd->rcvhdrqtailaddr_dma)
+	if ((op & HFI1_RCVCTRL_TAILUPD_ENB) && rcd->rcvhdrtail_kvaddr)
 		rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
 	if (op & HFI1_RCVCTRL_TAILUPD_DIS) {
 		/* See comment on RcvCtxtCtrl.TailUpd above */
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index bb72976..d612f9d 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -609,7 +609,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EINVAL;
 			goto done;
 		}
-		if (flags & VM_WRITE) {
+		if ((flags & VM_WRITE) || !uctxt->rcvhdrtail_kvaddr) {
 			ret = -EPERM;
 			goto done;
 		}
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index ae1f90d..28f4079 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1605,7 +1605,6 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	u64 reg;
 
 	if (!rcd->rcvhdrq) {
-		dma_addr_t dma_hdrqtail;
 		gfp_t gfp_flags;
 
 		/*
@@ -1628,13 +1627,13 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 			goto bail;
 		}
 
-		if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL)) {
+		if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL) ||
+		    HFI1_CAP_UGET_MASK(rcd->flags, DMA_RTAIL)) {
 			rcd->rcvhdrtail_kvaddr = dma_zalloc_coherent(
-				&dd->pcidev->dev, PAGE_SIZE, &dma_hdrqtail,
-				gfp_flags);
+				&dd->pcidev->dev, PAGE_SIZE,
+				&rcd->rcvhdrqtailaddr_dma, gfp_flags);
 			if (!rcd->rcvhdrtail_kvaddr)
 				goto bail_free;
-			rcd->rcvhdrqtailaddr_dma = dma_hdrqtail;
 		}
 
 		rcd->rcvhdrq_size = amt;
