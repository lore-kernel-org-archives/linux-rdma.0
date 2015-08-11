From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/8] IB/srp: Remove use_mr argument from srp_map_sg_entry()
Date: Mon, 10 Aug 2015 17:08:18 -0700
Message-ID: <55C93CF2.8080005@sandisk.com>
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

Move the srp_map_desc() call from inside srp_map_sg_entry() to
srp_map_sg() such that the use_mr argument can be removed from
srp_map_sg_entry().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 660a4a4..b8fc35b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1260,6 +1260,8 @@ static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
 {
 	struct srp_direct_buf *desc = state->desc;
 
+	WARN_ON_ONCE(!dma_len);
+
 	desc->va = cpu_to_be64(dma_addr);
 	desc->key = cpu_to_be32(rkey);
 	desc->len = cpu_to_be32(dma_len);
@@ -1366,29 +1368,17 @@ static int srp_finish_mapping(struct srp_map_state *state,
 
 static int srp_map_sg_entry(struct srp_map_state *state,
 			    struct srp_rdma_ch *ch,
-			    struct scatterlist *sg, int sg_index,
-			    bool use_mr)
+			    struct scatterlist *sg, int sg_index)
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	dma_addr_t dma_addr = ib_sg_dma_address(ibdev, sg);
 	unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
-	unsigned int len;
+	unsigned int len = 0;
 	int ret;
 
-	if (!dma_len)
-		return 0;
-
-	if (!use_mr) {
-		/*
-		 * Once we're in direct map mode for a request, we don't
-		 * go back to FMR or FR mode, so no need to update anything
-		 * other than the descriptor.
-		 */
-		srp_map_desc(state, dma_addr, dma_len, target->rkey);
-		return 0;
-	}
+	WARN_ON_ONCE(!dma_len);
 
 	while (dma_len) {
 		unsigned offset = dma_addr & ~dev->mr_page_mask;
@@ -1441,16 +1431,20 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 		use_mr = !!ch->fmr_pool;
 	}
 
-	for_each_sg(scat, sg, count, i) {
-		ret = srp_map_sg_entry(state, ch, sg, i, use_mr);
-		if (ret)
-			goto out;
-	}
-
 	if (use_mr) {
+		for_each_sg(scat, sg, count, i) {
+			ret = srp_map_sg_entry(state, ch, sg, i);
+			if (ret)
+				goto out;
+		}
 		ret = srp_finish_mapping(state, ch);
 		if (ret)
 			goto out;
+	} else {
+		for_each_sg(scat, sg, count, i) {
+			srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
+				     ib_sg_dma_len(dev->dev, sg), target->rkey);
+		}
 	}
 
 	req->nmdesc = state->nmdesc;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
