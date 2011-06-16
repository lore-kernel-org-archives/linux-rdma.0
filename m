From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: test for libosmcomp with a function that
 is used in the code
Date: Thu, 16 Jun 2011 11:10:09 -0700
Message-ID: <20110616111009.fb16cc5e.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Sun, 29 May 2011 18:01:31 -0700
Subject: [PATCH] infiniband-diags: test for libosmcomp with a function that is used in the code

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 configure.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index c6e8663..f41f049 100644
--- a/configure.in
+++ b/configure.in
@@ -46,8 +46,8 @@ AC_CHECK_MEMBER([struct umad_port.link_layer],
 if test "$ac_have_umad_port_link_layer" = "yes"; then
    AC_DEFINE([HAVE_UMAD_PORT_LINK_LAYER], 1, [Define to 1 if struct umad_port has link_layer member])
 fi
-AC_CHECK_LIB(osmcomp, cl_thread_init, [],
-	AC_MSG_ERROR([cl_thread_init() not found. diags require libosmcomp.]))
+AC_CHECK_LIB(osmcomp, cl_qmap_insert, [],
+	AC_MSG_ERROR([cl_qmap_insert() not found. diags require libosmcomp.]))
 fi
 
 dnl Checks for header files.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
