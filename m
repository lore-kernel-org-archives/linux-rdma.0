From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 03/16] Be explicit about _GNU_SOURCE
Date: Tue, 20 Sep 2016 16:10:12 -0600
Message-ID: <1474409425-15769-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The recommended way to use this macro is at the top of the source file,
avoid globally setting it via 'gcc -D' as few source files actually
need it. In this tree we only need it in 19 out of 101 sources.

_GNU_SOURCE changes the behaviour of a few select calls away from the C99
standard and should generally be minimized.

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (ibcm,rdmacm)
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/Makefile.am                   | 2 +-
 iwpmd/Makefile.am                   | 2 +-
 libhfi1verbs/Makefile.am            | 2 +-
 libi40iw/Makefile.am                | 2 +-
 libibcm/Makefile.am                 | 2 +-
 libibcm/src/cm.c                    | 2 +-
 libibverbs/configure.ac             | 1 -
 libibverbs/examples/asyncwatch.c    | 2 +-
 libibverbs/examples/rc_pingpong.c   | 2 +-
 libibverbs/examples/srq_pingpong.c  | 2 +-
 libibverbs/examples/uc_pingpong.c   | 2 +-
 libibverbs/examples/ud_pingpong.c   | 2 +-
 libibverbs/examples/xsrq_pingpong.c | 2 +-
 libibverbs/src/device.c             | 2 +-
 libibverbs/src/init.c               | 2 +-
 libibverbs/src/sysfs.c              | 2 +-
 libibverbs/src/verbs.c              | 1 +
 libipathverbs/Makefile.am           | 2 +-
 libmthca/Makefile.am                | 2 +-
 libmthca/src/memfree.c              | 2 +-
 libnes/Makefile.am                  | 2 +-
 libocrdma/Makefile.am               | 2 +-
 librdmacm/Makefile.am               | 2 +-
 librdmacm/examples/rping.c          | 2 +-
 librdmacm/src/preload.c             | 2 +-
 librdmacm/src/rsocket.c             | 2 +-
 librxe/Makefile.am                  | 2 +-
 27 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/ibacm/Makefile.am b/ibacm/Makefile.am
index a910585a8fd9..c5cdc6905714 100644
--- a/ibacm/Makefile.am
+++ b/ibacm/Makefile.am
@@ -1,6 +1,6 @@
 AM_CPPFLAGS = -I$(srcdir)/include -I$(srcdir)/linux -I$(srcdir)/src
 
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE 
+AM_CFLAGS = -g -Wall
 AM_LDFLAGS = -lpthread -ldl
 
 if HAVE_LD_VERSION_SCRIPT
diff --git a/iwpmd/Makefile.am b/iwpmd/Makefile.am
index 1a1473c4bd78..fbb4334da961 100644
--- a/iwpmd/Makefile.am
+++ b/iwpmd/Makefile.am
@@ -1,5 +1,5 @@
 AM_CPPFLAGS = -I$(includedir)/libnl3 -I/usr/include/libnl3
-AM_CFLAGS = -O2 -Wall -D_GNU_SOURCE
+AM_CFLAGS = -O2 -Wall
 ACLOCAL_AMFLAGS = -I m4
 
 bin_PROGRAMS = src/iwpmd
diff --git a/libhfi1verbs/Makefile.am b/libhfi1verbs/Makefile.am
index cd6ca0aa6100..3a51f0ba9889 100644
--- a/libhfi1verbs/Makefile.am
+++ b/libhfi1verbs/Makefile.am
@@ -51,7 +51,7 @@
 # Copyright (c) 2007. QLogic Corp. All rights reserved.
 # Copyright (c) 2003, 2004, 2005. PathScale, Inc. All rights reserved.
 
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+AM_CFLAGS = -g -Wall
 
 hfiverbs_version_script = @HFIVERBS_VERSION_SCRIPT@
 
diff --git a/libi40iw/Makefile.am b/libi40iw/Makefile.am
index 92772e5c8503..98d6f8ae1226 100644
--- a/libi40iw/Makefile.am
+++ b/libi40iw/Makefile.am
@@ -1,7 +1,7 @@
 lib_LTLIBRARIES = src/libi40iw.la
 
 AM_CPPFLAGS = -I$(srcdir)/src
-AM_CFLAGS = -O2 -Wall -D_GNU_SOURCE
+AM_CFLAGS = -O2 -Wall
 
 if HAVE_LD_VERSION_SCRIPT
     i40iw_version_script = -Wl,--version-script=$(srcdir)/src/i40iw.map
diff --git a/libibcm/Makefile.am b/libibcm/Makefile.am
index 2333930db548..e4be9f887b1c 100644
--- a/libibcm/Makefile.am
+++ b/libibcm/Makefile.am
@@ -3,7 +3,7 @@ INCLUDES = -I$(srcdir)/include
 lib_LTLIBRARIES = src/libibcm.la
 
 ACLOCAL_AMFLAGS = -I config
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+AM_CFLAGS = -g -Wall
 
 src_libibcm_la_CFLAGS = $(AM_CFLAGS)
 
diff --git a/libibcm/src/cm.c b/libibcm/src/cm.c
index 996268141a04..5c56381fd5db 100644
--- a/libibcm/src/cm.c
+++ b/libibcm/src/cm.c
@@ -32,7 +32,7 @@
  *
  * $Id$
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/configure.ac b/libibverbs/configure.ac
index 90c33dfb7c75..a8046f3c5a72 100644
--- a/libibverbs/configure.ac
+++ b/libibverbs/configure.ac
@@ -11,7 +11,6 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 dnl Checks for programs
 AC_PROG_CC
-AC_USE_SYSTEM_EXTENSIONS
 AC_PROG_LN_S
 LT_INIT
 
diff --git a/libibverbs/examples/asyncwatch.c b/libibverbs/examples/asyncwatch.c
index a77c1c8802c2..df1261503b7d 100644
--- a/libibverbs/examples/asyncwatch.c
+++ b/libibverbs/examples/asyncwatch.c
@@ -29,7 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 8d5835774590..967678362833 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -29,7 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index f61acb006c83..a1061c31972d 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -29,7 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index 272dc2668708..b25d16c79021 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -29,7 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
index 6d32cedc1284..fa99b9e51dfb 100644
--- a/libibverbs/examples/ud_pingpong.c
+++ b/libibverbs/examples/ud_pingpong.c
@@ -29,7 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index 70c576098581..ff00180f2644 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/src/device.c b/libibverbs/src/device.c
index 82d928a5d4b2..cfdf7cfd337c 100644
--- a/libibverbs/src/device.c
+++ b/libibverbs/src/device.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/src/init.c b/libibverbs/src/init.c
index dbdd7954a090..bca0e02d11e1 100644
--- a/libibverbs/src/init.c
+++ b/libibverbs/src/init.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/src/sysfs.c b/libibverbs/src/sysfs.c
index 0b6ad1e8cc9e..2e68da4bc97f 100644
--- a/libibverbs/src/sysfs.c
+++ b/libibverbs/src/sysfs.c
@@ -29,7 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libibverbs/src/verbs.c b/libibverbs/src/verbs.c
index fc8b9f65e4e4..debb6f687111 100644
--- a/libibverbs/src/verbs.c
+++ b/libibverbs/src/verbs.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libipathverbs/Makefile.am b/libipathverbs/Makefile.am
index 21cd83440b42..f9d4698c5e2c 100644
--- a/libipathverbs/Makefile.am
+++ b/libipathverbs/Makefile.am
@@ -33,7 +33,7 @@
 # combinations of this program with other software, or any other
 # product whatsoever.
 
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+AM_CFLAGS = -g -Wall
 
 ipathverbs_version_script = @IPATHVERBS_VERSION_SCRIPT@
 
diff --git a/libmthca/Makefile.am b/libmthca/Makefile.am
index e9be461693cd..1dd9a7ba8601 100644
--- a/libmthca/Makefile.am
+++ b/libmthca/Makefile.am
@@ -1,4 +1,4 @@
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+AM_CFLAGS = -g -Wall
 
 mthca_version_script = @MTHCA_VERSION_SCRIPT@
 
diff --git a/libmthca/src/memfree.c b/libmthca/src/memfree.c
index 53f01fcd6369..87de4c0f5899 100644
--- a/libmthca/src/memfree.c
+++ b/libmthca/src/memfree.c
@@ -29,7 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/libnes/Makefile.am b/libnes/Makefile.am
index a5fdfc27517e..ade8e8b1eee8 100644
--- a/libnes/Makefile.am
+++ b/libnes/Makefile.am
@@ -1,7 +1,7 @@
 
 lib_LTLIBRARIES = src/libnes.la
 
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+AM_CFLAGS = -g -Wall
 
 if HAVE_LD_VERSION_SCRIPT
     nes_version_script = -Wl,--version-script=$(srcdir)/src/nes.map
diff --git a/libocrdma/Makefile.am b/libocrdma/Makefile.am
index c07f38c0bc65..9b786e2b51a4 100644
--- a/libocrdma/Makefile.am
+++ b/libocrdma/Makefile.am
@@ -1,7 +1,7 @@
 
 lib_LTLIBRARIES = src/libocrdma.la
 
-AM_CFLAGS = -Wall -D_GNU_SOURCE
+AM_CFLAGS = -Wall
 
 if HAVE_LD_VERSION_SCRIPT
     ocrdma_version_script = -Wl,--version-script=$(srcdir)/src/ocrdma.map
diff --git a/librdmacm/Makefile.am b/librdmacm/Makefile.am
index bf721345f68d..84af01a14b4b 100644
--- a/librdmacm/Makefile.am
+++ b/librdmacm/Makefile.am
@@ -5,7 +5,7 @@ lib_LTLIBRARIES = src/librdmacm.la
 rslib_LTLIBRARIES = src/librspreload.la
 
 ACLOCAL_AMFLAGS = -I config
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DSYSCONFDIR=\"$(sysconfdir)\" -DRDMADIR=\"@rdmadir@\"
+AM_CFLAGS = -g -Wall -DSYSCONFDIR=\"$(sysconfdir)\" -DRDMADIR=\"@rdmadir@\"
 
 src_librdmacm_la_CFLAGS = $(AM_CFLAGS)
 src_librspreload_la_CFLAGS = $(AM_CFLAGS)
diff --git a/librdmacm/examples/rping.c b/librdmacm/examples/rping.c
index a0d10779a8b1..171857dcb5ca 100644
--- a/librdmacm/examples/rping.c
+++ b/librdmacm/examples/rping.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#define _GNU_SOURCE
 #include <getopt.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/librdmacm/src/preload.c b/librdmacm/src/preload.c
index 3a0bc4c8c71d..a0bc1cfbd7a5 100644
--- a/librdmacm/src/preload.c
+++ b/librdmacm/src/preload.c
@@ -30,7 +30,7 @@
  * SOFTWARE.
  *
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/librdmacm/src/rsocket.c b/librdmacm/src/rsocket.c
index c4f1b57dbb9a..818505fbe02e 100644
--- a/librdmacm/src/rsocket.c
+++ b/librdmacm/src/rsocket.c
@@ -30,7 +30,7 @@
  * SOFTWARE.
  *
  */
-
+#define _GNU_SOURCE
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
diff --git a/librxe/Makefile.am b/librxe/Makefile.am
index fe6c36c4eaba..972ae3b390b7 100644
--- a/librxe/Makefile.am
+++ b/librxe/Makefile.am
@@ -1,4 +1,4 @@
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+AM_CFLAGS = -g -Wall
   
 rxe_version_script = @RXE_VERSION_SCRIPT@
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
