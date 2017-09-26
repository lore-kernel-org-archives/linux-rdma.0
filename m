From: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] verbs: fix compilation error with ICC
Date: Tue, 26 Sep 2017 16:05:11 +0200
Message-ID: <1506434711-3828-1-git-send-email-nelio.laranjeiro@6wind.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Compiling a program including verbs.h with ICC fails with the following
error (seen with DPDK):

 /root/development/rdma-core/build/include/infiniband/verbs.h(84):
 warning #61: integer operation result is out of range
   static void *__VERBS_ABI_IS_EXTENDED = ((uint8_t *) NULL) - 1;

Fixes: 6be16586e081 ("Infrastructure to support verbs extensions")
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

Signed-off-by: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Acked-by: Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
---
 libibverbs/verbs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 8cdf8ab..cc633a1 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -42,6 +42,7 @@
 #include <errno.h>
 #include <string.h>
 #include <linux/types.h>
+#include <stdint.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -81,7 +82,7 @@ union ibv_gid {
 
 #define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))
 
-static void *__VERBS_ABI_IS_EXTENDED = ((uint8_t *) NULL) - 1;
+static void *__VERBS_ABI_IS_EXTENDED = (void *)UINTPTR_MAX;
 
 enum ibv_node_type {
 	IBV_NODE_UNKNOWN	= -1,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
