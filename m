From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 20/22] IB/mlx4: Check that reserved fields in
 mlx4_ib_create_qp_rss are zero
Date: Sun, 13 Aug 2017 13:24:22 +0300
Message-ID: <20170813102420.GA5245@yuvallap>
References: <20170813101816.3120-1-leon@kernel.org>
 <20170813101816.3120-21-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170813101816.3120-21-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 13, 2017 at 01:18:14PM +0300, Leon Romanovsky wrote:
> From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> According to mlx4 convention, need to fail the command due to a non-zero
> value in the user data which is expected to be zero.
> 
> Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
> Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index 44d2d0a2d5e0..2874d8790570 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -813,6 +813,9 @@ static struct ib_qp *_mlx4_ib_create_qp_rss(struct ib_pd *pd,
>  		return ERR_PTR(-EFAULT);
>  	}
>  
> +	if (memchr_inv(ucmd.reserved, 0, sizeof(ucmd.reserved)))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
>  	if (ucmd.comp_mask || ucmd.reserved1)
>  		return ERR_PTR(-EOPNOTSUPP);

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

>  
> -- 
> 2.14.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
