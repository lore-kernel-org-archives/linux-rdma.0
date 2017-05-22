From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libibumad: clean up htonll/ntohnll handling
Date: Mon, 22 May 2017 10:17:22 -0400
Message-ID: <20170522141722.50502-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Only ntohll was being checked to see if it wasn't defined, and was then
redefining htonll as well as ntohll. This was causing some problems for
the compile of the opa-ff package. Simple enough to rearrange this code a
bit such that htonll and ntohll are handled entirely independent of one
another.

Reported-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 libibumad/umad.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/libibumad/umad.h b/libibumad/umad.h
index 81811380..479165a8 100644
--- a/libibumad/umad.h
+++ b/libibumad/umad.h
@@ -247,15 +247,17 @@ static inline void umad_free(void *umad)
 	free(umad);
 }
 
+/* Users should use the glibc functions directly, not these wrappers */
 #ifndef ntohll
-#undef htonll
 #undef ntohll
-/* Users should use the glibc functions directly, not these wrappers */
-static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
 static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t x) { return be64toh(x); }
-#define htonll htonll
 #define ntohll ntohll
 #endif
+#ifndef htonll
+#undef htonll
+static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
+#define htonll htonll
+#endif
 
 END_C_DECLS
 #endif				/* _UMAD_H */
-- 
2.12.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
