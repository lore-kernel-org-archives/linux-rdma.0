From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 4/6] IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Mon, 29 Aug 2016 12:02:21 +0200
Message-ID: <1472464943-29450-5-git-send-email-hch@lst.de>
References: <1472464943-29450-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472464943-29450-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 39 ++++++++++++++-----------------------
 drivers/infiniband/ulp/srp/ib_srp.h |  2 --
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 579b8ae..06d2ddf 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1273,9 +1273,9 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	if (state->npages == 0)
 		return 0;
 
-	if (state->npages == 1 && target->global_mr) {
+	if (state->npages == 1 && (dev->pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
-			     target->global_mr->rkey);
+			     dev->pd->unsafe_global_rkey);
 		goto reset_state;
 	}
 
@@ -1326,12 +1326,12 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 
 	WARN_ON_ONCE(!dev->use_fast_reg);
 
-	if (sg_nents == 1 && target->global_mr) {
+	if (sg_nents == 1 && (dev->pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
 
 		srp_map_desc(state, sg_dma_address(state->sg) + sg_offset,
 			     sg_dma_len(state->sg) - sg_offset,
-			     target->global_mr->rkey);
+			     dev->pd->unsafe_global_rkey);
 		if (sg_offset_p)
 			*sg_offset_p = 0;
 		return 1;
@@ -1491,7 +1491,7 @@ static int srp_map_sg_dma(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	for_each_sg(scat, sg, count, i) {
 		srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
 			     ib_sg_dma_len(dev->dev, sg),
-			     target->global_mr->rkey);
+			     dev->pd->unsafe_global_rkey);
 	}
 
 	return 0;
@@ -1591,6 +1591,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 			struct srp_request *req)
 {
 	struct srp_target_port *target = ch->target;
+	struct ib_pd *pd = target->srp_host->srp_dev->pd;
 	struct scatterlist *scat;
 	struct srp_cmd *cmd = req->cmd->buf;
 	int len, nents, count, ret;
@@ -1626,7 +1627,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
 
-	if (count == 1 && target->global_mr) {
+	if (count == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		/*
 		 * The midlayer only generated a single gather/scatter
 		 * entry, or DMA mapping coalesced everything to a
@@ -1636,7 +1637,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
-		buf->key = cpu_to_be32(target->global_mr->rkey);
+		buf->key = cpu_to_be32(pd->unsafe_global_rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
 		req->nmdesc = 0;
@@ -1709,14 +1710,14 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	memcpy(indirect_hdr->desc_list, req->indirect_desc,
 	       count * sizeof (struct srp_direct_buf));
 
-	if (!target->global_mr) {
+	if (!(pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		ret = srp_map_idb(ch, req, state.gen.next, state.gen.end,
 				  idb_len, &idb_rkey);
 		if (ret < 0)
 			goto unmap;
 		req->nmdesc++;
 	} else {
-		idb_rkey = cpu_to_be32(target->global_mr->rkey);
+		idb_rkey = cpu_to_be32(pd->unsafe_global_rkey);
 	}
 
 	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
@@ -3269,7 +3270,6 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
 	target->lkey		= host->srp_dev->pd->local_dma_lkey;
-	target->global_mr	= host->srp_dev->global_mr;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
@@ -3524,6 +3524,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_host *host;
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
+	unsigned int flags = 0;
 
 	srp_dev = kzalloc(sizeof(*srp_dev), GFP_KERNEL);
 	if (!srp_dev)
@@ -3558,6 +3559,10 @@ static void srp_add_one(struct ib_device *device)
 		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
 	}
 
+	if (never_register || !register_always ||
+	    (!srp_dev->has_fmr && !srp_dev->has_fr))
+		flags |= IB_PD_UNSAFE_GLOBAL_RKEY;
+
 	if (srp_dev->use_fast_reg) {
 		srp_dev->max_pages_per_mr =
 			min_t(u32, srp_dev->max_pages_per_mr,
@@ -3577,15 +3582,6 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
-	if (never_register || !register_always ||
-	    (!srp_dev->has_fmr && !srp_dev->has_fr)) {
-		srp_dev->global_mr = ib_get_dma_mr(srp_dev->pd,
-						   IB_ACCESS_LOCAL_WRITE |
-						   IB_ACCESS_REMOTE_READ |
-						   IB_ACCESS_REMOTE_WRITE);
-		if (IS_ERR(srp_dev->global_mr))
-			goto err_pd;
-	}
 
 	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
 		host = srp_add_port(srp_dev, p);
@@ -3596,9 +3592,6 @@ static void srp_add_one(struct ib_device *device)
 	ib_set_client_data(device, &srp_client, srp_dev);
 	return;
 
-err_pd:
-	ib_dealloc_pd(srp_dev->pd);
-
 free_dev:
 	kfree(srp_dev);
 }
@@ -3638,8 +3631,6 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
 		kfree(host);
 	}
 
-	if (srp_dev->global_mr)
-		ib_dereg_mr(srp_dev->global_mr);
 	ib_dealloc_pd(srp_dev->pd);
 
 	kfree(srp_dev);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 26bb9b0..446f559 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -90,7 +90,6 @@ struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
-	struct ib_mr	       *global_mr;
 	u64			mr_page_mask;
 	int			mr_page_size;
 	int			mr_max_size;
@@ -179,7 +178,6 @@ struct srp_target_port {
 	spinlock_t		lock;
 
 	/* read only in the hot path */
-	struct ib_mr		*global_mr;
 	struct srp_rdma_ch	*ch;
 	u32			ch_count;
 	u32			lkey;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
