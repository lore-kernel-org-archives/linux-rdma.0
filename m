From: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Subject: Re: [PATCH] librdmacm: fix make install
Date: Mon, 25 Oct 2010 10:51:29 +0100
Message-ID: <ia3jv3$930$1@dough.gmane.org>
References: <i9ru6c$dm5$1@dough.gmane.org> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B18A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B18A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

make install fails if the include files in the install prefix
include/rdma,infiniband already exist. install claims that the <src>
and <destination> file are the same and exits with an error.

This patch modifies Makefile.am so that the rdma and infiniband include
files explicitly reference the source directory rather than the build
directory.

Also, EXTRA_DIST now only lists files that are not referenced anywhere
else in Makefile.am

Signed-off-by: Jonathan Rosser <jrosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
---
  Makefile.am |   12 +++++-------
  1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 2668aa3..8790fe8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -35,11 +35,11 @@ examples_rdma_server_LDADD = 
$(top_builddir)/src/librdmacm.la
  librdmacmincludedir = $(includedir)/rdma
  infinibandincludedir = $(includedir)/infiniband

-librdmacminclude_HEADERS = include/rdma/rdma_cma_abi.h \
-                          include/rdma/rdma_cma.h \
-                          include/rdma/rdma_verbs.h
+librdmacminclude_HEADERS = $(top_srcdir)/include/rdma/rdma_cma_abi.h \
+                          $(top_srcdir)/include/rdma/rdma_cma.h \
+                          $(top_srcdir)/include/rdma/rdma_verbs.h

-infinibandinclude_HEADERS = include/infiniband/ib.h
+infinibandinclude_HEADERS = $(top_srcdir)/include/infiniband/ib.h

  man_MANS = \
         man/rdma_accept.3 \
@@ -97,9 +97,7 @@ man_MANS = \
         man/rdma_client.1 \
         man/rdma_cm.7

-EXTRA_DIST = include/rdma/rdma_cma_abi.h include/rdma/rdma_cma.h \
-            include/infiniband/ib.h include/rdma/rdma_verbs.h \
-            src/cma.h src/librdmacm.map librdmacm.spec.in $(man_MANS)
+EXTRA_DIST = src/cma.h src/librdmacm.map librdmacm.spec.in $(man_MANS)

  dist-hook: librdmacm.spec
         cp librdmacm.spec $(distdir)
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
