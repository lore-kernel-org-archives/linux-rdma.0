From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v4 8/9] IB/srp: Rename FMR-related variables
Date: Tue, 20 May 2014 15:07:45 +0200
Message-ID: <537B53A1.2000008@acm.org>
References: <537B5286.1060504@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537B5286.1060504-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The next patch will cause the renamed variables to be shared between
the code for FMR and for FR memory registration. Make the names of
these variables independent of the memory registration mode. This
patch does not change any functionality. The start of this patch was
the changes applied via the following shell command:

sed -i.orig 's/SRP_FMR_SIZE/SRP_MAX_PAGES_PER_MR/g; \
    s/fmr_page_mask/mr_page_mask/g;s/fmr_page_size/mr_page_size/g; \
    s/fmr_page_shift/mr_page_shift/g;s/fmr_max_size/mr_max_size/g; \
    s/max_pages_per_fmr/max_pages_per_mr/g;s/nfmr/nmdesc/g; \
    s/fmr_len/dma_len/g' drivers/infiniband/ulp/srp/ib_srp.[ch]

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 60 ++++++++++++++++++-------------------
 drivers/infiniband/ulp/srp/ib_srp.h | 16 +++++-----
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 80dfe17..c9b3b9e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -302,8 +302,8 @@ static struct ib_fmr_pool *srp_alloc_fmr_pool(struct srp_target_port *target)
 	fmr_param.pool_size	    = target->scsi_host->can_queue;
 	fmr_param.dirty_watermark   = fmr_param.pool_size / 4;
 	fmr_param.cache		    = 1;
-	fmr_param.max_pages_per_fmr = dev->max_pages_per_fmr;
-	fmr_param.page_shift	    = ilog2(dev->fmr_page_size);
+	fmr_param.max_pages_per_fmr = dev->max_pages_per_mr;
+	fmr_param.page_shift	    = ilog2(dev->mr_page_size);
 	fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
 				       IB_ACCESS_REMOTE_WRITE |
 				       IB_ACCESS_REMOTE_READ);
@@ -657,7 +657,7 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 		req = &target->req_ring[i];
 		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
 					GFP_KERNEL);
-		req->map_page = kmalloc(srp_dev->max_pages_per_fmr *
+		req->map_page = kmalloc(srp_dev->max_pages_per_mr *
 					sizeof(void *), GFP_KERNEL);
 		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
 		if (!req->fmr_list || !req->map_page || !req->indirect_desc)
@@ -810,7 +810,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		return;
 
 	pfmr = req->fmr_list;
-	while (req->nfmr--)
+	while (req->nmdesc--)
 		ib_fmr_pool_unmap(*pfmr++);
 
 	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
@@ -979,9 +979,9 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 		return PTR_ERR(fmr);
 
 	*state->next_fmr++ = fmr;
-	state->nfmr++;
+	state->nmdesc++;
 
-	srp_map_desc(state, 0, state->fmr_len, fmr->fmr->rkey);
+	srp_map_desc(state, 0, state->dma_len, fmr->fmr->rkey);
 
 	return 0;
 }
@@ -995,14 +995,14 @@ static int srp_finish_mapping(struct srp_map_state *state,
 		return 0;
 
 	if (state->npages == 1 && !register_always)
-		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
+		srp_map_desc(state, state->base_dma_addr, state->dma_len,
 			     target->rkey);
 	else
 		ret = srp_map_finish_fmr(state, target);
 
 	if (ret == 0) {
 		state->npages = 0;
-		state->fmr_len = 0;
+		state->dma_len = 0;
 	}
 
 	return ret;
@@ -1047,7 +1047,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 * that were never quite defined, but went away when the initiator
 	 * avoided using FMR on such page fragments.
 	 */
-	if (dma_addr & ~dev->fmr_page_mask || dma_len > dev->fmr_max_size) {
+	if (dma_addr & ~dev->mr_page_mask || dma_len > dev->mr_max_size) {
 		ret = srp_finish_mapping(state, target);
 		if (ret)
 			return ret;
@@ -1066,7 +1066,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 		srp_map_update_start(state, sg, sg_index, dma_addr);
 
 	while (dma_len) {
-		if (state->npages == dev->max_pages_per_fmr) {
+		if (state->npages == dev->max_pages_per_mr) {
 			ret = srp_finish_mapping(state, target);
 			if (ret)
 				return ret;
@@ -1074,12 +1074,12 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 			srp_map_update_start(state, sg, sg_index, dma_addr);
 		}
 
-		len = min_t(unsigned int, dma_len, dev->fmr_page_size);
+		len = min_t(unsigned int, dma_len, dev->mr_page_size);
 
 		if (!state->npages)
 			state->base_dma_addr = dma_addr;
 		state->pages[state->npages++] = dma_addr;
-		state->fmr_len += len;
+		state->dma_len += len;
 		dma_addr += len;
 		dma_len -= len;
 	}
@@ -1089,7 +1089,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 * boundries.
 	 */
 	ret = 0;
-	if (len != dev->fmr_page_size) {
+	if (len != dev->mr_page_size) {
 		ret = srp_finish_mapping(state, target);
 		if (!ret)
 			srp_map_update_start(state, NULL, 0, 0);
@@ -1136,7 +1136,7 @@ backtrack:
 	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_finish_mapping(state, target))
 		goto backtrack;
 
-	req->nfmr = state->nfmr;
+	req->nmdesc = state->nmdesc;
 }
 
 static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
@@ -1189,7 +1189,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		buf->key = cpu_to_be32(target->rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
-		req->nfmr = 0;
+		req->nmdesc = 0;
 		goto map_complete;
 	}
 
@@ -1637,7 +1637,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		/*
 		 * If we ran out of memory descriptors (-ENOMEM) because an
 		 * application is queuing many requests with more than
-		 * max_pages_per_fmr sg-list elements, tell the SCSI mid-layer
+		 * max_pages_per_mr sg-list elements, tell the SCSI mid-layer
 		 * to reduce queue depth temporarily.
 		 */
 		scmnd->result = len == -ENOMEM ?
@@ -2878,8 +2878,8 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_device *srp_dev;
 	struct ib_device_attr *dev_attr;
 	struct srp_host *host;
-	int fmr_page_shift, s, e, p;
-	u64 max_pages_per_fmr;
+	int mr_page_shift, s, e, p;
+	u64 max_pages_per_mr;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2902,18 +2902,18 @@ static void srp_add_one(struct ib_device *device)
 	 * minimum of 4096 bytes. We're unlikely to build large sglists
 	 * out of smaller entries.
 	 */
-	fmr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
-	srp_dev->fmr_page_size	= 1 << fmr_page_shift;
-	srp_dev->fmr_page_mask	= ~((u64) srp_dev->fmr_page_size - 1);
-	max_pages_per_fmr	= dev_attr->max_mr_size;
-	do_div(max_pages_per_fmr, srp_dev->fmr_page_size);
-	srp_dev->max_pages_per_fmr = min_t(u64, SRP_FMR_SIZE,
-					   max_pages_per_fmr);
-	srp_dev->fmr_max_size	= srp_dev->fmr_page_size *
-				   srp_dev->max_pages_per_fmr;
-	pr_debug("%s: fmr_page_shift = %d, dev_attr->max_mr_size = %#llx, max_pages_per_fmr = %d, fmr_max_size = %#x\n",
-		 device->name, fmr_page_shift, dev_attr->max_mr_size,
-		 srp_dev->max_pages_per_fmr, srp_dev->fmr_max_size);
+	mr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
+	srp_dev->mr_page_size	= 1 << mr_page_shift;
+	srp_dev->mr_page_mask	= ~((u64) srp_dev->mr_page_size - 1);
+	max_pages_per_mr	= dev_attr->max_mr_size;
+	do_div(max_pages_per_mr, srp_dev->mr_page_size);
+	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
+					  max_pages_per_mr);
+	srp_dev->mr_max_size	= srp_dev->mr_page_size *
+				   srp_dev->max_pages_per_mr;
+	pr_debug("%s: mr_page_shift = %d, dev_attr->max_mr_size = %#llx, max_pages_per_mr = %d, mr_max_size = %#x\n",
+		 device->name, mr_page_shift, dev_attr->max_mr_size,
+		 srp_dev->max_pages_per_mr, srp_dev->mr_max_size);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 2d99e52..eb130486 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -66,7 +66,7 @@ enum {
 	SRP_TAG_NO_REQ		= ~0U,
 	SRP_TAG_TSK_MGMT	= 1U << 31,
 
-	SRP_FMR_SIZE		= 512,
+	SRP_MAX_PAGES_PER_MR	= 512,
 
 	SRP_MAP_ALLOW_FMR	= 0,
 	SRP_MAP_NO_FMR		= 1,
@@ -88,10 +88,10 @@ struct srp_device {
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
-	u64			fmr_page_mask;
-	int			fmr_page_size;
-	int			fmr_max_size;
-	int			max_pages_per_fmr;
+	u64			mr_page_mask;
+	int			mr_page_size;
+	int			mr_max_size;
+	int			max_pages_per_mr;
 	bool			has_fmr;
 };
 
@@ -114,7 +114,7 @@ struct srp_request {
 	u64		       *map_page;
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
-	short			nfmr;
+	short			nmdesc;
 	short			index;
 };
 
@@ -201,10 +201,10 @@ struct srp_map_state {
 	struct srp_direct_buf  *desc;
 	u64		       *pages;
 	dma_addr_t		base_dma_addr;
-	u32			fmr_len;
+	u32			dma_len;
 	u32			total_len;
 	unsigned int		npages;
-	unsigned int		nfmr;
+	unsigned int		nmdesc;
 	unsigned int		ndesc;
 	struct scatterlist     *unmapped_sg;
 	int			unmapped_index;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
