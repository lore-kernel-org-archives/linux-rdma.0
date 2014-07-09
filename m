From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-3.17 2/3] IB/ipoib: Use pkey change event instead of
 pkey polling mechanism
Date: Wed, 9 Jul 2014 15:32:09 +0000
Message-ID: <F3529576D8E232409F431C309E293993B89ED3@CRSMSX102.amr.corp.intel.com>
References: <1404812712-26187-1-git-send-email-ogerlitz@mellanox.com>
 <1404812712-26187-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404812712-26187-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On
> Behalf Of Or Gerlitz
> Sent: Tuesday, July 08, 2014 5:45 AM
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Estrin, Alex; Or Gerlitz
> Subject: [PATCH for-3.17 2/3] IB/ipoib: Use pkey change event instead of pkey
> polling mechanism
> 
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The current code use a dedicated polling logic to determine when the pkey
> assigned to the ipoib device is present in HCA port table and act accordingly.
> 
> Move to use the code which acts upon getting PKEY_CHANGE event to handle this
> task and remove the pkey polling logic/thread as they add extra complexity
> which isn't needed.
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |    6 +--
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   |   73 ++++++-----------------------
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    6 ++-
>  3 files changed, 20 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
> b/drivers/infiniband/ulp/ipoib/ipoib.h
> index c639f90..683d23a 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -86,7 +86,6 @@ enum {
>  	IPOIB_FLAG_INITIALIZED	  = 1,
>  	IPOIB_FLAG_ADMIN_UP	  = 2,
>  	IPOIB_PKEY_ASSIGNED	  = 3,
> -	IPOIB_PKEY_STOP		  = 4,
>  	IPOIB_FLAG_SUBINTERFACE	  = 5,
>  	IPOIB_MCAST_RUN		  = 6,
>  	IPOIB_STOP_REAPER	  = 7,
> @@ -312,7 +311,6 @@ struct ipoib_dev_priv {
>  	struct list_head multicast_list;
>  	struct rb_root multicast_tree;
> 
> -	struct delayed_work pkey_poll_task;
>  	struct delayed_work mcast_task;
>  	struct work_struct carrier_on_task;
>  	struct work_struct flush_light;
> @@ -477,6 +475,7 @@ int ipoib_ib_dev_open(struct net_device *dev);
>  int ipoib_ib_dev_up(struct net_device *dev);
>  int ipoib_ib_dev_down(struct net_device *dev, int flush);
>  int ipoib_ib_dev_stop(struct net_device *dev, int flush);
> +void ipoib_pkey_dev_check_presence(struct net_device *dev);
> 
>  int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
>  void ipoib_dev_cleanup(struct net_device *dev);
> @@ -532,8 +531,7 @@ int  ipoib_set_mode(struct net_device *dev, const char *buf);
> 
>  void ipoib_setup(struct net_device *dev);
> 
> -void ipoib_pkey_poll(struct work_struct *work);
> -int ipoib_pkey_dev_delay_open(struct net_device *dev);
> +void ipoib_pkey_open(struct ipoib_dev_priv *priv);
>  void ipoib_drain_cq(struct net_device *dev);
> 
>  void ipoib_set_ethtool_ops(struct net_device *dev);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 6a7003d..be8f971 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -709,7 +709,7 @@ dev_stop:
>  	return -1;
>  }
> 
> -static void ipoib_pkey_dev_check_presence(struct net_device *dev)
> +void ipoib_pkey_dev_check_presence(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  	u16 pkey_index = 0;
> @@ -745,14 +745,6 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
>  	clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
>  	netif_carrier_off(dev);
> 
> -	/* Shutdown the P_Key thread if still active */
> -	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
> -		mutex_lock(&pkey_mutex);
> -		set_bit(IPOIB_PKEY_STOP, &priv->flags);
> -		cancel_delayed_work_sync(&priv->pkey_poll_task);
> -		mutex_unlock(&pkey_mutex);
> -	}
> -
>  	ipoib_mcast_stop_thread(dev, flush);
>  	ipoib_mcast_dev_flush(dev);
> 
> @@ -988,9 +980,12 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
> 
>  	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
>  		/* for non-child devices must check/update the pkey value here */
> -		if (level == IPOIB_FLUSH_HEAVY &&
> -		    !test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
> -			update_parent_pkey(priv);
> +		if (level == IPOIB_FLUSH_HEAVY) {
> +			if (test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
> +				ipoib_pkey_open(priv);
> +			else
> +				update_parent_pkey(priv);
> +		}
>  		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
>  		return;
>  	}
> @@ -1009,8 +1004,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>  				clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
>  				ipoib_ib_dev_down(dev, 0);
>  				ipoib_ib_dev_stop(dev, 0);
> -				if (ipoib_pkey_dev_delay_open(dev))
> -					return;
> +				return;
>  			}
>  			/* restart QP only if P_Key index is changed */
>  			if (test_and_set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
> @@ -1094,54 +1088,15 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
>  	ipoib_transport_dev_cleanup(dev);
>  }
> 
> -/*
> - * Delayed P_Key Assigment Interim Support
> - *
> - * The following is initial implementation of delayed P_Key assigment
> - * mechanism. It is using the same approach implemented for the multicast
> - * group join. The single goal of this implementation is to quickly address
> - * Bug #2507. This implementation will probably be removed when the P_Key
> - * change async notification is available.
> - */
> -
> -void ipoib_pkey_poll(struct work_struct *work)
> +void ipoib_pkey_open(struct ipoib_dev_priv *priv)
>  {
> -	struct ipoib_dev_priv *priv =
> -		container_of(work, struct ipoib_dev_priv, pkey_poll_task.work);
> -	struct net_device *dev = priv->dev;
> 
> -	ipoib_pkey_dev_check_presence(dev);
> +	if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
> +		return;
> +
> +	ipoib_pkey_dev_check_presence(priv->dev);
> 
>  	if (test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
> -		ipoib_open(dev);
> -	else {
> -		mutex_lock(&pkey_mutex);
> -		if (!test_bit(IPOIB_PKEY_STOP, &priv->flags))
> -			queue_delayed_work(ipoib_workqueue,
> -					   &priv->pkey_poll_task,
> -					   HZ);
> -		mutex_unlock(&pkey_mutex);
> -	}
> +		ipoib_open(priv->dev);
>  }
> 
> -int ipoib_pkey_dev_delay_open(struct net_device *dev)
> -{
> -	struct ipoib_dev_priv *priv = netdev_priv(dev);
> -
> -	/* Look for the interface pkey value in the IB Port P_Key table and */
> -	/* set the interface pkey assigment flag                            */
> -	ipoib_pkey_dev_check_presence(dev);
> -
> -	/* P_Key value not assigned yet - start polling */
> -	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
> -		mutex_lock(&pkey_mutex);
> -		clear_bit(IPOIB_PKEY_STOP, &priv->flags);
> -		queue_delayed_work(ipoib_workqueue,
> -				   &priv->pkey_poll_task,
> -				   HZ);
> -		mutex_unlock(&pkey_mutex);
> -		return 1;
> -	}
> -
> -	return 0;
> -}
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 5786a78..35acbd4 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -108,7 +108,10 @@ int ipoib_open(struct net_device *dev)
> 
>  	set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
> 
> -	if (ipoib_pkey_dev_delay_open(dev))
> +
> +	ipoib_pkey_dev_check_presence(dev);
> +
> +	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
>  		return 0;
> 
>  	if (ipoib_ib_dev_open(dev))
> @@ -1379,7 +1382,6 @@ void ipoib_setup(struct net_device *dev)
>  	INIT_LIST_HEAD(&priv->dead_ahs);
>  	INIT_LIST_HEAD(&priv->multicast_list);
> 
> -	INIT_DELAYED_WORK(&priv->pkey_poll_task, ipoib_pkey_poll);
>  	INIT_DELAYED_WORK(&priv->mcast_task,   ipoib_mcast_join_task);
>  	INIT_WORK(&priv->carrier_on_task, ipoib_mcast_carrier_on_task);
>  	INIT_WORK(&priv->flush_light,   ipoib_ib_dev_flush_light);
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
