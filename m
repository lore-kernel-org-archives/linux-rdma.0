From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2] staging/rdma/hfi1: set Gen3 half-swing for integrated devices
Date: Mon,  9 Nov 2015 18:38:08 -0500
Message-ID: <1447112288-28327-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Correctly set half-swing for integrated devices.  A0 needs all fields set for
CcePcieCtrl.  B0 and later only need a few fields set.

Reviewed-by: Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Add comments concerning the very long names.

 drivers/staging/rdma/hfi1/chip_registers.h | 16 +++++++
 drivers/staging/rdma/hfi1/pcie.c           | 77 ++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index bf45de29d8bd..e4c1953203dd 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -51,6 +51,11 @@
  *
  */
 
+/*
+ * NOTE: The names in this file are very long but they are meant to track the
+ * hardware specification names.
+ */
+
 #define CORE		0x000000000000
 #define CCE			(CORE + 0x000000000000)
 #define ASIC		(CORE + 0x000000400000)
@@ -549,6 +554,17 @@
 #define CCE_MSIX_TABLE_UPPER (CCE + 0x000000100008)
 #define CCE_MSIX_TABLE_UPPER_RESETCSR 0x0000000100000000ull
 #define CCE_MSIX_VEC_CLR_WITHOUT_INT (CCE + 0x000000110400)
+#define CCE_PCIE_CTRL (CCE + 0x0000000000C0)
+#define CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_MASK 0x3ull
+#define CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_SHIFT 0
+#define CCE_PCIE_CTRL_PCIE_LANE_DELAY_MASK 0xFull
+#define CCE_PCIE_CTRL_PCIE_LANE_DELAY_SHIFT 2
+#define CCE_PCIE_CTRL_XMT_MARGIN_OVERWRITE_ENABLE_SHIFT 8
+#define CCE_PCIE_CTRL_XMT_MARGIN_SHIFT 9
+#define CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK 0x1ull
+#define CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_SHIFT 12
+#define CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_MASK 0x7ull
+#define CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_SHIFT 13
 #define CCE_REVISION (CCE + 0x000000000000)
 #define CCE_REVISION2 (CCE + 0x000000000008)
 #define CCE_REVISION2_HFI_ID_MASK 0x1ull
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index a956044459a2..fe17332e9239 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -865,6 +865,78 @@ static void arm_gasket_logic(struct hfi1_devdata *dd)
 }
 
 /*
+ * CcePcieCtrl long name helper
+ * Due to checkpatch checks we use this macro to shorten field macros names
+ */
+#define PC(field) (CCE_PCIE_CTRL_##field)
+
+ /*
+  * Write xmt_margin for full-swing (WFR-B) or half-swing (WFR-C).
+  */
+static void write_xmt_margin(struct hfi1_devdata *dd, const char *fname)
+{
+	u64 pcie_ctrl;
+	u64 xmt_margin;
+	u64 xmt_margin_oe;
+	u64 lane_delay;
+	u64 lane_bundle;
+
+	pcie_ctrl = read_csr(dd, CCE_PCIE_CTRL);
+
+	/*
+	 * For Discrete, use full-swing.
+	 *  - PCIe TX defaults to full-swing.
+	 *    Leave this register as default.
+	 * For Integrated, use half-swing
+	 *  - Copy xmt_margin and xmt_margin_oe
+	 *    from Gen1/Gen2 to Gen3.
+	 */
+	if (dd->pcidev->device == PCI_DEVICE_ID_INTEL1) { /* integrated */
+		/* extract initial fields */
+		xmt_margin = (pcie_ctrl >> PC(XMT_MARGIN_GEN1_GEN2_SHIFT))
+			    & PC(XMT_MARGIN_GEN1_GEN2_MASK);
+		xmt_margin_oe =
+			(pcie_ctrl
+			  >> PC(XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_SHIFT))
+			& PC(XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK);
+		lane_delay = (pcie_ctrl >> PC(PCIE_LANE_DELAY_SHIFT))
+			    & PC(PCIE_LANE_DELAY_MASK);
+		lane_bundle = (pcie_ctrl >> PC(PCIE_LANE_BUNDLE_SHIFT))
+			    & PC(PCIE_LANE_BUNDLE_MASK);
+
+		/*
+		 * For A0, EFUSE values are not set.  Override with the
+		 * correct values.
+		 */
+		if (is_a0(dd)) {
+			/*
+			 * xmt_margin and OverwiteEnabel should be the
+			 * same for Gen1/Gen2 and Gen3
+			 */
+			xmt_margin                = 0x5;
+			xmt_margin_oe = 0x1;
+			lane_delay                = 0xF; /* Delay 240ns. */
+			lane_bundle               = 0x0; /* Set to 1 lane. */
+		}
+
+		/* overwrite existing values */
+		pcie_ctrl = (xmt_margin << PC(XMT_MARGIN_GEN1_GEN2_SHIFT))
+			| (xmt_margin_oe <<
+				PC(XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_SHIFT))
+			| (xmt_margin << PC(XMT_MARGIN_SHIFT))
+			| (xmt_margin_oe <<
+				PC(XMT_MARGIN_OVERWRITE_ENABLE_SHIFT))
+			| (lane_delay << PC(PCIE_LANE_DELAY_SHIFT))
+			| (lane_bundle << PC(PCIE_LANE_BUNDLE_SHIFT));
+
+		write_csr(dd, CCE_PCIE_CTRL, pcie_ctrl);
+	}
+
+	dd_dev_info(dd, "%s: program XMT margin, CcePcieCtrl 0x%llx\n",
+		    fname, pcie_ctrl);
+}
+
+/*
  * Do all the steps needed to transition the PCIe link to Gen3 speed.
  */
 int do_pcie_gen3_transition(struct hfi1_devdata *dd)
@@ -1072,11 +1144,8 @@ retry:
 
 	/*
 	 * step 5d: program XMT margin
-	 * Right now, leave the default alone.  To change, do a
-	 * read-modify-write of:
-	 *	CcePcieCtrl.XmtMargin
-	 *	CcePcieCtrl.XmitMarginOverwriteEnable
 	 */
+	write_xmt_margin(dd, __func__);
 
 	/* step 5e: disable active state power management (ASPM) */
 	dd_dev_info(dd, "%s: clearing ASPM\n", __func__);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
