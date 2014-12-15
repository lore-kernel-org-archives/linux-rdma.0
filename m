From: john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] ibacm: Search the pthread and dynamic linker/loader library when linking.
Date: Mon, 15 Dec 2014 14:05:48 -0500
Message-ID: <1418670348-5391-1-git-send-email-john.fleck@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When building with RHEL 7, there is an undefined reference to the pthread
and the dynamic linker/loader libraries.

Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index c71ed7c..73b1a31 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,7 @@
 AM_CPPFLAGS = -I$(srcdir)/include -I$(srcdir)/linux -I$(srcdir)/src
 
 AM_CFLAGS = -g -Wall -D_GNU_SOURCE 
+AM_LDFLAGS = -lpthread -ldl
 
 if HAVE_LD_VERSION_SCRIPT
     libibacmp_version_script = -Wl,--version-script=$(srcdir)/prov/acmp/src/libibacmp.map
@@ -13,14 +14,14 @@ sbin_PROGRAMS = svc/ibacm
 svc_ibacm_SOURCES = src/acm.c src/acm_util.c
 util_ib_acme_SOURCES = src/acme.c src/libacm.c linux/libacm_linux.c src/parse.c
 svc_ibacm_CFLAGS = $(AM_CFLAGS)
-svc_ibacm_LDFLAGS = -rdynamic
+svc_ibacm_LDFLAGS = -rdynamic $(AM_LDFLAGS)
 util_ib_acme_CFLAGS = $(AM_CFLAGS) -DACME_PRINTS
 
 pkglib_LTLIBRARIES = lib/libibacmp.la
 lib_libibacmp_la_CFLAGS = $(AM_CFLAGS) 
 lib_libibacmp_la_SOURCES = prov/acmp/src/acmp.c  
 lib_libibacmp_la_LDFLAGS = -version-info 1 -export-dynamic \
-			   $(libibacmp_version_script)
+			   $(libibacmp_version_script) $(AM_LDFLAGS)
 lib_libibacmp_la_DEPENDENCIES =  $(srcdir)/prov/acmp/src/libibacmp.map
 
 ibacmincludedir = $(includedir)/infiniband
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
