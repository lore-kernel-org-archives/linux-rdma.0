From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 9/9] IB/srp: Add fast registration support
Date: Tue, 13 May 2014 16:44:50 +0200
Message-ID: <53722FE2.4010808@acm.org>
References: <53722E4F.7070709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53722E4F.7070709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Certain HCA types (e.g. Connect-IB) and certain configurations (e.g.
ConnectX VF) support fast registration but not FMR. Hence add fast
registration support.

In function srp_rport_reconnect(), move the the srp_finish_req()
loop from after to before the srp_create_target_ib() call. This is
needed to avoid that srp_finish_req() tries to queue any
invalidation requests for rkeys associated with the old queue pair
on the newly allocated queue pair. Invoking srp_finish_req() before
the queue pair has been reallocated is safe since srp_claim_req()
handles completions correctly that arrive after srp_finish_req()
has been invoked.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 457 +++++++++++++++++++++++++++++-------
 drivers/infiniband/ulp/srp/ib_srp.h |  74 +++++-
 2 files changed, 440 insertions(+), 91 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 4fda7eb..2e0bd4d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -66,6 +66,7 @@ static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
+static bool prefer_fr;
 static bool register_always;
 static int topspin_workarounds = 1;
 
@@ -88,6 +89,10 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
+module_param(prefer_fr, bool, 0444);
+MODULE_PARM_DESC(prefer_fr,
+"Whether to use fast registration if both FMR and fast registration are supported");
+
 module_param(register_always, bool, 0444);
 MODULE_PARM_DESC(register_always,
 		 "Use memory registration even for contiguous memory regions");
@@ -311,6 +316,132 @@ static struct ib_fmr_pool *srp_alloc_fmr_pool(struct srp_target_port *target)
 	return ib_create_fmr_pool(dev->pd, &fmr_param);
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
+
+	return srp_create_fr_pool(dev->dev, dev->pd,
+				  target->scsi_host->can_queue,
+				  dev->max_pages_per_mr);
+}
+
 static int srp_create_target_ib(struct srp_target_port *target)
 {
 	struct srp_device *dev = target->srp_host->srp_dev;
@@ -318,6 +449,8 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	struct ib_cq *recv_cq, *send_cq;
 	struct ib_qp *qp;
 	struct ib_fmr_pool *fmr_pool = NULL;
+	struct srp_fr_pool *fr_pool = NULL;
+	const int m = 1 + dev->use_fast_reg;
 	int ret;
 
 	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
@@ -332,7 +465,7 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	}
 
 	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, target,
-			       target->queue_size, target->comp_vector);
+			       m * target->queue_size, target->comp_vector);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
@@ -341,11 +474,11 @@ static int srp_create_target_ib(struct srp_target_port *target)
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
@@ -360,19 +493,38 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (ret)
 		goto err_qp;
 
-	if (!target->qp || target->fmr_pool) {
-		fmr_pool = srp_alloc_fmr_pool(target);
-		if (IS_ERR(fmr_pool)) {
-			ret = PTR_ERR(fmr_pool);
-			shost_printk(KERN_WARNING, target->scsi_host, PFX
-				     "FMR pool allocation failed (%d)\n", ret);
-			if (target->qp)
-				goto err_qp;
-			fmr_pool = NULL;
+	if (dev->use_fast_reg) {
+		if (!target->qp || target->fr_pool) {
+			fr_pool = srp_alloc_fr_pool(target);
+			if (IS_ERR(fr_pool)) {
+				ret = PTR_ERR(fr_pool);
+				shost_printk(KERN_WARNING, target->scsi_host,
+					PFX "FR pool allocation failed (%d)\n",
+					ret);
+				if (target->qp)
+					goto err_qp;
+				fr_pool = NULL;
+			}
+			if (target->fr_pool)
+				srp_destroy_fr_pool(target->fr_pool);
+			target->fr_pool = fr_pool;
+		}
+	} else {
+		if (!target->qp || target->fmr_pool) {
+			fmr_pool = srp_alloc_fmr_pool(target);
+			if (IS_ERR(fmr_pool)) {
+				ret = PTR_ERR(fmr_pool);
+				shost_printk(KERN_WARNING, target->scsi_host,
+					PFX "FMR pool allocation failed (%d)\n",
+					ret);
+				if (target->qp)
+					goto err_qp;
+				fmr_pool = NULL;
+			}
+			if (target->fmr_pool)
+				ib_destroy_fmr_pool(target->fmr_pool);
+			target->fmr_pool = fmr_pool;
 		}
-		if (target->fmr_pool)
-			ib_destroy_fmr_pool(target->fmr_pool);
-		target->fmr_pool = fmr_pool;
 	}
 
 	if (target->qp)
@@ -409,10 +561,16 @@ err:
  */
 static void srp_free_target_ib(struct srp_target_port *target)
 {
+	struct srp_device *dev = target->srp_host->srp_dev;
 	int i;
 
-	if (target->fmr_pool)
-		ib_destroy_fmr_pool(target->fmr_pool);
+	if (dev->use_fast_reg) {
+		if (target->fr_pool)
+			srp_destroy_fr_pool(target->fr_pool);
+	} else {
+		if (target->fmr_pool)
+			ib_destroy_fmr_pool(target->fmr_pool);
+	}
 	ib_destroy_qp(target->qp);
 	ib_destroy_cq(target->send_cq);
 	ib_destroy_cq(target->recv_cq);
@@ -617,7 +775,8 @@ static void srp_disconnect_target(struct srp_target_port *target)
 
 static void srp_free_req_data(struct srp_target_port *target)
 {
-	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_device *ibdev = dev->dev;
 	struct srp_request *req;
 	int i;
 
@@ -626,7 +785,10 @@ static void srp_free_req_data(struct srp_target_port *target)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &target->req_ring[i];
-		kfree(req->fmr_list);
+		if (dev->use_fast_reg)
+			kfree(req->fr_list);
+		else
+			kfree(req->fmr_list);
 		kfree(req->map_page);
 		if (req->indirect_dma_addr) {
 			ib_dma_unmap_single(ibdev, req->indirect_dma_addr,
@@ -645,6 +807,7 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 	struct srp_device *srp_dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 	struct srp_request *req;
+	void *mr_list;
 	dma_addr_t dma_addr;
 	int i, ret = -ENOMEM;
 
@@ -657,12 +820,20 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &target->req_ring[i];
-		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
-					GFP_KERNEL);
+		mr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
+				  GFP_KERNEL);
+		if (!mr_list)
+			goto out;
+		if (srp_dev->use_fast_reg)
+			req->fr_list = mr_list;
+		else
+			req->fmr_list = mr_list;
 		req->map_page = kmalloc(SRP_MAX_PAGES_PER_MR * sizeof(void *),
 					GFP_KERNEL);
+		if (!req->map_page)
+			goto out;
 		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
-		if (!req->fmr_list || !req->map_page || !req->indirect_desc)
+		if (!req->indirect_desc)
 			goto out;
 
 		dma_addr = ib_dma_map_single(ibdev, req->indirect_desc,
@@ -799,21 +970,48 @@ static int srp_connect_target(struct srp_target_port *target)
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
+		for (i = req->nmdesc, pfr = req->fr_list; i > 0; i--, pfr++)
+			srp_inv_rkey(target, (*pfr)->mr->rkey);
+		if (req->nmdesc)
+			srp_fr_pool_put(target->fr_pool, req->fr_list,
+					req->nmdesc);
+	} else {
+		struct ib_pool_fmr **pfmr;
+
+		for (i = req->nmdesc, pfmr = req->fmr_list; i > 0; i--, pfmr++)
+			ib_fmr_pool_unmap(*pfmr);
+	}
 
 	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
 			scmnd->sc_data_direction);
@@ -926,21 +1124,19 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	 * callbacks will have finished before a new QP is allocated.
 	 */
 	ret = srp_new_cm_id(target);
-	/*
-	 * Whether or not creating a new CM ID succeeded, create a new
-	 * QP. This guarantees that all completion callback function
-	 * invocations have finished before request resetting starts.
-	 */
-	if (ret == 0)
-		ret = srp_create_target_ib(target);
-	else
-		srp_create_target_ib(target);
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		srp_finish_req(target, req, NULL, DID_RESET << 16);
 	}
 
+	/*
+	 * Whether or not creating a new CM ID succeeded, create a new
+	 * QP. This guarantees that all callback functions for the old QP have
+	 * finished before any send requests are posted on the new QP.
+	 */
+	ret += srp_create_target_ib(target);
+
 	INIT_LIST_HEAD(&target->free_tx);
 	for (i = 0; i < target->queue_size; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
@@ -988,6 +1184,47 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
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
@@ -1000,7 +1237,9 @@ static int srp_finish_mapping(struct srp_map_state *state,
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
 			     target->rkey);
 	else
-		ret = srp_map_finish_fmr(state, target);
+		ret = target->srp_host->srp_dev->use_fast_reg ?
+			srp_map_finish_fr(state, target) :
+			srp_map_finish_fmr(state, target);
 
 	if (ret == 0) {
 		state->npages = 0;
@@ -1022,7 +1261,7 @@ static void srp_map_update_start(struct srp_map_state *state,
 static int srp_map_sg_entry(struct srp_map_state *state,
 			    struct srp_target_port *target,
 			    struct scatterlist *sg, int sg_index,
-			    int use_fmr)
+			    bool use_memory_registration)
 {
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
@@ -1034,22 +1273,24 @@ static int srp_map_sg_entry(struct srp_map_state *state,
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
-	if (dma_addr & ~dev->mr_page_mask || dma_len > dev->mr_max_size) {
+	if ((!dev->use_fast_reg && dma_addr & ~dev->mr_page_mask) ||
+	    dma_len > dev->mr_max_size) {
 		ret = srp_finish_mapping(state, target);
 		if (ret)
 			return ret;
@@ -1059,16 +1300,18 @@ static int srp_map_sg_entry(struct srp_map_state *state,
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
+		unsigned offset = dma_addr & ~dev->mr_page_mask;
+		if (state->npages == SRP_MAX_PAGES_PER_MR || offset != 0) {
 			ret = srp_finish_mapping(state, target);
 			if (ret)
 				return ret;
@@ -1076,17 +1319,18 @@ static int srp_map_sg_entry(struct srp_map_state *state,
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
 	}
 
-	/* If the last entry of the FMR wasn't a full page, then we need to
+	/*
+	 * If the last entry of the MR wasn't a full page, then we need to
 	 * close it out and start a new one -- we can only merge at page
 	 * boundries.
 	 */
@@ -1099,25 +1343,33 @@ static int srp_map_sg_entry(struct srp_map_state *state,
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
-	use_fmr = target->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
+	if (dev->use_fast_reg) {
+		state->next_fmr = req->fmr_list;
+		use_memory_registration = !!target->fr_pool;
+	} else {
+		state->next_fr = req->fr_list;
+		use_memory_registration = !!target->fmr_pool;
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
@@ -1130,15 +1382,17 @@ backtrack:
 			dma_len = ib_sg_dma_len(ibdev, sg);
 			dma_len -= (state->unmapped_addr - dma_addr);
 			dma_addr = state->unmapped_addr;
-			use_fmr = SRP_MAP_NO_FMR;
+			use_memory_registration = false;
 			srp_map_desc(state, dma_addr, dma_len, target->rkey);
 		}
 	}
 
-	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_finish_mapping(state, target))
+	if (use_memory_registration && srp_finish_mapping(state, target))
 		goto backtrack;
 
 	req->nmdesc = state->nmdesc;
+
+	return 0;
 }
 
 static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
@@ -1195,9 +1449,9 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
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
 
@@ -1205,7 +1459,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 				   target->indirect_size, DMA_TO_DEVICE);
 
 	memset(&state, 0, sizeof(state));
-	srp_map_fmr(&state, target, req, scat, count);
+	srp_map_sg(&state, target, req, scat, count);
 
 	/* We've mapped the request, now pull as much of the indirect
 	 * descriptor table as we can into the command buffer. If this
@@ -1214,7 +1468,8 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	 * give us more S/G entries than we allow.
 	 */
 	if (state.ndesc == 1) {
-		/* FMR mapping was able to collapse this to one entry,
+		/*
+		 * Memory registration collapsed the sg-list into one entry,
 		 * so use a direct descriptor.
 		 */
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
@@ -1537,14 +1792,24 @@ static void srp_tl_err_work(struct work_struct *work)
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
@@ -1560,7 +1825,7 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 		if (likely(wc.status == IB_WC_SUCCESS)) {
 			srp_handle_recv(target, &wc);
 		} else {
-			srp_handle_qp_err(wc.status, false, target);
+			srp_handle_qp_err(wc.wr_id, wc.status, false, target);
 		}
 	}
 }
@@ -1576,7 +1841,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &target->free_tx);
 		} else {
-			srp_handle_qp_err(wc.status, true, target);
+			srp_handle_qp_err(wc.wr_id, wc.status, true, target);
 		}
 	}
 }
@@ -2689,7 +2954,8 @@ static ssize_t srp_create_target(struct device *dev,
 		container_of(dev, struct srp_host, dev);
 	struct Scsi_Host *target_host;
 	struct srp_target_port *target;
-	struct ib_device *ibdev = host->srp_dev->dev;
+	struct srp_device *srp_dev = host->srp_dev;
+	struct ib_device *ibdev = srp_dev->dev;
 	int ret;
 
 	target_host = scsi_host_alloc(&srp_template,
@@ -2738,10 +3004,6 @@ static ssize_t srp_create_target(struct device *dev,
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
-	ret = srp_alloc_req_data(target);
-	if (ret)
-		goto err_free_mem;
-
 	ret = ib_query_gid(ibdev, host->port, 0, &target->path.sgid);
 	if (ret)
 		goto err_free_mem;
@@ -2752,7 +3014,7 @@ static ssize_t srp_create_target(struct device *dev,
 
 	if (!target->fmr_pool && !target->allow_ext_sg &&
 	    target->cmd_sg_cnt < target->sg_tablesize) {
-		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
+		pr_warn("No MR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
 		target->sg_tablesize = target->cmd_sg_cnt;
 	}
 
@@ -2763,6 +3025,10 @@ static ssize_t srp_create_target(struct device *dev,
 			     sizeof(struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof(struct srp_direct_buf);
 
+	ret = srp_alloc_req_data(target);
+	if (ret)
+		goto err_free_mem;
+
 	ret = srp_new_cm_id(target);
 	if (ret)
 		goto err_free_ib;
@@ -2876,6 +3142,7 @@ static void srp_add_one(struct ib_device *device)
 	struct ib_device_attr *dev_attr;
 	struct srp_host *host;
 	int mr_page_shift, s, e, p;
+	bool have_fmr = false, have_fr = false;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2890,6 +3157,19 @@ static void srp_add_one(struct ib_device *device)
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
@@ -2900,6 +3180,11 @@ static void srp_add_one(struct ib_device *device)
 	srp_dev->mr_page_mask	= ~((u64) srp_dev->mr_page_size - 1);
 	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
 				dev_attr->max_mr_size / srp_dev->mr_page_size);
+	if (srp_dev->use_fast_reg) {
+		srp_dev->max_pages_per_mr =
+			min_t(u32, srp_dev->max_pages_per_mr,
+			      dev_attr->max_fast_reg_page_list_len);
+	}
 	srp_dev->mr_max_size	= srp_dev->mr_page_size *
 				   srp_dev->max_pages_per_mr;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index fccf5df..fb465fd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -68,8 +68,8 @@ enum {
 
 	SRP_MAX_PAGES_PER_MR	= 512,
 
-	SRP_MAP_ALLOW_FMR	= 0,
-	SRP_MAP_NO_FMR		= 1,
+	LOCAL_INV_WR_ID_MASK	= 1,
+	FAST_REG_WR_ID_MASK	= 2,
 };
 
 enum srp_target_state {
@@ -83,6 +83,12 @@ enum srp_iu_type {
 	SRP_IU_RSP,
 };
 
+/*
+ * @mr_page_mask: HCA memory registration page mask.
+ * @mr_page_size: HCA memory registration page size.
+ * @mr_max_size: Maximum size in bytes of a single FMR / FR registration
+ *   request.
+ */
 struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
@@ -92,6 +98,7 @@ struct srp_device {
 	int			mr_page_size;
 	int			mr_max_size;
 	int			max_pages_per_mr;
+	bool			use_fast_reg;
 };
 
 struct srp_host {
@@ -109,12 +116,15 @@ struct srp_request {
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
+		struct ib_pool_fmr **fmr_list;
+		struct srp_fr_desc **fr_list;
+	};
 };
 
 struct srp_target_port {
@@ -128,7 +138,10 @@ struct srp_target_port {
 	struct ib_cq	       *send_cq ____cacheline_aligned_in_smp;
 	struct ib_cq	       *recv_cq;
 	struct ib_qp	       *qp;
-	struct ib_fmr_pool     *fmr_pool;
+	union {
+		struct ib_fmr_pool     *fmr_pool;
+		struct srp_fr_pool     *fr_pool;
+	};
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
@@ -195,8 +208,59 @@ struct srp_iu {
 	enum dma_data_direction	direction;
 };
 
+/**
+ * struct srp_fr_desc - fast registration work request arguments
+ * @entry: Entry in srp_fr_pool.free_list.
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
