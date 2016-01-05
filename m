From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 04/15] IB/srpt: Introduce target_reverse_dma_direction()
Date: Tue, 5 Jan 2016 15:22:20 +0100
Message-ID: <568BD19C.6060404@sandisk.com>
References: <568BD0FC.70207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568BD0FC.70207-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the function target_reverse_dma_direction() instead of
reimplementing it.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index cbcc73e..fd94780 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -96,19 +96,6 @@ static int srpt_queue_status(struct se_cmd *cmd);
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
-/**
- * opposite_dma_dir() - Swap DMA_TO_DEVICE and DMA_FROM_DEVICE.
- */
-static inline
-enum dma_data_direction opposite_dma_dir(enum dma_data_direction dir)
-{
-	switch (dir) {
-	case DMA_TO_DEVICE:	return DMA_FROM_DEVICE;
-	case DMA_FROM_DEVICE:	return DMA_TO_DEVICE;
-	default:		return dir;
-	}
-}
-
 static enum rdma_ch_state
 srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new_state)
 {
@@ -1048,7 +1035,7 @@ static void srpt_unmap_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 		dir = ioctx->cmd.data_direction;
 		BUG_ON(dir == DMA_NONE);
 		ib_dma_unmap_sg(ch->sport->sdev->device, sg, ioctx->sg_cnt,
-				opposite_dma_dir(dir));
+				target_reverse_dma_direction(&ioctx->cmd));
 		ioctx->mapped_sg_count = 0;
 	}
 }
@@ -1085,7 +1072,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	ioctx->sg_cnt = sg_cnt = cmd->t_data_nents;
 
 	count = ib_dma_map_sg(ch->sport->sdev->device, sg, sg_cnt,
-			      opposite_dma_dir(dir));
+			      target_reverse_dma_direction(cmd));
 	if (unlikely(!count))
 		return -EAGAIN;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
