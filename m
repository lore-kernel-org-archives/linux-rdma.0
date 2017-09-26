From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 7/7] IB/hfi1: Unsuccessful PCIe caps tuning should
 not fail driver load
Date: Tue, 26 Sep 2017 06:06:34 -0700
Message-ID: <20170926130633.31476.28127.stgit@scvm10.sc.intel.com>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926130434.31476.81826.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Failure to tune PCIe capabilities should not fail driver load. This can
cause the driver load to fail on systems with any of the following:
1. HFI's parent is not root. Example: HFI card is behind a PCIe bridge.
2. HFI's parent is not PCI Express capable.
In these situations, failure to tune PCIe capabilities should be logged
in the system message logs but not cause the driver load to fail.

This patch also ensures pcie capability word DevCtl is written only
after a successful read and the capability tuning process continues
even if read/write of the pcie capability word DevCtl fails.

Fixes: c53df62c7a9a ("IB/hfi1: Check return values from PCI config API calls")
Fixes: bf70a7757736 ("staging/rdma/hfi1: Enable WFR PCIe extended tags from the driver")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pcie.c |   50 ++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 82447b7..09e50fd 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -68,7 +68,7 @@
 /*
  * Code to adjust PCIe capabilities.
  */
-static int tune_pcie_caps(struct hfi1_devdata *);
+static void tune_pcie_caps(struct hfi1_devdata *);
 
 /*
  * Do all the common PCIe setup and initialization.
@@ -351,7 +351,7 @@ int pcie_speeds(struct hfi1_devdata *dd)
  */
 int request_msix(struct hfi1_devdata *dd, u32 msireq)
 {
-	int nvec, ret;
+	int nvec;
 
 	nvec = pci_alloc_irq_vectors(dd->pcidev, 1, msireq,
 				     PCI_IRQ_MSIX | PCI_IRQ_LEGACY);
@@ -360,12 +360,7 @@ int request_msix(struct hfi1_devdata *dd, u32 msireq)
 		return nvec;
 	}
 
-	ret = tune_pcie_caps(dd);
-	if (ret) {
-		dd_dev_err(dd, "tune_pcie_caps() failed: %d\n", ret);
-		pci_free_irq_vectors(dd->pcidev);
-		return ret;
-	}
+	tune_pcie_caps(dd);
 
 	/* check for legacy IRQ */
 	if (nvec == 1 && !dd->pcidev->msix_enabled)
@@ -502,7 +497,7 @@ int save_pci_variables(struct hfi1_devdata *dd)
 module_param_named(aspm, aspm_mode, uint, S_IRUGO);
 MODULE_PARM_DESC(aspm, "PCIe ASPM: 0: disable, 1: enable, 2: dynamic");
 
-static int tune_pcie_caps(struct hfi1_devdata *dd)
+static void tune_pcie_caps(struct hfi1_devdata *dd)
 {
 	struct pci_dev *parent;
 	u16 rc_mpss, rc_mps, ep_mpss, ep_mps;
@@ -513,22 +508,14 @@ static int tune_pcie_caps(struct hfi1_devdata *dd)
 	 * Turn on extended tags in DevCtl in case the BIOS has turned it off
 	 * to improve WFR SDMA bandwidth
 	 */
-	ret = pcie_capability_read_word(dd->pcidev,
-					PCI_EXP_DEVCTL, &ectl);
-	if (ret) {
-		dd_dev_err(dd, "Unable to read from PCI config\n");
-		return ret;
-	}
-
-	if (!(ectl & PCI_EXP_DEVCTL_EXT_TAG)) {
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &ectl);
+	if ((!ret) && !(ectl & PCI_EXP_DEVCTL_EXT_TAG)) {
 		dd_dev_info(dd, "Enabling PCIe extended tags\n");
 		ectl |= PCI_EXP_DEVCTL_EXT_TAG;
 		ret = pcie_capability_write_word(dd->pcidev,
 						 PCI_EXP_DEVCTL, ectl);
-		if (ret) {
-			dd_dev_err(dd, "Unable to write to PCI config\n");
-			return ret;
-		}
+		if (ret)
+			dd_dev_info(dd, "Unable to write to PCI config\n");
 	}
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
@@ -536,15 +523,22 @@ static int tune_pcie_caps(struct hfi1_devdata *dd)
 	 * The driver cannot perform the tuning if it does not have
 	 * access to the upstream component.
 	 */
-	if (!parent)
-		return -EINVAL;
+	if (!parent) {
+		dd_dev_info(dd, "Parent not found\n");
+		return;
+	}
 	if (!pci_is_root_bus(parent->bus)) {
 		dd_dev_info(dd, "Parent not root\n");
-		return -EINVAL;
+		return;
+	}
+	if (!pci_is_pcie(parent)) {
+		dd_dev_info(dd, "Parent is not PCI Express capable\n");
+		return;
+	}
+	if (!pci_is_pcie(dd->pcidev)) {
+		dd_dev_info(dd, "PCI device is not PCI Express capable\n");
+		return;
 	}
-
-	if (!pci_is_pcie(parent) || !pci_is_pcie(dd->pcidev))
-		return -EINVAL;
 	rc_mpss = parent->pcie_mpss;
 	rc_mps = ffs(pcie_get_mps(parent)) - 8;
 	/* Find out supported and configured values for endpoint (us) */
@@ -590,8 +584,6 @@ static int tune_pcie_caps(struct hfi1_devdata *dd)
 		ep_mrrs = max_mrrs;
 		pcie_set_readrq(dd->pcidev, ep_mrrs);
 	}
-
-	return 0;
 }
 
 /* End of PCIe capability tuning */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
