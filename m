From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 5/8] configure: Use automake's option "subdir-objects"
Date: Tue, 16 Jul 2013 23:59:49 +0200
Message-ID: <dd979f73267d169be990a757907f3351fec49b78.1374011243.git.ydroneaud@opteya.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Following advice in "Autotool Mythbuster" [1], option subdir-objects
can be used to have Makefiles create object files in the same
directory than theirs source files.

It reduces clobbering in the build directory.

[1] "Autotool Mythbuster", by Diego Elio "Flameeyes" Petten`o
http://www.flameeyes.eu/autotools-mythbuster/automake/nonrecursive.html

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index a9e95c0..807470f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ AC_CONFIG_SRCDIR([src/cma.c])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
 AC_CONFIG_HEADERS([config.h])
-AM_INIT_AUTOMAKE([foreign])
+AM_INIT_AUTOMAKE([foreign subdir-objects])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 LT_INIT
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
