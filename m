From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 04/13] PCI/P2PDMA: Introduce configfs/sysfs enable
 attribute helpers
Date: Thu, 30 Aug 2018 12:53:43 -0600
Message-ID: <20180830185352.3369-5-logang@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180830185352.3369-1-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Users of the P2PDMA infrastructure will typically need a way for
the user to tell the kernel to use P2P resources. Typically
this will be a simple on/off boolean operation but sometimes
it may be desirable for the user to specify the exact device to
use for the P2P operation.

Add new helpers for attributes which take a boolean or a PCI device.
Any boolean, or the word 'auto' turn P2P on or off. Specifying a full
PCI device name/BDF will select the specific device.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
---
 drivers/pci/p2pdma.c       | 83 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci-p2pdma.h | 15 +++++++++
 2 files changed, 98 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 29bd40a87768..3da848f3fe72 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -9,6 +9,7 @@
  */
 
 #define pr_fmt(fmt) "pci-p2pdma: " fmt
+#include <linux/ctype.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -856,3 +857,85 @@ int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	return nents;
 }
 EXPORT_SYMBOL_GPL(pci_p2pdma_map_sg);
+
+/**
+ * pci_p2pdma_enable_store - parse a configfs/sysfs attribute store
+ *		to enable p2pdma
+ * @page: contents of the value to be stored
+ * @p2p_dev: returns the PCI device that was selected to be used
+ *		(if 'auto', 'none or a boolean isn't the store value)
+ * @use_p2pdma: returns whether to enable p2pdma or not
+ *
+ * Parses an attribute value to decide whether to enable p2pdma.
+ * The value can select a PCI device (using it's full BDF device
+ * name), a boolean, or 'auto'. 'auto' and a true boolean value
+ * have the same meaning. A false value disables p2pdma and
+ * a PCI device enables it to use a specific device as the
+ * backing provider.
+ *
+ * pci_p2pdma_enable_show() should be used as the show operation for
+ * the attribute.
+ *
+ * Returns 0 on success
+ */
+int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
+			    bool *use_p2pdma)
+{
+	struct device *dev;
+
+	dev = bus_find_device_by_name(&pci_bus_type, NULL, page);
+	if (dev) {
+		*use_p2pdma = true;
+		*p2p_dev = to_pci_dev(dev);
+
+		if (!pci_has_p2pmem(*p2p_dev)) {
+			pr_err("PCI device has no peer-to-peer memory: %s\n",
+			       page);
+			pci_dev_put(*p2p_dev);
+			return -ENODEV;
+		}
+
+		return 0;
+	} else if (sysfs_streq(page, "auto")) {
+		*use_p2pdma = true;
+		return 0;
+	} else if ((page[0] == '0' || page[0] == '1') && !iscntrl(page[1])) {
+		/*
+		 * If the user enters a PCI device that  doesn't exist
+		 * like "0000:01:00.1", we don't want strtobool to think
+		 * it's a '0' when it's clearly not what the user wanted.
+		 * So we require 0's and 1's to be exactly one character.
+		 */
+	} else if (!strtobool(page, use_p2pdma)) {
+		return 0;
+	}
+
+	pr_err("No such PCI device: %.*s\n", (int)strcspn(page, "\n"), page);
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(pci_p2pdma_enable_store);
+
+/**
+ * pci_p2pdma_enable_show - show a configfs/sysfs attribute indicating
+ *		whether p2pdma is enabled
+ * @page: contents of the stored value
+ * @p2p_dev: the selected p2p device (NULL if no device is selected)
+ * @use_p2pdma: whether p2pdme has been enabled
+ *
+ * Attributes that use pci_p2pdma_enable_store() should use this function
+ * to show the value of the attribute.
+ *
+ * Returns 0 on success
+ */
+ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
+			       bool use_p2pdma)
+{
+	if (!use_p2pdma)
+		return sprintf(page, "none\n");
+
+	if (!p2p_dev)
+		return sprintf(page, "auto\n");
+
+	return sprintf(page, "%s\n", pci_name(p2p_dev));
+}
+EXPORT_SYMBOL_GPL(pci_p2pdma_enable_show);
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 2f03dbbf5af6..377de4d73767 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -38,6 +38,10 @@ void pci_p2pmem_free_sgl(struct pci_dev *pdev, struct scatterlist *sgl);
 void pci_p2pmem_publish(struct pci_dev *pdev, bool publish);
 int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		      enum dma_data_direction dir);
+int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
+			    bool *use_p2pdma);
+ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
+			       bool use_p2pdma);
 #else /* CONFIG_PCI_P2PDMA */
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
@@ -105,5 +109,16 @@ static inline int pci_p2pdma_map_sg(struct device *dev,
 {
 	return 0;
 }
+static inline int pci_p2pdma_enable_store(const char *page,
+		struct pci_dev **p2p_dev, bool *use_p2pdma)
+{
+	*use_p2pdma = false;
+	return 0;
+}
+static inline ssize_t pci_p2pdma_enable_show(char *page,
+		struct pci_dev *p2p_dev, bool use_p2pdma)
+{
+	return sprintf(page, "none\n");
+}
 #endif /* CONFIG_PCI_P2PDMA */
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.11.0
