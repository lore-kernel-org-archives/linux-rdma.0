From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/core: Remove a set-but-not-used variable from
 ib_sg_to_pages()
Date: Tue, 29 Dec 2015 12:55:57 +0200
Message-ID: <20151229105557.GC17694@leon.nu>
References: <5682561F.7000400@sandisk.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5682561F.7000400-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2015 at 10:45:03AM +0100, Bart Van Assche wrote:
> Detected this by building the IB core with W=1. See also patch
> "IB core: Fix ib_sg_to_pages()" (commit 8f5ba10ed40a).

Reviewed-by: Leon Romanovsky <leon.romanovsky-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 545906d..c90ed29 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1530,7 +1530,7 @@ int ib_sg_to_pages(struct ib_mr *mr,
>  		   int (*set_page)(struct ib_mr *, u64))
>  {
>  	struct scatterlist *sg;
> -	u64 last_end_dma_addr = 0, last_page_addr = 0;
> +	u64 last_end_dma_addr = 0;
>  	unsigned int last_page_off = 0;
>  	u64 page_mask = ~((u64)mr->page_size - 1);
>  	int i, ret;
> @@ -1572,7 +1572,6 @@ next_page:
>  
>  		mr->length += dma_len;
>  		last_end_dma_addr = end_dma_addr;
> -		last_page_addr = end_dma_addr & page_mask;
>  		last_page_off = end_dma_addr & ~page_mask;
>  	}
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
