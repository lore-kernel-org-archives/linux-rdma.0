From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] dapl-2.0 - configure: need a false conditional for
 verbs attr.link_layer member check
Date: Wed, 16 Jun 2010 10:21:29 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830103BF2434@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.in |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/configure.in b/configure.in
index c36304d..4110024 100644
--- a/configure.in
+++ b/configure.in
@@ -23,20 +23,16 @@ if test "$disable_libcheck" != "yes"
 then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libdapl requires libibverbs.]))
-fi
 
-dnl Checks for header files.
-if test "$disable_libcheck" != "yes"
-then
 AC_CHECK_HEADER(infiniband/verbs.h, [],
     AC_MSG_ERROR([<infiniband/verbs.h> not found.  Is libibverbs installed?]))
-fi
 
-if test "$disable_libcheck" != "yes"
-then
 AC_CHECK_MEMBER(struct ibv_port_attr.link_layer, 
-    AM_CONDITIONAL(DEFINE_ATTR_LINK_LAYER, test "yes" = "yes"),
-    [], [#include <infiniband/verbs.h>])
+    AM_CONDITIONAL(DEFINE_ATTR_LINK_LAYER, test "yes" = "yes"), 
+    AM_CONDITIONAL(DEFINE_ATTR_LINK_LAYER, test "yes" = "no"), 
+    [#include <infiniband/verbs.h>])
+else
+    AM_CONDITIONAL(DEFINE_ATTR_LINK_LAYER, test "yes" = "no")
 fi
 
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
