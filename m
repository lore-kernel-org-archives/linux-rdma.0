From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/8] IB/srp: Introduce srp_device.use_fmr
Date: Mon, 10 Aug 2015 17:08:44 -0700
Message-ID: <55C93D0C.7060000@sandisk.com>
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

Introduce the variable srp_device.use_fmr. Leave out the dev->has_fr /
dev->has_fmr and ch->fr_pool / ch->fmr_pool checks since these are
redundant. This patch does not change any functionality but makes the
source code easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 22 +++++++++++-----------
 drivers/infiniband/ulp/srp/ib_srp.h |  1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b8fc35b..1029fd2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -546,7 +546,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	if (ret)
 		goto err_qp;
 
-	if (dev->use_fast_reg && dev->has_fr) {
+	if (dev->use_fast_reg) {
 		fr_pool = srp_alloc_fr_pool(target);
 		if (IS_ERR(fr_pool)) {
 			ret = PTR_ERR(fr_pool);
@@ -557,7 +557,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 		if (ch->fr_pool)
 			srp_destroy_fr_pool(ch->fr_pool);
 		ch->fr_pool = fr_pool;
-	} else if (!dev->use_fast_reg && dev->has_fmr) {
+	} else if (dev->use_fmr) {
 		fmr_pool = srp_alloc_fmr_pool(target);
 		if (IS_ERR(fmr_pool)) {
 			ret = PTR_ERR(fmr_pool);
@@ -623,7 +623,7 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 	if (dev->use_fast_reg) {
 		if (ch->fr_pool)
 			srp_destroy_fr_pool(ch->fr_pool);
-	} else {
+	} else if (dev->use_fmr) {
 		if (ch->fmr_pool)
 			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
@@ -1085,7 +1085,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		if (req->nmdesc)
 			srp_fr_pool_put(ch->fr_pool, req->fr_list,
 					req->nmdesc);
-	} else {
+	} else if (dev->use_fmr) {
 		struct ib_pool_fmr **pfmr;
 
 		for (i = req->nmdesc, pfmr = req->fmr_list; i > 0; i--, pfmr++)
@@ -1345,8 +1345,11 @@ static int srp_finish_mapping(struct srp_map_state *state,
 			      struct srp_rdma_ch *ch)
 {
 	struct srp_target_port *target = ch->target;
+	struct srp_device *dev = target->srp_host->srp_dev;
 	int ret = 0;
 
+	WARN_ON_ONCE(!dev->use_fast_reg && !dev->use_fmr);
+
 	if (state->npages == 0)
 		return 0;
 
@@ -1354,8 +1357,7 @@ static int srp_finish_mapping(struct srp_map_state *state,
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
 			     target->rkey);
 	else
-		ret = target->srp_host->srp_dev->use_fast_reg ?
-			srp_map_finish_fr(state, ch) :
+		ret = dev->use_fast_reg ? srp_map_finish_fr(state, ch) :
 			srp_map_finish_fmr(state, ch);
 
 	if (ret == 0) {
@@ -1417,21 +1419,18 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct scatterlist *sg;
 	int i, ret;
-	bool use_mr;
 
 	state->desc	= req->indirect_desc;
 	state->pages	= req->map_page;
 	if (dev->use_fast_reg) {
 		state->fr.next = req->fr_list;
 		state->fr.end = req->fr_list + target->cmd_sg_cnt;
-		use_mr = !!ch->fr_pool;
-	} else {
+	} else if (dev->use_fmr) {
 		state->fmr.next = req->fmr_list;
 		state->fmr.end = req->fmr_list + target->cmd_sg_cnt;
-		use_mr = !!ch->fmr_pool;
 	}
 
-	if (use_mr) {
+	if (dev->use_fast_reg || dev->use_fmr) {
 		for_each_sg(scat, sg, count, i) {
 			ret = srp_map_sg_entry(state, ch, sg, i);
 			if (ret)
@@ -3355,6 +3354,7 @@ static void srp_add_one(struct ib_device *device)
 
 	srp_dev->use_fast_reg = (srp_dev->has_fr &&
 				 (!srp_dev->has_fmr || prefer_fr));
+	srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
 
 	/*
 	 * Use the smallest page size supported by the HCA, down to a
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 1e42418..60a33c1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -102,6 +102,7 @@ struct srp_device {
 	int			max_pages_per_mr;
 	bool			has_fmr;
 	bool			has_fr;
+	bool			use_fmr;
 	bool			use_fast_reg;
 };
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
