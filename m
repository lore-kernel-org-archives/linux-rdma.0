Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794939644;
	b=OsQjvK/8YBmgxEGlf450KRbobKDPI3QWK0LXtK6dlOHpE5GIZeSWh1eSBM9zmgF+szRJ
	 tkFJkp0bT10dA1+6HqtGLvG1iL6aVbR/WptBM9mAdO9xm4FD13mssxANBs82rynlQYwjs
	 ZbTLUWrgghp1yjcZXwLNVIoQT9jGeGXtYL7SNgh2zgHQFw2vTPpWs68M4Y0MT9B8Tw9tE
	 ZpUsOax8XKo8oa6ddw/aJOncGcozokn1orIOI+94DKTrag6l809GdyEfbmVMoGw3GFs2n
	 RMTFx81RfG7ijFvQyzNLlWsJYR0DlgKWvW0v9C3UM5FZHPSBSd5fH0dyU/UxONDstZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794939644;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=fl056RC2wTU7z1UYRy49KARy5BlKu2koKjdQuSFZ0Tk=;
	b=0l4KRZzCp/Dyp4JLYbwEyUpy5QmmR2EEbZcBzXgm2LEJOXY5xMa9CUiDoBksVbu7CTkR
	 08y67ND7tpOA5Ue2RVIvkHbbz8QEoa5mUjD71lyKqtOOE/6aoPlKYTWLxBmADYKF3rTFT
	 i2O4e+xQliYJY8jbYmEjNrdvl8/aD+ga4YmQbaLJmAVLOebeshMKtxqrjLlQhwtzAyurB
	 eGvBLsvXUOCp4Bp25XQ11BBngePPc8cs3XumqqI/PZ92JDmnJdFKLTxbAjp3Dc7nDO5yb
	 ZN5gMeQ9bOs5qRv1AFxdIlgT+k3B6oFMzmUIw/tEnsNSo735fo44YGWbrOc/bLga0Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=W84XlMZ8;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEB7606A334;
	Tue, 17 Nov 2026 18:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCEB7606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=W84XlMZ8
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 2380D20B716A; Tue, 17 Nov 2026 10:20:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2380D20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794939643;
	bh=fl056RC2wTU7z1UYRy49KARy5BlKu2koKjdQuSFZ0Tk=;
	h=From:To:Cc:Subject:Date:From;
	b=W84XlMZ8+mB1y2/5ndUdWT3oqDZ/uLroAQpjqf99hjRa3dqwPFSKTzTaY95PMFVbs
	 wckxuPoqkJS64CHXSVJWL/A2DQINRPSHtn86TgusxdvzNveRP7TrP9zCD4jRYQUExJ
	 zGC5Av5kh6Q9JVbHpdnVCNB35+gpCQ6I2Ms8Ieqg=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2] RDMA/mana_ib: Enable RDMA devices on the CDX bus
Date: Tue, 17 Nov 2026 10:20:43 -0800
Message-ID: <20261117182043.149267-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiyue Qiu <zhiyueqiu@microsoft.com>

Enable MANA RDMA on CDX by depending on the shared GDMA core and matching
the CDX auxiliary devices.

Map non-PCI userspace doorbells with pgprot_device() to match the CDX
transport, and report the Microsoft vendor ID directly.

Allocate missing DMA parameters before GDMA setup using managed memory.
Register a cleanup action to clear the device pointer before the memory
is freed.

Signed-off-by: Zhiyue Qiu <zhiyueqiu@microsoft.com>
Co-developed-by: Konstantin Taranov <kotaranov@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
Changes in v2:
- Allocate missing CDX DMA parameters before GDMA setup.

 drivers/infiniband/hw/mana/Kconfig            | 10 +++----
 drivers/infiniband/hw/mana/device.c           |  2 ++
 drivers/infiniband/hw/mana/main.c             |  9 ++++--
 .../net/ethernet/microsoft/mana/gdma_cdx.c    | 30 +++++++++++++++----
 4 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mana/Kconfig b/drivers/infiniband/hw/mana/Kconfig
index 546640657bac..6eae7fa91d95 100644
--- a/drivers/infiniband/hw/mana/Kconfig
+++ b/drivers/infiniband/hw/mana/Kconfig
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config MANA_INFINIBAND
 	tristate "Microsoft Azure Network Adapter support"
-	depends on NETDEVICES && ETHERNET && PCI && MICROSOFT_MANA
+	depends on NETDEVICES && ETHERNET && MICROSOFT_GDMA_CORE
 	help
 	  This driver provides low-level RDMA support for Microsoft Azure
-	  Network Adapter (MANA). MANA supports RDMA features that can be used
-	  for workloads (e.g. DPDK, MPI etc) that uses RDMA verbs to directly
-	  access hardware from user-mode processes in Microsoft Azure cloud
-	  environment.
+	  Network Adapter (MANA) on the PCI or CDX bus. MANA supports RDMA
+	  features that workloads such as DPDK and MPI can use to directly
+	  access hardware from user-mode processes in the Microsoft Azure
+	  cloud environment.
diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index 62c7803ca6c6..33e47490755f 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -257,6 +257,8 @@ static void mana_ib_remove(struct auxiliary_device *adev)
 static const struct auxiliary_device_id mana_id_table[] = {
 	{ .name = "mana.rdma", },
 	{ .name = "mana.eth", },
+	{ .name = "mana_cdx.rdma", },
+	{ .name = "mana_cdx.eth", },
 	{},
 };
 
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 858bbc325eb2..afb8fa002f73 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -572,7 +572,11 @@ int mana_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
 	pfn = (gc->phys_db_page_base +
 	       gc->db_page_size * mana_ucontext->doorbell) >>
 	      PAGE_SHIFT;
-	prot = pgprot_writecombine(vma->vm_page_prot);
+	/* Match the Device attributes used by the CDX transport. */
+	if (dev_is_pci(gc->dev))
+		prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		prot = pgprot_device(vma->vm_page_prot);
 
 	ret = rdma_user_mmap_io(ibcontext, vma, pfn, PAGE_SIZE, prot,
 				NULL);
@@ -623,14 +627,13 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
 			 struct ib_udata *uhw)
 {
 	struct mana_ib_dev *dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
-	struct pci_dev *pdev = to_pci_dev(mdev_to_gc(dev)->dev);
 	int err;
 
 	err = ib_no_udata_io(uhw);
 	if (err)
 		return err;
 
-	props->vendor_id = pdev->vendor;
+	props->vendor_id = PCI_VENDOR_ID_MICROSOFT;
 	props->vendor_part_id = dev->gdma_dev->dev_id.type;
 	props->max_mr_size = MANA_IB_MAX_MR_SIZE;
 	props->page_size_cap = dev->adapter_caps.page_size_cap;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
index 0d01e3d2f0d9..6c6ddc14ef7e 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/bitmap.h>
 #include <linux/cdx/cdx_bus.h>
+#include <linux/device.h>
 #include <linux/msi.h>
 #include <linux/xarray.h>
 
@@ -61,11 +62,8 @@ static int mana_cdx_setup_hwc_irqs(struct gdma_context *gc)
 		return err;
 	}
 
-	/* The PCI path also calls dma_set_max_seg_size(), but that is
-	 * deliberately omitted here: the CDX core does not attach a
-	 * dma_parms to the device, so the helper would only WARN, and MANA
-	 * never builds scatter-gather lists, so the limit is never read.
-	 */
+	dma_set_max_seg_size(gc->dev, UINT_MAX);
+	dma_set_seg_boundary(gc->dev, DMA_BIT_MASK(32));
 
 	err = cdx_enable_msi(cdx_dev);
 	if (err) {
@@ -196,6 +194,13 @@ static const struct gdma_bus_ops mana_cdx_bus_ops = {
 	.dev_reset		= mana_cdx_dev_reset,
 };
 
+static void mana_cdx_clear_dma_parms(void *data)
+{
+	struct device *dev = data;
+
+	dev->dma_parms = NULL;
+}
+
 static int mana_cdx_gd_probe(struct cdx_device *cdx_dev)
 {
 	struct gdma_context *gc;
@@ -241,6 +246,21 @@ static int mana_cdx_gd_probe(struct cdx_device *cdx_dev)
 	gc->bar0_va = bar0_va;
 	gc->dev = &cdx_dev->dev;
 	gc->bus_ops = &mana_cdx_bus_ops;
+	if (!gc->dev->dma_parms) {
+		gc->dev->dma_parms = devm_kzalloc(gc->dev,
+						  sizeof(*gc->dev->dma_parms),
+						  GFP_KERNEL);
+		if (!gc->dev->dma_parms) {
+			err = -ENOMEM;
+			goto unmap_bar;
+		}
+
+		/* Clear the pointer before devres frees the allocation. */
+		err = devm_add_action_or_reset(gc->dev, mana_cdx_clear_dma_parms,
+					       gc->dev);
+		if (err)
+			goto unmap_bar;
+	}
 
 	/* gc->is_pf is intentionally left clear: this device uses the VF
 	 * register layout, and the vPort and MAC filter registration that
-- 
2.43.0

