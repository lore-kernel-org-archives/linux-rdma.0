From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH for infiniband-diags] Fix errors triggered by autoregen.sh
Date: Sun, 18 Aug 2013 10:51:50 +0200
Message-ID: <52108B26.5070407@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that running autoregen.sh with recent versions of autoconf and
automake triggers the following errors:

libibnetdisc/Makefile.am:35: compiling `testleaks.c' with per-target flags requires `AM_PROG_CC_C_O' in `configure.in'
Makefile.am: installing `./INSTALL'
Makefile.am: required file `./NEWS' not found

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 configure.ac |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 02e4592..4c37259 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,7 +5,7 @@ AC_INIT(infiniband-diags, 1.6.2, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
 AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE
+AM_INIT_AUTOMAKE([foreign])
 
 AC_SUBST(RELEASE, ${RELEASE:-unknown})
 AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
@@ -22,6 +22,7 @@ AM_CONDITIONAL(DEBUG, test x$debug = xtrue)
 
 dnl Checks for programs
 AC_PROG_CC
+AM_PROG_CC_C_O
 AC_PROG_LIBTOOL
 
 AC_CHECK_PROG(have_dash, [dash], true, false)
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
