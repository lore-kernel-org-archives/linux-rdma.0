From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 4/4] debian/changelog: Update changes
Date: Thu, 29 Dec 2016 15:49:08 +0200
Message-ID: <20161229134908.13185-5-leon@kernel.org>
References: <20161229134908.13185-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161229134908.13185-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Document the recent changes into debian/changelog.

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/changelog | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 7b9c634..3fb247d 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,14 @@
+rdma-core (12-1.1) UNRELEASED; urgency=medium
+
+    * New version.
+    * Adding debian/copyright.
+    * Fix debian/iwpmd.
+    * Fix debian/control.
+    * Initial Release.
+    * close ITP (Closes: #848971).
+
+ -- Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  Mon, 26 Dec 2016 13:22:50 +0200
+
 rdma-core (12-1) unstable; urgency=low
 
   * New version
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
