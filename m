From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 07/13] IB/hfi1: Pass the context pointer rather
 than the index
Date: Mon, 24 Jul 2017 07:46:06 -0700
Message-ID: <20170724144606.10034.50710.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The hfi1_rcvctrl() function receives an index which it then converts
to an rcd.  Since most functions have the rcd, use that instead.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c      |   14 ++++++++------
 drivers/infiniband/hw/hfi1/chip.h      |    3 ++-
 drivers/infiniband/hw/hfi1/file_ops.c  |   11 +++++------
 drivers/infiniband/hw/hfi1/init.c      |   14 +++++++-------
 drivers/infiniband/hw/hfi1/intr.c      |    2 +-
 drivers/infiniband/hw/hfi1/vnic_main.c |    4 ++--
 6 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 2f74702..a62ef4a 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6790,7 +6790,7 @@ static void rxe_freeze(struct hfi1_devdata *dd)
 
 	/* disable all receive contexts */
 	for (i = 0; i < dd->num_rcv_contexts; i++)
-		hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_DIS, i);
+		hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_DIS, dd->rcd[i]);
 }
 
 /*
@@ -6814,9 +6814,9 @@ static void rxe_kernel_unfreeze(struct hfi1_devdata *dd)
 
 		rcvmask = HFI1_RCVCTRL_CTXT_ENB;
 		/* HFI1_RCVCTRL_TAILUPD_[ENB|DIS] needs to be set explicitly */
-		rcvmask |= HFI1_CAP_KGET_MASK(dd->rcd[i]->flags, DMA_RTAIL) ?
+		rcvmask |= HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL) ?
 			HFI1_RCVCTRL_TAILUPD_ENB : HFI1_RCVCTRL_TAILUPD_DIS;
-		hfi1_rcvctrl(dd, rcvmask, i);
+		hfi1_rcvctrl(dd, rcvmask, rcd);
 	}
 
 	/* enable port */
@@ -11722,16 +11722,18 @@ static u32 encoded_size(u32 size)
 	return 0x1;	/* if invalid, go with the minimum size */
 }
 
-void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, u16 ctxt)
+void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op,
+		  struct hfi1_ctxtdata *rcd)
 {
-	struct hfi1_ctxtdata *rcd;
 	u64 rcvctrl, reg;
 	int did_enable = 0;
+	u16 ctxt;
 
-	rcd = dd->rcd[ctxt];
 	if (!rcd)
 		return;
 
+	ctxt = rcd->ctxt;
+
 	hfi1_cdbg(RCVCTRL, "ctxt %d op 0x%x", ctxt, op);
 
 	rcvctrl = read_kctxt_csr(dd, ctxt, RCV_CTXT_CTRL);
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 9951052..bef6301 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1352,7 +1352,8 @@ enum {
 void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 		  u32 type, unsigned long pa, u16 order);
 void hfi1_quiet_serdes(struct hfi1_pportdata *ppd);
-void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, u16 ctxt);
+void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op,
+		  struct hfi1_ctxtdata *rcd);
 u32 hfi1_read_cntrs(struct hfi1_devdata *dd, char **namep, u64 **cntrp);
 u32 hfi1_read_portcntrs(struct hfi1_pportdata *ppd, char **namep, u64 **cntrp);
 int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which);
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 51e6a6f..7be75e0 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -389,8 +389,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 
 			sc_disable(sc);
 			ret = sc_enable(sc);
-			hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB,
-				     uctxt->ctxt);
+			hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB, uctxt);
 		} else {
 			ret = sc_restart(sc);
 		}
@@ -793,7 +792,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 		     HFI1_RCVCTRL_TAILUPD_DIS |
 		     HFI1_RCVCTRL_ONE_PKT_EGR_DIS |
 		     HFI1_RCVCTRL_NO_RHQ_DROP_DIS |
-		     HFI1_RCVCTRL_NO_EGR_DROP_DIS, uctxt->ctxt);
+		     HFI1_RCVCTRL_NO_EGR_DROP_DIS, uctxt);
 	/* Clear the context's J_KEY */
 	hfi1_clear_ctxt_jkey(dd, uctxt);
 	/*
@@ -1198,7 +1197,7 @@ static void user_init(struct hfi1_ctxtdata *uctxt)
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_ENB;
 	else
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_DIS;
-	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt->ctxt);
+	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt);
 }
 
 static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
@@ -1410,7 +1409,7 @@ static unsigned int poll_next(struct file *fp,
 	spin_lock_irq(&dd->uctxt_lock);
 	if (hdrqempty(uctxt)) {
 		set_bit(HFI1_CTXT_WAITING_RCV, &uctxt->event_flags);
-		hfi1_rcvctrl(dd, HFI1_RCVCTRL_INTRAVAIL_ENB, uctxt->ctxt);
+		hfi1_rcvctrl(dd, HFI1_RCVCTRL_INTRAVAIL_ENB, uctxt);
 		pollflag = 0;
 	} else {
 		pollflag = POLLIN | POLLRDNORM;
@@ -1495,7 +1494,7 @@ static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 	} else {
 		rcvctrl_op = HFI1_RCVCTRL_CTXT_DIS;
 	}
-	hfi1_rcvctrl(dd, rcvctrl_op, uctxt->ctxt);
+	hfi1_rcvctrl(dd, rcvctrl_op, uctxt);
 	/* always; new head should be equal to new tail; see above */
 bail:
 	return 0;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 818a4b8..7f5e4c7 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -603,8 +603,8 @@ static int init_after_reset(struct hfi1_devdata *dd)
 	 */
 	for (i = 0; i < dd->num_rcv_contexts; i++)
 		hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_DIS |
-				  HFI1_RCVCTRL_INTRAVAIL_DIS |
-				  HFI1_RCVCTRL_TAILUPD_DIS, i);
+			     HFI1_RCVCTRL_INTRAVAIL_DIS |
+			     HFI1_RCVCTRL_TAILUPD_DIS, dd->rcd[i]);
 	pio_send_control(dd, PSC_GLOBAL_DISABLE);
 	for (i = 0; i < dd->num_send_contexts; i++)
 		sc_disable(dd->send_contexts[i].sc);
@@ -634,7 +634,7 @@ static void enable_chip(struct hfi1_devdata *dd)
 			rcvmask |= HFI1_RCVCTRL_NO_RHQ_DROP_ENB;
 		if (HFI1_CAP_KGET_MASK(dd->rcd[i]->flags, NODROP_EGR_FULL))
 			rcvmask |= HFI1_RCVCTRL_NO_EGR_DROP_ENB;
-		hfi1_rcvctrl(dd, rcvmask, i);
+		hfi1_rcvctrl(dd, rcvmask, dd->rcd[i]);
 		sc_enable(dd->rcd[i]->sc);
 	}
 }
@@ -915,10 +915,10 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		ppd = dd->pport + pidx;
 		for (i = 0; i < dd->num_rcv_contexts; i++)
 			hfi1_rcvctrl(dd, HFI1_RCVCTRL_TAILUPD_DIS |
-					  HFI1_RCVCTRL_CTXT_DIS |
-					  HFI1_RCVCTRL_INTRAVAIL_DIS |
-					  HFI1_RCVCTRL_PKEY_DIS |
-					  HFI1_RCVCTRL_ONE_PKT_EGR_DIS, i);
+				     HFI1_RCVCTRL_CTXT_DIS |
+				     HFI1_RCVCTRL_INTRAVAIL_DIS |
+				     HFI1_RCVCTRL_PKEY_DIS |
+				     HFI1_RCVCTRL_ONE_PKT_EGR_DIS, dd->rcd[i]);
 		/*
 		 * Gracefully stop all sends allowing any in progress to
 		 * trickle out first.
diff --git a/drivers/infiniband/hw/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
index 04a5082..9469be9 100644
--- a/drivers/infiniband/hw/hfi1/intr.c
+++ b/drivers/infiniband/hw/hfi1/intr.c
@@ -196,7 +196,7 @@ void handle_user_interrupt(struct hfi1_ctxtdata *rcd)
 
 	if (test_and_clear_bit(HFI1_CTXT_WAITING_RCV, &rcd->event_flags)) {
 		wake_up_interruptible(&rcd->wait);
-		hfi1_rcvctrl(dd, HFI1_RCVCTRL_INTRAVAIL_DIS, rcd->ctxt);
+		hfi1_rcvctrl(dd, HFI1_RCVCTRL_INTRAVAIL_DIS, rcd);
 	} else if (test_and_clear_bit(HFI1_CTXT_WAITING_URG,
 							&rcd->event_flags)) {
 		rcd->urgent++;
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 9bd2744..89b0564 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -95,7 +95,7 @@ static int setup_vnic_ctxt(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt)
 	if (HFI1_CAP_KGET_MASK(uctxt->flags, DMA_RTAIL))
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_ENB;
 
-	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt->ctxt);
+	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt);
 
 	uctxt->is_vnic = true;
 done:
@@ -186,7 +186,7 @@ static void deallocate_vnic_ctxt(struct hfi1_devdata *dd,
 		     HFI1_RCVCTRL_INTRAVAIL_DIS |
 		     HFI1_RCVCTRL_ONE_PKT_EGR_DIS |
 		     HFI1_RCVCTRL_NO_RHQ_DROP_DIS |
-		     HFI1_RCVCTRL_NO_EGR_DROP_DIS, uctxt->ctxt);
+		     HFI1_RCVCTRL_NO_EGR_DROP_DIS, uctxt);
 	/*
 	 * VNIC contexts are allocated from user context pool.
 	 * Release them back to user context pool.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
