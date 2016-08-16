From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] MAINTAINERS: Fix Soft RoCE location
Date: Tue, 16 Aug 2016 12:29:46 +0300
Message-ID: <1471339786-4618-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Soft RoCE (rxe) is located in drivers/inifiniband/sw
and not in drivers/infiniband/hw/.

This patch fixes it.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a306795..119edf4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7655,7 +7655,7 @@ L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Supported
 W:	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-F:	drivers/infiniband/hw/rxe/
+F:	drivers/infiniband/sw/rxe/
 F:	include/uapi/rdma/rdma_user_rxe.h
 
 MEMBARRIER SUPPORT
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
