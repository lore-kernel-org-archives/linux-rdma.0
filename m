From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v5 11/13] nvme-pci: Add a quirk for a pseudo CMB
Date: Thu, 30 Aug 2018 12:53:50 -0600
Message-ID: <20180830185352.3369-12-logang@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830185352.3369-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

Introduce a quirk to use CMB-like memory on older devices that have
an exposed BAR but do not advertise support for using CMBLOC and
CMBSIZE.

We'd like to use some of these older cards to test P2P memory.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/nvme.h |  7 +++++++
 drivers/nvme/host/pci.c  | 24 ++++++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 4030743c90aa..8e6f3bcfe956 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -90,6 +90,13 @@ enum nvme_quirks {
 	 * Set MEDIUM priority on SQ creation
 	 */
 	NVME_QUIRK_MEDIUM_PRIO_SQ		= (1 << 7),
+
+	/*
+	 * Pseudo CMB Support on BAR 4. For adapters like the Microsemi
+	 * NVRAM that have CMB-like memory on a BAR but does not set
+	 * CMBLOC or CMBSZ.
+	 */
+	NVME_QUIRK_PSEUDO_CMB_BAR4		= (1 << 8),
 };
 
 /*
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index bb2120d30e39..f898f2ab1420 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1636,6 +1636,13 @@ static ssize_t nvme_cmb_show(struct device *dev,
 }
 static DEVICE_ATTR(cmb, S_IRUGO, nvme_cmb_show, NULL);
 
+static u32 nvme_pseudo_cmbsz(struct pci_dev *pdev, int bar)
+{
+	return NVME_CMBSZ_WDS | NVME_CMBSZ_RDS |
+		(((ilog2(SZ_16M) - 12) / 4) << NVME_CMBSZ_SZU_SHIFT) |
+		((pci_resource_len(pdev, bar) / SZ_16M) << NVME_CMBSZ_SZ_SHIFT);
+}
+
 static u64 nvme_cmb_size_unit(struct nvme_dev *dev)
 {
 	u8 szu = (dev->cmbsz >> NVME_CMBSZ_SZU_SHIFT) & NVME_CMBSZ_SZU_MASK;
@@ -1655,10 +1662,15 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 	int bar;
 
-	dev->cmbsz = readl(dev->bar + NVME_REG_CMBSZ);
-	if (!dev->cmbsz)
-		return;
-	dev->cmbloc = readl(dev->bar + NVME_REG_CMBLOC);
+	if (dev->ctrl.quirks & NVME_QUIRK_PSEUDO_CMB_BAR4) {
+		dev->cmbsz = nvme_pseudo_cmbsz(pdev, 4);
+		dev->cmbloc = 4;
+	} else {
+		dev->cmbsz = readl(dev->bar + NVME_REG_CMBSZ);
+		if (!dev->cmbsz)
+			return;
+		dev->cmbloc = readl(dev->bar + NVME_REG_CMBLOC);
+	}
 
 	size = nvme_cmb_size_unit(dev) * nvme_cmb_size(dev);
 	offset = nvme_cmb_size_unit(dev) * NVME_CMB_OFST(dev->cmbloc);
@@ -2707,6 +2719,10 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x1d1d, 0x2601),	/* CNEX Granby */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
+	{ PCI_DEVICE(0x11f8, 0xf117),	/* Microsemi NVRAM adaptor */
+		.driver_data = NVME_QUIRK_PSEUDO_CMB_BAR4, },
+	{ PCI_DEVICE(0x1db1, 0x0002),	/* Everspin nvNitro adaptor */
+		.driver_data = NVME_QUIRK_PSEUDO_CMB_BAR4,  },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
-- 
2.11.0
