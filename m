From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 3/3] debian: Update changelog to include Debian uploads
Date: Thu, 30 Nov 2017 13:39:40 +0100
Message-ID: <20171130123940.25795-4-benjamin.drung@profitbricks.com>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171130123940.25795-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma-core 15-2, 15-3, and 15.1-1 were uploaded to Debian unstable.
Include the changelogs from these uploads.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/changelog | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 44a83eaa..3336f331 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -4,6 +4,37 @@ rdma-core (16.0-1) unstable; urgency=low
 
  -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Tue, 14 Nov 2017 12:24:09 +0100
 
+rdma-core (15.1-1) unstable; urgency=medium
+
+  * New upstream release.
+  * Add m68k as non-coherent DMA architecture
+  * Mark libraries as Multi-Arch: same
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Thu, 30 Nov 2017 12:08:26 +0100
+
+rdma-core (15-3) unstable; urgency=medium
+
+  * debian/rules: Include architecture.mk for DEB_HOST_ARCH definition
+  * Add alpha, hppa, sh4 as non-coherent DMA archs
+  * Do not require valgrind on x32 (not available there due to build failure)
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Thu, 16 Nov 2017 17:33:48 +0100
+
+rdma-core (15-2) unstable; urgency=medium
+
+  * Do not build ibacm for non-Linux architectures
+  * Do not require valgrind if not available
+  * Let libibverbs1 15 break ibverbs-providers 14
+  * Drop dh-systemd build dependency
+  * Bump Standards-Version to 4.1.1 (no changes needed)
+  * Drop lintian overrides for false positives
+  * Set myself as maintainer (instead of linux-rdma)
+  * Do not try to install disabled ibverbs providers on architectures that do
+    not provide cache coherent DMA (Closes: #881731)
+  * Explicitly list private libibverbs symbols
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Thu, 16 Nov 2017 12:55:28 +0100
+
 rdma-core (15-1) unstable; urgency=medium
 
   * New upstream version. ibverbs-providers combines the source packages
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
