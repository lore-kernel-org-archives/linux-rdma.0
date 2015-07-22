From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 20/43] IB/core: Drop ib_alloc_fast_reg_mr
Date: Wed, 22 Jul 2015 09:55:20 +0300
Message-ID: <1437548143-24893-21-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fully replaced by a more generic and suitable
ib_alloc_mr

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 21 ---------------------
 include/rdma/ib_verbs.h         | 11 -----------
 2 files changed, 32 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 23d73bd..beed431 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1265,27 +1265,6 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
 }
 EXPORT_SYMBOL(ib_alloc_mr);
 
-struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
-{
-	struct ib_mr *mr;
-
-	if (!pd->device->alloc_fast_reg_mr)
-		return ERR_PTR(-ENOSYS);
-
-	mr = pd->device->alloc_fast_reg_mr(pd, max_page_list_len);
-
-	if (!IS_ERR(mr)) {
-		mr->device  = pd->device;
-		mr->pd      = pd;
-		mr->uobject = NULL;
-		atomic_inc(&pd->usecnt);
-		atomic_set(&mr->usecnt, 0);
-	}
-
-	return mr;
-}
-EXPORT_SYMBOL(ib_alloc_fast_reg_mr);
-
 struct ib_fast_reg_page_list *ib_alloc_fast_reg_page_list(struct ib_device *device,
 							  int max_page_list_len)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ec9a70..7a93e2d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1661,8 +1661,6 @@ struct ib_device {
 					       enum ib_mr_type mr_type,
 					       u32 max_entries,
 					       u32 flags);
-	struct ib_mr *		   (*alloc_fast_reg_mr)(struct ib_pd *pd,
-					       int max_page_list_len);
 	struct ib_fast_reg_page_list * (*alloc_fast_reg_page_list)(struct ib_device *device,
 								   int page_list_len);
 	void			   (*free_fast_reg_page_list)(struct ib_fast_reg_page_list *page_list);
@@ -2803,15 +2801,6 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
 			  u32 flags);
 
 /**
- * ib_alloc_fast_reg_mr - Allocates memory region usable with the
- *   IB_WR_FAST_REG_MR send work request.
- * @pd: The protection domain associated with the region.
- * @max_page_list_len: requested max physical buffer list length to be
- *   used with fast register work requests for this MR.
- */
-struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len);
-
-/**
  * ib_alloc_fast_reg_page_list - Allocates a page list array
  * @device - ib device pointer.
  * @page_list_len - size of the page list array to be allocated.
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
