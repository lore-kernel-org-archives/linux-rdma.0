From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: windows: need to include linux directory to pick
 up _errno.h
Date: Wed, 19 May 2010 16:27:36 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70135EB@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/SOURCES |    2 +-
 dapl/openib_scm/SOURCES |    2 +-
 dapl/openib_ucm/SOURCES |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/dapl/openib_cma/SOURCES b/dapl/openib_cma/SOURCES
index d6b97a2..0c3764b 100644
--- a/dapl/openib_cma/SOURCES
+++ b/dapl/openib_cma/SOURCES
@@ -25,7 +25,7 @@ SOURCES = \
 	cm.c
 
 INCLUDES = ..\include;..\openib_common;..\common;windows;..\..\dat\include;\
-		   ..\..\dat\udat\windows;..\udapl\windows;\
+		   ..\..\dat\udat\windows;..\udapl\windows;..\..\..\..\inc\user\linux;\
 		   ..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\libibverbs\include;\
 		   ..\..\..\librdmacm\include
 
diff --git a/dapl/openib_scm/SOURCES b/dapl/openib_scm/SOURCES
index 6e4ad30..2129e27 100644
--- a/dapl/openib_scm/SOURCES
+++ b/dapl/openib_scm/SOURCES
@@ -25,7 +25,7 @@ SOURCES = \
         cm.c
 
 INCLUDES = ..\include;..\openib_common\;..\common;windows;..\..\dat\include;\
-		   ..\..\dat\udat\windows;..\udapl\windows;\
+		   ..\..\dat\udat\windows;..\udapl\windows;..\..\..\..\inc\user\linux;\
 		   ..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\libibverbs\include
 
 DAPL_OPTS = -DEXPORT_DAPL_SYMBOLS -DDAT_EXTENSIONS -DSOCK_CM -DOPENIB -DCQ_WAIT_OBJECT
diff --git a/dapl/openib_ucm/SOURCES b/dapl/openib_ucm/SOURCES
index 7eecf48..a2b5dce 100644
--- a/dapl/openib_ucm/SOURCES
+++ b/dapl/openib_ucm/SOURCES
@@ -21,7 +21,8 @@ SOURCES = udapl.rc ..\dapl_common_src.c ..\dapl_udapl_src.c ..\openib_common.c \
 
 INCLUDES = ..\include;..\openib_common\;..\common;windows;..\..\dat\include;\
 		   ..\..\dat\udat\windows;..\udapl\windows;\
-		   ..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\libibverbs\include
+		   ..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\libibverbs\include;\
+		   ..\..\..\..\inc\user\linux;
 
 DAPL_OPTS = -DEXPORT_DAPL_SYMBOLS -DDAT_EXTENSIONS -DOPENIB -DCQ_WAIT_OBJECT
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
