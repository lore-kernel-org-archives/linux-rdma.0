From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/ipoib: print only once when doesn't support
 IB_QP_CREATE_USE_GFP_NOIO
Date: Tue, 1 Nov 2016 15:48:24 +0200
Message-ID: <20161101134823.GA6681@yuval-lap.Home>
References: <1478003653-16248-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478003653-16248-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 01, 2016 at 02:34:13PM +0200, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Currently when the card doesn't support IB_QP_CREATE_USE_GFP_NOIO it warns
> on every QP creation, It becomes worse when driver works in connected mode
> we will see one print on each new connection, instead do it once.
> 
> Fixes: 09b93088d7 ('Add a QP creation flag to use GFP_NOIO allocations')
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 4ad297d..917393b 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -1053,8 +1053,8 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
>  
>  	tx_qp = ib_create_qp(priv->pd, &attr);
>  	if (PTR_ERR(tx_qp) == -EINVAL) {
> -		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> -			   priv->ca->name);
> +		pr_warn_once("can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> +			     priv->ca->name);

But it will still re-print it for different device, right?

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
