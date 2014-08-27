From: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 3/5] libmlx4: add support for s390x platform
Date: Wed, 27 Aug 2014 12:24:38 +0200
Message-ID: <1409135080-44991-4-git-send-email-aishchuk@linux.vnet.ibm.com>
References: <1409135080-44991-1-git-send-email-aishchuk@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409135080-44991-1-git-send-email-aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since s390x platform requires execution of privileged CPU instructions
to work with PCI I/O memory, the PCI I/O memory cannot be directly accessed
from the userspace programs via the mapped memory areas. The current
implementation of the Inifiniband verbs uses mapped memory areas to
write data to device UAR and Blueflame page to initiate the I/O
operations, these verbs cannot be used on the s390x platfrom without
modification.
This patch contains the changes to the libmlx4 userspace Mellanox device
driver library required to provide support for the DAPL API on the s390x
platform. The original code that directly used mapped memory areas to access
the PCI I/O  memory of the Mellanox networking device is replaced with the
new system call invocation for writing the data to mapped memory areas.

Signed-off-by: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 src/doorbell.h |    8 +--
 src/mlx4.h     |    2 
 src/mmio.h     |  151 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/qp.c       |   17 ------
 4 files changed, 160 insertions(+), 18 deletions(-)

--- a/src/doorbell.h
+++ b/src/doorbell.h
@@ -33,6 +33,8 @@
 #ifndef DOORBELL_H
 #define DOORBELL_H
 
+#include "mmio.h"
+
 #if SIZEOF_LONG == 8
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -45,7 +47,7 @@
 
 static inline void mlx4_write64(uint32_t val[2], struct mlx4_context *ctx, int offset)
 {
-	*(volatile uint64_t *) (ctx->uar + offset) = MLX4_PAIR_TO_64(val);
+	mmio_writeq((unsigned long)(ctx->uar + offset), MLX4_PAIR_TO_64(val));
 }
 
 #else
@@ -53,8 +55,8 @@ static inline void mlx4_write64(uint32_t
 static inline void mlx4_write64(uint32_t val[2], struct mlx4_context *ctx, int offset)
 {
 	pthread_spin_lock(&ctx->uar_lock);
-	*(volatile uint32_t *) (ctx->uar + offset)     = val[0];
-	*(volatile uint32_t *) (ctx->uar + offset + 4) = val[1];
+	mmio_writel((unsigned long)(ctx->uar + offset), val[0]);
+	mmio_writel((unsigned long)(ctx->uar + offset + 4), val[1]);
 	pthread_spin_unlock(&ctx->uar_lock);
 }
 
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -73,6 +73,8 @@
 #define wc_wmb() asm volatile("sfence" ::: "memory")
 #elif defined(__ia64__)
 #define wc_wmb() asm volatile("fwb" ::: "memory")
+#elif defined(__s390x__)
+#define wc_wmb { asm volatile("" : : : "memory") }
 #else
 #define wc_wmb() wmb()
 #endif
--- /dev/null
+++ b/src/mmio.h
@@ -0,0 +1,151 @@
+/*
+ * Copyright (c) 2014 IBM Corporation
+ */
+#ifndef MMIO_H
+#define MMIO_H
+
+#include <unistd.h>
+#include <asm/unistd.h>
+#include <sys/syscall.h>
+#ifdef __s390x__
+
+#define s390_pci_mmio_write_call(addr, value) \
+	syscall(__NR_s390_pci_mmio_write, addr, &value, sizeof(value))
+
+
+static inline long s390_pci_mmio_writeb(const unsigned long mmio_addr,
+					const uint8_t val)
+{
+	return s390_pci_mmio_write_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_writew(const unsigned long mmio_addr,
+					const uint16_t val)
+{
+	return s390_pci_mmio_write_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_writel(const unsigned long mmio_addr,
+					const uint32_t val)
+{
+	return s390_pci_mmio_write_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_writeq(const unsigned long mmio_addr,
+					const uint64_t val)
+{
+	return s390_pci_mmio_write_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_write(const unsigned long mmio_addr,
+				       const void *val,
+				       const size_t length)
+{
+	return syscall(__NR_s390_pci_mmio_write, mmio_addr, val, length);
+}
+
+#define s390_pci_mmio_read_call(addr, value)	\
+	syscall(__NR_s390_pci_mmio_read, addr, value, sizeof(*value))
+
+static inline long s390_pci_mmio_readb(const unsigned long mmio_addr,
+				       uint8_t *val)
+{
+	return s390_pci_mmio_read_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_readw(const unsigned long mmio_addr,
+				       uint16_t *val)
+{
+	return s390_pci_mmio_read_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_readl(const unsigned long mmio_addr,
+				       uint32_t *val)
+{
+	return s390_pci_mmio_read_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_readq(const unsigned long mmio_addr,
+				       uint64_t *val)
+{
+	return s390_pci_mmio_read_call(mmio_addr, val);
+}
+
+static inline long s390_pci_mmio_read(const unsigned long mmio_addr,
+				      void *val,
+				      const size_t length)
+{
+	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, length);
+}
+
+#define mmio_writeb(addr, value) \
+		s390_pci_mmio_writeb(addr, value)
+#define mmio_writew(addr, value) \
+		s390_pci_mmio_writew(addr, value)
+#define mmio_writel(addr, value) \
+		s390_pci_mmio_writel(addr, value)
+#define mmio_writeq(addr, value) \
+		s390_pci_mmio_writeq(addr, value)
+#define mmio_write(addr, value, length) \
+		s390_pci_mmio_write(addr, value, length)
+
+#define mmio_readb(addr, value) \
+		s390_pci_mmio_readb(addr, value)
+#define mmio_readw(addr, value) \
+		s390_pci_mmio_readw(addr, value)
+#define mmio_readl(addr, value) \
+		s390_pci_mmio_readl(addr, value)
+#define mmio_readq(addr, value) \
+		s390_pci_mmio_readq(addr, value)
+#define mmio_read(addr, value, length) \
+		s390_pci_mmio_read(addr, value, length)
+
+static inline void mlx4_bf_copy(unsigned long *dst,
+				unsigned long *src,
+				unsigned bytecnt)
+{
+	mmio_write((unsigned long) dst, src, bytecnt);
+}
+
+#else
+
+#define mmio_writeb(addr, value) \
+	(*((uint8_t *)addr) = value)
+#define mmio_writeb(addr, value) \
+	(*((uint16_t *)addr) = value)
+#define mmio_writew(addr, value) \
+	(*((uint32_t *)addr) = value)
+#define mmio_writeq(addr, value) \
+	(*((uint64_t *)addr) = value)
+#define mmio_write(addr, value, length) \
+	memcpy(addr, value, length)
+
+#define mmio_readb(addr, value) \
+	(value = *((uint8_t *)addr))
+#define mmio_readw(addr, value) \
+	(value = *((uint16_t *)addr))
+#define mmio_readl(addr, value) \
+	(value = *((uint32_t *)addr))
+#define mmio_readq(addr, value) \
+	(value = *((uint64_t *)addr))
+#define mmio_read(addr, value, length) \
+	memcpy(value, addr, length)
+
+/*
+ * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
+ * implementations may use move-string-buffer assembler instructions,
+ * which do not guarantee order of copying.
+ */
+static inline void mlx4_bf_copy(unsigned long *dst,
+				unsigned long *src,
+				unsigned bytecnt)
+{
+	while (bytecnt > 0) {
+		*dst++ = *src++;
+		*dst++ = *src++;
+		bytecnt -= 2 * sizeof(long);
+	}
+}
+#endif
+
+#endif
--- a/src/qp.c
+++ b/src/qp.c
@@ -173,20 +173,6 @@ static void set_data_seg(struct mlx4_wqe
 	dseg->byte_count = htonl(sg->length);
 }
 
-/*
- * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
- * implementations may use move-string-buffer assembler instructions,
- * which do not guarantee order of copying.
- */
-static void mlx4_bf_copy(unsigned long *dst, unsigned long *src, unsigned bytecnt)
-{
-	while (bytecnt > 0) {
-		*dst++ = *src++;
-		*dst++ = *src++;
-		bytecnt -= 2 * sizeof (long);
-	}
-}
-
 int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			  struct ibv_send_wr **bad_wr)
 {
@@ -431,7 +417,8 @@ out:
 		 */
 		wmb();
 
-		*(uint32_t *) (ctx->uar + MLX4_SEND_DOORBELL) = qp->doorbell_qpn;
+		mmio_writel((unsigned long)(ctx->uar + MLX4_SEND_DOORBELL),
+			    qp->doorbell_qpn);
 	}
 
 	if (nreq)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
