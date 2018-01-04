From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/2] debian: Update changelog to include Debian uploads 16.x
Date: Thu,  4 Jan 2018 15:27:51 +0100
Message-ID: <20180104142751.32705-2-benjamin.drung@profitbricks.com>
References: <20180104142751.32705-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104142751.32705-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma-core 16.0-1 and 16.1-1 were uploaded to Debian unstable.
Include the changelogs from these uploads and update the timestamp from
the top commit.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/changelog | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/debian/changelog b/debian/changelog
index 597deefe..7aa1408d 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,8 +1,24 @@
-rdma-core (17.0-1) unstable; urgency=low
+rdma-core (17.0-1) unstable; urgency=medium
 
   * New upstream release.
 
- -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Tue, 14 Nov 2017 12:24:09 +0100
+ -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Thu, 04 Jan 2018 15:25:06 +0100
+
+rdma-core (16.1-1) unstable; urgency=medium
+
+  * New upstream bugfix release.
+  * Bump Standards-Version to 4.1.3 (no changes needed)
+  * Add udev dependency to rdma-core and srptools
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Thu, 04 Jan 2018 14:42:26 +0100
+
+rdma-core (16.0-1) unstable; urgency=medium
+
+  * New upstream release.
+  * Update private libibverbs symbols
+  * Bump Standards-Version to 4.1.2 (no changes needed)
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Tue, 12 Dec 2017 11:01:38 +0100
 
 rdma-core (15.1-1) unstable; urgency=medium
 
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
