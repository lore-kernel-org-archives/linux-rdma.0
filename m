From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] debian: Adding uploaders field
Date: Wed, 1 Mar 2017 14:23:49 +0200
Message-ID: <20170301122349.22634-1-talatb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Issue: None
Change-Id: I4d5c5ab493974d7be537d83f3a8efa5cdb160679
Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/control | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/debian/control b/debian/control
index 4033dd8..55f7f50 100644
--- a/debian/control
+++ b/debian/control
@@ -1,5 +1,9 @@
 Source: rdma-core
 Maintainer: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
+Uploaders:
+ Benjamin Drung <bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>,
+ Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
+ Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 Section: net
 Priority: extra
 Build-Depends: cmake (>= 2.8.11),
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
