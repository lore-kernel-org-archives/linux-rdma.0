From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/8] IB/srp: Add memory descriptor array pointer range
 checking
Date: Mon, 10 Aug 2015 17:07:27 -0700
Message-ID: <55C93CBF.1060606@sandisk.com>
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

Although most paths through which a request is submitted check
block layer parameters like the max_segments limit, these are
not checked when an SG_IO or direct I/O request is submitted.
Hence add a range check for the memory descriptor array pointer.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 16 ++++++++++++----
 drivers/infiniband/ulp/srp/ib_srp.h | 10 ++++++++--
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b6b9a55..f9fa220 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1277,12 +1277,15 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
+	if (state->fmr.next >= state->fmr.end)
+		return -ENOMEM;
+
 	fmr = ib_fmr_pool_map_phys(ch->fmr_pool, state->pages,
 				   state->npages, io_addr);
 	if (IS_ERR(fmr))
 		return PTR_ERR(fmr);
 
-	*state->next_fmr++ = fmr;
+	*state->fmr.next++ = fmr;
 	state->nmdesc++;
 
 	srp_map_desc(state, state->base_dma_addr & ~dev->mr_page_mask,
@@ -1301,6 +1304,9 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	struct srp_fr_desc *desc;
 	u32 rkey;
 
+	if (state->fr.next >= state->fr.end)
+		return -ENOMEM;
+
 	desc = srp_fr_pool_get(ch->fr_pool);
 	if (!desc)
 		return -ENOMEM;
@@ -1324,7 +1330,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 				       IB_ACCESS_REMOTE_WRITE);
 	wr.wr.fast_reg.rkey = desc->mr->lkey;
 
-	*state->next_fr++ = desc;
+	*state->fr.next++ = desc;
 	state->nmdesc++;
 
 	srp_map_desc(state, state->base_dma_addr, state->dma_len,
@@ -1450,10 +1456,12 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	state->desc	= req->indirect_desc;
 	state->pages	= req->map_page;
 	if (dev->use_fast_reg) {
-		state->next_fr = req->fr_list;
+		state->fr.next = req->fr_list;
+		state->fr.end = req->fr_list + target->cmd_sg_cnt;
 		use_mr = !!ch->fr_pool;
 	} else {
-		state->next_fmr = req->fmr_list;
+		state->fmr.next = req->fmr_list;
+		state->fmr.end = req->fmr_list + target->cmd_sg_cnt;
 		use_mr = !!ch->fmr_pool;
 	}
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 17ee3f8..2ab73bc 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -282,8 +282,14 @@ struct srp_fr_pool {
  */
 struct srp_map_state {
 	union {
-		struct ib_pool_fmr **next_fmr;
-		struct srp_fr_desc **next_fr;
+		struct {
+			struct ib_pool_fmr **next;
+			struct ib_pool_fmr **end;
+		} fmr;
+		struct {
+			struct srp_fr_desc **next;
+			struct srp_fr_desc **end;
+		} fr;
 	};
 	struct srp_direct_buf  *desc;
 	u64		       *pages;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
