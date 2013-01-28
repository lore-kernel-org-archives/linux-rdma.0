From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 6/7] libibumad: Define ntohll/htonll
Date: Mon, 28 Jan 2013 13:38:54 -0800
Message-ID: <1359409135-559-6-git-send-email-sean.hefty@intel.com>
References: <1359409135-559-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359409135-559-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Users of umad require ntohll/htonll to set/extract data from
MADs.  Include the definition with umad, not just libibmad.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/umad.h b/include/infiniband/umad.h
index 23abf0d..08fff71 100644
--- a/include/infiniband/umad.h
+++ b/include/infiniband/umad.h
@@ -35,6 +35,8 @@
 
 #include <stdint.h>
 #include <stdlib.h>
+#include <byteswap.h>
+#include <arpa/inet.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -193,8 +195,6 @@ int umad_debug(int level);
 void umad_addr_dump(ib_mad_addr_t * addr);
 void umad_dump(void *umad);
 
-#include <stdlib.h>
-
 static inline void *umad_alloc(int num, size_t size)
 {				/* alloc array of umad buffers */
 	return calloc(num, size);
@@ -205,5 +205,16 @@ static inline void umad_free(void *umad)
 	free(umad);
 }
 
+#ifndef ntohll
+  #if __BYTE_ORDER == __LITTLE_ENDIAN
+    #define ntohll(x) bswap_64(x)
+  #elif __BYTE_ORDER == __BIG_ENDIAN
+    #define ntohll(x) x
+  #endif
+#endif
+#ifndef htonll
+  #define htonll ntohll
+#endif
+
 END_C_DECLS
 #endif				/* _UMAD_H */
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
