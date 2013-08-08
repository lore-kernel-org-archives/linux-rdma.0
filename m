From: Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/16] qib: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:11:56 +0800
Message-ID: <1375967516-21316-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, jiang.liu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/qib/qib_pcie.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index c574ec7..3f14009 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -283,12 +283,12 @@ int qib_pcie_params(struct qib_devdata *dd, u32 minw, u32 *nent,
 		goto bail;
 	}
 
-	pos = pci_find_capability(dd->pcidev, PCI_CAP_ID_MSIX);
+	pos = dd->pcidev->msix_cap;
 	if (nent && *nent && pos) {
 		qib_msix_setup(dd, pos, nent, entry);
 		ret = 0; /* did it, either MSIx or INTx */
 	} else {
-		pos = pci_find_capability(dd->pcidev, PCI_CAP_ID_MSI);
+		pos = dd->pcidev->msi_cap;
 		if (pos)
 			ret = qib_msi_setup(dd, pos);
 		else
@@ -357,7 +357,7 @@ int qib_reinit_intr(struct qib_devdata *dd)
 	if (!dd->msi_lo)
 		goto bail;
 
-	pos = pci_find_capability(dd->pcidev, PCI_CAP_ID_MSI);
+	pos = dd->pcidev->msi_cap;
 	if (!pos) {
 		qib_dev_err(dd,
 			"Can't find MSI capability, can't restore MSI settings\n");
@@ -426,7 +426,7 @@ void qib_enable_intx(struct pci_dev *pdev)
 	if (new != cw)
 		pci_write_config_word(pdev, PCI_COMMAND, new);
 
-	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
+	pos = pdev->msi_cap;
 	if (pos) {
 		/* then turn off MSI */
 		pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &cw);
@@ -434,7 +434,7 @@ void qib_enable_intx(struct pci_dev *pdev)
 		if (new != cw)
 			pci_write_config_word(pdev, pos + PCI_MSI_FLAGS, new);
 	}
-	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+	pos = pdev->msix_cap;
 	if (pos) {
 		/* then turn off MSIx */
 		pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &cw);
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
