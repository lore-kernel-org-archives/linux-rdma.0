From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-3.11 7/7] IB/iser: Introduce fast memory registration model (FRWR)
Date: Sun, 28 Jul 2013 12:35:42 +0300
Message-ID: <1375004142-22559-8-git-send-email-ogerlitz@mellanox.com>
References: <1375004142-22559-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375004142-22559-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Newer HCAs and Virtual functions may not support FMRs but rather a fast
registration model, which we call FRWR - "Fast Registration Work Requests".

This model was introduced in 00f7ec36c "RDMA/core: Add memory management
extensions support" and works when the IB device supports the
IB_DEVICE_MEM_MGT_EXTENSIONS capability.

Upon creating the iser device iser will test whether the HCA supports FMRs.
If no support for FMRs, check if IB_DEVICE_MEM_MGT_EXTENSIONS is supported
and assign function pointers that handle fast registration and allocation
of appropriate resources (fast_reg descriptors).

Registration is done using posting IB_WR_FAST_REG_MR to the QP and
invalidations using posting IB_WR_LOCAL_INV.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |   21 ++++-
 drivers/infiniband/ulp/iser/iser_memory.c |  140 ++++++++++++++++++++++++++++-
 drivers/infiniband/ulp/iser/iser_verbs.c  |  138 ++++++++++++++++++++++++++--
 3 files changed, 287 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 75c5352..6791402 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -211,7 +211,7 @@ struct iser_mem_reg {
 	u64  va;
 	u64  len;
 	void *mem_h;
-	int  is_fmr;
+	int  is_mr;
 };
 
 struct iser_regd_buf {
@@ -277,6 +277,15 @@ struct iser_device {
 							    enum iser_data_dir cmd_dir);
 };
 
+struct fast_reg_descriptor {
+	struct list_head		  list;
+	/* For fast registration - FRWR */
+	struct ib_mr			 *data_mr;
+	struct ib_fast_reg_page_list     *data_frpl;
+	/* Valid for fast registration flag */
+	bool				  valid;
+};
+
 struct iser_conn {
 	struct iscsi_iser_conn       *iser_conn; /* iser conn for upcalls  */
 	struct iscsi_endpoint	     *ep;
@@ -307,6 +316,10 @@ struct iser_conn {
 			struct iser_page_vec	*page_vec; /* represents SG to fmr maps*
 							    * maps serialized as tx is*/
 		} fmr;
+		struct {
+			struct list_head	pool;
+			int			pool_size;
+		} frwr;
 	} fastreg;
 };
 
@@ -393,6 +406,8 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *task,
 
 int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
 			   enum iser_data_dir cmd_dir);
+int  iser_reg_rdma_mem_frwr(struct iscsi_iser_task *task,
+			    enum iser_data_dir cmd_dir);
 
 int  iser_connect(struct iser_conn   *ib_conn,
 		  struct sockaddr_in *src_addr,
@@ -405,6 +420,8 @@ int  iser_reg_page_vec(struct iser_conn     *ib_conn,
 
 void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 			enum iser_data_dir cmd_dir);
+void iser_unreg_mem_frwr(struct iscsi_iser_task *iser_task,
+			 enum iser_data_dir cmd_dir);
 
 int  iser_post_recvl(struct iser_conn *ib_conn);
 int  iser_post_recvm(struct iser_conn *ib_conn, int count);
@@ -421,4 +438,6 @@ int  iser_initialize_task_headers(struct iscsi_task *task,
 int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *session);
 int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
 void iser_free_fmr_pool(struct iser_conn *ib_conn);
+int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
+void iser_free_frwr_pool(struct iser_conn *ib_conn);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 1985e90..1ce0c97 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -395,8 +395,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	regd_buf = &iser_task->rdma_regd[cmd_dir];
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
-	if (aligned_len != mem->dma_nents ||
-	    (!ib_conn->fastreg.fmr.pool && mem->dma_nents > 1)) {
+	if (aligned_len != mem->dma_nents) {
 		err = fall_to_bounce_buf(iser_task, ibdev,
 					 cmd_dir, aligned_len);
 		if (err) {
@@ -414,7 +413,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 		regd_buf->reg.rkey = device->mr->rkey;
 		regd_buf->reg.len  = ib_sg_dma_len(ibdev, &sg[0]);
 		regd_buf->reg.va   = ib_sg_dma_address(ibdev, &sg[0]);
-		regd_buf->reg.is_fmr = 0;
+		regd_buf->reg.is_mr = 0;
 
 		iser_dbg("PHYSICAL Mem.register: lkey: 0x%08X rkey: 0x%08X  "
 			 "va: 0x%08lX sz: %ld]\n",
@@ -444,3 +443,138 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	}
 	return 0;
 }
+
+static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
+			    struct iser_conn *ib_conn,
+			    struct iser_regd_buf *regd_buf,
+			    u32 offset, unsigned int data_size,
+			    unsigned int page_list_len)
+{
+	struct ib_send_wr fastreg_wr, inv_wr;
+	struct ib_send_wr *bad_wr, *wr = NULL;
+	u8 key;
+	int ret;
+
+	if (!desc->valid) {
+		memset(&inv_wr, 0, sizeof(inv_wr));
+		inv_wr.opcode = IB_WR_LOCAL_INV;
+		inv_wr.send_flags = IB_SEND_SIGNALED;
+		inv_wr.ex.invalidate_rkey = desc->data_mr->rkey;
+		wr = &inv_wr;
+		/* Bump the key */
+		key = (u8)(desc->data_mr->rkey & 0x000000FF);
+		ib_update_fast_reg_key(desc->data_mr, ++key);
+	}
+
+	/* Prepare FASTREG WR */
+	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
+	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
+	fastreg_wr.send_flags = IB_SEND_SIGNALED;
+	fastreg_wr.wr.fast_reg.iova_start = desc->data_frpl->page_list[0] + offset;
+	fastreg_wr.wr.fast_reg.page_list = desc->data_frpl;
+	fastreg_wr.wr.fast_reg.page_list_len = page_list_len;
+	fastreg_wr.wr.fast_reg.page_shift = SHIFT_4K;
+	fastreg_wr.wr.fast_reg.length = data_size;
+	fastreg_wr.wr.fast_reg.rkey = desc->data_mr->rkey;
+	fastreg_wr.wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
+					       IB_ACCESS_REMOTE_WRITE |
+					       IB_ACCESS_REMOTE_READ);
+
+	if (!wr) {
+		wr = &fastreg_wr;
+		atomic_inc(&ib_conn->post_send_buf_count);
+	} else {
+		wr->next = &fastreg_wr;
+		atomic_add(2, &ib_conn->post_send_buf_count);
+	}
+
+	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
+	if (ret) {
+		if (bad_wr->next)
+			atomic_sub(2, &ib_conn->post_send_buf_count);
+		else
+			atomic_dec(&ib_conn->post_send_buf_count);
+		iser_err("fast registration failed, ret:%d\n", ret);
+		return ret;
+	}
+	desc->valid = false;
+
+	regd_buf->reg.mem_h = desc;
+	regd_buf->reg.lkey = desc->data_mr->lkey;
+	regd_buf->reg.rkey = desc->data_mr->rkey;
+	regd_buf->reg.va = desc->data_frpl->page_list[0] + offset;
+	regd_buf->reg.len = data_size;
+	regd_buf->reg.is_mr = 1;
+
+	return ret;
+}
+
+/**
+ * iser_reg_rdma_mem_frwr - Registers memory intended for RDMA,
+ * using Fast Registration WR (if possible) obtaining rkey and va
+ *
+ * returns 0 on success, errno code on failure
+ */
+int iser_reg_rdma_mem_frwr(struct iscsi_iser_task *iser_task,
+			   enum iser_data_dir cmd_dir)
+{
+	struct iser_conn *ib_conn = iser_task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
+	struct ib_device *ibdev = device->ib_device;
+	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
+	struct iser_regd_buf *regd_buf = &iser_task->rdma_regd[cmd_dir];
+	struct fast_reg_descriptor *desc;
+	unsigned int data_size, page_list_len;
+	int err, aligned_len;
+	unsigned long flags;
+	u32 offset;
+
+	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
+	if (aligned_len != mem->dma_nents) {
+		err = fall_to_bounce_buf(iser_task, ibdev,
+					 cmd_dir, aligned_len);
+		if (err) {
+			iser_err("failed to allocate bounce buffer\n");
+			return err;
+		}
+		mem = &iser_task->data_copy[cmd_dir];
+	}
+
+	/* if there a single dma entry, dma mr suffices */
+	if (mem->dma_nents == 1) {
+		struct scatterlist *sg = (struct scatterlist *)mem->buf;
+
+		regd_buf->reg.lkey = device->mr->lkey;
+		regd_buf->reg.rkey = device->mr->rkey;
+		regd_buf->reg.len  = ib_sg_dma_len(ibdev, &sg[0]);
+		regd_buf->reg.va   = ib_sg_dma_address(ibdev, &sg[0]);
+		regd_buf->reg.is_mr = 0;
+	} else {
+		spin_lock_irqsave(&ib_conn->lock, flags);
+		desc = list_first_entry(&ib_conn->fastreg.frwr.pool,
+					struct fast_reg_descriptor, list);
+		list_del(&desc->list);
+		spin_unlock_irqrestore(&ib_conn->lock, flags);
+		page_list_len = iser_sg_to_page_vec(mem, device->ib_device,
+						    desc->data_frpl->page_list,
+						    &offset, &data_size);
+
+		if (page_list_len * SIZE_4K < data_size) {
+			iser_err("fast reg page_list too short to hold this SG\n");
+			err = -EINVAL;
+			goto err_reg;
+		}
+
+		err = iser_fast_reg_mr(desc, ib_conn, regd_buf,
+				       offset, data_size, page_list_len);
+		if (err)
+			goto err_reg;
+	}
+
+	return 0;
+err_reg:
+	spin_lock_irqsave(&ib_conn->lock, flags);
+	list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
+	spin_unlock_irqrestore(&ib_conn->lock, flags);
+	return err;
+}
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index d9a47b9..d8cceae 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -73,12 +73,36 @@ static int iser_create_device_ib_res(struct iser_device *device)
 {
 	int i, j;
 	struct iser_cq_desc *cq_desc;
+	struct ib_device_attr *dev_attr;
 
-	/* Assign function handles */
-	device->iser_alloc_rdma_reg_res = iser_create_fmr_pool;
-	device->iser_free_rdma_reg_res = iser_free_fmr_pool;
-	device->iser_reg_rdma_mem = iser_reg_rdma_mem_fmr;
-	device->iser_unreg_rdma_mem = iser_unreg_mem_fmr;
+	dev_attr = kmalloc(sizeof(*dev_attr), GFP_KERNEL);
+	if (!dev_attr)
+		return -ENOMEM;
+
+	if (ib_query_device(device->ib_device, dev_attr)) {
+		pr_warn("Query device failed for %s\n", device->ib_device->name);
+		goto dev_attr_err;
+	}
+
+	/* Assign function handles  - based on FMR support */
+	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr &&
+	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr) {
+		iser_info("FMR supported, using FMR for registration\n");
+		device->iser_alloc_rdma_reg_res = iser_create_fmr_pool;
+		device->iser_free_rdma_reg_res = iser_free_fmr_pool;
+		device->iser_reg_rdma_mem = iser_reg_rdma_mem_fmr;
+		device->iser_unreg_rdma_mem = iser_unreg_mem_fmr;
+	} else
+	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
+		iser_info("FRWR supported, using FRWR for registration\n");
+		device->iser_alloc_rdma_reg_res = iser_create_frwr_pool;
+		device->iser_free_rdma_reg_res = iser_free_frwr_pool;
+		device->iser_reg_rdma_mem = iser_reg_rdma_mem_frwr;
+		device->iser_unreg_rdma_mem = iser_unreg_mem_frwr;
+	} else {
+		iser_err("IB device does not support FMRs nor FRWRs, can't register memory\n");
+		goto dev_attr_err;
+	}
 
 	device->cqs_used = min(ISER_MAX_CQ, device->ib_device->num_comp_vectors);
 	iser_info("using %d CQs, device %s supports %d vectors\n",
@@ -134,6 +158,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 	if (ib_register_event_handler(&device->event_handler))
 		goto handler_err;
 
+	kfree(dev_attr);
 	return 0;
 
 handler_err:
@@ -153,6 +178,8 @@ pd_err:
 	kfree(device->cq_desc);
 cq_desc_err:
 	iser_err("failed to allocate an IB resource\n");
+dev_attr_err:
+	kfree(dev_attr);
 	return -1;
 }
 
@@ -253,6 +280,80 @@ void iser_free_fmr_pool(struct iser_conn *ib_conn)
 }
 
 /**
+ * iser_create_frwr_pool - Creates pool of fast_reg descriptors
+ * for fast registration work requests.
+ * returns 0 on success, or errno code on failure
+ */
+int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
+{
+	struct iser_device	*device = ib_conn->device;
+	struct fast_reg_descriptor	*desc;
+	int i, ret;
+
+	INIT_LIST_HEAD(&ib_conn->fastreg.frwr.pool);
+	ib_conn->fastreg.frwr.pool_size = 0;
+	for (i = 0; i < cmds_max; i++) {
+		desc = kmalloc(sizeof(*desc), GFP_KERNEL);
+		if (!desc) {
+			iser_err("Failed to allocate a new fast_reg descriptor\n");
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		desc->data_frpl = ib_alloc_fast_reg_page_list(device->ib_device,
+							 ISCSI_ISER_SG_TABLESIZE + 1);
+		if (IS_ERR(desc->data_frpl)) {
+			ret = PTR_ERR(desc->data_frpl);
+			iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n", ret);
+			goto err;
+		}
+
+		desc->data_mr = ib_alloc_fast_reg_mr(device->pd,
+						     ISCSI_ISER_SG_TABLESIZE + 1);
+		if (IS_ERR(desc->data_mr)) {
+			ret = PTR_ERR(desc->data_mr);
+			iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
+			ib_free_fast_reg_page_list(desc->data_frpl);
+			goto err;
+		}
+		desc->valid = true;
+		list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
+		ib_conn->fastreg.frwr.pool_size++;
+	}
+
+	return 0;
+err:
+	iser_free_frwr_pool(ib_conn);
+	return ret;
+}
+
+/**
+ * iser_free_frwr_pool - releases the pool of fast_reg descriptors
+ */
+void iser_free_frwr_pool(struct iser_conn *ib_conn)
+{
+	struct fast_reg_descriptor *desc, *tmp;
+	int i = 0;
+
+	if (list_empty(&ib_conn->fastreg.frwr.pool))
+		return;
+
+	iser_info("freeing conn %p frwr pool\n", ib_conn);
+
+	list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.frwr.pool, list) {
+		list_del(&desc->list);
+		ib_free_fast_reg_page_list(desc->data_frpl);
+		ib_dereg_mr(desc->data_mr);
+		kfree(desc);
+		++i;
+	}
+
+	if (i < ib_conn->fastreg.frwr.pool_size)
+		iser_warn("pool still has %d regions registered\n",
+			  ib_conn->fastreg.frwr.pool_size - i);
+}
+
+/**
  * iser_create_ib_conn_res - Queue-Pair (QP)
  *
  * returns 0 on success, -1 on failure
@@ -707,7 +808,7 @@ int iser_reg_page_vec(struct iser_conn     *ib_conn,
 	mem_reg->rkey  = mem->fmr->rkey;
 	mem_reg->len   = page_vec->length * SIZE_4K;
 	mem_reg->va    = io_addr;
-	mem_reg->is_fmr = 1;
+	mem_reg->is_mr = 1;
 	mem_reg->mem_h = (void *)mem;
 
 	mem_reg->va   += page_vec->offset;
@@ -734,7 +835,7 @@ void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
 	int ret;
 
-	if (!reg->is_fmr)
+	if (!reg->is_mr)
 		return;
 
 	iser_dbg("PHYSICAL Mem.Unregister mem_h %p\n",reg->mem_h);
@@ -746,6 +847,23 @@ void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 	reg->mem_h = NULL;
 }
 
+void iser_unreg_mem_frwr(struct iscsi_iser_task *iser_task,
+			 enum iser_data_dir cmd_dir)
+{
+	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
+	struct iser_conn *ib_conn = iser_task->iser_conn->ib_conn;
+	struct fast_reg_descriptor *desc = reg->mem_h;
+
+	if (!reg->is_mr)
+		return;
+
+	reg->mem_h = NULL;
+	reg->is_mr = 0;
+	spin_lock_bh(&ib_conn->lock);
+	list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
+	spin_unlock_bh(&ib_conn->lock);
+}
+
 int iser_post_recvl(struct iser_conn *ib_conn)
 {
 	struct ib_recv_wr rx_wr, *rx_wr_failed;
@@ -867,7 +985,11 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_SEND)
 				iser_snd_completion(tx_desc, ib_conn);
-			else
+			else if (wc.opcode == IB_WC_LOCAL_INV ||
+				 wc.opcode == IB_WC_FAST_REG_MR) {
+				atomic_dec(&ib_conn->post_send_buf_count);
+				continue;
+			} else
 				iser_err("expected opcode %d got %d\n",
 					IB_WC_SEND, wc.opcode);
 		} else {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
