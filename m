From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 01/10] IPoIB: Consolidate rtnl_lock tasks in workqueue
Date: Fri, 12 Dec 2014 14:02:23 +0000
Message-ID: <F3529576D8E232409F431C309E2939930918C8A6@CRSMSX102.amr.corp.intel.com>
References: <cover.1418229671.git.dledford@redhat.com>
 <84fa20ea8c6763fee66b378adda1da52cd48e342.1418229671.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <84fa20ea8c6763fee66b378adda1da52cd48e342.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On
> Behalf Of Doug Ledford
> Sent: Wednesday, December 10, 2014 11:47 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Doug Ledford
> Subject: [PATCH 01/10] IPoIB: Consolidate rtnl_lock tasks in workqueue
> 
> Setting the mtu can safely be moved to the carrier_on_task, which keeps
> us from needing to take the rtnl lock in the join_finish section.
> 
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index ffb83b5f7e8..eee66d13e5b 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -190,12 +190,6 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
>  		spin_unlock_irq(&priv->lock);
>  		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
>  		set_qkey = 1;
> -
> -		if (!ipoib_cm_admin_enabled(dev)) {
> -			rtnl_lock();
> -			dev_set_mtu(dev, min(priv->mcast_mtu, priv->admin_mtu));
> -			rtnl_unlock();
> -		}
>  	}
> 
>  	if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
> @@ -371,6 +365,8 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
>  	}
> 
>  	rtnl_lock();
> +	if (!ipoib_cm_admin_enabled(priv->dev))
> +		dev_set_mtu(priv->dev, min(priv->mcast_mtu, priv->admin_mtu));
>  	netif_carrier_on(priv->dev);
>  	rtnl_unlock();
>  }
> --
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
