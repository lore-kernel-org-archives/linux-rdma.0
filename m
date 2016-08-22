From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 05/15] Include pthreads in the provider libraries
Date: Mon, 22 Aug 2016 12:13:28 -0600
Message-ID: <1471889618-1605-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is a mistake to not explicitly link to the libraries required.
Not linking causes the symbols to drop the symbol version which could
cause runtime problems down the road if pthreads ever goes through
another symbol version change.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libcxgb3/configure.in      | 2 ++
 libcxgb4/configure.in      | 2 ++
 libhfi1verbs/configure.in  | 2 ++
 libi40iw/configure.ac      | 2 ++
 libipathverbs/configure.in | 2 ++
 libmlx4/configure.ac       | 2 ++
 libmlx5/configure.ac       | 3 +++
 libmthca/configure.in      | 2 ++
 libnes/configure.in        | 2 ++
 libocrdma/configure.in     | 2 ++
 librxe/configure.in        | 2 ++
 11 files changed, 23 insertions(+)

diff --git a/libcxgb3/configure.in b/libcxgb3/configure.in
index 9efc82d34f33..db9177230cae 100644
--- a/libcxgb3/configure.in
+++ b/libcxgb3/configure.in
@@ -24,6 +24,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libcxgb3 requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libcxgb4/configure.in b/libcxgb4/configure.in
index 4a74596ce8c2..336ab1c57daf 100644
--- a/libcxgb4/configure.in
+++ b/libcxgb4/configure.in
@@ -24,6 +24,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libcxgb4 requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libhfi1verbs/configure.in b/libhfi1verbs/configure.in
index 7611a55bae20..3f6e6779ce74 100644
--- a/libhfi1verbs/configure.in
+++ b/libhfi1verbs/configure.in
@@ -81,6 +81,8 @@ AC_PROG_CC
 dnl Checks for libraries
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libhfi1verbs requires libibverbs.]))
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
diff --git a/libi40iw/configure.ac b/libi40iw/configure.ac
index 04e246d75366..e3849b03561b 100644
--- a/libi40iw/configure.ac
+++ b/libi40iw/configure.ac
@@ -23,6 +23,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libi40iw requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libipathverbs/configure.in b/libipathverbs/configure.in
index 70093c3a8acb..f2cf2e3f90ee 100644
--- a/libipathverbs/configure.in
+++ b/libipathverbs/configure.in
@@ -81,6 +81,8 @@ AC_CHECK_SIZEOF(long)
 dnl Checks for library functions
 AC_CHECK_FUNCS(ibv_read_sysfs_file ibv_dontfork_range ibv_dofork_range \
     ibv_register_driver)
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Now check if for libibverbs 1.0 vs 1.1
 dummy=if$$
diff --git a/libmlx4/configure.ac b/libmlx4/configure.ac
index a50faa2e7353..01bf7cbcf163 100644
--- a/libmlx4/configure.ac
+++ b/libmlx4/configure.ac
@@ -29,6 +29,8 @@ AC_LANG([C])
 dnl Checks for libraries
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libmlx4 requires libibverbs.]))
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
diff --git a/libmlx5/configure.ac b/libmlx5/configure.ac
index c7591268a137..cd235474245e 100644
--- a/libmlx5/configure.ac
+++ b/libmlx5/configure.ac
@@ -51,6 +51,9 @@ AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
 AC_CHECK_LIB(ibverbs, ibv_register_driver_ext,
     AC_DEFINE(HAVE_IBV_EXT, 1, [adding verbs extension support]))
 
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
+
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
     AC_MSG_ERROR([<infiniband/driver.h> not found.  libmlx5 requires libibverbs.]))
diff --git a/libmthca/configure.in b/libmthca/configure.in
index ffd5db6962f6..fb665ed2dd40 100644
--- a/libmthca/configure.in
+++ b/libmthca/configure.in
@@ -30,6 +30,8 @@ AC_PROG_CC
 dnl Checks for libraries
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libmthca requires libibverbs.]))
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
diff --git a/libnes/configure.in b/libnes/configure.in
index 0cde51420753..a25d129cc159 100644
--- a/libnes/configure.in
+++ b/libnes/configure.in
@@ -23,6 +23,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libnes requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libocrdma/configure.in b/libocrdma/configure.in
index a0c8175035f9..2fd54b5ecd72 100644
--- a/libocrdma/configure.in
+++ b/libocrdma/configure.in
@@ -24,6 +24,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libocrdma requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/librxe/configure.in b/librxe/configure.in
index 4f349cc9bae7..8927cef50468 100644
--- a/librxe/configure.in
+++ b/librxe/configure.in
@@ -36,6 +36,8 @@ if test x$enable_repackage = x || test x$enable_repackage = xno; then
         AC_MSG_ERROR([<infiniband/driver.h> not found.  librxe requires libibverbs.]))
     AC_CHECK_FUNCS(ibv_read_sysfs_file ibv_dontfork_range ibv_dofork_range \
         ibv_register_driver)
+    AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
 
     dummy=if$$
     cat <<IBV_VERSION > $dummy.c
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
