From: Ana Guerrero =?iso-8859-1?Q?L=F3pez?= <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
Subject: [infiniband-diags PATCH 2/4] Replace INCLUDES with AM_CPPFLAGS
Date: Mon, 5 Sep 2016 23:48:52 +0200
Message-ID: <20160905214852.GA9682@pryan.ekaia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes the following warnings:

Makefile.am:4: warning: 'INCLUDES' is the old name for 'AM_CPPFLAGS' (or '*_CPPFLAGS')

libibnetdisc/Makefile.am:4: warning: 'INCLUDES' is the old name for 'AM_CPPFLAGS' (or '*_CPPFLAGS')

Signed-off-by: Ana Guerrero López <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am              | 2 +-
 libibnetdisc/Makefile.am | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 3fea79d..1973702 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 ACLOCAL_AMFLAGS = -I config
 SUBDIRS = libibnetdisc
 
-INCLUDES = -I$(top_builddir)/include/ -I$(srcdir)/include -I$(includedir) \
+AM_CPPFLAGS = -I$(top_builddir)/include/ -I$(srcdir)/include -I$(includedir) \
 	-I$(includedir)/infiniband -I$(top_srcdir)/libibnetdisc/include
 
 if DEBUG
diff --git a/libibnetdisc/Makefile.am b/libibnetdisc/Makefile.am
index 2cfcc33..fee13ca 100644
--- a/libibnetdisc/Makefile.am
+++ b/libibnetdisc/Makefile.am
@@ -1,7 +1,7 @@
 
 #SUBDIRS = .
 
-INCLUDES = -I$(srcdir)/include -I$(includedir) -I$(includedir)/infiniband
+AM_CPPFLAGS = -I$(srcdir)/include -I$(includedir) -I$(includedir)/infiniband
 
 lib_LTLIBRARIES = libibnetdisc.la
 sbin_PROGRAMS =
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
