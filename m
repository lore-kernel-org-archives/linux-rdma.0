From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 07/10] IPoIB: Make ipoib_mcast_stop_thread flush the
 workqueue
Date: Fri, 12 Dec 2014 14:05:18 +0000
Message-ID: <F3529576D8E232409F431C309E2939930918C8FF@CRSMSX102.amr.corp.intel.com>
References: <cover.1418229671.git.dledford@redhat.com>
 <8c03e7569e7da863c0507dbf95e96ad06280b938.1418229671.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8c03e7569e7da863c0507dbf95e96ad06280b938.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> Subject: [PATCH 07/10] IPoIB: Make ipoib_mcast_stop_thread flush the workqueue
> 
> We used to pass a flush variable to mcast_stop_thread to indicate if we
> should flush the workqueue or not.  This was due to some code trying to
> flush a workqueue that it was currently running on which is a no-no.
> Now that we have per-device work queues, and now that
> ipoib_mcast_restart_task has taken the fact that it is queued on a
> single thread workqueue with all of the ipoib_mcast_join_task's and
> therefore has no need to stop the join task while it runs, we can do
> away with the flush parameter and unilaterally flush always.
> 
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h           |  2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 21 +++++++++------------
>  3 files changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
> b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 45fd10a72ec..28dc927c0e8 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -499,7 +499,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct
> sk_buff *skb);
> 
>  void ipoib_mcast_restart_task(struct work_struct *work);
>  int ipoib_mcast_start_thread(struct net_device *dev);
> -int ipoib_mcast_stop_thread(struct net_device *dev, int flush);
> +int ipoib_mcast_stop_thread(struct net_device *dev);
> 
>  void ipoib_mcast_dev_down(struct net_device *dev);
>  void ipoib_mcast_dev_flush(struct net_device *dev);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index bfd17d41b5f..66096787119 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -747,7 +747,7 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
>  	clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
>  	netif_carrier_off(dev);
> 
> -	ipoib_mcast_stop_thread(dev, flush);
> +	ipoib_mcast_stop_thread(dev);
>  	ipoib_mcast_dev_flush(dev);
> 
>  	ipoib_flush_paths(dev);
> @@ -1097,7 +1097,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
>  	 */
>  	ipoib_flush_paths(dev);
> 
> -	ipoib_mcast_stop_thread(dev, 1);
> +	ipoib_mcast_stop_thread(dev);
>  	ipoib_mcast_dev_flush(dev);
> 
>  	ipoib_transport_dev_cleanup(dev);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 845f910eb21..bc50dd0d0e4 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -648,7 +648,7 @@ int ipoib_mcast_start_thread(struct net_device *dev)
>  	return 0;
>  }
> 
> -int ipoib_mcast_stop_thread(struct net_device *dev, int flush)
> +int ipoib_mcast_stop_thread(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> 
> @@ -659,8 +659,7 @@ int ipoib_mcast_stop_thread(struct net_device *dev, int flush)
>  	cancel_delayed_work(&priv->mcast_task);
>  	mutex_unlock(&mcast_mutex);
> 
> -	if (flush)
> -		flush_workqueue(priv->wq);
> +	flush_workqueue(priv->wq);
> 
>  	return 0;
>  }
> @@ -838,8 +837,6 @@ void ipoib_mcast_restart_task(struct work_struct *work)
> 
>  	ipoib_dbg_mcast(priv, "restarting multicast task\n");
> 
> -	ipoib_mcast_stop_thread(dev, 0);
> -
>  	local_irq_save(flags);
>  	netif_addr_lock(dev);
>  	spin_lock(&priv->lock);
> @@ -936,13 +933,10 @@ void ipoib_mcast_restart_task(struct work_struct *work)
>  	 * We have to cancel outside of the spinlock, but we have to
>  	 * take the rtnl lock or else we race with the removal of
>  	 * entries from the remove list in mcast_dev_flush as part
> -	 * of ipoib_stop() which will call mcast_stop_thread with
> -	 * flush == 1 while holding the rtnl lock, and the
> -	 * flush_workqueue won't complete until this restart_mcast_task
> -	 * completes.  So do like the carrier on task and attempt to
> -	 * take the rtnl lock, but if we can't before the ADMIN_UP flag
> -	 * goes away, then just return and know that the remove list will
> -	 * get flushed later by mcast_stop_thread.
> +	 * of ipoib_stop().  We detect the drop of the ADMIN_UP flag
> +	 * to signal that we have hit this particular race, and we
> +	 * return since we know we don't need to do anything else
> +	 * anyway.
>  	 */
>  	while (!rtnl_trylock()) {
>  		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> @@ -954,6 +948,9 @@ void ipoib_mcast_restart_task(struct work_struct *work)
>  		ipoib_mcast_leave(mcast->dev, mcast);
>  		ipoib_mcast_free(mcast);
>  	}
> +	/*
> +	 * Restart our join task if needed
> +	 */
>  	ipoib_mcast_start_thread(dev);
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
