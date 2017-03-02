From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 rdam-core] debian: Adding uploaders field
Date: Thu, 2 Mar 2017 09:50:10 +0200
Message-ID: <20170302075010.12003-1-talatb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/control | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/debian/control b/debian/control
index 4033dd8..bc54d74 100644
--- a/debian/control
+++ b/debian/control
@@ -1,5 +1,8 @@
 Source: rdma-core
 Maintainer: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
+Uploaders:
+ Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>,
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
