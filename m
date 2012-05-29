From: Devendra Naga <devendra.aaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Remove version.h includes
Date: Tue, 29 May 2012 12:51:47 +0530
Message-ID: <1338276107-22169-1-git-send-email-devendra.aaru@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devendra Naga <devendra.aaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

when ran with make versioncheck the ocrdma_verbs.h ocrdma_main.c includes
version.h which are not needed.

drivers/infiniband/hw/ocrdma/ocrdma_main.c: 29 linux/version.h not needed.
drivers/infiniband/hw/ocrdma/ocrdma_verbs.h: 31 linux/version.h not needed.

Signed-off-by: Devendra Naga <devendra.aaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index a20d16e..04fef3d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -26,7 +26,6 @@
  *******************************************************************/
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/idr.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index e648343..633f03d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -28,7 +28,6 @@
 #ifndef __OCRDMA_VERBS_H__
 #define __OCRDMA_VERBS_H__
 
-#include <linux/version.h>
 int ocrdma_post_send(struct ib_qp *, struct ib_send_wr *,
 		     struct ib_send_wr **bad_wr);
 int ocrdma_post_recv(struct ib_qp *, struct ib_recv_wr *,
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
