From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 2/8] Makefile.am: Fix an automake warning
Date: Tue, 16 Jul 2013 23:59:46 +0200
Message-ID: <6806d5660d8e00f9c0a8c241c3c5d908cf9d85ec.1374011243.git.ydroneaud@opteya.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Fix the following automake warning message:

    Makefile.am:1: `INCLUDES' is the old name for `AM_CPPFLAGS' (or `*_CPPFLAGS')

A quote from the automake manual:

    INCLUDES
        This does the same job as AM_CPPFLAGS (or any per-target _CPPFLAGS variable
        if it is used). It is an older name for the same functionality. This
        variable is deprecated; we suggest using AM_CPPFLAGS and per-target
        _CPPFLAGS instead.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 3198165..e1be9f3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-INCLUDES = -I$(srcdir)/include
+AM_CPPFLAGS = -I$(srcdir)/include
 
 rslibdir = $(libdir)/rsocket
 lib_LTLIBRARIES = src/librdmacm.la
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
