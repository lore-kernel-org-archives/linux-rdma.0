From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end
 with newlines
Date: Tue, 26 Sep 2017 10:07:58 +0300
Message-ID: <20170926070758.GC5825@yuvallap>
References: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 12:20:01PM +0530, Arvind Yadav wrote:
> pr_err() and mlx5_ib_dbg( messages should terminated with a new-line to
> avoid other messages being concatenated.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index 0e2789d..92d643a 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1229,13 +1229,13 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>  		mr = alloc_mr_from_cache(pd, umem, virt_addr, length, ncont,
>  					 page_shift, order, access_flags);
>  		if (PTR_ERR(mr) == -EAGAIN) {
> -			mlx5_ib_dbg(dev, "cache empty for order %d", order);
> +			mlx5_ib_dbg(dev, "cache empty for order %d\n", order);
>  			mr = NULL;
>  		}
>  	} else if (!MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset)) {
>  		if (access_flags & IB_ACCESS_ON_DEMAND) {
>  			err = -EINVAL;
> -			pr_err("Got MR registration for ODP MR > 512MB, not supported for Connect-IB");
> +			pr_err("Got MR registration for ODP MR > 512MB, not supported for Connect-IB\n");
>  			goto error;
>  		}
>  		use_umr = false;
> -- 
> 1.9.1

FWIW,
Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
