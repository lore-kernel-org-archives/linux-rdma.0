From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 03/22] IB/iser: Remove '.' from log message
Date: Thu,  6 Aug 2015 18:32:47 +0300
Message-ID: <1438875186-4310-4-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 7420062..859d9d9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -905,6 +905,7 @@ iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 		mutex_unlock(&iser_conn->state_mutex);
 		iser_conn_release(iser_conn);
 	}
+
 	iscsi_destroy_endpoint(ep);
 }
 
@@ -1079,7 +1080,7 @@ static void __exit iser_exit(void)
 
 	if (!connlist_empty) {
 		iser_err("Error cleanup stage completed but we still have iser "
-			 "connections, destroying them anyway.\n");
+			 "connections, destroying them anyway\n");
 		list_for_each_entry_safe(iser_conn, n, &ig.connlist,
 					 conn_list) {
 			iser_conn_release(iser_conn);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
