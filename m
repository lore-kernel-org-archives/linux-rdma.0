From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] IB/ipath: remove ib_sg_dma_address() and
 ib_sg_dma_len() overloads
Date: Fri, 28 Mar 2014 12:35:50 -0400
Message-ID: <20140328163550.5773.20441.stgit@phlsvslse11.ph.intel.com>
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
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_dma.c |   43 +++++++++++--------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/infiniband/hw/ipath/ipath_dma.c
index 644c2c7..123a8c0 100644
--- a/drivers/infiniband/hw/ipath/ipath_dma.c
+++ b/drivers/infiniband/hw/ipath/ipath_dma.c
@@ -115,6 +115,10 @@ static int ipath_map_sg(struct ib_device *dev, struct scatterlist *sgl,
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
@@ -126,21 +130,6 @@ static void ipath_unmap_sg(struct ib_device *dev,
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-static u64 ipath_sg_dma_address(struct ib_device *dev, struct scatterlist *sg)
-{
-	u64 addr = (u64) page_address(sg_page(sg));
-
-	if (addr)
-		addr += sg->offset;
-	return addr;
-}
-
-static unsigned int ipath_sg_dma_len(struct ib_device *dev,
-				     struct scatterlist *sg)
-{
-	return sg->length;
-}
-
 static void ipath_sync_single_for_cpu(struct ib_device *dev,
 				      u64 addr,
 				      size_t size,
@@ -176,17 +165,15 @@ static void ipath_dma_free_coherent(struct ib_device *dev, size_t size,
 }
 
 struct ib_dma_mapping_ops ipath_dma_mapping_ops = {
-	ipath_mapping_error,
-	ipath_dma_map_single,
-	ipath_dma_unmap_single,
-	ipath_dma_map_page,
-	ipath_dma_unmap_page,
-	ipath_map_sg,
-	ipath_unmap_sg,
-	ipath_sg_dma_address,
-	ipath_sg_dma_len,
-	ipath_sync_single_for_cpu,
-	ipath_sync_single_for_device,
-	ipath_dma_alloc_coherent,
-	ipath_dma_free_coherent
+	.mapping_error = ipath_mapping_error,
+	.map_single = ipath_dma_map_single,
+	.unmap_single = ipath_dma_unmap_single,
+	.map_page = ipath_dma_map_page,
+	.unmap_page = ipath_dma_unmap_page,
+	.map_sg = ipath_map_sg,
+	.unmap_sg = ipath_unmap_sg,
+	.sync_single_for_cpu = ipath_sync_single_for_cpu,
+	.sync_single_for_device = ipath_sync_single_for_device,
+	.alloc_coherent = ipath_dma_alloc_coherent,
+	.free_coherent = ipath_dma_free_coherent
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
