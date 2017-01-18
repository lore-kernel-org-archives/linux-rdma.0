From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/7] IB/mlx5: Return error for unsupported
 signature type
Date: Wed, 18 Jan 2017 22:37:09 +0200
Message-ID: <20170118203708.GE17688@yuval-lap>
References: <20170118121036.32642-1-leon@kernel.org>
 <20170118121036.32642-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118121036.32642-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 02:10:31PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In case of unsupported singature, we returned positive
> value, while the better approach is to return -EINVAL.
> 
> In addition, in this change, the error print is enriched
> to provide an actual supplied signature type.

What's the reason for the empty warnings i see in callers of this function?
("mlx5_ib_warn(dev, "\n");".

Can we remove these while we are here?

> 
> Fixes: e6631814fb3a ("IB/mlx5: Support IB_WR_REG_SIG_MR")
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 6a83fb3..9021074 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3637,8 +3637,9 @@ static int set_psv_wr(struct ib_sig_domain *domain,
>  		psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
>  		break;
>  	default:
> -		pr_err("Bad signature type given.\n");
> -		return 1;
> +		pr_err("Bad signature type (%d) is given.\n",
> +		       domain->sig_type);
> +		return -EINVAL;
>  	}
>  
>  	*seg += sizeof(*psv_seg);
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
