From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/9] IB/hfi1: Fix parenthesis alignment issues
Date: Tue, 26 Sep 2017 07:04:03 -0700
Message-ID: <20170926140402.16637.87560.stgit@scvm10.sc.intel.com>
References: <20170926140201.16637.45981.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926140201.16637.45981.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In preparation to refactoring get_base_info(), cleanup some
checkpatch issues.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index a37139f..1fc500f 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1385,34 +1385,34 @@ static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 					       fd->subctxt,
 					       uctxt->egrbufs.rcvtids[0].dma);
 	binfo.sdma_comp_bufbase = HFI1_MMAP_TOKEN(SDMA_COMP, uctxt->ctxt,
-						 fd->subctxt, 0);
+						  fd->subctxt, 0);
 	/*
 	 * user regs are at
 	 * (RXE_PER_CONTEXT_USER + (ctxt * RXE_PER_CONTEXT_SIZE))
 	 */
 	binfo.user_regbase = HFI1_MMAP_TOKEN(UREGS, uctxt->ctxt,
-					    fd->subctxt, 0);
+					     fd->subctxt, 0);
 	offset = offset_in_page((uctxt_offset(uctxt) + fd->subctxt) *
 				sizeof(*dd->events));
 	binfo.events_bufbase = HFI1_MMAP_TOKEN(EVENTS, uctxt->ctxt,
-					      fd->subctxt,
-					      offset);
+					       fd->subctxt,
+					       offset);
 	binfo.status_bufbase = HFI1_MMAP_TOKEN(STATUS, uctxt->ctxt,
-					      fd->subctxt,
-					      dd->status);
+					       fd->subctxt,
+					       dd->status);
 	if (HFI1_CAP_IS_USET(DMA_RTAIL))
 		binfo.rcvhdrtail_base = HFI1_MMAP_TOKEN(RTAIL, uctxt->ctxt,
-						       fd->subctxt, 0);
+							fd->subctxt, 0);
 	if (uctxt->subctxt_cnt) {
 		binfo.subctxt_uregbase = HFI1_MMAP_TOKEN(SUBCTXT_UREGS,
-							uctxt->ctxt,
-							fd->subctxt, 0);
-		binfo.subctxt_rcvhdrbuf = HFI1_MMAP_TOKEN(SUBCTXT_RCV_HDRQ,
 							 uctxt->ctxt,
 							 fd->subctxt, 0);
+		binfo.subctxt_rcvhdrbuf = HFI1_MMAP_TOKEN(SUBCTXT_RCV_HDRQ,
+							  uctxt->ctxt,
+							  fd->subctxt, 0);
 		binfo.subctxt_rcvegrbuf = HFI1_MMAP_TOKEN(SUBCTXT_EGRBUF,
-							 uctxt->ctxt,
-							 fd->subctxt, 0);
+							  uctxt->ctxt,
+							  fd->subctxt, 0);
 	}
 	sz = (len < sizeof(binfo)) ? len : sizeof(binfo);
 	if (copy_to_user(ubase, &binfo, sz))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
