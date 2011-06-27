From: Jon Mason <jdmason-zqedIHPRSYI@public.gmane.org>
Subject: [PATCH 05/19] qib: remove unnecessary read of PCI_CAP_ID_EXP
Date: Mon, 27 Jun 2011 12:40:38 -0500
Message-ID: <1309196438-15830-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.

Signed-off-by: Jon Mason <jdmason-zqedIHPRSYI@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_pcie.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 891cc2f..4426782 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -255,7 +255,7 @@ int qib_pcie_params(struct qib_devdata *dd, u32 minw, u32 *nent,
 	u16 linkstat, speed;
 	int pos = 0, pose, ret = 1;
 
-	pose = pci_find_capability(dd->pcidev, PCI_CAP_ID_EXP);
+	pose = pci_pcie_cap(dd->pcidev);
 	if (!pose) {
 		qib_dev_err(dd, "Can't find PCI Express capability!\n");
 		/* set up something... */
@@ -509,7 +509,7 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
 		qib_devinfo(dd->pcidev, "Parent not root\n");
 		return 1;
 	}
-	ppos = pci_find_capability(parent, PCI_CAP_ID_EXP);
+	ppos = pci_pcie_cap(parent);
 	if (!ppos)
 		return 1;
 	if (parent->vendor != 0x8086)
@@ -578,14 +578,14 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 		qib_devinfo(dd->pcidev, "Parent not root\n");
 		goto bail;
 	}
-	ppos = pci_find_capability(parent, PCI_CAP_ID_EXP);
+	ppos = pci_pcie_cap(parent);
 	if (ppos) {
 		pci_read_config_word(parent, ppos + PCI_EXP_DEVCAP, &pcaps);
 		pci_read_config_word(parent, ppos + PCI_EXP_DEVCTL, &pctl);
 	} else
 		goto bail;
 	/* Find out supported and configured values for endpoint (us) */
-	epos = pci_find_capability(dd->pcidev, PCI_CAP_ID_EXP);
+	epos = pci_pcie_cap(dd->pcidev);
 	if (epos) {
 		pci_read_config_word(dd->pcidev, epos + PCI_EXP_DEVCAP, &ecaps);
 		pci_read_config_word(dd->pcidev, epos + PCI_EXP_DEVCTL, &ectl);
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
