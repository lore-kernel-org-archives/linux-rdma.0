From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/9] Move dma_ops from archdata into struct device
Date: Tue, 10 Jan 2017 16:56:41 -0800
Message-ID: <20170111005648.14988-3-bart.vanassche@sandisk.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <20170111005648.14988-1-bart.vanassche@sandisk.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Aurelien Jacquiot <a-jacquiot@ti.com>, Catalin Marinas <catalin.marinas@arm.com>, Chris Zankel <chris@zankel.net>, David Howells <dhowells@redhat.com>, "David S . Miller" <davem@davemloft.net>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Geoff Levand <geoff@infradead.org>, "H . Peter Anvin" <hpa@zytor.com>, Haavard Skinnemoen <hskinnemoen@gmail.com>, Hans-Christian Egtvedt <egtvedt@samfundet.no>, Helge Deller <deller@gmx.de>, Ingo Molnar <mingo@redhat.com>, "James E . J . Bottomley" <jejb@parisc-linux.org>, Jesper Nilsson <jesper.nilsson@axis.com>, Joerg Roedel <joro@8bytes.org>, Jon Mason <jdmason@kudzu.us>
List-Id: linux-rdma@vger.kernel.org

Several RDMA drivers, e.g. drivers/infiniband/hw/qib, use the CPU to
transfer data between memory and PCIe adapter. Because of performance
reasons it is important that the CPU cache is not flushed when such
drivers transfer data. Make this possible by allowing these drivers to
override the dma_map_ops pointer. Additionally, introduce the function
set_dma_ops() that will be used by a later patch in this series.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jon Mason <jdmason@kudzu.us>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Muli Ben-Yehuda <mulix@mulix.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: x86@kernel.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: adi-buildroot-devel@lists.sourceforge.net
Cc: iommu@lists.linux-foundation.org
Cc: linux-alpha@vger.kernel.org
Cc: linux-am33-list@redhat.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-c6x-dev@linux-c6x.org
Cc: linux-cris-kernel@axis.com
Cc: linux-hexagon@vger.kernel.org
Cc: linux-ia64@vger.kernel.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-metag@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: linux-snps-arc@lists.infradead.org
Cc: linux-xtensa@linux-xtensa.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: nios2-dev@lists.rocketboards.org
Cc: openrisc@lists.librecores.org
Cc: sparclinux@vger.kernel.org
Cc: uclinux-h8-devel@lists.sourceforge.jp
---
 arch/alpha/include/asm/dma-mapping.h      |  2 +-
 arch/arc/include/asm/dma-mapping.h        |  2 +-
 arch/arm/include/asm/device.h             |  1 -
 arch/arm/include/asm/dma-mapping.h        | 17 ++++-------------
 arch/arm64/include/asm/device.h           |  1 -
 arch/arm64/include/asm/dma-mapping.h      |  8 ++++----
 arch/arm64/mm/dma-mapping.c               |  8 ++++----
 arch/avr32/include/asm/dma-mapping.h      |  2 +-
 arch/blackfin/include/asm/dma-mapping.h   |  2 +-
 arch/c6x/include/asm/dma-mapping.h        |  2 +-
 arch/cris/include/asm/dma-mapping.h       |  4 ++--
 arch/frv/include/asm/dma-mapping.h        |  2 +-
 arch/h8300/include/asm/dma-mapping.h      |  2 +-
 arch/hexagon/include/asm/dma-mapping.h    |  5 +----
 arch/ia64/include/asm/dma-mapping.h       |  5 ++++-
 arch/m32r/include/asm/dma-mapping.h       |  4 +---
 arch/m68k/include/asm/dma-mapping.h       |  2 +-
 arch/metag/include/asm/dma-mapping.h      |  2 +-
 arch/microblaze/include/asm/dma-mapping.h |  2 +-
 arch/mips/include/asm/device.h            |  5 -----
 arch/mips/include/asm/dma-mapping.h       |  7 ++-----
 arch/mips/pci/pci-octeon.c                |  2 +-
 arch/mn10300/include/asm/dma-mapping.h    |  2 +-
 arch/nios2/include/asm/dma-mapping.h      |  2 +-
 arch/openrisc/include/asm/dma-mapping.h   |  2 +-
 arch/parisc/include/asm/dma-mapping.h     |  2 +-
 arch/powerpc/include/asm/device.h         |  4 ----
 arch/powerpc/include/asm/dma-mapping.h    | 17 ++---------------
 arch/powerpc/include/asm/ps3.h            |  2 +-
 arch/powerpc/kernel/dma.c                 |  2 +-
 arch/powerpc/platforms/cell/iommu.c       |  2 +-
 arch/powerpc/platforms/pasemi/iommu.c     |  2 +-
 arch/powerpc/platforms/pasemi/setup.c     |  2 +-
 arch/powerpc/platforms/ps3/system-bus.c   |  4 ++--
 arch/powerpc/platforms/pseries/ibmebus.c  |  2 +-
 arch/s390/include/asm/device.h            |  1 -
 arch/s390/include/asm/dma-mapping.h       |  4 +---
 arch/s390/pci/pci.c                       |  2 +-
 arch/sh/include/asm/dma-mapping.h         |  2 +-
 arch/sparc/include/asm/dma-mapping.h      |  4 ++--
 arch/tile/include/asm/device.h            |  3 ---
 arch/tile/include/asm/dma-mapping.h       | 12 ++----------
 arch/x86/include/asm/device.h             |  3 ---
 arch/x86/include/asm/dma-mapping.h        |  9 +--------
 arch/x86/kernel/pci-calgary_64.c          |  4 ++--
 arch/x86/pci/common.c                     |  2 +-
 arch/x86/pci/sta2x11-fixup.c              |  8 ++++----
 arch/xtensa/include/asm/device.h          |  4 ----
 arch/xtensa/include/asm/dma-mapping.h     |  7 ++-----
 drivers/infiniband/ulp/srpt/ib_srpt.c     |  2 +-
 drivers/iommu/amd_iommu.c                 |  6 +++---
 drivers/misc/mic/bus/mic_bus.c            |  2 +-
 drivers/misc/mic/bus/scif_bus.c           |  2 +-
 drivers/misc/mic/bus/vop_bus.c            |  2 +-
 include/linux/device.h                    |  2 ++
 include/linux/dma-mapping.h               | 12 ++++++++++++
 56 files changed, 85 insertions(+), 140 deletions(-)

diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index d3480562411d..5d53666935e6 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -3,7 +3,7 @@
 
 extern const struct dma_map_ops *dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return dma_ops;
 }
diff --git a/arch/arc/include/asm/dma-mapping.h b/arch/arc/include/asm/dma-mapping.h
index fdff3aa60052..94285031c4fb 100644
--- a/arch/arc/include/asm/dma-mapping.h
+++ b/arch/arc/include/asm/dma-mapping.h
@@ -20,7 +20,7 @@
 
 extern const struct dma_map_ops arc_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &arc_dma_ops;
 }
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
index 1aabd781306f..7c6d995fb935 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -18,23 +18,14 @@ extern const struct dma_map_ops arm_coherent_dma_ops;
 
 static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
 	return &arm_dma_ops;
 }
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (xen_initial_domain())
-		return xen_dma_ops;
-	else
-		return __generic_dma_ops(dev);
-}
-
-static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
-{
-	BUG_ON(!dev);
-	dev->archdata.dma_ops = ops;
+	return xen_initial_domain() ? xen_dma_ops : &arm_dma_ops;
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
index 1fedb43be712..ff311c67ab0c 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -29,8 +29,8 @@ extern const struct dma_map_ops dummy_dma_ops;
 
 static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
+       if (dev && dev->dma_ops)
+               return dev->dma_ops;
 
 	/*
 	 * We expect no ISA devices, and all other DMA masters are expected to
@@ -39,12 +39,12 @@ static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 	return &dummy_dma_ops;
 }
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	if (xen_initial_domain())
 		return xen_dma_ops;
 	else
-		return __generic_dma_ops(dev);
+		return __generic_dma_ops(NULL);
 }
 
 void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index bcef6368d48f..9c80a3cbce59 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -837,7 +837,7 @@ static bool do_iommu_attach(struct device *dev, const struct iommu_ops *ops,
 		return false;
 	}
 
-	dev->archdata.dma_ops = &iommu_dma_ops;
+	set_dma_ops(dev, &iommu_dma_ops);
 	return true;
 }
 
@@ -941,7 +941,7 @@ static void __iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 
 void arch_teardown_dma_ops(struct device *dev)
 {
-	dev->archdata.dma_ops = NULL;
+	set_dma_ops(dev, NULL);
 }
 
 #else
@@ -955,8 +955,8 @@ static void __iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 			const struct iommu_ops *iommu, bool coherent)
 {
-	if (!dev->archdata.dma_ops)
-		dev->archdata.dma_ops = &swiotlb_dma_ops;
+	if (!dev->dma_ops)
+		set_dma_ops(dev, &swiotlb_dma_ops);
 
 	dev->archdata.dma_coherent = coherent;
 	__iommu_setup_dma_ops(dev, dma_base, size, iommu);
diff --git a/arch/avr32/include/asm/dma-mapping.h b/arch/avr32/include/asm/dma-mapping.h
index b2b43c0e0774..7388451f9905 100644
--- a/arch/avr32/include/asm/dma-mapping.h
+++ b/arch/avr32/include/asm/dma-mapping.h
@@ -6,7 +6,7 @@ extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 
 extern const struct dma_map_ops avr32_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &avr32_dma_ops;
 }
diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index 320fb50fbd41..04254ac36bed 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -38,7 +38,7 @@ _dma_sync(dma_addr_t addr, size_t size, enum dma_data_direction dir)
 
 extern const struct dma_map_ops bfin_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &bfin_dma_ops;
 }
diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
index 88258b9ebc8e..aca9f755e4f8 100644
--- a/arch/c6x/include/asm/dma-mapping.h
+++ b/arch/c6x/include/asm/dma-mapping.h
@@ -19,7 +19,7 @@
 
 extern const struct dma_map_ops c6x_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &c6x_dma_ops;
 }
diff --git a/arch/cris/include/asm/dma-mapping.h b/arch/cris/include/asm/dma-mapping.h
index aae4fbc0a656..256169de3743 100644
--- a/arch/cris/include/asm/dma-mapping.h
+++ b/arch/cris/include/asm/dma-mapping.h
@@ -4,12 +4,12 @@
 #ifdef CONFIG_PCI
 extern const struct dma_map_ops v32_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &v32_dma_ops;
 }
 #else
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	BUG();
 	return NULL;
diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index 150cc00544a8..354900917585 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -9,7 +9,7 @@ extern unsigned long __nongprelbss dma_coherent_mem_end;
 
 extern const struct dma_map_ops frv_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &frv_dma_ops;
 }
diff --git a/arch/h8300/include/asm/dma-mapping.h b/arch/h8300/include/asm/dma-mapping.h
index f804bca4c13f..847c7562e046 100644
--- a/arch/h8300/include/asm/dma-mapping.h
+++ b/arch/h8300/include/asm/dma-mapping.h
@@ -3,7 +3,7 @@
 
 extern const struct dma_map_ops h8300_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &h8300_dma_map_ops;
 }
diff --git a/arch/hexagon/include/asm/dma-mapping.h b/arch/hexagon/include/asm/dma-mapping.h
index b812e917cd95..d3a87bd9b686 100644
--- a/arch/hexagon/include/asm/dma-mapping.h
+++ b/arch/hexagon/include/asm/dma-mapping.h
@@ -34,11 +34,8 @@ extern int bad_dma_address;
 
 extern const struct dma_map_ops *dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (unlikely(dev == NULL))
-		return NULL;
-
 	return dma_ops;
 }
 
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 05e467d56d86..73ec3c6f4cfe 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -23,7 +23,10 @@ extern void machvec_dma_sync_single(struct device *, dma_addr_t, size_t,
 extern void machvec_dma_sync_sg(struct device *, struct scatterlist *, int,
 				enum dma_data_direction);
 
-#define get_dma_ops(dev) platform_dma_get_ops(dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
+{
+	return platform_dma_get_ops(NULL);
+}
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
diff --git a/arch/m32r/include/asm/dma-mapping.h b/arch/m32r/include/asm/dma-mapping.h
index 99c43d2f05dc..c01d9f52d228 100644
--- a/arch/m32r/include/asm/dma-mapping.h
+++ b/arch/m32r/include/asm/dma-mapping.h
@@ -10,10 +10,8 @@
 
 #define DMA_ERROR_CODE (~(dma_addr_t)0x0)
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
 	return &dma_noop_ops;
 }
 
diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index 863509939d5a..9210e470771b 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -3,7 +3,7 @@
 
 extern const struct dma_map_ops m68k_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
         return &m68k_dma_ops;
 }
diff --git a/arch/metag/include/asm/dma-mapping.h b/arch/metag/include/asm/dma-mapping.h
index c156a7ac732f..fad3dc3cb210 100644
--- a/arch/metag/include/asm/dma-mapping.h
+++ b/arch/metag/include/asm/dma-mapping.h
@@ -3,7 +3,7 @@
 
 extern const struct dma_map_ops metag_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &metag_dma_ops;
 }
diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
index c7faf2fb51d6..3fad5e722a66 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -38,7 +38,7 @@
  */
 extern const struct dma_map_ops dma_direct_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &dma_direct_ops;
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
index b59b084a7569..aba71385f9d1 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -11,12 +11,9 @@
 
 extern const struct dma_map_ops *mips_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
-	else
-		return mips_dma_map_ops;
+	return mips_dma_map_ops;
 }
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index 308d051fc45c..7da99a908229 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -167,7 +167,7 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 		pci_write_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, dconfig);
 	}
 
-	dev->dev.archdata.dma_ops = octeon_pci_dma_map_ops;
+	set_dma_ops(&dev->dev, octeon_pci_dma_map_ops);
 
 	return 0;
 }
diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index 564e3927e005..737ef574b3ea 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -16,7 +16,7 @@
 
 extern const struct dma_map_ops mn10300_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &mn10300_dma_ops;
 }
diff --git a/arch/nios2/include/asm/dma-mapping.h b/arch/nios2/include/asm/dma-mapping.h
index aa00d839a64b..7b3c6f280293 100644
--- a/arch/nios2/include/asm/dma-mapping.h
+++ b/arch/nios2/include/asm/dma-mapping.h
@@ -12,7 +12,7 @@
 
 extern const struct dma_map_ops nios2_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &nios2_dma_ops;
 }
diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
index 88acbedb4947..0c0075f17145 100644
--- a/arch/openrisc/include/asm/dma-mapping.h
+++ b/arch/openrisc/include/asm/dma-mapping.h
@@ -30,7 +30,7 @@
 
 extern const struct dma_map_ops or1k_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &or1k_dma_map_ops;
 }
diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index 1749073e44fc..5404c6a726b2 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -27,7 +27,7 @@ extern const struct dma_map_ops pcx_dma_ops;
 
 extern const struct dma_map_ops *hppa_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return hppa_dma_ops;
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
index 2ec3eadf336f..efdcf87c4c2f 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -78,22 +78,9 @@ extern struct dma_map_ops dma_iommu_ops;
 #endif
 extern const struct dma_map_ops dma_direct_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	/* We don't handle the NULL dev case for ISA for now. We could
-	 * do it via an out of line call but it is not needed for now. The
-	 * only ISA DMA device we support is the floppy and we have a hack
-	 * in the floppy driver directly to get a device for us.
-	 */
-	if (unlikely(dev == NULL))
-		return NULL;
-
-	return dev->archdata.dma_ops;
-}
-
-static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
-{
-	dev->archdata.dma_ops = ops;
+	return NULL;
 }
 
 /*
diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index a19f831a4cc9..17ee719e799f 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -435,7 +435,7 @@ static inline void *ps3_system_bus_get_drvdata(
 	return dev_get_drvdata(&dev->core);
 }
 
-/* These two need global scope for get_dma_ops(). */
+/* These two need global scope for get_arch_dma_ops(). */
 
 extern struct bus_type ps3_system_bus_type;
 
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
index e1413e69e5fe..592a2a0f4860 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -692,7 +692,7 @@ static int cell_of_bus_notify(struct notifier_block *nb, unsigned long action,
 		return 0;
 
 	/* We use the PCI DMA ops */
-	dev->archdata.dma_ops = get_pci_dma_ops();
+	set_dma_ops(dev, get_pci_dma_ops());
 
 	cell_dma_dev_setup(dev);
 
diff --git a/arch/powerpc/platforms/pasemi/iommu.c b/arch/powerpc/platforms/pasemi/iommu.c
index e74adc4e7fd8..66bf56788260 100644
--- a/arch/powerpc/platforms/pasemi/iommu.c
+++ b/arch/powerpc/platforms/pasemi/iommu.c
@@ -186,7 +186,7 @@ static void pci_dma_dev_setup_pasemi(struct pci_dev *dev)
 	 */
 	if (dev->vendor == 0x1959 && dev->device == 0xa007 &&
 	    !firmware_has_feature(FW_FEATURE_LPAR)) {
-		dev->dev.archdata.dma_ops = &dma_direct_ops;
+		set_dma_ops(&dev->dev, &dma_direct_ops);
 		/*
 		 * Set the coherent DMA mask to prevent the iommu
 		 * being used unnecessarily
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 3182400cf48f..a00412d369f8 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -363,7 +363,7 @@ static int pcmcia_notify(struct notifier_block *nb, unsigned long action,
 		return 0;
 
 	/* We use the direct ops for localbus */
-	dev->archdata.dma_ops = &dma_direct_ops;
+	set_dma_ops(dev, &dma_direct_ops);
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index c81450d98794..b78041049146 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -756,11 +756,11 @@ int ps3_system_bus_device_register(struct ps3_system_bus_device *dev)
 
 	switch (dev->dev_type) {
 	case PS3_DEVICE_TYPE_IOC0:
-		dev->core.archdata.dma_ops = &ps3_ioc0_dma_ops;
+		set_dma_ops(&dev->core, &ps3_ioc0_dma_ops);
 		dev_set_name(&dev->core, "ioc0_%02x", ++dev_ioc0_count);
 		break;
 	case PS3_DEVICE_TYPE_SB:
-		dev->core.archdata.dma_ops = &ps3_sb_dma_ops;
+		set_dma_ops(&dev->core, &ps3_sb_dma_ops);
 		dev_set_name(&dev->core, "sb_%02x", ++dev_sb_count);
 
 		break;
diff --git a/arch/powerpc/platforms/pseries/ibmebus.c b/arch/powerpc/platforms/pseries/ibmebus.c
index 2e36a0b8944a..05063fd9b05f 100644
--- a/arch/powerpc/platforms/pseries/ibmebus.c
+++ b/arch/powerpc/platforms/pseries/ibmebus.c
@@ -169,7 +169,7 @@ static int ibmebus_create_device(struct device_node *dn)
 		return -ENOMEM;
 
 	dev->dev.bus = &ibmebus_bus_type;
-	dev->dev.archdata.dma_ops = &ibmebus_dma_ops;
+	set_dma_ops(&dev->dev, &ibmebus_dma_ops);
 
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
index 2776d205b1ff..3108b8dbe266 100644
--- a/arch/s390/include/asm/dma-mapping.h
+++ b/arch/s390/include/asm/dma-mapping.h
@@ -12,10 +12,8 @@
 
 extern const struct dma_map_ops s390_pci_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
 	return &dma_noop_ops;
 }
 
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 38e17d4d9884..5b4177d8f4c3 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -641,7 +641,7 @@ int pcibios_add_device(struct pci_dev *pdev)
 	int i;
 
 	pdev->dev.groups = zpci_attr_groups;
-	pdev->dev.archdata.dma_ops = &s390_pci_dma_ops;
+	set_dma_ops(&pdev->dev, &s390_pci_dma_ops);
 	zpci_map_resources(pdev);
 
 	for (i = 0; i < PCI_BAR_COUNT; i++) {
diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
index a7382c34c241..d99008af5f73 100644
--- a/arch/sh/include/asm/dma-mapping.h
+++ b/arch/sh/include/asm/dma-mapping.h
@@ -4,7 +4,7 @@
 extern const struct dma_map_ops *dma_ops;
 extern void no_iommu_init(void);
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return dma_ops;
 }
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 3d2babc0c4c6..69cc627779f2 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -24,14 +24,14 @@ extern const struct dma_map_ops pci32_dma_ops;
 
 extern struct bus_type pci_bus_type;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 #ifdef CONFIG_SPARC_LEON
 	if (sparc_cpu_model == sparc_leon)
 		return leon_dma_ops;
 #endif
 #if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
-	if (dev->bus == &pci_bus_type)
+	if (bus == &pci_bus_type)
 		return &pci32_dma_ops;
 #endif
 	return dma_ops;
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
index 4a06cc75b856..bbc71a29b2c6 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -29,12 +29,9 @@ extern const struct dma_map_ops *gx_pci_dma_map_ops;
 extern const struct dma_map_ops *gx_legacy_pci_dma_map_ops;
 extern const struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
-	else
-		return tile_dma_map_ops;
+	return tile_dma_map_ops;
 }
 
 static inline dma_addr_t get_dma_offset(struct device *dev)
@@ -59,11 +56,6 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
-static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
-{
-	dev->archdata.dma_ops = ops;
-}
-
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
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
index 5e4772886a1e..08a0838b83fb 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -27,16 +27,9 @@ extern int panic_on_overflow;
 
 extern const struct dma_map_ops *dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-#ifndef CONFIG_X86_DEV_DMA_OPS
 	return dma_ops;
-#else
-	if (unlikely(!dev) || !dev->archdata.dma_ops)
-		return dma_ops;
-	else
-		return dev->archdata.dma_ops;
-#endif
 }
 
 bool arch_dma_alloc_attrs(struct device **dev, gfp_t *gfp);
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 17f180148c80..87f9a1ff7cf6 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1177,7 +1177,7 @@ static int __init calgary_init(void)
 		tbl = find_iommu_table(&dev->dev);
 
 		if (translation_enabled(tbl))
-			dev->dev.archdata.dma_ops = &calgary_dma_ops;
+			set_dma_ops(&dev->dev, &calgary_dma_ops);
 	}
 
 	return ret;
@@ -1201,7 +1201,7 @@ static int __init calgary_init(void)
 		calgary_disable_translation(dev);
 		calgary_free_bus(dev);
 		pci_dev_put(dev); /* Undo calgary_init_one()'s pci_dev_get() */
-		dev->dev.archdata.dma_ops = NULL;
+		set_dma_ops(&dev->dev, NULL);
 	} while (1);
 
 	return ret;
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index a4fdfa7dcc1b..944e13c1a1e4 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -667,7 +667,7 @@ static void set_dma_domain_ops(struct pci_dev *pdev)
 	spin_lock(&dma_domain_list_lock);
 	list_for_each_entry(domain, &dma_domain_list, node) {
 		if (pci_domain_nr(pdev->bus) == domain->domain_nr) {
-			pdev->dev.archdata.dma_ops = domain->dma_ops;
+			set_dma_ops(&pdev->dev, domain->dma_ops);
 			break;
 		}
 	}
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index aa3828823170..21008548f225 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -203,7 +203,7 @@ static void sta2x11_setup_pdev(struct pci_dev *pdev)
 		return;
 	pci_set_consistent_dma_mask(pdev, STA2X11_AMBA_SIZE - 1);
 	pci_set_dma_mask(pdev, STA2X11_AMBA_SIZE - 1);
-	pdev->dev.archdata.dma_ops = &sta2x11_dma_ops;
+	set_dma_ops(&pdev->dev, &sta2x11_dma_ops);
 
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
index 50d23106cce0..c6140fa8c0be 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -20,12 +20,9 @@
 
 extern const struct dma_map_ops xtensa_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->archdata.dma_ops)
-		return dev->archdata.dma_ops;
-	else
-		return &xtensa_dma_map_ops;
+	return &xtensa_dma_map_ops;
 }
 
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3fc3f8b5752b..20444a7d867d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2524,7 +2524,7 @@ static void srpt_add_one(struct ib_device *device)
 	int i;
 
 	pr_debug("device = %p, device->dma_ops = %p\n", device,
-		 device->dma_ops);
+		 get_dma_ops(device->dma_device));
 
 	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
 	if (!sdev)
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3703fb9db419..246a88d96a97 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -515,7 +515,7 @@ static void iommu_uninit_device(struct device *dev)
 	iommu_group_remove_device(dev);
 
 	/* Remove dma-ops */
-	dev->archdata.dma_ops = NULL;
+	set_dma_ops(dev, NULL);
 
 	/*
 	 * We keep dev_data around for unplugged devices and reuse it when the
@@ -2164,7 +2164,7 @@ static int amd_iommu_add_device(struct device *dev)
 				dev_name(dev));
 
 		iommu_ignore_device(dev);
-		dev->archdata.dma_ops = &nommu_dma_ops;
+		set_dma_ops(dev, &nommu_dma_ops);
 		goto out;
 	}
 	init_iommu_group(dev);
@@ -2181,7 +2181,7 @@ static int amd_iommu_add_device(struct device *dev)
 	if (domain->type == IOMMU_DOMAIN_IDENTITY)
 		dev_data->passthrough = true;
 	else
-		dev->archdata.dma_ops = &amd_iommu_dma_ops;
+		set_dma_ops(dev, &amd_iommu_dma_ops);
 
 out:
 	iommu_completion_wait(iommu);
diff --git a/drivers/misc/mic/bus/mic_bus.c b/drivers/misc/mic/bus/mic_bus.c
index c4b27a25662a..ee6e4ef370ea 100644
--- a/drivers/misc/mic/bus/mic_bus.c
+++ b/drivers/misc/mic/bus/mic_bus.c
@@ -158,7 +158,7 @@ mbus_register_device(struct device *pdev, int id, const struct dma_map_ops *dma_
 	mbdev->dev.parent = pdev;
 	mbdev->id.device = id;
 	mbdev->id.vendor = MBUS_DEV_ANY_ID;
-	mbdev->dev.archdata.dma_ops = dma_ops;
+	set_dma_ops(&mbdev->dev, dma_ops);
 	mbdev->dev.dma_mask = &mbdev->dev.coherent_dma_mask;
 	dma_set_mask(&mbdev->dev, DMA_BIT_MASK(64));
 	mbdev->dev.release = mbus_release_dev;
diff --git a/drivers/misc/mic/bus/scif_bus.c b/drivers/misc/mic/bus/scif_bus.c
index e5d377e97c86..d4d559cad6a1 100644
--- a/drivers/misc/mic/bus/scif_bus.c
+++ b/drivers/misc/mic/bus/scif_bus.c
@@ -154,7 +154,7 @@ scif_register_device(struct device *pdev, int id, const struct dma_map_ops *dma_
 	sdev->dev.parent = pdev;
 	sdev->id.device = id;
 	sdev->id.vendor = SCIF_DEV_ANY_ID;
-	sdev->dev.archdata.dma_ops = dma_ops;
+	set_dma_ops(&sdev->dev, dma_ops);
 	sdev->dev.release = scif_release_dev;
 	sdev->hw_ops = hw_ops;
 	sdev->dnode = dnode;
diff --git a/drivers/misc/mic/bus/vop_bus.c b/drivers/misc/mic/bus/vop_bus.c
index b59551f5db65..c96a05f811f2 100644
--- a/drivers/misc/mic/bus/vop_bus.c
+++ b/drivers/misc/mic/bus/vop_bus.c
@@ -154,7 +154,7 @@ vop_register_device(struct device *pdev, int id,
 	vdev->dev.parent = pdev;
 	vdev->id.device = id;
 	vdev->id.vendor = VOP_DEV_ANY_ID;
-	vdev->dev.archdata.dma_ops = (const struct dma_map_ops *)dma_ops;
+	set_dma_ops(&vdev->dev, dma_ops);
 	vdev->dev.dma_mask = &vdev->dev.coherent_dma_mask;
 	dma_set_mask(&vdev->dev, DMA_BIT_MASK(64));
 	vdev->dev.release = vop_release_dev;
diff --git a/include/linux/device.h b/include/linux/device.h
index 491b4c0ca633..c7cb225d36b0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -885,6 +885,8 @@ struct dev_links_info {
  * a higher-level representation of the device.
  */
 struct device {
+	const struct dma_map_ops *dma_ops; /* See also get_dma_ops() */
+
 	struct device		*parent;
 
 	struct device_private	*p;
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index f1da68b82c63..ab8710888ddf 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -164,6 +164,18 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
 
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
+	return get_arch_dma_ops(dev ? dev->bus : NULL);
+}
+
+static inline void set_dma_ops(struct device *dev,
+			       const struct dma_map_ops *dma_ops)
+{
+	dev->dma_ops = dma_ops;
+}
 #else
 /*
  * Define the dma api to allow compilation but not linking of
-- 
2.11.0
