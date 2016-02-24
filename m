From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 06/12] iser-target: Remove impossible condition from isert_wait_conn
Date: Wed, 24 Feb 2016 19:24:03 +0200
Message-ID: <1456334649-21437-7-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We can never get to isert_wait_conn in INIT state anymore, so
get rid of this condition.

Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 01d37260a8d8..21f4f44de3ac 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3362,14 +3362,6 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 	isert_info("Starting conn %p\n", isert_conn);
 
 	mutex_lock(&isert_conn->mutex);
-	/*
-	 * Only wait for wait_comp_err if the isert_conn made it
-	 * into full feature phase..
-	 */
-	if (isert_conn->state == ISER_CONN_INIT) {
-		mutex_unlock(&isert_conn->mutex);
-		return;
-	}
 	isert_conn_terminate(isert_conn);
 	mutex_unlock(&isert_conn->mutex);
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
