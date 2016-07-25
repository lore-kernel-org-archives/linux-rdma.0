From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 21/28] IB/hfi1: Ignore QSFP interrupts until power stabilizes
Date: Mon, 25 Jul 2016 13:39:57 -0700
Message-ID: <20160725203956.4800.1166.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some QSFP cables assert the interrupt line as a side effect of module
plug-in and power up. This causes the SerDes and QSFP tuning algorithm
to begin cable initialization by reading the QSFP memory map over I2C,
which fails. This patch ignores any interrupt line assertion until
the module has completed power up and voltage rails have stabilized,
which can take a maximum of 500 ms per the SFF-8679 specification.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index faeed29..becc7b1 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9191,17 +9191,24 @@ static void wait_for_qsfp_init(struct hfi1_pportdata *ppd)
 	unsigned long timeout;
 
 	/*
-	 * Check for QSFP interrupt for t_init (SFF 8679)
+	 * Some QSFP cables have a quirk that asserts the IntN line as a side
+	 * effect of power up on plug-in. We ignore this false positive
+	 * interrupt until the module has finished powering up by waiting for
+	 * a minimum timeout of the module inrush initialization time of
+	 * 500 ms (SFF 8679 Table 5-6) to ensure the voltage rails in the
+	 * module have stabilized.
+	 */
+	msleep(500);
+
+	/*
+	 * Check for QSFP interrupt for t_init (SFF 8679 Table 8-1)
 	 */
 	timeout = jiffies + msecs_to_jiffies(2000);
 	while (1) {
 		mask = read_csr(dd, dd->hfi1_id ?
 				ASIC_QSFP2_IN : ASIC_QSFP1_IN);
-		if (!(mask & QSFP_HFI0_INT_N)) {
-			write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_CLEAR :
-				  ASIC_QSFP1_CLEAR, QSFP_HFI0_INT_N);
+		if (!(mask & QSFP_HFI0_INT_N))
 			break;
-		}
 		if (time_after(jiffies, timeout)) {
 			dd_dev_info(dd, "%s: No IntN detected, reset complete\n",
 				    __func__);
@@ -9217,10 +9224,17 @@ static void set_qsfp_int_n(struct hfi1_pportdata *ppd, u8 enable)
 	u64 mask;
 
 	mask = read_csr(dd, dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK);
-	if (enable)
+	if (enable) {
+		/*
+		 * Clear the status register to avoid an immediate interrupt
+		 * when we re-enable the IntN pin
+		 */
+		write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_CLEAR : ASIC_QSFP1_CLEAR,
+			  QSFP_HFI0_INT_N);
 		mask |= (u64)QSFP_HFI0_INT_N;
-	else
+	} else {
 		mask &= ~(u64)QSFP_HFI0_INT_N;
+	}
 	write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK, mask);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
