From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 8/9] IB/srp: Rename FMR-related variables
Date: Tue, 06 May 2014 14:56:09 +0200
Message-ID: <5368DBE9.1070208@acm.org>
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

The next patch will cause the renamed variables to be shared between
the code for FMR and for FR memory registration. Make the names of
these variables independent of the memory registration mode. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 44 ++++++++++++++++++-------------------
 drivers/infiniband/ulp/srp/ib_srp.h | 18 +++++++--------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index af94381..017de46 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -626,7 +626,7 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 		req = &req_ring[i];
 		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
 					GFP_KERNEL);
-		req->map_page = kmalloc(SRP_FMR_SIZE * sizeof(void *),
+		req->map_page = kmalloc(SRP_MAX_PAGES_PER_MR * sizeof(void *),
 					GFP_KERNEL);
 		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
 		if (!req->fmr_list || !req->map_page || !req->indirect_desc)
@@ -784,7 +784,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		return;
 
 	pfmr = req->fmr_list;
-	while (req->nfmr--)
+	while (req->nmdesc--)
 		ib_fmr_pool_unmap(*pfmr++);
 
 	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
@@ -954,9 +954,9 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 		return PTR_ERR(fmr);
 
 	*state->next_fmr++ = fmr;
-	state->nfmr++;
+	state->nmdesc++;
 
-	srp_map_desc(state, 0, state->fmr_len, fmr->fmr->rkey);
+	srp_map_desc(state, 0, state->dma_len, fmr->fmr->rkey);
 
 	return 0;
 }
@@ -970,7 +970,7 @@ static int srp_finish_mapping(struct srp_map_state *state,
 		return 0;
 
 	if (state->npages == 1) {
-		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
+		srp_map_desc(state, state->base_dma_addr, state->dma_len,
 			     target->rkey);
 	} else {
 		ret = srp_map_finish_fmr(state, target);
@@ -978,7 +978,7 @@ static int srp_finish_mapping(struct srp_map_state *state,
 
 	if (ret == 0) {
 		state->npages = 0;
-		state->fmr_len = 0;
+		state->dma_len = 0;
 	}
 
 	return ret;
@@ -1023,7 +1023,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 * that were never quite defined, but went away when the initiator
 	 * avoided using FMR on such page fragments.
 	 */
-	if (dma_addr & ~dev->fmr_page_mask || dma_len > dev->fmr_max_size) {
+	if (dma_addr & ~dev->mr_page_mask || dma_len > dev->fmr_max_size) {
 		ret = srp_finish_mapping(state, target);
 		if (ret)
 			return ret;
@@ -1042,7 +1042,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 		srp_map_update_start(state, sg, sg_index, dma_addr);
 
 	while (dma_len) {
-		if (state->npages == SRP_FMR_SIZE) {
+		if (state->npages == SRP_MAX_PAGES_PER_MR) {
 			ret = srp_map_finish_fmr(state, target);
 			if (ret)
 				return ret;
@@ -1050,12 +1050,12 @@ static int srp_map_sg_entry(struct srp_map_state *state,
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
@@ -1065,7 +1065,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 * boundries.
 	 */
 	ret = 0;
-	if (len != dev->fmr_page_size) {
+	if (len != dev->mr_page_size) {
 		ret = srp_map_finish_fmr(state, target);
 		if (!ret)
 			srp_map_update_start(state, NULL, 0, 0);
@@ -1112,7 +1112,7 @@ backtrack:
 	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_map_finish_fmr(state, target))
 		goto backtrack;
 
-	req->nfmr = state->nfmr;
+	req->nmdesc = state->nmdesc;
 }
 
 static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
@@ -1165,7 +1165,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		buf->key = cpu_to_be32(target->rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
-		req->nfmr = 0;
+		req->nmdesc = 0;
 		goto map_complete;
 	}
 
@@ -2844,15 +2844,15 @@ static void srp_alloc_fmr_pool(struct srp_device *srp_dev)
 
 	srp_dev->fmr_pool = NULL;
 
-	for (max_pages_per_mr = SRP_FMR_SIZE;
-	     max_pages_per_mr >= SRP_FMR_MIN_SIZE;
+	for (max_pages_per_mr = SRP_MAX_PAGES_PER_MR;
+	     max_pages_per_mr >= SRP_MIN_PAGES_PER_MR;
 	     max_pages_per_mr /= 2) {
 		memset(&fmr_param, 0, sizeof(fmr_param));
-		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
+		fmr_param.pool_size	    = SRP_MDESC_PER_POOL;
 		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
 		fmr_param.cache		    = 1;
 		fmr_param.max_pages_per_fmr = max_pages_per_mr;
-		fmr_param.page_shift	    = ilog2(srp_dev->fmr_page_size);
+		fmr_param.page_shift	    = ilog2(srp_dev->mr_page_size);
 		fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
 					       IB_ACCESS_REMOTE_WRITE |
 					       IB_ACCESS_REMOTE_READ);
@@ -2861,7 +2861,7 @@ static void srp_alloc_fmr_pool(struct srp_device *srp_dev)
 		if (!IS_ERR(pool)) {
 			srp_dev->fmr_pool = pool;
 			srp_dev->fmr_max_size =
-				srp_dev->fmr_page_size * max_pages_per_mr;
+				srp_dev->mr_page_size * max_pages_per_mr;
 			break;
 		}
 	}
@@ -2872,7 +2872,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_device *srp_dev;
 	struct ib_device_attr *dev_attr;
 	struct srp_host *host;
-	int fmr_page_shift, s, e, p;
+	int mr_page_shift, s, e, p;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2892,9 +2892,9 @@ static void srp_add_one(struct ib_device *device)
 	 * minimum of 4096 bytes. We're unlikely to build large sglists
 	 * out of smaller entries.
 	 */
-	fmr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
-	srp_dev->fmr_page_size	= 1 << fmr_page_shift;
-	srp_dev->fmr_page_mask	= ~((u64) srp_dev->fmr_page_size - 1);
+	mr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
+	srp_dev->mr_page_size	= 1 << mr_page_shift;
+	srp_dev->mr_page_mask	= ~((u64) srp_dev->mr_page_size - 1);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index aad27b7..89e3adb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -66,10 +66,10 @@ enum {
 	SRP_TAG_NO_REQ		= ~0U,
 	SRP_TAG_TSK_MGMT	= 1U << 31,
 
-	SRP_FMR_SIZE		= 512,
-	SRP_FMR_MIN_SIZE	= 128,
-	SRP_FMR_POOL_SIZE	= 1024,
-	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4,
+	SRP_MAX_PAGES_PER_MR	= 512,
+	SRP_MIN_PAGES_PER_MR	= 128,
+	SRP_MDESC_PER_POOL	= 1024,
+	SRP_FMR_DIRTY_SIZE	= SRP_MDESC_PER_POOL / 4,
 
 	SRP_MAP_ALLOW_FMR	= 0,
 	SRP_MAP_NO_FMR		= 1,
@@ -92,8 +92,8 @@ struct srp_device {
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
 	struct ib_fmr_pool     *fmr_pool;
-	u64			fmr_page_mask;
-	int			fmr_page_size;
+	u64			mr_page_mask;
+	int			mr_page_size;
 	int			fmr_max_size;
 };
 
@@ -116,7 +116,7 @@ struct srp_request {
 	u64		       *map_page;
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
-	short			nfmr;
+	short			nmdesc;
 	short			index;
 };
 
@@ -202,10 +202,10 @@ struct srp_map_state {
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
