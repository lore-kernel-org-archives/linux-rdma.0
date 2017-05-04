From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 12/15] IB/hfi1: Correctly clear the pkey
Date: Thu, 04 May 2017 05:15:03 -0700
Message-ID: <20170504121502.32747.57781.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In the close path the context is removed from the device array, and then
the clear pkey function is called.  The pkey function trys to get the
context from the device array, but because it was removed the clearing
does not occur.

Rework pkey clear function to work as expected.  Update the function
variable to reflect the correct size and name of the hw_context.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c      |   34 +++++++++++++-------------------
 drivers/infiniband/hw/hfi1/chip.h      |    2 +-
 drivers/infiniband/hw/hfi1/file_ops.c  |    2 +-
 drivers/infiniband/hw/hfi1/vnic_main.c |    2 +-
 4 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 5aa95da..9f72d55 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14528,30 +14528,24 @@ int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey)
 	return ret;
 }
 
-int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt)
+int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, struct hfi1_ctxtdata *ctxt)
 {
-	struct hfi1_ctxtdata *rcd;
-	unsigned sctxt;
-	int ret = 0;
+	u8 hw_ctxt;
 	u64 reg;
 
-	if (ctxt < dd->num_rcv_contexts) {
-		rcd = dd->rcd[ctxt];
-	} else {
-		ret = -EINVAL;
-		goto done;
-	}
-	if (!rcd || !rcd->sc) {
-		ret = -EINVAL;
-		goto done;
-	}
-	sctxt = rcd->sc->hw_context;
-	reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
+	if (!ctxt || !ctxt->sc)
+		return -EINVAL;
+
+	if (ctxt->ctxt >= dd->num_rcv_contexts)
+		return -EINVAL;
+
+	hw_ctxt = ctxt->sc->hw_context;
+	reg = read_kctxt_csr(dd, hw_ctxt, SEND_CTXT_CHECK_ENABLE);
 	reg &= ~SEND_CTXT_CHECK_ENABLE_CHECK_PARTITION_KEY_SMASK;
-	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
-	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_PARTITION_KEY, 0);
-done:
-	return ret;
+	write_kctxt_csr(dd, hw_ctxt, SEND_CTXT_CHECK_ENABLE, reg);
+	write_kctxt_csr(dd, hw_ctxt, SEND_CTXT_CHECK_PARTITION_KEY, 0);
+
+	return 0;
 }
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 4c3c88d..760aa2e 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1362,7 +1362,7 @@ void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey);
 int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt);
 int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey);
-int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt);
+int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, struct hfi1_ctxtdata *ctxt);
 void hfi1_read_link_quality(struct hfi1_devdata *dd, u8 *link_quality);
 void hfi1_init_vnic_rsm(struct hfi1_devdata *dd);
 void hfi1_deinit_vnic_rsm(struct hfi1_devdata *dd);
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 9574fc4..5a62440 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -810,7 +810,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	dd->rcd[uctxt->ctxt] = NULL;
 
 	hfi1_user_exp_rcv_grp_free(uctxt);
-	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
+	hfi1_clear_ctxt_pkey(dd, uctxt);
 
 	uctxt->rcvwait_to = 0;
 	uctxt->piowait_to = 0;
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 392f4d5..b1572c7 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -209,7 +209,7 @@ static void deallocate_vnic_ctxt(struct hfi1_devdata *dd,
 	uctxt->event_flags = 0;
 
 	hfi1_clear_tids(uctxt);
-	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
+	hfi1_clear_ctxt_pkey(dd, uctxt);
 
 	hfi1_stats.sps_ctxts--;
 	hfi1_free_ctxtdata(dd, uctxt);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
