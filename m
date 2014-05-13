From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 7/9] IB/srp: One FMR pool per SRP connection
Date: Tue, 13 May 2014 16:43:24 +0200
Message-ID: <53722F8C.4020809@acm.org>
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

Allocate one FMR pool per SRP connection instead of one SRP pool
per HCA. This improves scalability of the SRP initiator.

Only request the SCSI mid-layer to retry a SCSI command after a
temporary mapping failure (-ENOMEM) but not after a permanent
mapping failure. This avoids that SCSI commands are retried
indefinitely if a permanent memory mapping failure occurs.

Tell the SCSI mid-layer to reduce queue depth temporarily in the
unlikely case where an application is queuing many requests with
more than max_pages_per_fmr sg-list elements.

For FMR pool allocation, base the max_pages_per_fmr parameter on
the HCA memory registration limit.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 135 +++++++++++++++++++++---------------
 drivers/infiniband/ulp/srp/ib_srp.h |   6 +-
 2 files changed, 82 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index eb88f80..2bfc3dd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -293,12 +293,31 @@ static int srp_new_cm_id(struct srp_target_port *target)
 	return 0;
 }
 
+static struct ib_fmr_pool *srp_alloc_fmr_pool(struct srp_target_port *target)
+{
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_fmr_pool_param fmr_param;
+
+	memset(&fmr_param, 0, sizeof(fmr_param));
+	fmr_param.pool_size	    = target->scsi_host->can_queue;
+	fmr_param.dirty_watermark   = fmr_param.pool_size / 4;
+	fmr_param.cache		    = 1;
+	fmr_param.max_pages_per_fmr = dev->max_pages_per_fmr;
+	fmr_param.page_shift	    = ilog2(dev->fmr_page_size);
+	fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
+				       IB_ACCESS_REMOTE_WRITE |
+				       IB_ACCESS_REMOTE_READ);
+
+	return ib_create_fmr_pool(dev->pd, &fmr_param);
+}
+
 static int srp_create_target_ib(struct srp_target_port *target)
 {
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_qp_init_attr *init_attr;
 	struct ib_cq *recv_cq, *send_cq;
 	struct ib_qp *qp;
+	struct ib_fmr_pool *fmr_pool = NULL;
 	int ret;
 
 	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
@@ -341,6 +360,21 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (ret)
 		goto err_qp;
 
+	if (!target->qp || target->fmr_pool) {
+		fmr_pool = srp_alloc_fmr_pool(target);
+		if (IS_ERR(fmr_pool)) {
+			ret = PTR_ERR(fmr_pool);
+			shost_printk(KERN_WARNING, target->scsi_host, PFX
+				     "FMR pool allocation failed (%d)\n", ret);
+			if (target->qp)
+				goto err_qp;
+			fmr_pool = NULL;
+		}
+		if (target->fmr_pool)
+			ib_destroy_fmr_pool(target->fmr_pool);
+		target->fmr_pool = fmr_pool;
+	}
+
 	if (target->qp)
 		ib_destroy_qp(target->qp);
 	if (target->recv_cq)
@@ -377,6 +411,8 @@ static void srp_free_target_ib(struct srp_target_port *target)
 {
 	int i;
 
+	if (target->fmr_pool)
+		ib_destroy_fmr_pool(target->fmr_pool);
 	ib_destroy_qp(target->qp);
 	ib_destroy_cq(target->send_cq);
 	ib_destroy_cq(target->recv_cq);
@@ -936,11 +972,10 @@ static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
 static int srp_map_finish_fmr(struct srp_map_state *state,
 			      struct srp_target_port *target)
 {
-	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
-	fmr = ib_fmr_pool_map_phys(dev->fmr_pool, state->pages,
+	fmr = ib_fmr_pool_map_phys(target->fmr_pool, state->pages,
 				   state->npages, io_addr);
 	if (IS_ERR(fmr))
 		return PTR_ERR(fmr);
@@ -1077,7 +1112,7 @@ static void srp_map_fmr(struct srp_map_state *state,
 	state->pages	= req->map_page;
 	state->next_fmr	= req->fmr_list;
 
-	use_fmr = dev->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
+	use_fmr = target->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
 
 	for_each_sg(scat, sg, count, i) {
 		if (srp_map_sg_entry(state, target, sg, i, use_fmr)) {
@@ -1555,7 +1590,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	unsigned long flags;
-	int len, result;
+	int len, ret;
 	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
 
 	/*
@@ -1567,12 +1602,9 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (in_scsi_eh)
 		mutex_lock(&rport->mutex);
 
-	result = srp_chkready(target->rport);
-	if (unlikely(result)) {
-		scmnd->result = result;
-		scmnd->scsi_done(scmnd);
-		goto unlock_rport;
-	}
+	scmnd->result = srp_chkready(target->rport);
+	if (unlikely(scmnd->result))
+		goto err;
 
 	spin_lock_irqsave(&target->lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
@@ -1587,7 +1619,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_iu_len,
 				   DMA_TO_DEVICE);
 
-	scmnd->result        = 0;
 	scmnd->host_scribble = (void *) req;
 
 	cmd = iu->buf;
@@ -1604,7 +1635,15 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	len = srp_map_data(scmnd, target, req);
 	if (len < 0) {
 		shost_printk(KERN_ERR, target->scsi_host,
-			     PFX "Failed to map data\n");
+			     PFX "Failed to map data (%d)\n", len);
+		/*
+		 * If we ran out of memory descriptors (-ENOMEM) because an
+		 * application is queuing many requests with more than
+		 * max_pages_per_fmr sg-list elements, tell the SCSI mid-layer
+		 * to reduce queue depth temporarily.
+		 */
+		scmnd->result = len == -ENOMEM ?
+			DID_OK << 16 | QUEUE_FULL << 1 : DID_ERROR << 16;
 		goto err_iu;
 	}
 
@@ -1616,11 +1655,13 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		goto err_unmap;
 	}
 
+	ret = 0;
+
 unlock_rport:
 	if (in_scsi_eh)
 		mutex_unlock(&rport->mutex);
 
-	return 0;
+	return ret;
 
 err_unmap:
 	srp_unmap_data(scmnd, target, req);
@@ -1636,10 +1677,15 @@ err_iu:
 err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
-	if (in_scsi_eh)
-		mutex_unlock(&rport->mutex);
+err:
+	if (scmnd->result) {
+		scmnd->scsi_done(scmnd);
+		ret = 0;
+	} else {
+		ret = SCSI_MLQUEUE_HOST_BUSY;
+	}
 
-	return SCSI_MLQUEUE_HOST_BUSY;
+	goto unlock_rport;
 }
 
 /*
@@ -2688,19 +2734,6 @@ static ssize_t srp_create_target(struct device *dev,
 		goto err;
 	}
 
-	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
-				target->cmd_sg_cnt < target->sg_tablesize) {
-		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
-		target->sg_tablesize = target->cmd_sg_cnt;
-	}
-
-	target_host->sg_tablesize = target->sg_tablesize;
-	target->indirect_size = target->sg_tablesize *
-				sizeof (struct srp_direct_buf);
-	target->max_iu_len = sizeof (struct srp_cmd) +
-			     sizeof (struct srp_indirect_buf) +
-			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
-
 	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
@@ -2717,6 +2750,19 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_mem;
 
+	if (!target->fmr_pool && !target->allow_ext_sg &&
+	    target->cmd_sg_cnt < target->sg_tablesize) {
+		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
+		target->sg_tablesize = target->cmd_sg_cnt;
+	}
+
+	target_host->sg_tablesize = target->sg_tablesize;
+	target->indirect_size = target->sg_tablesize *
+				sizeof(struct srp_direct_buf);
+	target->max_iu_len = sizeof(struct srp_cmd) +
+			     sizeof(struct srp_indirect_buf) +
+			     target->cmd_sg_cnt * sizeof(struct srp_direct_buf);
+
 	ret = srp_new_cm_id(target);
 	if (ret)
 		goto err_free_ib;
@@ -2828,9 +2874,8 @@ static void srp_add_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
 	struct ib_device_attr *dev_attr;
-	struct ib_fmr_pool_param fmr_param;
 	struct srp_host *host;
-	int max_pages_per_fmr, fmr_page_shift, s, e, p;
+	int fmr_page_shift, s, e, p;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2853,7 +2898,10 @@ static void srp_add_one(struct ib_device *device)
 	fmr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
 	srp_dev->fmr_page_size	= 1 << fmr_page_shift;
 	srp_dev->fmr_page_mask	= ~((u64) srp_dev->fmr_page_size - 1);
-	srp_dev->fmr_max_size	= srp_dev->fmr_page_size * SRP_FMR_SIZE;
+	srp_dev->max_pages_per_fmr = min_t(u64, SRP_FMR_SIZE,
+				dev_attr->max_mr_size / srp_dev->fmr_page_size);
+	srp_dev->fmr_max_size	= srp_dev->fmr_page_size *
+				   srp_dev->max_pages_per_fmr;
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
@@ -2869,27 +2917,6 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->mr))
 		goto err_pd;
 
-	for (max_pages_per_fmr = SRP_FMR_SIZE;
-			max_pages_per_fmr >= SRP_FMR_MIN_SIZE;
-			max_pages_per_fmr /= 2, srp_dev->fmr_max_size /= 2) {
-		memset(&fmr_param, 0, sizeof fmr_param);
-		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
-		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
-		fmr_param.cache		    = 1;
-		fmr_param.max_pages_per_fmr = max_pages_per_fmr;
-		fmr_param.page_shift	    = fmr_page_shift;
-		fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
-					       IB_ACCESS_REMOTE_WRITE |
-					       IB_ACCESS_REMOTE_READ);
-
-		srp_dev->fmr_pool = ib_create_fmr_pool(srp_dev->pd, &fmr_param);
-		if (!IS_ERR(srp_dev->fmr_pool))
-			break;
-	}
-
-	if (IS_ERR(srp_dev->fmr_pool))
-		srp_dev->fmr_pool = NULL;
-
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
 		s = 0;
 		e = 0;
@@ -2952,8 +2979,6 @@ static void srp_remove_one(struct ib_device *device)
 		kfree(host);
 	}
 
-	if (srp_dev->fmr_pool)
-		ib_destroy_fmr_pool(srp_dev->fmr_pool);
 	ib_dereg_mr(srp_dev->mr);
 	ib_dealloc_pd(srp_dev->pd);
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index aad27b7..e45379f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -67,9 +67,6 @@ enum {
 	SRP_TAG_TSK_MGMT	= 1U << 31,
 
 	SRP_FMR_SIZE		= 512,
-	SRP_FMR_MIN_SIZE	= 128,
-	SRP_FMR_POOL_SIZE	= 1024,
-	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4,
 
 	SRP_MAP_ALLOW_FMR	= 0,
 	SRP_MAP_NO_FMR		= 1,
@@ -91,10 +88,10 @@ struct srp_device {
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
-	struct ib_fmr_pool     *fmr_pool;
 	u64			fmr_page_mask;
 	int			fmr_page_size;
 	int			fmr_max_size;
+	int			max_pages_per_fmr;
 };
 
 struct srp_host {
@@ -131,6 +128,7 @@ struct srp_target_port {
 	struct ib_cq	       *send_cq ____cacheline_aligned_in_smp;
 	struct ib_cq	       *recv_cq;
 	struct ib_qp	       *qp;
+	struct ib_fmr_pool     *fmr_pool;
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
