From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 06/17] staging/rdma/hfi1: Add one-time LCB reset
Date: Tue,  1 Dec 2015 15:38:15 -0500
Message-ID: <1449002306-15180-7-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add one-time LCB reset on driver load to pre-emptively work
around any LCB power cycle issues.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- Fixed driver name to hfi1 in subject line

 drivers/staging/rdma/hfi1/chip.c           |   20 ++++++++++++++++++++
 drivers/staging/rdma/hfi1/chip_registers.h |    3 +++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 6b6af40..8191065 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5888,6 +5888,23 @@ void init_qsfp(struct hfi1_pportdata *ppd)
 	}
 }
 
+/*
+ * Do a one-time initialize of the LCB block.
+ */
+static void init_lcb(struct hfi1_devdata *dd)
+{
+	/* the DC has been reset earlier in the driver load */
+
+	/* set LCB for cclk loopback on the port */
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 0x01);
+	write_csr(dd, DC_LCB_CFG_LANE_WIDTH, 0x00);
+	write_csr(dd, DC_LCB_CFG_REINIT_AS_SLAVE, 0x00);
+	write_csr(dd, DC_LCB_CFG_CNT_FOR_SKIP_STALL, 0x110);
+	write_csr(dd, DC_LCB_CFG_CLK_CNTR, 0x08);
+	write_csr(dd, DC_LCB_CFG_LOOPBACK, 0x02);
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 0x00);
+}
+
 int bringup_serdes(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
@@ -5909,6 +5926,9 @@ int bringup_serdes(struct hfi1_pportdata *ppd)
 	/* Set linkinit_reason on power up per OPA spec */
 	ppd->linkinit_reason = OPA_LINKINIT_REASON_LINKUP;
 
+	/* one-time init of the LCB */
+	init_lcb(dd);
+
 	if (loopback) {
 		ret = init_loopback(dd);
 		if (ret < 0)
diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index bf45de2..21ca8c1 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -318,6 +318,9 @@
 #define DC_LCB_CFG_TX_FIFOS_RADR_RST_VAL_SHIFT 0
 #define DC_LCB_CFG_TX_FIFOS_RESET (DC_LCB_CSRS + 0x000000000008)
 #define DC_LCB_CFG_TX_FIFOS_RESET_VAL_SHIFT 0
+#define DC_LCB_CFG_REINIT_AS_SLAVE (DC_LCB_CSRS + 0x000000000030)
+#define DC_LCB_CFG_CNT_FOR_SKIP_STALL (DC_LCB_CSRS + 0x000000000040)
+#define DC_LCB_CFG_CLK_CNTR (DC_LCB_CSRS + 0x000000000110)
 #define DC_LCB_ERR_CLR (DC_LCB_CSRS + 0x000000000308)
 #define DC_LCB_ERR_EN (DC_LCB_CSRS + 0x000000000310)
 #define DC_LCB_ERR_FLG (DC_LCB_CSRS + 0x000000000300)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
