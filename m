From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 25/25] IB/mlx4: Workaround for mlx4_alloc_priv_pages()
 array allocator
Date: Wed, 22 Jun 2016 14:56:05 +0300
Message-ID: <576A7CD5.4000603@grimberg.me>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
 <20160620161200.10809.45762.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160620161200.10809.45762.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 20/06/16 19:12, Chuck Lever wrote:
> Ensure the MR's PBL array never occupies the last 8 bytes of a page.
> This eliminates random "Local Protection Error" flushes when SLUB
> debugging is enabled.
>
> Fixes: 1b2cd0fc673c ('IB/mlx4: Support the new memory registration API')
> Suggested-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx4/mlx4_ib.h |    2 +-
>   drivers/infiniband/hw/mlx4/mr.c      |   40 +++++++++++++++++++---------------
>   2 files changed, 23 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> index 6c5ac5d..29acda2 100644
> --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> @@ -139,7 +139,7 @@ struct mlx4_ib_mr {
>   	u32			max_pages;
>   	struct mlx4_mr		mmr;
>   	struct ib_umem	       *umem;
> -	void			*pages_alloc;
> +	size_t			page_map_size;
>   };
>
>   struct mlx4_ib_mw {
> diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
> index 6312721..b90e47c 100644
> --- a/drivers/infiniband/hw/mlx4/mr.c
> +++ b/drivers/infiniband/hw/mlx4/mr.c
> @@ -277,20 +277,27 @@ mlx4_alloc_priv_pages(struct ib_device *device,
>   		      struct mlx4_ib_mr *mr,
>   		      int max_pages)
>   {
> -	int size = max_pages * sizeof(u64);
> -	int add_size;
>   	int ret;
>
> -	add_size = max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
> -
> -	mr->pages_alloc = kzalloc(size + add_size, GFP_KERNEL);
> -	if (!mr->pages_alloc)
> +	/* Round mapping size up to ensure DMA cacheline
> +	 * alignment, and cache the size to avoid mult/div
> +	 * in fast path.
> +	 */
> +	mr->page_map_size = roundup(max_pages * sizeof(u64),
> +				    MLX4_MR_PAGES_ALIGN);
> +	if (mr->page_map_size > PAGE_SIZE)
> +		return -EINVAL;
> +
> +	/* This is overkill, but hardware requires that the
> +	 * PBL array begins at a properly aligned address and
> +	 * never occupies the last 8 bytes of a page.
> +	 */
> +	mr->pages = (__be64 *)get_zeroed_page(GFP_KERNEL);
> +	if (!mr->pages)
>   		return -ENOMEM;

Again, I'm not convinced that this is a better choice then allocating
the exact needed size as dma coherent, but given that the dma coherent
allocations are always page aligned I wander if it's not the same
effect...

In any event, we can move forward with this for now:

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
