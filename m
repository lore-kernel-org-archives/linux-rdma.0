From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/verbs: Check each operation of dma_ops individually
Date: Tue, 14 Apr 2015 11:45:40 +0300
Message-ID: <20150414084539.GA6385@yuval-lab>
References: <1424667027-8790-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424667027-8790-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ping

On Sun, Feb 22, 2015 at 08:50:27PM -0800, Yuval Shaia wrote:
> Current approach force one to implement all ops even when some functions can use the default implementation.
> As a result, for new DMA ops (e.x new arch) many functions just wrap the default function.
> The fix is to check each DMA operation individually so one can leave empty the ones not need to be override.
> 
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 0d74f1d..166c01a 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2145,7 +2145,7 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags);
>   */
>  static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->mapping_error)
>  		return dev->dma_ops->mapping_error(dev, dma_addr);
>  	return dma_mapping_error(dev->dma_device, dma_addr);
>  }
> @@ -2161,7 +2161,7 @@ static inline u64 ib_dma_map_single(struct ib_device *dev,
>  				    void *cpu_addr, size_t size,
>  				    enum dma_data_direction direction)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->map_single)
>  		return dev->dma_ops->map_single(dev, cpu_addr, size, direction);
>  	return dma_map_single(dev->dma_device, cpu_addr, size, direction);
>  }
> @@ -2177,7 +2177,7 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
>  				       u64 addr, size_t size,
>  				       enum dma_data_direction direction)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->unmap_single)
>  		dev->dma_ops->unmap_single(dev, addr, size, direction);
>  	else
>  		dma_unmap_single(dev->dma_device, addr, size, direction);
> @@ -2215,7 +2215,7 @@ static inline u64 ib_dma_map_page(struct ib_device *dev,
>  				  size_t size,
>  					 enum dma_data_direction direction)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->map_page)
>  		return dev->dma_ops->map_page(dev, page, offset, size, direction);
>  	return dma_map_page(dev->dma_device, page, offset, size, direction);
>  }
> @@ -2231,7 +2231,7 @@ static inline void ib_dma_unmap_page(struct ib_device *dev,
>  				     u64 addr, size_t size,
>  				     enum dma_data_direction direction)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->unmap_page)
>  		dev->dma_ops->unmap_page(dev, addr, size, direction);
>  	else
>  		dma_unmap_page(dev->dma_device, addr, size, direction);
> @@ -2248,7 +2248,7 @@ static inline int ib_dma_map_sg(struct ib_device *dev,
>  				struct scatterlist *sg, int nents,
>  				enum dma_data_direction direction)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->map_sg)
>  		return dev->dma_ops->map_sg(dev, sg, nents, direction);
>  	return dma_map_sg(dev->dma_device, sg, nents, direction);
>  }
> @@ -2264,7 +2264,7 @@ static inline void ib_dma_unmap_sg(struct ib_device *dev,
>  				   struct scatterlist *sg, int nents,
>  				   enum dma_data_direction direction)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->unmap_sg)
>  		dev->dma_ops->unmap_sg(dev, sg, nents, direction);
>  	else
>  		dma_unmap_sg(dev->dma_device, sg, nents, direction);
> @@ -2325,7 +2325,7 @@ static inline void ib_dma_sync_single_for_cpu(struct ib_device *dev,
>  					      size_t size,
>  					      enum dma_data_direction dir)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->sync_single_for_cpu)
>  		dev->dma_ops->sync_single_for_cpu(dev, addr, size, dir);
>  	else
>  		dma_sync_single_for_cpu(dev->dma_device, addr, size, dir);
> @@ -2343,7 +2343,7 @@ static inline void ib_dma_sync_single_for_device(struct ib_device *dev,
>  						 size_t size,
>  						 enum dma_data_direction dir)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->sync_single_for_device)
>  		dev->dma_ops->sync_single_for_device(dev, addr, size, dir);
>  	else
>  		dma_sync_single_for_device(dev->dma_device, addr, size, dir);
> @@ -2361,7 +2361,7 @@ static inline void *ib_dma_alloc_coherent(struct ib_device *dev,
>  					   u64 *dma_handle,
>  					   gfp_t flag)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->alloc_coherent)
>  		return dev->dma_ops->alloc_coherent(dev, size, dma_handle, flag);
>  	else {
>  		dma_addr_t handle;
> @@ -2384,7 +2384,7 @@ static inline void ib_dma_free_coherent(struct ib_device *dev,
>  					size_t size, void *cpu_addr,
>  					u64 dma_handle)
>  {
> -	if (dev->dma_ops)
> +	if (dev->dma_ops && dev->dma_ops->free_coherent)
>  		dev->dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
>  	else
>  		dma_free_coherent(dev->dma_device, size, cpu_addr, dma_handle);
> -- 
> 1.7.1
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
