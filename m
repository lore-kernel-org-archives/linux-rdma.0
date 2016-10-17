From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/12] IB/hfi1: Clean up unused argument
Date: Mon, 17 Oct 2016 04:19:58 -0700
Message-ID: <20161017111957.7934.68488.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

hfi1_pcie_ddinit takes the PCI device id as an argument but never
uses it. Clean it up.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    2 +-
 drivers/infiniband/hw/hfi1/hfi.h  |    3 +--
 drivers/infiniband/hw/hfi1/pcie.c |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index bf645e9..3371361 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14449,7 +14449,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	 * Any error printing is already done by the init code.
 	 * On return, we have the chip mapped.
 	 */
-	ret = hfi1_pcie_ddinit(dd, pdev, ent);
+	ret = hfi1_pcie_ddinit(dd, pdev);
 	if (ret < 0)
 		goto bail_free;
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1453c5c..6f05f68 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1760,8 +1760,7 @@ int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len);
 
 int hfi1_pcie_init(struct pci_dev *, const struct pci_device_id *);
 void hfi1_pcie_cleanup(struct pci_dev *);
-int hfi1_pcie_ddinit(struct hfi1_devdata *, struct pci_dev *,
-		     const struct pci_device_id *);
+int hfi1_pcie_ddinit(struct hfi1_devdata *, struct pci_dev *);
 void hfi1_pcie_ddcleanup(struct hfi1_devdata *);
 void hfi1_pcie_flr(struct hfi1_devdata *);
 int pcie_speeds(struct hfi1_devdata *);
diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 89c68da..4ac8f33 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -157,8 +157,7 @@ void hfi1_pcie_cleanup(struct pci_dev *pdev)
  * fields required to re-initialize after a chip reset, or for
  * various other purposes
  */
-int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev,
-		     const struct pci_device_id *ent)
+int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev)
 {
 	unsigned long len;
 	resource_size_t addr;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
