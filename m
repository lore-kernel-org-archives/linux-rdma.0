From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 4/8] IB/srp: rework mapping engine to use multiple FMR entries
Date: Tue, 18 Jan 2011 23:27:18 -0500
Message-ID: <1295411242-26148-5-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of forcing all of the S/G entries to fit in one FMR, and falling
back to indirect descriptors if that fails, allow the use of as many
FMRs as needed to map the request. This lays the groundwork for allowing
indirect descriptor tables that are larger than can fit in the command
IU, but should marginally improve performance now by reducing the number
of indirect descriptors needed.

We up the minimum page size for the FMR pool, as it is rare that the
kernel would send down a requests with scattered 512 byte fragments, and
no HCA supports such a small FMR mapping in any case.

This patch also move some of the target initialization code afte the
parsing of options, to keep it together with the new code that needs to
allocate memory based on the options given.
---
 drivers/infiniband/ulp/srp/ib_srp.c |  367 +++++++++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |   28 +++-
 2 files changed, 266 insertions(+), 129 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6f8ee0c..9ce129a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -444,6 +444,17 @@ static bool srp_change_state(struct srp_target_port *target,
 	return changed;
 }
 
+static void srp_free_req_data(struct srp_target_port *target)
+{
+	struct srp_request *req;
+	int i;
+
+	for (i = 0, req = target->req_ring; i < SRP_CMD_SQ_SIZE; ++i, ++req) {
+		kfree(req->fmr_list);
+		kfree(req->map_page);
+	}
+}
+
 static void srp_remove_work(struct work_struct *work)
 {
 	struct srp_target_port *target =
@@ -460,6 +471,7 @@ static void srp_remove_work(struct work_struct *work)
 	scsi_remove_host(target->scsi_host);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
+	srp_free_req_data(target);
 	scsi_host_put(target->scsi_host);
 }
 
@@ -523,18 +535,20 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 			   struct srp_target_port *target,
 			   struct srp_request *req)
 {
+	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
+	struct ib_pool_fmr **pfmr;
+
 	if (!scsi_sglist(scmnd) ||
 	    (scmnd->sc_data_direction != DMA_TO_DEVICE &&
 	     scmnd->sc_data_direction != DMA_FROM_DEVICE))
 		return;
 
-	if (req->fmr) {
-		ib_fmr_pool_unmap(req->fmr);
-		req->fmr = NULL;
-	}
+	pfmr = req->fmr_list;
+	while (req->nfmr--)
+		ib_fmr_pool_unmap(*pfmr++);
 
-	ib_dma_unmap_sg(target->srp_host->srp_dev->dev, scsi_sglist(scmnd),
-			scsi_sg_count(scmnd), scmnd->sc_data_direction);
+	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
+			scmnd->sc_data_direction);
 }
 
 static void srp_remove_req(struct srp_target_port *target,
@@ -633,95 +647,152 @@ err:
 	return ret;
 }
 
-static int srp_map_fmr(struct srp_target_port *target, struct scatterlist *scat,
-		       int sg_cnt, struct srp_request *req,
-		       struct srp_direct_buf *buf)
+static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
+			 unsigned int dma_len, u32 rkey)
 {
-	u64 io_addr = 0;
-	u64 *dma_pages;
-	u32 len;
-	int page_cnt;
-	int i, j;
-	int ret;
-	struct srp_device *dev = target->srp_host->srp_dev;
-	struct ib_device *ibdev = dev->dev;
-	struct scatterlist *sg;
+	struct srp_direct_buf *desc = state->desc;
 
-	if (!dev->fmr_pool)
-		return -ENODEV;
+	desc->va = cpu_to_be64(dma_addr);
+	desc->key = cpu_to_be32(rkey);
+	desc->len = cpu_to_be32(dma_len);
 
-	if (ib_sg_dma_address(ibdev, &scat[0]) & ~dev->fmr_page_mask)
-		return -EINVAL;
+	state->total_len += dma_len;
+	state->desc++;
+	state->ndesc++;
+}
 
-	len = page_cnt = 0;
-	scsi_for_each_sg(req->scmnd, sg, sg_cnt, i) {
-		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
+static int srp_map_finish_fmr(struct srp_map_state *state,
+			      struct srp_target_port *target)
+{
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_pool_fmr *fmr;
+	u64 io_addr = 0;
 
-		if (ib_sg_dma_address(ibdev, sg) & ~dev->fmr_page_mask) {
-			if (i > 0)
-				return -EINVAL;
-			else
-				++page_cnt;
-		}
-		if ((ib_sg_dma_address(ibdev, sg) + dma_len) &
-		    ~dev->fmr_page_mask) {
-			if (i < sg_cnt - 1)
-				return -EINVAL;
-			else
-				++page_cnt;
-		}
+	if (!state->npages)
+		return 0;
 
-		len += dma_len;
+	if (state->npages == 1) {
+		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
+			     target->rkey);
+		state->npages = state->fmr_len = 0;
+		return 0;
 	}
 
-	page_cnt += len >> dev->fmr_page_shift;
-	if (page_cnt > SRP_FMR_SIZE)
-		return -ENOMEM;
+	fmr = ib_fmr_pool_map_phys(dev->fmr_pool, state->pages,
+				   state->npages, io_addr);
+	if (IS_ERR(fmr))
+		return PTR_ERR(fmr);
 
-	dma_pages = kmalloc(sizeof (u64) * page_cnt, GFP_ATOMIC);
-	if (!dma_pages)
-		return -ENOMEM;
+	*state->next_fmr++ = fmr;
+	state->nfmr++;
 
-	page_cnt = 0;
-	scsi_for_each_sg(req->scmnd, sg, sg_cnt, i) {
-		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
+	srp_map_desc(state, 0, state->fmr_len, fmr->fmr->rkey);
+	state->npages = state->fmr_len = 0;
+	return 0;
+}
+
+static void srp_map_update_start(struct srp_map_state *state,
+				 struct scatterlist *sg, int sg_index,
+				 dma_addr_t dma_addr)
+{
+	state->unmapped_sg = sg;
+	state->unmapped_index = sg_index;
+	state->unmapped_addr = dma_addr;
+}
 
-		for (j = 0; j < dma_len; j += dev->fmr_page_size)
-			dma_pages[page_cnt++] =
-				(ib_sg_dma_address(ibdev, sg) &
-				 dev->fmr_page_mask) + j;
+static int srp_map_sg_entry(struct srp_map_state *state,
+			    struct srp_target_port *target,
+			    struct scatterlist *sg, int sg_index,
+			    int use_fmr)
+{
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct ib_device *ibdev = dev->dev;
+	dma_addr_t dma_addr = ib_sg_dma_address(ibdev, sg);
+	unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
+	unsigned int len;
+	int ret;
+
+	if (!dma_len)
+		return 0;
+
+	if (use_fmr == SRP_MAP_NO_FMR) {
+		/* Once we're in direct map mode for a request, we don't
+		 * go back to FMR mode, so no need to update anything
+		 * other than the descriptor.
+		 */
+		srp_map_desc(state, dma_addr, dma_len, target->rkey);
+		return 0;
 	}
 
-	req->fmr = ib_fmr_pool_map_phys(dev->fmr_pool,
-					dma_pages, page_cnt, io_addr);
-	if (IS_ERR(req->fmr)) {
-		ret = PTR_ERR(req->fmr);
-		req->fmr = NULL;
-		goto out;
+	/* If we start at an offset into the FMR page, don't merge into
+	 * the current FMR. Finish it out, and use the kernel's MR for this
+	 * sg entry. This is to avoid potential bugs on some SRP targets
+	 * that were never quite defined, but went away when the initiator
+	 * avoided using FMR on such page fragments.
+	 */
+	if (dma_addr & ~dev->fmr_page_mask || dma_len > dev->fmr_max_size) {
+		ret = srp_map_finish_fmr(state, target);
+		if (ret)
+			return ret;
+
+		srp_map_desc(state, dma_addr, dma_len, target->rkey);
+		srp_map_update_start(state, NULL, 0, 0);
+		return 0;
 	}
 
-	buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, &scat[0]) &
-			       ~dev->fmr_page_mask);
-	buf->key = cpu_to_be32(req->fmr->fmr->rkey);
-	buf->len = cpu_to_be32(len);
+	/* If this is the first sg to go into the FMR, save our position.
+	 * We need to know the first unmapped entry, its index, and the
+	 * first unmapped address within that entry to be able to restart
+	 * mapping after an error.
+	 */
+	if (!state->unmapped_sg)
+		srp_map_update_start(state, sg, sg_index, dma_addr);
 
-	ret = 0;
+	while (dma_len) {
+		if (state->npages == SRP_FMR_SIZE) {
+			ret = srp_map_finish_fmr(state, target);
+			if (ret)
+				return ret;
 
-out:
-	kfree(dma_pages);
+			srp_map_update_start(state, sg, sg_index, dma_addr);
+		}
+
+		len = min_t(unsigned int, dma_len, dev->fmr_page_size);
 
+		if (!state->npages)
+			state->base_dma_addr = dma_addr;
+		state->pages[state->npages++] = dma_addr;
+		state->fmr_len += len;
+		dma_addr += len;
+		dma_len -= len;
+	}
+
+	/* If the last entry of the FMR wasn't a full page, then we need to
+	 * close it out and start a new one -- we can only merge at page
+	 * boundries.
+	 */
+	ret = 0;
+	if (len != dev->fmr_page_size) {
+		ret = srp_map_finish_fmr(state, target);
+		if (!ret)
+			srp_map_update_start(state, NULL, 0, 0);
+	}
 	return ret;
 }
 
 static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 			struct srp_request *req)
 {
-	struct scatterlist *scat;
+	struct scatterlist *scat, *sg;
 	struct srp_cmd *cmd = req->cmd->buf;
-	int len, nents, count;
-	u8 fmt = SRP_DATA_DESC_DIRECT;
+	int i, len, nents, count, use_fmr;
 	struct srp_device *dev;
 	struct ib_device *ibdev;
+	struct srp_map_state state;
+	struct srp_indirect_buf *indirect_hdr;
+	dma_addr_t indirect_addr;
+	u32 table_len;
+	u8 fmt;
 
 	if (!scsi_sglist(scmnd) || scmnd->sc_data_direction == DMA_NONE)
 		return sizeof (struct srp_cmd);
@@ -741,6 +812,8 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	ibdev = dev->dev;
 
 	count = ib_dma_map_sg(ibdev, scat, nents, scmnd->sc_data_direction);
+	if (unlikely(count == 0))
+		return -EIO;
 
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
@@ -757,49 +830,80 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
 		buf->key = cpu_to_be32(target->rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
-	} else if (srp_map_fmr(target, scat, count, req,
-			       (void *) cmd->add_data)) {
-		/*
-		 * FMR mapping failed, and the scatterlist has more
-		 * than one entry.  Generate an indirect memory
-		 * descriptor.
-		 */
-		struct srp_indirect_buf *buf = (void *) cmd->add_data;
-		struct scatterlist *sg;
-		u32 datalen = 0;
-		int i;
-
-		fmt = SRP_DATA_DESC_INDIRECT;
-		len = sizeof (struct srp_cmd) +
-			sizeof (struct srp_indirect_buf) +
-			count * sizeof (struct srp_direct_buf);
-
-		scsi_for_each_sg(scmnd, sg, count, i) {
-			unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
-
-			buf->desc_list[i].va  =
-				cpu_to_be64(ib_sg_dma_address(ibdev, sg));
-			buf->desc_list[i].key =
-				cpu_to_be32(target->rkey);
-			buf->desc_list[i].len = cpu_to_be32(dma_len);
-			datalen += dma_len;
+
+		req->nfmr = 0;
+		goto map_complete;
+	}
+
+	/* We have more than one scatter/gather entry, so build our indirect
+	 * descriptor table, trying to merge as many entries with FMR as we
+	 * can.
+	 */
+	indirect_hdr = (void *) cmd->add_data;
+
+	memset(&state, 0, sizeof(state));
+	state.desc	= indirect_hdr->desc_list;
+	state.pages	= req->map_page;
+	state.next_fmr	= req->fmr_list;
+
+	use_fmr = dev->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
+
+	for_each_sg(scat, sg, count, i) {
+		if (srp_map_sg_entry(&state, target, sg, i, use_fmr)) {
+			/* FMR mapping failed, so backtrack to the first
+			 * unmapped entry and continue on without using FMR.
+			 */
+			dma_addr_t dma_addr;
+			unsigned int dma_len;
+
+backtrack:
+			sg = state.unmapped_sg;
+			i = state.unmapped_index;
+
+			dma_addr = ib_sg_dma_address(ibdev, sg);
+			dma_len = ib_sg_dma_len(ibdev, sg);
+			dma_len -= (state.unmapped_addr - dma_addr);
+			dma_addr = state.unmapped_addr;
+			use_fmr = SRP_MAP_NO_FMR;
+			srp_map_desc(&state, dma_addr, dma_len, target->rkey);
 		}
+	}
 
-		if (scmnd->sc_data_direction == DMA_TO_DEVICE)
-			cmd->data_out_desc_cnt = count;
-		else
-			cmd->data_in_desc_cnt = count;
+	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_map_finish_fmr(&state, target))
+		goto backtrack;
 
-		buf->table_desc.va  =
-			cpu_to_be64(req->cmd->dma + sizeof *cmd + sizeof *buf);
-		buf->table_desc.key =
-			cpu_to_be32(target->rkey);
-		buf->table_desc.len =
-			cpu_to_be32(count * sizeof (struct srp_direct_buf));
+	/* We've mapped the request, fill in the command buffer.
+	 */
+	req->nfmr = state.nfmr;
+	if (state.ndesc == 1) {
+		/* FMR mapping was able to collapse this to one entry,
+		 * so use a direct descriptor.
+		 */
+		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
-		buf->len = cpu_to_be32(datalen);
+		*buf = indirect_hdr->desc_list[0];
+		goto map_complete;
 	}
 
+	table_len = state.ndesc * sizeof (struct srp_direct_buf);
+
+	fmt = SRP_DATA_DESC_INDIRECT;
+	len = sizeof(struct srp_cmd) + sizeof (struct srp_indirect_buf);
+	len += table_len;
+
+	indirect_addr = req->cmd->dma + sizeof *cmd + sizeof *indirect_hdr;
+
+	indirect_hdr->table_desc.va = cpu_to_be64(indirect_addr);
+	indirect_hdr->table_desc.key = cpu_to_be32(target->rkey);
+	indirect_hdr->table_desc.len = cpu_to_be32(table_len);
+	indirect_hdr->len = cpu_to_be32(state.total_len);
+
+	if (scmnd->sc_data_direction == DMA_TO_DEVICE)
+		cmd->data_out_desc_cnt = state.ndesc;
+	else
+		cmd->data_in_desc_cnt = state.ndesc;
+
+map_complete:
 	if (scmnd->sc_data_direction == DMA_TO_DEVICE)
 		cmd->buf_fmt = fmt << 4;
 	else
@@ -1947,8 +2051,7 @@ static ssize_t srp_create_target(struct device *dev,
 		container_of(dev, struct srp_host, dev);
 	struct Scsi_Host *target_host;
 	struct srp_target_port *target;
-	int ret;
-	int i;
+	int i, ret;
 
 	target_host = scsi_host_alloc(&srp_template,
 				      sizeof (struct srp_target_port));
@@ -1968,14 +2071,6 @@ static ssize_t srp_create_target(struct device *dev,
 	target->rkey		= host->srp_dev->mr->rkey;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 
-	spin_lock_init(&target->lock);
-	INIT_LIST_HEAD(&target->free_tx);
-	INIT_LIST_HEAD(&target->free_reqs);
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
-		target->req_ring[i].index = i;
-		list_add_tail(&target->req_ring[i].list, &target->free_reqs);
-	}
-
 	ret = srp_parse_options(buf, target);
 	if (ret)
 		goto err;
@@ -1985,6 +2080,23 @@ static ssize_t srp_create_target(struct device *dev,
 			     sizeof (struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
+	spin_lock_init(&target->lock);
+	INIT_LIST_HEAD(&target->free_tx);
+	INIT_LIST_HEAD(&target->free_reqs);
+	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+		struct srp_request *req = &target->req_ring[i];
+
+		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof (void *),
+					GFP_KERNEL);
+		req->map_page = kmalloc(SRP_FMR_SIZE * sizeof (void *),
+					GFP_KERNEL);
+		if (!req->fmr_list || !req->map_page)
+			goto err_free_mem;
+
+		req->index = i;
+		list_add_tail(&req->list, &target->free_reqs);
+	}
+
 	ib_query_gid(host->srp_dev->dev, host->port, 0, &target->path.sgid);
 
 	shost_printk(KERN_DEBUG, target->scsi_host, PFX
@@ -1998,11 +2110,11 @@ static ssize_t srp_create_target(struct device *dev,
 
 	ret = srp_create_target_ib(target);
 	if (ret)
-		goto err;
+		goto err_free_mem;
 
 	ret = srp_new_cm_id(target);
 	if (ret)
-		goto err_free;
+		goto err_free_ib;
 
 	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
@@ -2024,9 +2136,12 @@ err_disconnect:
 err_cm_id:
 	ib_destroy_cm_id(target->cm_id);
 
-err_free:
+err_free_ib:
 	srp_free_target_ib(target);
 
+err_free_mem:
+	srp_free_req_data(target);
+
 err:
 	scsi_host_put(target_host);
 
@@ -2099,7 +2214,7 @@ static void srp_add_one(struct ib_device *device)
 	struct ib_device_attr *dev_attr;
 	struct ib_fmr_pool_param fmr_param;
 	struct srp_host *host;
-	int s, e, p;
+	int fmr_page_shift, s, e, p;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2117,12 +2232,13 @@ static void srp_add_one(struct ib_device *device)
 
 	/*
 	 * Use the smallest page size supported by the HCA, down to a
-	 * minimum of 512 bytes (which is the smallest sector that a
-	 * SCSI command will ever carry).
+	 * minimum of 4096 bytes. We're unlikely to build large sglists
+	 * out of smaller entries.
 	 */
-	srp_dev->fmr_page_shift = max(9, ffs(dev_attr->page_size_cap) - 1);
-	srp_dev->fmr_page_size  = 1 << srp_dev->fmr_page_shift;
-	srp_dev->fmr_page_mask  = ~((u64) srp_dev->fmr_page_size - 1);
+	fmr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
+	srp_dev->fmr_page_size	= 1 << fmr_page_shift;
+	srp_dev->fmr_page_mask	= ~((u64) srp_dev->fmr_page_size - 1);
+	srp_dev->fmr_max_size	= srp_dev->fmr_page_size * SRP_FMR_SIZE;
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
@@ -2143,7 +2259,7 @@ static void srp_add_one(struct ib_device *device)
 	fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
 	fmr_param.cache		    = 1;
 	fmr_param.max_pages_per_fmr = SRP_FMR_SIZE;
-	fmr_param.page_shift	    = srp_dev->fmr_page_shift;
+	fmr_param.page_shift	    = fmr_page_shift;
 	fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
 				       IB_ACCESS_REMOTE_WRITE |
 				       IB_ACCESS_REMOTE_READ);
@@ -2223,6 +2339,7 @@ static void srp_remove_one(struct ib_device *device)
 			srp_disconnect_target(target);
 			ib_destroy_cm_id(target->cm_id);
 			srp_free_target_ib(target);
+			srp_free_req_data(target);
 			scsi_host_put(target->scsi_host);
 		}
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index db39dbf..b43b5e7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -71,7 +71,10 @@ enum {
 
 	SRP_FMR_SIZE		= 256,
 	SRP_FMR_POOL_SIZE	= 1024,
-	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4
+	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4,
+
+	SRP_MAP_ALLOW_FMR	= 0,
+	SRP_MAP_NO_FMR		= 1,
 };
 
 enum srp_target_state {
@@ -93,9 +96,9 @@ struct srp_device {
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
 	struct ib_fmr_pool     *fmr_pool;
-	int			fmr_page_shift;
-	int			fmr_page_size;
 	u64			fmr_page_mask;
+	int			fmr_page_size;
+	int			fmr_max_size;
 };
 
 struct srp_host {
@@ -112,7 +115,9 @@ struct srp_request {
 	struct list_head	list;
 	struct scsi_cmnd       *scmnd;
 	struct srp_iu	       *cmd;
-	struct ib_pool_fmr     *fmr;
+	struct ib_pool_fmr    **fmr_list;
+	u64		       *map_page;
+	short			nfmr;
 	short			index;
 };
 
@@ -181,4 +186,19 @@ struct srp_iu {
 	enum dma_data_direction	direction;
 };
 
+struct srp_map_state {
+	struct ib_pool_fmr    **next_fmr;
+	struct srp_direct_buf  *desc;
+	u64		       *pages;
+	dma_addr_t		base_dma_addr;
+	u32			fmr_len;
+	u32			total_len;
+	unsigned int		npages;
+	unsigned int		nfmr;
+	unsigned int		ndesc;
+	struct scatterlist     *unmapped_sg;
+	int			unmapped_index;
+	dma_addr_t		unmapped_addr;
+};
+
 #endif /* IB_SRP_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
