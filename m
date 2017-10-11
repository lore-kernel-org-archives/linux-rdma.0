From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 7/8] IB/srp: Cache global rkey
Date: Wed, 11 Oct 2017 10:27:28 -0700
Message-ID: <20171011172729.16984-8-bart.vanassche@wdc.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011172729.16984-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a micro-optimization for the hot path.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 27 ++++++++++++++-------------
 drivers/infiniband/ulp/srp/ib_srp.h |  3 ++-
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 96750ad253c4..463c3ed440eb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1292,7 +1292,6 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
-	struct ib_pd *pd = target->pd;
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
@@ -1308,9 +1307,9 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	if (state->npages == 0)
 		return 0;
 
-	if (state->npages == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
+	if (state->npages == 1 && target->global_rkey) {
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
-			     pd->unsafe_global_rkey);
+			     target->global_rkey);
 		goto reset_state;
 	}
 
@@ -1350,7 +1349,6 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
-	struct ib_pd *pd = target->pd;
 	struct ib_send_wr *bad_wr;
 	struct ib_reg_wr wr;
 	struct srp_fr_desc *desc;
@@ -1366,12 +1364,12 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 
 	WARN_ON_ONCE(!dev->use_fast_reg);
 
-	if (sg_nents == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
+	if (sg_nents == 1 && target->global_rkey) {
 		unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
 
 		srp_map_desc(state, sg_dma_address(state->sg) + sg_offset,
 			     sg_dma_len(state->sg) - sg_offset,
-			     pd->unsafe_global_rkey);
+			     target->global_rkey);
 		if (sg_offset_p)
 			*sg_offset_p = 0;
 		return 1;
@@ -1533,7 +1531,7 @@ static int srp_map_sg_dma(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	for_each_sg(scat, sg, count, i) {
 		srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
 			     ib_sg_dma_len(dev->dev, sg),
-			     target->pd->unsafe_global_rkey);
+			     target->global_rkey);
 	}
 
 	return 0;
@@ -1631,7 +1629,6 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 			struct srp_request *req)
 {
 	struct srp_target_port *target = ch->target;
-	struct ib_pd *pd = target->pd;
 	struct scatterlist *scat;
 	struct srp_cmd *cmd = req->cmd->buf;
 	int len, nents, count, ret;
@@ -1667,7 +1664,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
 
-	if (count == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
+	if (count == 1 && target->global_rkey) {
 		/*
 		 * The midlayer only generated a single gather/scatter
 		 * entry, or DMA mapping coalesced everything to a
@@ -1677,7 +1674,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
-		buf->key = cpu_to_be32(pd->unsafe_global_rkey);
+		buf->key = cpu_to_be32(target->global_rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
 		req->nmdesc = 0;
@@ -1748,14 +1745,14 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	memcpy(indirect_hdr->desc_list, req->indirect_desc,
 	       count * sizeof (struct srp_direct_buf));
 
-	if (!(pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
+	if (!target->global_rkey) {
 		ret = srp_map_idb(ch, req, state.gen.next, state.gen.end,
 				  idb_len, &idb_rkey);
 		if (ret < 0)
 			goto unmap;
 		req->nmdesc++;
 	} else {
-		idb_rkey = cpu_to_be32(pd->unsafe_global_rkey);
+		idb_rkey = cpu_to_be32(target->global_rkey);
 	}
 
 	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
@@ -3331,8 +3328,8 @@ static ssize_t srp_create_target(struct device *dev,
 	target->io_class	= SRP_REV16A_IB_IO_CLASS;
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
-	target->pd		= host->srp_dev->pd;
 	target->lkey		= host->srp_dev->pd->local_dma_lkey;
+	target->global_rkey	= host->srp_dev->global_rkey;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
@@ -3651,6 +3648,10 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
+	if (flags & IB_PD_UNSAFE_GLOBAL_RKEY) {
+		srp_dev->global_rkey = srp_dev->pd->unsafe_global_rkey;
+		WARN_ON_ONCE(srp_dev->global_rkey == 0);
+	}
 
 	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
 		host = srp_add_port(srp_dev, p);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index ab9077b81d5a..a814f5ef16f9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -90,6 +90,7 @@ struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
+	u32			global_rkey;
 	u64			mr_page_mask;
 	int			mr_page_size;
 	int			mr_max_size;
@@ -179,7 +180,7 @@ struct srp_target_port {
 	spinlock_t		lock;
 
 	/* read only in the hot path */
-	struct ib_pd		*pd;
+	u32			global_rkey;
 	struct srp_rdma_ch	*ch;
 	u32			ch_count;
 	u32			lkey;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
