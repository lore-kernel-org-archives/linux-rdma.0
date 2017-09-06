From: Kittipon Meesompop <kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] libmlx5: add support for the s390x platform
Date: Wed,  6 Sep 2017 15:36:20 +0200
Message-ID: <20170906133620.58716-1-kmeesomp@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since s390x platform requires execution of privileged CPU instructions           
to work with PCI I/O memory, the PCI I/O memory cannot be directly               
accessed from the userspace programs via the mapped memory areas.                
                                                                                 
This patch is created against libmlx5-1.2.1 and contains the changes to          
the libmlx5 userspace Mellanox device driver library required to provide         
support for the DAPL API on the s390x platform. The original code that           
directly used mapped memory areas to access the PCI I/O memory of the            
Mellanox networking device is replaced with the new system call                  
invocation for writing the data to mapped memory areas. The functions            
for reading and writing are added analogously to libmlx4.                        
                                                                                 
libmlx4 comparison to:                                                           
        commit f5c26f8762135f629c8cbe73d808e3029f07b176                          
        Author: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>                     
        Date:   Wed Nov 19 11:17:19 2014 +0100                                   
                                                                                 
Signed-off-by: Kittipon Meesompop <kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

diff --git a/libmlx5-1.2.1.orig/Makefile.am b/libmlx5-1.2.1/Makefile.am
index 39ca65d..45fa45d 100644
--- a/libmlx5-1.2.1.orig/Makefile.am
+++ b/libmlx5-1.2.1/Makefile.am
@@ -4,7 +4,7 @@ ACLOCAL_AMFLAGS = -I m4
 mlx5_version_script = @MLX5_VERSION_SCRIPT@
 
 MLX5_SOURCES = src/buf.c src/cq.c src/dbrec.c src/mlx5.c src/qp.c src/srq.c src/verbs.c
-noinst_HEADERS = src/bitmap.h src/doorbell.h src/list.h src/mlx5-abi.h src/mlx5.h src/wqe.h
+noinst_HEADERS = src/bitmap.h src/doorbell.h src/list.h src/mlx5-abi.h src/mlx5.h src/wqe.h src/mmio.h
 
 
 if HAVE_IBV_DEVICE_LIBRARY_EXTENSION
diff --git a/libmlx5-1.2.1.orig/src/doorbell.h b/libmlx5-1.2.1/src/doorbell.h
index 7d4df8a..436c1cb 100644
--- a/libmlx5-1.2.1.orig/src/doorbell.h
+++ b/libmlx5-1.2.1/src/doorbell.h
@@ -34,6 +34,8 @@
 #ifndef DOORBELL_H
 #define DOORBELL_H
 
+#include "mmio.h"
+
 #if SIZEOF_LONG == 8
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -46,7 +48,7 @@
 
 static inline void mlx5_write64(uint32_t val[2], void *dest, struct mlx5_spinlock *lock)
 {
-	*(volatile uint64_t *)dest = MLX5_PAIR_TO_64(val);
+	mmio_writeq((unsigned long)dest, MLX5_PAIR_TO_64(val));
 }
 
 #else
@@ -54,8 +56,8 @@ static inline void mlx5_write64(uint32_t val[2], void *dest, struct mlx5_spinloc
 static inline void mlx5_write64(uint32_t val[2], void *dest, struct mlx5_spinlock *lock)
 {
 	mlx5_spin_lock(lock);
-	*(volatile uint32_t *)dest		= val[0];
-	*(volatile uint32_t *)(dest + 4)	= val[1];
+	mmio_writel((unsigned long)(dest), val[0]);
+	mmio_writel((unsigned long)(dest + 4), val[1]);
 	mlx5_spin_unlock(lock);
 }
 
diff --git a/libmlx5-1.2.1.orig/src/mlx5.h b/libmlx5-1.2.1/src/mlx5.h
index feb095c..125652c 100644
--- a/libmlx5-1.2.1.orig/src/mlx5.h
+++ b/libmlx5-1.2.1/src/mlx5.h
@@ -85,6 +85,8 @@
 #define wc_wmb() asm volatile("sfence" ::: "memory")
 #elif defined(__ia64__)
 #define wc_wmb() asm volatile("fwb" ::: "memory")
+#elif defined(__s390x__)
+#define wc_wmb { asm volatile("" : : : "memory") } 
 #else
 #define wc_wmb() wmb()
 #endif
diff --git a/libmlx5-1.2.1/src/mmio.h b/libmlx5-1.2.1/src/mmio.h
new file mode 100644
index 0000000..45afd80
--- /dev/null
+++ b/libmlx5-1.2.1/src/mmio.h
@@ -0,0 +1,130 @@
+#ifndef MMIO_H
+#define MMIO_H
+
+#include <unistd.h>
+#include <asm/unistd.h>
+#include <sys/syscall.h>
+#ifdef __s390x__
+
+static inline long mmio_writeb(const unsigned long mmio_addr,
+			       const uint8_t val)
+{
+	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
+}
+
+static inline long mmio_writew(const unsigned long mmio_addr,
+			       const uint16_t val)
+{
+	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
+}
+
+static inline long mmio_writel(const unsigned long mmio_addr,
+			       const uint32_t val)
+{
+	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
+}
+
+static inline long mmio_writeq(const unsigned long mmio_addr,
+			       const uint64_t val)
+{
+	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
+}
+
+static inline long mmio_write(const unsigned long mmio_addr,
+			      const void *val,
+			      const size_t length)
+{
+	return syscall(__NR_s390_pci_mmio_write, mmio_addr, val, length);
+}
+
+static inline long mmio_readb(const unsigned long mmio_addr, uint8_t *val)
+{
+	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
+}
+
+static inline long mmio_readw(const unsigned long mmio_addr, uint16_t *val)
+{
+	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
+}
+
+static inline long mmio_readl(const unsigned long mmio_addr, uint32_t *val)
+{
+	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
+}
+
+static inline long mmio_readq(const unsigned long mmio_addr, uint64_t *val)
+{
+	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
+}
+
+static inline long mmio_read(const unsigned long mmio_addr,
+			     void *val,
+			     const size_t length)
+{
+	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, length);
+}
+
+static inline void mlx5_bf_copy(unsigned long long *dst,
+				unsigned long long *src,
+				unsigned bytecnt, struct mlx5_qp *qp)
+{
+	while (bytecnt > 0) {
+	        mmio_write((unsigned long)dst, src, 64);
+		src += 8;
+		dst += 8;
+		bytecnt -= 8 * sizeof(unsigned long long);
+		if (unlikely(src == qp->sq.qend))
+			src = qp->buf.buf + qp->sq.offset;
+	}
+}
+
+#else
+
+#define mmio_writeb(addr, value) \
+	(*((volatile uint8_t *)addr) = value)
+#define mmio_writew(addr, value) \
+	(*((volatile uint16_t *)addr) = value)
+#define mmio_writel(addr, value) \
+	(*((volatile uint32_t *)addr) = value)
+#define mmio_writeq(addr, value) \
+	(*((volatile uint64_t *)addr) = value)
+#define mmio_write(addr, value, length) \
+	memcpy(addr, value, length)
+
+#define mmio_readb(addr, value) \
+	(value = *((volatile uint8_t *)addr))
+#define mmio_readw(addr, value) \
+	(value = *((volatile uint16_t *)addr))
+#define mmio_readl(addr, value) \
+	(value = *((volatile uint32_t *)addr))
+#define mmio_readq(addr, value) \
+	(value = *((volatile uint64_t *)addr))
+#define mmio_read(addr, value, length) \
+	memcpy(value, addr, length)
+
+/*
+ * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
+ * implementations may use move-string-buffer assembler instructions,
+ * which do not guarantee order of copying.
+ */
+static inline void mlx5_bf_copy(unsigned long long *dst,
+				unsigned long long *src,
+				unsigned bytecnt, struct mlx5_qp *qp)
+{
+        while (bytecnt > 0) {
+                *dst++ = *src++;
+                *dst++ = *src++;
+                *dst++ = *src++;
+                *dst++ = *src++;
+                *dst++ = *src++;
+                *dst++ = *src++;
+                *dst++ = *src++;
+                *dst++ = *src++;
+                bytecnt -= 8 * sizeof(unsigned long long);
+                if (unlikely(src == qp->sq.qend))
+                        src = qp->buf.buf + qp->sq.offset;
+        }
+}
+#endif
+
+#endif
diff --git a/libmlx5-1.2.1.orig/src/qp.c b/libmlx5-1.2.1/src/qp.c
index 51e1176..b9e2cc2 100644
--- a/libmlx5-1.2.1.orig/src/qp.c
+++ b/libmlx5-1.2.1/src/qp.c
@@ -222,29 +222,6 @@ static void set_data_ptr_seg_atomic(struct mlx5_wqe_data_seg *dseg,
 	dseg->addr       = htonll(sg->addr);
 }
 
-/*
- * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
- * implementations may use move-string-buffer assembler instructions,
- * which do not guarantee order of copying.
- */
-static void mlx5_bf_copy(unsigned long long *dst, unsigned long long *src,
-			 unsigned bytecnt, struct mlx5_qp *qp)
-{
-	while (bytecnt > 0) {
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		bytecnt -= 8 * sizeof(unsigned long long);
-		if (unlikely(src == qp->sq.qend))
-			src = qp->sq_start;
-	}
-}
-
 static uint32_t send_ieth(struct ibv_send_wr *wr)
 {
 	switch (wr->opcode) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
