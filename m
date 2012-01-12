From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Wed, 11 Jan 2012 22:00:49 -0500
Message-ID: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 8d4548f2b ("IB/qib: Default some module parameters optimally")
introduced an issue with older root complexes.  They cannot handle
the pcie_caps of 0x51.

A typical diagnostic in this situation reported by syslog contains
the text:

  [PCIe Poisoned TLP][Send DMA memory read]

Insure the 0x51 is not used on the suspect chip sets.

Reviewed-by: Mark Debbage <mark.debbage-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_pcie.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 0de55c0..bb23ba0 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -577,7 +577,7 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
  * BIOS may not set PCIe bus-utilization parameters for best performance.
  * Check and optionally adjust them to maximize our throughput.
  */
-static int qib_pcie_caps = 0x51;
+static int qib_pcie_caps;
 module_param_named(pcie_caps, qib_pcie_caps, int, S_IRUGO);
 MODULE_PARM_DESC(pcie_caps, "Max PCIe tuning: Payload (0..3), ReadReq (4..7)");
 
@@ -589,6 +589,7 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	u16 pcaps, pctl, ecaps, ectl;
 	int rc_sup, ep_sup;
 	int rc_cur, ep_cur;
+	int caps = 0x51; /* may be overridden below */
 
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
@@ -609,6 +610,14 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 		pci_read_config_word(dd->pcidev, epos + PCI_EXP_DEVCTL, &ectl);
 	} else
 		goto bail;
+	if (!qib_pcie_caps) {
+		u16 devid = parent->device;
+		if ((devid >= 0x25e2 && devid <= 0x25fa) ||
+		    (devid >= 0x65e2 && devid <= 0x65fa) ||
+		    (devid >= 0x4021 && devid <= 0x402e))
+			caps = 0;
+	} else
+		caps = qib_pcie_caps;
 	ret = 0;
 	/* Find max payload supported by root, endpoint */
 	rc_sup = fld2val(pcaps, PCI_EXP_DEVCAP_PAYLOAD);
@@ -620,8 +629,8 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	ep_cur = fld2val(ectl, PCI_EXP_DEVCTL_PAYLOAD);
 
 	/* If Supported greater than limit in module param, limit it */
-	if (rc_sup > (qib_pcie_caps & 7))
-		rc_sup = qib_pcie_caps & 7;
+	if (rc_sup > (caps & 7))
+		rc_sup = caps & 7;
 	/* If less than (allowed, supported), bump root payload */
 	if (rc_sup > rc_cur) {
 		rc_cur = rc_sup;
@@ -643,8 +652,8 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	 * which is code '5' (log2(4096) - 7)
 	 */
 	rc_sup = 5;
-	if (rc_sup > ((qib_pcie_caps >> 4) & 7))
-		rc_sup = (qib_pcie_caps >> 4) & 7;
+	if (rc_sup > ((caps >> 4) & 7))
+		rc_sup = (caps >> 4) & 7;
 	rc_cur = fld2val(pctl, PCI_EXP_DEVCTL_READRQ);
 	ep_cur = fld2val(ectl, PCI_EXP_DEVCTL_READRQ);
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
