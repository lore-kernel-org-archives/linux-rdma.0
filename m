From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Fix declaration of C++ include file in C-block
Date: Wed, 25 Oct 2017 12:23:23 +0300
Message-ID: <20171025092323.20082-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The include of limits.h in case of C++ application throws the following
error during the compilation.

/usr/include/c++/4.8.2/limits:303:3: error: template with C linkage
   template<typename _Tp>
   ^

The reason to such failure is the location of limits.c, it is supposed
to be included outside of C-block, so let's move it to avoid the error.

Fixes: 6a74285158a1 ("verbs: Fix C++ compilation break")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 4e2f338a..52c8e3c6 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -44,6 +44,10 @@
 #include <linux/types.h>
 #include <stdint.h>

+#ifdef __cplusplus
+#include <limits>
+#endif
+
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
 #  define END_C_DECLS   }
@@ -83,7 +87,6 @@ union ibv_gid {
 #define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))

 #ifdef __cplusplus
-#include <limits>
 #define __VERBS_ABI_IS_EXTENDED ((void *)std::numeric_limits<uintptr_t>::max())
 #else
 #define __VERBS_ABI_IS_EXTENDED ((void *)UINTPTR_MAX)
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
