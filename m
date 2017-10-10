From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core v1] verbs: Fix C++ compilation break
Date: Tue, 10 Oct 2017 11:14:10 +0300
Message-ID: <20171010081410.10946-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The commit 983f80191923 ("verbs: fix compilation error with ICC") fixed
warning by using UINTPTR_MAX, however such change breaks compilation
of C++ applications.

On some systems, the stdint.h contains the following ifdef to protect UINTPTR_MAX
"#if !defined __cplusplus || defined __STDC_LIMIT_MACROS"

The simple inclusion of <cstdint> header is not enough too to fix
compilation error, because that file was added in C++11 standard and
it produces following error while using it:

/usr/include/c++/4.8.2/bits/c++0x_warning.h:32:2: error: #error This file requires
compiler and library support for the ISO C++ 2011 standard. This support is currently
experimental, and must be enabled with the -std=c++11 or -std=gnu++11 compiler options.

So let's fix C++ compilation break by using numeric_limits to avoid __STDC_LIMIT_MACROS.

Fixes: 983f80191923 ("verbs: fix compilation error with ICC")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
---
Travis CI failure is a false alarm (checkpatch):
https://github.com/linux-rdma/rdma-core/pull/224

Changes from v0:
 * Updated commit message to better reflect the issue
 * Used Jason's code, so added his SOB
---
 libibverbs/verbs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index cc633a12..4e2f338a 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -82,7 +82,12 @@ union ibv_gid {

 #define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))

-static void *__VERBS_ABI_IS_EXTENDED = (void *)UINTPTR_MAX;
+#ifdef __cplusplus
+#include <limits>
+#define __VERBS_ABI_IS_EXTENDED ((void *)std::numeric_limits<uintptr_t>::max())
+#else
+#define __VERBS_ABI_IS_EXTENDED ((void *)UINTPTR_MAX)
+#endif

 enum ibv_node_type {
 	IBV_NODE_UNKNOWN	= -1,
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
