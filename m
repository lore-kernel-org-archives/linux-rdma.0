From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH librdmacm] Fixed build problem due to missing macro
Date: Sun,  2 Dec 2012 14:04:23 +0200
Message-ID: <1354449863-20990-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, esalomon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rsocket.c wasn't passing compilation as of missing definition for the 
container_of macro, fix it. Reported-by: Eyal Salamon <esalomon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cma.c     |    5 -----
 src/cma.h     |    6 ++++++
 src/rsocket.c |    1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 91bf108..388be61 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -124,11 +124,6 @@ static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
 static int abi_ver = RDMA_USER_CM_MAX_ABI_VERSION;
 int af_ib_support;
 
-#ifndef container_of
-#define container_of(ptr, type, field) \
-	((type *) ((void *)ptr - offsetof(type, field)))
-#endif
-
 static void ucma_cleanup(void)
 {
 	ucma_ib_cleanup();
diff --git a/src/cma.h b/src/cma.h
index 6a1cd75..0a0370e 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -71,6 +71,12 @@ static inline uint64_t ntohll(uint64_t x) { return x; }
 #define max(a, b) ((a) > (b) ? a : b)
 #define min(a, b) ((a) < (b) ? a : b)
 
+#ifndef container_of
+#define container_of(ptr, type, field) \
+	((type *) ((void *)ptr - offsetof(type, field)))
+#endif
+
+
 /*
  * Fast synchronization for low contention locking.
  */
diff --git a/src/rsocket.c b/src/rsocket.c
index 58fcb8e..a060f66 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -43,6 +43,7 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <stdio.h>
+#include <stddef.h>
 #include <string.h>
 #include <netinet/in.h>
 #include <netinet/tcp.h>
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
