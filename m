From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] debian: Squash changelog to be one entry
Date: Wed, 29 Mar 2017 16:53:04 +0300
Message-ID: <20170329135304.11764-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The debian's changelog is managed outside of rdma-core upstream package
and hence there is no need to add entry to it, just update version only.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 debian/changelog | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/debian/changelog b/debian/changelog
index 5a323cef..37cd5b51 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,10 +1,4 @@
 rdma-core (14-1) unstable; urgency=low
-
-  * Bump version.
-
- -- Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  Sat, 25 Mar 2017 14:29:00 -0600
-
-rdma-core (13-1) unstable; urgency=low
   * New version.
   * Adding debian/copyright.
   * Close ITP (Closes: #848971).
--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
