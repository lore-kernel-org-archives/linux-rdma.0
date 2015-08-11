From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/8] IB/srp: Remove the memory registration backtracking code
Date: Mon, 10 Aug 2015 17:07:46 -0700
Message-ID: <55C93CD2.8050704@sandisk.com>
References: <55BBF4B8.2050700@sandisk.com>
 <20150803152420.GA24193@infradead.org> <55BFB40F.8000500@sandisk.com>
 <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
 <20150805195122.GA31595@obsidianresearch.com> <55C2840C.5050301@sandisk.com>
 <55C2912A.50709@sandisk.com> <20150806001006.GD2483@obsidianresearch.com>
 <55C2A7FE.7020904@sandisk.com> <20150806043642.GA14153@obsidianresearch.com>
 <55C93C61.9010508@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C93C61.9010508-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mapping a discontiguous sg-list requires multiple memory regions
and hence can exhaust the memory region pool. The SRP initiator
already handles this by temporarily reducing the queue depth. This
means that it is safe to remove the memory registration backtracking
code. This patch has been tested with direct I/O sizes up to 256 MB.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 62 ++++++++-----------------------------
 drivers/infiniband/ulp/srp/ib_srp.h |  6 ----
 2 files changed, 13 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f9fa220..660a4a4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1364,15 +1364,6 @@ static int srp_finish_mapping(struct srp_map_state *state,
 	return ret;
 }
 
-static void srp_map_update_start(struct srp_map_state *state,
-				 struct scatterlist *sg, int sg_index,
-				 dma_addr_t dma_addr)
-{
-	state->unmapped_sg = sg;
-	state->unmapped_index = sg_index;
-	state->unmapped_addr = dma_addr;
-}
-
 static int srp_map_sg_entry(struct srp_map_state *state,
 			    struct srp_rdma_ch *ch,
 			    struct scatterlist *sg, int sg_index,
@@ -1399,23 +1390,12 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 		return 0;
 	}
 
-	/*
-	 * If this is the first sg that will be mapped via FMR or via FR, save
-	 * our position. We need to know the first unmapped entry, its index,
-	 * and the first unmapped address within that entry to be able to
-	 * restart mapping after an error.
-	 */
-	if (!state->unmapped_sg)
-		srp_map_update_start(state, sg, sg_index, dma_addr);
-
 	while (dma_len) {
 		unsigned offset = dma_addr & ~dev->mr_page_mask;
 		if (state->npages == dev->max_pages_per_mr || offset != 0) {
 			ret = srp_finish_mapping(state, ch);
 			if (ret)
 				return ret;
-
-			srp_map_update_start(state, sg, sg_index, dma_addr);
 		}
 
 		len = min_t(unsigned int, dma_len, dev->mr_page_size - offset);
@@ -1434,11 +1414,8 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 * boundaries.
 	 */
 	ret = 0;
-	if (len != dev->mr_page_size) {
+	if (len != dev->mr_page_size)
 		ret = srp_finish_mapping(state, ch);
-		if (!ret)
-			srp_map_update_start(state, NULL, 0, 0);
-	}
 	return ret;
 }
 
@@ -1448,9 +1425,8 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
-	struct ib_device *ibdev = dev->dev;
 	struct scatterlist *sg;
-	int i;
+	int i, ret;
 	bool use_mr;
 
 	state->desc	= req->indirect_desc;
@@ -1466,34 +1442,22 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	}
 
 	for_each_sg(scat, sg, count, i) {
-		if (srp_map_sg_entry(state, ch, sg, i, use_mr)) {
-			/*
-			 * Memory registration failed, so backtrack to the
-			 * first unmapped entry and continue on without using
-			 * memory registration.
-			 */
-			dma_addr_t dma_addr;
-			unsigned int dma_len;
-
-backtrack:
-			sg = state->unmapped_sg;
-			i = state->unmapped_index;
-
-			dma_addr = ib_sg_dma_address(ibdev, sg);
-			dma_len = ib_sg_dma_len(ibdev, sg);
-			dma_len -= (state->unmapped_addr - dma_addr);
-			dma_addr = state->unmapped_addr;
-			use_mr = false;
-			srp_map_desc(state, dma_addr, dma_len, target->rkey);
-		}
+		ret = srp_map_sg_entry(state, ch, sg, i, use_mr);
+		if (ret)
+			goto out;
 	}
 
-	if (use_mr && srp_finish_mapping(state, ch))
-		goto backtrack;
+	if (use_mr) {
+		ret = srp_finish_mapping(state, ch);
+		if (ret)
+			goto out;
+	}
 
 	req->nmdesc = state->nmdesc;
+	ret = 0;
 
-	return 0;
+out:
+	return ret;
 }
 
 static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 2ab73bc..1e42418 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -276,9 +276,6 @@ struct srp_fr_pool {
  * @npages:	    Number of page addresses in the pages[] array.
  * @nmdesc:	    Number of FMR or FR memory descriptors used for mapping.
  * @ndesc:	    Number of SRP buffer descriptors that have been filled in.
- * @unmapped_sg:    First element of the sg-list that is mapped via FMR or FR.
- * @unmapped_index: Index of the first element mapped via FMR or FR.
- * @unmapped_addr:  DMA address of the first element mapped via FMR or FR.
  */
 struct srp_map_state {
 	union {
@@ -299,9 +296,6 @@ struct srp_map_state {
 	unsigned int		npages;
 	unsigned int		nmdesc;
 	unsigned int		ndesc;
-	struct scatterlist     *unmapped_sg;
-	int			unmapped_index;
-	dma_addr_t		unmapped_addr;
 };
 
 #endif /* IB_SRP_H */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
