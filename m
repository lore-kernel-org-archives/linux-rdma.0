From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/13] IB/hfi1: Move saving PCI values to a
 separate function
Date: Mon, 24 Jul 2017 07:46:30 -0700
Message-ID: <20170724144629.10034.96933.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

During PCIe initialization some registers' values from
PCI config space are saved in order to restore them later
(i.e. after reset). Restoring those value is done by a
function called restore_pci_variables, while saving them
is put directly into function hfi1_pcie_ddinit.
Move saving values to a separate function in the image
of restoring functionality.

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    5 ++
 drivers/infiniband/hw/hfi1/hfi.h  |    1 
 drivers/infiniband/hw/hfi1/pcie.c |  110 ++++++++++++++++++++-----------------
 3 files changed, 64 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 789dbc4..4a4405e 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14866,6 +14866,11 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	if (ret < 0)
 		goto bail_free;
 
+	/* Save PCI space registers to rewrite after device reset */
+	ret = save_pci_variables(dd);
+	if (ret < 0)
+		goto bail_cleanup;
+
 	/* verify that reads actually work, save revision for reset check */
 	dd->revision = read_csr(dd, CCE_REVISION);
 	if (dd->revision == ~(u64)0) {
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 2ce3fc5..2d32c5c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1835,6 +1835,7 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 int pcie_speeds(struct hfi1_devdata *dd);
 int request_msix(struct hfi1_devdata *dd, u32 msireq);
 int restore_pci_variables(struct hfi1_devdata *dd);
+int save_pci_variables(struct hfi1_devdata *dd);
 int do_pcie_gen3_transition(struct hfi1_devdata *dd);
 int parse_platform_config(struct hfi1_devdata *dd);
 int get_platform_config_field(struct hfi1_devdata *dd,
diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 3ac1a1a..82447b7 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -221,63 +221,11 @@ int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev)
 	}
 	dd_dev_info(dd, "WC RcvArray: %p for %x\n",
 		    dd->rcvarray_wc, dd->chip_rcv_array_count * 8);
-	/*
-	 * Save BARs and command to rewrite after device reset.
-	 */
-
-	ret = pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, &dd->pcibar0);
-	if (ret)
-		goto read_error;
-
-	ret = pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, &dd->pcibar1);
-	if (ret)
-		goto read_error;
-	
-	ret = pci_read_config_dword(dd->pcidev, PCI_ROM_ADDRESS, &dd->pci_rom);
-	if (ret)
-		goto read_error;
-
-	ret = pci_read_config_word(dd->pcidev, PCI_COMMAND, &dd->pci_command);
-	if (ret)
-		goto read_error;
-
-	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL,
-					&dd->pcie_devctl);
-	if (ret)
-		goto read_error;
-
-	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL,
-					&dd->pcie_lnkctl);
-	if (ret)
-		goto read_error;
-
-	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL2,
-					&dd->pcie_devctl2);
-	if (ret)
-		goto read_error;
-
-	ret = pci_read_config_dword(dd->pcidev, PCI_CFG_MSIX0, &dd->pci_msix0);
-	if (ret)
-		goto read_error;
-
-	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
-				    &dd->pci_lnkctl3);
-	if (ret)
-		goto read_error;
-
-	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_TPH2, &dd->pci_tph2);
-	if (ret)
-		goto read_error;
 
 	dd->flags |= HFI1_PRESENT;	/* chip.c CSR routines now work */
 	return 0;
-
-read_error:
-	dd_dev_err(dd, "Unable to read from PCI config\n");
-	goto bail_error;
 nomem:
 	ret = -ENOMEM;
-bail_error:
 	hfi1_pcie_ddcleanup(dd);
 	return ret;
 }
@@ -484,6 +432,64 @@ int restore_pci_variables(struct hfi1_devdata *dd)
 	return ret;
 }
 
+/* Save BARs and command to rewrite after device reset */
+int save_pci_variables(struct hfi1_devdata *dd)
+{
+	int ret = 0;
+
+	ret = pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0,
+				    &dd->pcibar0);
+	if (ret)
+		goto error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1,
+				    &dd->pcibar1);
+	if (ret)
+		goto error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCI_ROM_ADDRESS, &dd->pci_rom);
+	if (ret)
+		goto error;
+
+	ret = pci_read_config_word(dd->pcidev, PCI_COMMAND, &dd->pci_command);
+	if (ret)
+		goto error;
+
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL,
+					&dd->pcie_devctl);
+	if (ret)
+		goto error;
+
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL,
+					&dd->pcie_lnkctl);
+	if (ret)
+		goto error;
+
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL2,
+					&dd->pcie_devctl2);
+	if (ret)
+		goto error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCI_CFG_MSIX0, &dd->pci_msix0);
+	if (ret)
+		goto error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
+				    &dd->pci_lnkctl3);
+	if (ret)
+		goto error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_TPH2, &dd->pci_tph2);
+	if (ret)
+		goto error;
+
+	return 0;
+
+error:
+	dd_dev_err(dd, "Unable to read from PCI config\n");
+	return ret;
+}
+
 /*
  * BIOS may not set PCIe bus-utilization parameters for best performance.
  * Check and optionally adjust them to maximize our throughput.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
