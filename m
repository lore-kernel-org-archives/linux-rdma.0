From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc v1 2/4] IB/iser: Add module parameter for always register memory
Date: Mon, 21 Sep 2015 19:41:12 +0300
Message-ID: <1442853674-8677-3-git-send-email-sagig@mellanox.com>
References: <1442853674-8677-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442853674-8677-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This module parameter forces memory registration even for
a continuous memory region. It is true by default as sending
an all-physical rkey with remote permissions might be insecure.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c  |  5 +++++
 drivers/infiniband/ulp/iser/iscsi_iser.h  |  1 +
 drivers/infiniband/ulp/iser/iser_memory.c | 18 ++++++++++++------
 drivers/infiniband/ulp/iser/iser_verbs.c  | 21 +++++++++++++--------
 4 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1ace5d83a4d7..f58ff96b6cbb 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -97,6 +97,11 @@ unsigned int iser_max_sectors = ISER_DEF_MAX_SECTORS;
 module_param_named(max_sectors, iser_max_sectors, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_sectors, "Max number of sectors in a single scsi command (default:1024");
 
+bool iser_always_reg = true;
+module_param_named(always_register, iser_always_reg, bool, S_IRUGO);
+MODULE_PARM_DESC(always_register,
+		 "Always register memory, even for continuous memory regions (default:true)");
+
 bool iser_pi_enable = false;
 module_param_named(pi_enable, iser_pi_enable, bool, S_IRUGO);
 MODULE_PARM_DESC(pi_enable, "Enable T10-PI offload support (default:disabled)");
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 86f6583485ef..a5edd6ede692 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -611,6 +611,7 @@ extern int iser_debug_level;
 extern bool iser_pi_enable;
 extern int iser_pi_guard;
 extern unsigned int iser_max_sectors;
+extern bool iser_always_reg;
 
 int iser_assign_reg_ops(struct iser_device *device);
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 2493cc748db8..4c46d67d37a1 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -803,11 +803,12 @@ static int
 iser_reg_prot_sg(struct iscsi_iser_task *task,
 		 struct iser_data_buf *mem,
 		 struct iser_fr_desc *desc,
+		 bool use_dma_key,
 		 struct iser_mem_reg *reg)
 {
 	struct iser_device *device = task->iser_conn->ib_conn.device;
 
-	if (mem->dma_nents == 1)
+	if (use_dma_key)
 		return iser_reg_dma(device, mem, reg);
 
 	return device->reg_ops->reg_mem(task, mem, &desc->pi_ctx->rsc, reg);
@@ -817,11 +818,12 @@ static int
 iser_reg_data_sg(struct iscsi_iser_task *task,
 		 struct iser_data_buf *mem,
 		 struct iser_fr_desc *desc,
+		 bool use_dma_key,
 		 struct iser_mem_reg *reg)
 {
 	struct iser_device *device = task->iser_conn->ib_conn.device;
 
-	if (mem->dma_nents == 1)
+	if (use_dma_key)
 		return iser_reg_dma(device, mem, reg);
 
 	return device->reg_ops->reg_mem(task, mem, &desc->rsc, reg);
@@ -836,14 +838,17 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 	struct iser_mem_reg *reg = &task->rdma_reg[dir];
 	struct iser_mem_reg *data_reg;
 	struct iser_fr_desc *desc = NULL;
+	bool use_dma_key;
 	int err;
 
 	err = iser_handle_unaligned_buf(task, mem, dir);
 	if (unlikely(err))
 		return err;
 
-	if (mem->dma_nents != 1 ||
-	    scsi_get_prot_op(task->sc) != SCSI_PROT_NORMAL) {
+	use_dma_key = (mem->dma_nents == 1 && !iser_always_reg &&
+		       scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL);
+
+	if (!use_dma_key) {
 		desc = device->reg_ops->reg_desc_get(ib_conn);
 		reg->mem_h = desc;
 	}
@@ -853,7 +858,7 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 	else
 		data_reg = &task->desc.data_reg;
 
-	err = iser_reg_data_sg(task, mem, desc, data_reg);
+	err = iser_reg_data_sg(task, mem, desc, use_dma_key, data_reg);
 	if (unlikely(err))
 		goto err_reg;
 
@@ -866,7 +871,8 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 			if (unlikely(err))
 				goto err_reg;
 
-			err = iser_reg_prot_sg(task, mem, desc, prot_reg);
+			err = iser_reg_prot_sg(task, mem, desc,
+					       use_dma_key, prot_reg);
 			if (unlikely(err))
 				goto err_reg;
 		}
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ae70cc1463ac..85132d867bc8 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -133,11 +133,15 @@ static int iser_create_device_ib_res(struct iser_device *device)
 			     (unsigned long)comp);
 	}
 
-	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
-				   IB_ACCESS_REMOTE_WRITE |
-				   IB_ACCESS_REMOTE_READ);
-	if (IS_ERR(device->mr))
-		goto dma_mr_err;
+	if (!iser_always_reg) {
+		int access = IB_ACCESS_LOCAL_WRITE |
+			     IB_ACCESS_REMOTE_WRITE |
+			     IB_ACCESS_REMOTE_READ;
+
+		device->mr = ib_get_dma_mr(device->pd, access);
+		if (IS_ERR(device->mr))
+			goto dma_mr_err;
+	}
 
 	INIT_IB_EVENT_HANDLER(&device->event_handler, device->ib_device,
 				iser_event_handler);
@@ -147,7 +151,8 @@ static int iser_create_device_ib_res(struct iser_device *device)
 	return 0;
 
 handler_err:
-	ib_dereg_mr(device->mr);
+	if (device->mr)
+		ib_dereg_mr(device->mr);
 dma_mr_err:
 	for (i = 0; i < device->comps_used; i++)
 		tasklet_kill(&device->comps[i].tasklet);
@@ -173,7 +178,6 @@ comps_err:
 static void iser_free_device_ib_res(struct iser_device *device)
 {
 	int i;
-	BUG_ON(device->mr == NULL);
 
 	for (i = 0; i < device->comps_used; i++) {
 		struct iser_comp *comp = &device->comps[i];
@@ -184,7 +188,8 @@ static void iser_free_device_ib_res(struct iser_device *device)
 	}
 
 	(void)ib_unregister_event_handler(&device->event_handler);
-	(void)ib_dereg_mr(device->mr);
+	if (device->mr)
+		(void)ib_dereg_mr(device->mr);
 	ib_dealloc_pd(device->pd);
 
 	kfree(device->comps);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
