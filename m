From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 2/5] RDMA/qedr: properly check atomic capabilities
Date: Thu, 27 Apr 2017 13:35:32 +0300
Message-ID: <1493289335-29350-3-git-send-email-Ram.Amrani@cavium.com>
References: <1493289335-29350-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493289335-29350-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After checking the path upwards towards root complex, actualy check
root complex atomic_req capability, and not our own NIC.
Verify that the PCIe device control register's atomic egress block
is cleared in the path.
Verify that the PCIe version is at least 2.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c | 77 +++++++++++++++++++++++----------------
 include/uapi/linux/pci_regs.h     |  1 +
 2 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index b9b47e5..e3498e9 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -340,43 +340,58 @@ static void qedr_remove_sysfiles(struct qedr_dev *dev)
 static void qedr_pci_set_atomic(struct qedr_dev *dev, struct pci_dev *pdev)
 {
 	struct pci_dev *bridge;
-	u32 val;
-
-	dev->atomic_cap = IB_ATOMIC_NONE;
+	u32 ctl2, cap2;
+	u16 flags;
+	int rc;
 
 	bridge = pdev->bus->self;
 	if (!bridge)
-		return;
-
-	/* Check whether we are connected directly or via a switch */
-	while (bridge && bridge->bus->parent) {
-		DP_DEBUG(dev, QEDR_MSG_INIT,
-			 "Device is not connected directly to root. bridge->bus->number=%d primary=%d\n",
-			 bridge->bus->number, bridge->bus->primary);
-		/* Need to check Atomic Op Routing Supported all the way to
-		 * root complex.
-		 */
-		pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &val);
-		if (!(val & PCI_EXP_DEVCAP2_ATOMIC_ROUTE)) {
-			pcie_capability_clear_word(pdev,
-						   PCI_EXP_DEVCTL2,
-						   PCI_EXP_DEVCTL2_ATOMIC_REQ);
-			return;
-		}
+		goto disable;
+
+	/* Check atomic routing support all the way to root complex */
+	while (bridge->bus->parent) {
+		rc = pcie_capability_read_word(bridge, PCI_EXP_FLAGS, &flags);
+		if (rc || ((flags & PCI_EXP_FLAGS_VERS) < 2))
+			goto disable;
+
+		rc = pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &cap2);
+		if (rc)
+			goto disable;
+
+		rc = pcie_capability_read_dword(bridge, PCI_EXP_DEVCTL2, &ctl2);
+		if (rc)
+			goto disable;
+
+		if (!(cap2 & PCI_EXP_DEVCAP2_ATOMIC_ROUTE) ||
+		    (ctl2 & PCI_EXP_DEVCTL2_ATOMIC_EGRESS_BLOCK))
+			goto disable;
 		bridge = bridge->bus->parent->self;
 	}
-	bridge = pdev->bus->self;
 
-	/* according to bridge capability */
-	pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &val);
-	if (val & PCI_EXP_DEVCAP2_ATOMIC_COMP64) {
-		pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
-					 PCI_EXP_DEVCTL2_ATOMIC_REQ);
-		dev->atomic_cap = IB_ATOMIC_GLOB;
-	} else {
-		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
-					   PCI_EXP_DEVCTL2_ATOMIC_REQ);
-	}
+	rc = pcie_capability_read_word(bridge, PCI_EXP_FLAGS, &flags);
+	if (rc || ((flags & PCI_EXP_FLAGS_VERS) < 2))
+		goto disable;
+
+	rc = pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &cap2);
+	if (rc || !(cap2 & PCI_EXP_DEVCAP2_ATOMIC_COMP64))
+		goto disable;
+
+	/* Set atomic operations */
+	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
+				 PCI_EXP_DEVCTL2_ATOMIC_REQ);
+	dev->atomic_cap = IB_ATOMIC_GLOB;
+
+	DP_DEBUG(dev, QEDR_MSG_INIT, "Atomic capability enabled\n");
+
+	return;
+
+disable:
+	pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
+				   PCI_EXP_DEVCTL2_ATOMIC_REQ);
+	dev->atomic_cap = IB_ATOMIC_NONE;
+
+	DP_DEBUG(dev, QEDR_MSG_INIT, "Atomic capability disabled\n");
+
 }
 
 static const struct qed_rdma_ops *qed_ops;
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 634c9c4..18a26c1 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -630,6 +630,7 @@
 #define  PCI_EXP_DEVCTL2_COMP_TIMEOUT	0x000f	/* Completion Timeout Value */
 #define  PCI_EXP_DEVCTL2_ARI		0x0020	/* Alternative Routing-ID */
 #define PCI_EXP_DEVCTL2_ATOMIC_REQ	0x0040	/* Set Atomic requests */
+#define PCI_EXP_DEVCTL2_ATOMIC_EGRESS_BLOCK 0x0080 /* Block atomic egress */
 #define  PCI_EXP_DEVCTL2_IDO_REQ_EN	0x0100	/* Allow IDO for requests */
 #define  PCI_EXP_DEVCTL2_IDO_CMP_EN	0x0200	/* Allow IDO for completions */
 #define  PCI_EXP_DEVCTL2_LTR_EN		0x0400	/* Enable LTR mechanism */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
