From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 02/20] drm/i915: Move u64-to-ptr helpers to general header
Date: Sun, 17 Jun 2018 12:59:48 +0300
Message-ID: <20180617100006.30663-3-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The macro u64_to_ptr() and function ptr_to_u64() are useful enough
to be part of general header, so move them there and allow RDMA
subsystem reuse them.

Reviewed-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/gpu/drm/i915/i915_utils.h | 12 ++----------
 include/linux/kernel.h            | 12 ++++++++++++
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index 00165ad55fb3..2ffc43b97a5a 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -25,6 +25,8 @@
 #ifndef __I915_UTILS_H
 #define __I915_UTILS_H
 
+#include <linux/kernel.h>
+
 #undef WARN_ON
 /* Many gcc seem to no see through this and fall over :( */
 #if 0
@@ -102,16 +104,6 @@
 	__T;								\
 })
 
-static inline u64 ptr_to_u64(const void *ptr)
-{
-	return (uintptr_t)ptr;
-}
-
-#define u64_to_ptr(T, x) ({						\
-	typecheck(u64, x);						\
-	(T *)(uintptr_t)(x);						\
-})
-
 #define __mask_next_bit(mask) ({					\
 	int __idx = ffs(mask) - 1;					\
 	mask &= ~BIT(__idx);						\
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d23123238534..7d60a3472929 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -71,6 +71,18 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+static inline u64 ptr_to_u64(const void *ptr)
+{
+	return (uintptr_t)ptr;
+}
+
+#define u64_to_ptr(T, x) (		\
+{					\
+	typecheck(u64, x);		\
+	(T *)(uintptr_t)(x);		\
+}					\
+)
+
 #define u64_to_user_ptr(x) (		\
 {					\
 	typecheck(u64, x);		\
-- 
2.14.4
