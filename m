From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/6] IB/srp: Fix srp_map_sg_fr()
Date: Tue, 1 Dec 2015 10:19:38 -0800
Message-ID: <565DE4BA.1040703@sandisk.com>
References: <565DE3EC.2070002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DE3EC.2070002-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After dma_map_sg() has been called the return value of that function
must be used as the number of elements in the scatterlist instead of
scsi_sg_count().

Fixes: commit f7f7aab1a5c0 ("IB/srp: Convert to new registration API")
Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.4+
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 19 ++++++++-----------
 drivers/infiniband/ulp/srp/ib_srp.h |  5 +----
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fac1423..3db9a65 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1313,7 +1313,7 @@ reset_state:
 }
 
 static int srp_map_finish_fr(struct srp_map_state *state,
-			     struct srp_rdma_ch *ch)
+			     struct srp_rdma_ch *ch, int sg_nents)
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
@@ -1328,10 +1328,10 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 
 	WARN_ON_ONCE(!dev->use_fast_reg);
 
-	if (state->sg_nents == 0)
+	if (sg_nents == 0)
 		return 0;
 
-	if (state->sg_nents == 1 && target->global_mr) {
+	if (sg_nents == 1 && target->global_mr) {
 		srp_map_desc(state, sg_dma_address(state->sg),
 			     sg_dma_len(state->sg),
 			     target->global_mr->rkey);
@@ -1345,8 +1345,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	rkey = ib_inc_rkey(desc->mr->rkey);
 	ib_update_fast_reg_key(desc->mr, rkey);
 
-	n = ib_map_mr_sg(desc->mr, state->sg, state->sg_nents,
-			 dev->mr_page_size);
+	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, dev->mr_page_size);
 	if (unlikely(n < 0))
 		return n;
 
@@ -1452,16 +1451,15 @@ static int srp_map_sg_fr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	state->fr.next = req->fr_list;
 	state->fr.end = req->fr_list + ch->target->cmd_sg_cnt;
 	state->sg = scat;
-	state->sg_nents = scsi_sg_count(req->scmnd);
 
-	while (state->sg_nents) {
+	while (count) {
 		int i, n;
 
-		n = srp_map_finish_fr(state, ch);
+		n = srp_map_finish_fr(state, ch, count);
 		if (unlikely(n < 0))
 			return n;
 
-		state->sg_nents -= n;
+		count -= n;
 		for (i = 0; i < n; i++)
 			state->sg = sg_next(state->sg);
 	}
@@ -1521,13 +1519,12 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 
 	if (dev->use_fast_reg) {
 		state.sg = idb_sg;
-		state.sg_nents = 1;
 		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
 		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 		idb_sg->dma_length = idb_sg->length;	      /* hack^2 */
 #endif
-		ret = srp_map_finish_fr(&state, ch);
+		ret = srp_map_finish_fr(&state, ch, 1);
 		if (ret < 0)
 			return ret;
 	} else if (dev->use_fmr) {
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 87a2a91..f6af531 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -300,10 +300,7 @@ struct srp_map_state {
 	dma_addr_t		base_dma_addr;
 	u32			dma_len;
 	u32			total_len;
-	union {
-		unsigned int	npages;
-		int		sg_nents;
-	};
+	unsigned int		npages;
 	unsigned int		nmdesc;
 	unsigned int		ndesc;
 };
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
