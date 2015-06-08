From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 03/11] IB/iser: Rename struct fast_reg_descriptor -> iser_fr_desc
Date: Mon,  8 Jun 2015 16:15:15 +0300
Message-ID: <1433769323-790-4-git-send-email-sagig@mellanox.com>
References: <1433769323-790-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769323-790-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid struct names without iser_ prefix.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    8 ++++----
 drivers/infiniband/ulp/iser/iser_memory.c |   10 +++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c  |   10 +++++-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index b9564d7..8abbfda 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -394,13 +394,13 @@ struct iser_pi_context {
 };
 
 /**
- * struct fast_reg_descriptor - Fast registration descriptor
+ * struct iser_fr_desc - Fast registration descriptor
  *
  * @list:           entry in connection fastreg pool
  * @rsc:            data buffer registration resources
  * @pi_ctx:         protection information context
  */
-struct fast_reg_descriptor {
+struct iser_fr_desc {
 	struct list_head		  list;
 	struct iser_reg_resources	  rsc;
 	struct iser_pi_context		 *pi_ctx;
@@ -640,9 +640,9 @@ int iser_create_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max);
 void iser_free_fastreg_pool(struct ib_conn *ib_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
-struct fast_reg_descriptor *
+struct iser_fr_desc *
 iser_reg_desc_get(struct ib_conn *ib_conn);
 void
 iser_reg_desc_put(struct ib_conn *ib_conn,
-		  struct fast_reg_descriptor *desc);
+		  struct iser_fr_desc *desc);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 82a3304..710ac7d 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -146,15 +146,15 @@ iser_copy_to_bounce(struct iser_data_buf *data)
 	iser_copy_bounce(data, true);
 }
 
-struct fast_reg_descriptor *
+struct iser_fr_desc *
 iser_reg_desc_get(struct ib_conn *ib_conn)
 {
-	struct fast_reg_descriptor *desc;
+	struct iser_fr_desc *desc;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ib_conn->lock, flags);
 	desc = list_first_entry(&ib_conn->fastreg.pool,
-				struct fast_reg_descriptor, list);
+				struct iser_fr_desc, list);
 	list_del(&desc->list);
 	spin_unlock_irqrestore(&ib_conn->lock, flags);
 
@@ -163,7 +163,7 @@ iser_reg_desc_get(struct ib_conn *ib_conn)
 
 void
 iser_reg_desc_put(struct ib_conn *ib_conn,
-		  struct fast_reg_descriptor *desc)
+		  struct iser_fr_desc *desc)
 {
 	unsigned long flags;
 
@@ -787,7 +787,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	struct ib_device *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_mem_reg *mem_reg = &iser_task->rdma_reg[cmd_dir];
-	struct fast_reg_descriptor *desc = NULL;
+	struct iser_fr_desc *desc = NULL;
 	int err, aligned_len;
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 58cf809..e001346 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -316,7 +316,7 @@ iser_free_reg_res(struct iser_reg_resources *rsc)
 
 static int
 iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
-		  struct fast_reg_descriptor *desc)
+		  struct iser_fr_desc *desc)
 {
 	struct iser_pi_context *pi_ctx = NULL;
 	struct ib_mr_init_attr mr_init_attr = {.max_reg_descriptors = 2,
@@ -363,7 +363,7 @@ iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 
 static int
 iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
-			 bool pi_enable, struct fast_reg_descriptor *desc)
+			 bool pi_enable, struct iser_fr_desc *desc)
 {
 	int ret;
 
@@ -395,7 +395,7 @@ pi_ctx_alloc_failure:
 int iser_create_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 {
 	struct iser_device *device = ib_conn->device;
-	struct fast_reg_descriptor *desc;
+	struct iser_fr_desc *desc;
 	int i, ret;
 
 	INIT_LIST_HEAD(&ib_conn->fastreg.pool);
@@ -433,7 +433,7 @@ err:
  */
 void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 {
-	struct fast_reg_descriptor *desc, *tmp;
+	struct iser_fr_desc *desc, *tmp;
 	int i = 0;
 
 	if (list_empty(&ib_conn->fastreg.pool))
@@ -1250,7 +1250,7 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector)
 {
 	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
-	struct fast_reg_descriptor *desc = reg->mem_h;
+	struct iser_fr_desc *desc = reg->mem_h;
 	unsigned long sector_size = iser_task->sc->device->sector_size;
 	struct ib_mr_status mr_status;
 	int ret;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
