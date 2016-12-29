From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 1/4] debian/control: Remove build-essential from Build-Depends
Date: Thu, 29 Dec 2016 15:49:05 +0200
Message-ID: <20161229134908.13185-2-leon@kernel.org>
References: <20161229134908.13185-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161229134908.13185-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix lintian error [1] build-depends-on-build-essential build-depends.
The package build is done with "debuild -uc -us -d" comamnd.

[1]
E: rdma-core source: build-depends-on-build-essential build-depends

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/control | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/debian/control b/debian/control
index 3b04ac9..9e73c2b 100644
--- a/debian/control
+++ b/debian/control
@@ -2,8 +2,7 @@ Source: rdma-core
 Maintainer: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
 Section: net
 Priority: extra
-Build-Depends: build-essential,
-	       cmake (>= 2.8.11),
+Build-Depends: cmake (>= 2.8.11),
 	       debhelper (>= 9),
 	       dh-systemd,
 	       dpkg-dev (>= 1.17),
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
