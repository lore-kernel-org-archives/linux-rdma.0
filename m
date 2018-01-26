From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 01/16] IB/hfi1: Do not override given pcie_pset
 value
Date: Fri, 26 Jan 2018 06:31:27 -0800
Message-ID: <20180126143123.6868.86785.stgit@scvm10.sc.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126142640.6868.12402.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

During PCIe Gen 3 transistion, pcie_pset is read and might be overridden
to a default value(i.e. 255) in do_pcie_gen3_transition() routine.

If the pcie_pset value is overridden then this new value will be used
during initialization of next adapter on a different card.

Introducing a new local variable to avoid modification of pcie_pset

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pcie.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 8c7e7a6..83d66e8 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -1034,6 +1034,7 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	int do_retry, retry_count = 0;
 	int intnum = 0;
 	uint default_pset;
+	uint pset = pcie_pset;
 	u16 target_vector, target_speed;
 	u16 lnkctl2, vendor;
 	u8 div;
@@ -1201,16 +1202,16 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	 *
 	 * Set Gen3EqPsetReqVec, leave other fields 0.
 	 */
-	if (pcie_pset == UNSET_PSET)
-		pcie_pset = default_pset;
-	if (pcie_pset > 10) {	/* valid range is 0-10, inclusive */
+	if (pset == UNSET_PSET)
+		pset = default_pset;
+	if (pset > 10) {	/* valid range is 0-10, inclusive */
 		dd_dev_err(dd, "%s: Invalid Eq Pset %u, setting to %d\n",
-			   __func__, pcie_pset, default_pset);
-		pcie_pset = default_pset;
+			   __func__, pset, default_pset);
+		pset = default_pset;
 	}
-	dd_dev_info(dd, "%s: using EQ Pset %u\n", __func__, pcie_pset);
+	dd_dev_info(dd, "%s: using EQ Pset %u\n", __func__, pset);
 	pci_write_config_dword(dd->pcidev, PCIE_CFG_REG_PL106,
-			       ((1 << pcie_pset) <<
+			       ((1 << pset) <<
 			PCIE_CFG_REG_PL106_GEN3_EQ_PSET_REQ_VEC_SHIFT) |
 			PCIE_CFG_REG_PL106_GEN3_EQ_EVAL2MS_DISABLE_SMASK |
 			PCIE_CFG_REG_PL106_GEN3_EQ_PHASE23_EXIT_MODE_SMASK);
@@ -1240,10 +1241,10 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 		/* apply static CTLE tunings */
 		u8 pcie_dc, pcie_lf, pcie_hf, pcie_bw;
 
-		pcie_dc = ctle_tunings[pcie_pset][0];
-		pcie_lf = ctle_tunings[pcie_pset][1];
-		pcie_hf = ctle_tunings[pcie_pset][2];
-		pcie_bw = ctle_tunings[pcie_pset][3];
+		pcie_dc = ctle_tunings[pset][0];
+		pcie_lf = ctle_tunings[pset][1];
+		pcie_hf = ctle_tunings[pset][2];
+		pcie_bw = ctle_tunings[pset][3];
 		write_gasket_interrupt(dd, intnum++, 0x0026, 0x0200 | pcie_dc);
 		write_gasket_interrupt(dd, intnum++, 0x0026, 0x0100 | pcie_lf);
 		write_gasket_interrupt(dd, intnum++, 0x0026, 0x0000 | pcie_hf);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
