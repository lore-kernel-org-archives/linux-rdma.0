From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/54] staging/rdma/hfi1: Correctly set RcvCtxtCtrl register
Date: Wed, 03 Feb 2016 14:32:49 -0800
Message-ID: <20160203223246.5923.96306.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The RcvCtxtCtrl register was being incorrectly set upon context
initialization and clean up resulting, in many cases, of contexts using
settings from previous contexts' initialization. This resulted in bad
and unexpected behavior. This was especially important for the TailUpd
bit, which requires special handling and if set incorrectly could lead
to severely degraded performance.

This patch fixes the handling of the RcvCtxtCtrl register, ensuring that
each context gets initialized with settings applicable only for that
context. It also ensures the proper setting for the TailUpd bit by
setting it to either 0 or 1 (as needed by the context's configuration)
explicitly.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |   18 ++++++++++++++----
 drivers/staging/rdma/hfi1/file_ops.c |    9 +++++++++
 drivers/staging/rdma/hfi1/init.c     |    2 +-
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index a90e6e6..d10ba67 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6684,11 +6684,17 @@ static void rxe_freeze(struct hfi1_devdata *dd)
  */
 static void rxe_kernel_unfreeze(struct hfi1_devdata *dd)
 {
+	u32 rcvmask;
 	int i;
 
 	/* enable all kernel contexts */
-	for (i = 0; i < dd->n_krcv_queues; i++)
-		hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB, i);
+	for (i = 0; i < dd->n_krcv_queues; i++) {
+		rcvmask = HFI1_RCVCTRL_CTXT_ENB;
+		/* HFI1_RCVCTRL_TAILUPD_[ENB|DIS] needs to be set explicitly */
+		rcvmask |= HFI1_CAP_KGET_MASK(dd->rcd[i]->flags, DMA_RTAIL) ?
+			HFI1_RCVCTRL_TAILUPD_ENB : HFI1_RCVCTRL_TAILUPD_DIS;
+		hfi1_rcvctrl(dd, rcvmask, i);
+	}
 
 	/* enable port */
 	add_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
@@ -11255,6 +11261,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		if (dd->rcvhdrtail_dummy_physaddr) {
 			write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
 					dd->rcvhdrtail_dummy_physaddr);
+			/* Enabling RcvCtxtCtrl.TailUpd is intentional. */
 			rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
 		}
 
@@ -11266,8 +11273,11 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		rcvctrl &= ~RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
 	if (op & HFI1_RCVCTRL_TAILUPD_ENB && rcd->rcvhdrqtailaddr_phys)
 		rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
-	if (op & HFI1_RCVCTRL_TAILUPD_DIS)
-		rcvctrl &= ~RCV_CTXT_CTRL_TAIL_UPD_SMASK;
+	if (op & HFI1_RCVCTRL_TAILUPD_DIS) {
+		/* See comment on RcvCtxtCtrl.TailUpd above */
+		if (!(op & HFI1_RCVCTRL_CTXT_DIS))
+			rcvctrl &= ~RCV_CTXT_CTRL_TAIL_UPD_SMASK;
+	}
 	if (op & HFI1_RCVCTRL_TIDFLOW_ENB)
 		rcvctrl |= RCV_CTXT_CTRL_TID_FLOW_ENABLE_SMASK;
 	if (op & HFI1_RCVCTRL_TIDFLOW_DIS)
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index d365889..5c694fa 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -771,6 +771,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_DIS |
 		     HFI1_RCVCTRL_TIDFLOW_DIS |
 		     HFI1_RCVCTRL_INTRAVAIL_DIS |
+		     HFI1_RCVCTRL_TAILUPD_DIS |
 		     HFI1_RCVCTRL_ONE_PKT_EGR_DIS |
 		     HFI1_RCVCTRL_NO_RHQ_DROP_DIS |
 		     HFI1_RCVCTRL_NO_EGR_DROP_DIS, uctxt->ctxt);
@@ -1156,8 +1157,16 @@ static int user_init(struct file *fp)
 		rcvctrl_ops |= HFI1_RCVCTRL_NO_EGR_DROP_ENB;
 	if (HFI1_CAP_KGET_MASK(uctxt->flags, NODROP_RHQ_FULL))
 		rcvctrl_ops |= HFI1_RCVCTRL_NO_RHQ_DROP_ENB;
+	/*
+	 * The RcvCtxtCtrl.TailUpd bit has to be explicitly written.
+	 * We can't rely on the correct value to be set from prior
+	 * uses of the chip or ctxt. Therefore, add the rcvctrl op
+	 * for both cases.
+	 */
 	if (HFI1_CAP_KGET_MASK(uctxt->flags, DMA_RTAIL))
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_ENB;
+	else
+		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_DIS;
 	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt->ctxt);
 
 	/* Notify any waiting slaves */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 2851e90..fc3d40a 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -589,8 +589,8 @@ static void enable_chip(struct hfi1_devdata *dd)
 	 * Enable kernel ctxts' receive and receive interrupt.
 	 * Other ctxts done as user opens and initializes them.
 	 */
-	rcvmask = HFI1_RCVCTRL_CTXT_ENB | HFI1_RCVCTRL_INTRAVAIL_ENB;
 	for (i = 0; i < dd->first_user_ctxt; ++i) {
+		rcvmask = HFI1_RCVCTRL_CTXT_ENB | HFI1_RCVCTRL_INTRAVAIL_ENB;
 		rcvmask |= HFI1_CAP_KGET_MASK(dd->rcd[i]->flags, DMA_RTAIL) ?
 			HFI1_RCVCTRL_TAILUPD_ENB : HFI1_RCVCTRL_TAILUPD_DIS;
 		if (!HFI1_CAP_KGET_MASK(dd->rcd[i]->flags, MULTI_PKT_EGR))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
