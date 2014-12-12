From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 08/10] IPoIB: No longer use flush as a parameter
Date: Fri, 12 Dec 2014 14:05:48 +0000
Message-ID: <F3529576D8E232409F431C309E2939930918C914@CRSMSX102.amr.corp.intel.com>
References: <cover.1418229671.git.dledford@redhat.com>
 <28c67ea96dd0a0c3f39bfa78176537c3eb983c50.1418229671.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <28c67ea96dd0a0c3f39bfa78176537c3eb983c50.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> Subject: [PATCH 08/10] IPoIB: No longer use flush as a parameter
> 
> Various places in the IPoIB code had a deadlock related to flushing the
> ipoib workqueue.  Now that we have per device workqueues and a specific
> flush workqueue, there is no longer a deadlock issue with flushing the
> device specific workqueues and we can do so unilaterally.
> 
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |  6 +++---
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   | 19 +++++++++----------
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |  8 ++++----
>  3 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
> b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 28dc927c0e8..8ba80a6d3a4 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -484,10 +484,10 @@ void ipoib_ib_dev_flush_heavy(struct work_struct *work);
>  void ipoib_pkey_event(struct work_struct *work);
>  void ipoib_ib_dev_cleanup(struct net_device *dev);
> 
> -int ipoib_ib_dev_open(struct net_device *dev, int flush);
> +int ipoib_ib_dev_open(struct net_device *dev);
>  int ipoib_ib_dev_up(struct net_device *dev);
> -int ipoib_ib_dev_down(struct net_device *dev, int flush);
> -int ipoib_ib_dev_stop(struct net_device *dev, int flush);
> +int ipoib_ib_dev_down(struct net_device *dev);
> +int ipoib_ib_dev_stop(struct net_device *dev);
>  void ipoib_pkey_dev_check_presence(struct net_device *dev);
> 
>  int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 66096787119..fe65abb5150 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -664,7 +664,7 @@ static void ipoib_ib_tx_timer_func(unsigned long ctx)
>  	drain_tx_cq((struct net_device *)ctx);
>  }
> 
> -int ipoib_ib_dev_open(struct net_device *dev, int flush)
> +int ipoib_ib_dev_open(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  	int ret;
> @@ -706,7 +706,7 @@ int ipoib_ib_dev_open(struct net_device *dev, int flush)
>  dev_stop:
>  	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
>  		napi_enable(&priv->napi);
> -	ipoib_ib_dev_stop(dev, flush);
> +	ipoib_ib_dev_stop(dev);
>  	return -1;
>  }
> 
> @@ -738,7 +738,7 @@ int ipoib_ib_dev_up(struct net_device *dev)
>  	return ipoib_mcast_start_thread(dev);
>  }
> 
> -int ipoib_ib_dev_down(struct net_device *dev, int flush)
> +int ipoib_ib_dev_down(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> 
> @@ -807,7 +807,7 @@ void ipoib_drain_cq(struct net_device *dev)
>  	local_bh_enable();
>  }
> 
> -int ipoib_ib_dev_stop(struct net_device *dev, int flush)
> +int ipoib_ib_dev_stop(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  	struct ib_qp_attr qp_attr;
> @@ -880,8 +880,7 @@ timeout:
>  	/* Wait for all AHs to be reaped */
>  	set_bit(IPOIB_STOP_REAPER, &priv->flags);
>  	cancel_delayed_work(&priv->ah_reap_task);
> -	if (flush)
> -		flush_workqueue(priv->wq);
> +	flush_workqueue(priv->wq);
> 
>  	begin = jiffies;
> 
> @@ -918,7 +917,7 @@ int ipoib_ib_dev_init(struct net_device *dev, struct ib_device
> *ca, int port)
>  		    (unsigned long) dev);
> 
>  	if (dev->flags & IFF_UP) {
> -		if (ipoib_ib_dev_open(dev, 1)) {
> +		if (ipoib_ib_dev_open(dev)) {
>  			ipoib_transport_dev_cleanup(dev);
>  			return -ENODEV;
>  		}
> @@ -1040,12 +1039,12 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv
> *priv,
>  	}
> 
>  	if (level >= IPOIB_FLUSH_NORMAL)
> -		ipoib_ib_dev_down(dev, 0);
> +		ipoib_ib_dev_down(dev);
> 
>  	if (level == IPOIB_FLUSH_HEAVY) {
>  		if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
> -			ipoib_ib_dev_stop(dev, 0);
> -		if (ipoib_ib_dev_open(dev, 0) != 0)
> +			ipoib_ib_dev_stop(dev);
> +		if (ipoib_ib_dev_open(dev) != 0)
>  			return;
>  		if (netif_queue_stopped(dev))
>  			netif_start_queue(dev);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 42e5c278f48..6bad17d4d58 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -108,7 +108,7 @@ int ipoib_open(struct net_device *dev)
> 
>  	set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
> 
> -	if (ipoib_ib_dev_open(dev, 1)) {
> +	if (ipoib_ib_dev_open(dev)) {
>  		if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
>  			return 0;
>  		goto err_disable;
> @@ -139,7 +139,7 @@ int ipoib_open(struct net_device *dev)
>  	return 0;
> 
>  err_stop:
> -	ipoib_ib_dev_stop(dev, 1);
> +	ipoib_ib_dev_stop(dev);
> 
>  err_disable:
>  	clear_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
> @@ -157,8 +157,8 @@ static int ipoib_stop(struct net_device *dev)
> 
>  	netif_stop_queue(dev);
> 
> -	ipoib_ib_dev_down(dev, 1);
> -	ipoib_ib_dev_stop(dev, 0);
> +	ipoib_ib_dev_down(dev);
> +	ipoib_ib_dev_stop(dev);
> 
>  	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
>  		struct ipoib_dev_priv *cpriv;
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
