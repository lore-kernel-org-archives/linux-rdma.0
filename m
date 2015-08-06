From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 17/22] IB/iser: Make reg_desc_get a per device routine
Date: Thu,  6 Aug 2015 18:33:01 +0300
Message-ID: <1438875186-4310-18-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

As for fmrs we will hold a single registration descriptor
as no need for multiple like in the frwr mode (descriptor
for each task). This change helps unifying the duplicate
registration code paths.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  | 16 ++++++++++---
 drivers/infiniband/ulp/iser/iser_memory.c | 38 +++++++++++++++++++++++--------
 2 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index a8c8177..611abaa 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -333,6 +333,8 @@ struct iser_comp {
  * @free_reg_res:      Free registration resources
  * @reg_rdma_mem:      Register memory buffers
  * @unreg_rdma_mem:    Un-register memory buffers
+ * @reg_desc_get:      Get a registration descriptor for pool
+ * @reg_desc_put:      Get a registration descriptor to pool
  */
 struct iser_reg_ops {
 	int            (*alloc_reg_res)(struct ib_conn *ib_conn,
@@ -342,6 +344,9 @@ struct iser_reg_ops {
 				       enum iser_data_dir cmd_dir);
 	void           (*unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
 					 enum iser_data_dir cmd_dir);
+	struct iser_fr_desc * (*reg_desc_get)(struct ib_conn *ib_conn);
+	void           (*reg_desc_put)(struct ib_conn *ib_conn,
+				       struct iser_fr_desc *desc);
 };
 
 /**
@@ -657,8 +662,13 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
 struct iser_fr_desc *
-iser_reg_desc_get(struct ib_conn *ib_conn);
+iser_reg_desc_get_fr(struct ib_conn *ib_conn);
 void
-iser_reg_desc_put(struct ib_conn *ib_conn,
-		  struct iser_fr_desc *desc);
+iser_reg_desc_put_fr(struct ib_conn *ib_conn,
+		     struct iser_fr_desc *desc);
+struct iser_fr_desc *
+iser_reg_desc_get_fmr(struct ib_conn *ib_conn);
+void
+iser_reg_desc_put_fmr(struct ib_conn *ib_conn,
+		      struct iser_fr_desc *desc);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 11bba5a..4e687ee 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -44,6 +44,8 @@ static struct iser_reg_ops fastreg_ops = {
 	.free_reg_res	= iser_free_fastreg_pool,
 	.reg_rdma_mem	= iser_reg_rdma_mem_fastreg,
 	.unreg_rdma_mem	= iser_unreg_mem_fastreg,
+	.reg_desc_get	= iser_reg_desc_get_fr,
+	.reg_desc_put	= iser_reg_desc_put_fr,
 };
 
 static struct iser_reg_ops fmr_ops = {
@@ -51,6 +53,8 @@ static struct iser_reg_ops fmr_ops = {
 	.free_reg_res	= iser_free_fmr_pool,
 	.reg_rdma_mem	= iser_reg_rdma_mem_fmr,
 	.unreg_rdma_mem	= iser_unreg_mem_fmr,
+	.reg_desc_get	= iser_reg_desc_get_fmr,
+	.reg_desc_put	= iser_reg_desc_put_fmr,
 };
 
 int iser_assign_reg_ops(struct iser_device *device)
@@ -182,7 +186,7 @@ iser_copy_to_bounce(struct iser_data_buf *data)
 }
 
 struct iser_fr_desc *
-iser_reg_desc_get(struct ib_conn *ib_conn)
+iser_reg_desc_get_fr(struct ib_conn *ib_conn)
 {
 	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_fr_desc *desc;
@@ -198,8 +202,8 @@ iser_reg_desc_get(struct ib_conn *ib_conn)
 }
 
 void
-iser_reg_desc_put(struct ib_conn *ib_conn,
-		  struct iser_fr_desc *desc)
+iser_reg_desc_put_fr(struct ib_conn *ib_conn,
+		     struct iser_fr_desc *desc)
 {
 	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	unsigned long flags;
@@ -209,6 +213,21 @@ iser_reg_desc_put(struct ib_conn *ib_conn,
 	spin_unlock_irqrestore(&fr_pool->lock, flags);
 }
 
+struct iser_fr_desc *
+iser_reg_desc_get_fmr(struct ib_conn *ib_conn)
+{
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
+
+	return list_first_entry(&fr_pool->list,
+				struct iser_fr_desc, list);
+}
+
+void
+iser_reg_desc_put_fmr(struct ib_conn *ib_conn,
+		      struct iser_fr_desc *desc)
+{
+}
+
 /**
  * iser_start_rdma_unaligned_sg
  */
@@ -544,13 +563,14 @@ void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 			    enum iser_data_dir cmd_dir)
 {
+	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
 
 	if (!reg->mem_h)
 		return;
 
-	iser_reg_desc_put(&iser_task->iser_conn->ib_conn,
-			  reg->mem_h);
+	device->reg_ops->reg_desc_put(&iser_task->iser_conn->ib_conn,
+				     reg->mem_h);
 	reg->mem_h = NULL;
 }
 
@@ -564,7 +584,6 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			  enum iser_data_dir cmd_dir)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_device   *device = ib_conn->device;
 	struct ib_device     *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
@@ -590,8 +609,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	} else { /* use FMR for multiple dma entries */
 		struct iser_fr_desc *desc;
 
-		desc = list_first_entry(&fr_pool->list,
-					struct iser_fr_desc, list);
+		desc = device->reg_ops->reg_desc_get(ib_conn);
 		err = iser_fast_reg_fmr(iser_task, mem, &desc->rsc, mem_reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
@@ -844,7 +862,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	if (mem->dma_nents != 1 ||
 	    scsi_get_prot_op(iser_task->sc) != SCSI_PROT_NORMAL) {
-		desc = iser_reg_desc_get(ib_conn);
+		desc = device->reg_ops->reg_desc_get(ib_conn);
 		mem_reg->mem_h = desc;
 	}
 
@@ -887,7 +905,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	return 0;
 err_reg:
 	if (desc)
-		iser_reg_desc_put(ib_conn, desc);
+		device->reg_ops->reg_desc_put(ib_conn, desc);
 
 	return err;
 }
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
