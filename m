From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 1/8] Add "foreign" option to AM_INIT_AUTOMAKE
Date: Tue, 16 Jul 2013 23:59:45 +0200
Message-ID: <60e5e0ae4524153d31389554a7d9c601a75427ad.1374011243.git.ydroneaud@opteya.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Switch to the modern form of the AM_INIT_AUTOMAKE macro and tell
automake that the librdmacm package does not follow the GNU
standards. This change makes it possible to use 'autoreconf' for the
librdmacm package.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 35d79dd..20c2f94 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ AC_CONFIG_SRCDIR([src/cma.c])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
 AC_CONFIG_HEADERS(config.h)
-AM_INIT_AUTOMAKE(librdmacm, 1.0.17)
+AM_INIT_AUTOMAKE([foreign])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AM_PROG_LIBTOOL
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
