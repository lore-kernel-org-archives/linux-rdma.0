From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 12/22] IB/iser: Introduce iser_reg_ops
Date: Thu, 30 Jul 2015 11:06:25 +0300
Message-ID: <1438243595-32288-13-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move all the per-device function pointers to an easy
extensible iser_reg_ops structure that contains all
the iser registration operations.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     | 39 ++++++++++++++++++----------
 drivers/infiniband/ulp/iser/iser_initiator.c | 16 ++++++------
 drivers/infiniband/ulp/iser/iser_memory.c    | 35 +++++++++++++++++++++++++
 drivers/infiniband/ulp/iser/iser_verbs.c     | 30 +++++----------------
 4 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 70bf6e7..9ce090c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -326,6 +326,25 @@ struct iser_comp {
 };
 
 /**
+ * struct iser_device - Memory registration operations
+ *     per-device registration schemes
+ *
+ * @alloc_reg_res:     Allocate registration resources
+ * @free_reg_res:      Free registration resources
+ * @reg_rdma_mem:      Register memory buffers
+ * @unreg_rdma_mem:    Un-register memory buffers
+ */
+struct iser_reg_ops {
+	int            (*alloc_reg_res)(struct ib_conn *ib_conn,
+					unsigned cmds_max);
+	void           (*free_reg_res)(struct ib_conn *ib_conn);
+	int            (*reg_rdma_mem)(struct iscsi_iser_task *iser_task,
+				       enum iser_data_dir cmd_dir);
+	void           (*unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
+					 enum iser_data_dir cmd_dir);
+};
+
+/**
  * struct iser_device - iSER device handle
  *
  * @ib_device:     RDMA device
@@ -338,11 +357,7 @@ struct iser_comp {
  * @comps_used:    Number of completion contexts used, Min between online
  *                 cpus and device max completion vectors
  * @comps:         Dinamically allocated array of completion handlers
- * Memory registration pool Function pointers (FMR or Fastreg):
- *     @iser_alloc_rdma_reg_res: Allocation of memory regions pool
- *     @iser_free_rdma_reg_res:  Free of memory regions pool
- *     @iser_reg_rdma_mem:       Memory registration routine
- *     @iser_unreg_rdma_mem:     Memory deregistration routine
+ * @reg_ops:       Registration ops
  */
 struct iser_device {
 	struct ib_device             *ib_device;
@@ -354,13 +369,7 @@ struct iser_device {
 	int                          refcount;
 	int			     comps_used;
 	struct iser_comp	     *comps;
-	int                          (*iser_alloc_rdma_reg_res)(struct ib_conn *ib_conn,
-								unsigned cmds_max);
-	void                         (*iser_free_rdma_reg_res)(struct ib_conn *ib_conn);
-	int                          (*iser_reg_rdma_mem)(struct iscsi_iser_task *iser_task,
-							  enum iser_data_dir cmd_dir);
-	void                         (*iser_unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
-							    enum iser_data_dir cmd_dir);
+	struct iser_reg_ops          *reg_ops;
 };
 
 #define ISER_CHECK_GUARD	0xc0
@@ -563,6 +572,8 @@ extern int iser_debug_level;
 extern bool iser_pi_enable;
 extern int iser_pi_guard;
 
+int iser_assign_reg_ops(struct iser_device *device);
+
 int iser_send_control(struct iscsi_conn *conn,
 		      struct iscsi_task *task);
 
@@ -636,9 +647,9 @@ int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
 int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 			      struct iscsi_session *session);
-int iser_create_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max);
+int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max);
 void iser_free_fmr_pool(struct ib_conn *ib_conn);
-int iser_create_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max);
+int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max);
 void iser_free_fastreg_pool(struct ib_conn *ib_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 42d6f42..88d8a89 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -73,7 +73,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 			return err;
 	}
 
-	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_IN);
+	err = device->reg_ops->reg_rdma_mem(iser_task, ISER_DIR_IN);
 	if (err) {
 		iser_err("Failed to set up Data-IN RDMA\n");
 		return err;
@@ -128,7 +128,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 			return err;
 	}
 
-	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_OUT);
+	err = device->reg_ops->reg_rdma_mem(iser_task, ISER_DIR_OUT);
 	if (err != 0) {
 		iser_err("Failed to register write cmd RDMA mem\n");
 		return err;
@@ -260,7 +260,7 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 	iser_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
 	iser_conn->min_posted_rx = iser_conn->qp_max_recv_dtos >> 2;
 
-	if (device->iser_alloc_rdma_reg_res(ib_conn, session->scsi_cmds_max))
+	if (device->reg_ops->alloc_reg_res(ib_conn, session->scsi_cmds_max))
 		goto create_rdma_reg_res_failed;
 
 	if (iser_alloc_login_buf(iser_conn))
@@ -301,7 +301,7 @@ rx_desc_dma_map_failed:
 rx_desc_alloc_fail:
 	iser_free_login_buf(iser_conn);
 alloc_login_buf_fail:
-	device->iser_free_rdma_reg_res(ib_conn);
+	device->reg_ops->free_reg_res(ib_conn);
 create_rdma_reg_res_failed:
 	iser_err("failed allocating rx descriptors / data buffers\n");
 	return -ENOMEM;
@@ -314,8 +314,8 @@ void iser_free_rx_descriptors(struct iser_conn *iser_conn)
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
 
-	if (device->iser_free_rdma_reg_res)
-		device->iser_free_rdma_reg_res(ib_conn);
+	if (device->reg_ops->free_reg_res)
+		device->reg_ops->free_reg_res(ib_conn);
 
 	rx_desc = iser_conn->rx_descs;
 	for (i = 0; i < iser_conn->qp_max_recv_dtos; i++, rx_desc++)
@@ -699,7 +699,7 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	}
 
 	if (iser_task->dir[ISER_DIR_IN]) {
-		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
+		device->reg_ops->unreg_rdma_mem(iser_task, ISER_DIR_IN);
 		if (is_rdma_data_aligned)
 			iser_dma_unmap_task_data(iser_task,
 						 &iser_task->data[ISER_DIR_IN],
@@ -711,7 +711,7 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	}
 
 	if (iser_task->dir[ISER_DIR_OUT]) {
-		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
+		device->reg_ops->unreg_rdma_mem(iser_task, ISER_DIR_OUT);
 		if (is_rdma_data_aligned)
 			iser_dma_unmap_task_data(iser_task,
 						 &iser_task->data[ISER_DIR_OUT],
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 4209d73..ff3ec53 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -39,6 +39,41 @@
 
 #include "iscsi_iser.h"
 
+static struct iser_reg_ops fastreg_ops = {
+	.alloc_reg_res	= iser_alloc_fastreg_pool,
+	.free_reg_res	= iser_free_fastreg_pool,
+	.reg_rdma_mem	= iser_reg_rdma_mem_fastreg,
+	.unreg_rdma_mem	= iser_unreg_mem_fastreg,
+};
+
+static struct iser_reg_ops fmr_ops = {
+	.alloc_reg_res	= iser_alloc_fmr_pool,
+	.free_reg_res	= iser_free_fmr_pool,
+	.reg_rdma_mem	= iser_reg_rdma_mem_fmr,
+	.unreg_rdma_mem	= iser_unreg_mem_fmr,
+};
+
+int iser_assign_reg_ops(struct iser_device *device)
+{
+	struct ib_device_attr *dev_attr = &device->dev_attr;
+
+	/* Assign function handles  - based on FMR support */
+	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr &&
+	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr) {
+		iser_info("FMR supported, using FMR for registration\n");
+		device->reg_ops = &fmr_ops;
+	} else
+	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
+		iser_info("FastReg supported, using FastReg for registration\n");
+		device->reg_ops = &fastreg_ops;
+	} else {
+		iser_err("IB device does not support FMRs nor FastRegs, can't register memory\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 static void
 iser_free_bounce_sg(struct iser_data_buf *data)
 {
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 2a0cb42..ca0aba3 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -87,25 +87,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		return ret;
 	}
 
-	/* Assign function handles  - based on FMR support */
-	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr &&
-	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr) {
-		iser_info("FMR supported, using FMR for registration\n");
-		device->iser_alloc_rdma_reg_res = iser_create_fmr_pool;
-		device->iser_free_rdma_reg_res = iser_free_fmr_pool;
-		device->iser_reg_rdma_mem = iser_reg_rdma_mem_fmr;
-		device->iser_unreg_rdma_mem = iser_unreg_mem_fmr;
-	} else
-	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
-		iser_info("FastReg supported, using FastReg for registration\n");
-		device->iser_alloc_rdma_reg_res = iser_create_fastreg_pool;
-		device->iser_free_rdma_reg_res = iser_free_fastreg_pool;
-		device->iser_reg_rdma_mem = iser_reg_rdma_mem_fastreg;
-		device->iser_unreg_rdma_mem = iser_unreg_mem_fastreg;
-	} else {
-		iser_err("IB device does not support FMRs nor FastRegs, can't register memory\n");
-		return -1;
-	}
+	ret = iser_assign_reg_ops(device);
+	if (ret)
+		return ret;
 
 	device->comps_used = min_t(int, num_online_cpus(),
 				 device->ib_device->num_comp_vectors);
@@ -211,11 +195,11 @@ static void iser_free_device_ib_res(struct iser_device *device)
 }
 
 /**
- * iser_create_fmr_pool - Creates FMR pool and page_vector
+ * iser_alloc_fmr_pool - Creates FMR pool and page_vector
  *
  * returns 0 on success, or errno code on failure
  */
-int iser_create_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
+int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 {
 	struct iser_device *device = ib_conn->device;
 	struct ib_fmr_pool_param params;
@@ -384,11 +368,11 @@ pi_ctx_alloc_failure:
 }
 
 /**
- * iser_create_fastreg_pool - Creates pool of fast_reg descriptors
+ * iser_alloc_fastreg_pool - Creates pool of fast_reg descriptors
  * for fast registration work requests.
  * returns 0 on success, or errno code on failure
  */
-int iser_create_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
+int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 {
 	struct iser_device *device = ib_conn->device;
 	struct iser_fr_desc *desc;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
