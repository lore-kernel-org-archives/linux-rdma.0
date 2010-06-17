From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/7] IB/qib: mask hardware error during link reset
Date: Thu, 17 Jun 2010 16:13:54 -0700
Message-ID: <20100617231354.8006.45083.stgit@chromite.mv.qlogic.com>
References: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617231338.8006.18131.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The HCA checks for certain hardware errors which can be falsely
triggered when the IB link is reset. The fix is to mask them rather
than report them.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_7322_regs.h |   48 +++++++++++++++--------------
 drivers/infiniband/hw/qib/qib_iba7322.c   |    9 ++++-
 2 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_7322_regs.h b/drivers/infiniband/hw/qib/qib_7322_regs.h
index a97440b..32dc81f 100644
--- a/drivers/infiniband/hw/qib/qib_7322_regs.h
+++ b/drivers/infiniband/hw/qib/qib_7322_regs.h
@@ -742,15 +742,15 @@
 #define QIB_7322_HwErrMask_IBCBusFromSPCParityErrMask_1_LSB 0xF
 #define QIB_7322_HwErrMask_IBCBusFromSPCParityErrMask_1_MSB 0xF
 #define QIB_7322_HwErrMask_IBCBusFromSPCParityErrMask_1_RMASK 0x1
-#define QIB_7322_HwErrMask_statusValidNoEopMask_1_LSB 0xE
-#define QIB_7322_HwErrMask_statusValidNoEopMask_1_MSB 0xE
-#define QIB_7322_HwErrMask_statusValidNoEopMask_1_RMASK 0x1
+#define QIB_7322_HwErrMask_IBCBusToSPCParityErrMask_1_LSB 0xE
+#define QIB_7322_HwErrMask_IBCBusToSPCParityErrMask_1_MSB 0xE
+#define QIB_7322_HwErrMask_IBCBusToSPCParityErrMask_1_RMASK 0x1
 #define QIB_7322_HwErrMask_IBCBusFromSPCParityErrMask_0_LSB 0xD
 #define QIB_7322_HwErrMask_IBCBusFromSPCParityErrMask_0_MSB 0xD
 #define QIB_7322_HwErrMask_IBCBusFromSPCParityErrMask_0_RMASK 0x1
-#define QIB_7322_HwErrMask_statusValidNoEopMask_0_LSB 0xC
-#define QIB_7322_HwErrMask_statusValidNoEopMask_0_MSB 0xC
-#define QIB_7322_HwErrMask_statusValidNoEopMask_0_RMASK 0x1
+#define QIB_7322_HwErrMask_statusValidNoEopMask_LSB 0xC
+#define QIB_7322_HwErrMask_statusValidNoEopMask_MSB 0xC
+#define QIB_7322_HwErrMask_statusValidNoEopMask_RMASK 0x1
 #define QIB_7322_HwErrMask_LATriggeredMask_LSB 0xB
 #define QIB_7322_HwErrMask_LATriggeredMask_MSB 0xB
 #define QIB_7322_HwErrMask_LATriggeredMask_RMASK 0x1
@@ -796,15 +796,15 @@
 #define QIB_7322_HwErrStatus_IBCBusFromSPCParityErr_1_LSB 0xF
 #define QIB_7322_HwErrStatus_IBCBusFromSPCParityErr_1_MSB 0xF
 #define QIB_7322_HwErrStatus_IBCBusFromSPCParityErr_1_RMASK 0x1
-#define QIB_7322_HwErrStatus_statusValidNoEop_1_LSB 0xE
-#define QIB_7322_HwErrStatus_statusValidNoEop_1_MSB 0xE
-#define QIB_7322_HwErrStatus_statusValidNoEop_1_RMASK 0x1
+#define QIB_7322_HwErrStatus_IBCBusToSPCParityErr_1_LSB 0xE
+#define QIB_7322_HwErrStatus_IBCBusToSPCParityErr_1_MSB 0xE
+#define QIB_7322_HwErrStatus_IBCBusToSPCParityErr_1_RMASK 0x1
 #define QIB_7322_HwErrStatus_IBCBusFromSPCParityErr_0_LSB 0xD
 #define QIB_7322_HwErrStatus_IBCBusFromSPCParityErr_0_MSB 0xD
 #define QIB_7322_HwErrStatus_IBCBusFromSPCParityErr_0_RMASK 0x1
-#define QIB_7322_HwErrStatus_statusValidNoEop_0_LSB 0xC
-#define QIB_7322_HwErrStatus_statusValidNoEop_0_MSB 0xC
-#define QIB_7322_HwErrStatus_statusValidNoEop_0_RMASK 0x1
+#define QIB_7322_HwErrStatus_statusValidNoEop_LSB 0xC
+#define QIB_7322_HwErrStatus_statusValidNoEop_MSB 0xC
+#define QIB_7322_HwErrStatus_statusValidNoEop_RMASK 0x1
 #define QIB_7322_HwErrStatus_LATriggered_LSB 0xB
 #define QIB_7322_HwErrStatus_LATriggered_MSB 0xB
 #define QIB_7322_HwErrStatus_LATriggered_RMASK 0x1
@@ -850,15 +850,15 @@
 #define QIB_7322_HwErrClear_IBCBusFromSPCParityErrClear_1_LSB 0xF
 #define QIB_7322_HwErrClear_IBCBusFromSPCParityErrClear_1_MSB 0xF
 #define QIB_7322_HwErrClear_IBCBusFromSPCParityErrClear_1_RMASK 0x1
-#define QIB_7322_HwErrClear_IBCBusToSPCparityErrClear_1_LSB 0xE
-#define QIB_7322_HwErrClear_IBCBusToSPCparityErrClear_1_MSB 0xE
-#define QIB_7322_HwErrClear_IBCBusToSPCparityErrClear_1_RMASK 0x1
+#define QIB_7322_HwErrClear_IBCBusToSPCParityErrClear_1_LSB 0xE
+#define QIB_7322_HwErrClear_IBCBusToSPCParityErrClear_1_MSB 0xE
+#define QIB_7322_HwErrClear_IBCBusToSPCParityErrClear_1_RMASK 0x1
 #define QIB_7322_HwErrClear_IBCBusFromSPCParityErrClear_0_LSB 0xD
 #define QIB_7322_HwErrClear_IBCBusFromSPCParityErrClear_0_MSB 0xD
 #define QIB_7322_HwErrClear_IBCBusFromSPCParityErrClear_0_RMASK 0x1
-#define QIB_7322_HwErrClear_IBCBusToSPCparityErrClear_0_LSB 0xC
-#define QIB_7322_HwErrClear_IBCBusToSPCparityErrClear_0_MSB 0xC
-#define QIB_7322_HwErrClear_IBCBusToSPCparityErrClear_0_RMASK 0x1
+#define QIB_7322_HwErrClear_statusValidNoEopClear_LSB 0xC
+#define QIB_7322_HwErrClear_statusValidNoEopClear_MSB 0xC
+#define QIB_7322_HwErrClear_statusValidNoEopClear_RMASK 0x1
 #define QIB_7322_HwErrClear_LATriggeredClear_LSB 0xB
 #define QIB_7322_HwErrClear_LATriggeredClear_MSB 0xB
 #define QIB_7322_HwErrClear_LATriggeredClear_RMASK 0x1
@@ -880,15 +880,15 @@
 #define QIB_7322_HwDiagCtrl_ForceIBCBusFromSPCParityErr_1_LSB 0xF
 #define QIB_7322_HwDiagCtrl_ForceIBCBusFromSPCParityErr_1_MSB 0xF
 #define QIB_7322_HwDiagCtrl_ForceIBCBusFromSPCParityErr_1_RMASK 0x1
-#define QIB_7322_HwDiagCtrl_ForcestatusValidNoEop_1_LSB 0xE
-#define QIB_7322_HwDiagCtrl_ForcestatusValidNoEop_1_MSB 0xE
-#define QIB_7322_HwDiagCtrl_ForcestatusValidNoEop_1_RMASK 0x1
+#define QIB_7322_HwDiagCtrl_ForceIBCBusToSPCParityErr_1_LSB 0xE
+#define QIB_7322_HwDiagCtrl_ForceIBCBusToSPCParityErr_1_MSB 0xE
+#define QIB_7322_HwDiagCtrl_ForceIBCBusToSPCParityErr_1_RMASK 0x1
 #define QIB_7322_HwDiagCtrl_ForceIBCBusFromSPCParityErr_0_LSB 0xD
 #define QIB_7322_HwDiagCtrl_ForceIBCBusFromSPCParityErr_0_MSB 0xD
 #define QIB_7322_HwDiagCtrl_ForceIBCBusFromSPCParityErr_0_RMASK 0x1
-#define QIB_7322_HwDiagCtrl_ForcestatusValidNoEop_0_LSB 0xC
-#define QIB_7322_HwDiagCtrl_ForcestatusValidNoEop_0_MSB 0xC
-#define QIB_7322_HwDiagCtrl_ForcestatusValidNoEop_0_RMASK 0x1
+#define QIB_7322_HwDiagCtrl_ForceIBCBusToSPCParityErr_0_LSB 0xC
+#define QIB_7322_HwDiagCtrl_ForceIBCBusToSPCParityErr_0_MSB 0xC
+#define QIB_7322_HwDiagCtrl_ForceIBCBusToSPCParityErr_0_RMASK 0x1
 
 #define QIB_7322_EXTStatus_OFFS 0xC0
 #define QIB_7322_EXTStatus_DEF 0x000000000000X000
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 3e9828b..8ee0ac6 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1100,9 +1100,9 @@ static const struct qib_hwerror_msgs qib_7322_hwerror_msgs[] = {
 	HWE_AUTO_P(SDmaMemReadErr, 1),
 	HWE_AUTO_P(SDmaMemReadErr, 0),
 	HWE_AUTO_P(IBCBusFromSPCParityErr, 1),
+	HWE_AUTO_P(IBCBusToSPCParityErr, 1),
 	HWE_AUTO_P(IBCBusFromSPCParityErr, 0),
-	HWE_AUTO_P(statusValidNoEop, 1),
-	HWE_AUTO_P(statusValidNoEop, 0),
+	HWE_AUTO(statusValidNoEop),
 	HWE_AUTO(LATriggered),
 	{ .mask = 0 }
 };
@@ -4763,6 +4763,8 @@ static void qib_7322_mini_pcs_reset(struct qib_pportdata *ppd)
 		SYM_MASK(IBPCSConfig_0, tx_rx_reset);
 
 	val = qib_read_kreg_port(ppd, krp_ib_pcsconfig);
+	qib_write_kreg(dd, kr_hwerrmask,
+		       dd->cspec->hwerrmask & ~HWE_MASK(statusValidNoEop));
 	qib_write_kreg_port(ppd, krp_ibcctrl_a,
 			    ppd->cpspec->ibcctrl_a &
 			    ~SYM_MASK(IBCCtrlA_0, IBLinkEn));
@@ -4772,6 +4774,9 @@ static void qib_7322_mini_pcs_reset(struct qib_pportdata *ppd)
 	qib_write_kreg_port(ppd, krp_ib_pcsconfig, val & ~reset_bits);
 	qib_write_kreg_port(ppd, krp_ibcctrl_a, ppd->cpspec->ibcctrl_a);
 	qib_write_kreg(dd, kr_scratch, 0ULL);
+	qib_write_kreg(dd, kr_hwerrclear,
+		       SYM_MASK(HwErrClear, statusValidNoEopClear));
+	qib_write_kreg(dd, kr_hwerrmask, dd->cspec->hwerrmask);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
