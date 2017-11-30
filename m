From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/3] debian: Mark libraries as Multi-Arch: same
Date: Thu, 30 Nov 2017 13:39:39 +0100
Message-ID: <20171130123940.25795-3-benjamin.drung@profitbricks.com>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171130123940.25795-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The library packages do not contain any maintainer scripts and for any
pair of architectures, the common files have equal content. Thus it
should be safe to mark the package Multi-Arch: same.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/debian/control b/debian/control
index cddc9db5..451b379f 100644
--- a/debian/control
+++ b/debian/control
@@ -175,6 +175,7 @@ Description: Debug symbols for the libibverbs library
 Package: libibcm-dev
 Section: libdevel
 Architecture: linux-any
+Multi-Arch: same
 Depends: libibcm1 (= ${binary:Version}), libibverbs-dev, ${misc:Depends}
 Description: Development files for the libibcm library
  libibcm provides a userspace implementation of an InfiniBand
@@ -187,6 +188,7 @@ Description: Development files for the libibcm library
 
 Package: libibcm1
 Architecture: linux-any
+Multi-Arch: same
 Section: libs
 Depends: ${misc:Depends}, ${shlibs:Depends}
 Description: InfiniBand Communication Manager (CM) library
@@ -212,6 +214,7 @@ Description: Debug symbols for the libibcm1 library
 Package: libibumad-dev
 Section: libdevel
 Architecture: linux-any
+Multi-Arch: same
 Depends: libibumad3 (= ${binary:Version}), ${misc:Depends}
 Description: Development files for libibumad
  libibumad provides userspace Infiniband Management Datagram (uMAD)
@@ -224,6 +227,7 @@ Description: Development files for libibumad
 
 Package: libibumad3
 Architecture: linux-any
+Multi-Arch: same
 Section: libs
 Pre-Depends: ${misc:Pre-Depends}
 Depends: ${misc:Depends}, ${shlibs:Depends}
@@ -250,6 +254,7 @@ Description: Debug symbols for the libibumad3 library
 Package: librdmacm-dev
 Section: libdevel
 Architecture: linux-any
+Multi-Arch: same
 Depends: libibverbs-dev, librdmacm1 (= ${binary:Version}), ${misc:Depends}
 Description: Development files for the librdmacm library
  librdmacm is a library that allows applications to set up reliable
@@ -271,6 +276,7 @@ Description: Development files for the librdmacm library
 
 Package: librdmacm1
 Architecture: linux-any
+Multi-Arch: same
 Section: libs
 Pre-Depends: ${misc:Pre-Depends}
 Depends: ${misc:Depends}, ${shlibs:Depends}
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
