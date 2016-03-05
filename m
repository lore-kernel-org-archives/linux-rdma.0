From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/17] IB/hfi1: Remove ASIC block clear
Date: Sat, 05 Mar 2016 08:49:39 -0800
Message-ID: <20160305164939.32025.13636.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ASIC block is shared between two HFIs. Individual devices
should not initialize registers there. Retain the power-on values.
Individual users set registers as needed with one exception.
Clear sbus fast mode on "slow" calls.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |   88 ---------------------------------
 drivers/infiniband/hw/hfi1/firmware.c |    3 +
 2 files changed, 3 insertions(+), 88 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 263c882..0874287 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -12934,91 +12934,6 @@ static void reset_cce_csrs(struct hfi1_devdata *dd)
 		write_csr(dd, CCE_INT_COUNTER_ARRAY32 + (8 * i), 0);
 }
 
-/* set ASIC CSRs to chip reset defaults */
-static void reset_asic_csrs(struct hfi1_devdata *dd)
-{
-	int i;
-
-	/*
-	 * If the HFIs are shared between separate nodes or VMs,
-	 * then more will need to be done here.  One idea is a module
-	 * parameter that returns early, letting the first power-on or
-	 * a known first load do the reset and blocking all others.
-	 */
-
-	if (!(dd->flags & HFI1_DO_INIT_ASIC))
-		return;
-
-	if (dd->icode != ICODE_FPGA_EMULATION) {
-		/* emulation does not have an SBus - leave these alone */
-		/*
-		 * All writes to ASIC_CFG_SBUS_REQUEST do something.
-		 * Notes:
-		 * o The reset is not zero if aimed at the core.  See the
-		 *   SBus documentation for details.
-		 * o If the SBus firmware has been updated (e.g. by the BIOS),
-		 *   will the reset revert that?
-		 */
-		/* ASIC_CFG_SBUS_REQUEST leave alone */
-		write_csr(dd, ASIC_CFG_SBUS_EXECUTE, 0);
-	}
-	/* ASIC_SBUS_RESULT read-only */
-	write_csr(dd, ASIC_STS_SBUS_COUNTERS, 0);
-	for (i = 0; i < ASIC_NUM_SCRATCH; i++)
-		write_csr(dd, ASIC_CFG_SCRATCH + (8 * i), 0);
-	write_csr(dd, ASIC_CFG_MUTEX, 0);	/* this will clear it */
-
-	/* We might want to retain this state across FLR if we ever use it */
-	write_csr(dd, ASIC_CFG_DRV_STR, 0);
-
-	/* ASIC_CFG_THERM_POLL_EN leave alone */
-	/* ASIC_STS_THERM read-only */
-	/* ASIC_CFG_RESET leave alone */
-
-	write_csr(dd, ASIC_PCIE_SD_HOST_CMD, 0);
-	/* ASIC_PCIE_SD_HOST_STATUS read-only */
-	write_csr(dd, ASIC_PCIE_SD_INTRPT_DATA_CODE, 0);
-	write_csr(dd, ASIC_PCIE_SD_INTRPT_ENABLE, 0);
-	/* ASIC_PCIE_SD_INTRPT_PROGRESS read-only */
-	write_csr(dd, ASIC_PCIE_SD_INTRPT_STATUS, ~0ull); /* clear */
-	/* ASIC_HFI0_PCIE_SD_INTRPT_RSPD_DATA read-only */
-	/* ASIC_HFI1_PCIE_SD_INTRPT_RSPD_DATA read-only */
-	for (i = 0; i < 16; i++)
-		write_csr(dd, ASIC_PCIE_SD_INTRPT_LIST + (8 * i), 0);
-
-	/* ASIC_GPIO_IN read-only */
-	write_csr(dd, ASIC_GPIO_OE, 0);
-	write_csr(dd, ASIC_GPIO_INVERT, 0);
-	write_csr(dd, ASIC_GPIO_OUT, 0);
-	write_csr(dd, ASIC_GPIO_MASK, 0);
-	/* ASIC_GPIO_STATUS read-only */
-	write_csr(dd, ASIC_GPIO_CLEAR, ~0ull);
-	/* ASIC_GPIO_FORCE leave alone */
-
-	/* ASIC_QSFP1_IN read-only */
-	write_csr(dd, ASIC_QSFP1_OE, 0);
-	write_csr(dd, ASIC_QSFP1_INVERT, 0);
-	write_csr(dd, ASIC_QSFP1_OUT, 0);
-	write_csr(dd, ASIC_QSFP1_MASK, 0);
-	/* ASIC_QSFP1_STATUS read-only */
-	write_csr(dd, ASIC_QSFP1_CLEAR, ~0ull);
-	/* ASIC_QSFP1_FORCE leave alone */
-
-	/* ASIC_QSFP2_IN read-only */
-	write_csr(dd, ASIC_QSFP2_OE, 0);
-	write_csr(dd, ASIC_QSFP2_INVERT, 0);
-	write_csr(dd, ASIC_QSFP2_OUT, 0);
-	write_csr(dd, ASIC_QSFP2_MASK, 0);
-	/* ASIC_QSFP2_STATUS read-only */
-	write_csr(dd, ASIC_QSFP2_CLEAR, ~0ull);
-	/* ASIC_QSFP2_FORCE leave alone */
-
-	write_csr(dd, ASIC_EEP_CTL_STAT, ASIC_EEP_CTL_STAT_RESETCSR);
-	/* this also writes a NOP command, clearing paging mode */
-	write_csr(dd, ASIC_EEP_ADDR_CMD, 0);
-	write_csr(dd, ASIC_EEP_DATA, 0);
-}
-
 /* set MISC CSRs to chip reset defaults */
 static void reset_misc_csrs(struct hfi1_devdata *dd)
 {
@@ -13428,14 +13343,11 @@ static void init_chip(struct hfi1_devdata *dd)
 			hfi1_pcie_flr(dd);
 			restore_pci_variables(dd);
 		}
-
-		reset_asic_csrs(dd);
 	} else {
 		dd_dev_info(dd, "Resetting CSRs with writes\n");
 		reset_cce_csrs(dd);
 		reset_txe_csrs(dd);
 		reset_rxe_csrs(dd);
-		reset_asic_csrs(dd);
 		reset_misc_csrs(dd);
 	}
 	/* clear the DC reset */
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index d5befd1..ca4e489 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1170,6 +1170,9 @@ int sbus_request_slow(struct hfi1_devdata *dd,
 {
 	u64 reg, count = 0;
 
+	/* make sure fast mode is clear */
+	clear_sbus_fast_mode(dd);
+
 	sbus_request(dd, receiver_addr, data_addr, command, data_in);
 	write_csr(dd, ASIC_CFG_SBUS_EXECUTE,
 		  ASIC_CFG_SBUS_EXECUTE_EXECUTE_SMASK);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
