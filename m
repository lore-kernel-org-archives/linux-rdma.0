From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Thu, 29 Sep 2016 14:47:55 -0600
Message-ID: <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For a long time now endian.h has defined sane fixed with conversion
macros, so lets just use them instead of rolling our own.

Also, htonll is defined in this source tree under infiniband/arch.h,
so all users of that macro can just use the header.

Someday we should also get rid of all the endless wrappers..

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/linux/osd.h                    |  8 +-------
 libcxgb3/src/cxio_wr.h               | 10 +++-------
 libcxgb4/src/t4.h                    | 11 ++++-------
 libi40iw/src/i40iw_umain.h           | 18 ++----------------
 libibumad/src/sysfs.c                |  8 +-------
 libibverbs/include/infiniband/arch.h | 15 ++++++---------
 libnes/src/nes_umain.h               | 17 ++---------------
 libocrdma/src/ocrdma_verbs.c         | 32 ++++----------------------------
 librdmacm/examples/common.h          | 11 +++--------
 librdmacm/src/cma.h                  |  9 +--------
 srp_daemon/srp_daemon/srp_daemon.h   | 17 +----------------
 11 files changed, 28 insertions(+), 128 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 2c4db81b9e8e..c1e7d996c371 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -46,6 +46,7 @@
 #include <arpa/inet.h>
 #include <sys/time.h>
 #include <netinet/in.h>
+#include <infiniband/arch.h>
 
 #include <ccan/minmax.h>
 
@@ -55,13 +56,6 @@
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#define htonll(x) bswap_64(x)
-#else
-#define htonll(x) (x)
-#endif
-#define ntohll(x) htonll(x)
-
 #if DEFINE_ATOMICS
 typedef struct { pthread_mutex_t mut; int val; } atomic_t;
 static inline int atomic_inc(atomic_t *atomic)
diff --git a/libcxgb3/src/cxio_wr.h b/libcxgb3/src/cxio_wr.h
index ece06bd0568c..e24c7fed7d76 100644
--- a/libcxgb3/src/cxio_wr.h
+++ b/libcxgb3/src/cxio_wr.h
@@ -50,13 +50,9 @@
 #define Q_COUNT(rptr,wptr) ((wptr)-(rptr))
 #define Q_PTR2IDX(ptr,size_log2) (ptr & ((1UL<<size_log2)-1))
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#  define cpu_to_pci32(val) ((val))
-#elif __BYTE_ORDER == __BIG_ENDIAN
-#  define cpu_to_pci32(val) (__bswap_32((val)))
-#else
-#  error __BYTE_ORDER not defined
-#endif
+/* Generally speaking, PCI systems auto-byteswap on PCI accesses, so this is
+   probably wrong */
+#define cpu_to_pci32(val) htole32(val)
 
 #define RING_DOORBELL(doorbell, QPID) { \
 	*doorbell = cpu_to_pci32(QPID); \
diff --git a/libcxgb4/src/t4.h b/libcxgb4/src/t4.h
index e8c5cf66cb14..e519cc4087e6 100644
--- a/libcxgb4/src/t4.h
+++ b/libcxgb4/src/t4.h
@@ -62,13 +62,10 @@
 #define unlikely
 #define ROUND_UP(x, n) (((x) + (n) - 1u) & ~((n) - 1u))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#  define cpu_to_pci32(val) ((val))
-#elif __BYTE_ORDER == __BIG_ENDIAN
-#  define cpu_to_pci32(val) (__bswap_32((val)))
-#else
-#  error __BYTE_ORDER not defined
-#endif
+
+/* Generally speaking, PCI systems auto-byteswap on PCI accesses, so this is
+   probably wrong */
+#define cpu_to_pci32(val) htole32(val)
 
 #define writel(v, a) do { *((volatile u32 *)(a)) = cpu_to_pci32(v); } while (0)
 
diff --git a/libi40iw/src/i40iw_umain.h b/libi40iw/src/i40iw_umain.h
index 39b54ba29dcb..13d3da89eba9 100644
--- a/libi40iw/src/i40iw_umain.h
+++ b/libi40iw/src/i40iw_umain.h
@@ -195,28 +195,14 @@ int i40iw_uattach_mcast(struct ibv_qp *, const union ibv_gid *, uint16_t);
 int i40iw_udetach_mcast(struct ibv_qp *, const union ibv_gid *, uint16_t);
 void i40iw_async_event(struct ibv_async_event *event);
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
 static inline uint32_t cpu_to_le32(uint32_t x)
 {
-	return x;
+	return htole32(x);
 }
 
 static inline uint32_t le32_to_cpu(uint32_t x)
 {
-	return x;
+	return le32toh(x);
 }
-#else
-static inline uint32_t cpu_to_le32(uint32_t x)
-{
-	return ((x & 0xFF000000) >> 24) | ((x & 0x00FF0000) >> 8) |
-	    ((x & 0x0000FF00) << 8) | ((x & 0x000000FF) << 24);
-}
-
-static inline uint32_t le32_to_cpu(uint32_t x)
-{
-	return ((x & 0xFF000000) >> 24) | ((x & 0x00FF0000) >> 8) |
-	    ((x & 0x0000FF00) << 8) | ((x & 0x000000FF) << 24);
-}
-#endif
 
 #endif /* i40iw_umain_H */
diff --git a/libibumad/src/sysfs.c b/libibumad/src/sysfs.c
index d10f312285ea..011e411f0951 100644
--- a/libibumad/src/sysfs.c
+++ b/libibumad/src/sysfs.c
@@ -41,15 +41,9 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <endian.h>
 #include <byteswap.h>
 #include <netinet/in.h>
-
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#define htonll(x) bswap_64(x)
-#else
-#define htonll(x) (x)
-#endif
+#include <infiniband/arch.h>
 
 static int ret_code(void)
 {
diff --git a/libibverbs/include/infiniband/arch.h b/libibverbs/include/infiniband/arch.h
index e35ecf05bceb..bf0feec08d73 100644
--- a/libibverbs/include/infiniband/arch.h
+++ b/libibverbs/include/infiniband/arch.h
@@ -37,15 +37,12 @@
 #include <endian.h>
 #include <byteswap.h>
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-static inline uint64_t htonll(uint64_t x) { return bswap_64(x); }
-static inline uint64_t ntohll(uint64_t x) { return bswap_64(x); }
-#elif __BYTE_ORDER == __BIG_ENDIAN
-static inline uint64_t htonll(uint64_t x) { return x; }
-static inline uint64_t ntohll(uint64_t x) { return x; }
-#else
-#error __BYTE_ORDER is neither __LITTLE_ENDIAN nor __BIG_ENDIAN
-#endif
+#undef htonll
+#undef ntohll
+static inline uint64_t htonll(uint64_t x) { return htobe64(x); }
+static inline uint64_t ntohll(uint64_t x) { return be64toh(x); }
+#define htonll htonll
+#define ntohll ntohll
 
 /*
  * Architecture-specific defines.  Currently, an architecture is
diff --git a/libnes/src/nes_umain.h b/libnes/src/nes_umain.h
index c53acd7e90fe..91299823e675 100644
--- a/libnes/src/nes_umain.h
+++ b/libnes/src/nes_umain.h
@@ -393,26 +393,13 @@ int nes_uattach_mcast(struct ibv_qp *, const union ibv_gid *, uint16_t);
 int nes_udetach_mcast(struct ibv_qp *, const union ibv_gid *, uint16_t);
 void nes_async_event(struct ibv_async_event *event);
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
 static inline uint32_t cpu_to_le32(uint32_t x)
 {
-	return x;
+	return htole32(x);
 }
 static inline uint32_t le32_to_cpu(uint32_t x)
 {
-	return x;
+	return le32toh(x);
 }
-#else
-static inline uint32_t cpu_to_le32(uint32_t x)
-{
-	return (((x&0xFF000000)>>24) | ((x&0x00FF0000)>>8) |
-			((x&0x0000FF00)<<8) | ((x&0x000000FF)<<24));
-}
-static inline uint32_t le32_to_cpu(uint32_t x)
-{
-	return (((x&0xFF000000)>>24) | ((x&0x00FF0000)>>8) |
-			((x&0x0000FF00)<<8) | ((x&0x000000FF)<<24));
-}
-#endif
 
 #endif				/* nes_umain_H */
diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index 6d58cb219fe1..163bf23f8914 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -46,6 +46,7 @@
 #include <sys/mman.h>
 #include <netinet/in.h>
 #include <unistd.h>
+#include <endian.h>
 
 #include "ocrdma_main.h"
 #include "ocrdma_abi.h"
@@ -54,48 +55,23 @@
 static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
 			      int solicited, uint32_t num_cqe);
 
-static inline uint32_t ocrdma_swap_endianness(uint32_t val)
-{
-	return ((val & 0xFF000000) >> 24) | ((val & 0xFF) << 24) |
-	    ((val & 0xFF00) << 8) | ((val & 0xFF0000) >> 8);
-}
-
 static inline uint32_t ocrdma_cpu_to_le(uint32_t val)
 {
-#if __BYTE_ORDER == __BIG_ENDIAN
-	return ocrdma_swap_endianness(val);
-#else
-	return val;
-#endif
+	return htole32(val);
 }
 
 static inline uint32_t ocrdma_le_to_cpu(uint32_t val)
 {
-#if __BYTE_ORDER == __BIG_ENDIAN
-	return ocrdma_swap_endianness(val);
-#else
-	return val;
-#endif
-}
-
-static inline uint32_t ocrdma_cpu_to_be(uint32_t val)
-{
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-	return ocrdma_swap_endianness(val);
-#else
-	return val;
-#endif
+	return le32toh(val);
 }
 
 static inline void ocrdma_swap_cpu_to_le(void *dst, uint32_t len)
 {
-#if __BYTE_ORDER == __BIG_ENDIAN
 	int i = 0;
 	uint32_t *src_ptr = dst;
 	uint32_t *dst_ptr = dst;
 	for (; i < (len / 4); i++)
-		*dst_ptr++ = ocrdma_swap_endianness(*src_ptr++);
-#endif
+		*dst_ptr++ = le32toh(*src_ptr++);
 }
 
 /*
diff --git a/librdmacm/examples/common.h b/librdmacm/examples/common.h
index f7511f039697..ac2d160b0044 100644
--- a/librdmacm/examples/common.h
+++ b/librdmacm/examples/common.h
@@ -34,20 +34,15 @@
 
 #include <stdlib.h>
 #include <sys/types.h>
-#include <byteswap.h>
+#include <endian.h>
 #include <poll.h>
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rsocket.h>
 #include <infiniband/ib.h>
 
-#if __BYTE_ORDER == __BIG_ENDIAN
-static inline uint64_t cpu_to_be64(uint64_t x) { return x; }
-static inline uint32_t cpu_to_be32(uint32_t x) { return x; }
-#else
-static inline uint64_t cpu_to_be64(uint64_t x) { return bswap_64(x); }
-static inline uint32_t cpu_to_be32(uint32_t x) { return bswap_32(x); }
-#endif
+static inline uint64_t cpu_to_be64(uint64_t x) { return htobe64(x); }
+static inline uint32_t cpu_to_be32(uint32_t x) { return htobe32(x); }
 
 extern int use_rs;
 
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index 16a55a67af9e..c2f603d6f439 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -44,6 +44,7 @@
 
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
+#include <infiniband/arch.h>
 
 #include <ccan/minmax.h>
 
@@ -51,14 +52,6 @@
 
 #define PFX "librdmacm: "
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-static inline uint64_t htonll(uint64_t x) { return bswap_64(x); }
-static inline uint64_t ntohll(uint64_t x) { return bswap_64(x); }
-#else
-static inline uint64_t htonll(uint64_t x) { return x; }
-static inline uint64_t ntohll(uint64_t x) { return x; }
-#endif
-
 /*
  * Fast synchronization for low contention locking.
  */
diff --git a/srp_daemon/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon/srp_daemon.h
index d6a2d8a84728..5d42d51e6d1c 100644
--- a/srp_daemon/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon/srp_daemon.h
@@ -42,26 +42,11 @@
 #include <byteswap.h>
 #include <infiniband/verbs.h>
 #include <infiniband/umad.h>
+#include <infiniband/arch.h>
 
 #include "config.h"
 #include "srp_ib_types.h"
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#ifndef htonll
-#define htonll(x) bswap_64(x)
-#endif
-#ifndef ntohll
-#define ntohll(x) bswap_64(x)
-#endif
-#elif __BYTE_ORDER == __BIG_ENDIAN
-#ifndef htonll
-#define htonll(x) (x)
-#endif
-#ifndef ntohll
-#define ntohll(x) (x)
-#endif
-#endif
-
 #ifdef __cplusplus
 template <bool b> struct vki_static_assert { int m_bitfield:(2*b-1); };
 #define STATIC_ASSERT(expr) \
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
