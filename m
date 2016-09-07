From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 02/28] Include pthreads in the provider libraries
Date: Wed, 7 Sep 2016 10:04:28 -0600
Message-ID: <20160907160428.GF2878@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <027401d20915$e0d3b620$a27b2260$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <027401d20915$e0d3b620$a27b2260$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 07, 2016 at 09:41:11AM -0500, Steve Wise wrote:
> > +AC_CHECK_LIB(pthread, pthread_mutex_init, [],
> > +    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires
> > libpthread.]))
> > 
> 
> Nit: This should be "libcxgb3 requires..."  Similar change needed for all of
> this patch.

Sure.

>From 44ce61764b9293468cfd8b13191c453910a6ab15 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Wed, 7 Sep 2016 10:02:47 -0600
Subject: [PATCH] Include pthreads in the provider libraries

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
index 9efc82d34f33..cc254a6e5d8d 100644
--- a/libcxgb3/configure.in
+++ b/libcxgb3/configure.in
@@ -24,6 +24,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libcxgb3 requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libcxgb3 requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libcxgb4/configure.in b/libcxgb4/configure.in
index 4a74596ce8c2..2bb930399a3e 100644
--- a/libcxgb4/configure.in
+++ b/libcxgb4/configure.in
@@ -24,6 +24,8 @@ then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libcxgb4 requires libibverbs.]))
 fi
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libcxgb4 requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADERS(sysfs/libsysfs.h)
diff --git a/libhfi1verbs/configure.in b/libhfi1verbs/configure.in
index 7611a55bae20..bdea514c25b4 100644
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
diff --git a/libmlx4/configure.ac b/libmlx4/configure.ac
index a50faa2e7353..536a07921d7e 100644
--- a/libmlx4/configure.ac
+++ b/libmlx4/configure.ac
@@ -29,6 +29,8 @@ AC_LANG([C])
 dnl Checks for libraries
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  libmlx4 requires libibverbs.]))
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libmlx4 requires libpthread.]))
 
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
diff --git a/libmlx5/configure.ac b/libmlx5/configure.ac
index c7591268a137..dca7c81a88ce 100644
--- a/libmlx5/configure.ac
+++ b/libmlx5/configure.ac
@@ -51,6 +51,9 @@ AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
 AC_CHECK_LIB(ibverbs, ibv_register_driver_ext,
     AC_DEFINE(HAVE_IBV_EXT, 1, [adding verbs extension support]))
 
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libmlx5 requires libpthread.]))
+
 dnl Checks for header files.
 AC_CHECK_HEADER(infiniband/driver.h, [],
     AC_MSG_ERROR([<infiniband/driver.h> not found.  libmlx5 requires libibverbs.]))
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
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
