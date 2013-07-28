From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-3.11 4/7] IB/iser: Generalize rdma memory registration
Date: Sun, 28 Jul 2013 12:35:39 +0300
Message-ID: <1375004142-22559-5-git-send-email-ogerlitz@mellanox.com>
References: <1375004142-22559-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375004142-22559-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently the driver uses FMRs as the only means to register the memory
pointed by SG provided by the SCSI mid-layer with the RDMA device.

As perperation step for adding more methods for fast path memory
registrarion, make the alloc/free and reg/unreg calls be function
pointers which are now just set to the existing FMR ones.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   13 +++++++++-
 drivers/infiniband/ulp/iser/iser_initiator.c |   34 ++++++++++++-------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |   13 +++++++++-
 3 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index d2fc55a..78117be 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -252,6 +252,9 @@ struct iser_rx_desc {
 
 #define ISER_MAX_CQ 4
 
+struct iser_conn;
+struct iscsi_iser_task;
+
 struct iser_device {
 	struct ib_device             *ib_device;
 	struct ib_pd	             *pd;
@@ -265,6 +268,13 @@ struct iser_device {
 	int                          cq_active_qps[ISER_MAX_CQ];
 	int			     cqs_used;
 	struct iser_cq_desc	     *cq_desc;
+	int                          (*iser_alloc_rdma_reg_res)(struct iser_conn *ib_conn,
+								unsigned cmds_max);
+	void                         (*iser_free_rdma_reg_res)(struct iser_conn *ib_conn);
+	int                          (*iser_reg_rdma_mem)(struct iscsi_iser_task *iser_task,
+							  enum iser_data_dir cmd_dir);
+	void                         (*iser_unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
+							    enum iser_data_dir cmd_dir);
 };
 
 struct iser_conn {
@@ -389,7 +399,8 @@ int  iser_reg_page_vec(struct iser_conn     *ib_conn,
 		       struct iser_page_vec *page_vec,
 		       struct iser_mem_reg  *mem_reg);
 
-void iser_unreg_mem(struct iser_mem_reg *mem_reg);
+void iser_unreg_mem(struct iscsi_iser_task *iser_task,
+		    enum iser_data_dir cmd_dir);
 
 int  iser_post_recvl(struct iser_conn *ib_conn);
 int  iser_post_recvm(struct iser_conn *ib_conn, int count);
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 5c2b142..bdc38f4 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -49,6 +49,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task,
 
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
+	struct iser_device  *device = iser_task->iser_conn->ib_conn->device;
 	struct iser_regd_buf *regd_buf;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -69,7 +70,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task,
 		return -EINVAL;
 	}
 
-	err = iser_reg_rdma_mem(iser_task,ISER_DIR_IN);
+	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_IN);
 	if (err) {
 		iser_err("Failed to set up Data-IN RDMA\n");
 		return err;
@@ -98,6 +99,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 		       unsigned int edtl)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
+	struct iser_device  *device = iser_task->iser_conn->ib_conn->device;
 	struct iser_regd_buf *regd_buf;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -119,7 +121,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 		return -EINVAL;
 	}
 
-	err = iser_reg_rdma_mem(iser_task,ISER_DIR_OUT);
+	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_OUT);
 	if (err != 0) {
 		iser_err("Failed to register write cmd RDMA mem\n");
 		return err;
@@ -253,8 +255,8 @@ int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *s
 	ib_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
 	ib_conn->min_posted_rx = ib_conn->qp_max_recv_dtos >> 2;
 
-	if (iser_create_fmr_pool(ib_conn, session->scsi_cmds_max))
-		goto create_fmr_pool_failed;
+	if (device->iser_alloc_rdma_reg_res(ib_conn, session->scsi_cmds_max))
+		goto create_rdma_reg_res_failed;
 
 	if (iser_alloc_login_buf(ib_conn))
 		goto alloc_login_buf_fail;
@@ -293,8 +295,8 @@ rx_desc_dma_map_failed:
 rx_desc_alloc_fail:
 	iser_free_login_buf(ib_conn);
 alloc_login_buf_fail:
-	iser_free_fmr_pool(ib_conn);
-create_fmr_pool_failed:
+	device->iser_free_rdma_reg_res(ib_conn);
+create_rdma_reg_res_failed:
 	iser_err("failed allocating rx descriptors / data buffers\n");
 	return -ENOMEM;
 }
@@ -308,6 +310,9 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 	if (!ib_conn->rx_descs)
 		goto free_login_buf;
 
+	if (device && device->iser_free_rdma_reg_res)
+		device->iser_free_rdma_reg_res(ib_conn);
+
 	rx_desc = ib_conn->rx_descs;
 	for (i = 0; i < ib_conn->qp_max_recv_dtos; i++, rx_desc++)
 		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
@@ -318,7 +323,6 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 
 free_login_buf:
 	iser_free_login_buf(ib_conn);
-	iser_free_fmr_pool(ib_conn);
 }
 
 static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
@@ -629,8 +633,8 @@ void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 
 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
+	struct iser_device *device = iser_task->iser_conn->ib_conn->device;
 	int is_rdma_aligned = 1;
-	struct iser_regd_buf *regd;
 
 	/* if we were reading, copy back to unaligned sglist,
 	 * anyway dma_unmap and free the copy
@@ -644,17 +648,11 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 		iser_finalize_rdma_unaligned_sg(iser_task, ISER_DIR_OUT);
 	}
 
-	if (iser_task->dir[ISER_DIR_IN]) {
-		regd = &iser_task->rdma_regd[ISER_DIR_IN];
-		if (regd->reg.is_fmr)
-			iser_unreg_mem(&regd->reg);
-	}
+	if (iser_task->dir[ISER_DIR_IN])
+		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
 
-	if (iser_task->dir[ISER_DIR_OUT]) {
-		regd = &iser_task->rdma_regd[ISER_DIR_OUT];
-		if (regd->reg.is_fmr)
-			iser_unreg_mem(&regd->reg);
-	}
+	if (iser_task->dir[ISER_DIR_OUT])
+		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
 
        /* if the data was unaligned, it was already unmapped and then copied */
        if (is_rdma_aligned)
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5e49a36..5b53428 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -74,6 +74,12 @@ static int iser_create_device_ib_res(struct iser_device *device)
 	int i, j;
 	struct iser_cq_desc *cq_desc;
 
+	/* Assign function handles */
+	device->iser_alloc_rdma_reg_res = iser_create_fmr_pool;
+	device->iser_free_rdma_reg_res = iser_free_fmr_pool;
+	device->iser_reg_rdma_mem = iser_reg_rdma_mem;
+	device->iser_unreg_rdma_mem = iser_unreg_mem;
+
 	device->cqs_used = min(ISER_MAX_CQ, device->ib_device->num_comp_vectors);
 	iser_info("using %d CQs, device %s supports %d vectors\n",
 		  device->cqs_used, device->ib_device->name,
@@ -721,10 +727,15 @@ int iser_reg_page_vec(struct iser_conn     *ib_conn,
 /**
  * Unregister (previosuly registered) memory.
  */
-void iser_unreg_mem(struct iser_mem_reg *reg)
+void iser_unreg_mem(struct iscsi_iser_task *iser_task,
+		    enum iser_data_dir cmd_dir)
 {
+	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
 	int ret;
 
+	if (!reg->is_fmr)
+		return;
+
 	iser_dbg("PHYSICAL Mem.Unregister mem_h %p\n",reg->mem_h);
 
 	ret = ib_fmr_pool_unmap((struct ib_pool_fmr *)reg->mem_h);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
