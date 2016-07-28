From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/16] IB/hfi1: Use the same capability state for all shared contexts
Date: Thu, 28 Jul 2016 15:21:13 -0400
Message-ID: <1469733687-31738-3-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Save the current capability state at user context creation
time.  Report this saved value for all shared contexts.

Also get rid of unnecessary hfi1_get_base_kinfo function.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |  8 --------
 drivers/infiniband/hw/hfi1/chip.h     |  2 --
 drivers/infiniband/hw/hfi1/file_ops.c | 21 +++++++++++----------
 drivers/infiniband/hw/hfi1/hfi.h      |  2 +-
 4 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index c93683496614..b32638d58ae8 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9648,14 +9648,6 @@ void hfi1_clear_tids(struct hfi1_ctxtdata *rcd)
 		hfi1_put_tid(dd, i, PT_INVALID, 0, 0);
 }
 
-int hfi1_get_base_kinfo(struct hfi1_ctxtdata *rcd,
-			struct hfi1_ctxt_info *kinfo)
-{
-	kinfo->runtime_flags = (HFI1_MISC_GET() << HFI1_CAP_USER_SHIFT) |
-		HFI1_CAP_UGET(MASK) | HFI1_CAP_KGET(K2U);
-	return 0;
-}
-
 struct hfi1_message_header *hfi1_get_msgheader(
 				struct hfi1_devdata *dd, __le32 *rhf_addr)
 {
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index f07bc4ccc468..ed11107c50fe 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1337,8 +1337,6 @@ void hfi1_start_cleanup(struct hfi1_devdata *dd);
 void hfi1_clear_tids(struct hfi1_ctxtdata *rcd);
 struct hfi1_message_header *hfi1_get_msgheader(
 				struct hfi1_devdata *dd, __le32 *rhf_addr);
-int hfi1_get_base_kinfo(struct hfi1_ctxtdata *rcd,
-			struct hfi1_ctxt_info *kinfo);
 int hfi1_init_ctxt(struct send_context *sc);
 void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 		  u32 type, unsigned long pa, u16 order);
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 0522bafb190b..1f4cd5aa2071 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -981,7 +981,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 			return ret;
 	}
 	uctxt->userversion = uinfo->userversion;
-	uctxt->flags = HFI1_CAP_UGET(MASK);
+	uctxt->flags = hfi1_cap_mask; /* save current flag state */
 	init_waitqueue_head(&uctxt->wait);
 	strlcpy(uctxt->comm, current->comm, sizeof(uctxt->comm));
 	memcpy(uctxt->uuid, uinfo->uuid, sizeof(uctxt->uuid));
@@ -1084,18 +1084,18 @@ static int user_init(struct file *fp)
 	hfi1_set_ctxt_jkey(uctxt->dd, uctxt->ctxt, uctxt->jkey);
 
 	rcvctrl_ops = HFI1_RCVCTRL_CTXT_ENB;
-	if (HFI1_CAP_KGET_MASK(uctxt->flags, HDRSUPP))
+	if (HFI1_CAP_UGET_MASK(uctxt->flags, HDRSUPP))
 		rcvctrl_ops |= HFI1_RCVCTRL_TIDFLOW_ENB;
 	/*
 	 * Ignore the bit in the flags for now until proper
 	 * support for multiple packet per rcv array entry is
 	 * added.
 	 */
-	if (!HFI1_CAP_KGET_MASK(uctxt->flags, MULTI_PKT_EGR))
+	if (!HFI1_CAP_UGET_MASK(uctxt->flags, MULTI_PKT_EGR))
 		rcvctrl_ops |= HFI1_RCVCTRL_ONE_PKT_EGR_ENB;
-	if (HFI1_CAP_KGET_MASK(uctxt->flags, NODROP_EGR_FULL))
+	if (HFI1_CAP_UGET_MASK(uctxt->flags, NODROP_EGR_FULL))
 		rcvctrl_ops |= HFI1_RCVCTRL_NO_EGR_DROP_ENB;
-	if (HFI1_CAP_KGET_MASK(uctxt->flags, NODROP_RHQ_FULL))
+	if (HFI1_CAP_UGET_MASK(uctxt->flags, NODROP_RHQ_FULL))
 		rcvctrl_ops |= HFI1_RCVCTRL_NO_RHQ_DROP_ENB;
 	/*
 	 * The RcvCtxtCtrl.TailUpd bit has to be explicitly written.
@@ -1103,7 +1103,7 @@ static int user_init(struct file *fp)
 	 * uses of the chip or ctxt. Therefore, add the rcvctrl op
 	 * for both cases.
 	 */
-	if (HFI1_CAP_KGET_MASK(uctxt->flags, DMA_RTAIL))
+	if (HFI1_CAP_UGET_MASK(uctxt->flags, DMA_RTAIL))
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_ENB;
 	else
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_DIS;
@@ -1126,9 +1126,10 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 	int ret = 0;
 
 	memset(&cinfo, 0, sizeof(cinfo));
-	ret = hfi1_get_base_kinfo(uctxt, &cinfo);
-	if (ret < 0)
-		goto done;
+	cinfo.runtime_flags = (((uctxt->flags >> HFI1_CAP_MISC_SHIFT) &
+				HFI1_CAP_MISC_MASK) << HFI1_CAP_USER_SHIFT) |
+			HFI1_CAP_UGET_MASK(uctxt->flags, MASK) |
+			HFI1_CAP_KGET_MASK(uctxt->flags, K2U);
 	cinfo.num_active = hfi1_count_active_units();
 	cinfo.unit = uctxt->dd->unit;
 	cinfo.ctxt = uctxt->ctxt;
@@ -1150,7 +1151,7 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, fd->subctxt, cinfo);
 	if (copy_to_user(ubase, &cinfo, sizeof(cinfo)))
 		ret = -EFAULT;
-done:
+
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 6fb86fee0701..36e6b8e0c735 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -255,7 +255,7 @@ struct hfi1_ctxtdata {
 	/* chip offset of PIO buffers for this ctxt */
 	u32 piobufs;
 	/* per-context configuration flags */
-	u32 flags;
+	unsigned long flags;
 	/* per-context event flags for fileops/intr communication */
 	unsigned long event_flags;
 	/* WAIT_RCV that timed out, no interrupt */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
