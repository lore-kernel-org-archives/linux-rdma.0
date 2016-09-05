From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 4/6] IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Mon,  5 Sep 2016 12:56:19 +0200
Message-ID: <1473072981-2035-5-git-send-email-hch@lst.de>
References: <1473072981-2035-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473072981-2035-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 44 ++++++++++++++++---------------------
 drivers/infiniband/ulp/srp/ib_srp.h |  3 +--
 2 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 579b8ae..5ed1e88 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1262,6 +1262,7 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_pd *pd = target->pd;
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
@@ -1273,9 +1274,9 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	if (state->npages == 0)
 		return 0;
 
-	if (state->npages == 1 && target->global_mr) {
+	if (state->npages == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
-			     target->global_mr->rkey);
+			     pd->unsafe_global_rkey);
 		goto reset_state;
 	}
 
@@ -1315,6 +1316,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_pd *pd = target->pd;
 	struct ib_send_wr *bad_wr;
 	struct ib_reg_wr wr;
 	struct srp_fr_desc *desc;
@@ -1326,12 +1328,12 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 
 	WARN_ON_ONCE(!dev->use_fast_reg);
 
-	if (sg_nents == 1 && target->global_mr) {
+	if (sg_nents == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
 
 		srp_map_desc(state, sg_dma_address(state->sg) + sg_offset,
 			     sg_dma_len(state->sg) - sg_offset,
-			     target->global_mr->rkey);
+			     pd->unsafe_global_rkey);
 		if (sg_offset_p)
 			*sg_offset_p = 0;
 		return 1;
@@ -1491,7 +1493,7 @@ static int srp_map_sg_dma(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	for_each_sg(scat, sg, count, i) {
 		srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
 			     ib_sg_dma_len(dev->dev, sg),
-			     target->global_mr->rkey);
+			     target->pd->unsafe_global_rkey);
 	}
 
 	return 0;
@@ -1591,6 +1593,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 			struct srp_request *req)
 {
 	struct srp_target_port *target = ch->target;
+	struct ib_pd *pd = target->pd;
 	struct scatterlist *scat;
 	struct srp_cmd *cmd = req->cmd->buf;
 	int len, nents, count, ret;
@@ -1626,7 +1629,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
 
-	if (count == 1 && target->global_mr) {
+	if (count == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		/*
 		 * The midlayer only generated a single gather/scatter
 		 * entry, or DMA mapping coalesced everything to a
@@ -1636,7 +1639,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
-		buf->key = cpu_to_be32(target->global_mr->rkey);
+		buf->key = cpu_to_be32(pd->unsafe_global_rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
 		req->nmdesc = 0;
@@ -1709,14 +1712,14 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
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
@@ -3268,8 +3271,8 @@ static ssize_t srp_create_target(struct device *dev,
 	target->io_class	= SRP_REV16A_IB_IO_CLASS;
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
+	target->pd		= host->srp_dev->pd;
 	target->lkey		= host->srp_dev->pd->local_dma_lkey;
-	target->global_mr	= host->srp_dev->global_mr;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
@@ -3524,6 +3527,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_host *host;
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
+	unsigned int flags = 0;
 
 	srp_dev = kzalloc(sizeof(*srp_dev), GFP_KERNEL);
 	if (!srp_dev)
@@ -3558,6 +3562,10 @@ static void srp_add_one(struct ib_device *device)
 		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
 	}
 
+	if (never_register || !register_always ||
+	    (!srp_dev->has_fmr && !srp_dev->has_fr))
+		flags |= IB_PD_UNSAFE_GLOBAL_RKEY;
+
 	if (srp_dev->use_fast_reg) {
 		srp_dev->max_pages_per_mr =
 			min_t(u32, srp_dev->max_pages_per_mr,
@@ -3573,19 +3581,10 @@ static void srp_add_one(struct ib_device *device)
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
 	srp_dev->dev = device;
-	srp_dev->pd  = ib_alloc_pd(device, 0);
+	srp_dev->pd  = ib_alloc_pd(device, flags);
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
@@ -3596,9 +3595,6 @@ static void srp_add_one(struct ib_device *device)
 	ib_set_client_data(device, &srp_client, srp_dev);
 	return;
 
-err_pd:
-	ib_dealloc_pd(srp_dev->pd);
-
 free_dev:
 	kfree(srp_dev);
 }
@@ -3638,8 +3634,6 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
 		kfree(host);
 	}
 
-	if (srp_dev->global_mr)
-		ib_dereg_mr(srp_dev->global_mr);
 	ib_dealloc_pd(srp_dev->pd);
 
 	kfree(srp_dev);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 26bb9b0..21c6969 100644
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
@@ -179,7 +178,7 @@ struct srp_target_port {
 	spinlock_t		lock;
 
 	/* read only in the hot path */
-	struct ib_mr		*global_mr;
+	struct ib_pd		*pd;
 	struct srp_rdma_ch	*ch;
 	u32			ch_count;
 	u32			lkey;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
