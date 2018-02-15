From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 3/3] debian: Add Debian uploads up to version 16.2-1
Date: Thu, 15 Feb 2018 12:08:42 +0100
Message-ID: <20180215110842.6375-3-benjamin.drung@profitbricks.com>
References: <20180215110842.6375-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180215110842.6375-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma-core 16.1-2 and 16.2-1 were uploaded to Debian unstable. Include
the changelogs from these uploads and update the timestamp from the top
commit.
---
 debian/changelog | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index 7aa1408d..8dcb371f 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -2,7 +2,21 @@ rdma-core (17.0-1) unstable; urgency=medium
 
   * New upstream release.
 
- -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Thu, 04 Jan 2018 15:25:06 +0100
+ -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Thu, 15 Feb 2018 12:06:48 +0100
+
+rdma-core (16.2-1) unstable; urgency=medium
+
+  * New upstream bugfix release
+  * Guard udevadm call again
+  * Override intentional systemd WantedBy= relationship lintian warning
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Thu, 15 Feb 2018 11:41:14 +0100
+
+rdma-core (16.1-2) unstable; urgency=medium
+
+  * Do not require valgrind on ia64 (Closes: #887511)
+
+ -- Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>  Fri, 19 Jan 2018 12:37:05 +0100
 
 rdma-core (16.1-1) unstable; urgency=medium
 
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
