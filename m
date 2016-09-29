From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 2/9] Remove HAVE_VALGRIND_MEMCHECK_H/INCLUDE_VALGRIND
Date: Thu, 29 Sep 2016 14:47:49 -0600
Message-ID: <1475182076-5411-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The cmake build system guarantees that valgrind/memcheck.h is present.
If the system does not have it, or valgrind is disabled, then it is
replaced with a dummy header full of empty stubs.

Thus all the copy&paste boiler plate is consolidated into buildlib.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/config.h.in               |  4 ----
 libibcm/src/cm.c                   | 11 +----------
 libibumad/src/umad.c               | 14 +-------------
 libibverbs/src/ibverbs.h           | 14 +-------------
 libmlx4/src/mlx4.h                 | 18 +-----------------
 libmlx5/src/mlx5.h                 | 18 +-----------------
 libmthca/src/mthca.h               | 18 +-----------------
 librdmacm/src/cma.h                | 11 +----------
 srp_daemon/srp_daemon/srp_daemon.h |  5 -----
 9 files changed, 7 insertions(+), 106 deletions(-)

diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 0a87457e6d7a..a02be9cfb0f7 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -21,10 +21,6 @@
 // FIXME: Remove this, The cmake version hard-requires new style CLOEXEC support
 #define STREAM_CLOEXEC "e"
 
-// FIXME: Remove this, cmake always provides a valgrind/memcheck.h
-#define HAVE_VALGRIND_MEMCHECK_H 1
-#define INCLUDE_VALGRIND 1
-
 #define IBV_CONFIG_DIR "@CONFIG_DIR@"
 #define RS_CONF_DIR "@CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/rsocket"
 #define IWPM_CONFIG_FILE "@CMAKE_INSTALL_FULL_SYSCONFDIR@/iwpmd.conf"
diff --git a/libibcm/src/cm.c b/libibcm/src/cm.c
index ebe36bef89e6..f775923aa73c 100644
--- a/libibcm/src/cm.c
+++ b/libibcm/src/cm.c
@@ -49,16 +49,7 @@
 #include <infiniband/driver.h>
 #include <infiniband/marshall.h>
 
-#ifdef INCLUDE_VALGRIND
-#   include <valgrind/memcheck.h>
-#   ifndef VALGRIND_MAKE_MEM_DEFINED
-#       warning "Valgrind requested, but VALGRIND_MAKE_MEM_DEFINED undefined"
-#   endif
-#endif
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#   define VALGRIND_MAKE_MEM_DEFINED(addr,len)
-#endif
+#include <valgrind/memcheck.h>
 
 #define PFX "libibcm: "
 
diff --git a/libibumad/src/umad.c b/libibumad/src/umad.c
index 176d112e125b..0c969f1eb8ad 100644
--- a/libibumad/src/umad.c
+++ b/libibumad/src/umad.c
@@ -52,19 +52,7 @@
 
 #define IB_OPENIB_OUI                 (0x001405)
 
-#ifdef HAVE_VALGRIND_MEMCHECK_H
-
-#  include <valgrind/memcheck.h>
-
-#  ifndef VALGRIND_MAKE_MEM_DEFINED
-#    warning "Valgrind support requested, but VALGRIND_MAKE_MEM_DEFINED not available"
-#  endif
-
-#endif				/* HAVE_VALGRIND_MEMCHECK_H */
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#  define VALGRIND_MAKE_MEM_DEFINED(addr,len)
-#endif
+#include <valgrind/memcheck.h>
 
 typedef struct ib_user_mad_reg_req {
 	uint32_t id;
diff --git a/libibverbs/src/ibverbs.h b/libibverbs/src/ibverbs.h
index 062a490915b0..7892af4ad247 100644
--- a/libibverbs/src/ibverbs.h
+++ b/libibverbs/src/ibverbs.h
@@ -38,19 +38,7 @@
 
 #include <infiniband/driver.h>
 
-#ifdef HAVE_VALGRIND_MEMCHECK_H
-
-#  include <valgrind/memcheck.h>
-
-#  ifndef VALGRIND_MAKE_MEM_DEFINED
-#    warning "Valgrind support requested, but VALGRIND_MAKE_MEM_DEFINED not available"
-#  endif
-
-#endif /* HAVE_VALGRIND_MEMCHECK_H */
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#  define VALGRIND_MAKE_MEM_DEFINED(addr, len) 0
-#endif
+#include <valgrind/memcheck.h>
 
 #define HIDDEN		__attribute__((visibility ("hidden")))
 
diff --git a/libmlx4/src/mlx4.h b/libmlx4/src/mlx4.h
index feea3386f9a7..4551141d2007 100644
--- a/libmlx4/src/mlx4.h
+++ b/libmlx4/src/mlx4.h
@@ -47,23 +47,7 @@
 #define uninitialized_var(x) x = x
 #endif
 
-#ifdef HAVE_VALGRIND_MEMCHECK_H
-
-#  include <valgrind/memcheck.h>
-
-#  if !defined(VALGRIND_MAKE_MEM_DEFINED) || !defined(VALGRIND_MAKE_MEM_UNDEFINED)
-#    warning "Valgrind support requested, but VALGRIND_MAKE_MEM_(UN)DEFINED not available"
-#  endif
-
-#endif /* HAVE_VALGRIND_MEMCHECK_H */
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#  define VALGRIND_MAKE_MEM_DEFINED(addr,len)
-#endif
-
-#ifndef VALGRIND_MAKE_MEM_UNDEFINED
-#  define VALGRIND_MAKE_MEM_UNDEFINED(addr,len)
-#endif
+#include <valgrind/memcheck.h>
 
 #ifndef rmb
 #  define rmb() mb()
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index 6c4e83002028..aa8b6feceb4e 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -52,23 +52,7 @@
 #define uninitialized_var(x) x = x
 #endif
 
-#ifdef HAVE_VALGRIND_MEMCHECK_H
-
-#  include <valgrind/memcheck.h>
-
-#  if !defined(VALGRIND_MAKE_MEM_DEFINED) || !defined(VALGRIND_MAKE_MEM_UNDEFINED)
-#    warning "Valgrind support requested, but VALGRIND_MAKE_MEM_(UN)DEFINED not available"
-#  endif
-
-#endif /* HAVE_VALGRIND_MEMCHECK_H */
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#  define VALGRIND_MAKE_MEM_DEFINED(addr, len)
-#endif
-
-#ifndef VALGRIND_MAKE_MEM_UNDEFINED
-#  define VALGRIND_MAKE_MEM_UNDEFINED(addr, len)
-#endif
+#include <valgrind/memcheck.h>
 
 #ifndef rmb
 #  define rmb() mb()
diff --git a/libmthca/src/mthca.h b/libmthca/src/mthca.h
index bd1e7a2b1dc0..18d52291343f 100644
--- a/libmthca/src/mthca.h
+++ b/libmthca/src/mthca.h
@@ -39,23 +39,7 @@
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
 
-#ifdef HAVE_VALGRIND_MEMCHECK_H
-
-#  include <valgrind/memcheck.h>
-
-#  if !defined(VALGRIND_MAKE_MEM_DEFINED) || !defined(VALGRIND_MAKE_MEM_UNDEFINED)
-#    warning "Valgrind support requested, but VALGRIND_MAKE_MEM_(UN)DEFINED not available"
-#  endif
-
-#endif /* HAVE_VALGRIND_MEMCHECK_H */
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#  define VALGRIND_MAKE_MEM_DEFINED(addr,len)
-#endif
-
-#ifndef VALGRIND_MAKE_MEM_UNDEFINED
-#  define VALGRIND_MAKE_MEM_UNDEFINED(addr,len)
-#endif
+#include <valgrind/memcheck.h>
 
 #ifndef rmb
 #  define rmb() mb()
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index d6005538227f..16a55a67af9e 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -47,16 +47,7 @@
 
 #include <ccan/minmax.h>
 
-#ifdef INCLUDE_VALGRIND
-#   include <valgrind/memcheck.h>
-#   ifndef VALGRIND_MAKE_MEM_DEFINED
-#       warning "Valgrind requested, but VALGRIND_MAKE_MEM_DEFINED undefined"
-#   endif
-#endif
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#   define VALGRIND_MAKE_MEM_DEFINED(addr,len)
-#endif
+#include <valgrind/memcheck.h>
 
 #define PFX "librdmacm: "
 
diff --git a/srp_daemon/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon/srp_daemon.h
index 6d1575519bc3..d6a2d8a84728 100644
--- a/srp_daemon/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon/srp_daemon.h
@@ -408,12 +408,7 @@ typedef struct {
 	char filler[MAD_BLOCK_SIZE];
 } srp_ib_user_mad_t;
 
-#if defined(HAVE_VALGRIND_DRD_H) && defined(ENABLE_VALGRIND)
 #include <valgrind/drd.h>
-#endif
-#ifndef ANNOTATE_BENIGN_RACE_SIZED
-#define ANNOTATE_BENIGN_RACE_SIZED(a, b, c) do { } while(0)
-#endif
 
 #define pr_human(arg...)				\
 	do {						\
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
