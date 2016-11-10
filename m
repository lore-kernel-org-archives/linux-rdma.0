From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/IPoIB: Remove can't use GFP_NOIO warning
Date: Thu, 10 Nov 2016 10:33:37 +0200
Message-ID: <20161110083336.GC9839@yuval-lap.uk.oracle.com>
References: <1478765808-12517-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478765808-12517-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Thu, Nov 10, 2016 at 10:16:48AM +0200, Leon Romanovsky wrote:
> From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Remove the warning print of "can't use of GFP_NOIO" to avoid prints in
> each QP creation when devices aren't supporting IB_QP_CREATE_USE_GFP_NOIO.
> 
> This print become more annoying when the IPoIB interface is configured
> to work in connected mode.
> 
> Fixes: 09b93088d750 ('IB: Add a QP creation flag to use GFP_NOIO allocations')
> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 4ad297d..50c9772 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -1053,8 +1053,6 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
>  
>  	tx_qp = ib_create_qp(priv->pd, &attr);
>  	if (PTR_ERR(tx_qp) == -EINVAL) {
> -		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> -			   priv->ca->name);
>  		attr.create_flags &= ~IB_QP_CREATE_USE_GFP_NOIO;
>  		tx_qp = ib_create_qp(priv->pd, &attr);
>  	}
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
