From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 02/10] IPoIB: Make the carrier_on_task race aware
Date: Fri, 12 Dec 2014 14:02:47 +0000
Message-ID: <F3529576D8E232409F431C309E2939930918C8B2@CRSMSX102.amr.corp.intel.com>
References: <cover.1418229671.git.dledford@redhat.com>
 <9da7866273a37e8927eb079d90c96074a118c5bd.1418229671.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9da7866273a37e8927eb079d90c96074a118c5bd.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> Subject: [PATCH 02/10] IPoIB: Make the carrier_on_task race aware
> 
> We blindly assume that we can just take the rtnl lock and that will
> prevent races with downing this interface.  Unfortunately, that's not
> the case.  In ipoib_mcast_stop_thread() we will call flush_workqueue()
> in an attempt to clear out all remaining instances of ipoib_join_task.
> But, since this task is put on the same workqueue as the join task, the
> flush_workqueue waits on this thread too.  But this thread is deadlocked
> on the rtnl lock.  The better thing here is to use trylock and loop on
> that until we either get the lock or we see that FLAG_ADMIN_UP has
> been cleared, in which case we don't need to do anything anyway and we
> just return.
> 
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index eee66d13e5b..9862c76a83f 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -353,18 +353,27 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
>  						   carrier_on_task);
>  	struct ib_port_attr attr;
> 
> -	/*
> -	 * Take rtnl_lock to avoid racing with ipoib_stop() and
> -	 * turning the carrier back on while a device is being
> -	 * removed.
> -	 */
>  	if (ib_query_port(priv->ca, priv->port, &attr) ||
>  	    attr.state != IB_PORT_ACTIVE) {
>  		ipoib_dbg(priv, "Keeping carrier off until IB port is active\n");
>  		return;
>  	}
> 
> -	rtnl_lock();
> +	/*
> +	 * Take rtnl_lock to avoid racing with ipoib_stop() and
> +	 * turning the carrier back on while a device is being
> +	 * removed.  However, ipoib_stop() will attempt to flush
> +	 * the workqueue while holding the rtnl lock, so loop
> +	 * on trylock until either we get the lock or we see
> +	 * FLAG_ADMIN_UP go away as that signals that we are bailing
> +	 * and can safely ignore the carrier on work
> +	 */
> +	while (!rtnl_trylock()) {
> +		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> +			return;
> +		else
> +			msleep(20);
> +	}
>  	if (!ipoib_cm_admin_enabled(priv->dev))
>  		dev_set_mtu(priv->dev, min(priv->mcast_mtu, priv->admin_mtu));
>  	netif_carrier_on(priv->dev);
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
