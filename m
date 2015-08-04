From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v3] IB/srp: Do not create an all physical insecure rkey by
 default
Date: Tue, 4 Aug 2015 12:56:40 -0600
Message-ID: <20150804185640.GA10934@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ULP only needs this if the insecure register_always performance
optimization is enabled, or if FRWR/FMR is not supported in the driver.

This is a WIP for this functionality, there are several WARN_ONs in
this patch that can be hit under certain work loads. Additional patches
will be needed to re-arrange each of those cases appropriately.

This patch also changes the default mode to FRWR as FMR will always
hit a WARN_ON.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 72 ++++++++++++++++++++++++++-----------
 drivers/infiniband/ulp/srp/ib_srp.h |  4 +--
 2 files changed, 53 insertions(+), 23 deletions(-)

This version includes the changes Christoph and Bart requested, it
might work a bit out of the box now.
 - Make prefer_fr = true
 - Get rid of taget->rkey and use a mr pointer instead.
   Check the mr pointer for null before every usage.
   This gets rid of register_always checks in the data flow.

Doug, as discussed, this patch is still known not to work, the two
cases that were ID's are guarded by WARN_ON's that will trigger.

Someone else more familiar with SRP will need to build additional
patches to correct those cases. They can be done incrementally before
this patch by testing for register_always.

This is probably unmergable until all the WARN_ONs are fully audited and
removed after proving they cannot trigger.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 19a1356f8b2a..22d936d47f71 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -68,8 +68,8 @@ static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
-static bool prefer_fr;
-static bool register_always;
+static bool prefer_fr = true;
+static bool register_always = true;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -1338,9 +1338,9 @@ static int srp_finish_mapping(struct srp_map_state *state,
 	if (state->npages == 0)
 		return 0;
 
-	if (state->npages == 1 && !register_always)
+	if (state->npages == 1 && target->global_rkey_mr)
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
-			     target->rkey);
+			     target->global_rkey_mr->rkey);
 	else
 		ret = target->srp_host->srp_dev->use_fast_reg ?
 			srp_map_finish_fr(state, ch) :
@@ -1385,7 +1385,11 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 		 * go back to FMR or FR mode, so no need to update anything
 		 * other than the descriptor.
 		 */
-		srp_map_desc(state, dma_addr, dma_len, target->rkey);
+		if (WARN_ON(!target->global_rkey_mr))
+			return -EINVAL;
+
+		srp_map_desc(state, dma_addr, dma_len,
+			     target->global_rkey_mr->rkey);
 		return 0;
 	}
 
@@ -1397,11 +1401,14 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 */
 	if ((!dev->use_fast_reg && dma_addr & ~dev->mr_page_mask) ||
 	    dma_len > dev->mr_max_size) {
+		if (WARN_ON(!target->global_rkey_mr))
+			return -EINVAL;
 		ret = srp_finish_mapping(state, ch);
 		if (ret)
 			return ret;
 
-		srp_map_desc(state, dma_addr, dma_len, target->rkey);
+		srp_map_desc(state, dma_addr, dma_len,
+			     target->global_rkey_mr->rkey);
 		srp_map_update_start(state, NULL, 0, 0);
 		return 0;
 	}
@@ -1462,12 +1469,16 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 
 	state->desc	= req->indirect_desc;
 	state->pages	= req->map_page;
+
+	use_mr = !target->global_rkey_mr;
 	if (dev->use_fast_reg) {
 		state->next_fr = req->fr_list;
-		use_mr = !!ch->fr_pool;
+		if (WARN_ON(!ch->fr_pool))
+			return -EINVAL;
 	} else {
 		state->next_fmr = req->fmr_list;
-		use_mr = !!ch->fmr_pool;
+		if (WARN_ON(!ch->fmr_pool))
+			return -EINVAL;
 	}
 
 	for_each_sg(scat, sg, count, i) {
@@ -1489,7 +1500,11 @@ backtrack:
 			dma_len -= (state->unmapped_addr - dma_addr);
 			dma_addr = state->unmapped_addr;
 			use_mr = false;
-			srp_map_desc(state, dma_addr, dma_len, target->rkey);
+			/* FIXME: This is surely the wrong error out */
+			if (WARN_ON(!target->global_rkey_mr))
+				return -EINVAL;
+			srp_map_desc(state, dma_addr, dma_len,
+				     target->global_rkey_mr->rkey);
 		}
 	}
 
@@ -1539,7 +1554,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
 
-	if (count == 1 && !register_always) {
+	if (count == 1 && target->global_rkey_mr) {
 		/*
 		 * The midlayer only generated a single gather/scatter
 		 * entry, or DMA mapping coalesced everything to a
@@ -1549,7 +1564,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
-		buf->key = cpu_to_be32(target->rkey);
+		buf->key = cpu_to_be32(target->global_rkey_mr->rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
 		req->nmdesc = 0;
@@ -1602,8 +1617,12 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	memcpy(indirect_hdr->desc_list, req->indirect_desc,
 	       count * sizeof (struct srp_direct_buf));
 
+	if (WARN_ON(!target->global_rkey_mr))
+		return -EINVAL;
+
 	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
-	indirect_hdr->table_desc.key = cpu_to_be32(target->rkey);
+	indirect_hdr->table_desc.key =
+	    cpu_to_be32(target->global_rkey_mr->rkey);
 	indirect_hdr->table_desc.len = cpu_to_be32(table_len);
 	indirect_hdr->len = cpu_to_be32(state.total_len);
 
@@ -3147,7 +3166,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
 	target->lkey		= host->srp_dev->pd->local_dma_lkey;
-	target->rkey		= host->srp_dev->mr->rkey;
+	target->global_rkey_mr  = host->srp_dev->global_rkey_mr;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
@@ -3378,6 +3397,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_host *host;
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
+	bool need_phys_rkey = false;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -3396,8 +3416,11 @@ static void srp_add_one(struct ib_device *device)
 			    device->map_phys_fmr && device->unmap_fmr);
 	srp_dev->has_fr = (dev_attr->device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!srp_dev->has_fmr && !srp_dev->has_fr)
+	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
+		/* Fall back to using an insecure all physical rkey */
+		need_phys_rkey = true;
+	}
 
 	srp_dev->use_fast_reg = (srp_dev->has_fr &&
 				 (!srp_dev->has_fmr || prefer_fr));
@@ -3433,12 +3456,18 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
-	srp_dev->mr = ib_get_dma_mr(srp_dev->pd,
-				    IB_ACCESS_LOCAL_WRITE |
-				    IB_ACCESS_REMOTE_READ |
-				    IB_ACCESS_REMOTE_WRITE);
-	if (IS_ERR(srp_dev->mr))
-		goto err_pd;
+	if (!register_always)
+		need_phys_rkey = true;
+
+	if (need_phys_rkey) {
+		srp_dev->global_rkey_mr = ib_get_dma_mr(
+		    srp_dev->pd, IB_ACCESS_LOCAL_WRITE |
+				 IB_ACCESS_REMOTE_READ |
+				 IB_ACCESS_REMOTE_WRITE);
+		if (IS_ERR(srp_dev->global_rkey_mr))
+			goto err_pd;
+	} else
+		srp_dev->global_rkey_mr = NULL;
 
 	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
 		host = srp_add_port(srp_dev, p);
@@ -3495,7 +3524,8 @@ static void srp_remove_one(struct ib_device *device)
 		kfree(host);
 	}
 
-	ib_dereg_mr(srp_dev->mr);
+	if (srp_dev->global_rkey_mr)
+		ib_dereg_mr(srp_dev->global_rkey_mr);
 	ib_dealloc_pd(srp_dev->pd);
 
 	kfree(srp_dev);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 17ee3f80ba55..557cc3a73014 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -95,7 +95,7 @@ struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
-	struct ib_mr	       *mr;
+	struct ib_mr	       *global_rkey_mr;
 	u64			mr_page_mask;
 	int			mr_page_size;
 	int			mr_max_size;
@@ -185,7 +185,7 @@ struct srp_target_port {
 	struct srp_rdma_ch	*ch;
 	u32			ch_count;
 	u32			lkey;
-	u32			rkey;
+	struct ib_mr	       *global_rkey_mr;
 	enum srp_target_state	state;
 	unsigned int		max_iu_len;
 	unsigned int		cmd_sg_cnt;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
