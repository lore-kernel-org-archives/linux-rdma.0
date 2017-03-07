From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] device: Stop requiring that struct device is embedded in struct pci_dev
Date: Mon, 6 Mar 2017 16:35:48 -0800
Message-ID: <20170307003549.3872-2-bart.vanassche@sandisk.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307003549.3872-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The dma mapping operations of several architectures and also of
several I/O MMU implementations need to translate a struct
device pointer into a struct pci_dev pointer. This translation
is performed by to_pci_dev(). That macro assumes that struct
device is embedded in struct pci_dev. However, that is not the
case for the device structure in struct ib_device. Since that
device structure is passed to DMA mapping operations since kernel
v4.11-rc1, introduce a pointer in struct device to make the
translation from struct device into struct pci_dev more flexible.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
---
 drivers/pci/probe.c    | 1 +
 include/linux/device.h | 5 +++++
 include/linux/pci.h    | 5 ++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dfc9a2794141..60d739b59520 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1736,6 +1736,7 @@ struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
 
 	INIT_LIST_HEAD(&dev->bus_list);
 	dev->dev.type = &pci_dev_type;
+	dev->dev.pci_dev = dev;
 	dev->bus = pci_bus_get(bus);
 
 	return dev;
diff --git a/include/linux/device.h b/include/linux/device.h
index 30c4570e928d..c18afd376d2a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -42,6 +42,7 @@ struct fwnode_handle;
 struct iommu_ops;
 struct iommu_group;
 struct iommu_fwspec;
+struct pci_dev;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -860,6 +861,9 @@ struct dev_links_info {
  * 		segment limitations.
  * @dma_pools:	Dma pools (if dma'ble device).
  * @dma_mem:	Internal for coherent mem override.
+ * @pci_dev:	PCI device associated with this device. Used by DMA mapping
+ *		operations on architectures that need access to PCI device
+ *		members that are not in struct device.
  * @cma_area:	Contiguous memory area for dma allocations
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
@@ -940,6 +944,7 @@ struct device {
 
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
 					     override */
+	struct pci_dev		*pci_dev; /* for DMA mapping operations */
 #ifdef CONFIG_DMA_CMA
 	struct cma *cma_area;		/* contiguous memory area for dma
 					   allocations */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index eb3da1a04e6c..eca790eaae20 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -409,7 +409,10 @@ static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 
 struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
 
-#define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
+static inline struct pci_dev *to_pci_dev(const struct device *dev)
+{
+	return dev->pci_dev;
+}
 #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
 
 static inline int pci_channel_offline(struct pci_dev *pdev)
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
