From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] libibumad: Define ntohll/htonll
Date: Thu, 28 Apr 2011 16:04:59 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F412F@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Users of umad require ntohll/htonll to set/extract data from
MADs.  Include the definition with umad, not just libibmad.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad.h |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/umad.h b/include/infiniband/umad.h
index 23abf0d..6c337c0 100644
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
@@ -205,5 +205,22 @@ static inline void umad_free(void *umad)
 	free(umad);
 }
 
+#ifndef ntohll
+  #if __BYTE_ORDER == __LITTLE_ENDIAN
+    static inline uint64_t ntohll(uint64_t x)
+    {
+        return bswap_64(x);
+    }
+  #elif __BYTE_ORDER == __BIG_ENDIAN
+    static inline uint64_t ntohll(uint64_t x)
+    {
+        return x;
+    }
+  #endif
+#endif
+#ifndef htonll
+  #define htonll ntohll
+#endif
+
 END_C_DECLS
 #endif				/* _UMAD_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
