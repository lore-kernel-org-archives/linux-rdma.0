From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 11/18] IB/iser: Move fastreg descriptor pool get/put to helper functions
Date: Sun, 29 Mar 2015 15:45:25 +0300
Message-ID: <1427633132-23910-12-git-send-email-sagig@mellanox.com>
References: <1427633132-23910-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633132-23910-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of open-coding connection fastreg pool get/put,
we introduce iser_reg_desc[get|put] helpers.

We aren't setting these static as this will be a per-device
routine later on. Also, cleanup iser_unreg_rdma_mem_fastreg
a bit.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    5 +++
 drivers/infiniband/ulp/iser/iser_memory.c |   50 ++++++++++++++++++----------
 2 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 198f928..43e4912 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -644,4 +644,9 @@ int iser_create_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max);
 void iser_free_fastreg_pool(struct ib_conn *ib_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
+struct fast_reg_descriptor *
+iser_reg_desc_get(struct ib_conn *ib_conn);
+void
+iser_reg_desc_put(struct ib_conn *ib_conn,
+		  struct fast_reg_descriptor *desc);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 6e6b753..17a5d70 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -41,6 +41,32 @@
 
 #define ISER_KMALLOC_THRESHOLD 0x20000 /* 128K - kmalloc limit */
 
+struct fast_reg_descriptor *
+iser_reg_desc_get(struct ib_conn *ib_conn)
+{
+	struct fast_reg_descriptor *desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ib_conn->lock, flags);
+	desc = list_first_entry(&ib_conn->fastreg.pool,
+				struct fast_reg_descriptor, list);
+	list_del(&desc->list);
+	spin_unlock_irqrestore(&ib_conn->lock, flags);
+
+	return desc;
+}
+
+void
+iser_reg_desc_put(struct ib_conn *ib_conn,
+		  struct fast_reg_descriptor *desc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ib_conn->lock, flags);
+	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
+	spin_unlock_irqrestore(&ib_conn->lock, flags);
+}
+
 /**
  * iser_start_rdma_unaligned_sg
  */
@@ -409,17 +435,13 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 			    enum iser_data_dir cmd_dir)
 {
 	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
-	struct iser_conn *iser_conn = iser_task->iser_conn;
-	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-	struct fast_reg_descriptor *desc = reg->mem_h;
 
-	if (!desc)
+	if (!reg->mem_h)
 		return;
 
+	iser_reg_desc_put(&iser_task->iser_conn->ib_conn,
+			  reg->mem_h);
 	reg->mem_h = NULL;
-	spin_lock_bh(&ib_conn->lock);
-	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-	spin_unlock_bh(&ib_conn->lock);
 }
 
 /**
@@ -725,7 +747,6 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	struct fast_reg_descriptor *desc = NULL;
 	struct ib_sge data_sge;
 	int err, aligned_len;
-	unsigned long flags;
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
@@ -739,11 +760,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	if (mem->dma_nents != 1 ||
 	    scsi_get_prot_op(iser_task->sc) != SCSI_PROT_NORMAL) {
-		spin_lock_irqsave(&ib_conn->lock, flags);
-		desc = list_first_entry(&ib_conn->fastreg.pool,
-					struct fast_reg_descriptor, list);
-		list_del(&desc->list);
-		spin_unlock_irqrestore(&ib_conn->lock, flags);
+		desc = iser_reg_desc_get(ib_conn);
 		mem_reg->mem_h = desc;
 	}
 
@@ -799,11 +816,8 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	return 0;
 err_reg:
-	if (desc) {
-		spin_lock_irqsave(&ib_conn->lock, flags);
-		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-		spin_unlock_irqrestore(&ib_conn->lock, flags);
-	}
+	if (desc)
+		iser_reg_desc_put(ib_conn, desc);
 
 	return err;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
