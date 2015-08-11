From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/8] IB/srp: Re-enable FMR for non-page aligned buffers
Date: Mon, 10 Aug 2015 17:06:29 -0700
Message-ID: <55C93C85.6090003@sandisk.com>
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

During a discussion in 2011 nobody recalled why FMR was not used for
non-page aligned buffers (see also
http://thread.gmane.org/gmane.linux.drivers.rdma/7149). Re-enable FMR
for such buffers. For the reason why the srp_map_fmr() function needs
to be modified, see also patch "IB/srp: rework mapping engine to use
multiple FMR entries" (commit ID 8f26c9ff9cd0; January 2011).

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2968b7b..887e8ca 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1272,6 +1272,8 @@ static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
 static int srp_map_finish_fmr(struct srp_map_state *state,
 			      struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
+	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
@@ -1283,7 +1285,8 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	*state->next_fmr++ = fmr;
 	state->nmdesc++;
 
-	srp_map_desc(state, 0, state->dma_len, fmr->fmr->rkey);
+	srp_map_desc(state, state->base_dma_addr & ~dev->mr_page_mask,
+		     state->dma_len, fmr->fmr->rkey);
 
 	return 0;
 }
@@ -1390,14 +1393,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 		return 0;
 	}
 
-	/*
-	 * Since not all RDMA HW drivers support non-zero page offsets for
-	 * FMR, if we start at an offset into a page, don't merge into the
-	 * current FMR mapping. Finish it out, and use the kernel's MR for
-	 * this sg entry.
-	 */
-	if ((!dev->use_fast_reg && dma_addr & ~dev->mr_page_mask) ||
-	    dma_len > dev->mr_max_size) {
+	if (dma_len > dev->mr_max_size) {
 		ret = srp_finish_mapping(state, ch);
 		if (ret)
 			return ret;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
