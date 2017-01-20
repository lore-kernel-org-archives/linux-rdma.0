From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 08/37] IB/core: Remove ib_dma_*map_single_attrs()
Date: Fri, 20 Jan 2017 13:04:08 -0800
Message-ID: <20170120210437.26389-9-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove these functions because these are not used. Additionally, the
implementation of these functions is not correct for the hfi1, qib and
rxe drivers because dma_device is used instead of dma_ops.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 include/rdma/ib_verbs.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 958a24d8fae7..8b9a3767f695 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3004,24 +3004,6 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
 		dma_unmap_single(dev->dma_device, addr, size, direction);
 }
 
-static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
-					  void *cpu_addr, size_t size,
-					  enum dma_data_direction direction,
-					  unsigned long dma_attrs)
-{
-	return dma_map_single_attrs(dev->dma_device, cpu_addr, size,
-				    direction, dma_attrs);
-}
-
-static inline void ib_dma_unmap_single_attrs(struct ib_device *dev,
-					     u64 addr, size_t size,
-					     enum dma_data_direction direction,
-					     unsigned long dma_attrs)
-{
-	return dma_unmap_single_attrs(dev->dma_device, addr, size,
-				      direction, dma_attrs);
-}
-
 /**
  * ib_dma_map_page - Map a physical page to DMA address
  * @dev: The device for which the dma_addr is to be created
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
