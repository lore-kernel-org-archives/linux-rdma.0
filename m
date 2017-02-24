From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] libibmad: Fix conflict with new umad.h header
Date: Fri, 24 Feb 2017 00:40:27 -0500
Message-ID: <1487914827-339-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/mad.h | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index 77858c3fe6e1..2911dee3cdf4 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -1662,29 +1662,17 @@ extern MAD_EXPORT int ibdebug;
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #ifndef ntohll
-static inline uint64_t ntohll(uint64_t x)
-{
-	return bswap_64(x);
-}
+#define ntohll bswap_64
 #endif
 #ifndef htonll
-static inline uint64_t htonll(uint64_t x)
-{
-	return bswap_64(x);
-}
+#define htonll bswap_64
 #endif
 #elif __BYTE_ORDER == __BIG_ENDIAN
 #ifndef ntohll
-static inline uint64_t ntohll(uint64_t x)
-{
-	return x;
-}
+#define ntohll(x) x
 #endif
 #ifndef htonll
-static inline uint64_t htonll(uint64_t x)
-{
-	return x;
-}
+#define htonll(x) x
 #endif
 #endif				/* __BYTE_ORDER == __BIG_ENDIAN */
 
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
