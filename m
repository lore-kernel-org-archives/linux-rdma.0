From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/iser: fix possible memory leak in iser_create_frwr_pool
Date: Mon, 19 Aug 2013 16:41:51 +0300
Message-ID: <1376919711-23732-1-git-send-email-roid@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

where desc is not being freed in error flows.

Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 28badac..afe9567 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -305,7 +305,7 @@ int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 		if (IS_ERR(desc->data_frpl)) {
 			ret = PTR_ERR(desc->data_frpl);
 			iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n", ret);
-			goto err;
+			goto fast_reg_page_failure;
 		}
 
 		desc->data_mr = ib_alloc_fast_reg_mr(device->pd,
@@ -313,8 +313,7 @@ int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 		if (IS_ERR(desc->data_mr)) {
 			ret = PTR_ERR(desc->data_mr);
 			iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
-			ib_free_fast_reg_page_list(desc->data_frpl);
-			goto err;
+			goto fast_reg_mr_failure;
 		}
 		desc->valid = true;
 		list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
@@ -322,6 +321,11 @@ int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 	}
 
 	return 0;
+
+fast_reg_mr_failure:
+	ib_free_fast_reg_page_list(desc->data_frpl);
+fast_reg_page_failure:
+	kfree(desc);
 err:
 	iser_free_frwr_pool(ib_conn);
 	return ret;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
