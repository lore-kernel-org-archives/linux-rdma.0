From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 02/10] Handle always_inline attribute in util/compiler.h
Date: Wed,  1 Feb 2017 09:39:28 +0200
Message-ID: <1485934776-715-3-git-send-email-yishaih@mellanox.com>
References: <1485934776-715-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485934776-715-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Define always_inline function attribute under ALWAYS_INLINE
macro in util/compiler.h and clean it up from any provider code.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.h | 6 ------
 util/compiler.h       | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 1d28ccf..3f89f4b 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -46,12 +46,6 @@
 
 #include <valgrind/memcheck.h>
 
-#ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
-#define ALWAYS_INLINE __attribute__((always_inline))
-#else
-#define ALWAYS_INLINE
-#endif
-
 #define PFX		"mlx5: "
 
 
diff --git a/util/compiler.h b/util/compiler.h
index fa2c0e7..e262540 100644
--- a/util/compiler.h
+++ b/util/compiler.h
@@ -31,4 +31,10 @@
 #endif
 #endif
 
+#ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
+#define ALWAYS_INLINE __attribute__((always_inline))
+#else
+#define ALWAYS_INLINE
+#endif
+
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
