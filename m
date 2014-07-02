From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/8] build: Add build support for XRC
Date: Tue,  1 Jul 2014 23:11:14 -0700
Message-ID: <1404281479-6755-4-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Modify autotools to check for and require a libibverbs
version that includes XRC and extension support.

Remove any code used to support older versions of
libibverbs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.ac |    8 ++------
 src/cma.h    |   42 +-----------------------------------------
 2 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7581df4..0b8d6ec 100644
--- a/configure.ac
+++ b/configure.ac
@@ -40,14 +40,10 @@ dnl Checks for libraries
 AC_CHECK_LIB(pthread, pthread_mutex_init, [],
     AC_MSG_ERROR([pthread_mutex_init() not found.  librdmacm requires libpthread.]))
 if test "$disable_libcheck" != "yes"; then
-AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
-    AC_MSG_ERROR([ibv_get_device_list() not found.  librdmacm requires libibverbs.]))
+AC_CHECK_LIB(ibverbs, ibv_cmd_open_xrcd, [],
+    AC_MSG_ERROR([ibv_cmd_open_xrcd() not found.  librdmacm requires libibverbs 1.1.8 or later.]))
 fi
 
-AC_CHECK_MEMBER(struct ibv_path_record.service_id, [],
-    AC_DEFINE(DEFINE_PATH_RECORD, 1, [adding path record definition]),
-    [#include <infiniband/sa.h>])
-
 dnl Check for gcc atomic intrinsics
 AC_MSG_CHECKING(compiler support for atomics)
 AC_LINK_IFELSE([AC_LANG_PROGRAM([[int i = 0;]],
diff --git a/src/cma.h b/src/cma.h
index a7bab0f..98eba8d 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -167,46 +167,6 @@ void ucma_ib_init();
 void ucma_ib_cleanup();
 void ucma_ib_resolve(struct rdma_addrinfo **rai, struct rdma_addrinfo *hints);
 
-/* Define path record definition if using older version of libibverbs */
-#ifdef DEFINE_PATH_RECORD
-#define IBV_PATH_RECORD_REVERSIBLE 0x80
-
-struct ibv_path_record
-{
-	uint64_t        service_id;
-	union ibv_gid   dgid;
-	union ibv_gid   sgid;
-	uint16_t        dlid;
-	uint16_t        slid;
-	uint32_t        flowlabel_hoplimit; /* resv-31:28 flow label-27:8 hop limit-7:0*/
-	uint8_t         tclass;
-	uint8_t         reversible_numpath; /* reversible-7:7 num path-6:0 */
-	uint16_t        pkey;
-	uint16_t        qosclass_sl;        /* qos class-15:4 sl-3:0 */
-	uint8_t         mtu;                /* mtu selector-7:6 mtu-5:0 */
-	uint8_t         rate;               /* rate selector-7:6 rate-5:0 */
-	uint8_t         packetlifetime;     /* lifetime selector-7:6 lifetime-5:0 */
-	uint8_t         preference;
-	uint8_t         reserved[6];
-};
-
-#define IBV_PATH_FLAG_GMP             (1<<0)
-#define IBV_PATH_FLAG_PRIMARY         (1<<1)
-#define IBV_PATH_FLAG_ALTERNATE       (1<<2)
-#define IBV_PATH_FLAG_OUTBOUND        (1<<3)
-#define IBV_PATH_FLAG_INBOUND         (1<<4)
-#define IBV_PATH_FLAG_INBOUND_REVERSE (1<<5)
-#define IBV_PATH_FLAG_BIDIRECTIONAL   (IBV_PATH_FLAG_OUTBOUND |     \
-                                       IBV_PATH_FLAG_INBOUND_REVERSE)
-
-struct ibv_path_data
-{
-	uint32_t               flags;
-	uint32_t               reserved;
-	struct ibv_path_record path;
-};
-#endif
-
 struct ib_connect_hdr {
 	uint8_t  cma_version;
 	uint8_t  ip_version; /* IP version: 7:4 */
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
