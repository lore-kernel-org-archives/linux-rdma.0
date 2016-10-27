From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 05/10] IB/isert: Replace semaphore sem with completion
Date: Thu, 27 Oct 2016 12:29:09 +0530
Message-ID: <1477551554-30349-6-git-send-email-binoy.jayan@linaro.org>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477551554-30349-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'sem' in isert_device is used as completion, so convert
it to struct completion. Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 +++---
 drivers/infiniband/ulp/isert/ib_isert.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6dd43f6..de80f56 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -619,7 +619,7 @@
 	mutex_unlock(&isert_np->mutex);
 
 	isert_info("np %p: Allow accept_np to continue\n", isert_np);
-	up(&isert_np->sem);
+	complete(&isert_np->comp);
 }
 
 static void
@@ -2311,7 +2311,7 @@ struct rdma_cm_id *
 		isert_err("Unable to allocate struct isert_np\n");
 		return -ENOMEM;
 	}
-	sema_init(&isert_np->sem, 0);
+	init_completion(&isert_np->comp);
 	mutex_init(&isert_np->mutex);
 	INIT_LIST_HEAD(&isert_np->accepted);
 	INIT_LIST_HEAD(&isert_np->pending);
@@ -2427,7 +2427,7 @@ struct rdma_cm_id *
 	int ret;
 
 accept_wait:
-	ret = down_interruptible(&isert_np->sem);
+	ret = wait_for_completion_interruptible(&isert_np->comp);
 	if (ret)
 		return -ENODEV;
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index c02ada5..a1277c0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -3,6 +3,7 @@
 #include <linux/in6.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
+#include <linux/completion.h>
 #include <rdma/rw.h>
 #include <scsi/iser.h>
 
@@ -190,7 +191,7 @@ struct isert_device {
 
 struct isert_np {
 	struct iscsi_np         *np;
-	struct semaphore	sem;
+	struct completion	comp;
 	struct rdma_cm_id	*cm_id;
 	struct mutex		mutex;
 	struct list_head	accepted;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
