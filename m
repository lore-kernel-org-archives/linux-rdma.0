From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND 11/11] staging/rdma/hfi1: Workaround to prevent corruption during packet delivery
Date: Fri,  6 Nov 2015 20:07:06 -0500
Message-ID: <1446858426-30509-12-git-send-email-jubin.john@intel.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446858426-30509-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mark F. Brown <mark.f.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Disabling one receive context when RX_DMA is receiving a packet can cause
incorrect packet delivery for a subsequent packet on another receive
context.

This is resolved by doing the following:
1. Programming dummy tail address for every receive context
   before enabling it
2. While deallocating receive context resetting tail address
   to dummy address
3. Leaving the dummy address in when disabling tail update
4. When disabling receive context leaving tail update enabled

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mark F. Brown <mark.f.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   18 +++++++++++++++---
 drivers/staging/rdma/hfi1/hfi.h  |    4 ++++
 drivers/staging/rdma/hfi1/init.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 7658c76..e74c32e 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -7785,6 +7785,17 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 	}
 	if (op & HFI1_RCVCTRL_CTXT_DIS) {
 		write_csr(dd, RCV_VL15, 0);
+		/*
+		 * When receive context is being disabled turn on tail
+		 * update with a dummy tail address and then disable
+		 * receive context.
+		 */
+		if (dd->rcvhdrtail_dummy_physaddr) {
+			write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
+					dd->rcvhdrtail_dummy_physaddr);
+			rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
+		}
+
 		rcvctrl &= ~RCV_CTXT_CTRL_ENABLE_SMASK;
 	}
 	if (op & HFI1_RCVCTRL_INTRAVAIL_ENB)
@@ -7854,10 +7865,11 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 	if (op & (HFI1_RCVCTRL_TAILUPD_DIS | HFI1_RCVCTRL_CTXT_DIS))
 		/*
 		 * If the context has been disabled and the Tail Update has
-		 * been cleared, clear the RCV_HDR_TAIL_ADDR CSR so
-		 * it doesn't contain an address that is invalid.
+		 * been cleared, set the RCV_HDR_TAIL_ADDR CSR to dummy address
+		 * so it doesn't contain an address that is invalid.
 		 */
-		write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR, 0);
+		write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
+				dd->rcvhdrtail_dummy_physaddr);
 }
 
 u32 hfi1_read_cntrs(struct hfi1_devdata *dd, loff_t pos, char **namep,
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 190f7a2..02f2deb 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1084,6 +1084,10 @@ struct hfi1_devdata {
 	/* Save the enabled LCB error bits */
 	u64 lcb_err_en;
 	u8 dc_shutdown;
+
+	/* receive context tail dummy address */
+	volatile __le64 *rcvhdrtail_dummy_kvaddr;
+	dma_addr_t rcvhdrtail_dummy_physaddr;
 };
 
 /* 8051 firmware version helper */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 4a79744..36a3065 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -693,6 +693,18 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 	if (ret)
 		goto done;
 
+	/* allocate dummy tail memory for all receive contexts */
+	dd->rcvhdrtail_dummy_kvaddr = dma_zalloc_coherent(
+		&dd->pcidev->dev, sizeof(u64),
+		&dd->rcvhdrtail_dummy_physaddr,
+		GFP_KERNEL);
+
+	if (!dd->rcvhdrtail_dummy_kvaddr) {
+		dd_dev_err(dd, "cannot allocate dummy tail memory\n");
+		ret = -ENOMEM;
+		goto done;
+	}
+
 	/* dd->rcd can be NULL if early initialization failed */
 	for (i = 0; dd->rcd && i < dd->first_user_ctxt; ++i) {
 		/*
@@ -1268,6 +1280,14 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 	tmp = dd->rcd;
 	dd->rcd = NULL;
 	spin_unlock_irqrestore(&dd->uctxt_lock, flags);
+
+	if (dd->rcvhdrtail_dummy_kvaddr) {
+		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
+				  (void *)dd->rcvhdrtail_dummy_kvaddr,
+				  dd->rcvhdrtail_dummy_physaddr);
+				  dd->rcvhdrtail_dummy_kvaddr = NULL;
+	}
+
 	for (ctxt = 0; tmp && ctxt < dd->num_rcv_contexts; ctxt++) {
 		struct hfi1_ctxtdata *rcd = tmp[ctxt];
 
@@ -1523,6 +1543,14 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	reg = (dd->rcvhdrsize & RCV_HDR_SIZE_HDR_SIZE_MASK)
 		<< RCV_HDR_SIZE_HDR_SIZE_SHIFT;
 	write_kctxt_csr(dd, rcd->ctxt, RCV_HDR_SIZE, reg);
+
+	/*
+	 * Program dummy tail address for every receive context
+	 * before enabling any receive context
+	 */
+	write_kctxt_csr(dd, rcd->ctxt, RCV_HDR_TAIL_ADDR,
+			dd->rcvhdrtail_dummy_physaddr);
+
 	return 0;
 
 bail_free:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
