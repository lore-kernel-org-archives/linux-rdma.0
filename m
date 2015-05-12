From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] MAINTAINERS: update the official rdma git repo
Date: Mon, 11 May 2015 21:13:56 -0400
Message-ID: <2936ae04aa5d7ebfd9921e363a8e8686f8bb5936.1431393236.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Linus prefers kernel.org repos to github repos for security.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 40c14f14204d..c1911a7adb4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5048,7 +5048,7 @@ M:	Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.openfabrics.org/
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-T:	git git://github.com/dledford/linux.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
 S:	Supported
 F:	Documentation/infiniband/
 F:	drivers/infiniband/
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
