From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/4] IB/core: Remove overload in ib_sg_dma*
Date: Fri, 28 Mar 2014 13:26:59 -0400
Message-ID: <20140328172659.23646.44411.stgit@phlsvslse11.ph.intel.com>
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

The code is replaced by driver specific
changes and avoids the pointer NULL test
for drivers that don't overload these
operations.

Suggested-by: <Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Vinod Kumar <vinod.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6793f32..5777716 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1266,10 +1266,6 @@ struct ib_dma_mapping_ops {
 	void		(*unmap_sg)(struct ib_device *dev,
 				    struct scatterlist *sg, int nents,
 				    enum dma_data_direction direction);
-	u64		(*dma_address)(struct ib_device *dev,
-				       struct scatterlist *sg);
-	unsigned int	(*dma_len)(struct ib_device *dev,
-				   struct scatterlist *sg);
 	void		(*sync_single_for_cpu)(struct ib_device *dev,
 					       u64 dma_handle,
 					       size_t size,
@@ -2089,12 +2085,13 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
  * @dev: The device for which the DMA addresses were created
  * @sg: The scatter/gather entry
+ *
+ * Note: this function is obsolete. To do: change all occurrences of
+ * ib_sg_dma_address() into sg_dma_address().
  */
 static inline u64 ib_sg_dma_address(struct ib_device *dev,
 				    struct scatterlist *sg)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->dma_address(dev, sg);
 	return sg_dma_address(sg);
 }
 
@@ -2102,12 +2099,13 @@ static inline u64 ib_sg_dma_address(struct ib_device *dev,
  * ib_sg_dma_len - Return the DMA length from a scatter/gather entry
  * @dev: The device for which the DMA addresses were created
  * @sg: The scatter/gather entry
+ *
+ * Note: this function is obsolete. To do: change all occurrences of
+ * ib_sg_dma_len() into sg_dma_len().
  */
 static inline unsigned int ib_sg_dma_len(struct ib_device *dev,
 					 struct scatterlist *sg)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->dma_len(dev, sg);
 	return sg_dma_len(sg);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
