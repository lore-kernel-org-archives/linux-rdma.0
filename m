From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH V4 6/7] PCI: Rename pci_try_reset_bus() to pci_reset_bus()
Date: Thu, 28 Jun 2018 15:31:04 -0400
Message-ID: <1530214274-21139-6-git-send-email-okaya@codeaurora.org>
References: <1530214274-21139-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530214274-21139-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pci@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, Alex Williamson <alex.williamson@redhat.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Peter Xu <peterx@redhat.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Now that the old implementation of pci_reset_bus() is gone, replace
pci_try_reset_bus() with pci_reset_bus().

Compared to the old implementation, new code will fail immmediately with
-EAGAIN if object lock cannot be obtained.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/infiniband/hw/hfi1/pcie.c |  2 +-
 drivers/pci/pci.c                 | 18 +++++++++---------
 drivers/vfio/pci/vfio_pci.c       |  4 ++--
 include/linux/pci.h               |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index df4f2d3..baf7c32 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -905,7 +905,7 @@ static int trigger_sbr(struct hfi1_devdata *dd)
 	 * delay after a reset is required.  Per spec requirements,
 	 * the link is either working or not after that point.
 	 */
-	return pci_try_reset_bus(dev);
+	return pci_reset_bus(dev);
 }
 
 /*
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6cec722..28a071d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4784,7 +4784,7 @@ int pci_probe_reset_slot(struct pci_slot *slot)
 EXPORT_SYMBOL_GPL(pci_probe_reset_slot);
 
 /**
- * __pci_try_reset_slot - Try to reset a PCI slot
+ * __pci_reset_slot - Try to reset a PCI slot
  * @slot: PCI slot to reset
  *`
  * A PCI bus may host multiple slots, each slot may support a reset mechanism
@@ -4798,7 +4798,7 @@ EXPORT_SYMBOL_GPL(pci_probe_reset_slot);
  *
  * Same as above except return -EAGAIN if the slot cannot be locked
  */
-static int __pci_try_reset_slot(struct pci_slot *slot)
+static int __pci_reset_slot(struct pci_slot *slot)
 {
 	int rc;
 
@@ -4854,12 +4854,12 @@ int pci_probe_reset_bus(struct pci_bus *bus)
 EXPORT_SYMBOL_GPL(pci_probe_reset_bus);
 
 /**
- * __pci_try_reset_bus - Try to reset a PCI bus
+ * __pci_reset_bus - Try to reset a PCI bus
  * @bus: top level PCI bus to reset
  *
  * Same as above except return -EAGAIN if the bus cannot be locked
  */
-static int __pci_try_reset_bus(struct pci_bus *bus)
+static int __pci_reset_bus(struct pci_bus *bus)
 {
 	int rc;
 
@@ -4882,22 +4882,22 @@ static int __pci_try_reset_bus(struct pci_bus *bus)
 }
 
 /**
- * pci_try_reset_bus - Try to reset a PCI bus
+ * pci_reset_bus - Try to reset a PCI bus
  * @pdev: top level PCI device to reset via slot/bus
  *
  * Same as above except return -EAGAIN if the bus cannot be locked
  */
-int pci_try_reset_bus(struct pci_dev *pdev)
+int pci_reset_bus(struct pci_dev *pdev)
 {
 	bool slot = false;
 
 	if (!pci_probe_reset_slot(pdev->slot))
 		slot = true;
 
-	return slot ? __pci_try_reset_slot(pdev->slot) :
-			__pci_try_reset_bus(pdev->bus);
+	return slot ? __pci_reset_slot(pdev->slot) :
+			__pci_reset_bus(pdev->bus);
 }
-EXPORT_SYMBOL_GPL(pci_try_reset_bus);
+EXPORT_SYMBOL_GPL(pci_reset_bus);
 
 /**
  * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 71018ec..345c0dc 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1010,7 +1010,7 @@ static long vfio_pci_ioctl(void *device_data,
 						    &info, slot);
 		if (!ret)
 			/* User has access, do the reset */
-			ret = pci_try_reset_bus(vdev->pdev);
+			ret = pci_reset_bus(vdev->pdev);
 
 hot_reset_release:
 		for (i--; i >= 0; i--)
@@ -1372,7 +1372,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	}
 
 	if (needs_reset)
-		ret = pci_try_reset_bus(vdev->pdev);
+		ret = pci_reset_bus(vdev->pdev);
 
 put_devs:
 	for (i = 0; i < devs.cur_index; i++) {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ad0c89a..79a2c27 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1096,7 +1096,7 @@ int pci_reset_function_locked(struct pci_dev *dev);
 int pci_try_reset_function(struct pci_dev *dev);
 int pci_probe_reset_slot(struct pci_slot *slot);
 int pci_probe_reset_bus(struct pci_bus *bus);
-int pci_try_reset_bus(struct pci_dev *dev);
+int pci_reset_bus(struct pci_dev *dev);
 void pci_reset_secondary_bus(struct pci_dev *dev);
 void pcibios_reset_secondary_bus(struct pci_dev *dev);
 void pci_update_resource(struct pci_dev *dev, int resno);
-- 
2.7.4
