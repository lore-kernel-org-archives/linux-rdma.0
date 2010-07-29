From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC PATCH 2/4] uverbs: Add common ib_iomem_get service
Date: Thu, 29 Jul 2010 16:20:19 -0500
Message-ID: <4C51F093.6030009@opengridcomputing.com>
References: <20100729162339.14674.15788.stgit@build.ogc.int> <20100729162509.14674.34237.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729162509.14674.34237.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/29/10 11:25 AM, Tom Tucker wrote:
> From: Tom Tucker<tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>
> Add an ib_iomem_get service that converts a vma to an array of
> physical addresses. This makes it easier for each device driver to
> add support for the reg_io_mr provider method.
>
> Signed-off-by: Tom Tucker<tom-/Yg/VP3ZvrM@public.gmane.org>
> ---
>
>   drivers/infiniband/core/umem.c |  248 ++++++++++++++++++++++++++++++++++++++--
>   include/rdma/ib_umem.h         |   14 ++
>   2 files changed, 251 insertions(+), 11 deletions(-)
>
> [...snip...]
>    

> +			/* The pfn_list we built is a set of Page
> +			 * Frame Numbers (PFN) whose physical address
> +			 * is PFN<<  PAGE_SHIFT. The SG DMA mapping
> +			 * services expect page addresses, not PFN,
> +			 * therefore, we have to do the dma mapping
> +			 * ourselves here. */
> +			for (i = 0; i<  chunk->nents; ++i) {
> +				sg_set_page(&chunk->page_list[i], 0,
> +					    PAGE_SIZE, 0);
> +				chunk->page_list[i].dma_address =
> +					(pfn_list[i]<<  PAGE_SHIFT);
>    

This is not architecture independent. Does anyone have any thoughts on 
how this ought to be done?

> +				chunk->page_list[i].dma_length = PAGE_SIZE;
> +			}
> +			chunk->nmap = chunk->nents;
> +			ret -= chunk->nents;
> +			off += chunk->nents;
> +			list_add_tail(&chunk->list,&umem->chunk_list);
> +		}
> +
> +		ret = 0;
> +	}
> +
>    
[...snip...]

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
