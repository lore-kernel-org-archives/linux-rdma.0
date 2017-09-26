From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 9/9] IB/hfi1: Refactor reset_ctxt() IOCTL
Date: Tue, 26 Sep 2017 07:04:42 -0700
Message-ID: <20170926140440.16637.88239.stgit@scvm10.sc.intel.com>
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

The IOCTL is a bit unwieldy.  Refactor reset_ctxt() to be a bit more
manageable.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |  122 ++++++++++++++++++---------------
 1 files changed, 66 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 6497b65..22feca5 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -107,6 +107,7 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 static int user_event_ack(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 			  unsigned long arg);
 static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned long arg);
+static int ctxt_reset(struct hfi1_ctxtdata *uctxt);
 static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       unsigned long arg);
 static int vma_fault(struct vm_fault *vmf);
@@ -282,63 +283,9 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 		ret = set_ctxt_pkey(uctxt, arg);
 		break;
 
-	case HFI1_IOCTL_CTXT_RESET: {
-		struct send_context *sc;
-		struct hfi1_devdata *dd;
-
-		if (!uctxt || !uctxt->dd || !uctxt->sc)
-			return -EINVAL;
-
-		/*
-		 * There is no protection here. User level has to
-		 * guarantee that no one will be writing to the send
-		 * context while it is being re-initialized.
-		 * If user level breaks that guarantee, it will break
-		 * it's own context and no one else's.
-		 */
-		dd = uctxt->dd;
-		sc = uctxt->sc;
-		/*
-		 * Wait until the interrupt handler has marked the
-		 * context as halted or frozen. Report error if we time
-		 * out.
-		 */
-		wait_event_interruptible_timeout(
-			sc->halt_wait, (sc->flags & SCF_HALTED),
-			msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
-		if (!(sc->flags & SCF_HALTED))
-			return -ENOLCK;
-
-		/*
-		 * If the send context was halted due to a Freeze,
-		 * wait until the device has been "unfrozen" before
-		 * resetting the context.
-		 */
-		if (sc->flags & SCF_FROZEN) {
-			wait_event_interruptible_timeout(
-				dd->event_queue,
-				!(ACCESS_ONCE(dd->flags) & HFI1_FROZEN),
-				msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
-			if (dd->flags & HFI1_FROZEN)
-				return -ENOLCK;
-
-			if (dd->flags & HFI1_FORCED_FREEZE)
-				/*
-				 * Don't allow context reset if we are into
-				 * forced freeze
-				 */
-				return -ENODEV;
-
-			sc_disable(sc);
-			ret = sc_enable(sc);
-			hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB, uctxt);
-		} else {
-			ret = sc_restart(sc);
-		}
-		if (!ret)
-			sc_return_credits(sc);
+	case HFI1_IOCTL_CTXT_RESET:
+		ret = ctxt_reset(uctxt);
 		break;
-	}
 
 	case HFI1_IOCTL_GET_VERS:
 		uval = HFI1_USER_SWVERSION;
@@ -1658,6 +1605,69 @@ static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned long arg)
 	return -ENOENT;
 }
 
+/**
+ * ctxt_reset - Reset the user context
+ * @uctxt: valid user context
+ */
+static int ctxt_reset(struct hfi1_ctxtdata *uctxt)
+{
+	struct send_context *sc;
+	struct hfi1_devdata *dd;
+	int ret = 0;
+
+	if (!uctxt || !uctxt->dd || !uctxt->sc)
+		return -EINVAL;
+
+	/*
+	 * There is no protection here. User level has to guarantee that
+	 * no one will be writing to the send context while it is being
+	 * re-initialized.  If user level breaks that guarantee, it will
+	 * break it's own context and no one else's.
+	 */
+	dd = uctxt->dd;
+	sc = uctxt->sc;
+
+	/*
+	 * Wait until the interrupt handler has marked the context as
+	 * halted or frozen. Report error if we time out.
+	 */
+	wait_event_interruptible_timeout(
+		sc->halt_wait, (sc->flags & SCF_HALTED),
+		msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
+	if (!(sc->flags & SCF_HALTED))
+		return -ENOLCK;
+
+	/*
+	 * If the send context was halted due to a Freeze, wait until the
+	 * device has been "unfrozen" before resetting the context.
+	 */
+	if (sc->flags & SCF_FROZEN) {
+		wait_event_interruptible_timeout(
+			dd->event_queue,
+			!(READ_ONCE(dd->flags) & HFI1_FROZEN),
+			msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
+		if (dd->flags & HFI1_FROZEN)
+			return -ENOLCK;
+
+		if (dd->flags & HFI1_FORCED_FREEZE)
+			/*
+			 * Don't allow context reset if we are into
+			 * forced freeze
+			 */
+			return -ENODEV;
+
+		sc_disable(sc);
+		ret = sc_enable(sc);
+		hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB, uctxt);
+	} else {
+		ret = sc_restart(sc);
+	}
+	if (!ret)
+		sc_return_credits(sc);
+
+	return ret;
+}
+
 static void user_remove(struct hfi1_devdata *dd)
 {
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
