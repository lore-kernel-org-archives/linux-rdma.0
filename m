From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/12] IB/hfi1: Update HFI to use the latest PCI API
Date: Tue, 26 Sep 2017 07:00:30 -0700
Message-ID: <20170926140029.15601.99834.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The HFI PCI IRQ code uses an obsolete PCI API.  Update the code to use
the new PCI IRQ API and any necessary changes because of the new API.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   58 +++++++++++++------------------------
 drivers/infiniband/hw/hfi1/hfi.h  |    2 -
 2 files changed, 21 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index c47a01f..0b45615 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -12984,7 +12984,7 @@ static void clean_up_interrupts(struct hfi1_devdata *dd)
 			if (!me->arg) /* => no irq, no affinity */
 				continue;
 			hfi1_put_irq_affinity(dd, me);
-			free_irq(me->irq, me->arg);
+			pci_free_irq(dd->pcidev, i, me->arg);
 		}
 
 		/* clean structures */
@@ -12994,7 +12994,7 @@ static void clean_up_interrupts(struct hfi1_devdata *dd)
 	} else {
 		/* INTx */
 		if (dd->requested_intx_irq) {
-			free_irq(dd->pcidev->irq, dd);
+			pci_free_irq(dd->pcidev, 0, dd);
 			dd->requested_intx_irq = 0;
 		}
 		disable_intx(dd->pcidev);
@@ -13053,10 +13053,8 @@ static int request_intx_irq(struct hfi1_devdata *dd)
 {
 	int ret;
 
-	snprintf(dd->intx_name, sizeof(dd->intx_name), DRIVER_NAME "_%d",
-		 dd->unit);
-	ret = request_irq(dd->pcidev->irq, general_interrupt,
-			  IRQF_SHARED, dd->intx_name, dd);
+	ret = pci_request_irq(dd->pcidev, 0, general_interrupt, NULL, dd,
+			      DRIVER_NAME "_%d", dd->unit);
 	if (ret)
 		dd_dev_err(dd, "unable to request INTx interrupt, err %d\n",
 			   ret);
@@ -13099,13 +13097,14 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		int idx;
 		struct hfi1_ctxtdata *rcd = NULL;
 		struct sdma_engine *sde = NULL;
+		char name[MAX_NAME_SIZE];
 
-		/* obtain the arguments to request_irq */
+		/* obtain the arguments to pci_request_irq */
 		if (first_general <= i && i < last_general) {
 			idx = i - first_general;
 			handler = general_interrupt;
 			arg = dd;
-			snprintf(me->name, sizeof(me->name),
+			snprintf(name, sizeof(name),
 				 DRIVER_NAME "_%d", dd->unit);
 			err_info = "general";
 			me->type = IRQ_GENERAL;
@@ -13114,7 +13113,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			sde = &dd->per_sdma[idx];
 			handler = sdma_interrupt;
 			arg = sde;
-			snprintf(me->name, sizeof(me->name),
+			snprintf(name, sizeof(name),
 				 DRIVER_NAME "_%d sdma%d", dd->unit, idx);
 			err_info = "sdma";
 			remap_sdma_interrupts(dd, idx, i);
@@ -13133,7 +13132,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 				handler = receive_context_interrupt;
 				thread = receive_context_thread;
 				arg = rcd;
-				snprintf(me->name, sizeof(me->name),
+				snprintf(name, sizeof(name),
 					 DRIVER_NAME "_%d kctxt%d",
 					 dd->unit, idx);
 				err_info = "receive context";
@@ -13154,18 +13153,10 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		if (!arg)
 			continue;
 		/* make sure the name is terminated */
-		me->name[sizeof(me->name) - 1] = 0;
+		name[sizeof(name) - 1] = 0;
 		me->irq = pci_irq_vector(dd->pcidev, i);
-		/*
-		 * On err return me->irq.  Don't need to clear this
-		 * because 'arg' has not been set, and cleanup will
-		 * do the right thing.
-		 */
-		if (me->irq < 0)
-			return me->irq;
-
-		ret = request_threaded_irq(me->irq, handler, thread, 0,
-					   me->name, arg);
+		ret = pci_request_irq(dd->pcidev, i, handler, thread, arg,
+				      name);
 		if (ret) {
 			dd_dev_err(dd,
 				   "unable to allocate %s interrupt, irq %d, index %d, err %d\n",
@@ -13173,7 +13164,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			return ret;
 		}
 		/*
-		 * assign arg after request_irq call, so it will be
+		 * assign arg after pci_request_irq call, so it will be
 		 * cleaned up
 		 */
 		me->arg = arg;
@@ -13191,7 +13182,7 @@ void hfi1_vnic_synchronize_irq(struct hfi1_devdata *dd)
 	int i;
 
 	if (!dd->num_msix_entries) {
-		synchronize_irq(dd->pcidev->irq);
+		synchronize_irq(pci_irq_vector(dd->pcidev, 0));
 		return;
 	}
 
@@ -13212,7 +13203,7 @@ void hfi1_reset_vnic_msix_info(struct hfi1_ctxtdata *rcd)
 		return;
 
 	hfi1_put_irq_affinity(dd, me);
-	free_irq(me->irq, me->arg);
+	pci_free_irq(dd->pcidev, rcd->msix_intr, me->arg);
 
 	me->arg = NULL;
 }
@@ -13235,28 +13226,21 @@ void hfi1_set_vnic_msix_info(struct hfi1_ctxtdata *rcd)
 	rcd->ireg = (IS_RCVAVAIL_START + idx) / 64;
 	rcd->imask = ((u64)1) <<
 		  ((IS_RCVAVAIL_START + idx) % 64);
-
-	snprintf(me->name, sizeof(me->name),
-		 DRIVER_NAME "_%d kctxt%d", dd->unit, idx);
-	me->name[sizeof(me->name) - 1] = 0;
 	me->type = IRQ_RCVCTXT;
 	me->irq = pci_irq_vector(dd->pcidev, rcd->msix_intr);
-	if (me->irq < 0) {
-		dd_dev_err(dd, "vnic irq vector request (idx %d) fail %d\n",
-			   idx, me->irq);
-		return;
-	}
 	remap_intr(dd, IS_RCVAVAIL_START + idx, rcd->msix_intr);
 
-	ret = request_threaded_irq(me->irq, receive_context_interrupt,
-				   receive_context_thread, 0, me->name, arg);
+	ret = pci_request_irq(dd->pcidev, rcd->msix_intr,
+			      receive_context_interrupt,
+			      receive_context_thread, arg,
+			      DRIVER_NAME "_%d kctxt%d", dd->unit, idx);
 	if (ret) {
 		dd_dev_err(dd, "vnic irq request (irq %d, idx %d) fail %d\n",
 			   me->irq, idx, ret);
 		return;
 	}
 	/*
-	 * assign arg after request_irq call, so it will be
+	 * assign arg after pci_request_irq call, so it will be
 	 * cleaned up
 	 */
 	me->arg = arg;
@@ -13265,7 +13249,7 @@ void hfi1_set_vnic_msix_info(struct hfi1_ctxtdata *rcd)
 	if (ret) {
 		dd_dev_err(dd,
 			   "unable to pin IRQ %d\n", ret);
-		free_irq(me->irq, me->arg);
+		pci_free_irq(dd->pcidev, rcd->msix_intr, me->arg);
 	}
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 3ac9c30..0a64158 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -616,7 +616,6 @@ struct hfi1_msix_entry {
 	enum irq_type type;
 	int irq;
 	void *arg;
-	char name[MAX_NAME_SIZE];
 	cpumask_t mask;
 	struct irq_affinity_notify notify;
 };
@@ -1183,7 +1182,6 @@ struct hfi1_devdata {
 
 	/* INTx information */
 	u32 requested_intx_irq;		/* did we request one? */
-	char intx_name[MAX_NAME_SIZE];	/* INTx name */
 
 	/* general interrupt: mask of handled interrupts */
 	u64 gi_mask[CCE_NUM_INT_CSRS];

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
