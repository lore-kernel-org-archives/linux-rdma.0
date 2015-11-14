From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 06/18] staging/rdma/hfi: Add one-time LCB reset
Date: Fri, 13 Nov 2015 19:37:04 -0800
Message-ID: <1447472236-622-6-git-send-email-jubin.john@intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447472236-622-1-git-send-email-jubin.john@intel.com>
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

From: Dean Luick <dean.luick@intel.com>

Add one-time LCB reset on driver load to pre-emptively work
around any LCB power cycle issues.

Reviewed-by: Easwar Hariharan <easwar.hariharan@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c           |   20 ++++++++++++++++++++
 drivers/staging/rdma/hfi1/chip_registers.h |    3 +++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index a5b3653..be89e37 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5856,6 +5856,23 @@ void init_qsfp(struct hfi1_pportdata *ppd)
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
@@ -5877,6 +5894,9 @@ int bringup_serdes(struct hfi1_pportdata *ppd)
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
1.7.0.7
