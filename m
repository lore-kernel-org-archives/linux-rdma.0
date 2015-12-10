From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 02/37] IB/rdmavt: Consolidate dma ops in rdmavt.
Date: Thu, 10 Dec 2015 14:07:04 +0200
Message-ID: <56696AE8.8000500@mellanox.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204305.8144.7038.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204305.8144.7038.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A few nits:

On 07/12/2015 22:43, Dennis Dalessandro wrote:
> +static int rvt_map_sg(struct ib_device *dev, struct scatterlist *sgl,
> +		      int nents, enum dma_data_direction direction)
> +{
> +	struct scatterlist *sg;
> +	u64 addr;
> +	int i;
> +	int ret = nents;
> +
> +	if (WARN_ON(!valid_dma_direction(direction)))
> +		return BAD_DMA_ADDRESS;
The function returns 0 on error, so its technically correct, but it
doesn't return a DMA address, so I think it would make more sense to
return 0 here and not BAD_DMA_ADDRESS.

> +
> +	for_each_sg(sgl, sg, nents, i) {
> +		addr = (u64)page_address(sg_page(sg));
> +		if (!addr) {
> +			ret = 0;
> +			break;
> +		}
> +		sg->dma_address = addr + sg->offset;
> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
> +		sg->dma_length = sg->length;
> +#endif
> +	}
> +	return ret;
> +}

> diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
> index ec210f3..a19a3af 100644
> --- a/drivers/infiniband/sw/rdmavt/vt.h
> +++ b/drivers/infiniband/sw/rdmavt/vt.h
> @@ -52,5 +52,6 @@
>   */
>  
>  #include <rdma/rdma_vt.h>
> +#include "dma.h"
Why do you need the dma.h file included here? Won't it be enough to
include it in vt.c?

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
