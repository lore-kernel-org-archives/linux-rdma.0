From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 1/2] IB/hfi1: Fix user context tail allocation for
 DMA_RTAIL
Date: Thu, 31 May 2018 11:30:09 -0700
Message-ID: <20180531183004.26542.62024.stgit@scvm10.sc.intel.com>
References: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

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

Cc: <stable@vger.kernel.org> # 4.9.x
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/chip.c     |    8 ++++----
 drivers/infiniband/hw/hfi1/file_ops.c |    2 +-
 drivers/infiniband/hw/hfi1/init.c     |    9 ++++-----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 9b1f97f..ccbdce2 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6841,7 +6841,7 @@ static void rxe_kernel_unfreeze(struct hfi1_devdata *dd)
 		}
 		rcvmask = HFI1_RCVCTRL_CTXT_ENB;
 		/* HFI1_RCVCTRL_TAILUPD_[ENB|DIS] needs to be set explicitly */
-		rcvmask |= HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL) ?
+		rcvmask |= rcd->rcvhdrtail_kvaddr ?
 			HFI1_RCVCTRL_TAILUPD_ENB : HFI1_RCVCTRL_TAILUPD_DIS;
 		hfi1_rcvctrl(dd, rcvmask, rcd);
 		hfi1_rcd_put(rcd);
@@ -8367,7 +8367,7 @@ static inline int check_packet_present(struct hfi1_ctxtdata *rcd)
 	u32 tail;
 	int present;
 
-	if (!HFI1_CAP_IS_KSET(DMA_RTAIL))
+	if (!rcd->rcvhdrtail_kvaddr)
 		present = (rcd->seq_cnt ==
 				rhf_rcv_seq(rhf_to_cpu(get_rhf_addr(rcd))));
 	else /* is RDMA rtail */
@@ -11843,7 +11843,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op,
 		/* reset the tail and hdr addresses, and sequence count */
 		write_kctxt_csr(dd, ctxt, RCV_HDR_ADDR,
 				rcd->rcvhdrq_dma);
-		if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL))
+		if (rcd->rcvhdrtail_kvaddr)
 			write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
 					rcd->rcvhdrqtailaddr_dma);
 		rcd->seq_cnt = 1;
@@ -11923,7 +11923,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op,
 		rcvctrl |= RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
 	if (op & HFI1_RCVCTRL_INTRAVAIL_DIS)
 		rcvctrl &= ~RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
-	if (op & HFI1_RCVCTRL_TAILUPD_ENB && rcd->rcvhdrqtailaddr_dma)
+	if ((op & HFI1_RCVCTRL_TAILUPD_ENB) && rcd->rcvhdrtail_kvaddr)
 		rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
 	if (op & HFI1_RCVCTRL_TAILUPD_DIS) {
 		/* See comment on RcvCtxtCtrl.TailUpd above */
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index c9d23c3..0fc4aa9 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -505,7 +505,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EINVAL;
 			goto done;
 		}
-		if (flags & VM_WRITE) {
+		if ((flags & VM_WRITE) || !uctxt->rcvhdrtail_kvaddr) {
 			ret = -EPERM;
 			goto done;
 		}
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 8265551..f2a0b03 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1838,7 +1838,6 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	u64 reg;
 
 	if (!rcd->rcvhdrq) {
-		dma_addr_t dma_hdrqtail;
 		gfp_t gfp_flags;
 
 		/*
@@ -1863,13 +1862,13 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
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
