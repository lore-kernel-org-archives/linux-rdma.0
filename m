Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7EC51C04E;
	Thu, 24 Sep 2026 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271103; cv=none; b=gLIIasEBqMlt55BUeiwZrJAdPl6oueyZxoCX9UHJc4RHy03F0MNfNsEg51QuEpa9Yt/vkOrBdX+m3wN8TU2psXt28Hn5N4cA6pMGizhlTTA2D1c5n7S17heDrUAsec0GwMEzPN/7aXma3uQH/F/0pqHuVLel5GYt7XT+kzVe5v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271103; c=relaxed/simple;
	bh=HCJr9ywfnyuFa2f4PznihLPwS7Wv27iECo9BmFoKNEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDeTTEA0a/sIpx5OlQkOjXWtdLStWWPOw9yB2KxWc8vbuC+Os9HpVa2MMRVMbj2GfOa3N4bfkiP1YTw+2AcfnRT2HjYPeSh4MnRsowp7Pwj3oF8IOTwyXk07y1dH7OmC/CTd3YoSBqi+x8I5+/xfB/OPHRj6QogLKf9yrjpbLBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FUTC6UoZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FUTC6UoZ"
Received: from CPC-mawas-YGKSX.localdomain (unknown [70.37.26.38])
	by linux.microsoft.com (Postfix) with ESMTPSA id 33EA820B7169;
	Thu, 24 Sep 2026 10:30:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 33EA820B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790271051;
	bh=jSoWeMh1TG73DB7ZmwJ7G7GJXYotzMz9IN4qQOOC0Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUTC6UoZ86ZOjkW1neA0X4xnFBgx4oqpSPQcr1YIXgixHJ7nsVy2TRldt7IdwT/IF
	 x59CRNFEO1cx//NEMkOYxSvfXKukAj+Fv0FU0nhDOMSjMschD8mPkqkS24SzKqcJ4J
	 4DrUMu+dlsTihTddPIVUqHB1TNh8z4Yqgm3oyvrA=
From: Manish Awasthi <mawasthi@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com
Cc: horms@kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	nipun.gupta@amd.com,
	nikhil.agarwal@amd.com,
	gargaditya@linux.microsoft.com,
	ernis@linux.microsoft.com,
	kees@kernel.org,
	paulros@microsoft.com,
	mawasthi@microsoft.com
Subject: [PATCH net-next 4/4] net: mana: Add support for CDX device ID 0x00C2
Date: Thu, 24 Sep 2026 17:30:54 +0000
Message-ID: <20260924173054.589291-5-mawasthi@linux.microsoft.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the CDX transport as mana_cdx.ko for device ID 0x00C2, using the shared
gdma_core.ko. Allocate interrupts at probe, limit queues to available
vectors, use 32-bit DMA, and keep CDX auxiliary devices separate from PCI.

Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/Kconfig        |  14 +
 drivers/net/ethernet/microsoft/mana/Makefile  |   3 +
 .../net/ethernet/microsoft/mana/gdma_cdx.c    | 340 ++++++++++++++++++
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c |   5 +-
 include/net/mana/gdma.h                       |   4 +
 6 files changed, 365 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_cdx.c

diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
index ee5bc1c1bf59..7e4b77f7f29c 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -35,4 +35,18 @@ config MICROSOFT_MANA
 	  To compile this driver as a module, choose M here.
 	  The module will be called mana.
 
+config MICROSOFT_MANA_CDX
+	tristate "Microsoft Azure Network Adapter (MANA) support for the CDX bus"
+	depends on CDX_BUS
+	depends on GENERIC_MSI_IRQ
+	depends on 64BIT && !CPU_BIG_ENDIAN
+	select MICROSOFT_GDMA_CORE
+	help
+	  This driver supports the Microsoft Azure Network Adapter (MANA) on
+	  systems where it is integrated into the SoC and presented on the CDX
+	  bus rather than discovered over PCI.
+
+	  To compile this driver as a module, choose M here.
+	  The module will be called mana_cdx.
+
 endif #NET_VENDOR_MICROSOFT
diff --git a/drivers/net/ethernet/microsoft/mana/Makefile b/drivers/net/ethernet/microsoft/mana/Makefile
index 72c03fb6e441..64926015f734 100644
--- a/drivers/net/ethernet/microsoft/mana/Makefile
+++ b/drivers/net/ethernet/microsoft/mana/Makefile
@@ -8,3 +8,6 @@ gdma_core-y := gdma_main.o shm_channel.o hw_channel.o mana_en.o mana_ethtool.o \
 
 obj-$(CONFIG_MICROSOFT_MANA) += mana.o
 mana-y := gdma_pci.o
+
+obj-$(CONFIG_MICROSOFT_MANA_CDX) += mana_cdx.o
+mana_cdx-y := gdma_cdx.o
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
new file mode 100644
index 000000000000..0d01e3d2f0d9
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2025, Microsoft Corporation. */
+#include <linux/module.h>
+#include <linux/bitmap.h>
+#include <linux/cdx/cdx_bus.h>
+#include <linux/msi.h>
+#include <linux/xarray.h>
+
+#include <net/mana/mana.h>
+
+#define MANA_CDX_GDMA_REGS_SIZE	(GDMA_REG_SHM_OFFSET + sizeof(u64))
+
+static int mana_cdx_msix_virq(struct gdma_context *gc, int msi)
+{
+	unsigned int virq = msi_get_virq(gc->dev, msi);
+
+	/* CDX allocates its whole vector pool in mana_cdx_setup_hwc_irqs(),
+	 * so a vector with no Linux IRQ was never part of that pool.
+	 */
+	return virq ? virq : -EINVAL;
+}
+
+static int mana_cdx_dev_reset(struct gdma_context *gc)
+{
+	return cdx_dev_reset(gc->dev);
+}
+
+static int mana_cdx_setup_hwc_irqs(struct gdma_context *gc)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(gc->dev);
+	struct gdma_irq_context *gic;
+	unsigned int max_irqs;
+	int nvec;
+	int err, i = 0, j;
+
+	max_irqs = cdx_dev->num_msi;
+
+	/* Need 1 IRQ for HWC and at least 1 for the data path queues */
+	if (max_irqs < 2) {
+		dev_err(&cdx_dev->dev, "Not enough MSI vectors: %u\n",
+			max_irqs);
+		return -ENOSPC;
+	}
+
+	/* Constrain the device to 32-bit DMA addresses, for both the MSI
+	 * doorbells and the data path buffers, and never widen it afterwards.
+	 *
+	 * The MSI doorbell address has to land within the low 4GB. The data
+	 * path carries a second constraint: the device does not perform
+	 * writes to the final page of the 48-bit IOVA window, and
+	 * iommu_dma_alloc_iova() allocates downwards from the top of that
+	 * window, so the first queue created lands on the unusable page and
+	 * its event queue stalls permanently. PCI devices are shielded from
+	 * this by the low-4GB first attempt in iommu_dma_alloc_iova(), but
+	 * that attempt is gated on dev_is_pci() and CDX devices do not
+	 * qualify.
+	 */
+	err = dma_set_mask_and_coherent(gc->dev, DMA_BIT_MASK(32));
+	if (err) {
+		dev_err(&cdx_dev->dev, "Failed to set 32-bit DMA mask\n");
+		return err;
+	}
+
+	/* The PCI path also calls dma_set_max_seg_size(), but that is
+	 * deliberately omitted here: the CDX core does not attach a
+	 * dma_parms to the device, so the helper would only WARN, and MANA
+	 * never builds scatter-gather lists, so the limit is never read.
+	 */
+
+	err = cdx_enable_msi(cdx_dev);
+	if (err) {
+		dev_err(&cdx_dev->dev, "Failed to enable MSI\n");
+		return err;
+	}
+
+	err = msi_domain_alloc_irqs(gc->dev, MSI_DEFAULT_DOMAIN, max_irqs);
+	if (err) {
+		dev_err(&cdx_dev->dev, "Failed to alloc MSI IRQs\n");
+		cdx_disable_msi(cdx_dev);
+		return err;
+	}
+
+	nvec = max_irqs;
+
+	xa_init(&gc->irq_contexts);
+
+	/* No IRQ affinity hint is applied here. The PCI transport spreads its
+	 * vectors over the NUMA node local to the device; the CDX platforms
+	 * this driver targets are single-node, so there is nothing to spread
+	 * over. Affinity management can be added when a multi-node CDX host
+	 * exists to validate it against.
+	 */
+	for (i = 0; i < nvec; i++) {
+		int msi = i;
+
+		gic = mana_gd_get_gic(gc, false, &msi);
+		if (IS_ERR(gic)) {
+			err = PTR_ERR(gic);
+			goto free_irq;
+		}
+	}
+
+	gc->max_num_msix = nvec;
+	gc->num_msix_usable = nvec;
+
+	/* CDX sizes its MSI pool at probe time and cannot grow it later, so
+	 * never share vectors: vector 0 is reserved for the HWC and each of
+	 * the remaining nvec - 1 vectors backs exactly one EQ. That bounds
+	 * the queue count at nvec - 1 and guarantees the HWC vector is never
+	 * handed out to a data queue.
+	 */
+	gc->msi_sharing = false;
+
+	gc->msi_bitmap = bitmap_zalloc(nvec, GFP_KERNEL);
+	if (!gc->msi_bitmap) {
+		err = -ENOMEM;
+		goto free_irq;
+	}
+
+	/* Reserve the HWC vector */
+	set_bit(0, gc->msi_bitmap);
+
+	return 0;
+
+free_irq:
+	for (j = i - 1; j >= 0; j--)
+		mana_gd_put_gic(gc, false, j);
+
+	xa_destroy(&gc->irq_contexts);
+	msi_domain_free_irqs_all(gc->dev, MSI_DEFAULT_DOMAIN);
+	cdx_disable_msi(cdx_dev);
+	return err;
+}
+
+static void mana_cdx_remove_irqs(struct gdma_context *gc)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(gc->dev);
+	int i;
+
+	if (gc->max_num_msix < 1)
+		return;
+
+	for (i = 0; i < gc->max_num_msix; i++) {
+		if (!xa_load(&gc->irq_contexts, i))
+			continue;
+
+		mana_gd_put_gic(gc, false, i);
+	}
+
+	WARN_ON(!xa_empty(&gc->irq_contexts));
+
+	xa_destroy(&gc->irq_contexts);
+	msi_domain_free_irqs_all(gc->dev, MSI_DEFAULT_DOMAIN);
+	cdx_disable_msi(cdx_dev);
+
+	bitmap_free(gc->msi_bitmap);
+	gc->msi_bitmap = NULL;
+	gc->max_num_msix = 0;
+	gc->num_msix_usable = 0;
+}
+
+static int mana_cdx_setup_remaining_irqs(struct gdma_context *gc)
+{
+	unsigned int max_queues_vport;
+
+	/* mana_gd_query_max_resources() may turn MSI sharing back on and round
+	 * the per-vPort queue count up to MANA_DEF_NUM_QUEUES. CDX sizes its
+	 * vector pool at probe time and cannot grow it later, and the HWC
+	 * vector must stay private, so give every vPort a private slice of the
+	 * remaining vectors instead. gc->max_num_queues is already capped at
+	 * num_msix_usable - 1 by the core.
+	 */
+	gc->msi_sharing = false;
+	max_queues_vport = (gc->num_msix_usable - 1) / gc->num_ports;
+	if (!max_queues_vport) {
+		dev_err(gc->dev, "%u MSI vectors cannot serve %u vPorts\n",
+			gc->num_msix_usable, gc->num_ports);
+		return -ENOSPC;
+	}
+
+	gc->max_num_queues_vport = min(gc->max_num_queues, max_queues_vport);
+
+	dev_dbg(gc->dev, "%u MSI vectors, %u vPorts, %u queues, no MSI sharing\n",
+		gc->num_msix_usable, gc->num_ports, gc->max_num_queues_vport);
+
+	return 0;
+}
+
+static const struct gdma_bus_ops mana_cdx_bus_ops = {
+	.bus_name		= "cdx",
+	.adev_prefix		= "mana_cdx",
+	.msix_virq		= mana_cdx_msix_virq,
+	.setup_hwc_irqs		= mana_cdx_setup_hwc_irqs,
+	.setup_remaining_irqs	= mana_cdx_setup_remaining_irqs,
+	.remove_irqs		= mana_cdx_remove_irqs,
+	.dev_reset		= mana_cdx_dev_reset,
+};
+
+static int mana_cdx_gd_probe(struct cdx_device *cdx_dev)
+{
+	struct gdma_context *gc;
+	void __iomem *bar0_va;
+	int err;
+
+	/* Each port has 2 CQs, each CQ has at most 1 EQE at a time */
+	BUILD_BUG_ON(2 * MAX_PORTS_IN_MANA_DEV * GDMA_EQE_SIZE > EQ_SIZE);
+
+	err = cdx_dev_reset(&cdx_dev->dev);
+	if (err)
+		return err;
+
+	err = cdx_set_master(cdx_dev);
+	if (err)
+		return err;
+
+	gc = vzalloc(sizeof(*gc));
+	if (!gc) {
+		err = -ENOMEM;
+		goto clear_master;
+	}
+
+	mutex_init(&gc->eq_test_event_mutex);
+	mutex_init(&gc->gic_mutex);
+	dev_set_drvdata(&cdx_dev->dev, gc);
+	gc->bar0_pa = cdx_resource_start(cdx_dev, 0);
+	gc->bar0_size = cdx_resource_len(cdx_dev, 0);
+	if (gc->bar0_size < MANA_CDX_GDMA_REGS_SIZE) {
+		dev_err(&cdx_dev->dev, "BAR0 size %#llx is too small\n",
+			(u64)gc->bar0_size);
+		err = -EINVAL;
+		goto free_gc;
+	}
+
+	bar0_va = ioremap(gc->bar0_pa, gc->bar0_size);
+	if (!bar0_va) {
+		err = -ENOMEM;
+		goto free_gc;
+	}
+
+	gc->numa_node = dev_to_node(&cdx_dev->dev);
+	gc->bar0_va = bar0_va;
+	gc->dev = &cdx_dev->dev;
+	gc->bus_ops = &mana_cdx_bus_ops;
+
+	/* gc->is_pf is intentionally left clear: this device uses the VF
+	 * register layout, and the vPort and MAC filter registration that
+	 * is_pf selects is not required on this bus.
+	 */
+
+	err = mana_gd_setup(gc);
+	if (err)
+		goto unmap_bar;
+
+	err = mana_probe(&gc->mana, false);
+	if (err)
+		goto cleanup_gd;
+
+	err = mana_rdma_probe(&gc->mana_ib);
+	if (err)
+		goto remove_mana;
+
+	/* If a hardware reset event arrived over HWC during probe, roll back:
+	 * the device state the rest of probe observed is no longer valid.
+	 */
+	if (test_and_set_bit(GC_PROBE_SUCCEEDED, &gc->flags)) {
+		err = -EPROTO;
+		goto remove_rdma;
+	}
+
+	return 0;
+
+remove_rdma:
+	mana_rdma_remove(&gc->mana_ib);
+remove_mana:
+	mana_remove(&gc->mana, false);
+cleanup_gd:
+	mana_gd_cleanup(gc);
+unmap_bar:
+	iounmap(bar0_va);
+free_gc:
+	dev_set_drvdata(&cdx_dev->dev, NULL);
+	vfree(gc);
+clear_master:
+	cdx_clear_master(cdx_dev);
+	return err;
+}
+
+static int mana_cdx_gd_remove(struct cdx_device *cdx_dev)
+{
+	struct gdma_context *gc = dev_get_drvdata(&cdx_dev->dev);
+
+	mana_rdma_remove(&gc->mana_ib);
+	mana_remove(&gc->mana, false);
+
+	mana_gd_cleanup(gc);
+	cdx_clear_master(cdx_dev);
+
+	iounmap(gc->bar0_va);
+
+	dev_set_drvdata(&cdx_dev->dev, NULL);
+	vfree(gc);
+	return 0;
+}
+
+/* Quiesce the device for kexec. This is also called upon reboot/shutdown. */
+static void mana_cdx_gd_shutdown(struct cdx_device *cdx_dev)
+{
+	struct gdma_context *gc = dev_get_drvdata(&cdx_dev->dev);
+
+	mana_rdma_remove(&gc->mana_ib);
+	mana_remove(&gc->mana, true);
+
+	mana_gd_cleanup(gc);
+	cdx_clear_master(cdx_dev);
+}
+
+#define CDX_VENDOR_ID_MICROSOFT 0x1414
+static const struct cdx_device_id mana_cdx_table[] = {
+	{ CDX_DEVICE(CDX_VENDOR_ID_MICROSOFT, MANA_CDX_DEVICE_ID) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(cdx, mana_cdx_table);
+
+static struct cdx_driver gdma_cdx_driver = {
+	.match_id_table	= mana_cdx_table,
+	.probe		= mana_cdx_gd_probe,
+	.remove		= mana_cdx_gd_remove,
+	.shutdown	= mana_cdx_gd_shutdown,
+	.driver	= {
+		.name	= "mana_cdx",
+	},
+};
+
+module_driver(gdma_cdx_driver, cdx_driver_register, cdx_driver_unregister);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("Microsoft Azure Network Adapter driver for the CDX bus");
+MODULE_IMPORT_NS("CDX_BUS");
+MODULE_IMPORT_NS("NET_MANA");
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
index 92a1e66e18b7..ed8925296c8a 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -619,6 +619,7 @@ static void mana_pci_remove_irqs(struct gdma_context *gc)
 
 static const struct gdma_bus_ops mana_pci_bus_ops = {
 	.bus_name		= "pci",
+	.adev_prefix		= "mana",
 	.msix_can_alloc_dyn	= mana_pci_msix_can_alloc_dyn,
 	.msix_virq		= mana_pci_msix_virq,
 	.msix_alloc_at		= mana_pci_msix_alloc_at,
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 16a9d192c099..2ba48a1c4b15 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3957,8 +3957,9 @@ static int add_adev(struct gdma_dev *gd, const char *name)
 
 	/* madev is owned by the auxiliary device */
 	madev = NULL;
-	/* Keep the established mana.{eth,rdma} auxiliary match names. */
-	ret = __auxiliary_device_add(adev, "mana");
+	/* Keep match names independent of the common module's name. */
+	ret = __auxiliary_device_add(adev,
+				     gd->gdma_context->bus_ops->adev_prefix);
 	if (ret)
 		goto add_fail;
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index cdec5558304f..c610fc1067e0 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -432,6 +432,7 @@ struct gdma_context;
  * instance in gdma_context.bus_ops at probe time.
  *
  * @bus_name: Bus token used to build the per-vector IRQ names.
+ * @adev_prefix: Prefix used for auxiliary-device match names.
  * @msix_can_alloc_dyn: True if the bus can allocate MSI-X vectors after
  *	probe time. Buses that size their vector pool at probe and cannot
  *	grow it later leave this NULL.
@@ -459,6 +460,7 @@ struct gdma_context;
  */
 struct gdma_bus_ops {
 	const char *bus_name;
+	const char *adev_prefix;
 	bool (*msix_can_alloc_dyn)(struct gdma_context *gc);
 	int (*msix_virq)(struct gdma_context *gc, int msi);
 	int (*msix_alloc_at)(struct gdma_context *gc, int *msi);
@@ -684,6 +686,8 @@ struct gdma_eqe {
 #define MANA_PF2_DEVICE_ID 0x00C1
 #define MANA_VF_DEVICE_ID 0x00BA
 
+#define MANA_CDX_DEVICE_ID 0x00C2
+
 struct gdma_posted_wqe_info {
 	u32 wqe_size_in_bu;
 };
-- 
2.54.0
