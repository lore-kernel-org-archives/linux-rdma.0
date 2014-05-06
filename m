From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 9/9] IB/srp: Add fast registration support
Date: Tue, 06 May 2014 14:56:41 +0200
Message-ID: <5368DC09.70608@acm.org>
References: <5368DA5B.80609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368DA5B.80609-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Certain HCA types (e.g. Connect-IB) and certain configurations (e.g.
ConnectX VF) support FR but not FMR. Hence add FR support.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 442 ++++++++++++++++++++++++++++++------
 drivers/infiniband/ulp/srp/ib_srp.h |  82 ++++++-
 2 files changed, 451 insertions(+), 73 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 017de46..fbda2ca 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -66,6 +66,8 @@ static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
+static bool prefer_fr;
+static bool register_always;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -87,6 +89,14 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
+module_param(prefer_fr, bool, 0444);
+MODULE_PARM_DESC(prefer_fr,
+		 "Whether to use FR if both FMR and FR are supported");
+
+module_param(register_always, bool, 0444);
+MODULE_PARM_DESC(register_always,
+		 "Use memory registration even for contiguous memory regions");
+
 static struct kernel_param_ops srp_tmo_ops;
 
 static int srp_reconnect_delay = 10;
@@ -288,12 +298,154 @@ static int srp_new_cm_id(struct srp_target_port *target)
 	return 0;
 }
 
+/**
+ * srp_destroy_fr_pool() - free the resources owned by a pool
+ * @pool: Fast registration pool to be destroyed.
+ */
+static void srp_destroy_fr_pool(struct srp_fr_pool *pool)
+{
+	int i;
+	struct srp_fr_desc *d;
+
+	if (!pool)
+		return;
+
+	for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
+		if (d->frpl)
+			ib_free_fast_reg_page_list(d->frpl);
+		if (d->mr)
+			ib_dereg_mr(d->mr);
+	}
+	kfree(pool);
+}
+
+/**
+ * srp_create_fr_pool() - allocate and initialize a pool for fast registration
+ * @device:            IB device to allocate fast registration descriptors for.
+ * @pd:                Protection domain associated with the FR descriptors.
+ * @pool_size:         Number of descriptors to allocate.
+ * @max_page_list_len: Maximum fast registration work request page list length.
+ */
+static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
+					      struct ib_pd *pd, int pool_size,
+					      int max_page_list_len)
+{
+	struct srp_fr_pool *pool;
+	struct srp_fr_desc *d;
+	struct ib_mr *mr;
+	struct ib_fast_reg_page_list *frpl;
+	int i, ret = -EINVAL;
+
+	if (pool_size <= 0)
+		goto err;
+	ret = -ENOMEM;
+	pool = kzalloc(sizeof(struct srp_fr_pool) +
+		       pool_size * sizeof(struct srp_fr_desc), GFP_KERNEL);
+	if (!pool)
+		goto err;
+	pool->size = pool_size;
+	pool->max_page_list_len = max_page_list_len;
+	spin_lock_init(&pool->lock);
+	INIT_LIST_HEAD(&pool->free_list);
+
+	for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
+		mr = ib_alloc_fast_reg_mr(pd, max_page_list_len);
+		if (IS_ERR(mr)) {
+			ret = PTR_ERR(mr);
+			goto destroy_pool;
+		}
+		d->mr = mr;
+		frpl = ib_alloc_fast_reg_page_list(device, max_page_list_len);
+		if (IS_ERR(frpl)) {
+			ret = PTR_ERR(frpl);
+			goto destroy_pool;
+		}
+		d->frpl = frpl;
+		list_add_tail(&d->entry, &pool->free_list);
+	}
+
+out:
+	return pool;
+
+destroy_pool:
+	srp_destroy_fr_pool(pool);
+
+err:
+	pool = ERR_PTR(ret);
+	goto out;
+}
+
+/**
+ * srp_fr_pool_get() - obtain a descriptor suitable for fast registration
+ * @pool: Pool to obtain descriptor from.
+ */
+static struct srp_fr_desc *srp_fr_pool_get(struct srp_fr_pool *pool)
+{
+	struct srp_fr_desc *d = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	if (!list_empty(&pool->free_list)) {
+		d = list_first_entry(&pool->free_list, typeof(*d), entry);
+		list_del(&d->entry);
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	return d;
+}
+
+/**
+ * srp_fr_pool_put() - put an FR descriptor back in the free list
+ * @pool: Pool the descriptor was allocated from.
+ * @desc: Pointer to an array of fast registration descriptor pointers.
+ * @n:    Number of descriptors to put back.
+ *
+ * Note: The caller must already have queued an invalidation request for
+ * desc->mr->rkey before calling this function.
+ */
+static void srp_fr_pool_put(struct srp_fr_pool *pool, struct srp_fr_desc **desc,
+			    int n)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	for (i = 0; i < n; i++)
+		list_add(&desc[i]->entry, &pool->free_list);
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
+{
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct srp_fr_pool *pool;
+	int max_pages_per_mr;
+
+	for (max_pages_per_mr = SRP_MAX_PAGES_PER_MR;
+	     max_pages_per_mr >= SRP_MIN_PAGES_PER_MR;
+	     max_pages_per_mr /= 2) {
+		pool = srp_create_fr_pool(dev->dev, dev->pd,
+					  SRP_MDESC_PER_POOL, max_pages_per_mr);
+		if (!IS_ERR(pool))
+			goto out;
+	}
+
+	if (IS_ERR(pool))
+		pr_warn("Fast registration pool creation for %s failed: %d\n",
+			dev->dev->name, PTR_RET(pool));
+
+out:
+	return pool;
+}
+
 static int srp_create_target_ib(struct srp_target_port *target)
 {
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_qp_init_attr *init_attr;
 	struct ib_cq *recv_cq, *send_cq;
 	struct ib_qp *qp;
+	struct srp_fr_pool *fr_pool = NULL;
+	const int m = 1 + dev->use_fast_reg;
 	int ret;
 
 	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
@@ -308,7 +460,7 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	}
 
 	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, target,
-			       target->queue_size, target->comp_vector);
+			       m * target->queue_size, target->comp_vector);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
@@ -317,11 +469,11 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	ib_req_notify_cq(recv_cq, IB_CQ_NEXT_COMP);
 
 	init_attr->event_handler       = srp_qp_event;
-	init_attr->cap.max_send_wr     = target->queue_size;
+	init_attr->cap.max_send_wr     = m * target->queue_size;
 	init_attr->cap.max_recv_wr     = target->queue_size;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = 1;
-	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
+	init_attr->sq_sig_type         = IB_SIGNAL_REQ_WR;
 	init_attr->qp_type             = IB_QPT_RC;
 	init_attr->send_cq             = send_cq;
 	init_attr->recv_cq             = recv_cq;
@@ -336,6 +488,14 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (ret)
 		goto err_qp;
 
+	if (dev->use_fast_reg) {
+		fr_pool = srp_alloc_fr_pool(target);
+		if (IS_ERR(fr_pool)) {
+			ret = PTR_ERR(fr_pool);
+			goto err_qp;
+		}
+	}
+
 	if (target->qp)
 		ib_destroy_qp(target->qp);
 	if (target->recv_cq)
@@ -343,6 +503,15 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (target->send_cq)
 		ib_destroy_cq(target->send_cq);
 
+	if (dev->use_fast_reg) {
+		srp_destroy_fr_pool(target->fr_pool);
+		target->fr_pool = fr_pool;
+		target->mr_max_size = dev->mr_page_size *
+			fr_pool->max_page_list_len;
+	} else {
+		target->mr_max_size = dev->fmr_max_size;
+	}
+
 	target->qp = qp;
 	target->recv_cq = recv_cq;
 	target->send_cq = send_cq;
@@ -370,12 +539,16 @@ err:
  */
 static void srp_free_target_ib(struct srp_target_port *target)
 {
+	struct srp_device *dev = target->srp_host->srp_dev;
 	int i;
 
 	ib_destroy_qp(target->qp);
 	ib_destroy_cq(target->send_cq);
 	ib_destroy_cq(target->recv_cq);
 
+	if (dev->use_fast_reg)
+		srp_destroy_fr_pool(target->fr_pool);
+
 	target->qp = NULL;
 	target->send_cq = target->recv_cq = NULL;
 
@@ -577,7 +750,8 @@ static void srp_disconnect_target(struct srp_target_port *target)
 static void srp_free_req_data(struct srp_target_port *target,
 			      struct srp_request *req_ring)
 {
-	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_device *ibdev = dev->dev;
 	struct srp_request *req;
 	int i;
 
@@ -586,7 +760,10 @@ static void srp_free_req_data(struct srp_target_port *target,
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &req_ring[i];
-		kfree(req->fmr_list);
+		if (dev->use_fast_reg)
+			kfree(req->fr.fr_list);
+		else
+			kfree(req->fmr.fmr_list);
 		kfree(req->map_page);
 		if (req->indirect_dma_addr) {
 			ib_dma_unmap_single(ibdev, req->indirect_dma_addr,
@@ -612,6 +789,7 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 	struct ib_device *ibdev = srp_dev->dev;
 	struct list_head free_reqs;
 	struct srp_request *req_ring, *req;
+	void *mr_list;
 	dma_addr_t dma_addr;
 	int i, ret = -ENOMEM;
 
@@ -624,12 +802,20 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &req_ring[i];
-		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
-					GFP_KERNEL);
+		mr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
+				  GFP_KERNEL);
+		if (!mr_list)
+			goto out;
+		if (srp_dev->use_fast_reg)
+			req->fr.fr_list = mr_list;
+		else
+			req->fmr.fmr_list = mr_list;
 		req->map_page = kmalloc(SRP_MAX_PAGES_PER_MR * sizeof(void *),
 					GFP_KERNEL);
+		if (!req->map_page)
+			goto out;
 		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
-		if (!req->fmr_list || !req->map_page || !req->indirect_desc)
+		if (!req->indirect_desc)
 			goto out;
 
 		dma_addr = ib_dma_map_single(ibdev, req->indirect_desc,
@@ -771,21 +957,49 @@ static int srp_connect_target(struct srp_target_port *target)
 	}
 }
 
+static int srp_inv_rkey(struct srp_target_port *target, u32 rkey)
+{
+	struct ib_send_wr *bad_wr;
+	struct ib_send_wr wr = {
+		.opcode		    = IB_WR_LOCAL_INV,
+		.wr_id		    = LOCAL_INV_WR_ID_MASK,
+		.next		    = NULL,
+		.num_sge	    = 0,
+		.send_flags	    = 0,
+		.ex.invalidate_rkey = rkey,
+	};
+
+	return ib_post_send(target->qp, &wr, &bad_wr);
+}
+
 static void srp_unmap_data(struct scsi_cmnd *scmnd,
 			   struct srp_target_port *target,
 			   struct srp_request *req)
 {
-	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
-	struct ib_pool_fmr **pfmr;
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_device *ibdev = dev->dev;
+	int i;
 
 	if (!scsi_sglist(scmnd) ||
 	    (scmnd->sc_data_direction != DMA_TO_DEVICE &&
 	     scmnd->sc_data_direction != DMA_FROM_DEVICE))
 		return;
 
-	pfmr = req->fmr_list;
-	while (req->nmdesc--)
-		ib_fmr_pool_unmap(*pfmr++);
+	if (dev->use_fast_reg) {
+		struct srp_fr_desc **pfr;
+
+		for (i = req->nmdesc, pfr = req->fr.fr_list; i > 0; i--, pfr++)
+			srp_inv_rkey(target, (*pfr)->mr->rkey);
+		if (req->nmdesc)
+			srp_fr_pool_put(target->fr_pool, req->fr.fr_list,
+					req->nmdesc);
+	} else {
+		struct ib_pool_fmr **pfmr;
+
+		for (i = req->nmdesc, pfmr = req->fmr.fmr_list; i > 0;
+		     i--, pfmr++)
+			ib_fmr_pool_unmap(*pfmr);
+	}
 
 	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
 			scmnd->sc_data_direction);
@@ -898,20 +1112,25 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	 * callbacks will have finished before a new QP is allocated.
 	 */
 	ret = srp_new_cm_id(target);
+
+	for (i = 0; i < target->req_ring_size; ++i) {
+		struct srp_request *req = &target->req_ring[i];
+		srp_finish_req(target, req, NULL, DID_RESET << 16);
+	}
+
 	/*
 	 * Whether or not creating a new CM ID succeeded, create a new
-	 * QP. This guarantees that all completion callback function
-	 * invocations have finished before request resetting starts.
+	 * QP. This guarantees that all QP callback function invocations have
+	 * finished before request reallocating starts.
 	 */
 	if (ret == 0)
 		ret = srp_create_target_ib(target);
 	else
 		srp_create_target_ib(target);
 
-	for (i = 0; i < target->req_ring_size; ++i) {
-		struct srp_request *req = &target->req_ring[i];
-		srp_finish_req(target, req, NULL, DID_RESET << 16);
-	}
+	/* Reallocate requests to reset the MR state in FR mode. */
+	if (ret == 0)
+		ret = srp_alloc_req_data(target);
 
 	INIT_LIST_HEAD(&target->free_tx);
 	for (i = 0; i < target->queue_size; ++i)
@@ -961,6 +1180,47 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	return 0;
 }
 
+static int srp_map_finish_fr(struct srp_map_state *state,
+			     struct srp_target_port *target)
+{
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_send_wr *bad_wr;
+	struct ib_send_wr wr;
+	struct srp_fr_desc *desc;
+	u32 rkey;
+
+	desc = srp_fr_pool_get(target->fr_pool);
+	if (!desc)
+		return -ENOMEM;
+
+	rkey = ib_inc_rkey(desc->mr->rkey);
+	ib_update_fast_reg_key(desc->mr, rkey);
+
+	memcpy(desc->frpl->page_list, state->pages,
+	       sizeof(state->pages[0]) * state->npages);
+
+	memset(&wr, 0, sizeof(wr));
+	wr.opcode = IB_WR_FAST_REG_MR;
+	wr.wr_id = FAST_REG_WR_ID_MASK;
+	wr.wr.fast_reg.iova_start = state->base_dma_addr;
+	wr.wr.fast_reg.page_list = desc->frpl;
+	wr.wr.fast_reg.page_list_len = state->npages;
+	wr.wr.fast_reg.page_shift = ilog2(dev->mr_page_size);
+	wr.wr.fast_reg.length = state->dma_len;
+	wr.wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE |
+				       IB_ACCESS_REMOTE_READ |
+				       IB_ACCESS_REMOTE_WRITE);
+	wr.wr.fast_reg.rkey = desc->mr->lkey;
+
+	*state->next_fr++ = desc;
+	state->nmdesc++;
+
+	srp_map_desc(state, state->base_dma_addr, state->dma_len,
+		     desc->mr->rkey);
+
+	return ib_post_send(target->qp, &wr, &bad_wr);
+}
+
 static int srp_finish_mapping(struct srp_map_state *state,
 			      struct srp_target_port *target)
 {
@@ -969,11 +1229,13 @@ static int srp_finish_mapping(struct srp_map_state *state,
 	if (state->npages == 0)
 		return 0;
 
-	if (state->npages == 1) {
+	if (state->npages == 1 && !register_always) {
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
 			     target->rkey);
 	} else {
-		ret = srp_map_finish_fmr(state, target);
+		ret = target->srp_host->srp_dev->use_fast_reg ?
+			srp_map_finish_fr(state, target) :
+			srp_map_finish_fmr(state, target);
 	}
 
 	if (ret == 0) {
@@ -996,7 +1258,7 @@ static void srp_map_update_start(struct srp_map_state *state,
 static int srp_map_sg_entry(struct srp_map_state *state,
 			    struct srp_target_port *target,
 			    struct scatterlist *sg, int sg_index,
-			    int use_fmr)
+			    bool use_memory_registration)
 {
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
@@ -1008,22 +1270,24 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	if (!dma_len)
 		return 0;
 
-	if (use_fmr == SRP_MAP_NO_FMR) {
-		/* Once we're in direct map mode for a request, we don't
-		 * go back to FMR mode, so no need to update anything
+	if (!use_memory_registration) {
+		/*
+		 * Once we're in direct map mode for a request, we don't
+		 * go back to FMR or FR mode, so no need to update anything
 		 * other than the descriptor.
 		 */
 		srp_map_desc(state, dma_addr, dma_len, target->rkey);
 		return 0;
 	}
 
-	/* If we start at an offset into the FMR page, don't merge into
-	 * the current FMR. Finish it out, and use the kernel's MR for this
-	 * sg entry. This is to avoid potential bugs on some SRP targets
-	 * that were never quite defined, but went away when the initiator
-	 * avoided using FMR on such page fragments.
+	/*
+	 * Since not all RDMA HW drivers support non-zero page offsets for
+	 * FMR, if we start at an offset into a page, don't merge into the
+	 * current FMR mapping. Finish it out, and use the kernel's MR for
+	 * this sg entry.
 	 */
-	if (dma_addr & ~dev->mr_page_mask || dma_len > dev->fmr_max_size) {
+	if ((!dev->use_fast_reg && dma_addr & ~dev->mr_page_mask) ||
+	    dma_len > target->mr_max_size) {
 		ret = srp_finish_mapping(state, target);
 		if (ret)
 			return ret;
@@ -1033,28 +1297,30 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 		return 0;
 	}
 
-	/* If this is the first sg to go into the FMR, save our position.
-	 * We need to know the first unmapped entry, its index, and the
-	 * first unmapped address within that entry to be able to restart
-	 * mapping after an error.
+	/*
+	 * If this is the first sg that will be mapped via FMR or via FR, save
+	 * our position. We need to know the first unmapped entry, its index,
+	 * and the first unmapped address within that entry to be able to
+	 * restart mapping after an error.
 	 */
 	if (!state->unmapped_sg)
 		srp_map_update_start(state, sg, sg_index, dma_addr);
 
 	while (dma_len) {
-		if (state->npages == SRP_MAX_PAGES_PER_MR) {
-			ret = srp_map_finish_fmr(state, target);
+		unsigned offset = dma_addr & ~dev->mr_page_mask;
+		if (state->npages == SRP_MAX_PAGES_PER_MR || offset != 0) {
+			ret = srp_finish_mapping(state, target);
 			if (ret)
 				return ret;
 
 			srp_map_update_start(state, sg, sg_index, dma_addr);
 		}
 
-		len = min_t(unsigned int, dma_len, dev->mr_page_size);
+		len = min_t(unsigned int, dma_len, dev->mr_page_size - offset);
 
 		if (!state->npages)
 			state->base_dma_addr = dma_addr;
-		state->pages[state->npages++] = dma_addr;
+		state->pages[state->npages++] = dma_addr & dev->mr_page_mask;
 		state->dma_len += len;
 		dma_addr += len;
 		dma_len -= len;
@@ -1066,32 +1332,40 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 */
 	ret = 0;
 	if (len != dev->mr_page_size) {
-		ret = srp_map_finish_fmr(state, target);
+		ret = srp_finish_mapping(state, target);
 		if (!ret)
 			srp_map_update_start(state, NULL, 0, 0);
 	}
 	return ret;
 }
 
-static void srp_map_fmr(struct srp_map_state *state,
-			struct srp_target_port *target, struct srp_request *req,
-			struct scatterlist *scat, int count)
+static int srp_map_sg(struct srp_map_state *state,
+		      struct srp_target_port *target, struct srp_request *req,
+		      struct scatterlist *scat, int count)
 {
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	struct scatterlist *sg;
-	int i, use_fmr;
+	int i;
+	bool use_memory_registration;
 
 	state->desc	= req->indirect_desc;
 	state->pages	= req->map_page;
-	state->next_fmr	= req->fmr_list;
-
-	use_fmr = dev->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
+	if (dev->use_fast_reg) {
+		state->next_fmr = req->fmr.fmr_list;
+		use_memory_registration = !!target->fr_pool;
+	} else {
+		state->next_fr = req->fr.fr_list;
+		use_memory_registration = !!dev->fmr_pool;
+	}
 
 	for_each_sg(scat, sg, count, i) {
-		if (srp_map_sg_entry(state, target, sg, i, use_fmr)) {
-			/* FMR mapping failed, so backtrack to the first
-			 * unmapped entry and continue on without using FMR.
+		if (srp_map_sg_entry(state, target, sg, i,
+				     use_memory_registration)) {
+			/*
+			 * Memory registration failed, so backtrack to the
+			 * first unmapped entry and continue on without using
+			 * memory registration.
 			 */
 			dma_addr_t dma_addr;
 			unsigned int dma_len;
@@ -1104,15 +1378,17 @@ backtrack:
 			dma_len = ib_sg_dma_len(ibdev, sg);
 			dma_len -= (state->unmapped_addr - dma_addr);
 			dma_addr = state->unmapped_addr;
-			use_fmr = SRP_MAP_NO_FMR;
+			use_memory_registration = false;
 			srp_map_desc(state, dma_addr, dma_len, target->rkey);
 		}
 	}
 
-	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_map_finish_fmr(state, target))
+	if (use_memory_registration && srp_finish_mapping(state, target))
 		goto backtrack;
 
 	req->nmdesc = state->nmdesc;
+
+	return 0;
 }
 
 static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
@@ -1120,7 +1396,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 {
 	struct scatterlist *scat;
 	struct srp_cmd *cmd = req->cmd->buf;
-	int len, nents, count;
+	int len, nents, count, res;
 	struct srp_device *dev;
 	struct ib_device *ibdev;
 	struct srp_map_state state;
@@ -1152,7 +1428,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
 
-	if (count == 1) {
+	if (count == 1 && !register_always) {
 		/*
 		 * The midlayer only generated a single gather/scatter
 		 * entry, or DMA mapping coalesced everything to a
@@ -1169,9 +1445,9 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		goto map_complete;
 	}
 
-	/* We have more than one scatter/gather entry, so build our indirect
-	 * descriptor table, trying to merge as many entries with FMR as we
-	 * can.
+	/*
+	 * We have more than one scatter/gather entry, so build our indirect
+	 * descriptor table, trying to merge as many entries as we can.
 	 */
 	indirect_hdr = (void *) cmd->add_data;
 
@@ -1179,7 +1455,9 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 				   target->indirect_size, DMA_TO_DEVICE);
 
 	memset(&state, 0, sizeof(state));
-	srp_map_fmr(&state, target, req, scat, count);
+	res = srp_map_sg(&state, target, req, scat, count);
+	if (res < 0)
+		return res;
 
 	/* We've mapped the request, now pull as much of the indirect
 	 * descriptor table as we can into the command buffer. If this
@@ -1188,7 +1466,8 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	 * give us more S/G entries than we allow.
 	 */
 	if (state.ndesc == 1) {
-		/* FMR mapping was able to collapse this to one entry,
+		/*
+		 * Memory registration collapsed the sg-list into one entry,
 		 * so use a direct descriptor.
 		 */
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
@@ -1511,14 +1790,24 @@ static void srp_tl_err_work(struct work_struct *work)
 		srp_start_tl_fail_timers(target->rport);
 }
 
-static void srp_handle_qp_err(enum ib_wc_status wc_status, bool send_err,
-			      struct srp_target_port *target)
+static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
+			      bool send_err, struct srp_target_port *target)
 {
 	if (target->connected && !target->qp_in_error) {
-		shost_printk(KERN_ERR, target->scsi_host,
-			     PFX "failed %s status %d\n",
-			     send_err ? "send" : "receive",
-			     wc_status);
+		if (wr_id & LOCAL_INV_WR_ID_MASK) {
+			shost_printk(KERN_ERR, target->scsi_host,
+				     "LOCAL_INV failed with status %d\n",
+				     wc_status);
+		} else if (wr_id & FAST_REG_WR_ID_MASK) {
+			shost_printk(KERN_ERR, target->scsi_host,
+				     "FAST_REG_MR failed status %d\n",
+				     wc_status);
+		} else {
+			shost_printk(KERN_ERR, target->scsi_host,
+				     PFX "failed %s status %d for iu %p\n",
+				     send_err ? "send" : "receive",
+				     wc_status, (void *)(uintptr_t)wr_id);
+		}
 		queue_work(system_long_wq, &target->tl_err_work);
 	}
 	target->qp_in_error = true;
@@ -1534,7 +1823,7 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 		if (likely(wc.status == IB_WC_SUCCESS)) {
 			srp_handle_recv(target, &wc);
 		} else {
-			srp_handle_qp_err(wc.status, false, target);
+			srp_handle_qp_err(wc.wr_id, wc.status, false, target);
 		}
 	}
 }
@@ -1550,7 +1839,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &target->free_tx);
 		} else {
-			srp_handle_qp_err(wc.status, true, target);
+			srp_handle_qp_err(wc.wr_id, wc.status, true, target);
 		}
 	}
 }
@@ -2873,6 +3162,7 @@ static void srp_add_one(struct ib_device *device)
 	struct ib_device_attr *dev_attr;
 	struct srp_host *host;
 	int mr_page_shift, s, e, p;
+	bool have_fmr = false, have_fr = false;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2887,6 +3177,19 @@ static void srp_add_one(struct ib_device *device)
 	if (!srp_dev)
 		goto free_attr;
 
+	if (device->alloc_fmr && device->dealloc_fmr && device->map_phys_fmr &&
+	    device->unmap_fmr) {
+		have_fmr = true;
+	}
+	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS)
+		have_fr = true;
+	if (!have_fmr && !have_fr) {
+		dev_err(&device->dev, "neither FMR nor FR is supported\n");
+		goto free_dev;
+	}
+
+	srp_dev->use_fast_reg = have_fr && (!have_fmr || prefer_fr);
+
 	/*
 	 * Use the smallest page size supported by the HCA, down to a
 	 * minimum of 4096 bytes. We're unlikely to build large sglists
@@ -2910,7 +3213,8 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->mr))
 		goto err_pd;
 
-	srp_alloc_fmr_pool(srp_dev);
+	if (!srp_dev->use_fast_reg)
+		srp_alloc_fmr_pool(srp_dev);
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
 		s = 0;
@@ -2974,7 +3278,7 @@ static void srp_remove_one(struct ib_device *device)
 		kfree(host);
 	}
 
-	if (srp_dev->fmr_pool)
+	if (!srp_dev->use_fast_reg && srp_dev->fmr_pool)
 		ib_destroy_fmr_pool(srp_dev->fmr_pool);
 	ib_dereg_mr(srp_dev->mr);
 	ib_dealloc_pd(srp_dev->pd);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 89e3adb..4ec44b5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -71,8 +71,8 @@ enum {
 	SRP_MDESC_PER_POOL	= 1024,
 	SRP_FMR_DIRTY_SIZE	= SRP_MDESC_PER_POOL / 4,
 
-	SRP_MAP_ALLOW_FMR	= 0,
-	SRP_MAP_NO_FMR		= 1,
+	LOCAL_INV_WR_ID_MASK	= 1,
+	FAST_REG_WR_ID_MASK	= 2,
 };
 
 enum srp_target_state {
@@ -86,6 +86,12 @@ enum srp_iu_type {
 	SRP_IU_RSP,
 };
 
+/*
+ * @mr_page_mask: HCA memory registration page mask.
+ * @mr_page_size: HCA memory registration page size.
+ * @fmr_max_size: Maximum size of a single HCA memory registration request
+ *                when using FMR.
+ */
 struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
@@ -95,6 +101,7 @@ struct srp_device {
 	u64			mr_page_mask;
 	int			mr_page_size;
 	int			fmr_max_size;
+	bool			use_fast_reg;
 };
 
 struct srp_host {
@@ -108,18 +115,32 @@ struct srp_host {
 	struct mutex		add_target_mutex;
 };
 
+/*
+ * In the union below 'fmr' stands for 'Fast Memory Registration' and fr for
+ * 'Fast Registration'.
+ */
 struct srp_request {
 	struct list_head	list;
 	struct scsi_cmnd       *scmnd;
 	struct srp_iu	       *cmd;
-	struct ib_pool_fmr    **fmr_list;
 	u64		       *map_page;
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
 	short			nmdesc;
 	short			index;
+	union {
+		struct {
+			struct ib_pool_fmr **fmr_list;
+		} fmr;
+		struct {
+			struct srp_fr_desc **fr_list;
+		} fr;
+	};
 };
 
+/*
+ * @mr_max_size: Maximum size of a single HCA memory registration request.
+ */
 struct srp_target_port {
 	/* These are RW in the hot path, and commonly used together */
 	struct list_head	free_tx;
@@ -131,6 +152,8 @@ struct srp_target_port {
 	struct ib_cq	       *send_cq ____cacheline_aligned_in_smp;
 	struct ib_cq	       *recv_cq;
 	struct ib_qp	       *qp;
+	struct srp_fr_pool     *fr_pool;
+	int			mr_max_size;
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
@@ -197,8 +220,59 @@ struct srp_iu {
 	enum dma_data_direction	direction;
 };
 
+/**
+ * struct srp_fr_desc - fast registration work request arguments
+ * @entry: Entry in free_list.
+ * @mr:    Memory region.
+ * @frpl:  Fast registration page list.
+ */
+struct srp_fr_desc {
+	struct list_head		entry;
+	struct ib_mr			*mr;
+	struct ib_fast_reg_page_list	*frpl;
+};
+
+/**
+ * struct srp_fr_pool - pool of fast registration descriptors
+ *
+ * An entry is available for allocation if and only if it occurs in @free_list.
+ *
+ * @size:      Number of descriptors in this pool.
+ * @max_page_list_len: Maximum fast registration work request page list length.
+ * @lock:      Protects free_list.
+ * @free_list: List of free descriptors.
+ * @desc:      Fast registration descriptor pool.
+ */
+struct srp_fr_pool {
+	int			size;
+	int			max_page_list_len;
+	spinlock_t		lock;
+	struct list_head	free_list;
+	struct srp_fr_desc	desc[0];
+};
+
+/**
+ * struct srp_map_state - per-request DMA memory mapping state
+ * @desc:	    Pointer to the element of the SRP buffer descriptor array
+ *		    that is being filled in.
+ * @pages:	    Array with DMA addresses of pages being considered for
+ *		    memory registration.
+ * @base_dma_addr:  DMA address of the first page that has not yet been mapped.
+ * @dma_len:	    Number of bytes that will be registered with the next
+ *		    FMR or FR memory registration call.
+ * @total_len:	    Total number of bytes in the sg-list being mapped.
+ * @npages:	    Number of page addresses in the pages[] array.
+ * @nmdesc:	    Number of FMR or FR memory descriptors used for mapping.
+ * @ndesc:	    Number of SRP buffer descriptors that have been filled in.
+ * @unmapped_sg:    First element of the sg-list that is mapped via FMR or FR.
+ * @unmapped_index: Index of the first element mapped via FMR or FR.
+ * @unmapped_addr:  DMA address of the first element mapped via FMR or FR.
+ */
 struct srp_map_state {
-	struct ib_pool_fmr    **next_fmr;
+	union {
+		struct ib_pool_fmr **next_fmr;
+		struct srp_fr_desc **next_fr;
+	};
 	struct srp_direct_buf  *desc;
 	u64		       *pages;
 	dma_addr_t		base_dma_addr;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
