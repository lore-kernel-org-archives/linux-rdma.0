From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/13] SoftiWarp application buffer management
Date: Thu, 12 Oct 2017 13:40:57 -0400
Message-ID: <96733eba-cb00-9bc4-aa55-cba6daccfcc7@intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-8-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-8-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2017 8:28 AM, Bernard Metzler wrote:
.
.
.
> +
> +static int siw_dma_generic_mapping_error(struct device *dev,
> +					 dma_addr_t dma_addr)
> +{
> +	return dma_addr == 0;
> +}
> +
> +static int siw_dma_generic_supported(struct device *dev, u64 mask)
> +{
> +	return 1;
> +}
> +
> +const struct dma_map_ops siw_dma_generic_ops = {
> +	.alloc			= siw_dma_generic_alloc,
> +	.free			= siw_dma_generic_free,
> +	.map_page		= siw_dma_generic_map_page,
> +	.unmap_page		= siw_dma_generic_unmap_page,
> +	.map_sg			= siw_dma_generic_map_sg,
> +	.unmap_sg		= siw_dma_generic_unmap_sg,
> +	.sync_single_for_cpu	= siw_generic_sync_single_for_cpu,
> +	.sync_single_for_device	= siw_generic_sync_single_for_device,
> +	.sync_sg_for_cpu	= siw_generic_sync_sg_for_cpu,
> +	.sync_sg_for_device	= siw_generic_sync_sg_for_device,
> +	.mapping_error		= siw_dma_generic_mapping_error,
> +	.dma_supported		= siw_dma_generic_supported,
> +	.is_phys		= 1
> +};
> 

Not sure you need this stuff. Check out this patch:

0bbb3b7496ea ("IB/rxe, IB/rdmavt: Use dma_virt_ops instead of 
duplicating it"

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
