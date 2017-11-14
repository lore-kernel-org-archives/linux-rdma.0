From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/6] debian: Replace priority extra by optional
Date: Tue, 14 Nov 2017 21:02:43 +0100
Message-ID: <20171114200247.25890-3-benjamin.drung@profitbricks.com>
References: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200247.25890-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since Debian Policy version 4.0.1, the priority extra has been
deprecated.

Refer to Debian Policy Manual section 2.5 (Priorities) for details.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/debian/control b/debian/control
index 8c0957c7..403f0527 100644
--- a/debian/control
+++ b/debian/control
@@ -155,7 +155,6 @@ Description: Library for direct userspace use of RDMA (InfiniBand/iWARP)
 
 Package: libibverbs1-dbg
 Section: debug
-Priority: extra
 Architecture: linux-any
 Multi-Arch: same
 Depends: libibverbs1 (= ${binary:Version}), ${misc:Depends}
@@ -199,7 +198,6 @@ Description: InfiniBand Communication Manager (CM) library
 
 Package: libibcm1-dbg
 Section: debug
-Priority: extra
 Architecture: linux-any
 Depends: libibcm1 (= ${binary:Version}), ${misc:Depends}
 Description: Debug symbols for the libibcm1 library
@@ -238,7 +236,6 @@ Description: InfiniBand Userspace Management Datagram (uMAD) library
 
 Package: libibumad3-dbg
 Section: debug
-Priority: extra
 Architecture: linux-any
 Depends: libibumad3 (= ${binary:Version}), ${misc:Depends}
 Description: Debug symbols for the libibumad3 library
@@ -295,7 +292,6 @@ Description: Library for managing RDMA connections
 
 Package: librdmacm1-dbg
 Section: debug
-Priority: extra
 Architecture: linux-any
 Depends: librdmacm1 (= ${binary:Version}), ${misc:Depends}
 Description: Debug symbols for the librdmacm library
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
