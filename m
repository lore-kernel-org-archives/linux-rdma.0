From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 11/22] IB/iser: Remove dead code in fmr_pool alloc/free
Date: Thu, 30 Jul 2015 11:06:24 +0300
Message-ID: <1438243595-32288-12-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the past the we always tried to allocate an fmr_pool
and if it failed on ENOSYS (not supported) then we continued
with dma mr. This is not the case anymore and if we tried to
allocate an fmr_pool then it is supported and we expect to succeed.

Also, the check if fmr_pool is allocated when free is called is
redundant as well as we are guaranteed it exists.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index f7828e3..2a0cb42 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -244,22 +244,18 @@ int iser_create_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 				    IB_ACCESS_REMOTE_READ);
 
 	ib_conn->fmr.pool = ib_create_fmr_pool(device->pd, &params);
-	if (!IS_ERR(ib_conn->fmr.pool))
-		return 0;
+	if (IS_ERR(ib_conn->fmr.pool)) {
+		ret = PTR_ERR(ib_conn->fmr.pool);
+		iser_err("FMR allocation failed, err %d\n", ret);
+		goto err;
+	}
+
+	return 0;
 
-	/* no FMR => no need for page_vec */
+err:
 	kfree(ib_conn->fmr.page_vec);
 	ib_conn->fmr.page_vec = NULL;
-
-	ret = PTR_ERR(ib_conn->fmr.pool);
-	ib_conn->fmr.pool = NULL;
-	if (ret != -ENOSYS) {
-		iser_err("FMR allocation failed, err %d\n", ret);
-		return ret;
-	} else {
-		iser_warn("FMRs are not supported, using unaligned mode\n");
-		return 0;
-	}
+	return ret;
 }
 
 /**
@@ -270,9 +266,7 @@ void iser_free_fmr_pool(struct ib_conn *ib_conn)
 	iser_info("freeing conn %p fmr pool %p\n",
 		  ib_conn, ib_conn->fmr.pool);
 
-	if (ib_conn->fmr.pool != NULL)
-		ib_destroy_fmr_pool(ib_conn->fmr.pool);
-
+	ib_destroy_fmr_pool(ib_conn->fmr.pool);
 	ib_conn->fmr.pool = NULL;
 
 	kfree(ib_conn->fmr.page_vec);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
