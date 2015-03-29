From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 14/18] iser-target: Get rid of redundant max_accept
Date: Sun, 29 Mar 2015 15:52:16 +0300
Message-ID: <1427633540-30352-15-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Not sure what it was used for, but there is
no real need for it now as I see it. Go ahead
and get rid of it.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4fddc08..97cee96 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3209,11 +3209,11 @@ isert_accept_np(struct iscsi_np *np, struct iscsi_conn *conn)
 {
 	struct isert_np *isert_np = np->np_context;
 	struct isert_conn *isert_conn;
-	int max_accept = 0, ret;
+	int ret;
 
 accept_wait:
 	ret = down_interruptible(&isert_np->np_sem);
-	if (ret || max_accept > 5)
+	if (ret)
 		return -ENODEV;
 
 	spin_lock_bh(&np->np_thread_lock);
@@ -3232,7 +3232,6 @@ accept_wait:
 	mutex_lock(&isert_np->np_accept_mutex);
 	if (list_empty(&isert_np->np_accept_list)) {
 		mutex_unlock(&isert_np->np_accept_mutex);
-		max_accept++;
 		goto accept_wait;
 	}
 	isert_conn = list_first_entry(&isert_np->np_accept_list,
@@ -3242,7 +3241,6 @@ accept_wait:
 
 	conn->context = isert_conn;
 	isert_conn->conn = conn;
-	max_accept = 0;
 
 	isert_set_conn_info(np, conn, isert_conn);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
