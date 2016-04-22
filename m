From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 08/11] IB/srp: Move common code into the caller
Date: Fri, 22 Apr 2016 14:15:04 -0700
Message-ID: <571A9458.3050904@sandisk.com>
References: <571A936F.7040409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A936F.7040409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
  drivers/infiniband/ulp/srp/ib_srp.c | 4 +---
  1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c 
b/drivers/infiniband/ulp/srp/ib_srp.c
index d709428c..caefd1a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1409,7 +1409,6 @@ static int srp_map_sg_fmr(struct srp_map_state 
*state, struct srp_rdma_ch *ch,
  	struct scatterlist *sg;
  	int i, ret;

-	state->desc = req->indirect_desc;
  	state->pages = req->map_page;
  	state->fmr.next = req->fmr_list;
  	state->fmr.end = req->fmr_list + ch->target->cmd_sg_cnt;
@@ -1431,7 +1430,6 @@ static int srp_map_sg_fr(struct srp_map_state 
*state, struct srp_rdma_ch *ch,
  			 struct srp_request *req, struct scatterlist *scat,
  			 int count)
  {
-	state->desc = req->indirect_desc;
  	state->fr.next = req->fr_list;
  	state->fr.end = req->fr_list + ch->target->cmd_sg_cnt;
  	state->sg = scat;
@@ -1463,7 +1461,6 @@ static int srp_map_sg_dma(struct srp_map_state 
*state, struct srp_rdma_ch *ch,
  	struct scatterlist *sg;
  	int i;

-	state->desc = req->indirect_desc;
  	for_each_sg(scat, sg, count, i) {
  		srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
  			     ib_sg_dma_len(dev->dev, sg),
@@ -1602,6 +1599,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, 
struct srp_rdma_ch *ch,
  				   target->indirect_size, DMA_TO_DEVICE);

  	memset(&state, 0, sizeof(state));
+	state.desc = req->indirect_desc;
  	if (dev->use_fast_reg)
  		ret = srp_map_sg_fr(&state, ch, req, scat, count);
  	else if (dev->use_fmr)
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
