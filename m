From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/21] IB/hfi1: Fix QOS rule mappings
Date: Tue, 12 Apr 2016 10:50:22 -0700
Message-ID: <20160412175021.24485.27742.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The QOS RSM rule mappings are off by one, referencing a kernel receive
context that does not exist.

Correctly start the QOS RSM map entries at FIRST_KERNEL_CONTEXT rather
than MIN_KERNEL_KCTXTS.  Remove the cruft that hid this.

Change the QP map table so all traffic not caught by QOS RSM goes to
the control context rather than the first QOS context.

Correct comments to match the actual code operation and intent.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   48 +++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 8b54d66..79dc29a 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -12675,20 +12675,20 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	unsigned ngroups;
 
 	/*
-	 * Kernel contexts: (to be fixed later):
-	 * - min or 2 or 1 context/numa
+	 * Kernel receive contexts:
+	 * - min of 2 or 1 context/numa (excluding control context)
 	 * - Context 0 - control context (VL15/multicast/error)
-	 * - Context 1 - default context
+	 * - Context 1 - first kernel context
+	 * - Context 2 - second kernel context
+	 * ...
 	 */
 	if (n_krcvqs)
 		/*
-		 * Don't count context 0 in n_krcvqs since
-		 * is isn't used for normal verbs traffic.
-		 *
-		 * krcvqs will reflect number of kernel
-		 * receive contexts above 0.
+		 * n_krcvqs is the sum of module parameter kernel receive
+		 * contexts, krcvqs[].  It does not include the control
+		 * context, so add that.
 		 */
-		num_kernel_contexts = n_krcvqs + MIN_KERNEL_KCTXTS - 1;
+		num_kernel_contexts = n_krcvqs + 1;
 	else
 		num_kernel_contexts = num_online_nodes() + 1;
 	num_kernel_contexts =
@@ -13473,22 +13473,17 @@ static void init_qpmap_table(struct hfi1_devdata *dd,
 /**
  * init_qos - init RX qos
  * @dd - device data
- * @first_context
- *
- * This routine initializes Rule 0 and the
- * RSM map table to implement qos.
  *
- * If all of the limit tests succeed,
- * qos is applied based on the array
- * interpretation of krcvqs where
- * entry 0 is VL0.
+ * This routine initializes Rule 0 and the RSM map table to implement
+ * quality of service (qos).
  *
- * The number of vl bits (n) and the number of qpn
- * bits (m) are computed to feed both the RSM map table
- * and the single rule.
+ * If all of the limit tests succeed, qos is applied based on the array
+ * interpretation of krcvqs where entry 0 is VL0.
  *
+ * The number of vl bits (n) and the number of qpn bits (m) are computed to
+ * feed both the RSM map table and the single rule.
  */
-static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
+static void init_qos(struct hfi1_devdata *dd)
 {
 	u8 max_by_vl = 0;
 	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
@@ -13518,7 +13513,7 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 		goto bail;
 	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
 	/* init the local copy of the table */
-	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
+	for (i = 0, ctxt = FIRST_KERNEL_KCTXT; i < num_vls; i++) {
 		unsigned tctxt;
 
 		for (qpn = 0, tctxt = ctxt;
@@ -13546,7 +13541,7 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	/* add rule0 */
 	write_csr(dd, RCV_RSM_CFG /* + (8 * 0) */,
 		  RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_MASK <<
-		  RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT |
+			RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT |
 		  2ull << RCV_RSM_CFG_PACKET_TYPE_SHIFT);
 	write_csr(dd, RCV_RSM_SELECT /* + (8 * 0) */,
 		  LRH_BTH_MATCH_OFFSET << RCV_RSM_SELECT_FIELD1_OFFSET_SHIFT |
@@ -13563,8 +13558,8 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	/* Enable RSM */
 	add_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
 	kfree(rsmmap);
-	/* map everything else to first context */
-	init_qpmap_table(dd, FIRST_KERNEL_KCTXT, MIN_KERNEL_KCTXTS - 1);
+	/* map everything else to the mcast/err/vl15 context */
+	init_qpmap_table(dd, HFI1_CTRL_CTXT, HFI1_CTRL_CTXT);
 	dd->qos_shift = n + 1;
 	return;
 bail:
@@ -13577,8 +13572,7 @@ static void init_rxe(struct hfi1_devdata *dd)
 	/* enable all receive errors */
 	write_csr(dd, RCV_ERR_MASK, ~0ull);
 	/* setup QPN map table - start where VL15 context leaves off */
-	init_qos(dd, dd->n_krcv_queues > MIN_KERNEL_KCTXTS ?
-		 MIN_KERNEL_KCTXTS : 0);
+	init_qos(dd);
 	/*
 	 * make sure RcvCtrl.RcvWcb <= PCIe Device Control
 	 * Register Max_Payload_Size (PCI_EXP_DEVCTL in Linux PCIe config

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
