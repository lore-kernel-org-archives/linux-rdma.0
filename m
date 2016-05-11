From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/6] IB/srp: Prevent mapping failures
Date: Tue, 10 May 2016 17:16:15 -0700
Message-ID: <573279CF.4060006@sandisk.com>
References: <573278D9.4050908@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <573278D9.4050908-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If both max_sectors and the queue_depth are high enough it can
happen that the MR pool is depleted temporarily. This causes
the SRP initiator to report mapping failures. Although the SRP
initiator recovers from such mapping failures, prevent that
this can happen by allocating more memory regions.

Additionally, only enable memory registration if at least two
pages can be registered per memory region.

Reported-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 102 +++++++++++++++++++++++++++++-------
 drivers/infiniband/ulp/srp/ib_srp.h |   1 +
 2 files changed, 84 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e530a77..075cd7a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -468,7 +468,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	struct ib_qp *qp;
 	struct ib_fmr_pool *fmr_pool = NULL;
 	struct srp_fr_pool *fr_pool = NULL;
-	const int m = dev->use_fast_reg ? 3 : 1;
+	const int m = 1 + dev->use_fast_reg * target->mr_per_cmd * 2;
 	int ret;
 
 	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
@@ -849,7 +849,7 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &ch->req_ring[i];
-		mr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
+		mr_list = kmalloc(target->mr_per_cmd * sizeof(void *),
 				  GFP_KERNEL);
 		if (!mr_list)
 			goto out;
@@ -1298,9 +1298,16 @@ static void srp_reg_mr_err_done(struct ib_cq *cq, struct ib_wc *wc)
 	srp_handle_qp_err(cq, wc, "FAST REG");
 }
 
+/*
+ * Map up to sg_nents elements of state->sg where *sg_offset_p is the offset
+ * where to start in the first element. If sg_offset_p != NULL then
+ * *sg_offset_p is updated to the offset in state->sg[retval] of the first
+ * byte that has not yet been mapped.
+ */
 static int srp_map_finish_fr(struct srp_map_state *state,
 			     struct srp_request *req,
-			     struct srp_rdma_ch *ch, int sg_nents)
+			     struct srp_rdma_ch *ch, int sg_nents,
+			     unsigned int *sg_offset_p)
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
@@ -1316,9 +1323,13 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	WARN_ON_ONCE(!dev->use_fast_reg);
 
 	if (sg_nents == 1 && target->global_mr) {
-		srp_map_desc(state, sg_dma_address(state->sg),
-			     sg_dma_len(state->sg),
+		unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
+
+		srp_map_desc(state, sg_dma_address(state->sg) + sg_offset,
+			     sg_dma_len(state->sg) - sg_offset,
 			     target->global_mr->rkey);
+		if (sg_offset_p)
+			*sg_offset_p = 0;
 		return 1;
 	}
 
@@ -1329,15 +1340,18 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	rkey = ib_inc_rkey(desc->mr->rkey);
 	ib_update_fast_reg_key(desc->mr, rkey);
 
-	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, NULL, dev->mr_page_size);
+	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, sg_offset_p,
+			 dev->mr_page_size);
 	if (unlikely(n < 0)) {
 		srp_fr_pool_put(ch->fr_pool, &desc, 1);
-		pr_debug("%s: ib_map_mr_sg(%d) returned %d.\n",
+		pr_debug("%s: ib_map_mr_sg(%d, %d) returned %d.\n",
 			 dev_name(&req->scmnd->device->sdev_gendev), sg_nents,
-			 n);
+			 sg_offset_p ? *sg_offset_p : -1, n);
 		return n;
 	}
 
+	WARN_ON_ONCE(desc->mr->length == 0);
+
 	req->reg_cqe.done = srp_reg_mr_err_done;
 
 	wr.wr.next = NULL;
@@ -1358,8 +1372,10 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 		     desc->mr->length, desc->mr->rkey);
 
 	err = ib_post_send(ch->qp, &wr.wr, &bad_wr);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		WARN_ON_ONCE(err == -ENOMEM);
 		return err;
+	}
 
 	return n;
 }
@@ -1416,7 +1432,7 @@ static int srp_map_sg_fmr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 
 	state->pages = req->map_page;
 	state->fmr.next = req->fmr_list;
-	state->fmr.end = req->fmr_list + ch->target->cmd_sg_cnt;
+	state->fmr.end = req->fmr_list + ch->target->mr_per_cmd;
 
 	for_each_sg(scat, sg, count, i) {
 		ret = srp_map_sg_entry(state, ch, sg, i);
@@ -1435,8 +1451,10 @@ static int srp_map_sg_fr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 			 struct srp_request *req, struct scatterlist *scat,
 			 int count)
 {
+	unsigned int sg_offset = 0;
+
 	state->fr.next = req->fr_list;
-	state->fr.end = req->fr_list + ch->target->cmd_sg_cnt;
+	state->fr.end = req->fr_list + ch->target->mr_per_cmd;
 	state->sg = scat;
 
 	if (count == 0)
@@ -1445,7 +1463,7 @@ static int srp_map_sg_fr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	while (count) {
 		int i, n;
 
-		n = srp_map_finish_fr(state, req, ch, count);
+		n = srp_map_finish_fr(state, req, ch, count, &sg_offset);
 		if (unlikely(n < 0))
 			return n;
 
@@ -1509,9 +1527,10 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 		idb_sg->dma_length = idb_sg->length;	      /* hack^2 */
 #endif
-		ret = srp_map_finish_fr(&state, req, ch, 1);
+		ret = srp_map_finish_fr(&state, req, ch, 1, NULL);
 		if (ret < 0)
 			return ret;
+		WARN_ON_ONCE(ret < 1);
 	} else if (dev->use_fmr) {
 		state.pages = idb_pages;
 		state.pages[0] = (req->indirect_dma_addr &
@@ -2579,6 +2598,20 @@ static int srp_reset_host(struct scsi_cmnd *scmnd)
 	return srp_reconnect_rport(target->rport) == 0 ? SUCCESS : FAILED;
 }
 
+static int srp_slave_alloc(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct srp_target_port *target = host_to_target(shost);
+	struct srp_device *srp_dev = target->srp_host->srp_dev;
+	struct ib_device *ibdev = srp_dev->dev;
+
+	if (!(ibdev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
+		blk_queue_virt_boundary(sdev->request_queue,
+					~srp_dev->mr_page_mask);
+
+	return 0;
+}
+
 static int srp_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -2770,6 +2803,7 @@ static struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
+	.slave_alloc			= srp_slave_alloc,
 	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
@@ -3176,6 +3210,7 @@ static ssize_t srp_create_target(struct device *dev,
 	struct srp_device *srp_dev = host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 	int ret, node_idx, node, cpu, i;
+	unsigned int max_sectors_per_mr, mr_per_cmd = 0;
 	bool multich = false;
 
 	target_host = scsi_host_alloc(&srp_template,
@@ -3232,8 +3267,33 @@ static ssize_t srp_create_target(struct device *dev,
 		target->sg_tablesize = target->cmd_sg_cnt;
 	}
 
+	if (srp_dev->use_fast_reg || srp_dev->use_fmr) {
+		/*
+		 * FR and FMR can only map one HCA page per entry. If the
+		 * start address is not aligned on a HCA page boundary two
+		 * entries will be used for the head and the tail although
+		 * these two entries combined contain at most one HCA page of
+		 * data. Hence the "+ 1" in the calculation below.
+		 *
+		 * The indirect data buffer descriptor is contiguous so the
+		 * memory for that buffer will only be registered if
+		 * register_always is true. Hence add one to mr_per_cmd if
+		 * register_always has been set.
+		 */
+		max_sectors_per_mr = srp_dev->max_pages_per_mr <<
+				  (ilog2(srp_dev->mr_page_size) - 9);
+		mr_per_cmd = register_always +
+			(target->scsi_host->max_sectors + 1 +
+			 max_sectors_per_mr - 1) / max_sectors_per_mr;
+		pr_debug("max_sectors = %u; max_pages_per_mr = %u; mr_page_size = %u; max_sectors_per_mr = %u; mr_per_cmd = %u\n",
+			 target->scsi_host->max_sectors,
+			 srp_dev->max_pages_per_mr, srp_dev->mr_page_size,
+			 max_sectors_per_mr, mr_per_cmd);
+	}
+
 	target_host->sg_tablesize = target->sg_tablesize;
-	target->mr_pool_size = target->scsi_host->can_queue;
+	target->mr_pool_size = target->scsi_host->can_queue * mr_per_cmd;
+	target->mr_per_cmd = mr_per_cmd;
 	target->indirect_size = target->sg_tablesize *
 				sizeof (struct srp_direct_buf);
 	target->max_iu_len = sizeof (struct srp_cmd) +
@@ -3440,6 +3500,9 @@ static void srp_add_one(struct ib_device *device)
 	srp_dev->mr_page_mask	= ~((u64) srp_dev->mr_page_size - 1);
 	max_pages_per_mr	= device->attrs.max_mr_size;
 	do_div(max_pages_per_mr, srp_dev->mr_page_size);
+	pr_debug("%s: %llu / %u = %llu <> %u\n", __func__,
+		 device->attrs.max_mr_size, srp_dev->mr_page_size,
+		 max_pages_per_mr, SRP_MAX_PAGES_PER_MR);
 	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
 					  max_pages_per_mr);
 
@@ -3447,12 +3510,13 @@ static void srp_add_one(struct ib_device *device)
 			    device->map_phys_fmr && device->unmap_fmr);
 	srp_dev->has_fr = (device->attrs.device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!srp_dev->has_fmr && !srp_dev->has_fr)
+	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
-
-	srp_dev->use_fast_reg = (srp_dev->has_fr &&
-				 (!srp_dev->has_fmr || prefer_fr));
-	srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
+	} else if (device->attrs.max_mr_size >= 2 * srp_dev->mr_page_size) {
+		srp_dev->use_fast_reg = (srp_dev->has_fr &&
+					 (!srp_dev->has_fmr || prefer_fr));
+		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
+	}
 
 	if (srp_dev->use_fast_reg) {
 		srp_dev->max_pages_per_mr =
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index a00914c..26bb9b0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -203,6 +203,7 @@ struct srp_target_port {
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
 	int			mr_pool_size;
+	int			mr_per_cmd;
 	int			queue_size;
 	int			req_ring_size;
 	int			comp_vector;
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
