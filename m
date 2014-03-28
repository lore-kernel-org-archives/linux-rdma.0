From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/4] IB/ehca: remove ib_sg_dma_address() and
 ib_sg_dma_len() overloads
Date: Fri, 28 Mar 2014 13:26:53 -0400
Message-ID: <20140328172653.23646.12359.stgit@phlsvslse11.ph.intel.com>
References: <20140328172606.23646.35980.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140328172606.23646.35980.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These methods appear to only mimic the sg_dma_address()
and sg_dma_len() behavior.

They can be safely removed.

Suggested-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index bcfb0c1..65873ee 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -2591,16 +2591,6 @@ static void ehca_dma_unmap_sg(struct ib_device *dev, struct scatterlist *sg,
 	/* This is only a stub; nothing to be done here */
 }
 
-static u64 ehca_dma_address(struct ib_device *dev, struct scatterlist *sg)
-{
-	return sg->dma_address;
-}
-
-static unsigned int ehca_dma_len(struct ib_device *dev, struct scatterlist *sg)
-{
-	return sg->length;
-}
-
 static void ehca_dma_sync_single_for_cpu(struct ib_device *dev, u64 addr,
 					 size_t size,
 					 enum dma_data_direction dir)
@@ -2653,8 +2643,6 @@ struct ib_dma_mapping_ops ehca_dma_mapping_ops = {
 	.unmap_page             = ehca_dma_unmap_page,
 	.map_sg                 = ehca_dma_map_sg,
 	.unmap_sg               = ehca_dma_unmap_sg,
-	.dma_address            = ehca_dma_address,
-	.dma_len                = ehca_dma_len,
 	.sync_single_for_cpu    = ehca_dma_sync_single_for_cpu,
 	.sync_single_for_device = ehca_dma_sync_single_for_device,
 	.alloc_coherent         = ehca_dma_alloc_coherent,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
