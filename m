From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc] IB/hfi: Only read capability registers if the
 capability exists
Date: Fri, 22 Dec 2017 08:47:20 -0800
Message-ID: <20171222164717.31842.12554.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

During driver init, various registers are saved to allow restoration
after an FLR or gen3 bump.  Some of these registers are not available
in some circumstances (i.e. Virtual machines).

Delete unnecessary register read/write, and only access register if
the capability exists.

Cc: <stable@vger.kernel.org> # 4.14.x
Fixes: a618b7e40af2 ("IB/hfi1: Move saving PCI values to a separate function")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/hfi.h  |    1 -
 drivers/infiniband/hw/hfi1/pcie.c |   30 ++++++++++++------------------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index dc5b133..2fa651c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1131,7 +1131,6 @@ struct hfi1_devdata {
 	u16 pcie_lnkctl;
 	u16 pcie_devctl2;
 	u32 pci_msix0;
-	u32 pci_lnkctl3;
 	u32 pci_tph2;
 
 	/*
diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 09e50fd..8c7e7a6 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -411,15 +411,12 @@ int restore_pci_variables(struct hfi1_devdata *dd)
 	if (ret)
 		goto error;
 
-	ret = pci_write_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
-				     dd->pci_lnkctl3);
-	if (ret)
-		goto error;
-
-	ret = pci_write_config_dword(dd->pcidev, PCIE_CFG_TPH2, dd->pci_tph2);
-	if (ret)
-		goto error;
-
+	if (pci_find_ext_capability(dd->pcidev, PCI_EXT_CAP_ID_TPH)) {
+		ret = pci_write_config_dword(dd->pcidev, PCIE_CFG_TPH2,
+					     dd->pci_tph2);
+		if (ret)
+			goto error;
+	}
 	return 0;
 
 error:
@@ -469,15 +466,12 @@ int save_pci_variables(struct hfi1_devdata *dd)
 	if (ret)
 		goto error;
 
-	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
-				    &dd->pci_lnkctl3);
-	if (ret)
-		goto error;
-
-	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_TPH2, &dd->pci_tph2);
-	if (ret)
-		goto error;
-
+	if (pci_find_ext_capability(dd->pcidev, PCI_EXT_CAP_ID_TPH)) {
+		ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_TPH2,
+					    &dd->pci_tph2);
+		if (ret)
+			goto error;
+	}
 	return 0;
 
 error:
