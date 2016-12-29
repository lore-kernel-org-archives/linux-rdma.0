From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 2/4] debian/iwpmd.install: Remove ibacm from iwpmd install
Date: Thu, 29 Dec 2016 15:49:06 +0200
Message-ID: <20161229134908.13185-3-leon@kernel.org>
References: <20161229134908.13185-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161229134908.13185-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In debian/iwpmd.install file, there was reference to etc/init.d/ibacm.

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/iwpmd.install | 1 -
 1 file changed, 1 deletion(-)

diff --git a/debian/iwpmd.install b/debian/iwpmd.install
index c80b1c9..bff17f1 100644
--- a/debian/iwpmd.install
+++ b/debian/iwpmd.install
@@ -1,4 +1,3 @@
-etc/init.d/ibacm
 etc/init.d/iwpmd
 etc/iwpmd.conf
 lib/systemd/system/iwpmd.service
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
