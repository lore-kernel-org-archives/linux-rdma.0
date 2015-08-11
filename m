From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 8/8] IB/srp: Create an insecure all physical rkey only if
 needed
Date: Mon, 10 Aug 2015 17:09:36 -0700
Message-ID: <55C93D40.2020608@sandisk.com>
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

The SRP initiator only needs this if the insecure register_always=N
performance optimization is enabled, or if FRWR/FMR is not supported
in the driver.

Do not create an all physical MR unless it is needed to support
either of those modes. Default register_always to true so the out of
the box configuration does not create an insecure all physical MR.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
[bvanassche: reworked and rebased this patch]
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 40 +++++++++++++++++++++----------------
 drivers/infiniband/ulp/srp/ib_srp.h |  4 ++--
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2a16ab4..192f737 100644
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
@@ -1353,9 +1353,9 @@ static int srp_finish_mapping(struct srp_map_state *state,
 	if (state->npages == 0)
 		return 0;
 
-	if (state->npages == 1 && !register_always)
+	if (state->npages == 1 && target->global_mr)
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
-			     target->rkey);
+			     target->global_mr->rkey);
 	else
 		ret = dev->use_fast_reg ? srp_map_finish_fr(state, ch) :
 			srp_map_finish_fmr(state, ch);
@@ -1442,7 +1442,8 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	} else {
 		for_each_sg(scat, sg, count, i) {
 			srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
-				     ib_sg_dma_len(dev->dev, sg), target->rkey);
+				     ib_sg_dma_len(dev->dev, sg),
+				     target->global_mr->rkey);
 		}
 	}
 
@@ -1531,7 +1532,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
 
-	if (count == 1 && !register_always) {
+	if (count == 1 && target->global_mr) {
 		/*
 		 * The midlayer only generated a single gather/scatter
 		 * entry, or DMA mapping coalesced everything to a
@@ -1541,7 +1542,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
-		buf->key = cpu_to_be32(target->rkey);
+		buf->key = cpu_to_be32(target->global_mr->rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
 		req->nmdesc = 0;
@@ -1595,14 +1596,14 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	memcpy(indirect_hdr->desc_list, req->indirect_desc,
 	       count * sizeof (struct srp_direct_buf));
 
-	if (register_always && (dev->use_fast_reg || dev->use_fmr)) {
+	if (!target->global_mr) {
 		ret = srp_map_idb(ch, req, state.gen.next, state.gen.end,
 				  idb_len, &idb_rkey);
 		if (ret < 0)
 			return ret;
 		req->nmdesc++;
 	} else {
-		idb_rkey = target->rkey;
+		idb_rkey = target->global_mr->rkey;
 	}
 
 	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
@@ -3150,7 +3151,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
 	target->lkey		= host->srp_dev->pd->local_dma_lkey;
-	target->rkey		= host->srp_dev->mr->rkey;
+	target->global_mr	= host->srp_dev->global_mr;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
@@ -3438,12 +3439,16 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
-	srp_dev->mr = ib_get_dma_mr(srp_dev->pd,
-				    IB_ACCESS_LOCAL_WRITE |
-				    IB_ACCESS_REMOTE_READ |
-				    IB_ACCESS_REMOTE_WRITE);
-	if (IS_ERR(srp_dev->mr))
-		goto err_pd;
+	if (!register_always || (!srp_dev->has_fmr && !srp_dev->has_fr)) {
+		srp_dev->global_mr = ib_get_dma_mr(srp_dev->pd,
+						   IB_ACCESS_LOCAL_WRITE |
+						   IB_ACCESS_REMOTE_READ |
+						   IB_ACCESS_REMOTE_WRITE);
+		if (IS_ERR(srp_dev->global_mr))
+			goto err_pd;
+	} else {
+		srp_dev->global_mr = NULL;
+	}
 
 	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
 		host = srp_add_port(srp_dev, p);
@@ -3500,7 +3505,8 @@ static void srp_remove_one(struct ib_device *device)
 		kfree(host);
 	}
 
-	ib_dereg_mr(srp_dev->mr);
+	if (srp_dev->global_mr)
+		ib_dereg_mr(srp_dev->global_mr);
 	ib_dealloc_pd(srp_dev->pd);
 
 	kfree(srp_dev);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 255b0e5..3608f2e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -95,7 +95,7 @@ struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
-	struct ib_mr	       *mr;
+	struct ib_mr	       *global_mr;
 	u64			mr_page_mask;
 	int			mr_page_size;
 	int			mr_max_size;
@@ -183,10 +183,10 @@ struct srp_target_port {
 	spinlock_t		lock;
 
 	/* read only in the hot path */
+	struct ib_mr		*global_mr;
 	struct srp_rdma_ch	*ch;
 	u32			ch_count;
 	u32			lkey;
-	u32			rkey;
 	enum srp_target_state	state;
 	unsigned int		max_iu_len;
 	unsigned int		cmd_sg_cnt;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
