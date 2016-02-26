From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6] iwpm: crash fix for large connections test
Date: Fri, 26 Feb 2016 09:18:05 -0600
Message-ID: <1456499885-8044-7-git-send-email-faisal.latif@intel.com>
References: <1456499885-8044-1-git-send-email-faisal.latif@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456499885-8044-1-git-send-email-faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During large connection test, there is a crash at wake_up() in the callback as waitq is
not yet initialized. Callback can happen before iwpm_wait_complete_req() is called to
initialize waitq.
To resolve, using signaling semaphore instead of waitq.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Tatyana E Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/iwpm_msg.c  | 10 +++++-----
 drivers/infiniband/core/iwpm_util.c | 14 +++++++-------
 drivers/infiniband/core/iwpm_util.h |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index c2b4ce6..43e3fa2 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -89,7 +89,7 @@ int iwpm_register_pid(struct iwpm_dev_data *pm_msg, u8 nl_client)
 	if (ret)
 		goto pid_query_error;
 	ret = ibnl_put_attr(skb, nlh, IFNAMSIZ,
-				pm_msg->if_name, IWPM_NLA_REG_IF_NAME);
+			    pm_msg->if_name, IWPM_NLA_REG_IF_NAME);
 	if (ret)
 		goto pid_query_error;
 	ret = ibnl_put_attr(skb, nlh, IWPM_DEVNAME_SIZE,
@@ -394,7 +394,7 @@ register_pid_response_exit:
 	/* always for found nlmsg_request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	wake_up(&nlmsg_request->waitq);
+	up(&nlmsg_request->sem);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_register_pid_cb);
@@ -463,7 +463,7 @@ add_mapping_response_exit:
 	/* always for found request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	wake_up(&nlmsg_request->waitq);
+	up(&nlmsg_request->sem);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_add_mapping_cb);
@@ -555,7 +555,7 @@ query_mapping_response_exit:
 	/* always for found request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	wake_up(&nlmsg_request->waitq);
+	up(&nlmsg_request->sem);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_add_and_query_mapping_cb);
@@ -749,7 +749,7 @@ int iwpm_mapping_error_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	/* always for found request */
 	kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	barrier();
-	wake_up(&nlmsg_request->waitq);
+	up(&nlmsg_request->sem);
 	return 0;
 }
 EXPORT_SYMBOL(iwpm_mapping_error_cb);
diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 5fb089e..9b2bf2f 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -254,9 +254,9 @@ void iwpm_add_remote_info(struct iwpm_remote_info *rem_info)
 }
 
 int iwpm_get_remote_info(struct sockaddr_storage *mapped_loc_addr,
-				struct sockaddr_storage *mapped_rem_addr,
-				struct sockaddr_storage *remote_addr,
-				u8 nl_client)
+			 struct sockaddr_storage *mapped_rem_addr,
+			 struct sockaddr_storage *remote_addr,
+			 u8 nl_client)
 {
 	struct hlist_node *tmp_hlist_node;
 	struct hlist_head *hash_bucket_head;
@@ -322,6 +322,8 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
 	nlmsg_request->nl_client = nl_client;
 	nlmsg_request->request_done = 0;
 	nlmsg_request->err_code = 0;
+	sema_init(&nlmsg_request->sem, 1);
+	down(&nlmsg_request->sem);
 	return nlmsg_request;
 }
 
@@ -364,11 +366,9 @@ struct iwpm_nlmsg_request *iwpm_find_nlmsg_request(__u32 echo_seq)
 int iwpm_wait_complete_req(struct iwpm_nlmsg_request *nlmsg_request)
 {
 	int ret;
-	init_waitqueue_head(&nlmsg_request->waitq);
 
-	ret = wait_event_timeout(nlmsg_request->waitq,
-			(nlmsg_request->request_done != 0), IWPM_NL_TIMEOUT);
-	if (!ret) {
+	ret = down_timeout(&nlmsg_request->sem, IWPM_NL_TIMEOUT);
+	if (ret) {
 		ret = -EINVAL;
 		pr_info("%s: Timeout %d sec for netlink request (seq = %u)\n",
 			__func__, (IWPM_NL_TIMEOUT/HZ), nlmsg_request->nlmsg_seq);
diff --git a/drivers/infiniband/core/iwpm_util.h b/drivers/infiniband/core/iwpm_util.h
index b7b9e19..af1fc14 100644
--- a/drivers/infiniband/core/iwpm_util.h
+++ b/drivers/infiniband/core/iwpm_util.h
@@ -69,7 +69,7 @@ struct iwpm_nlmsg_request {
 	u8	            nl_client;
 	u8                  request_done;
 	u16                 err_code;
-	wait_queue_head_t   waitq;
+	struct semaphore    sem;
 	struct kref         kref;
 };
 
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
