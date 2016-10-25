From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/8] IB/core: iwpm_nlmsg_request: Replace semaphore with completion
Date: Tue, 25 Oct 2016 17:31:52 +0530
Message-ID: <1477396919-27669-2-git-send-email-binoy.jayan@linaro.org>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477396919-27669-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Semaphore sem in iwpm_nlmsg_request is used as completion, so
convert it to a struct completion type. Semaphores are going
away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/iwpm_msg.c  | 8 ++++----
 drivers/infiniband/core/iwpm_util.c | 7 +++----
 drivers/infiniband/core/iwpm_util.h | 3 ++-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 1c41b95..761358f 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -394,7 +394,7 @@ int iwpm_register_pid_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	/* always for found nlmsg_request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	up(&nlmsg_request->sem);
+	complete(&nlmsg_request->comp);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_register_pid_cb);
@@ -463,7 +463,7 @@ int iwpm_add_mapping_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	/* always for found request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	up(&nlmsg_request->sem);
+	complete(&nlmsg_request->comp);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_add_mapping_cb);
@@ -555,7 +555,7 @@ int iwpm_add_and_query_mapping_cb(struct sk_buff *skb,
 	/* always for found request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	up(&nlmsg_request->sem);
+	complete(&nlmsg_request->comp);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_add_and_query_mapping_cb);
@@ -749,7 +749,7 @@ int iwpm_mapping_error_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	/* always for found request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	up(&nlmsg_request->sem);
+	complete(&nlmsg_request->comp);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_mapping_error_cb);
diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index ade71e7..08ddd2e 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -323,8 +323,7 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
 	nlmsg_request->nl_client = nl_client;
 	nlmsg_request->request_done = 0;
 	nlmsg_request->err_code = 0;
-	sema_init(&nlmsg_request->sem, 1);
-	down(&nlmsg_request->sem);
+	init_completion(&nlmsg_request->comp);
 	return nlmsg_request;
 }
 
@@ -368,8 +367,8 @@ int iwpm_wait_complete_req(struct iwpm_nlmsg_request *nlmsg_request)
 {
 	int ret;
 
-	ret = down_timeout(&nlmsg_request->sem, IWPM_NL_TIMEOUT);
-	if (ret) {
+	ret = wait_for_completion_timeout(&nlmsg_request->comp, IWPM_NL_TIMEOUT);
+	if (!ret) {
 		ret = -EINVAL;
 		pr_info("%s: Timeout %d sec for netlink request (seq = %u)\n",
 			__func__, (IWPM_NL_TIMEOUT/HZ), nlmsg_request->nlmsg_seq);
diff --git a/drivers/infiniband/core/iwpm_util.h b/drivers/infiniband/core/iwpm_util.h
index af1fc14..ea6c299 100644
--- a/drivers/infiniband/core/iwpm_util.h
+++ b/drivers/infiniband/core/iwpm_util.h
@@ -43,6 +43,7 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/completion.h>
 #include <linux/jhash.h>
 #include <linux/kref.h>
 #include <net/netlink.h>
@@ -69,7 +70,7 @@ struct iwpm_nlmsg_request {
 	u8	            nl_client;
 	u8                  request_done;
 	u16                 err_code;
-	struct semaphore    sem;
+	struct completion   comp;
 	struct kref         kref;
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
