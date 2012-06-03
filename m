From: Sachin Kamat <sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] ocrdma: Remove version.h header file inclusion
Date: Sun,  3 Jun 2012 22:35:05 +0530
Message-ID: <1338743105-11304-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

version.h header file is no longer required.

Signed-off-by: Sachin Kamat <sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

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
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
