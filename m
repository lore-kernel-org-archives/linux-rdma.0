From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 01/37] treewide: Constify most dma_map_ops structures
Date: Fri, 20 Jan 2017 13:04:01 -0800
Message-ID: <20170120210437.26389-2-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Most dma_map_ops structures are never modified. Constify these
structures such that these can be write-protected. This patch
has been generated as follows:

git grep -l 'struct dma_map_ops' |
  xargs -d\\n sed -i \
    -e 's/struct dma_map_ops/const struct dma_map_ops/g' \
    -e 's/const struct dma_map_ops {/struct dma_map_ops {/g' \
    -e 's/^const struct dma_map_ops;$/struct dma_map_ops;/' \
    -e 's/const const struct dma_map_ops /const struct dma_map_ops /g';
sed -i -e 's/const \(struct dma_map_ops intel_dma_ops\)/\1/' \
  $(git grep -l 'struct dma_map_ops intel_dma_ops');
sed -i -e 's/const \(struct dma_map_ops dma_iommu_ops\)/\1/' \
  $(git grep -l 'struct dma_map_ops' | grep ^arch/powerpc);
sed -i -e '/^struct vmd_dev {$/,/^};$/ s/const \(struct dma_map_ops[[:blank:]]dma_ops;\)/\1/' \
       -e '/^static void vmd_setup_dma_ops/,/^}$/ s/const \(struct dma_map_ops \*dest\)/\1/' \
       -e 's/const \(struct dma_map_ops \*dest = \&vmd->dma_ops\)/\1/' \
    drivers/pci/host/*.c
sed -i -e '/^void __init pci_iommu_alloc(void)$/,/^}$/ s/dma_ops->/intel_dma_ops./' arch/ia64/kernel/pci-dma.c
sed -i -e 's/static const struct dma_map_ops sn_dma_ops/static struct dma_map_ops sn_dma_ops/' arch/ia64/sn/pci/pci_dma.c
sed -i -e 's/(const struct dma_map_ops \*)//' drivers/misc/mic/bus/vop_bus.c

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 arch/alpha/include/asm/dma-mapping.h               |  4 +--
 arch/alpha/kernel/pci-noop.c                       |  4 +--
 arch/alpha/kernel/pci_iommu.c                      |  4 +--
 arch/arc/include/asm/dma-mapping.h                 |  4 +--
 arch/arc/mm/dma.c                                  |  2 +-
 arch/arm/common/dmabounce.c                        |  2 +-
 arch/arm/include/asm/device.h                      |  2 +-
 arch/arm/include/asm/dma-mapping.h                 | 10 +++---
 arch/arm/mm/dma-mapping.c                          | 22 ++++++------
 arch/arm/xen/mm.c                                  |  4 +--
 arch/arm64/include/asm/device.h                    |  2 +-
 arch/arm64/include/asm/dma-mapping.h               |  6 ++--
 arch/arm64/mm/dma-mapping.c                        |  6 ++--
 arch/avr32/include/asm/dma-mapping.h               |  4 +--
 arch/avr32/mm/dma-coherent.c                       |  2 +-
 arch/blackfin/include/asm/dma-mapping.h            |  4 +--
 arch/blackfin/kernel/dma-mapping.c                 |  2 +-
 arch/c6x/include/asm/dma-mapping.h                 |  4 +--
 arch/c6x/kernel/dma.c                              |  2 +-
 arch/cris/arch-v32/drivers/pci/dma.c               |  2 +-
 arch/cris/include/asm/dma-mapping.h                |  6 ++--
 arch/frv/include/asm/dma-mapping.h                 |  4 +--
 arch/frv/mb93090-mb00/pci-dma-nommu.c              |  2 +-
 arch/frv/mb93090-mb00/pci-dma.c                    |  2 +-
 arch/h8300/include/asm/dma-mapping.h               |  4 +--
 arch/h8300/kernel/dma.c                            |  2 +-
 arch/hexagon/include/asm/dma-mapping.h             |  4 +--
 arch/hexagon/kernel/dma.c                          |  4 +--
 arch/ia64/hp/common/hwsw_iommu.c                   |  4 +--
 arch/ia64/hp/common/sba_iommu.c                    |  4 +--
 arch/ia64/include/asm/dma-mapping.h                |  2 +-
 arch/ia64/include/asm/machvec.h                    |  4 +--
 arch/ia64/kernel/dma-mapping.c                     |  4 +--
 arch/ia64/kernel/pci-dma.c                         | 10 +++---
 arch/ia64/kernel/pci-swiotlb.c                     |  2 +-
 arch/m32r/include/asm/device.h                     |  2 +-
 arch/m32r/include/asm/dma-mapping.h                |  2 +-
 arch/m68k/include/asm/dma-mapping.h                |  4 +--
 arch/m68k/kernel/dma.c                             |  2 +-
 arch/metag/include/asm/dma-mapping.h               |  4 +--
 arch/metag/kernel/dma.c                            |  2 +-
 arch/microblaze/include/asm/dma-mapping.h          |  4 +--
 arch/microblaze/kernel/dma.c                       |  2 +-
 arch/mips/cavium-octeon/dma-octeon.c               |  4 +--
 arch/mips/include/asm/device.h                     |  2 +-
 arch/mips/include/asm/dma-mapping.h                |  4 +--
 .../include/asm/mach-cavium-octeon/dma-coherence.h |  2 +-
 arch/mips/include/asm/netlogic/common.h            |  2 +-
 arch/mips/loongson64/common/dma-swiotlb.c          |  2 +-
 arch/mips/mm/dma-default.c                         |  4 +--
 arch/mips/netlogic/common/nlm-dma.c                |  2 +-
 arch/mn10300/include/asm/dma-mapping.h             |  4 +--
 arch/mn10300/mm/dma-alloc.c                        |  2 +-
 arch/nios2/include/asm/dma-mapping.h               |  4 +--
 arch/nios2/mm/dma-mapping.c                        |  2 +-
 arch/openrisc/include/asm/dma-mapping.h            |  4 +--
 arch/openrisc/kernel/dma.c                         |  2 +-
 arch/parisc/include/asm/dma-mapping.h              |  8 ++---
 arch/parisc/kernel/drivers.c                       |  2 +-
 arch/parisc/kernel/pci-dma.c                       |  4 +--
 arch/powerpc/include/asm/device.h                  |  2 +-
 arch/powerpc/include/asm/dma-mapping.h             |  6 ++--
 arch/powerpc/include/asm/pci.h                     |  4 +--
 arch/powerpc/include/asm/swiotlb.h                 |  2 +-
 arch/powerpc/kernel/dma-swiotlb.c                  |  2 +-
 arch/powerpc/kernel/dma.c                          |  6 ++--
 arch/powerpc/kernel/pci-common.c                   |  6 ++--
 arch/powerpc/platforms/cell/iommu.c                |  4 +--
 arch/powerpc/platforms/powernv/npu-dma.c           |  2 +-
 arch/powerpc/platforms/ps3/system-bus.c            |  4 +--
 arch/powerpc/platforms/pseries/ibmebus.c           |  2 +-
 arch/powerpc/platforms/pseries/vio.c               |  2 +-
 arch/s390/include/asm/device.h                     |  2 +-
 arch/s390/include/asm/dma-mapping.h                |  4 +--
 arch/s390/pci/pci_dma.c                            |  2 +-
 arch/sh/include/asm/dma-mapping.h                  |  4 +--
 arch/sh/kernel/dma-nommu.c                         |  2 +-
 arch/sh/mm/consistent.c                            |  2 +-
 arch/sparc/include/asm/dma-mapping.h               |  8 ++---
 arch/sparc/kernel/iommu.c                          |  4 +--
 arch/sparc/kernel/ioport.c                         |  8 ++---
 arch/sparc/kernel/pci_sun4v.c                      |  2 +-
 arch/tile/include/asm/device.h                     |  2 +-
 arch/tile/include/asm/dma-mapping.h                | 12 +++----
 arch/tile/kernel/pci-dma.c                         | 24 ++++++-------
 arch/unicore32/include/asm/dma-mapping.h           |  4 +--
 arch/unicore32/mm/dma-swiotlb.c                    |  2 +-
 arch/x86/include/asm/device.h                      |  4 +--
 arch/x86/include/asm/dma-mapping.h                 |  4 +--
 arch/x86/include/asm/iommu.h                       |  2 +-
 arch/x86/kernel/amd_gart_64.c                      |  2 +-
 arch/x86/kernel/pci-calgary_64.c                   |  2 +-
 arch/x86/kernel/pci-dma.c                          |  4 +--
 arch/x86/kernel/pci-nommu.c                        |  2 +-
 arch/x86/kernel/pci-swiotlb.c                      |  2 +-
 arch/x86/pci/sta2x11-fixup.c                       |  2 +-
 arch/x86/xen/pci-swiotlb-xen.c                     |  2 +-
 arch/xtensa/include/asm/device.h                   |  2 +-
 arch/xtensa/include/asm/dma-mapping.h              |  4 +--
 arch/xtensa/kernel/pci-dma.c                       |  2 +-
 drivers/iommu/amd_iommu.c                          |  4 +--
 drivers/misc/mic/bus/mic_bus.c                     |  2 +-
 drivers/misc/mic/bus/scif_bus.c                    |  2 +-
 drivers/misc/mic/bus/scif_bus.h                    |  2 +-
 drivers/misc/mic/bus/vop_bus.c                     |  2 +-
 drivers/misc/mic/host/mic_boot.c                   |  4 +--
 drivers/parisc/ccio-dma.c                          |  2 +-
 drivers/parisc/sba_iommu.c                         |  2 +-
 drivers/pci/host/vmd.c                             |  2 +-
 include/linux/dma-mapping.h                        | 42 +++++++++++-----------
 include/linux/mic_bus.h                            |  2 +-
 include/xen/arm/hypervisor.h                       |  2 +-
 lib/dma-noop.c                                     |  2 +-
 113 files changed, 227 insertions(+), 227 deletions(-)

diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index c63b6ac19ee5..d3480562411d 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -1,9 +1,9 @@
 #ifndef _ALPHA_DMA_MAPPING_H
 #define _ALPHA_DMA_MAPPING_H
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return dma_ops;
 }
diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
index bb152e21e5ae..ffbdb3fb672f 100644
--- a/arch/alpha/kernel/pci-noop.c
+++ b/arch/alpha/kernel/pci-noop.c
@@ -128,7 +128,7 @@ static int alpha_noop_supported(struct device *dev, u64 mask)
 	return mask < 0x00ffffffUL ? 0 : 1;
 }
 
-struct dma_map_ops alpha_noop_ops = {
+const struct dma_map_ops alpha_noop_ops = {
 	.alloc			= alpha_noop_alloc_coherent,
 	.free			= dma_noop_free_coherent,
 	.map_page		= dma_noop_map_page,
@@ -137,5 +137,5 @@ struct dma_map_ops alpha_noop_ops = {
 	.dma_supported		= alpha_noop_supported,
 };
 
-struct dma_map_ops *dma_ops = &alpha_noop_ops;
+const struct dma_map_ops *dma_ops = &alpha_noop_ops;
 EXPORT_SYMBOL(dma_ops);
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 451fc9cdd323..7fd2329038a3 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -939,7 +939,7 @@ static int alpha_pci_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return dma_addr == 0;
 }
 
-struct dma_map_ops alpha_pci_ops = {
+const struct dma_map_ops alpha_pci_ops = {
 	.alloc			= alpha_pci_alloc_coherent,
 	.free			= alpha_pci_free_coherent,
 	.map_page		= alpha_pci_map_page,
@@ -950,5 +950,5 @@ struct dma_map_ops alpha_pci_ops = {
 	.dma_supported		= alpha_pci_supported,
 };
 
-struct dma_map_ops *dma_ops = &alpha_pci_ops;
+const struct dma_map_ops *dma_ops = &alpha_pci_ops;
 EXPORT_SYMBOL(dma_ops);
diff --git a/arch/arc/include/asm/dma-mapping.h b/arch/arc/include/asm/dma-mapping.h
index 266f11c9bd59..fdff3aa60052 100644
--- a/arch/arc/include/asm/dma-mapping.h
+++ b/arch/arc/include/asm/dma-mapping.h
@@ -18,9 +18,9 @@
 #include <plat/dma.h>
 #endif
 
-extern struct dma_map_ops arc_dma_ops;
+extern const struct dma_map_ops arc_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &arc_dma_ops;
 }
diff --git a/arch/arc/mm/dma.c b/arch/arc/mm/dma.c
index 08450a1a5b5f..2a07e6ecafbd 100644
--- a/arch/arc/mm/dma.c
+++ b/arch/arc/mm/dma.c
@@ -218,7 +218,7 @@ static int arc_dma_supported(struct device *dev, u64 dma_mask)
 	return dma_mask == DMA_BIT_MASK(32);
 }
 
-struct dma_map_ops arc_dma_ops = {
+const struct dma_map_ops arc_dma_ops = {
 	.alloc			= arc_dma_alloc,
 	.free			= arc_dma_free,
 	.mmap			= arc_dma_mmap,
diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 75055df1cda3..9b1b7be2ec0e 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -452,7 +452,7 @@ static int dmabounce_set_mask(struct device *dev, u64 dma_mask)
 	return arm_dma_ops.set_dma_mask(dev, dma_mask);
 }
 
-static struct dma_map_ops dmabounce_ops = {
+static const struct dma_map_ops dmabounce_ops = {
 	.alloc			= arm_dma_alloc,
 	.free			= arm_dma_free,
 	.mmap			= arm_dma_mmap,
diff --git a/arch/arm/include/asm/device.h b/arch/arm/include/asm/device.h
index 4111592f0130..d8a572f9c187 100644
--- a/arch/arm/include/asm/device.h
+++ b/arch/arm/include/asm/device.h
@@ -7,7 +7,7 @@
 #define ASMARM_DEVICE_H
 
 struct dev_archdata {
-	struct dma_map_ops	*dma_ops;
+	const struct dma_map_ops	*dma_ops;
 #ifdef CONFIG_DMABOUNCE
 	struct dmabounce_device_info *dmabounce;
 #endif
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index bf02dbd9ccda..1aabd781306f 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -13,17 +13,17 @@
 #include <asm/xen/hypervisor.h>
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
-extern struct dma_map_ops arm_dma_ops;
-extern struct dma_map_ops arm_coherent_dma_ops;
+extern const struct dma_map_ops arm_dma_ops;
+extern const struct dma_map_ops arm_coherent_dma_ops;
 
-static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
 	return &arm_dma_ops;
 }
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (xen_initial_domain())
 		return xen_dma_ops;
@@ -31,7 +31,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 		return __generic_dma_ops(dev);
 }
 
-static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
+static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
 	BUG_ON(!dev);
 	dev->archdata.dma_ops = ops;
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index ab7710002ba6..d26fe1a35687 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -180,7 +180,7 @@ static void arm_dma_sync_single_for_device(struct device *dev,
 	__dma_page_cpu_to_dev(page, offset, size, dir);
 }
 
-struct dma_map_ops arm_dma_ops = {
+const struct dma_map_ops arm_dma_ops = {
 	.alloc			= arm_dma_alloc,
 	.free			= arm_dma_free,
 	.mmap			= arm_dma_mmap,
@@ -204,7 +204,7 @@ static int arm_coherent_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		 unsigned long attrs);
 
-struct dma_map_ops arm_coherent_dma_ops = {
+const struct dma_map_ops arm_coherent_dma_ops = {
 	.alloc			= arm_coherent_dma_alloc,
 	.free			= arm_coherent_dma_free,
 	.mmap			= arm_coherent_dma_mmap,
@@ -1067,7 +1067,7 @@ static void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
 int arm_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		enum dma_data_direction dir, unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
 	int i, j;
 
@@ -1101,7 +1101,7 @@ int arm_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 void arm_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 		enum dma_data_direction dir, unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
 
 	int i;
@@ -1120,7 +1120,7 @@ void arm_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 void arm_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
 	int i;
 
@@ -1139,7 +1139,7 @@ void arm_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 void arm_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
 	int i;
 
@@ -2099,7 +2099,7 @@ static void arm_iommu_sync_single_for_device(struct device *dev,
 	__dma_page_cpu_to_dev(page, offset, size, dir);
 }
 
-struct dma_map_ops iommu_ops = {
+const struct dma_map_ops iommu_ops = {
 	.alloc		= arm_iommu_alloc_attrs,
 	.free		= arm_iommu_free_attrs,
 	.mmap		= arm_iommu_mmap_attrs,
@@ -2119,7 +2119,7 @@ struct dma_map_ops iommu_ops = {
 	.unmap_resource		= arm_iommu_unmap_resource,
 };
 
-struct dma_map_ops iommu_coherent_ops = {
+const struct dma_map_ops iommu_coherent_ops = {
 	.alloc		= arm_coherent_iommu_alloc_attrs,
 	.free		= arm_coherent_iommu_free_attrs,
 	.mmap		= arm_coherent_iommu_mmap_attrs,
@@ -2319,7 +2319,7 @@ void arm_iommu_detach_device(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(arm_iommu_detach_device);
 
-static struct dma_map_ops *arm_get_iommu_dma_map_ops(bool coherent)
+static const struct dma_map_ops *arm_get_iommu_dma_map_ops(bool coherent)
 {
 	return coherent ? &iommu_coherent_ops : &iommu_ops;
 }
@@ -2374,7 +2374,7 @@ static void arm_teardown_iommu_dma_ops(struct device *dev) { }
 
 #endif	/* CONFIG_ARM_DMA_USE_IOMMU */
 
-static struct dma_map_ops *arm_get_dma_map_ops(bool coherent)
+static const struct dma_map_ops *arm_get_dma_map_ops(bool coherent)
 {
 	return coherent ? &arm_coherent_dma_ops : &arm_dma_ops;
 }
@@ -2382,7 +2382,7 @@ static struct dma_map_ops *arm_get_dma_map_ops(bool coherent)
 void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 			const struct iommu_ops *iommu, bool coherent)
 {
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 
 	dev->archdata.dma_coherent = coherent;
 	if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index bd62d94f8ac5..ce18c91b50a1 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -182,10 +182,10 @@ void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order)
 }
 EXPORT_SYMBOL_GPL(xen_destroy_contiguous_region);
 
-struct dma_map_ops *xen_dma_ops;
+const struct dma_map_ops *xen_dma_ops;
 EXPORT_SYMBOL(xen_dma_ops);
 
-static struct dma_map_ops xen_swiotlb_dma_ops = {
+static const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.alloc = xen_swiotlb_alloc_coherent,
 	.free = xen_swiotlb_free_coherent,
 	.sync_single_for_cpu = xen_swiotlb_sync_single_for_cpu,
diff --git a/arch/arm64/include/asm/device.h b/arch/arm64/include/asm/device.h
index 243ef256b8c9..00c678cc31e1 100644
--- a/arch/arm64/include/asm/device.h
+++ b/arch/arm64/include/asm/device.h
@@ -17,7 +17,7 @@
 #define __ASM_DEVICE_H
 
 struct dev_archdata {
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 #ifdef CONFIG_IOMMU_API
 	void *iommu;			/* private IOMMU data */
 #endif
diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index ccea82c2b089..1fedb43be712 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -25,9 +25,9 @@
 #include <asm/xen/hypervisor.h>
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0)
-extern struct dma_map_ops dummy_dma_ops;
+extern const struct dma_map_ops dummy_dma_ops;
 
-static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
@@ -39,7 +39,7 @@ static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
 	return &dummy_dma_ops;
 }
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (xen_initial_domain())
 		return xen_dma_ops;
diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index e04082700bb1..bcef6368d48f 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -352,7 +352,7 @@ static int __swiotlb_dma_supported(struct device *hwdev, u64 mask)
 	return 1;
 }
 
-static struct dma_map_ops swiotlb_dma_ops = {
+static const struct dma_map_ops swiotlb_dma_ops = {
 	.alloc = __dma_alloc,
 	.free = __dma_free,
 	.mmap = __swiotlb_mmap,
@@ -505,7 +505,7 @@ static int __dummy_dma_supported(struct device *hwdev, u64 mask)
 	return 0;
 }
 
-struct dma_map_ops dummy_dma_ops = {
+const struct dma_map_ops dummy_dma_ops = {
 	.alloc                  = __dummy_alloc,
 	.free                   = __dummy_free,
 	.mmap                   = __dummy_mmap,
@@ -784,7 +784,7 @@ static void __iommu_unmap_sg_attrs(struct device *dev,
 	iommu_dma_unmap_sg(dev, sgl, nelems, dir, attrs);
 }
 
-static struct dma_map_ops iommu_dma_ops = {
+static const struct dma_map_ops iommu_dma_ops = {
 	.alloc = __iommu_alloc_attrs,
 	.free = __iommu_free_attrs,
 	.mmap = __iommu_mmap_attrs,
diff --git a/arch/avr32/include/asm/dma-mapping.h b/arch/avr32/include/asm/dma-mapping.h
index 1115f2a645d1..b2b43c0e0774 100644
--- a/arch/avr32/include/asm/dma-mapping.h
+++ b/arch/avr32/include/asm/dma-mapping.h
@@ -4,9 +4,9 @@
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	int direction);
 
-extern struct dma_map_ops avr32_dma_ops;
+extern const struct dma_map_ops avr32_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &avr32_dma_ops;
 }
diff --git a/arch/avr32/mm/dma-coherent.c b/arch/avr32/mm/dma-coherent.c
index 54534e5d0781..555222d4f414 100644
--- a/arch/avr32/mm/dma-coherent.c
+++ b/arch/avr32/mm/dma-coherent.c
@@ -191,7 +191,7 @@ static void avr32_dma_sync_sg_for_device(struct device *dev,
 		dma_cache_sync(dev, sg_virt(sg), sg->length, direction);
 }
 
-struct dma_map_ops avr32_dma_ops = {
+const struct dma_map_ops avr32_dma_ops = {
 	.alloc			= avr32_dma_alloc,
 	.free			= avr32_dma_free,
 	.map_page		= avr32_dma_map_page,
diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index 3490570aaa82..320fb50fbd41 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -36,9 +36,9 @@ _dma_sync(dma_addr_t addr, size_t size, enum dma_data_direction dir)
 		__dma_sync(addr, size, dir);
 }
 
-extern struct dma_map_ops bfin_dma_ops;
+extern const struct dma_map_ops bfin_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &bfin_dma_ops;
 }
diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
index a27a74a18fb0..477bb29a7987 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -159,7 +159,7 @@ static inline void bfin_dma_sync_single_for_device(struct device *dev,
 	_dma_sync(handle, size, dir);
 }
 
-struct dma_map_ops bfin_dma_ops = {
+const struct dma_map_ops bfin_dma_ops = {
 	.alloc			= bfin_dma_alloc,
 	.free			= bfin_dma_free,
 
diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
index 5717b1e52d96..88258b9ebc8e 100644
--- a/arch/c6x/include/asm/dma-mapping.h
+++ b/arch/c6x/include/asm/dma-mapping.h
@@ -17,9 +17,9 @@
  */
 #define DMA_ERROR_CODE ~0
 
-extern struct dma_map_ops c6x_dma_ops;
+extern const struct dma_map_ops c6x_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &c6x_dma_ops;
 }
diff --git a/arch/c6x/kernel/dma.c b/arch/c6x/kernel/dma.c
index 6752df32ef06..9fff8be75f58 100644
--- a/arch/c6x/kernel/dma.c
+++ b/arch/c6x/kernel/dma.c
@@ -123,7 +123,7 @@ static void c6x_dma_sync_sg_for_device(struct device *dev,
 
 }
 
-struct dma_map_ops c6x_dma_ops = {
+const struct dma_map_ops c6x_dma_ops = {
 	.alloc			= c6x_dma_alloc,
 	.free			= c6x_dma_free,
 	.map_page		= c6x_dma_map_page,
diff --git a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
index 1f0636793f0c..7072341995ff 100644
--- a/arch/cris/arch-v32/drivers/pci/dma.c
+++ b/arch/cris/arch-v32/drivers/pci/dma.c
@@ -69,7 +69,7 @@ static inline int v32_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-struct dma_map_ops v32_dma_ops = {
+const struct dma_map_ops v32_dma_ops = {
 	.alloc			= v32_dma_alloc,
 	.free			= v32_dma_free,
 	.map_page		= v32_dma_map_page,
diff --git a/arch/cris/include/asm/dma-mapping.h b/arch/cris/include/asm/dma-mapping.h
index 5a370178a0e9..aae4fbc0a656 100644
--- a/arch/cris/include/asm/dma-mapping.h
+++ b/arch/cris/include/asm/dma-mapping.h
@@ -2,14 +2,14 @@
 #define _ASM_CRIS_DMA_MAPPING_H
 
 #ifdef CONFIG_PCI
-extern struct dma_map_ops v32_dma_ops;
+extern const struct dma_map_ops v32_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &v32_dma_ops;
 }
 #else
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	BUG();
 	return NULL;
diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index 9a82bfa4303b..150cc00544a8 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -7,9 +7,9 @@
 extern unsigned long __nongprelbss dma_coherent_mem_start;
 extern unsigned long __nongprelbss dma_coherent_mem_end;
 
-extern struct dma_map_ops frv_dma_ops;
+extern const struct dma_map_ops frv_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &frv_dma_ops;
 }
diff --git a/arch/frv/mb93090-mb00/pci-dma-nommu.c b/arch/frv/mb93090-mb00/pci-dma-nommu.c
index 187688128c65..4a96de7f0af4 100644
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c
+++ b/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -164,7 +164,7 @@ static int frv_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-struct dma_map_ops frv_dma_ops = {
+const struct dma_map_ops frv_dma_ops = {
 	.alloc			= frv_dma_alloc,
 	.free			= frv_dma_free,
 	.map_page		= frv_dma_map_page,
diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index dba7df918144..e7130abc0dae 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -106,7 +106,7 @@ static int frv_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-struct dma_map_ops frv_dma_ops = {
+const struct dma_map_ops frv_dma_ops = {
 	.alloc			= frv_dma_alloc,
 	.free			= frv_dma_free,
 	.map_page		= frv_dma_map_page,
diff --git a/arch/h8300/include/asm/dma-mapping.h b/arch/h8300/include/asm/dma-mapping.h
index 7ac7fadffed0..f804bca4c13f 100644
--- a/arch/h8300/include/asm/dma-mapping.h
+++ b/arch/h8300/include/asm/dma-mapping.h
@@ -1,9 +1,9 @@
 #ifndef _H8300_DMA_MAPPING_H
 #define _H8300_DMA_MAPPING_H
 
-extern struct dma_map_ops h8300_dma_map_ops;
+extern const struct dma_map_ops h8300_dma_map_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &h8300_dma_map_ops;
 }
diff --git a/arch/h8300/kernel/dma.c b/arch/h8300/kernel/dma.c
index 3651da045806..225dd0a188dc 100644
--- a/arch/h8300/kernel/dma.c
+++ b/arch/h8300/kernel/dma.c
@@ -60,7 +60,7 @@ static int map_sg(struct device *dev, struct scatterlist *sgl,
 	return nents;
 }
 
-struct dma_map_ops h8300_dma_map_ops = {
+const struct dma_map_ops h8300_dma_map_ops = {
 	.alloc = dma_alloc,
 	.free = dma_free,
 	.map_page = map_page,
diff --git a/arch/hexagon/include/asm/dma-mapping.h b/arch/hexagon/include/asm/dma-mapping.h
index 7ef58df909fc..b812e917cd95 100644
--- a/arch/hexagon/include/asm/dma-mapping.h
+++ b/arch/hexagon/include/asm/dma-mapping.h
@@ -32,9 +32,9 @@ struct device;
 extern int bad_dma_address;
 #define DMA_ERROR_CODE bad_dma_address
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (unlikely(dev == NULL))
 		return NULL;
diff --git a/arch/hexagon/kernel/dma.c b/arch/hexagon/kernel/dma.c
index dbc4f1003da4..e74b65009587 100644
--- a/arch/hexagon/kernel/dma.c
+++ b/arch/hexagon/kernel/dma.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <asm/page.h>
 
-struct dma_map_ops *dma_ops;
+const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 int bad_dma_address;  /*  globals are automatically initialized to zero  */
@@ -203,7 +203,7 @@ static void hexagon_sync_single_for_device(struct device *dev,
 	dma_sync(dma_addr_to_virt(dma_handle), size, dir);
 }
 
-struct dma_map_ops hexagon_dma_ops = {
+const struct dma_map_ops hexagon_dma_ops = {
 	.alloc		= hexagon_dma_alloc_coherent,
 	.free		= hexagon_free_coherent,
 	.map_sg		= hexagon_map_sg,
diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index 1e4cae5ae053..0310078a95f8 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -18,7 +18,7 @@
 #include <linux/export.h>
 #include <asm/machvec.h>
 
-extern struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
+extern const struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
 
 /* swiotlb declarations & definitions: */
 extern int swiotlb_late_init_with_default_size (size_t size);
@@ -34,7 +34,7 @@ static inline int use_swiotlb(struct device *dev)
 		!sba_dma_ops.dma_supported(dev, *dev->dma_mask);
 }
 
-struct dma_map_ops *hwsw_dma_get_ops(struct device *dev)
+const struct dma_map_ops *hwsw_dma_get_ops(struct device *dev)
 {
 	if (use_swiotlb(dev))
 		return &swiotlb_dma_ops;
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 630ee8073899..aec4a3354abe 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2096,7 +2096,7 @@ static int __init acpi_sba_ioc_init_acpi(void)
 /* This has to run before acpi_scan_init(). */
 arch_initcall(acpi_sba_ioc_init_acpi);
 
-extern struct dma_map_ops swiotlb_dma_ops;
+extern const struct dma_map_ops swiotlb_dma_ops;
 
 static int __init
 sba_init(void)
@@ -2216,7 +2216,7 @@ sba_page_override(char *str)
 
 __setup("sbapagesize=",sba_page_override);
 
-struct dma_map_ops sba_dma_ops = {
+const struct dma_map_ops sba_dma_ops = {
 	.alloc			= sba_alloc_coherent,
 	.free			= sba_free_coherent,
 	.map_page		= sba_map_page,
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index d472805edfa9..05e467d56d86 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -14,7 +14,7 @@
 
 #define DMA_ERROR_CODE 0
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 extern struct ia64_machine_vector ia64_mv;
 extern void set_iommu_machvec(void);
 
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index ed7f09089f12..af285c423e1e 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -44,7 +44,7 @@ typedef void ia64_mv_kernel_launch_event_t(void);
 /* DMA-mapping interface: */
 typedef void ia64_mv_dma_init (void);
 typedef u64 ia64_mv_dma_get_required_mask (struct device *);
-typedef struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
+typedef const struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
 
 /*
  * WARNING: The legacy I/O space is _architected_.  Platforms are
@@ -248,7 +248,7 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 # endif /* CONFIG_IA64_GENERIC */
 
 extern void swiotlb_dma_init(void);
-extern struct dma_map_ops *dma_get_ops(struct device *);
+extern const struct dma_map_ops *dma_get_ops(struct device *);
 
 /*
  * Define default versions so we can extend machvec for new platforms without having
diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index 7f7916238208..e0dd97f4eb69 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -4,7 +4,7 @@
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly;
 
-struct dma_map_ops *dma_ops;
+const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 #define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
@@ -17,7 +17,7 @@ static int __init dma_init(void)
 }
 fs_initcall(dma_init);
 
-struct dma_map_ops *dma_get_ops(struct device *dev)
+const struct dma_map_ops *dma_get_ops(struct device *dev)
 {
 	return dma_ops;
 }
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 992c1098c522..9094a73f996f 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -90,11 +90,11 @@ void __init pci_iommu_alloc(void)
 {
 	dma_ops = &intel_dma_ops;
 
-	dma_ops->sync_single_for_cpu = machvec_dma_sync_single;
-	dma_ops->sync_sg_for_cpu = machvec_dma_sync_sg;
-	dma_ops->sync_single_for_device = machvec_dma_sync_single;
-	dma_ops->sync_sg_for_device = machvec_dma_sync_sg;
-	dma_ops->dma_supported = iommu_dma_supported;
+	intel_dma_ops.sync_single_for_cpu = machvec_dma_sync_single;
+	intel_dma_ops.sync_sg_for_cpu = machvec_dma_sync_sg;
+	intel_dma_ops.sync_single_for_device = machvec_dma_sync_single;
+	intel_dma_ops.sync_sg_for_device = machvec_dma_sync_sg;
+	intel_dma_ops.dma_supported = iommu_dma_supported;
 
 	/*
 	 * The order of these functions is important for
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 2933208c0285..a14989dacded 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -30,7 +30,7 @@ static void ia64_swiotlb_free_coherent(struct device *dev, size_t size,
 	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
 }
 
-struct dma_map_ops swiotlb_dma_ops = {
+const struct dma_map_ops swiotlb_dma_ops = {
 	.alloc = ia64_swiotlb_alloc_coherent,
 	.free = ia64_swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
diff --git a/arch/m32r/include/asm/device.h b/arch/m32r/include/asm/device.h
index 4a9f35e0973f..7955a9799466 100644
--- a/arch/m32r/include/asm/device.h
+++ b/arch/m32r/include/asm/device.h
@@ -4,7 +4,7 @@
  * This file is released under the GPLv2
  */
 struct dev_archdata {
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 };
 
 struct pdev_archdata {
diff --git a/arch/m32r/include/asm/dma-mapping.h b/arch/m32r/include/asm/dma-mapping.h
index 2c43a77fe942..99c43d2f05dc 100644
--- a/arch/m32r/include/asm/dma-mapping.h
+++ b/arch/m32r/include/asm/dma-mapping.h
@@ -10,7 +10,7 @@
 
 #define DMA_ERROR_CODE (~(dma_addr_t)0x0)
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index 96c536194287..863509939d5a 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -1,9 +1,9 @@
 #ifndef _M68K_DMA_MAPPING_H
 #define _M68K_DMA_MAPPING_H
 
-extern struct dma_map_ops m68k_dma_ops;
+extern const struct dma_map_ops m68k_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
         return &m68k_dma_ops;
 }
diff --git a/arch/m68k/kernel/dma.c b/arch/m68k/kernel/dma.c
index 07070065a425..0fc5dabb4a42 100644
--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -158,7 +158,7 @@ static int m68k_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 	return nents;
 }
 
-struct dma_map_ops m68k_dma_ops = {
+const struct dma_map_ops m68k_dma_ops = {
 	.alloc			= m68k_dma_alloc,
 	.free			= m68k_dma_free,
 	.map_page		= m68k_dma_map_page,
diff --git a/arch/metag/include/asm/dma-mapping.h b/arch/metag/include/asm/dma-mapping.h
index 27af5d479ce6..c156a7ac732f 100644
--- a/arch/metag/include/asm/dma-mapping.h
+++ b/arch/metag/include/asm/dma-mapping.h
@@ -1,9 +1,9 @@
 #ifndef _ASM_METAG_DMA_MAPPING_H
 #define _ASM_METAG_DMA_MAPPING_H
 
-extern struct dma_map_ops metag_dma_ops;
+extern const struct dma_map_ops metag_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &metag_dma_ops;
 }
diff --git a/arch/metag/kernel/dma.c b/arch/metag/kernel/dma.c
index 91968d92652b..f0ab3a498328 100644
--- a/arch/metag/kernel/dma.c
+++ b/arch/metag/kernel/dma.c
@@ -575,7 +575,7 @@ static void metag_dma_sync_sg_for_device(struct device *dev,
 		dma_sync_for_device(sg_virt(sg), sg->length, direction);
 }
 
-struct dma_map_ops metag_dma_ops = {
+const struct dma_map_ops metag_dma_ops = {
 	.alloc			= metag_dma_alloc,
 	.free			= metag_dma_free,
 	.map_page		= metag_dma_map_page,
diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
index 1768d4bdc8d3..c7faf2fb51d6 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -36,9 +36,9 @@
 /*
  * Available generic sets of operations
  */
-extern struct dma_map_ops dma_direct_ops;
+extern const struct dma_map_ops dma_direct_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &dma_direct_ops;
 }
diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index 818daf230eb4..12e093a03e60 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -187,7 +187,7 @@ int dma_direct_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
 #endif
 }
 
-struct dma_map_ops dma_direct_ops = {
+const struct dma_map_ops dma_direct_ops = {
 	.alloc		= dma_direct_alloc_coherent,
 	.free		= dma_direct_free_coherent,
 	.mmap		= dma_direct_mmap_coherent,
diff --git a/arch/mips/cavium-octeon/dma-octeon.c b/arch/mips/cavium-octeon/dma-octeon.c
index fd69528b24fb..897d32c888ee 100644
--- a/arch/mips/cavium-octeon/dma-octeon.c
+++ b/arch/mips/cavium-octeon/dma-octeon.c
@@ -205,7 +205,7 @@ static phys_addr_t octeon_unity_dma_to_phys(struct device *dev, dma_addr_t daddr
 }
 
 struct octeon_dma_map_ops {
-	struct dma_map_ops dma_map_ops;
+	const struct dma_map_ops dma_map_ops;
 	dma_addr_t (*phys_to_dma)(struct device *dev, phys_addr_t paddr);
 	phys_addr_t (*dma_to_phys)(struct device *dev, dma_addr_t daddr);
 };
@@ -333,7 +333,7 @@ static struct octeon_dma_map_ops _octeon_pci_dma_map_ops = {
 	},
 };
 
-struct dma_map_ops *octeon_pci_dma_map_ops;
+const struct dma_map_ops *octeon_pci_dma_map_ops;
 
 void __init octeon_pci_dma_init(void)
 {
diff --git a/arch/mips/include/asm/device.h b/arch/mips/include/asm/device.h
index 21c2082a0dfb..ebc5c1265473 100644
--- a/arch/mips/include/asm/device.h
+++ b/arch/mips/include/asm/device.h
@@ -10,7 +10,7 @@ struct dma_map_ops;
 
 struct dev_archdata {
 	/* DMA operations on that device */
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 
 #ifdef CONFIG_DMA_PERDEV_COHERENT
 	/* Non-zero if DMA is coherent with CPU caches */
diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
index 7aa71b9b0258..b59b084a7569 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -9,9 +9,9 @@
 #include <dma-coherence.h>
 #endif
 
-extern struct dma_map_ops *mips_dma_map_ops;
+extern const struct dma_map_ops *mips_dma_map_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
index 460042ee5d6f..9110988b92a1 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
@@ -65,7 +65,7 @@ dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
 phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr);
 
 struct dma_map_ops;
-extern struct dma_map_ops *octeon_pci_dma_map_ops;
+extern const struct dma_map_ops *octeon_pci_dma_map_ops;
 extern char *octeon_swiotlb;
 
 #endif /* __ASM_MACH_CAVIUM_OCTEON_DMA_COHERENCE_H */
diff --git a/arch/mips/include/asm/netlogic/common.h b/arch/mips/include/asm/netlogic/common.h
index be52c2125d71..e0717d10e650 100644
--- a/arch/mips/include/asm/netlogic/common.h
+++ b/arch/mips/include/asm/netlogic/common.h
@@ -88,7 +88,7 @@ extern struct plat_smp_ops nlm_smp_ops;
 extern char nlm_reset_entry[], nlm_reset_entry_end[];
 
 /* SWIOTLB */
-extern struct dma_map_ops nlm_swiotlb_dma_ops;
+extern const struct dma_map_ops nlm_swiotlb_dma_ops;
 
 extern unsigned int nlm_threads_per_core;
 extern cpumask_t nlm_cpumask;
diff --git a/arch/mips/loongson64/common/dma-swiotlb.c b/arch/mips/loongson64/common/dma-swiotlb.c
index aab4fd681e1f..7296df043d92 100644
--- a/arch/mips/loongson64/common/dma-swiotlb.c
+++ b/arch/mips/loongson64/common/dma-swiotlb.c
@@ -122,7 +122,7 @@ phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 	return daddr;
 }
 
-static struct dma_map_ops loongson_dma_map_ops = {
+static const struct dma_map_ops loongson_dma_map_ops = {
 	.alloc = loongson_dma_alloc_coherent,
 	.free = loongson_dma_free_coherent,
 	.map_page = loongson_dma_map_page,
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index a39c36af97ad..1cb84472cb58 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -417,7 +417,7 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 
 EXPORT_SYMBOL(dma_cache_sync);
 
-static struct dma_map_ops mips_default_dma_map_ops = {
+static const struct dma_map_ops mips_default_dma_map_ops = {
 	.alloc = mips_dma_alloc_coherent,
 	.free = mips_dma_free_coherent,
 	.mmap = mips_dma_mmap,
@@ -433,7 +433,7 @@ static struct dma_map_ops mips_default_dma_map_ops = {
 	.dma_supported = mips_dma_supported
 };
 
-struct dma_map_ops *mips_dma_map_ops = &mips_default_dma_map_ops;
+const struct dma_map_ops *mips_dma_map_ops = &mips_default_dma_map_ops;
 EXPORT_SYMBOL(mips_dma_map_ops);
 
 #define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
diff --git a/arch/mips/netlogic/common/nlm-dma.c b/arch/mips/netlogic/common/nlm-dma.c
index 0630693bec2a..0ec9d9da6d51 100644
--- a/arch/mips/netlogic/common/nlm-dma.c
+++ b/arch/mips/netlogic/common/nlm-dma.c
@@ -67,7 +67,7 @@ static void nlm_dma_free_coherent(struct device *dev, size_t size,
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
-struct dma_map_ops nlm_swiotlb_dma_ops = {
+const struct dma_map_ops nlm_swiotlb_dma_ops = {
 	.alloc = nlm_dma_alloc_coherent,
 	.free = nlm_dma_free_coherent,
 	.map_page = swiotlb_map_page,
diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index 1dcd44757f32..564e3927e005 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -14,9 +14,9 @@
 #include <asm/cache.h>
 #include <asm/io.h>
 
-extern struct dma_map_ops mn10300_dma_ops;
+extern const struct dma_map_ops mn10300_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &mn10300_dma_ops;
 }
diff --git a/arch/mn10300/mm/dma-alloc.c b/arch/mn10300/mm/dma-alloc.c
index 4f4b9029f0ea..86108d2496b3 100644
--- a/arch/mn10300/mm/dma-alloc.c
+++ b/arch/mn10300/mm/dma-alloc.c
@@ -121,7 +121,7 @@ static int mn10300_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-struct dma_map_ops mn10300_dma_ops = {
+const struct dma_map_ops mn10300_dma_ops = {
 	.alloc			= mn10300_dma_alloc,
 	.free			= mn10300_dma_free,
 	.map_page		= mn10300_dma_map_page,
diff --git a/arch/nios2/include/asm/dma-mapping.h b/arch/nios2/include/asm/dma-mapping.h
index bec8ac8e6ad2..aa00d839a64b 100644
--- a/arch/nios2/include/asm/dma-mapping.h
+++ b/arch/nios2/include/asm/dma-mapping.h
@@ -10,9 +10,9 @@
 #ifndef _ASM_NIOS2_DMA_MAPPING_H
 #define _ASM_NIOS2_DMA_MAPPING_H
 
-extern struct dma_map_ops nios2_dma_ops;
+extern const struct dma_map_ops nios2_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &nios2_dma_ops;
 }
diff --git a/arch/nios2/mm/dma-mapping.c b/arch/nios2/mm/dma-mapping.c
index f6a5dcf9d682..7040c1adbb5e 100644
--- a/arch/nios2/mm/dma-mapping.c
+++ b/arch/nios2/mm/dma-mapping.c
@@ -192,7 +192,7 @@ static void nios2_dma_sync_sg_for_device(struct device *dev,
 
 }
 
-struct dma_map_ops nios2_dma_ops = {
+const struct dma_map_ops nios2_dma_ops = {
 	.alloc			= nios2_dma_alloc,
 	.free			= nios2_dma_free,
 	.map_page		= nios2_dma_map_page,
diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
index 1f260bccb368..88acbedb4947 100644
--- a/arch/openrisc/include/asm/dma-mapping.h
+++ b/arch/openrisc/include/asm/dma-mapping.h
@@ -28,9 +28,9 @@
 
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
 
-extern struct dma_map_ops or1k_dma_map_ops;
+extern const struct dma_map_ops or1k_dma_map_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &or1k_dma_map_ops;
 }
diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
index 906998bac957..b10369b7e31b 100644
--- a/arch/openrisc/kernel/dma.c
+++ b/arch/openrisc/kernel/dma.c
@@ -232,7 +232,7 @@ or1k_sync_single_for_device(struct device *dev,
 		mtspr(SPR_DCBFR, cl);
 }
 
-struct dma_map_ops or1k_dma_map_ops = {
+const struct dma_map_ops or1k_dma_map_ops = {
 	.alloc = or1k_dma_alloc,
 	.free = or1k_dma_free,
 	.map_page = or1k_map_page,
diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index 16e024602737..1749073e44fc 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -21,13 +21,13 @@
 */
 
 #ifdef CONFIG_PA11
-extern struct dma_map_ops pcxl_dma_ops;
-extern struct dma_map_ops pcx_dma_ops;
+extern const struct dma_map_ops pcxl_dma_ops;
+extern const struct dma_map_ops pcx_dma_ops;
 #endif
 
-extern struct dma_map_ops *hppa_dma_ops;
+extern const struct dma_map_ops *hppa_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return hppa_dma_ops;
 }
diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 700e2d2da096..fa78419100c8 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -40,7 +40,7 @@
 #include <asm/parisc-device.h>
 
 /* See comments in include/asm-parisc/pci.h */
-struct dma_map_ops *hppa_dma_ops __read_mostly;
+const struct dma_map_ops *hppa_dma_ops __read_mostly;
 EXPORT_SYMBOL(hppa_dma_ops);
 
 static struct device root = {
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 697c53543a4d..5f0067a62738 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -572,7 +572,7 @@ static void pa11_dma_sync_sg_for_device(struct device *dev, struct scatterlist *
 		flush_kernel_vmap_range(sg_virt(sg), sg->length);
 }
 
-struct dma_map_ops pcxl_dma_ops = {
+const struct dma_map_ops pcxl_dma_ops = {
 	.dma_supported =	pa11_dma_supported,
 	.alloc =		pa11_dma_alloc,
 	.free =			pa11_dma_free,
@@ -608,7 +608,7 @@ static void pcx_dma_free(struct device *dev, size_t size, void *vaddr,
 	return;
 }
 
-struct dma_map_ops pcx_dma_ops = {
+const struct dma_map_ops pcx_dma_ops = {
 	.dma_supported =	pa11_dma_supported,
 	.alloc =		pcx_dma_alloc,
 	.free =			pcx_dma_free,
diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 406c2b1ff82d..49cbb0fca233 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -21,7 +21,7 @@ struct iommu_table;
  */
 struct dev_archdata {
 	/* DMA operations on that device */
-	struct dma_map_ops	*dma_ops;
+	const struct dma_map_ops	*dma_ops;
 
 	/*
 	 * These two used to be a union. However, with the hybrid ops we need
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 84e3f8dd5e4f..2ec3eadf336f 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -76,9 +76,9 @@ static inline unsigned long device_to_mask(struct device *dev)
 #ifdef CONFIG_PPC64
 extern struct dma_map_ops dma_iommu_ops;
 #endif
-extern struct dma_map_ops dma_direct_ops;
+extern const struct dma_map_ops dma_direct_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	/* We don't handle the NULL dev case for ISA for now. We could
 	 * do it via an out of line call but it is not needed for now. The
@@ -91,7 +91,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 	return dev->archdata.dma_ops;
 }
 
-static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
+static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
 	dev->archdata.dma_ops = ops;
 }
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index e9bd6cf0212f..93eded8d3843 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -53,8 +53,8 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 }
 
 #ifdef CONFIG_PCI
-extern void set_pci_dma_ops(struct dma_map_ops *dma_ops);
-extern struct dma_map_ops *get_pci_dma_ops(void);
+extern void set_pci_dma_ops(const struct dma_map_ops *dma_ops);
+extern const struct dma_map_ops *get_pci_dma_ops(void);
 #else	/* CONFIG_PCI */
 #define set_pci_dma_ops(d)
 #define get_pci_dma_ops()	NULL
diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/include/asm/swiotlb.h
index de99d6e29430..01d45a5fd00b 100644
--- a/arch/powerpc/include/asm/swiotlb.h
+++ b/arch/powerpc/include/asm/swiotlb.h
@@ -13,7 +13,7 @@
 
 #include <linux/swiotlb.h>
 
-extern struct dma_map_ops swiotlb_dma_ops;
+extern const struct dma_map_ops swiotlb_dma_ops;
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index c6689f658b50..d0ea7860e02b 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -46,7 +46,7 @@ static u64 swiotlb_powerpc_get_required(struct device *dev)
  * map_page, and unmap_page on highmem, use normal dma_ops
  * for everything else.
  */
-struct dma_map_ops swiotlb_dma_ops = {
+const struct dma_map_ops swiotlb_dma_ops = {
 	.alloc = __dma_direct_alloc_coherent,
 	.free = __dma_direct_free_coherent,
 	.mmap = dma_direct_mmap_coherent,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 6877e3fa95bb..03b98f1f98ec 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -274,7 +274,7 @@ static inline void dma_direct_sync_single(struct device *dev,
 }
 #endif
 
-struct dma_map_ops dma_direct_ops = {
+const struct dma_map_ops dma_direct_ops = {
 	.alloc				= dma_direct_alloc_coherent,
 	.free				= dma_direct_free_coherent,
 	.mmap				= dma_direct_mmap_coherent,
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(dma_set_coherent_mask);
 
 int __dma_set_mask(struct device *dev, u64 dma_mask)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if ((dma_ops != NULL) && (dma_ops->set_dma_mask != NULL))
 		return dma_ops->set_dma_mask(dev, dma_mask);
@@ -344,7 +344,7 @@ EXPORT_SYMBOL(dma_set_mask);
 
 u64 __dma_get_required_mask(struct device *dev)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (unlikely(dma_ops == NULL))
 		return 0;
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 74bec5498972..09db4778435c 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -59,14 +59,14 @@ resource_size_t isa_mem_base;
 EXPORT_SYMBOL(isa_mem_base);
 
 
-static struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
+static const struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
 
-void set_pci_dma_ops(struct dma_map_ops *dma_ops)
+void set_pci_dma_ops(const struct dma_map_ops *dma_ops)
 {
 	pci_dma_ops = dma_ops;
 }
 
-struct dma_map_ops *get_pci_dma_ops(void)
+const struct dma_map_ops *get_pci_dma_ops(void)
 {
 	return pci_dma_ops;
 }
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 7ff51f96a00e..e1413e69e5fe 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -651,7 +651,7 @@ static int dma_fixed_dma_supported(struct device *dev, u64 mask)
 
 static int dma_set_mask_and_switch(struct device *dev, u64 dma_mask);
 
-static struct dma_map_ops dma_iommu_fixed_ops = {
+static const struct dma_map_ops dma_iommu_fixed_ops = {
 	.alloc          = dma_fixed_alloc_coherent,
 	.free           = dma_fixed_free_coherent,
 	.map_sg         = dma_fixed_map_sg,
@@ -1172,7 +1172,7 @@ __setup("iommu_fixed=", setup_iommu_fixed);
 
 static u64 cell_dma_get_required_mask(struct device *dev)
 {
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 
 	if (!dev->dma_mask)
 		return 0;
diff --git a/arch/powerpc/platforms/powernv/npu-dma.c b/arch/powerpc/platforms/powernv/npu-dma.c
index 73b155fd4481..1c383f38031d 100644
--- a/arch/powerpc/platforms/powernv/npu-dma.c
+++ b/arch/powerpc/platforms/powernv/npu-dma.c
@@ -115,7 +115,7 @@ static u64 dma_npu_get_required_mask(struct device *dev)
 	return 0;
 }
 
-static struct dma_map_ops dma_npu_ops = {
+static const struct dma_map_ops dma_npu_ops = {
 	.map_page		= dma_npu_map_page,
 	.map_sg			= dma_npu_map_sg,
 	.alloc			= dma_npu_alloc,
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 8af1c15aef85..c81450d98794 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -701,7 +701,7 @@ static u64 ps3_dma_get_required_mask(struct device *_dev)
 	return DMA_BIT_MASK(32);
 }
 
-static struct dma_map_ops ps3_sb_dma_ops = {
+static const struct dma_map_ops ps3_sb_dma_ops = {
 	.alloc = ps3_alloc_coherent,
 	.free = ps3_free_coherent,
 	.map_sg = ps3_sb_map_sg,
@@ -712,7 +712,7 @@ static struct dma_map_ops ps3_sb_dma_ops = {
 	.unmap_page = ps3_unmap_page,
 };
 
-static struct dma_map_ops ps3_ioc0_dma_ops = {
+static const struct dma_map_ops ps3_ioc0_dma_ops = {
 	.alloc = ps3_alloc_coherent,
 	.free = ps3_free_coherent,
 	.map_sg = ps3_ioc0_map_sg,
diff --git a/arch/powerpc/platforms/pseries/ibmebus.c b/arch/powerpc/platforms/pseries/ibmebus.c
index 614c28537141..2e36a0b8944a 100644
--- a/arch/powerpc/platforms/pseries/ibmebus.c
+++ b/arch/powerpc/platforms/pseries/ibmebus.c
@@ -136,7 +136,7 @@ static u64 ibmebus_dma_get_required_mask(struct device *dev)
 	return DMA_BIT_MASK(64);
 }
 
-static struct dma_map_ops ibmebus_dma_ops = {
+static const struct dma_map_ops ibmebus_dma_ops = {
 	.alloc              = ibmebus_alloc_coherent,
 	.free               = ibmebus_free_coherent,
 	.map_sg             = ibmebus_map_sg,
diff --git a/arch/powerpc/platforms/pseries/vio.c b/arch/powerpc/platforms/pseries/vio.c
index 2c8fb3ec989e..720493932486 100644
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -615,7 +615,7 @@ static u64 vio_dma_get_required_mask(struct device *dev)
         return dma_iommu_ops.get_required_mask(dev);
 }
 
-static struct dma_map_ops vio_dma_mapping_ops = {
+static const struct dma_map_ops vio_dma_mapping_ops = {
 	.alloc             = vio_dma_iommu_alloc_coherent,
 	.free              = vio_dma_iommu_free_coherent,
 	.mmap		   = dma_direct_mmap_coherent,
diff --git a/arch/s390/include/asm/device.h b/arch/s390/include/asm/device.h
index 4a9f35e0973f..7955a9799466 100644
--- a/arch/s390/include/asm/device.h
+++ b/arch/s390/include/asm/device.h
@@ -4,7 +4,7 @@
  * This file is released under the GPLv2
  */
 struct dev_archdata {
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 };
 
 struct pdev_archdata {
diff --git a/arch/s390/include/asm/dma-mapping.h b/arch/s390/include/asm/dma-mapping.h
index ffaba07f50ab..2776d205b1ff 100644
--- a/arch/s390/include/asm/dma-mapping.h
+++ b/arch/s390/include/asm/dma-mapping.h
@@ -10,9 +10,9 @@
 
 #define DMA_ERROR_CODE		(~(dma_addr_t) 0x0)
 
-extern struct dma_map_ops s390_pci_dma_ops;
+extern const struct dma_map_ops s390_pci_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 1d7a9c71944a..9081a57fa340 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -650,7 +650,7 @@ static int __init dma_debug_do_init(void)
 }
 fs_initcall(dma_debug_do_init);
 
-struct dma_map_ops s390_pci_dma_ops = {
+const struct dma_map_ops s390_pci_dma_ops = {
 	.alloc		= s390_dma_alloc,
 	.free		= s390_dma_free,
 	.map_sg		= s390_dma_map_sg,
diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
index 0052ad40e86d..a7382c34c241 100644
--- a/arch/sh/include/asm/dma-mapping.h
+++ b/arch/sh/include/asm/dma-mapping.h
@@ -1,10 +1,10 @@
 #ifndef __ASM_SH_DMA_MAPPING_H
 #define __ASM_SH_DMA_MAPPING_H
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 extern void no_iommu_init(void);
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return dma_ops;
 }
diff --git a/arch/sh/kernel/dma-nommu.c b/arch/sh/kernel/dma-nommu.c
index 47fee3b6e29c..d24c707b2181 100644
--- a/arch/sh/kernel/dma-nommu.c
+++ b/arch/sh/kernel/dma-nommu.c
@@ -65,7 +65,7 @@ static void nommu_sync_sg(struct device *dev, struct scatterlist *sg,
 }
 #endif
 
-struct dma_map_ops nommu_dma_ops = {
+const struct dma_map_ops nommu_dma_ops = {
 	.alloc			= dma_generic_alloc_coherent,
 	.free			= dma_generic_free_coherent,
 	.map_page		= nommu_map_page,
diff --git a/arch/sh/mm/consistent.c b/arch/sh/mm/consistent.c
index 92b6976fde59..d1275adfa0ef 100644
--- a/arch/sh/mm/consistent.c
+++ b/arch/sh/mm/consistent.c
@@ -22,7 +22,7 @@
 
 #define PREALLOC_DMA_DEBUG_ENTRIES	4096
 
-struct dma_map_ops *dma_ops;
+const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int __init dma_init(void)
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 1180ae254154..3d2babc0c4c6 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -18,13 +18,13 @@ static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	 */
 }
 
-extern struct dma_map_ops *dma_ops;
-extern struct dma_map_ops *leon_dma_ops;
-extern struct dma_map_ops pci32_dma_ops;
+extern const struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *leon_dma_ops;
+extern const struct dma_map_ops pci32_dma_ops;
 
 extern struct bus_type pci_bus_type;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #ifdef CONFIG_SPARC_LEON
 	if (sparc_cpu_model == sparc_leon)
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 9df997995f6b..c63ba99ca551 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -741,7 +741,7 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static struct dma_map_ops sun4u_dma_ops = {
+static const struct dma_map_ops sun4u_dma_ops = {
 	.alloc			= dma_4u_alloc_coherent,
 	.free			= dma_4u_free_coherent,
 	.map_page		= dma_4u_map_page,
@@ -752,7 +752,7 @@ static struct dma_map_ops sun4u_dma_ops = {
 	.sync_sg_for_cpu	= dma_4u_sync_sg_for_cpu,
 };
 
-struct dma_map_ops *dma_ops = &sun4u_dma_ops;
+const struct dma_map_ops *dma_ops = &sun4u_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 int dma_supported(struct device *dev, u64 device_mask)
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 6ffaec44931a..cf20033a1458 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -401,7 +401,7 @@ static void sbus_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	BUG();
 }
 
-static struct dma_map_ops sbus_dma_ops = {
+static const struct dma_map_ops sbus_dma_ops = {
 	.alloc			= sbus_alloc_coherent,
 	.free			= sbus_free_coherent,
 	.map_page		= sbus_map_page,
@@ -637,7 +637,7 @@ static void pci32_sync_sg_for_device(struct device *device, struct scatterlist *
 	}
 }
 
-struct dma_map_ops pci32_dma_ops = {
+const struct dma_map_ops pci32_dma_ops = {
 	.alloc			= pci32_alloc_coherent,
 	.free			= pci32_free_coherent,
 	.map_page		= pci32_map_page,
@@ -652,10 +652,10 @@ struct dma_map_ops pci32_dma_ops = {
 EXPORT_SYMBOL(pci32_dma_ops);
 
 /* leon re-uses pci32_dma_ops */
-struct dma_map_ops *leon_dma_ops = &pci32_dma_ops;
+const struct dma_map_ops *leon_dma_ops = &pci32_dma_ops;
 EXPORT_SYMBOL(leon_dma_ops);
 
-struct dma_map_ops *dma_ops = &sbus_dma_ops;
+const struct dma_map_ops *dma_ops = &sbus_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index f4daccd12bf5..68bec7c97cb8 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -669,7 +669,7 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	local_irq_restore(flags);
 }
 
-static struct dma_map_ops sun4v_dma_ops = {
+static const struct dma_map_ops sun4v_dma_ops = {
 	.alloc				= dma_4v_alloc_coherent,
 	.free				= dma_4v_free_coherent,
 	.map_page			= dma_4v_map_page,
diff --git a/arch/tile/include/asm/device.h b/arch/tile/include/asm/device.h
index 6ab8bf146d4c..25f23ac7d361 100644
--- a/arch/tile/include/asm/device.h
+++ b/arch/tile/include/asm/device.h
@@ -18,7 +18,7 @@
 
 struct dev_archdata {
 	/* DMA operations on that device */
-        struct dma_map_ops	*dma_ops;
+        const struct dma_map_ops	*dma_ops;
 
 	/* Offset of the DMA address from the PA. */
 	dma_addr_t		dma_offset;
diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index 01ceb4a895b0..4a06cc75b856 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -24,12 +24,12 @@
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 #endif
 
-extern struct dma_map_ops *tile_dma_map_ops;
-extern struct dma_map_ops *gx_pci_dma_map_ops;
-extern struct dma_map_ops *gx_legacy_pci_dma_map_ops;
-extern struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
+extern const struct dma_map_ops *tile_dma_map_ops;
+extern const struct dma_map_ops *gx_pci_dma_map_ops;
+extern const struct dma_map_ops *gx_legacy_pci_dma_map_ops;
+extern const struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
@@ -59,7 +59,7 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
-static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
+static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
 	dev->archdata.dma_ops = ops;
 }
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index 24e0f8c21f2f..569bb6dd154a 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -329,7 +329,7 @@ tile_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static struct dma_map_ops tile_default_dma_map_ops = {
+static const struct dma_map_ops tile_default_dma_map_ops = {
 	.alloc = tile_dma_alloc_coherent,
 	.free = tile_dma_free_coherent,
 	.map_page = tile_dma_map_page,
@@ -344,7 +344,7 @@ static struct dma_map_ops tile_default_dma_map_ops = {
 	.dma_supported = tile_dma_supported
 };
 
-struct dma_map_ops *tile_dma_map_ops = &tile_default_dma_map_ops;
+const struct dma_map_ops *tile_dma_map_ops = &tile_default_dma_map_ops;
 EXPORT_SYMBOL(tile_dma_map_ops);
 
 /* Generic PCI DMA mapping functions */
@@ -516,7 +516,7 @@ tile_pci_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static struct dma_map_ops tile_pci_default_dma_map_ops = {
+static const struct dma_map_ops tile_pci_default_dma_map_ops = {
 	.alloc = tile_pci_dma_alloc_coherent,
 	.free = tile_pci_dma_free_coherent,
 	.map_page = tile_pci_dma_map_page,
@@ -531,7 +531,7 @@ static struct dma_map_ops tile_pci_default_dma_map_ops = {
 	.dma_supported = tile_pci_dma_supported
 };
 
-struct dma_map_ops *gx_pci_dma_map_ops = &tile_pci_default_dma_map_ops;
+const struct dma_map_ops *gx_pci_dma_map_ops = &tile_pci_default_dma_map_ops;
 EXPORT_SYMBOL(gx_pci_dma_map_ops);
 
 /* PCI DMA mapping functions for legacy PCI devices */
@@ -552,7 +552,7 @@ static void tile_swiotlb_free_coherent(struct device *dev, size_t size,
 	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
 }
 
-static struct dma_map_ops pci_swiotlb_dma_ops = {
+static const struct dma_map_ops pci_swiotlb_dma_ops = {
 	.alloc = tile_swiotlb_alloc_coherent,
 	.free = tile_swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
@@ -567,7 +567,7 @@ static struct dma_map_ops pci_swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 };
 
-static struct dma_map_ops pci_hybrid_dma_ops = {
+static const struct dma_map_ops pci_hybrid_dma_ops = {
 	.alloc = tile_swiotlb_alloc_coherent,
 	.free = tile_swiotlb_free_coherent,
 	.map_page = tile_pci_dma_map_page,
@@ -582,18 +582,18 @@ static struct dma_map_ops pci_hybrid_dma_ops = {
 	.dma_supported = tile_pci_dma_supported
 };
 
-struct dma_map_ops *gx_legacy_pci_dma_map_ops = &pci_swiotlb_dma_ops;
-struct dma_map_ops *gx_hybrid_pci_dma_map_ops = &pci_hybrid_dma_ops;
+const struct dma_map_ops *gx_legacy_pci_dma_map_ops = &pci_swiotlb_dma_ops;
+const struct dma_map_ops *gx_hybrid_pci_dma_map_ops = &pci_hybrid_dma_ops;
 #else
-struct dma_map_ops *gx_legacy_pci_dma_map_ops;
-struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
+const struct dma_map_ops *gx_legacy_pci_dma_map_ops;
+const struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
 #endif
 EXPORT_SYMBOL(gx_legacy_pci_dma_map_ops);
 EXPORT_SYMBOL(gx_hybrid_pci_dma_map_ops);
 
 int dma_set_mask(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	/*
 	 * For PCI devices with 64-bit DMA addressing capability, promote
@@ -623,7 +623,7 @@ EXPORT_SYMBOL(dma_set_mask);
 #ifdef CONFIG_ARCH_HAS_DMA_SET_COHERENT_MASK
 int dma_set_coherent_mask(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	/*
 	 * For PCI devices with 64-bit DMA addressing capability, promote
diff --git a/arch/unicore32/include/asm/dma-mapping.h b/arch/unicore32/include/asm/dma-mapping.h
index 4749854afd03..14d7729c7b73 100644
--- a/arch/unicore32/include/asm/dma-mapping.h
+++ b/arch/unicore32/include/asm/dma-mapping.h
@@ -21,9 +21,9 @@
 #include <asm/memory.h>
 #include <asm/cacheflush.h>
 
-extern struct dma_map_ops swiotlb_dma_map_ops;
+extern const struct dma_map_ops swiotlb_dma_map_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &swiotlb_dma_map_ops;
 }
diff --git a/arch/unicore32/mm/dma-swiotlb.c b/arch/unicore32/mm/dma-swiotlb.c
index 3e9f6489ba38..525413d6690e 100644
--- a/arch/unicore32/mm/dma-swiotlb.c
+++ b/arch/unicore32/mm/dma-swiotlb.c
@@ -31,7 +31,7 @@ static void unicore_swiotlb_free_coherent(struct device *dev, size_t size,
 	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
 }
 
-struct dma_map_ops swiotlb_dma_map_ops = {
+const struct dma_map_ops swiotlb_dma_map_ops = {
 	.alloc = unicore_swiotlb_alloc_coherent,
 	.free = unicore_swiotlb_free_coherent,
 	.map_sg = swiotlb_map_sg_attrs,
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 684ed6c3aa67..b2d0b4ced7e3 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -3,7 +3,7 @@
 
 struct dev_archdata {
 #ifdef CONFIG_X86_DEV_DMA_OPS
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 #endif
 #if defined(CONFIG_INTEL_IOMMU) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
@@ -13,7 +13,7 @@ struct dev_archdata {
 #if defined(CONFIG_X86_DEV_DMA_OPS) && defined(CONFIG_PCI_DOMAINS)
 struct dma_domain {
 	struct list_head node;
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 	int domain_nr;
 };
 void add_dma_domain(struct dma_domain *domain);
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 44461626830e..5e4772886a1e 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -25,9 +25,9 @@ extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #ifndef CONFIG_X86_DEV_DMA_OPS
 	return dma_ops;
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 345c99cef152..793869879464 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_IOMMU_H
 #define _ASM_X86_IOMMU_H
 
-extern struct dma_map_ops nommu_dma_ops;
+extern const struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_pass_through;
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index 63ff468a7986..82dfe32faaf4 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -695,7 +695,7 @@ static __init int init_amd_gatt(struct agp_kern_info *info)
 	return -1;
 }
 
-static struct dma_map_ops gart_dma_ops = {
+static const struct dma_map_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
 	.map_page			= gart_map_page,
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 5d400ba1349d..17f180148c80 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -478,7 +478,7 @@ static void calgary_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
-static struct dma_map_ops calgary_dma_ops = {
+static const struct dma_map_ops calgary_dma_ops = {
 	.alloc = calgary_alloc_coherent,
 	.free = calgary_free_coherent,
 	.map_sg = calgary_map_sg,
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d30c37750765..76f4c039baae 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -17,7 +17,7 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_map_ops *dma_ops = &nommu_dma_ops;
+const struct dma_map_ops *dma_ops = &nommu_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -214,7 +214,7 @@ early_param("iommu", iommu_setup);
 
 int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 00e71ce396a8..a88952ef371c 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -88,7 +88,7 @@ static void nommu_sync_sg_for_device(struct device *dev,
 	flush_write_buffers();
 }
 
-struct dma_map_ops nommu_dma_ops = {
+const struct dma_map_ops nommu_dma_ops = {
 	.alloc			= dma_generic_alloc_coherent,
 	.free			= dma_generic_free_coherent,
 	.map_sg			= nommu_map_sg,
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 410efb2c7b80..1e23577e17cf 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -45,7 +45,7 @@ void x86_swiotlb_free_coherent(struct device *dev, size_t size,
 		dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
 }
 
-static struct dma_map_ops swiotlb_dma_ops = {
+static const struct dma_map_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc = x86_swiotlb_alloc_coherent,
 	.free = x86_swiotlb_free_coherent,
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 052c1cb76305..aa3828823170 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -179,7 +179,7 @@ static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
 }
 
 /* We have our own dma_ops: the same as swiotlb but from alloc (above) */
-static struct dma_map_ops sta2x11_dma_ops = {
+static const struct dma_map_ops sta2x11_dma_ops = {
 	.alloc = sta2x11_swiotlb_alloc_coherent,
 	.free = x86_swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index a0b36a9d5df1..42b08f8fc2ca 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -18,7 +18,7 @@
 
 int xen_swiotlb __read_mostly;
 
-static struct dma_map_ops xen_swiotlb_dma_ops = {
+static const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.alloc = xen_swiotlb_alloc_coherent,
 	.free = xen_swiotlb_free_coherent,
 	.sync_single_for_cpu = xen_swiotlb_sync_single_for_cpu,
diff --git a/arch/xtensa/include/asm/device.h b/arch/xtensa/include/asm/device.h
index fe1f5c878493..a77d45d39f35 100644
--- a/arch/xtensa/include/asm/device.h
+++ b/arch/xtensa/include/asm/device.h
@@ -10,7 +10,7 @@ struct dma_map_ops;
 
 struct dev_archdata {
 	/* DMA operations on that device */
-	struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 };
 
 struct pdev_archdata {
diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
index 3fc1170a6488..50d23106cce0 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -18,9 +18,9 @@
 
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
 
-extern struct dma_map_ops xtensa_dma_map_ops;
+extern const struct dma_map_ops xtensa_dma_map_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index 70e362e6038e..ecec5265a66d 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -249,7 +249,7 @@ int xtensa_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return 0;
 }
 
-struct dma_map_ops xtensa_dma_map_ops = {
+const struct dma_map_ops xtensa_dma_map_ops = {
 	.alloc = xtensa_dma_alloc,
 	.free = xtensa_dma_free,
 	.map_page = xtensa_map_page,
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3ef0f42984f2..3703fb9db419 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -117,7 +117,7 @@ static const struct iommu_ops amd_iommu_ops;
 static ATOMIC_NOTIFIER_HEAD(ppr_notifier);
 int amd_iommu_max_glx_val = -1;
 
-static struct dma_map_ops amd_iommu_dma_ops;
+static const struct dma_map_ops amd_iommu_dma_ops;
 
 /*
  * This struct contains device specific data for the IOMMU
@@ -2728,7 +2728,7 @@ static int amd_iommu_dma_supported(struct device *dev, u64 mask)
 	return check_device(dev);
 }
 
-static struct dma_map_ops amd_iommu_dma_ops = {
+static const struct dma_map_ops amd_iommu_dma_ops = {
 	.alloc		= alloc_coherent,
 	.free		= free_coherent,
 	.map_page	= map_page,
diff --git a/drivers/misc/mic/bus/mic_bus.c b/drivers/misc/mic/bus/mic_bus.c
index be37890abb93..c4b27a25662a 100644
--- a/drivers/misc/mic/bus/mic_bus.c
+++ b/drivers/misc/mic/bus/mic_bus.c
@@ -143,7 +143,7 @@ static void mbus_release_dev(struct device *d)
 }
 
 struct mbus_device *
-mbus_register_device(struct device *pdev, int id, struct dma_map_ops *dma_ops,
+mbus_register_device(struct device *pdev, int id, const struct dma_map_ops *dma_ops,
 		     struct mbus_hw_ops *hw_ops, int index,
 		     void __iomem *mmio_va)
 {
diff --git a/drivers/misc/mic/bus/scif_bus.c b/drivers/misc/mic/bus/scif_bus.c
index ff6e01c25810..e5d377e97c86 100644
--- a/drivers/misc/mic/bus/scif_bus.c
+++ b/drivers/misc/mic/bus/scif_bus.c
@@ -138,7 +138,7 @@ static void scif_release_dev(struct device *d)
 }
 
 struct scif_hw_dev *
-scif_register_device(struct device *pdev, int id, struct dma_map_ops *dma_ops,
+scif_register_device(struct device *pdev, int id, const struct dma_map_ops *dma_ops,
 		     struct scif_hw_ops *hw_ops, u8 dnode, u8 snode,
 		     struct mic_mw *mmio, struct mic_mw *aper, void *dp,
 		     void __iomem *rdp, struct dma_chan **chan, int num_chan,
diff --git a/drivers/misc/mic/bus/scif_bus.h b/drivers/misc/mic/bus/scif_bus.h
index 94f29ac608b6..ff59568219ad 100644
--- a/drivers/misc/mic/bus/scif_bus.h
+++ b/drivers/misc/mic/bus/scif_bus.h
@@ -113,7 +113,7 @@ int scif_register_driver(struct scif_driver *driver);
 void scif_unregister_driver(struct scif_driver *driver);
 struct scif_hw_dev *
 scif_register_device(struct device *pdev, int id,
-		     struct dma_map_ops *dma_ops,
+		     const struct dma_map_ops *dma_ops,
 		     struct scif_hw_ops *hw_ops, u8 dnode, u8 snode,
 		     struct mic_mw *mmio, struct mic_mw *aper,
 		     void *dp, void __iomem *rdp,
diff --git a/drivers/misc/mic/bus/vop_bus.c b/drivers/misc/mic/bus/vop_bus.c
index 303da222f5b6..e3caa6c53922 100644
--- a/drivers/misc/mic/bus/vop_bus.c
+++ b/drivers/misc/mic/bus/vop_bus.c
@@ -154,7 +154,7 @@ vop_register_device(struct device *pdev, int id,
 	vdev->dev.parent = pdev;
 	vdev->id.device = id;
 	vdev->id.vendor = VOP_DEV_ANY_ID;
-	vdev->dev.archdata.dma_ops = (struct dma_map_ops *)dma_ops;
+	vdev->dev.archdata.dma_ops = dma_ops;
 	vdev->dev.dma_mask = &vdev->dev.coherent_dma_mask;
 	dma_set_mask(&vdev->dev, DMA_BIT_MASK(64));
 	vdev->dev.release = vop_release_dev;
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index 9599d732aff3..c327985c9523 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -245,7 +245,7 @@ static void __mic_dma_unmap_sg(struct device *dev,
 	dma_unmap_sg(&mdev->pdev->dev, sg, nents, dir);
 }
 
-static struct dma_map_ops __mic_dma_ops = {
+static const struct dma_map_ops __mic_dma_ops = {
 	.alloc = __mic_dma_alloc,
 	.free = __mic_dma_free,
 	.map_page = __mic_dma_map_page,
@@ -344,7 +344,7 @@ mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	mic_unmap_single(mdev, dma_addr, size);
 }
 
-static struct dma_map_ops mic_dma_ops = {
+static const struct dma_map_ops mic_dma_ops = {
 	.map_page = mic_dma_map_page,
 	.unmap_page = mic_dma_unmap_page,
 };
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 553ef8a5d588..aeb073b5fe16 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1011,7 +1011,7 @@ ccio_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	DBG_RUN_SG("%s() DONE (nents %d)\n", __func__, nents);
 }
 
-static struct dma_map_ops ccio_ops = {
+static const struct dma_map_ops ccio_ops = {
 	.dma_supported =	ccio_dma_supported,
 	.alloc =		ccio_alloc,
 	.free =			ccio_free,
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 151b86b6d2e2..33385e574433 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1069,7 +1069,7 @@ sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 
 }
 
-static struct dma_map_ops sba_ops = {
+static const struct dma_map_ops sba_ops = {
 	.dma_supported =	sba_dma_supported,
 	.alloc =		sba_alloc,
 	.free =			sba_free,
diff --git a/drivers/pci/host/vmd.c b/drivers/pci/host/vmd.c
index 18ef1a93c10a..e27ad2a3bd33 100644
--- a/drivers/pci/host/vmd.c
+++ b/drivers/pci/host/vmd.c
@@ -282,7 +282,7 @@ static struct device *to_vmd_dev(struct device *dev)
 	return &vmd->dev->dev;
 }
 
-static struct dma_map_ops *vmd_dma_ops(struct device *dev)
+static const struct dma_map_ops *vmd_dma_ops(struct device *dev)
 {
 	return get_dma_ops(to_vmd_dev(dev));
 }
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 10c5a17b1f51..f1da68b82c63 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -127,7 +127,7 @@ struct dma_map_ops {
 	int is_phys;
 };
 
-extern struct dma_map_ops dma_noop_ops;
+extern const struct dma_map_ops dma_noop_ops;
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
@@ -170,8 +170,8 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
  * dma dependent code.  Code that depends on the dma-mapping
  * API needs to set 'depends on HAS_DMA' in its Kconfig
  */
-extern struct dma_map_ops bad_dma_ops;
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+extern const struct dma_map_ops bad_dma_ops;
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return &bad_dma_ops;
 }
@@ -182,7 +182,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      enum dma_data_direction dir,
 					      unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(ptr, size);
@@ -201,7 +201,7 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 					  enum dma_data_direction dir,
 					  unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
@@ -217,7 +217,7 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 				   int nents, enum dma_data_direction dir,
 				   unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	int i, ents;
 	struct scatterlist *s;
 
@@ -235,7 +235,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
 				      int nents, enum dma_data_direction dir,
 				      unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	debug_dma_unmap_sg(dev, sg, nents, dir);
@@ -249,7 +249,7 @@ static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 					    enum dma_data_direction dir,
 					    unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
@@ -265,7 +265,7 @@ static inline void dma_unmap_page_attrs(struct device *dev,
 					enum dma_data_direction dir,
 					unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
@@ -279,7 +279,7 @@ static inline dma_addr_t dma_map_resource(struct device *dev,
 					  enum dma_data_direction dir,
 					  unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -300,7 +300,7 @@ static inline void dma_unmap_resource(struct device *dev, dma_addr_t addr,
 				      size_t size, enum dma_data_direction dir,
 				      unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_resource)
@@ -312,7 +312,7 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 					   size_t size,
 					   enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
@@ -324,7 +324,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					      dma_addr_t addr, size_t size,
 					      enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
@@ -364,7 +364,7 @@ static inline void
 dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		    int nelems, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
@@ -376,7 +376,7 @@ static inline void
 dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		       int nelems, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
@@ -421,7 +421,7 @@ static inline int
 dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma, void *cpu_addr,
 	       dma_addr_t dma_addr, size_t size, unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	BUG_ON(!ops);
 	if (ops->mmap)
 		return ops->mmap(dev, vma, cpu_addr, dma_addr, size, attrs);
@@ -439,7 +439,7 @@ dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt, void *cpu_addr,
 		      dma_addr_t dma_addr, size_t size,
 		      unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	BUG_ON(!ops);
 	if (ops->get_sgtable)
 		return ops->get_sgtable(dev, sgt, cpu_addr, dma_addr, size,
@@ -457,7 +457,7 @@ static inline void *dma_alloc_attrs(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag,
 				       unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	void *cpu_addr;
 
 	BUG_ON(!ops);
@@ -479,7 +479,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle,
 				     unsigned long attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!ops);
 	WARN_ON(irqs_disabled());
@@ -537,7 +537,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 #ifndef HAVE_ARCH_DMA_SUPPORTED
 static inline int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (!ops)
 		return 0;
@@ -550,7 +550,7 @@ static inline int dma_supported(struct device *dev, u64 mask)
 #ifndef HAVE_ARCH_DMA_SET_MASK
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (ops->set_dma_mask)
 		return ops->set_dma_mask(dev, mask);
diff --git a/include/linux/mic_bus.h b/include/linux/mic_bus.h
index 27d7c95fd0da..504d54c71bdb 100644
--- a/include/linux/mic_bus.h
+++ b/include/linux/mic_bus.h
@@ -90,7 +90,7 @@ struct mbus_hw_ops {
 };
 
 struct mbus_device *
-mbus_register_device(struct device *pdev, int id, struct dma_map_ops *dma_ops,
+mbus_register_device(struct device *pdev, int id, const struct dma_map_ops *dma_ops,
 		     struct mbus_hw_ops *hw_ops, int index,
 		     void __iomem *mmio_va);
 void mbus_unregister_device(struct mbus_device *mbdev);
diff --git a/include/xen/arm/hypervisor.h b/include/xen/arm/hypervisor.h
index 95251512e2c4..44b587b49904 100644
--- a/include/xen/arm/hypervisor.h
+++ b/include/xen/arm/hypervisor.h
@@ -18,7 +18,7 @@ static inline enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return PARAVIRT_LAZY_NONE;
 }
 
-extern struct dma_map_ops *xen_dma_ops;
+extern const struct dma_map_ops *xen_dma_ops;
 
 #ifdef CONFIG_XEN
 void __init xen_early_init(void);
diff --git a/lib/dma-noop.c b/lib/dma-noop.c
index 3d766e78fbe2..65e49dd35b7b 100644
--- a/lib/dma-noop.c
+++ b/lib/dma-noop.c
@@ -64,7 +64,7 @@ static int dma_noop_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-struct dma_map_ops dma_noop_ops = {
+const struct dma_map_ops dma_noop_ops = {
 	.alloc			= dma_noop_alloc,
 	.free			= dma_noop_free,
 	.map_page		= dma_noop_map_page,
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
