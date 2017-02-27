From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH] RDMA/iser: Fix possible mr leak on device removal event
Date: Mon, 27 Feb 2017 20:16:33 +0200
Message-ID: <1488219394-11720-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the rdma device is removed, we must cleanup all
the rdma resources within the DEVICE_REMOVAL event
handler to let the device teardown gracefully. When
this happens with live I/O, some memory regions are
occupied. Thus, track them too and dereg all the mr's.

We are safe with mr access by iscsi_iser_cleanup_task.

Reported-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h | 2 ++
 drivers/infiniband/ulp/iser/iser_verbs.c | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 9d0b22ad58c1..c1ae4aeae2f9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -430,6 +430,7 @@ struct iser_fr_desc {
 	struct list_head		  list;
 	struct iser_reg_resources	  rsc;
 	struct iser_pi_context		 *pi_ctx;
+	struct list_head                  all_list;
 };
 
 /**
@@ -443,6 +444,7 @@ struct iser_fr_pool {
 	struct list_head        list;
 	spinlock_t              lock;
 	int                     size;
+	struct list_head        all_list;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 30b622f2ab73..c538a38c91ce 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -362,6 +362,7 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn,
 	int i, ret;
 
 	INIT_LIST_HEAD(&fr_pool->list);
+	INIT_LIST_HEAD(&fr_pool->all_list);
 	spin_lock_init(&fr_pool->lock);
 	fr_pool->size = 0;
 	for (i = 0; i < cmds_max; i++) {
@@ -373,6 +374,7 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn,
 		}
 
 		list_add_tail(&desc->list, &fr_pool->list);
+		list_add_tail(&desc->all_list, &fr_pool->all_list);
 		fr_pool->size++;
 	}
 
@@ -392,13 +394,13 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 	struct iser_fr_desc *desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&fr_pool->list))
+	if (list_empty(&fr_pool->all_list))
 		return;
 
 	iser_info("freeing conn %p fr pool\n", ib_conn);
 
-	list_for_each_entry_safe(desc, tmp, &fr_pool->list, list) {
-		list_del(&desc->list);
+	list_for_each_entry_safe(desc, tmp, &fr_pool->all_list, all_list) {
+		list_del(&desc->all_list);
 		iser_free_reg_res(&desc->rsc);
 		if (desc->pi_ctx)
 			iser_free_pi_ctx(desc->pi_ctx);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
