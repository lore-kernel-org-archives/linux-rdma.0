From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 04/37] treewide: Consolidate get_dma_ops() implementations
Date: Fri, 20 Jan 2017 13:04:04 -0800
Message-ID: <20170120210437.26389-5-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce a new architecture-specific get_arch_dma_ops() function
that takes a struct bus_type * argument. Add get_dma_ops() in
<linux/dma-mapping.h>.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
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
 arch/alpha/include/asm/dma-mapping.h      | 2 +-
 arch/arc/include/asm/dma-mapping.h        | 2 +-
 arch/arm/include/asm/dma-mapping.h        | 4 ++--
 arch/arm64/include/asm/dma-mapping.h      | 4 ++--
 arch/avr32/include/asm/dma-mapping.h      | 2 +-
 arch/blackfin/include/asm/dma-mapping.h   | 2 +-
 arch/c6x/include/asm/dma-mapping.h        | 2 +-
 arch/cris/include/asm/dma-mapping.h       | 4 ++--
 arch/frv/include/asm/dma-mapping.h        | 2 +-
 arch/h8300/include/asm/dma-mapping.h      | 2 +-
 arch/hexagon/include/asm/dma-mapping.h    | 5 +----
 arch/ia64/include/asm/dma-mapping.h       | 5 ++++-
 arch/m32r/include/asm/dma-mapping.h       | 4 +---
 arch/m68k/include/asm/dma-mapping.h       | 2 +-
 arch/metag/include/asm/dma-mapping.h      | 2 +-
 arch/microblaze/include/asm/dma-mapping.h | 2 +-
 arch/mips/include/asm/dma-mapping.h       | 7 ++-----
 arch/mn10300/include/asm/dma-mapping.h    | 2 +-
 arch/nios2/include/asm/dma-mapping.h      | 2 +-
 arch/openrisc/include/asm/dma-mapping.h   | 2 +-
 arch/parisc/include/asm/dma-mapping.h     | 2 +-
 arch/powerpc/include/asm/dma-mapping.h    | 7 ++-----
 arch/powerpc/include/asm/ps3.h            | 2 +-
 arch/s390/include/asm/dma-mapping.h       | 4 +---
 arch/sh/include/asm/dma-mapping.h         | 2 +-
 arch/sparc/include/asm/dma-mapping.h      | 4 ++--
 arch/tile/include/asm/dma-mapping.h       | 7 ++-----
 arch/unicore32/include/asm/dma-mapping.h  | 2 +-
 arch/x86/include/asm/dma-mapping.h        | 9 +--------
 arch/xtensa/include/asm/dma-mapping.h     | 7 ++-----
 include/linux/dma-mapping.h               | 7 +++++++
 31 files changed, 48 insertions(+), 64 deletions(-)

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
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index c7432d647e53..716656925975 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -23,12 +23,12 @@ static inline const struct dma_map_ops *__generic_dma_ops(struct device *dev)
 	return &arm_dma_ops;
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
 
 #define HAVE_ARCH_DMA_SUPPORTED 1
diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 58ae36cc3b60..505756cdc67a 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
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
index 27b1597ac563..c01d9f52d228 100644
--- a/arch/m32r/include/asm/dma-mapping.h
+++ b/arch/m32r/include/asm/dma-mapping.h
@@ -10,10 +10,8 @@
 
 #define DMA_ERROR_CODE (~(dma_addr_t)0x0)
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->dma_ops)
-		return dev->dma_ops;
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
diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
index dad3b09fe993..aba71385f9d1 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -11,12 +11,9 @@
 
 extern const struct dma_map_ops *mips_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->dma_ops)
-		return dev->dma_ops;
-	else
-		return mips_dma_map_ops;
+	return mips_dma_map_ops;
 }
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
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
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 8275603ba4d5..181a095468e4 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -78,17 +78,14 @@ extern struct dma_map_ops dma_iommu_ops;
 #endif
 extern const struct dma_map_ops dma_direct_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	/* We don't handle the NULL dev case for ISA for now. We could
 	 * do it via an out of line call but it is not needed for now. The
 	 * only ISA DMA device we support is the floppy and we have a hack
 	 * in the floppy driver directly to get a device for us.
 	 */
-	if (unlikely(dev == NULL))
-		return NULL;
-
-	return dev->dma_ops;
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
 
diff --git a/arch/s390/include/asm/dma-mapping.h b/arch/s390/include/asm/dma-mapping.h
index a872027d0c1b..3108b8dbe266 100644
--- a/arch/s390/include/asm/dma-mapping.h
+++ b/arch/s390/include/asm/dma-mapping.h
@@ -12,10 +12,8 @@
 
 extern const struct dma_map_ops s390_pci_dma_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->dma_ops)
-		return dev->dma_ops;
 	return &dma_noop_ops;
 }
 
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
diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index 2562995a6ac9..bbc71a29b2c6 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -29,12 +29,9 @@ extern const struct dma_map_ops *gx_pci_dma_map_ops;
 extern const struct dma_map_ops *gx_legacy_pci_dma_map_ops;
 extern const struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->dma_ops)
-		return dev->dma_ops;
-	else
-		return tile_dma_map_ops;
+	return tile_dma_map_ops;
 }
 
 static inline dma_addr_t get_dma_offset(struct device *dev)
diff --git a/arch/unicore32/include/asm/dma-mapping.h b/arch/unicore32/include/asm/dma-mapping.h
index 14d7729c7b73..518ba5848dd6 100644
--- a/arch/unicore32/include/asm/dma-mapping.h
+++ b/arch/unicore32/include/asm/dma-mapping.h
@@ -23,7 +23,7 @@
 
 extern const struct dma_map_ops swiotlb_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
 	return &swiotlb_dma_map_ops;
 }
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 94b5b96966cb..08a0838b83fb 100644
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
-	if (unlikely(!dev) || !dev->dma_ops)
-		return dma_ops;
-	else
-		return dev->dma_ops;
-#endif
 }
 
 bool arch_dma_alloc_attrs(struct device **dev, gfp_t *gfp);
diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
index 9eecfc3c5dc4..c6140fa8c0be 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -20,12 +20,9 @@
 
 extern const struct dma_map_ops xtensa_dma_map_ops;
 
-static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	if (dev && dev->dma_ops)
-		return dev->dma_ops;
-	else
-		return &xtensa_dma_map_ops;
+	return &xtensa_dma_map_ops;
 }
 
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index e97f23e8b2d9..ab8710888ddf 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -164,6 +164,13 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
 
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (dev && dev->dma_ops)
+		return dev->dma_ops;
+	return get_arch_dma_ops(dev ? dev->bus : NULL);
+}
+
 static inline void set_dma_ops(struct device *dev,
 			       const struct dma_map_ops *dma_ops)
 {
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
