From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl: include _errno.h in windows osd header
Date: Mon, 12 Jul 2010 15:08:16 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A127DC7B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The linux compatability header file _errno.h is moving out of verbs.h.
Include _errno.h in the windows osd header files, similar to how
errno.h is included in the linux osd header files.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This patch separates the DAPL changes from the other Windows changes.

 dapl/ibal/SOURCES                    |    2 +-
 dapl/openib_cma/windows/openib_osd.h |    4 ----
 dapl/udapl/windows/dapl_osd.h        |    1 +
 dat/udat/SOURCES                     |    2 +-
 dat/udat/windows/dat_osd.h           |    1 +
 5 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/dapl/ibal/SOURCES b/dapl/ibal/SOURCES
index b8c9932..bb1d792 100644
--- a/dapl/ibal/SOURCES
+++ b/dapl/ibal/SOURCES
@@ -28,7 +28,7 @@ SOURCES=udapl.rc			\
 
 INCLUDES = ..\include;..\common;..\..\dat\include;\
 		   ..\..\dat\udat\windows;..\udapl\windows;\
-		   ..\..\..\..\inc;..\..\..\..\inc\user;
+		   ..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\..\inc\user\linux;
 
 DAPL_OPTS = -DEXPORT_DAPL_SYMBOLS -D_VENDOR_IBAL_ -DDAPL_MERGE_CM_DTO\
 			-DDAT_EXTENSIONS
diff --git a/dapl/openib_cma/windows/openib_osd.h b/dapl/openib_cma/windows/openib_osd.h
index 3290081..ac392b0 100644
--- a/dapl/openib_cma/windows/openib_osd.h
+++ b/dapl/openib_cma/windows/openib_osd.h
@@ -4,7 +4,3 @@
 
 #define ntohll _byteswap_uint64
 #define htonll _byteswap_uint64
-
-#ifndef EADDRNOTAVAIL
-#define EADDRNOTAVAIL	WSAEADDRNOTAVAIL
-#endif
diff --git a/dapl/udapl/windows/dapl_osd.h b/dapl/udapl/windows/dapl_osd.h
index 5fb9363..4b9ecbf 100644
--- a/dapl/udapl/windows/dapl_osd.h
+++ b/dapl/udapl/windows/dapl_osd.h
@@ -50,6 +50,7 @@
 
 #include <stddef.h>
 #include <complib/cl_types.h>
+#include <_errno.h>
 #pragma warning ( push, 3 )
 #include <winioctl.h>
 #include <stdio.h>
diff --git a/dat/udat/SOURCES b/dat/udat/SOURCES
index 7d37f65..4cddf72 100644
--- a/dat/udat/SOURCES
+++ b/dat/udat/SOURCES
@@ -19,7 +19,7 @@ SOURCES=udat.rc			\
 	udat_sr_parser.c	\
 	udat_sources.c
 
-INCLUDES=windows;..\common;..\include;
+INCLUDES=windows;..\common;..\include;..\..\..\..\inc\user\linux;
 RCOPTIONS=/I..\..\..\..\inc;
 
 # FIX ME!!! XXX specifically the 4113 warning prior to testing.
diff --git a/dat/udat/windows/dat_osd.h b/dat/udat/windows/dat_osd.h
index 6941e46..e661ba3 100644
--- a/dat/udat/windows/dat_osd.h
+++ b/dat/udat/windows/dat_osd.h
@@ -57,6 +57,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
+#include <_errno.h>
 
 #ifndef STATIC
 #define STATIC static


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
