From: Jubin John <jubin.john@intel.com>
Subject: [PATCH v2 1/2] staging/rdma/hfi1: Workaround to prevent corruption
 during packet delivery
Date: Mon,  9 Nov 2015 19:18:20 -0500
Message-ID: <1447114701-11003-2-git-send-email-jubin.john@intel.com>
References: <1447114701-11003-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447114701-11003-1-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Mark F. Brown <mark.f.brown@intel.com>

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

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Mark F. Brown <mark.f.brown@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |   18 +++++++++++++++---
 drivers/staging/rdma/hfi1/hfi.h  |    4 ++++
 drivers/staging/rdma/hfi1/init.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e489819..3c3ba52 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -7753,6 +7753,17 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
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
@@ -7822,10 +7833,11 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
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
index 190f7a2..10b227c 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1084,6 +1084,10 @@ struct hfi1_devdata {
 	/* Save the enabled LCB error bits */
 	u64 lcb_err_en;
 	u8 dc_shutdown;
+
+	/* receive context tail dummy address */
+	__le64 *rcvhdrtail_dummy_kvaddr;
+	dma_addr_t rcvhdrtail_dummy_physaddr;
 };
 
 /* 8051 firmware version helper */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 8666f3a..3879d80 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -691,6 +691,18 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
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
@@ -1266,6 +1278,14 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
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
 
@@ -1521,6 +1541,14 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
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
