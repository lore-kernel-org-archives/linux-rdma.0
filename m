From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix chunk sg list overflow in mlx4_alloc_icm()
Date: Thu, 6 May 2010 08:04:53 +0200
Message-ID: <20100506080453.43594a4b@frecb007965>
References: <20100430132131.0d829b3c@frecb007965>
	<adatyqmmej0.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyqmmej0.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi Roland,

On Wed, 05 May 2010 10:42:11 -0700
Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> good catch, applied.  Did this hit you in practice?  I guess it would
> take a big coherent ICM allocation, were you getting those?

  Yes, some customer got hit by this, which ended up corrupting memory.

> 
> Also what do you think of this independent cleanup on top of your patch?
> It handles the error case for allocation and then avoids having the
> common case inside a deeper nested block:

  No problem, it indeed makes the code more readable.

  Thanks,

  Sebastien.

> 
>  drivers/net/mlx4/icm.c |   37 +++++++++++++++++++------------------
>  1 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/mlx4/icm.c b/drivers/net/mlx4/icm.c
> index ef62f17..b07e4de 100644
> --- a/drivers/net/mlx4/icm.c
> +++ b/drivers/net/mlx4/icm.c
> @@ -163,29 +163,30 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
>  			ret = mlx4_alloc_icm_pages(&chunk->mem[chunk->npages],
>  						   cur_order, gfp_mask);
>  
> -		if (!ret) {
> -			++chunk->npages;
> -
> -			if (coherent)
> -				++chunk->nsg;
> -			else if (chunk->npages == MLX4_ICM_CHUNK_LEN) {
> -				chunk->nsg = pci_map_sg(dev->pdev, chunk->mem,
> -							chunk->npages,
> -							PCI_DMA_BIDIRECTIONAL);
> -
> -				if (chunk->nsg <= 0)
> -					goto fail;
> -			}
> +		if (ret) {
> +			if (--cur_order < 0)
> +				goto fail;
> +			else
> +				continue;
> +		}
>  
> -			if (chunk->npages == MLX4_ICM_CHUNK_LEN)
> -				chunk = NULL;
> +		++chunk->npages;
>  
> -			npages -= 1 << cur_order;
> -		} else {
> -			--cur_order;
> -			if (cur_order < 0)
> +		if (coherent)
> +			++chunk->nsg;
> +		else if (chunk->npages == MLX4_ICM_CHUNK_LEN) {
> +			chunk->nsg = pci_map_sg(dev->pdev, chunk->mem,
> +						chunk->npages,
> +						PCI_DMA_BIDIRECTIONAL);
> +
> +			if (chunk->nsg <= 0)
>  				goto fail;
>  		}
> +
> +		if (chunk->npages == MLX4_ICM_CHUNK_LEN)
> +			chunk = NULL;
> +
> +		npages -= 1 << cur_order;
>  	}
>  
>  	if (!coherent && chunk) {
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
