From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] IB/qib: remove ib_sg_dma_address() and ib_sg_dma_len()
 overloads
Date: Fri, 28 Mar 2014 12:35:45 -0400
Message-ID: <20140328163545.5773.46946.stgit@phlsvslse11.ph.intel.com>
References: <20140328163500.5773.35838.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140328163500.5773.35838.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The code is replaced by logic in the .map_sg overload.

Suggested-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Vinod Kumar <vinod.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_dma.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_dma.c b/drivers/infiniband/hw/qib/qib_dma.c
index 2920bb3..59fe092 100644
--- a/drivers/infiniband/hw/qib/qib_dma.c
+++ b/drivers/infiniband/hw/qib/qib_dma.c
@@ -108,6 +108,10 @@ static int qib_map_sg(struct ib_device *dev, struct scatterlist *sgl,
 			ret = 0;
 			break;
 		}
+		sg->dma_address = addr + sg->offset;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
+		sg->dma_length = sg->length;
+#endif
 	}
 	return ret;
 }
@@ -119,21 +123,6 @@ static void qib_unmap_sg(struct ib_device *dev,
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-static u64 qib_sg_dma_address(struct ib_device *dev, struct scatterlist *sg)
-{
-	u64 addr = (u64) page_address(sg_page(sg));
-
-	if (addr)
-		addr += sg->offset;
-	return addr;
-}
-
-static unsigned int qib_sg_dma_len(struct ib_device *dev,
-				   struct scatterlist *sg)
-{
-	return sg->length;
-}
-
 static void qib_sync_single_for_cpu(struct ib_device *dev, u64 addr,
 				    size_t size, enum dma_data_direction dir)
 {
@@ -173,8 +162,6 @@ struct ib_dma_mapping_ops qib_dma_mapping_ops = {
 	.unmap_page = qib_dma_unmap_page,
 	.map_sg = qib_map_sg,
 	.unmap_sg = qib_unmap_sg,
-	.dma_address = qib_sg_dma_address,
-	.dma_len = qib_sg_dma_len,
 	.sync_single_for_cpu = qib_sync_single_for_cpu,
 	.sync_single_for_device = qib_sync_single_for_device,
 	.alloc_coherent = qib_dma_alloc_coherent,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
