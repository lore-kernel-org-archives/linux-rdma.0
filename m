From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH librdmacm] Fix autotools to include the necessary M4 files
Date: Thu, 7 Oct 2010 16:50:34 -0600
Message-ID: <20101007225034.GC30829@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Otherwise running autogen.sh with a new version of autotools and then
building on a system with an older version tends to explode.
Unfortunately this is sometimes necessary since the new version is
required by the package.

This is how GNU envisions this mess works at least..

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 Makefile.am  |    1 +
 configure.in |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

Sean - same story as for Roland, all your libraries need this patch,
can you apply it to all of them? Thanks.

diff --git a/Makefile.am b/Makefile.am
index 2668aa3..434cb6b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,6 +2,7 @@ INCLUDES = -I$(srcdir)/include
 
 lib_LTLIBRARIES = src/librdmacm.la
 
+ACLOCAL_AMFLAGS = -I config
 AM_CFLAGS = -g -Wall -D_GNU_SOURCE
 
 src_librdmacm_la_CFLAGS = $(AM_CFLAGS)
diff --git a/configure.in b/configure.in
index 37d1851..e63211f 100644
--- a/configure.in
+++ b/configure.in
@@ -4,6 +4,7 @@ AC_PREREQ(2.57)
 AC_INIT(librdmacm, 1.0.13, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org)
 AC_CONFIG_SRCDIR([src/cma.c])
 AC_CONFIG_AUX_DIR(config)
+AC_CONFIG_MACRO_DIR(config)
 AM_CONFIG_HEADER(config.h)
 AM_INIT_AUTOMAKE(librdmacm, 1.0.13)
 
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
