From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 02/16] Include pthreads in the provider libraries
Date: Tue, 20 Sep 2016 16:10:11 -0600
Message-ID: <1474409425-15769-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It is a mistake to not explicitly link to the libraries required.
Not linking causes the symbols to drop the symbol version which could
cause runtime problems down the road if pthreads ever goes through
another symbol version change.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libhfi1verbs/configure.in  | 2 ++
 libi40iw/configure.ac      | 2 ++
 libipathverbs/configure.in | 2 ++
 libmthca/configure.in      | 2 ++
 libnes/configure.in        | 2 ++
 libocrdma/configure.in     | 2 ++
 librxe/configure.in        | 2 ++
 7 files changed, 14 insertions(+)

diff --git a/libhfi1verbs/configure.in b/libhfi1verbs/configure.in
index 5bbcffc0dc56..a8218914f53f 100644
--- a/libhfi1verbs/configure.in
+++ b/libhfi1verbs/configure.in
@@ -81,6 +81,8 @@ AC_PROG_CC
 dnl Checks for libraries
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libhfi1verbs requires libibverbs.]))
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libhfi1verbs requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
diff --git a/libi40iw/configure.ac b/libi40iw/configure.ac
index 04e246d75366..108ffd5999b9 100644
--- a/libi40iw/configure.ac
+++ b/libi40iw/configure.ac
@@ -23,6 +23,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libi40iw requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libi40iw requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libipathverbs/configure.in b/libipathverbs/configure.in
index 70093c3a8acb..9718d56e4411 100644
--- a/libipathverbs/configure.in
+++ b/libipathverbs/configure.in
@@ -81,6 +81,8 @@ AC_CHECK_SIZEOF(long)
 dnl Checks for library functions
 AC_CHECK_FUNCS(ibv_read_sysfs_file ibv_dontfork_range ibv_dofork_range \
     ibv_register_driver)
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found. libipathverbs requires libpthread.]))
 
 dnl Now check if for libibverbs 1.0 vs 1.1
 dummy=if$$
diff --git a/libmthca/configure.in b/libmthca/configure.in
index ffd5db6962f6..c5454436bf8f 100644
--- a/libmthca/configure.in
+++ b/libmthca/configure.in
@@ -30,6 +30,8 @@ AC_PROG_CC
 dnl Checks for libraries
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libmthca requires libibverbs.]))
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libmthca requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
diff --git a/libnes/configure.in b/libnes/configure.in
index 0cde51420753..08e9948ed13c 100644
--- a/libnes/configure.in
+++ b/libnes/configure.in
@@ -23,6 +23,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libnes requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libnes requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libocrdma/configure.in b/libocrdma/configure.in
index a0c8175035f9..659d79f52f25 100644
--- a/libocrdma/configure.in
+++ b/libocrdma/configure.in
@@ -24,6 +24,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libocrdma requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libocrdma requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/librxe/configure.in b/librxe/configure.in
index 4f349cc9bae7..957d65000704 100644
--- a/librxe/configure.in
+++ b/librxe/configure.in
@@ -36,6 +36,8 @@ if test x$enable_repackage = x || test x$enable_repackage = xno; then
         AC_MSG_ERROR([<infiniband/driver.h> not found.  librxe requires libibverbs.]))
     AC_CHECK_FUNCS(ibv_read_sysfs_file ibv_dontfork_range ibv_dofork_range \
         ibv_register_driver)
+    AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  librxe requires libpthread.]))
 
     dummy=if$$
     cat <<IBV_VERSION > $dummy.c
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
