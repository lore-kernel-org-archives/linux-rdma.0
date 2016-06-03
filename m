From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] IB/srp: Fix srp_map_sg_dma()
Date: Fri, 3 Jun 2016 11:40:24 -0700
Message-ID: <25293485-8307-5361-c6fc-6bcadd832249@sandisk.com>
References: <4b4cc34a-eebb-8534-3d76-1cfb3fe961f5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4b4cc34a-eebb-8534-3d76-1cfb3fe961f5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Because patch "IB/srp: Move common code into the caller" was applied
partially srp_map_sg_dma() doesn't work properly. Fix this by
applying the remainder of that patch. See also
http://thread.gmane.org/gmane.linux.drivers.rdma/35803/focus=35811.

Fixes: 3849e44d1c4b ("IB/srp: Move common code into the caller")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sai-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bc24b8d..3322ed7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1457,7 +1457,6 @@ static int srp_map_sg_fr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 {
 	unsigned int sg_offset = 0;
 
-	state->desc = req->indirect_desc;
 	state->fr.next = req->fr_list;
 	state->fr.end = req->fr_list + ch->target->mr_per_cmd;
 	state->sg = scat;
@@ -1489,7 +1488,6 @@ static int srp_map_sg_dma(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	struct scatterlist *sg;
 	int i;
 
-	state->desc = req->indirect_desc;
 	for_each_sg(scat, sg, count, i) {
 		srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
 			     ib_sg_dma_len(dev->dev, sg),
@@ -1655,6 +1653,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 				   target->indirect_size, DMA_TO_DEVICE);
 
 	memset(&state, 0, sizeof(state));
+	state.desc = req->indirect_desc;
 	if (dev->use_fast_reg)
 		ret = srp_map_sg_fr(&state, ch, req, scat, count);
 	else if (dev->use_fmr)
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
