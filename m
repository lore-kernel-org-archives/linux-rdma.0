From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/13] IB-mgmt: Move ntohll/htonll from mad.h to umad.h
Date: Wed, 3 Nov 2010 16:11:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B37E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Users of umad require ntohll/htonll to set/extract data from
MADs.  Move the definition from libibmad to libibumad.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 libibmad/include/infiniband/mad.h     |   29 +----------------------------
 libibmad/include/infiniband/mad_osd.h |    2 --
 libibumad/include/infiniband/umad.h   |   21 +++++++++++++++++++--
 3 files changed, 20 insertions(+), 32 deletions(-)
 mode change 100644 => 100755 libibmad/include/infiniband/mad_osd.h

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index f3733a2..80630f4 100755
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -36,6 +36,7 @@
 #define _MAD_H_
 
 #include <infiniband/mad_osd.h>
+#include <infiniband/umad.h>
 #include <infiniband/umad_sa.h>
 #include <infiniband/umad_sm.h>
 #include <infiniband/umad_types.h>
@@ -1041,34 +1042,6 @@ MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
 
 extern MAD_EXPORT int ibdebug;
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#ifndef ntohll
-static inline uint64_t ntohll(uint64_t x)
-{
-	return bswap_64(x);
-}
-#endif
-#ifndef htonll
-static inline uint64_t htonll(uint64_t x)
-{
-	return bswap_64(x);
-}
-#endif
-#elif __BYTE_ORDER == __BIG_ENDIAN
-#ifndef ntohll
-static inline uint64_t ntohll(uint64_t x)
-{
-	return x;
-}
-#endif
-#ifndef htonll
-static inline uint64_t htonll(uint64_t x)
-{
-	return x;
-}
-#endif
-#endif				/* __BYTE_ORDER == __BIG_ENDIAN */
-
 /* Misc. macros: */
 /** align value \a l to \a size (ceil) */
 #define ALIGN(l, size) (((l) + ((size) - 1)) / (size) * (size))
diff --git a/libibmad/include/infiniband/mad_osd.h b/libibmad/include/infiniband/mad_osd.h
old mode 100644
new mode 100755
index ee73561..ce5397f
--- a/libibmad/include/infiniband/mad_osd.h
+++ b/libibmad/include/infiniband/mad_osd.h
@@ -39,9 +39,7 @@
 #include <stdio.h>
 #include <sys/types.h>
 #include <unistd.h>
-#include <byteswap.h>
 #include <inttypes.h>
-#include <arpa/inet.h>
 
 #define MAD_EXPORT
 #define IBND_EXPORT
diff --git a/libibumad/include/infiniband/umad.h b/libibumad/include/infiniband/umad.h
index 650654e..a798cf8 100755
--- a/libibumad/include/infiniband/umad.h
+++ b/libibumad/include/infiniband/umad.h
@@ -35,6 +35,8 @@
 
 #include <stdint.h>
 #include <stdlib.h>
+#include <byteswap.h>
+#include <arpa/inet.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -203,8 +205,6 @@ int umad_debug(int level);
 void umad_addr_dump(ib_mad_addr_t * addr);
 void umad_dump(void *umad);
 
-#include <stdlib.h>
-
 static inline void *umad_alloc(int num, size_t size)
 {				/* alloc array of umad buffers */
 	return calloc(num, size);
@@ -215,5 +215,22 @@ static inline void umad_free(void *umad)
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
