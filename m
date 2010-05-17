From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: define struct ibv_path_record if not defined
Date: Mon, 17 May 2010 15:03:14 -0700
Message-ID: <096730ED720B4E488D80F555E7A5CBD2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

librdmacm relies on struct ibv_path_record from libibverbs.  However,
to support older versions of libibverbs, define struct ibv_path_record
if it is not already defined.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I don't know if this is the ideal fix, but it allows librdmacm to build
with older versions of libibverbs.  I selected this rather than surrounding
the code that requires these definitions with an #ifdef.

 configure.in |    4 ++++
 src/cma.h    |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 3db4247..6650bbd 100644
--- a/configure.in
+++ b/configure.in
@@ -49,6 +49,10 @@ AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  librdmacm requires libibverbs.]))
 fi
 
+AC_CHECK_MEMBER(struct ibv_path_record.service_id, [],
+    AC_DEFINE(DEFINE_PATH_RECORD, 1, [adding path record definition]),
+    [#include <infiniband/sa.h>])
+
 dnl Checks for header files.
 AC_HEADER_STDC
 if test "$disable_libcheck" != "yes"; then
diff --git a/src/cma.h b/src/cma.h
index de012c2..d88c6b1 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -89,4 +89,44 @@ void ucma_ib_resolve(struct rdma_addrinfo *rai);
 #define ucma_ib_resolve(x)
 #endif
 
+/* Define path record definition if using older version of libibverbs */
+#ifdef DEFINE_PATH_RECORD
+#define IBV_PATH_RECORD_REVERSIBLE 0x80
+
+struct ibv_path_record
+{
+	uint64_t        service_id;
+	union ibv_gid   dgid;
+	union ibv_gid   sgid;
+	uint16_t        dlid;
+	uint16_t        slid;
+	uint32_t        flowlabel_hoplimit; /* resv-31:28 flow label-27:8 hop limit-7:0*/
+	uint8_t         tclass;
+	uint8_t         reversible_numpath; /* reversible-7:7 num path-6:0 */
+	uint16_t        pkey;
+	uint16_t        qosclass_sl;        /* qos class-15:4 sl-3:0 */
+	uint8_t         mtu;                /* mtu selector-7:6 mtu-5:0 */
+	uint8_t         rate;               /* rate selector-7:6 rate-5:0 */
+	uint8_t         packetlifetime;     /* lifetime selector-7:6 lifetime-5:0 */
+	uint8_t         preference;
+	uint8_t         reserved[6];
+};
+
+#define IBV_PATH_FLAG_GMP             (1<<0)
+#define IBV_PATH_FLAG_PRIMARY         (1<<1)
+#define IBV_PATH_FLAG_ALTERNATE       (1<<2)
+#define IBV_PATH_FLAG_OUTBOUND        (1<<3)
+#define IBV_PATH_FLAG_INBOUND         (1<<4)
+#define IBV_PATH_FLAG_INBOUND_REVERSE (1<<5)
+#define IBV_PATH_FLAG_BIDIRECTIONAL   (IBV_PATH_FLAG_OUTBOUND |     \
+                                       IBV_PATH_FLAG_INBOUND_REVERSE)
+
+struct ibv_path_data
+{
+	uint32_t               flags;
+	uint32_t               reserved;
+	struct ibv_path_record path;
+};
+#endif
+
 #endif /* CMA_H */



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
