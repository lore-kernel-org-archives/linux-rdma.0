From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 07/12] nvme-pci: clean up CMB initialization
Date: Thu,  4 Jan 2018 12:01:32 -0700
Message-ID: <20180104190137.7654-8-logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180104190137.7654-1-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Refactor the call to nvme_map_cmb, and change the conditions for probing
for the CMB.  First remove the version check as NVMe TPs always apply
to earlier versions of the spec as well.  Second check for the whole CMBSZ
register for support of the CMB feature instead of just the size field
inside of it to simplify the code a bit.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/pci.c | 41 ++++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f5800c3c9082..58c379af6fb4 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1663,21 +1663,20 @@ static ssize_t nvme_cmb_show(struct device *dev,
 }
 static DEVICE_ATTR(cmb, S_IRUGO, nvme_cmb_show, NULL);
 
-static void __iomem *nvme_map_cmb(struct nvme_dev *dev)
+static void nvme_map_cmb(struct nvme_dev *dev)
 {
 	u64 szu, size, offset;
 	resource_size_t bar_size;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
-	void __iomem *cmb;
 	int bar;
 
 	dev->cmbsz = readl(dev->bar + NVME_REG_CMBSZ);
-	if (!(NVME_CMB_SZ(dev->cmbsz)))
-		return NULL;
+	if (!dev->cmbsz)
+		return;
 	dev->cmbloc = readl(dev->bar + NVME_REG_CMBLOC);
 
 	if (!use_cmb_sqes)
-		return NULL;
+		return;
 
 	szu = (u64)1 << (12 + 4 * NVME_CMB_SZU(dev->cmbsz));
 	size = szu * NVME_CMB_SZ(dev->cmbsz);
@@ -1686,7 +1685,7 @@ static void __iomem *nvme_map_cmb(struct nvme_dev *dev)
 	bar_size = pci_resource_len(pdev, bar);
 
 	if (offset > bar_size)
-		return NULL;
+		return;
 
 	/*
 	 * Controllers may support a CMB size larger than their BAR,
@@ -1696,13 +1695,16 @@ static void __iomem *nvme_map_cmb(struct nvme_dev *dev)
 	if (size > bar_size - offset)
 		size = bar_size - offset;
 
-	cmb = ioremap_wc(pci_resource_start(pdev, bar) + offset, size);
-	if (!cmb)
-		return NULL;
-
+	dev->cmb = ioremap_wc(pci_resource_start(pdev, bar) + offset, size);
+	if (!dev->cmb)
+		return;
 	dev->cmb_bus_addr = pci_bus_address(pdev, bar) + offset;
 	dev->cmb_size = size;
-	return cmb;
+
+	if (sysfs_add_file_to_group(&dev->ctrl.device->kobj,
+				    &dev_attr_cmb.attr, NULL))
+		dev_warn(dev->ctrl.device,
+			 "failed to add sysfs attribute for CMB\n");
 }
 
 static inline void nvme_release_cmb(struct nvme_dev *dev)
@@ -2124,22 +2126,7 @@ static int nvme_pci_enable(struct nvme_dev *dev)
                         "set queue depth=%u\n", dev->q_depth);
 	}
 
-	/*
-	 * CMBs can currently only exist on >=1.2 PCIe devices. We only
-	 * populate sysfs if a CMB is implemented. Since nvme_dev_attrs_group
-	 * has no name we can pass NULL as final argument to
-	 * sysfs_add_file_to_group.
-	 */
-
-	if (readl(dev->bar + NVME_REG_VS) >= NVME_VS(1, 2, 0)) {
-		dev->cmb = nvme_map_cmb(dev);
-		if (dev->cmb) {
-			if (sysfs_add_file_to_group(&dev->ctrl.device->kobj,
-						    &dev_attr_cmb.attr, NULL))
-				dev_warn(dev->ctrl.device,
-					 "failed to add sysfs attribute for CMB\n");
-		}
-	}
+	nvme_map_cmb(dev);
 
 	pci_enable_pcie_error_reporting(pdev);
 	pci_save_state(pdev);
-- 
2.11.0
