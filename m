From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Fix C++ compilation break
Date: Mon,  9 Oct 2017 11:17:17 +0300
Message-ID: <20171009081717.21478-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The commit 983f80191923 ("verbs: fix compilation error with ICC") fixed
warning by using UINTPTR_MAX, however such change breaks compilation
of C++ applications.

In C++ world, the UINTPTR_MAX is declared in <cstdint> and not stdint.h,
so in order to avoid messing with various defines to decide which header
file include: stdint.h or <cstdint>, we will check for the existence
of UINTPTR_MAX and will fallback to old implementation.

Fixes: 983f80191923 ("verbs: fix compilation error with ICC")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/verbs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index cc633a12..f540b660 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -82,7 +82,11 @@ union ibv_gid {

 #define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))

+#ifdef UINTPTR_MAX
 static void *__VERBS_ABI_IS_EXTENDED = (void *)UINTPTR_MAX;
+#else
+static void *__VERBS_ABI_IS_EXTENDED = ((uint8_t *) NULL) - 1;
+#endif

 enum ibv_node_type {
 	IBV_NODE_UNKNOWN	= -1,
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
