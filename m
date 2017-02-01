From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 01/10] Handle likely/unlikely in a single place
Date: Wed,  1 Feb 2017 09:39:27 +0200
Message-ID: <1485934776-715-2-git-send-email-yishaih@mellanox.com>
References: <1485934776-715-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485934776-715-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move likely/unlikely macros definitions into
util/compiler.h and cleanup their usage in the
providers code.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/cxgb4/t4.h          |  2 +-
 providers/hns/hns_roce_u.h    |  5 +----
 providers/i40iw/i40iw_umain.h |  8 +-------
 providers/mlx4/mlx4.h         |  9 +--------
 providers/mlx5/mlx5.h         |  6 +-----
 providers/nes/nes_umain.h     |  8 +-------
 util/compiler.h               | 16 ++++++++++++++++
 7 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/providers/cxgb4/t4.h b/providers/cxgb4/t4.h
index eda9a20..cad675c 100644
--- a/providers/cxgb4/t4.h
+++ b/providers/cxgb4/t4.h
@@ -34,6 +34,7 @@
 #include <stdint.h>
 #include <assert.h>
 #include <syslog.h>
+#include <util/compiler.h>
 
 /*
  * Try and minimize the changes from the kernel code that is pull in
@@ -59,7 +60,6 @@
 #define be32_to_cpu ntohl
 #define be64_to_cpu ntohll
 #define BUG_ON(c) assert(!(c))
-#define unlikely
 #define ROUND_UP(x, n) (((x) + (n) - 1u) & ~((n) - 1u))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 4a6ed8e..8483d34 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_U_H
 
 #include <stddef.h>
+#include <util/compiler.h>
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
@@ -51,10 +52,6 @@
 
 #define PFX				"hns: "
 
-#ifndef likely
-#define likely(x)     __builtin_expect(!!(x), 1)
-#endif
-
 #define roce_get_field(origin, mask, shift) \
 	(((origin) & (mask)) >> (shift))
 
diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
index 06d38a2..4ca6057 100644
--- a/providers/i40iw/i40iw_umain.h
+++ b/providers/i40iw/i40iw_umain.h
@@ -38,6 +38,7 @@
 #include <inttypes.h>
 #include <stddef.h>
 #include <endian.h>
+#include <util/compiler.h>
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
@@ -47,13 +48,6 @@
 #include "i40iw_status.h"
 #include "i40iw_user.h"
 
-#ifndef likely
-#define likely(x)   __builtin_expect((x), 1)
-#endif
-#ifndef unlikely
-#define unlikely(x) __builtin_expect((x), 0)
-#endif
-
 #define PFX "libi40iw-"
 
 #define  I40IW_BASE_PUSH_PAGE	1
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index b851e95..788e9fe 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -36,6 +36,7 @@
 
 #include <stddef.h>
 #include <netinet/in.h>
+#include <util/compiler.h>
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
@@ -51,14 +52,6 @@ enum {
 	MLX4_STAT_RATE_OFFSET		= 5
 };
 
-#ifndef likely
-#ifdef __GNUC__
-#define likely(x)       __builtin_expect(!!(x),1)
-#else
-#define likely(x)      (x)
-#endif
-#endif
-
 enum {
 	MLX4_QP_TABLE_BITS		= 8,
 	MLX4_QP_TABLE_SIZE		= 1 << MLX4_QP_TABLE_BITS,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index cf314fc..1d28ccf 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -35,6 +35,7 @@
 
 #include <stddef.h>
 #include <stdio.h>
+#include <util/compiler.h>
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
@@ -43,11 +44,6 @@
 #include "bitmap.h"
 #include <ccan/minmax.h>
 
-#ifdef __GNUC__
-#define likely(x)	__builtin_expect((x), 1)
-#define unlikely(x)	__builtin_expect((x), 0)
-#endif
-
 #include <valgrind/memcheck.h>
 
 #ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
diff --git a/providers/nes/nes_umain.h b/providers/nes/nes_umain.h
index 093956a..c10c4fe 100644
--- a/providers/nes/nes_umain.h
+++ b/providers/nes/nes_umain.h
@@ -37,17 +37,11 @@
 #include <inttypes.h>
 #include <stddef.h>
 #include <endian.h>
+#include <util/compiler.h>
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
 
-#ifndef likely
-#define likely(x)   __builtin_expect((x),1)
-#endif
-#ifndef unlikely
-#define unlikely(x) __builtin_expect((x),0)
-#endif
-
 #define PFX	"libnes: "
 
 #define  NES_QP_MMAP		1
diff --git a/util/compiler.h b/util/compiler.h
index 9b57e04..fa2c0e7 100644
--- a/util/compiler.h
+++ b/util/compiler.h
@@ -15,4 +15,20 @@
 #define uninitialized_var(x) x = x
 #endif
 
+#ifndef likely
+#ifdef __GNUC__
+#define likely(x)       __builtin_expect(!!(x), 1)
+#else
+#define likely(x)      (x)
+#endif
+#endif
+
+#ifndef unlikely
+#ifdef __GNUC__
+#define unlikely(x)      __builtin_expect(!!(x), 0)
+#else
+#define unlikely(x)    (x)
+#endif
+#endif
+
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
