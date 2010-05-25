From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: fix undefined symbol error when CONFIG_PCI_MSI
	undefined
Date: Tue, 25 May 2010 12:22:33 -0700
Message-ID: <20100525192233.18292.56653.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes a compile error saying qib_init_iba6120_funcs() is
undefined when CONFIG_PCI_MSI is not defined.
Thanks to Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> for finding this and
suggesting the fix.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_iba6120.c |   12 ------------
 drivers/infiniband/hw/qib/qib_init.c    |    6 ++++++
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 7b6549f..1eadadc 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -3475,14 +3475,6 @@ struct qib_devdata *qib_init_iba6120_funcs(struct pci_dev *pdev,
 	struct qib_devdata *dd;
 	int ret;
 
-#ifndef CONFIG_PCI_MSI
-	qib_early_err(&pdev->dev, "QLogic PCIE device 0x%x cannot "
-	      "work if CONFIG_PCI_MSI is not enabled\n",
-	      ent->device);
-	dd = ERR_PTR(-ENODEV);
-	goto bail;
-#endif
-
 	dd = qib_alloc_devdata(pdev, sizeof(struct qib_pportdata) +
 			       sizeof(struct qib_chip_specific));
 	if (IS_ERR(dd))
@@ -3554,10 +3546,6 @@ struct qib_devdata *qib_init_iba6120_funcs(struct pci_dev *pdev,
 	if (qib_mini_init)
 		goto bail;
 
-#ifndef CONFIG_PCI_MSI
-	qib_dev_err(dd, "PCI_MSI not configured, NO interrupts\n");
-#endif
-
 	if (qib_pcie_params(dd, 8, NULL, NULL))
 		qib_dev_err(dd, "Failed to setup PCIe or interrupts; "
 			    "continuing anyway\n");
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index c0139c0..9b40f34 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1237,7 +1237,13 @@ static int __devinit qib_init_one(struct pci_dev *pdev,
 	 */
 	switch (ent->device) {
 	case PCI_DEVICE_ID_QLOGIC_IB_6120:
+#ifdef CONFIG_PCI_MSI
 		dd = qib_init_iba6120_funcs(pdev, ent);
+#else
+		qib_early_err(&pdev->dev, "QLogic PCIE device 0x%x cannot "
+		      "work if CONFIG_PCI_MSI is not enabled\n",
+		      ent->device);
+#endif
 		break;
 
 	case PCI_DEVICE_ID_QLOGIC_IB_7220:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
