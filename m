From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 9/9] IB/ipoib: Change list_del to
 list_del_init in the tx object
Date: Mon, 2 Jan 2017 14:21:52 +0200
Message-ID: <20170102122151.GA25669@yuval-lap.uk.oracle.com>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-10-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161228124728.26619-10-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 28, 2016 at 02:47:28PM +0200, Leon Romanovsky wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Since ipoib_cm_tx_start function and ipoib_cm_tx_reap function
> belong to different work queues, they can run in parallel.
> In this case if ipoib_cm_tx_reap calls list_del and release the
> lock, ipoib_cm_tx_start may acquire it and call list_del_init
> on the already deleted object.
> Changing list_del to list_del_init in ipoib_cm_tx_reap fixes the problem.
> 
> Fixes: 839fcaba355a ("IPoIB: Connected mode experimental support")
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index c433e72..53d69d7 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -1392,7 +1392,7 @@ static void ipoib_cm_tx_reap(struct work_struct *work)
>  
>  	while (!list_empty(&priv->cm.reap_list)) {
>  		p = list_entry(priv->cm.reap_list.next, typeof(*p), list);
> -		list_del(&p->list);
> +		list_del_init(&p->list);
>  		spin_unlock_irqrestore(&priv->lock, flags);
>  		netif_tx_unlock_bh(dev);
>  		ipoib_cm_tx_destroy(p);

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

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
