From: Jon Mason <jdmason-zqedIHPRSYI@public.gmane.org>
Subject: [PATCH 04/19] mthca: remove unnecessary read of PCI_CAP_ID_EXP
Date: Mon, 27 Jun 2011 12:39:54 -0500
Message-ID: <1309196394-15793-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
better way of determining if the device is PCIE or not (as it uses the
same saved PCIE capability offset).

Signed-off-by: Jon Mason <jdmason-zqedIHPRSYI@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_main.c  |    2 +-
 drivers/infiniband/hw/mthca/mthca_reset.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index f24b79b..9f05601 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -149,7 +149,7 @@ static int mthca_tune_pci(struct mthca_dev *mdev)
 	} else if (!(mdev->mthca_flags & MTHCA_FLAG_PCIE))
 		mthca_info(mdev, "No PCI-X capability, not setting RBC.\n");
 
-	if (pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP)) {
+	if (pci_is_pcie(mdev->pdev)) {
 		if (pcie_set_readrq(mdev->pdev, 4096)) {
 			mthca_err(mdev, "Couldn't write PCI Express read request, "
 				"aborting.\n");
diff --git a/drivers/infiniband/hw/mthca/mthca_reset.c b/drivers/infiniband/hw/mthca/mthca_reset.c
index 2a13a16..4fa3534 100644
--- a/drivers/infiniband/hw/mthca/mthca_reset.c
+++ b/drivers/infiniband/hw/mthca/mthca_reset.c
@@ -113,7 +113,7 @@ int mthca_reset(struct mthca_dev *mdev)
 	}
 
 	hca_pcix_cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_PCIX);
-	hca_pcie_cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP);
+	hca_pcie_cap = pci_pcie_cap(mdev->pdev);
 
 	if (bridge) {
 		bridge_header = kmalloc(256, GFP_KERNEL);
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
