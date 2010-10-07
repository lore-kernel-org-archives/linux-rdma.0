From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] Fix autotools to include the necessary M4 files
Date: Thu, 7 Oct 2010 16:38:33 -0600
Message-ID: <20101007223833.GB30829@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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

Roland - This changes the autogen.sh output from:
+ aclocal -I config
+ libtoolize --force --copy
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `config'.
libtoolize: copying file `config/ltmain.sh'
libtoolize: Consider adding `AC_CONFIG_MACRO_DIR([m4])' to configure.in and
libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
+ autoheader
+ automake --foreign --add-missing --copy
+ autoconf

to:

+ aclocal -I config
+ libtoolize --force --copy
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `config'.
libtoolize: copying file `config/ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `config'.
libtoolize: copying file `config/libtool.m4'
libtoolize: copying file `config/ltoptions.m4'
libtoolize: copying file `config/ltsugar.m4'
libtoolize: copying file `config/ltversion.m4'
libtoolize: copying file `config/lt~obsolete.m4'
+ autoheader
+ automake --foreign --add-missing --copy
+ autoconf

And fixes various build problems in weird cases. All of the libraries
you maintain need a similar patch. Do you want me to send seperate
patches for all of them?

diff --git a/Makefile.am b/Makefile.am
index 5aa1289..e6a50ba 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,6 +2,7 @@ INCLUDES = -I$(srcdir)/include
 
 lib_LTLIBRARIES = src/libibverbs.la
 
+ACLOCAL_AMFLAGS = -I config
 AM_CFLAGS = -g -Wall
 
 src_libibverbs_la_CFLAGS = $(AM_CFLAGS) -DIBV_CONFIG_DIR=\"$(sysconfdir)/libibverbs.d\"
diff --git a/configure.in b/configure.in
index 927c406..cc93e00 100644
--- a/configure.in
+++ b/configure.in
@@ -4,6 +4,7 @@ AC_PREREQ(2.57)
 AC_INIT(libibverbs, 1.1.4, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org)
 AC_CONFIG_SRCDIR([src/ibverbs.h])
 AC_CONFIG_AUX_DIR(config)
+AC_CONFIG_MACRO_DIR(config)
 AC_CONFIG_HEADER(config.h)
 AM_INIT_AUTOMAKE(libibverbs, 1.1.4)
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
