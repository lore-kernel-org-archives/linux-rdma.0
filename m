From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 08/10] umad: Replace htonll macros with proper inlines and mark deprecated
Date: Thu,  9 Feb 2017 14:53:30 -0700
Message-ID: <1486677212-3188-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This allowed code using these public definitions to continue to compile
but will get warnings from gcc. Users should move to glibc's endian.h

We want to avoid new users of these macros in our tree.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/umad.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/libibumad/umad.h b/libibumad/umad.h
index d574d5d32e0d20..ee8605d3418fcd 100644
--- a/libibumad/umad.h
+++ b/libibumad/umad.h
@@ -229,14 +229,13 @@ static inline void umad_free(void *umad)
 }
 
 #ifndef ntohll
-  #if __BYTE_ORDER == __LITTLE_ENDIAN
-    #define ntohll(x) bswap_64(x)
-  #elif __BYTE_ORDER == __BIG_ENDIAN
-    #define ntohll(x) x
-  #endif
-#endif
-#ifndef htonll
-  #define htonll ntohll
+#undef htonll
+#undef ntohll
+/* Users should use the glibc functions directly, not these wrappers */
+static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
+static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t x) { return be64toh(x); }
+#define htonll htonll
+#define ntohll ntohll
 #endif
 
 END_C_DECLS
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
