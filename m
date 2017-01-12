From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 21/26] staging/lustre: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:13 -0800
Message-ID: <20170112190718.6728-22-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: James Simmons <jsimmons@infradead.org>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
index 14576977200f..f2c0c60eee1d 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
@@ -925,21 +925,21 @@ kiblnd_rd_msg_size(struct kib_rdma_desc *rd, int msgtype, int n)
 static inline __u64
 kiblnd_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
 {
-	return ib_dma_mapping_error(dev, dma_addr);
+	return dma_mapping_error(dev->dma_device, dma_addr);
 }
 
 static inline __u64 kiblnd_dma_map_single(struct ib_device *dev,
 					  void *msg, size_t size,
 					  enum dma_data_direction direction)
 {
-	return ib_dma_map_single(dev, msg, size, direction);
+	return dma_map_single(dev->dma_device, msg, size, direction);
 }
 
 static inline void kiblnd_dma_unmap_single(struct ib_device *dev,
 					   __u64 addr, size_t size,
 					  enum dma_data_direction direction)
 {
-	ib_dma_unmap_single(dev, addr, size, direction);
+	dma_unmap_single(dev->dma_device, addr, size, direction);
 }
 
 #define KIBLND_UNMAP_ADDR_SET(p, m, a)  do {} while (0)
@@ -949,26 +949,26 @@ static inline int kiblnd_dma_map_sg(struct ib_device *dev,
 				    struct scatterlist *sg, int nents,
 				    enum dma_data_direction direction)
 {
-	return ib_dma_map_sg(dev, sg, nents, direction);
+	return dma_map_sg(dev->dma_device, sg, nents, direction);
 }
 
 static inline void kiblnd_dma_unmap_sg(struct ib_device *dev,
 				       struct scatterlist *sg, int nents,
 				       enum dma_data_direction direction)
 {
-	ib_dma_unmap_sg(dev, sg, nents, direction);
+	dma_unmap_sg(dev->dma_device, sg, nents, direction);
 }
 
 static inline __u64 kiblnd_sg_dma_address(struct ib_device *dev,
 					  struct scatterlist *sg)
 {
-	return ib_sg_dma_address(dev, sg);
+	return sg_dma_address(sg);
 }
 
 static inline unsigned int kiblnd_sg_dma_len(struct ib_device *dev,
 					     struct scatterlist *sg)
 {
-	return ib_sg_dma_len(dev, sg);
+	return sg_dma_len(sg);
 }
 
 /* XXX We use KIBLND_CONN_PARAM(e) as writable buffer, it's not strictly */
-- 
2.11.0
