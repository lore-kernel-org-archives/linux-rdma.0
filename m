From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 3/3] debian: Update changelog to include Debian upload
Date: Tue, 14 Nov 2017 12:33:30 +0100
Message-ID: <20171114113330.2715-4-benjamin.drung@profitbricks.com>
References: <20171114113330.2715-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114113330.2715-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma-core 15-1 was accepted in Debian. Include the changelog from that
upload.
---
 debian/changelog | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/debian/changelog b/debian/changelog
index 9ee7fe16..10ee3c7d 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,7 +1,14 @@
 rdma-core (16-1) unstable; urgency=low
 
-  * New version.
-  * Adding debian/copyright.
-  * Close ITP (Closes: #848971).
+  * New upstream release.
 
- -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Mon, 12 Sep 2016 13:44:24 -0600
+ -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Tue, 14 Nov 2017 12:24:09 +0100
+
+rdma-core (15-1) unstable; urgency=medium
+
+  * New upstream version. ibverbs-providers combines the source packages
+    libcxgb3, libipathverbs, libmlx4, libmlx5, libmthca, and libnes.
+    rdma-core also combines the source packages ibacm, libibcm, libibumad,
+    libibverbs, librdmacm, and srptools (Closes: #848971)
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Mon, 18 Sep 2017 11:00:39 +0200
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
