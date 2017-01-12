From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 15/26] IB/mlx5: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:07 -0800
Message-ID: <20170112190718.6728-16-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 00175191fdc6..4d3daef6d859 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1865,9 +1865,9 @@ int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 
 	mr->ndescs = 0;
 
-	ib_dma_sync_single_for_cpu(ibmr->device, mr->desc_map,
-				   mr->desc_size * mr->max_descs,
-				   DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(ibmr->device->dma_device, mr->desc_map,
+				mr->desc_size * mr->max_descs,
+				DMA_TO_DEVICE);
 
 	if (mr->access_mode == MLX5_MKC_ACCESS_MODE_KLMS)
 		n = mlx5_ib_sg_to_klms(mr, sg, sg_nents, sg_offset);
@@ -1875,9 +1875,9 @@ int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		n = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset,
 				mlx5_set_page);
 
-	ib_dma_sync_single_for_device(ibmr->device, mr->desc_map,
-				      mr->desc_size * mr->max_descs,
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(ibmr->device->dma_device, mr->desc_map,
+				   mr->desc_size * mr->max_descs,
+				   DMA_TO_DEVICE);
 
 	return n;
 }
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
