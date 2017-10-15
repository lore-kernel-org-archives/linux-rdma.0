From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] RDMA: Remove Sean's and Hal's emails from MAINTAINER file
Date: Sun, 15 Oct 2017 09:56:48 +0300
Message-ID: <20171015065648.14653-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RDMA subsystem has one active maintainer who can apply
patches - Doug Ledford, but the RDMA entries in MAINTAINER file
are not stating it. The following patch removes Sean's and Hal's
emails from the maintainers list.

It will allow clean get_maintaner.pl output which is needed for people
outside of our community and various semi-automatic tools.

Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dafc9c3bbcfa..f1688510178a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6775,8 +6775,6 @@ F:	drivers/ipack/

 INFINIBAND SUBSYSTEM
 M:	Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
-M:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
-M:	Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.openfabrics.org/
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
