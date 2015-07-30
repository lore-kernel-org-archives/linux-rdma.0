From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/22] IB/iser: Change minor assignments and logging prints
Date: Thu, 30 Jul 2015 11:06:15 +0300
Message-ID: <1438243595-32288-3-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index c7cea25..7420062 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -847,10 +847,9 @@ failure:
 static int
 iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 {
-	struct iser_conn *iser_conn;
+	struct iser_conn *iser_conn = ep->dd_data;
 	int rc;
 
-	iser_conn = ep->dd_data;
 	rc = wait_for_completion_interruptible_timeout(&iser_conn->up_completion,
 						       msecs_to_jiffies(timeout_ms));
 	/* if conn establishment failed, return error code to iscsi */
@@ -862,7 +861,7 @@ iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 		mutex_unlock(&iser_conn->state_mutex);
 	}
 
-	iser_info("ib conn %p rc = %d\n", iser_conn, rc);
+	iser_info("iser conn %p rc = %d\n", iser_conn, rc);
 
 	if (rc > 0)
 		return 1; /* success, this is the equivalent of POLLOUT */
@@ -884,11 +883,9 @@ iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 static void
 iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 {
-	struct iser_conn *iser_conn;
+	struct iser_conn *iser_conn = ep->dd_data;
 
-	iser_conn = ep->dd_data;
-	iser_info("ep %p iser conn %p state %d\n",
-		  ep, iser_conn, iser_conn->state);
+	iser_info("ep %p iser conn %p\n", ep, iser_conn);
 
 	mutex_lock(&iser_conn->state_mutex);
 	iser_conn_terminate(iser_conn);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
