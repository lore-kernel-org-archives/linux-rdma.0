From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/9] IB/ipoib: Add detailed error message to
 dev_queue_xmit call
Date: Wed, 28 Dec 2016 14:11:00 +0200
Message-ID: <20161228121100.GC6237@yuval-lap>
References: <20161227133911.14340-1-leon@kernel.org>
 <20161227133911.14340-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161227133911.14340-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Tue, Dec 27, 2016 at 03:39:08PM +0200, Leon Romanovsky wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add a detailed return code to dev_queue_xmit function when
> calling to requeue packet via __skb_dequeue.
> 
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c        | 7 ++++---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 8 +++++---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 6 ++++--
>  3 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 1c7a9a1..a720d2d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -1015,9 +1015,10 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
>  
>  	while ((skb = __skb_dequeue(&skqueue))) {
>  		skb->dev = p->dev;
> -		if (dev_queue_xmit(skb))
> -			ipoib_warn(priv, "dev_queue_xmit failed "
> -				   "to requeue packet\n");
> +		ret = dev_queue_xmit(skb);
> +		if (ret)
> +			ipoib_warn(priv, "%s:dev_queue_xmit failed to re-queue packet, ret:%d\n",
> +				   __func__, ret);
>  	}
>  
>  	ret = ib_send_cm_rtu(cm_id, NULL, 0);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 1090fe2..b5e1e4d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -844,10 +844,12 @@ static void path_rec_completion(int status,
>  		ipoib_put_ah(old_ah);
>  
>  	while ((skb = __skb_dequeue(&skqueue))) {
> +		int ret;
>  		skb->dev = dev;
> -		if (dev_queue_xmit(skb))
> -			ipoib_warn(priv, "dev_queue_xmit failed "
> -				   "to requeue packet\n");
> +		ret = dev_queue_xmit(skb);
> +		if (ret)
> +			ipoib_warn(priv, "%s: dev_queue_xmit failed to re-queue packet, ret:%d\n",
> +				   __func__, ret);
>  	}
>  }
>  
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index fddff40..7c6c67b 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -314,9 +314,11 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
>  		netif_tx_unlock_bh(dev);
>  
>  		skb->dev = dev;
> -		if (dev_queue_xmit(skb))
> -			ipoib_warn(priv, "dev_queue_xmit failed to requeue packet\n");
>  
> +		ret = dev_queue_xmit(skb);
> +		if (ret)
> +			ipoib_warn(priv, "%s:dev_queue_xmit failed to re-queue packet, ret:%d\n",
> +				   __func__, ret);
>  		netif_tx_lock_bh(dev);
>  	}
>  	netif_tx_unlock_bh(dev);
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
