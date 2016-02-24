From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/12] iser-target: Remove redundant wait in release_conn
Date: Wed, 24 Feb 2016 19:24:02 +0200
Message-ID: <1456334649-21437-6-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

With current termination flow we call release_conn after completion.

Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 7 -------
 drivers/infiniband/ulp/isert/ib_isert.h | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 0e1a802c3618..01d37260a8d8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -583,7 +583,6 @@ isert_init_conn(struct isert_conn *isert_conn)
 	INIT_LIST_HEAD(&isert_conn->node);
 	init_completion(&isert_conn->login_comp);
 	init_completion(&isert_conn->login_req_comp);
-	init_completion(&isert_conn->wait);
 	kref_init(&isert_conn->kref);
 	mutex_init(&isert_conn->mutex);
 	spin_lock_init(&isert_conn->pool_lock);
@@ -834,7 +833,6 @@ isert_handle_unbound_conn(struct isert_conn *isert_conn)
 		 */
 		list_del_init(&isert_conn->node);
 		isert_put_conn(isert_conn);
-		complete(&isert_conn->wait);
 		queue_work(isert_release_wq, &isert_conn->release_work);
 	}
 	mutex_unlock(&isert_np->mutex);
@@ -867,9 +865,6 @@ isert_conn_terminate(struct isert_conn *isert_conn)
 	if (err)
 		isert_warn("Failed rdma_disconnect isert_conn %p\n",
 			   isert_conn);
-
-	isert_info("conn %p completing wait\n", isert_conn);
-	complete(&isert_conn->wait);
 }
 
 static int
@@ -3274,8 +3269,6 @@ static void isert_release_work(struct work_struct *work)
 
 	isert_info("Starting release conn %p\n", isert_conn);
 
-	wait_for_completion(&isert_conn->wait);
-
 	mutex_lock(&isert_conn->mutex);
 	isert_conn->state = ISER_CONN_DOWN;
 	mutex_unlock(&isert_conn->mutex);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 1aa019ab9d78..9f916b12cf40 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -201,7 +201,6 @@ struct isert_conn {
 	struct ib_qp		*qp;
 	struct isert_device	*device;
 	struct mutex		mutex;
-	struct completion	wait;
 	struct completion	wait_comp_err;
 	struct kref		kref;
 	struct list_head	fr_pool;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
