From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 26/26] IB/core: Remove ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:18 -0800
Message-ID: <20170112190718.6728-27-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-rdma@vger.kernel.org

Remove the ib_dma_map_*() functions because due to previous patches
these are no longer used.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 include/rdma/ib_verbs.h | 218 ------------------------------------------------
 1 file changed, 218 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index de8dfb61d2b6..b4b83603b5df 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2912,224 +2912,6 @@ static inline int ib_req_ncomp_notif(struct ib_cq *cq, int wc_cnt)
 }
 
 /**
- * ib_dma_mapping_error - check a DMA addr for error
- * @dev: The device for which the dma_addr was created
- * @dma_addr: The DMA address to check
- */
-static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
-{
-	return dma_mapping_error(dev->dma_device, dma_addr);
-}
-
-/**
- * ib_dma_map_single - Map a kernel virtual address to DMA address
- * @dev: The device for which the dma_addr is to be created
- * @cpu_addr: The kernel virtual address
- * @size: The size of the region in bytes
- * @direction: The direction of the DMA
- */
-static inline u64 ib_dma_map_single(struct ib_device *dev,
-				    void *cpu_addr, size_t size,
-				    enum dma_data_direction direction)
-{
-	return dma_map_single(dev->dma_device, cpu_addr, size, direction);
-}
-
-/**
- * ib_dma_unmap_single - Destroy a mapping created by ib_dma_map_single()
- * @dev: The device for which the DMA address was created
- * @addr: The DMA address
- * @size: The size of the region in bytes
- * @direction: The direction of the DMA
- */
-static inline void ib_dma_unmap_single(struct ib_device *dev,
-				       u64 addr, size_t size,
-				       enum dma_data_direction direction)
-{
-	dma_unmap_single(dev->dma_device, addr, size, direction);
-}
-
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
-/**
- * ib_dma_map_page - Map a physical page to DMA address
- * @dev: The device for which the dma_addr is to be created
- * @page: The page to be mapped
- * @offset: The offset within the page
- * @size: The size of the region in bytes
- * @direction: The direction of the DMA
- */
-static inline u64 ib_dma_map_page(struct ib_device *dev,
-				  struct page *page,
-				  unsigned long offset,
-				  size_t size,
-					 enum dma_data_direction direction)
-{
-	return dma_map_page(dev->dma_device, page, offset, size, direction);
-}
-
-/**
- * ib_dma_unmap_page - Destroy a mapping created by ib_dma_map_page()
- * @dev: The device for which the DMA address was created
- * @addr: The DMA address
- * @size: The size of the region in bytes
- * @direction: The direction of the DMA
- */
-static inline void ib_dma_unmap_page(struct ib_device *dev,
-				     u64 addr, size_t size,
-				     enum dma_data_direction direction)
-{
-	dma_unmap_page(dev->dma_device, addr, size, direction);
-}
-
-/**
- * ib_dma_map_sg - Map a scatter/gather list to DMA addresses
- * @dev: The device for which the DMA addresses are to be created
- * @sg: The array of scatter/gather entries
- * @nents: The number of scatter/gather entries
- * @direction: The direction of the DMA
- */
-static inline int ib_dma_map_sg(struct ib_device *dev,
-				struct scatterlist *sg, int nents,
-				enum dma_data_direction direction)
-{
-	return dma_map_sg(dev->dma_device, sg, nents, direction);
-}
-
-/**
- * ib_dma_unmap_sg - Unmap a scatter/gather list of DMA addresses
- * @dev: The device for which the DMA addresses were created
- * @sg: The array of scatter/gather entries
- * @nents: The number of scatter/gather entries
- * @direction: The direction of the DMA
- */
-static inline void ib_dma_unmap_sg(struct ib_device *dev,
-				   struct scatterlist *sg, int nents,
-				   enum dma_data_direction direction)
-{
-	dma_unmap_sg(dev->dma_device, sg, nents, direction);
-}
-
-static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
-				      struct scatterlist *sg, int nents,
-				      enum dma_data_direction direction,
-				      unsigned long dma_attrs)
-{
-	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
-				dma_attrs);
-}
-
-static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
-					 struct scatterlist *sg, int nents,
-					 enum dma_data_direction direction,
-					 unsigned long dma_attrs)
-{
-	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, dma_attrs);
-}
-/**
- * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
- * @dev: The device for which the DMA addresses were created
- * @sg: The scatter/gather entry
- *
- * Note: this function is obsolete. To do: change all occurrences of
- * ib_sg_dma_address() into sg_dma_address().
- */
-static inline u64 ib_sg_dma_address(struct ib_device *dev,
-				    struct scatterlist *sg)
-{
-	return sg_dma_address(sg);
-}
-
-/**
- * ib_sg_dma_len - Return the DMA length from a scatter/gather entry
- * @dev: The device for which the DMA addresses were created
- * @sg: The scatter/gather entry
- *
- * Note: this function is obsolete. To do: change all occurrences of
- * ib_sg_dma_len() into sg_dma_len().
- */
-static inline unsigned int ib_sg_dma_len(struct ib_device *dev,
-					 struct scatterlist *sg)
-{
-	return sg_dma_len(sg);
-}
-
-/**
- * ib_dma_sync_single_for_cpu - Prepare DMA region to be accessed by CPU
- * @dev: The device for which the DMA address was created
- * @addr: The DMA address
- * @size: The size of the region in bytes
- * @dir: The direction of the DMA
- */
-static inline void ib_dma_sync_single_for_cpu(struct ib_device *dev,
-					      u64 addr,
-					      size_t size,
-					      enum dma_data_direction dir)
-{
-	dma_sync_single_for_cpu(dev->dma_device, addr, size, dir);
-}
-
-/**
- * ib_dma_sync_single_for_device - Prepare DMA region to be accessed by device
- * @dev: The device for which the DMA address was created
- * @addr: The DMA address
- * @size: The size of the region in bytes
- * @dir: The direction of the DMA
- */
-static inline void ib_dma_sync_single_for_device(struct ib_device *dev,
-						 u64 addr,
-						 size_t size,
-						 enum dma_data_direction dir)
-{
-	dma_sync_single_for_device(dev->dma_device, addr, size, dir);
-}
-
-/**
- * ib_dma_alloc_coherent - Allocate memory and map it for DMA
- * @dev: The device for which the DMA address is requested
- * @size: The size of the region to allocate in bytes
- * @dma_handle: A pointer for returning the DMA address of the region
- * @flag: memory allocator flags
- */
-static inline void *ib_dma_alloc_coherent(struct ib_device *dev,
-					   size_t size,
-					   dma_addr_t *dma_handle,
-					   gfp_t flag)
-{
-	return dma_alloc_coherent(dev->dma_device, size, dma_handle, flag);
-}
-
-/**
- * ib_dma_free_coherent - Free memory allocated by ib_dma_alloc_coherent()
- * @dev: The device for which the DMA addresses were allocated
- * @size: The size of the region
- * @cpu_addr: the address returned by ib_dma_alloc_coherent()
- * @dma_handle: the DMA address returned by ib_dma_alloc_coherent()
- */
-static inline void ib_dma_free_coherent(struct ib_device *dev,
-					size_t size, void *cpu_addr,
-					dma_addr_t dma_handle)
-{
-	dma_free_coherent(dev->dma_device, size, cpu_addr, dma_handle);
-}
-
-/**
  * ib_dereg_mr - Deregisters a memory region and removes it from the
  *   HCA translation table.
  * @mr: The memory region to deregister.
-- 
2.11.0
