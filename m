From: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: change PCI bar addr assignments to Linux API functions
Date: Wed, 10 May 2017 13:48:13 -0500
Message-ID: <1494442093-3590-1-git-send-email-robers97@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The Ominpath adapter driver fails to load the ppc64le platform
due to invalid PCI setup.

This patch makes the PCI configuration more robust and will
fixes 64 bit addressing for ppc64le.

Signed-off-by: Steven L Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pcie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 93faf86..6a9f6f9 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -207,8 +207,8 @@ int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev)
 	/*
 	 * Save BARs and command to rewrite after device reset.
 	 */
-	dd->pcibar0 = addr;
-	dd->pcibar1 = addr >> 32;
+	pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, &dd->pcibar0);
+	pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, &dd->pcibar1);
 	pci_read_config_dword(dd->pcidev, PCI_ROM_ADDRESS, &dd->pci_rom);
 	pci_read_config_word(dd->pcidev, PCI_COMMAND, &dd->pci_command);
 	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &dd->pcie_devctl);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
