From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/5] utils: Add timespec compare utility
Date: Thu, 29 Jun 2017 17:00:12 +0300
Message-ID: <1498744816-23354-2-git-send-email-yishaih@mellanox.com>
References: <1498744816-23354-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498744816-23354-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move ts_cmp from srp_daemon.h to util.h, to be used from
another place in a downstream patch.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 srp_daemon/srp_daemon.h | 7 +------
 util/util.h             | 6 ++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon.h
index 026db41..5d268ed 100644
--- a/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon.h
@@ -39,6 +39,7 @@
 #include <stdint.h>
 #include <signal.h>
 #include <endian.h>
+#include <util/util.h>
 #include <infiniband/verbs.h>
 #include <infiniband/umad.h>
 #include <linux/types.h>	/* __be16, __be32 and __be64 */
@@ -47,12 +48,6 @@
 #include "config.h"
 #include "srp_ib_types.h"
 
-/* a CMP b. See also the BSD macro timercmp(). */
-#define ts_cmp(a, b, CMP)			\
-	(((a)->tv_sec == (b)->tv_sec) ?		\
-	 ((a)->tv_nsec CMP (b)->tv_nsec) :	\
-	 ((a)->tv_sec CMP (b)->tv_sec))
-
 #define SRP_CATAS_ERR SIGUSR1
 
 enum {
diff --git a/util/util.h b/util/util.h
index ed4ffe8..c3e5955 100644
--- a/util/util.h
+++ b/util/util.h
@@ -10,4 +10,10 @@
 		(rc < len && rc >= 0);                                         \
 	})
 
+/* a CMP b. See also the BSD macro timercmp(). */
+#define ts_cmp(a, b, CMP)			\
+	(((a)->tv_sec == (b)->tv_sec) ?		\
+	 ((a)->tv_nsec CMP (b)->tv_nsec) :	\
+	 ((a)->tv_sec CMP (b)->tv_sec))
+
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
