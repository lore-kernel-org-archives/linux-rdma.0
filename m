From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 02/37] treewide: Move dma_ops from struct dev_archdata into struct device
Date: Fri, 20 Jan 2017 13:04:02 -0800
Message-ID: <20170120210437.26389-3-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Woodhouse <dwmw2@infradead.org>, Juergen Gross <jgross@suse.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, x86@kernel.org
List-Id: linux-rdma@vger.kernel.org

Some but not all architectures provide set_dma_ops(). Move dma_ops
from struct dev_archdata into struct device such that it becomes
possible on all architectures to configure dma_ops per device.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>
Cc: x86@kernel.org
---
 arch/arm/include/asm/device.h            | 1 -
 arch/arm/include/asm/dma-mapping.h       | 6 +++---
 arch/arm64/include/asm/device.h          | 1 -
 arch/arm64/include/asm/dma-mapping.h     | 4 ++--
 arch/arm64/mm/dma-mapping.c              | 8 ++++----
 arch/m32r/include/asm/device.h           | 1 -
 arch/m32r/include/asm/dma-mapping.h      | 4 ++--
 arch/mips/include/asm/device.h           | 5 -----
 arch/mips/include/asm/dma-mapping.h      | 4 ++--
 arch/mips/pci/pci-octeon.c               | 2 +-
 arch/powerpc/include/asm/device.h        | 4 ----
 arch/powerpc/include/asm/dma-mapping.h   | 4 ++--
 arch/powerpc/kernel/dma.c                | 2 +-
 arch/powerpc/platforms/cell/iommu.c      | 2 +-
 arch/powerpc/platforms/pasemi/iommu.c    | 2 +-
 arch/powerpc/platforms/pasemi/setup.c    | 2 +-
 arch/powerpc/platforms/ps3/system-bus.c  | 4 ++--
 arch/powerpc/platforms/pseries/ibmebus.c | 2 +-
 arch/s390/include/asm/device.h           | 1 -
 arch/s390/include/asm/dma-mapping.h      | 4 ++--
 arch/s390/pci/pci.c                      | 2 +-
 arch/tile/include/asm/device.h           | 3 ---
 arch/tile/include/asm/dma-mapping.h      | 6 +++---
 arch/x86/include/asm/device.h            | 3 ---
 arch/x86/include/asm/dma-mapping.h       | 4 ++--
 arch/x86/kernel/pci-calgary_64.c         | 4 ++--
 arch/x86/pci/common.c                    | 2 +-
 arch/x86/pci/sta2x11-fixup.c             | 8 ++++----
 arch/xtensa/include/asm/device.h         | 4 ----
 arch/xtensa/include/asm/dma-mapping.h    | 4 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c    | 2 +-
 drivers/iommu/amd_iommu.c                | 6 +++---
 drivers/misc/mic/bus/mic_bus.c           | 2 +-
 drivers/misc/mic/bus/scif_bus.c          | 2 +-
 drivers/misc/mic/bus/vop_bus.c           | 2 +-
 include/linux/device.h                   | 1 +
 36 files changed, 48 insertions(+), 70 deletions(-)

diff --git a/arch/arm/include/asm/device.h b/arch/arm/include/asm/device.h
index d8a572f9c187..220ba207be91 100644
--- a/arch/arm/include/asm/device.h
+++ b/arch/arm/include/asm/device.h
@@ -7,7 +7,6 @@
 #define ASMARM_DEVICE_H
 
 struct dev_archdata {
-	const struct dma_map_ops	*dma_ops;
 #ifdef CONFIG_DMABOUNCE
 	struct dmabounce_device_info *dmabounce;
 #endif
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 1aabd781306f..312f4d0564d6 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -18,8 +18,8 @@ extern const struct dma_map_ops arm_coherent_dma_ops;
 
 static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 	return &arm_dma_ops;
 }
 
@@ -34,7 +34,7 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
 	BUG_ON(!dev);
-	dev->archdata.dma_ops = ops;
+	dev->dma_ops = ops;
 }
 
 #define HAVE_ARCH_DMA_SUPPORTED 1
diff --git a/arch/arm64/include/asm/device.h b/arch/arm64/include/asm/device.h
index 00c678cc31e1..73d5bab015eb 100644
--- a/arch/arm64/include/asm/device.h
+++ b/arch/arm64/include/asm/device.h
@@ -17,7 +17,6 @@
 #define __ASM_DEVICE_H
 
 struct dev_archdata {
-	const struct dma_map_ops *dma_ops;
 #ifdef CONFIG_IOMMU_API
 	void *iommu;			/* private IOMMU data */
 #endif
diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 1fedb43be712..58ae36cc3b60 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -29,8 +29,8 @@ extern const struct dma_map_ops dummy_dma_ops;
 
 static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 
 	/*
 	 * We expect no ISA devices, and all other DMA masters are expected to
diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index bcef6368d48f..dbab4c6c084b 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -837,7 +837,7 @@ static bool do_iommu_attach(struct device *dev, const struct iommu_ops *ops,
 		return false;
 	}
 
-	dev->archdata.dma_ops = &iommu_dma_ops;
+	dev->dma_ops = &iommu_dma_ops;
 	return true;
 }
 
@@ -941,7 +941,7 @@ static void __iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 
 void arch_teardown_dma_ops(struct device *dev)
 {
-	dev->archdata.dma_ops = NULL;
+	dev->dma_ops = NULL;
 }
 
 #else
@@ -955,8 +955,8 @@ static void __iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 			const struct iommu_ops *iommu, bool coherent)
 {
-	if (!dev->archdata.dma_ops)
-		dev->archdata.dma_ops = &swiotlb_dma_ops;
+	if (!dev->dma_ops)
+		dev->dma_ops = &swiotlb_dma_ops;
 
 	dev->archdata.dma_coherent = coherent;
 	__iommu_setup_dma_ops(dev, dma_base, size, iommu);
diff --git a/arch/m32r/include/asm/device.h b/arch/m32r/include/asm/device.h
index 7955a9799466..5203fc87f080 100644
--- a/arch/m32r/include/asm/device.h
+++ b/arch/m32r/include/asm/device.h
@@ -4,7 +4,6 @@
  * This file is released under the GPLv2
  */
 struct dev_archdata {
-	const struct dma_map_ops *dma_ops;
 };
 
 struct pdev_archdata {
diff --git a/arch/m32r/include/asm/dma-mapping.h b/arch/m32r/include/asm/dma-mapping.h
index 99c43d2f05dc..27b1597ac563 100644
--- a/arch/m32r/include/asm/dma-mapping.h
+++ b/arch/m32r/include/asm/dma-mapping.h
@@ -12,8 +12,8 @@
 
 static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 	return &dma_noop_ops;
 }
 
diff --git a/arch/mips/include/asm/device.h b/arch/mips/include/asm/device.h
index ebc5c1265473..6aa796f1081a 100644
--- a/arch/mips/include/asm/device.h
+++ b/arch/mips/include/asm/device.h
@@ -6,12 +6,7 @@
 #ifndef _ASM_MIPS_DEVICE_H
 #define _ASM_MIPS_DEVICE_H
 
-struct dma_map_ops;
-
 struct dev_archdata {
-	/* DMA operations on that device */
-	const struct dma_map_ops *dma_ops;
-
 #ifdef CONFIG_DMA_PERDEV_COHERENT
 	/* Non-zero if DMA is coherent with CPU caches */
 	bool dma_coherent;
diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
index b59b084a7569..dad3b09fe993 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -13,8 +13,8 @@ extern const struct dma_map_ops *mips_dma_map_ops;
 
 static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 	else
 		return mips_dma_map_ops;
 }
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index 308d051fc45c..9ee01936862e 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -167,7 +167,7 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 		pci_write_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, dconfig);
 	}
 
-	dev->dev.archdata.dma_ops = octeon_pci_dma_map_ops;
+	dev->dev.dma_ops = octeon_pci_dma_map_ops;
 
 	return 0;
 }
diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 49cbb0fca233..0245bfcaac32 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -6,7 +6,6 @@
 #ifndef _ASM_POWERPC_DEVICE_H
 #define _ASM_POWERPC_DEVICE_H
 
-struct dma_map_ops;
 struct device_node;
 #ifdef CONFIG_PPC64
 struct pci_dn;
@@ -20,9 +19,6 @@ struct iommu_table;
  * drivers/macintosh/macio_asic.c
  */
 struct dev_archdata {
-	/* DMA operations on that device */
-	const struct dma_map_ops	*dma_ops;
-
 	/*
 	 * These two used to be a union. However, with the hybrid ops we need
 	 * both so here we store both a DMA offset for direct mappings and
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 2ec3eadf336f..59fbd4abcbf8 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -88,12 +88,12 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 	if (unlikely(dev == NULL))
 		return NULL;
 
-	return dev->archdata.dma_ops;
+	return dev->dma_ops;
 }
 
 static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
-	dev->archdata.dma_ops = ops;
+	dev->dma_ops = ops;
 }
 
 /*
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 03b98f1f98ec..41c749586bd2 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -33,7 +33,7 @@ static u64 __maybe_unused get_pfn_limit(struct device *dev)
 	struct dev_archdata __maybe_unused *sd = &dev->archdata;
 
 #ifdef CONFIG_SWIOTLB
-	if (sd->max_direct_dma_addr && sd->dma_ops == &swiotlb_dma_ops)
+	if (sd->max_direct_dma_addr && dev->dma_ops == &swiotlb_dma_ops)
 		pfn = min_t(u64, pfn, sd->max_direct_dma_addr >> PAGE_SHIFT);
 #endif
 
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index e1413e69e5fe..71b995bbcae0 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -692,7 +692,7 @@ static int cell_of_bus_notify(struct notifier_block *nb, unsigned long action,
 		return 0;
 
 	/* We use the PCI DMA ops */
-	dev->archdata.dma_ops = get_pci_dma_ops();
+	dev->dma_ops = get_pci_dma_ops();
 
 	cell_dma_dev_setup(dev);
 
diff --git a/arch/powerpc/platforms/pasemi/iommu.c b/arch/powerpc/platforms/pasemi/iommu.c
index e74adc4e7fd8..7fec04de27fc 100644
--- a/arch/powerpc/platforms/pasemi/iommu.c
+++ b/arch/powerpc/platforms/pasemi/iommu.c
@@ -186,7 +186,7 @@ static void pci_dma_dev_setup_pasemi(struct pci_dev *dev)
 	 */
 	if (dev->vendor == 0x1959 && dev->device == 0xa007 &&
 	    !firmware_has_feature(FW_FEATURE_LPAR)) {
-		dev->dev.archdata.dma_ops = &dma_direct_ops;
+		dev->dev.dma_ops = &dma_direct_ops;
 		/*
 		 * Set the coherent DMA mask to prevent the iommu
 		 * being used unnecessarily
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 3182400cf48f..c4a3e93dc324 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -363,7 +363,7 @@ static int pcmcia_notify(struct notifier_block *nb, unsigned long action,
 		return 0;
 
 	/* We use the direct ops for localbus */
-	dev->archdata.dma_ops = &dma_direct_ops;
+	dev->dma_ops = &dma_direct_ops;
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index c81450d98794..2d2e5f80a3d3 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -756,11 +756,11 @@ int ps3_system_bus_device_register(struct ps3_system_bus_device *dev)
 
 	switch (dev->dev_type) {
 	case PS3_DEVICE_TYPE_IOC0:
-		dev->core.archdata.dma_ops = &ps3_ioc0_dma_ops;
+		dev->core.dma_ops = &ps3_ioc0_dma_ops;
 		dev_set_name(&dev->core, "ioc0_%02x", ++dev_ioc0_count);
 		break;
 	case PS3_DEVICE_TYPE_SB:
-		dev->core.archdata.dma_ops = &ps3_sb_dma_ops;
+		dev->core.dma_ops = &ps3_sb_dma_ops;
 		dev_set_name(&dev->core, "sb_%02x", ++dev_sb_count);
 
 		break;
diff --git a/arch/powerpc/platforms/pseries/ibmebus.c b/arch/powerpc/platforms/pseries/ibmebus.c
index 2e36a0b8944a..99a6bf7f3bcf 100644
--- a/arch/powerpc/platforms/pseries/ibmebus.c
+++ b/arch/powerpc/platforms/pseries/ibmebus.c
@@ -169,7 +169,7 @@ static int ibmebus_create_device(struct device_node *dn)
 		return -ENOMEM;
 
 	dev->dev.bus = &ibmebus_bus_type;
-	dev->dev.archdata.dma_ops = &ibmebus_dma_ops;
+	dev->dev.dma_ops = &ibmebus_dma_ops;
 
 	ret = of_device_add(dev);
 	if (ret)
diff --git a/arch/s390/include/asm/device.h b/arch/s390/include/asm/device.h
index 7955a9799466..5203fc87f080 100644
--- a/arch/s390/include/asm/device.h
+++ b/arch/s390/include/asm/device.h
@@ -4,7 +4,6 @@
  * This file is released under the GPLv2
  */
 struct dev_archdata {
-	const struct dma_map_ops *dma_ops;
 };
 
 struct pdev_archdata {
diff --git a/arch/s390/include/asm/dma-mapping.h b/arch/s390/include/asm/dma-mapping.h
index 2776d205b1ff..a872027d0c1b 100644
--- a/arch/s390/include/asm/dma-mapping.h
+++ b/arch/s390/include/asm/dma-mapping.h
@@ -14,8 +14,8 @@ extern const struct dma_map_ops s390_pci_dma_ops;
 
 static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 	return &dma_noop_ops;
 }
 
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 38e17d4d9884..82abef8b8574 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -641,7 +641,7 @@ int pcibios_add_device(struct pci_dev *pdev)
 	int i;
 
 	pdev->dev.groups = zpci_attr_groups;
-	pdev->dev.archdata.dma_ops = &s390_pci_dma_ops;
+	pdev->dev.dma_ops = &s390_pci_dma_ops;
 	zpci_map_resources(pdev);
 
 	for (i = 0; i < PCI_BAR_COUNT; i++) {
diff --git a/arch/tile/include/asm/device.h b/arch/tile/include/asm/device.h
index 25f23ac7d361..1cf45422a0df 100644
--- a/arch/tile/include/asm/device.h
+++ b/arch/tile/include/asm/device.h
@@ -17,9 +17,6 @@
 #define _ASM_TILE_DEVICE_H
 
 struct dev_archdata {
-	/* DMA operations on that device */
-        const struct dma_map_ops	*dma_ops;
-
 	/* Offset of the DMA address from the PA. */
 	dma_addr_t		dma_offset;
 
diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index 4a06cc75b856..c0620697eaad 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -31,8 +31,8 @@ extern const struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
 
 static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 	else
 		return tile_dma_map_ops;
 }
@@ -61,7 +61,7 @@ static inline void dma_mark_clean(void *addr, size_t size) {}
 
 static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
-	dev->archdata.dma_ops = ops;
+	dev->dma_ops = ops;
 }
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index b2d0b4ced7e3..1b3ef26e77df 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -2,9 +2,6 @@
 #define _ASM_X86_DEVICE_H
 
 struct dev_archdata {
-#ifdef CONFIG_X86_DEV_DMA_OPS
-	const struct dma_map_ops *dma_ops;
-#endif
 #if defined(CONFIG_INTEL_IOMMU) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 5e4772886a1e..94b5b96966cb 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -32,10 +32,10 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 #ifndef CONFIG_X86_DEV_DMA_OPS
 	return dma_ops;
 #else
-	if (unlikely(!dev) || !dev->archdata.dma_ops)
+	if (unlikely(!dev) || !dev->dma_ops)
 		return dma_ops;
 	else
-		return dev->archdata.dma_ops;
+		return dev->dma_ops;
 #endif
 }
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 17f180148c80..5070320780c6 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1177,7 +1177,7 @@ static int __init calgary_init(void)
 		tbl = find_iommu_table(&dev->dev);
 
 		if (translation_enabled(tbl))
-			dev->dev.archdata.dma_ops = &calgary_dma_ops;
+			dev->dev.dma_ops = &calgary_dma_ops;
 	}
 
 	return ret;
@@ -1201,7 +1201,7 @@ static int __init calgary_init(void)
 		calgary_disable_translation(dev);
 		calgary_free_bus(dev);
 		pci_dev_put(dev); /* Undo calgary_init_one()'s pci_dev_get() */
-		dev->dev.archdata.dma_ops = NULL;
+		dev->dev.dma_ops = NULL;
 	} while (1);
 
 	return ret;
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index a4fdfa7dcc1b..0cb52ae0a8f0 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -667,7 +667,7 @@ static void set_dma_domain_ops(struct pci_dev *pdev)
 	spin_lock(&dma_domain_list_lock);
 	list_for_each_entry(domain, &dma_domain_list, node) {
 		if (pci_domain_nr(pdev->bus) == domain->domain_nr) {
-			pdev->dev.archdata.dma_ops = domain->dma_ops;
+			pdev->dev.dma_ops = domain->dma_ops;
 			break;
 		}
 	}
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index aa3828823170..ec008e800b45 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -203,7 +203,7 @@ static void sta2x11_setup_pdev(struct pci_dev *pdev)
 		return;
 	pci_set_consistent_dma_mask(pdev, STA2X11_AMBA_SIZE - 1);
 	pci_set_dma_mask(pdev, STA2X11_AMBA_SIZE - 1);
-	pdev->dev.archdata.dma_ops = &sta2x11_dma_ops;
+	pdev->dev.dma_ops = &sta2x11_dma_ops;
 
 	/* We must enable all devices as master, for audio DMA to work */
 	pci_set_master(pdev);
@@ -223,7 +223,7 @@ bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	struct sta2x11_mapping *map;
 
-	if (dev->archdata.dma_ops != &sta2x11_dma_ops) {
+	if (dev->dma_ops != &sta2x11_dma_ops) {
 		if (!dev->dma_mask)
 			return false;
 		return addr + size - 1 <= *dev->dma_mask;
@@ -247,7 +247,7 @@ bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
  */
 dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
 {
-	if (dev->archdata.dma_ops != &sta2x11_dma_ops)
+	if (dev->dma_ops != &sta2x11_dma_ops)
 		return paddr;
 	return p2a(paddr, to_pci_dev(dev));
 }
@@ -259,7 +259,7 @@ dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
  */
 phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 {
-	if (dev->archdata.dma_ops != &sta2x11_dma_ops)
+	if (dev->dma_ops != &sta2x11_dma_ops)
 		return daddr;
 	return a2p(daddr, to_pci_dev(dev));
 }
diff --git a/arch/xtensa/include/asm/device.h b/arch/xtensa/include/asm/device.h
index a77d45d39f35..1deeb8ebbb1b 100644
--- a/arch/xtensa/include/asm/device.h
+++ b/arch/xtensa/include/asm/device.h
@@ -6,11 +6,7 @@
 #ifndef _ASM_XTENSA_DEVICE_H
 #define _ASM_XTENSA_DEVICE_H
 
-struct dma_map_ops;
-
 struct dev_archdata {
-	/* DMA operations on that device */
-	const struct dma_map_ops *dma_ops;
 };
 
 struct pdev_archdata {
diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
index 50d23106cce0..9eecfc3c5dc4 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -22,8 +22,8 @@ extern const struct dma_map_ops xtensa_dma_map_ops;
 
 static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 	else
 		return &xtensa_dma_map_ops;
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d21ba9d857c3..dfc24f19178b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2465,7 +2465,7 @@ static void srpt_add_one(struct ib_device *device)
 	int i;
 
 	pr_debug("device = %p, device->dma_ops = %p\n", device,
-		 device->dma_ops);
+		 device->dma_device->dma_ops);
 
 	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
 	if (!sdev)
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3703fb9db419..f7b86679bafe 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -515,7 +515,7 @@ static void iommu_uninit_device(struct device *dev)
 	iommu_group_remove_device(dev);
 
 	/* Remove dma-ops */
-	dev->archdata.dma_ops = NULL;
+	dev->dma_ops = NULL;
 
 	/*
 	 * We keep dev_data around for unplugged devices and reuse it when the
@@ -2164,7 +2164,7 @@ static int amd_iommu_add_device(struct device *dev)
 				dev_name(dev));
 
 		iommu_ignore_device(dev);
-		dev->archdata.dma_ops = &nommu_dma_ops;
+		dev->dma_ops = &nommu_dma_ops;
 		goto out;
 	}
 	init_iommu_group(dev);
@@ -2181,7 +2181,7 @@ static int amd_iommu_add_device(struct device *dev)
 	if (domain->type == IOMMU_DOMAIN_IDENTITY)
 		dev_data->passthrough = true;
 	else
-		dev->archdata.dma_ops = &amd_iommu_dma_ops;
+		dev->dma_ops = &amd_iommu_dma_ops;
 
 out:
 	iommu_completion_wait(iommu);
diff --git a/drivers/misc/mic/bus/mic_bus.c b/drivers/misc/mic/bus/mic_bus.c
index c4b27a25662a..77b16ca66846 100644
--- a/drivers/misc/mic/bus/mic_bus.c
+++ b/drivers/misc/mic/bus/mic_bus.c
@@ -158,7 +158,7 @@ mbus_register_device(struct device *pdev, int id, const struct dma_map_ops *dma_
 	mbdev->dev.parent = pdev;
 	mbdev->id.device = id;
 	mbdev->id.vendor = MBUS_DEV_ANY_ID;
-	mbdev->dev.archdata.dma_ops = dma_ops;
+	mbdev->dev.dma_ops = dma_ops;
 	mbdev->dev.dma_mask = &mbdev->dev.coherent_dma_mask;
 	dma_set_mask(&mbdev->dev, DMA_BIT_MASK(64));
 	mbdev->dev.release = mbus_release_dev;
diff --git a/drivers/misc/mic/bus/scif_bus.c b/drivers/misc/mic/bus/scif_bus.c
index e5d377e97c86..a444db5f61fe 100644
--- a/drivers/misc/mic/bus/scif_bus.c
+++ b/drivers/misc/mic/bus/scif_bus.c
@@ -154,7 +154,7 @@ scif_register_device(struct device *pdev, int id, const struct dma_map_ops *dma_
 	sdev->dev.parent = pdev;
 	sdev->id.device = id;
 	sdev->id.vendor = SCIF_DEV_ANY_ID;
-	sdev->dev.archdata.dma_ops = dma_ops;
+	sdev->dev.dma_ops = dma_ops;
 	sdev->dev.release = scif_release_dev;
 	sdev->hw_ops = hw_ops;
 	sdev->dnode = dnode;
diff --git a/drivers/misc/mic/bus/vop_bus.c b/drivers/misc/mic/bus/vop_bus.c
index e3caa6c53922..fd7f2a6049f8 100644
--- a/drivers/misc/mic/bus/vop_bus.c
+++ b/drivers/misc/mic/bus/vop_bus.c
@@ -154,7 +154,7 @@ vop_register_device(struct device *pdev, int id,
 	vdev->dev.parent = pdev;
 	vdev->id.device = id;
 	vdev->id.vendor = VOP_DEV_ANY_ID;
-	vdev->dev.archdata.dma_ops = dma_ops;
+	vdev->dev.dma_ops = dma_ops;
 	vdev->dev.dma_mask = &vdev->dev.coherent_dma_mask;
 	dma_set_mask(&vdev->dev, DMA_BIT_MASK(64));
 	vdev->dev.release = vop_release_dev;
diff --git a/include/linux/device.h b/include/linux/device.h
index 491b4c0ca633..46a567261ccc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -921,6 +921,7 @@ struct device {
 #ifdef CONFIG_NUMA
 	int		numa_node;	/* NUMA node this device is close to */
 #endif
+	const struct dma_map_ops *dma_ops;
 	u64		*dma_mask;	/* dma mask (if dma'able device) */
 	u64		coherent_dma_mask;/* Like dma_mask, but for
 					     alloc_coherent mappings as
-- 
2.11.0
