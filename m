From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/10] IPoIB: Use dedicated workqueues per interface
Date: Fri, 12 Dec 2014 14:05:00 +0000
Message-ID: <F3529576D8E232409F431C309E2939930918C8F5@CRSMSX102.amr.corp.intel.com>
References: <cover.1418229671.git.dledford@redhat.com>
 <f733fa8b780b1ac512efb748683dca001fb2edf7.1418229671.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f733fa8b780b1ac512efb748683dca001fb2edf7.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> Subject: [PATCH 06/10] IPoIB: Use dedicated workqueues per interface
> 
> During my recent work on the rtnl lock deadlock in the IPoIB driver, I
> saw that even once I fixed the apparent races for a single device, as
> soon as that device had any children, new races popped up.  It turns out
> that this is because no matter how well we protect against races on a
> single device, the fact that all devices use the same workqueue, and
> flush_workqueue() flushes *everything* from that workqueue, we can have
> one device in the middle of a down and holding the rtnl lock and another
> totally unrelated device needing to run mcast_restart_task, which wants
> the rtnl lock and will loop trying to take it unless is sees its own
> FLAG_ADMIN_UP flag go away.  Because the unrelated interface will never
> see its own ADMIN_UP flag drop, the interface going down will deadlock
> trying to flush the queue.  There are several possible solutions to this
> problem:
> 
> Make carrier_on_task and mcast_restart_task try to take the rtnl for
> some set period of time and if they fail, then bail.  This runs the real
> risk of dropping work on the floor, which can end up being its own
> separate kind of deadlock.
> 
> Set some global flag in the driver that says some device is in the
> middle of going down, letting all tasks know to bail.  Again, this can
> drop work on the floor.  I suppose if our own ADMIN_UP flag doesn't go
> away, then maybe after a few tries on the rtnl lock we can queue our own
> task back up as a delayed work and return and avoid dropping work on the
> floor that way.  But I'm not 100% convinced that we won't cause other
> problems.
> 
> Or the method this patch attempts to use, which is when we bring an
> interface up, create a workqueue specifically for that interface, so
> that when we take it back down, we are flushing only those tasks
> associated with our interface.  In addition, keep the global workqueue,
> but now limit it to only flush tasks.  In this way, the flush tasks can
> always flush the device specific work queues without having deadlock
> issues.
> 
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c        | 18 +++++++++---------
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  6 +++---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 19 ++++++++++++-------
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 26 ++++++++++++--------------
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c     | 22 +++++++++++++++++++++-
>  6 files changed, 58 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
> b/drivers/infiniband/ulp/ipoib/ipoib.h
> index f4c1b20b23b..45fd10a72ec 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -323,6 +323,7 @@ struct ipoib_dev_priv {
>  	struct list_head multicast_list;
>  	struct rb_root multicast_tree;
> 
> +	struct workqueue_struct *wq;
>  	struct delayed_work mcast_task;
>  	struct work_struct carrier_on_task;
>  	struct work_struct flush_light;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 933efcea0d0..56959adb6c7 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -474,7 +474,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct
> ib_cm_event *even
>  	}
> 
>  	spin_lock_irq(&priv->lock);
> -	queue_delayed_work(ipoib_workqueue,
> +	queue_delayed_work(priv->wq,
>  			   &priv->cm.stale_task, IPOIB_CM_RX_DELAY);
>  	/* Add this entry to passive ids list head, but do not re-add it
>  	 * if IB_EVENT_QP_LAST_WQE_REACHED has moved it to flush list. */
> @@ -576,7 +576,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc
> *wc)
>  			spin_lock_irqsave(&priv->lock, flags);
>  			list_splice_init(&priv->cm.rx_drain_list, &priv-
> >cm.rx_reap_list);
>  			ipoib_cm_start_rx_drain(priv);
> -			queue_work(ipoib_workqueue, &priv->cm.rx_reap_task);
> +			queue_work(priv->wq, &priv->cm.rx_reap_task);
>  			spin_unlock_irqrestore(&priv->lock, flags);
>  		} else
>  			ipoib_warn(priv, "cm recv completion event with wrid %d (>
> %d)\n",
> @@ -603,7 +603,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc
> *wc)
>  				spin_lock_irqsave(&priv->lock, flags);
>  				list_move(&p->list, &priv->cm.rx_reap_list);
>  				spin_unlock_irqrestore(&priv->lock, flags);
> -				queue_work(ipoib_workqueue, &priv->cm.rx_reap_task);
> +				queue_work(priv->wq, &priv->cm.rx_reap_task);
>  			}
>  			return;
>  		}
> @@ -827,7 +827,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc
> *wc)
> 
>  		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
>  			list_move(&tx->list, &priv->cm.reap_list);
> -			queue_work(ipoib_workqueue, &priv->cm.reap_task);
> +			queue_work(priv->wq, &priv->cm.reap_task);
>  		}
> 
>  		clear_bit(IPOIB_FLAG_OPER_UP, &tx->flags);
> @@ -1255,7 +1255,7 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
> 
>  		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
>  			list_move(&tx->list, &priv->cm.reap_list);
> -			queue_work(ipoib_workqueue, &priv->cm.reap_task);
> +			queue_work(priv->wq, &priv->cm.reap_task);
>  		}
> 
>  		spin_unlock_irqrestore(&priv->lock, flags);
> @@ -1284,7 +1284,7 @@ struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device
> *dev, struct ipoib_path
>  	tx->dev = dev;
>  	list_add(&tx->list, &priv->cm.start_list);
>  	set_bit(IPOIB_FLAG_INITIALIZED, &tx->flags);
> -	queue_work(ipoib_workqueue, &priv->cm.start_task);
> +	queue_work(priv->wq, &priv->cm.start_task);
>  	return tx;
>  }
> 
> @@ -1295,7 +1295,7 @@ void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
>  	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
>  		spin_lock_irqsave(&priv->lock, flags);
>  		list_move(&tx->list, &priv->cm.reap_list);
> -		queue_work(ipoib_workqueue, &priv->cm.reap_task);
> +		queue_work(priv->wq, &priv->cm.reap_task);
>  		ipoib_dbg(priv, "Reap connection for gid %pI6\n",
>  			  tx->neigh->daddr + 4);
>  		tx->neigh = NULL;
> @@ -1417,7 +1417,7 @@ void ipoib_cm_skb_too_long(struct net_device *dev, struct
> sk_buff *skb,
> 
>  	skb_queue_tail(&priv->cm.skb_queue, skb);
>  	if (e)
> -		queue_work(ipoib_workqueue, &priv->cm.skb_task);
> +		queue_work(priv->wq, &priv->cm.skb_task);
>  }
> 
>  static void ipoib_cm_rx_reap(struct work_struct *work)
> @@ -1450,7 +1450,7 @@ static void ipoib_cm_stale_task(struct work_struct *work)
>  	}
> 
>  	if (!list_empty(&priv->cm.passive_ids))
> -		queue_delayed_work(ipoib_workqueue,
> +		queue_delayed_work(priv->wq,
>  				   &priv->cm.stale_task, IPOIB_CM_RX_DELAY);
>  	spin_unlock_irq(&priv->lock);
>  }
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 72626c34817..bfd17d41b5f 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -655,7 +655,7 @@ void ipoib_reap_ah(struct work_struct *work)
>  	__ipoib_reap_ah(dev);
> 
>  	if (!test_bit(IPOIB_STOP_REAPER, &priv->flags))
> -		queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task,
> +		queue_delayed_work(priv->wq, &priv->ah_reap_task,
>  				   round_jiffies_relative(HZ));
>  }
> 
> @@ -696,7 +696,7 @@ int ipoib_ib_dev_open(struct net_device *dev, int flush)
>  	}
> 
>  	clear_bit(IPOIB_STOP_REAPER, &priv->flags);
> -	queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task,
> +	queue_delayed_work(priv->wq, &priv->ah_reap_task,
>  			   round_jiffies_relative(HZ));
> 
>  	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
> @@ -881,7 +881,7 @@ timeout:
>  	set_bit(IPOIB_STOP_REAPER, &priv->flags);
>  	cancel_delayed_work(&priv->ah_reap_task);
>  	if (flush)
> -		flush_workqueue(ipoib_workqueue);
> +		flush_workqueue(priv->wq);
> 
>  	begin = jiffies;
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 2cf81ef5141..42e5c278f48 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -839,7 +839,7 @@ static void ipoib_set_mcast_list(struct net_device *dev)
>  		return;
>  	}
> 
> -	queue_work(ipoib_workqueue, &priv->restart_task);
> +	queue_work(priv->wq, &priv->restart_task);
>  }
> 
>  static u32 ipoib_addr_hash(struct ipoib_neigh_hash *htbl, u8 *daddr)
> @@ -954,7 +954,7 @@ static void ipoib_reap_neigh(struct work_struct *work)
>  	__ipoib_reap_neigh(priv);
> 
>  	if (!test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
> -		queue_delayed_work(ipoib_workqueue, &priv->neigh_reap_task,
> +		queue_delayed_work(priv->wq, &priv->neigh_reap_task,
>  				   arp_tbl.gc_interval);
>  }
> 
> @@ -1133,7 +1133,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
> 
>  	/* start garbage collection */
>  	clear_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
> -	queue_delayed_work(ipoib_workqueue, &priv->neigh_reap_task,
> +	queue_delayed_work(priv->wq, &priv->neigh_reap_task,
>  			   arp_tbl.gc_interval);
> 
>  	return 0;
> @@ -1293,7 +1293,7 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device
> *ca, int port)
>  	return 0;
> 
>  out_dev_uninit:
> -	ipoib_ib_dev_cleanup();
> +	ipoib_ib_dev_cleanup(dev);
> 
>  out_tx_ring_cleanup:
>  	vfree(priv->tx_ring);
> @@ -1646,7 +1646,7 @@ register_failed:
>  	/* Stop GC if started before flush */
>  	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
>  	cancel_delayed_work(&priv->neigh_reap_task);
> -	flush_workqueue(ipoib_workqueue);
> +	flush_workqueue(priv->wq);
> 
>  event_failed:
>  	ipoib_dev_cleanup(priv->dev);
> @@ -1717,7 +1717,7 @@ static void ipoib_remove_one(struct ib_device *device)
>  		/* Stop GC */
>  		set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
>  		cancel_delayed_work(&priv->neigh_reap_task);
> -		flush_workqueue(ipoib_workqueue);
> +		flush_workqueue(priv->wq);
> 
>  		unregister_netdev(priv->dev);
>  		free_netdev(priv->dev);
> @@ -1758,8 +1758,13 @@ static int __init ipoib_init_module(void)
>  	 * unregister_netdev() and linkwatch_event take the rtnl lock,
>  	 * so flush_scheduled_work() can deadlock during device
>  	 * removal.
> +	 *
> +	 * In addition, bringing one device up and another down at the
> +	 * same time can deadlock a single workqueue, so we have this
> +	 * global fallback workqueue, but we also attempt to open a
> +	 * per device workqueue each time we bring an interface up
>  	 */
> -	ipoib_workqueue = create_singlethread_workqueue("ipoib");
> +	ipoib_workqueue = create_singlethread_workqueue("ipoib_flush");
>  	if (!ipoib_workqueue) {
>  		ret = -ENOMEM;
>  		goto err_fs;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 41325960e4e..845f910eb21 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -388,7 +388,7 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
>  	 * the workqueue while holding the rtnl lock, so loop
>  	 * on trylock until either we get the lock or we see
>  	 * FLAG_ADMIN_UP go away as that signals that we are bailing
> -	 * and can safely ignore the carrier on work
> +	 * and can safely ignore the carrier on work.
>  	 */
>  	while (!rtnl_trylock()) {
>  		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> @@ -432,15 +432,14 @@ static int ipoib_mcast_join_complete(int status,
>  	if (!status) {
>  		mcast->backoff = 1;
>  		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
> -			queue_delayed_work(ipoib_workqueue,
> -					   &priv->mcast_task, 0);
> +			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
> 
>  		/*
> -		 * Defer carrier on work to ipoib_workqueue to avoid a
> +		 * Defer carrier on work to priv->wq to avoid a
>  		 * deadlock on rtnl_lock here.
>  		 */
>  		if (mcast == priv->broadcast)
> -			queue_work(ipoib_workqueue, &priv->carrier_on_task);
> +			queue_work(priv->wq, &priv->carrier_on_task);
>  	} else {
>  		if (mcast->logcount++ < 20) {
>  			if (status == -ETIMEDOUT || status == -EAGAIN) {
> @@ -465,7 +464,7 @@ out:
>  	if (status == -ENETRESET)
>  		status = 0;
>  	if (status && test_bit(IPOIB_MCAST_RUN, &priv->flags))
> -		queue_delayed_work(ipoib_workqueue, &priv->mcast_task,
> +		queue_delayed_work(priv->wq, &priv->mcast_task,
>  				   mcast->backoff * HZ);
>  	spin_unlock_irq(&priv->lock);
>  	mutex_unlock(&mcast_mutex);
> @@ -535,8 +534,7 @@ static void ipoib_mcast_join(struct net_device *dev, struct
> ipoib_mcast *mcast,
>  			mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
> 
>  		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
> -			queue_delayed_work(ipoib_workqueue,
> -					   &priv->mcast_task,
> +			queue_delayed_work(priv->wq, &priv->mcast_task,
>  					   mcast->backoff * HZ);
>  	}
>  	mutex_unlock(&mcast_mutex);
> @@ -576,8 +574,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
>  			ipoib_warn(priv, "failed to allocate broadcast group\n");
>  			mutex_lock(&mcast_mutex);
>  			if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
> -				queue_delayed_work(ipoib_workqueue,
> -						   &priv->mcast_task, HZ);
> +				queue_delayed_work(priv->wq, &priv->mcast_task,
> +						   HZ);
>  			mutex_unlock(&mcast_mutex);
>  			return;
>  		}
> @@ -644,7 +642,7 @@ int ipoib_mcast_start_thread(struct net_device *dev)
> 
>  	mutex_lock(&mcast_mutex);
>  	if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> -		queue_delayed_work(ipoib_workqueue, &priv->mcast_task, 0);
> +		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>  	mutex_unlock(&mcast_mutex);
> 
>  	return 0;
> @@ -662,7 +660,7 @@ int ipoib_mcast_stop_thread(struct net_device *dev, int flush)
>  	mutex_unlock(&mcast_mutex);
> 
>  	if (flush)
> -		flush_workqueue(ipoib_workqueue);
> +		flush_workqueue(priv->wq);
> 
>  	return 0;
>  }
> @@ -729,7 +727,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct
> sk_buff *skb)
>  		__ipoib_mcast_add(dev, mcast);
>  		list_add_tail(&mcast->list, &priv->multicast_list);
>  		if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> -			queue_delayed_work(ipoib_workqueue, &priv->mcast_task, 0);
> +			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>  	}
> 
>  	if (!mcast->ah) {
> @@ -944,7 +942,7 @@ void ipoib_mcast_restart_task(struct work_struct *work)
>  	 * completes.  So do like the carrier on task and attempt to
>  	 * take the rtnl lock, but if we can't before the ADMIN_UP flag
>  	 * goes away, then just return and know that the remove list will
> -	 * get flushed later by mcast_dev_flush.
> +	 * get flushed later by mcast_stop_thread.
>  	 */
>  	while (!rtnl_trylock()) {
>  		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> index c56d5d44c53..b72a753eb41 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> @@ -145,10 +145,20 @@ int ipoib_transport_dev_init(struct net_device *dev, struct
> ib_device *ca)
>  	int ret, size;
>  	int i;
> 
> +	/*
> +	 * the various IPoIB tasks assume they will never race against
> +	 * themselves, so always use a single thread workqueue
> +	 */
> +	priv->wq = create_singlethread_workqueue("ipoib_wq");
> +	if (!priv->wq) {
> +		printk(KERN_WARNING "ipoib: failed to allocate device WQ\n");
> +		return -ENODEV;
> +	}
> +
>  	priv->pd = ib_alloc_pd(priv->ca);
>  	if (IS_ERR(priv->pd)) {
>  		printk(KERN_WARNING "%s: failed to allocate PD\n", ca->name);
> -		return -ENODEV;
> +		goto out_free_wq;
>  	}
> 
>  	priv->mr = ib_get_dma_mr(priv->pd, IB_ACCESS_LOCAL_WRITE);
> @@ -242,6 +252,10 @@ out_free_mr:
> 
>  out_free_pd:
>  	ib_dealloc_pd(priv->pd);
> +
> +out_free_wq:
> +	destroy_workqueue(priv->wq);
> +	priv->wq = NULL;
>  	return -ENODEV;
>  }
> 
> @@ -270,6 +284,12 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
> 
>  	if (ib_dealloc_pd(priv->pd))
>  		ipoib_warn(priv, "ib_dealloc_pd failed\n");
> +
> +	if (priv->wq) {
> +		flush_workqueue(priv->wq);
> +		destroy_workqueue(priv->wq);
> +		priv->wq = NULL;
> +	}
>  }
> 
>  void ipoib_event(struct ib_event_handler *handler,
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
