From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 05/10] IPoIB: change init sequence ordering
Date: Fri, 12 Dec 2014 14:04:36 +0000
Message-ID: <F3529576D8E232409F431C309E2939930918C8E1@CRSMSX102.amr.corp.intel.com>
References: <cover.1418229671.git.dledford@redhat.com>
 <540b071b56bdc3b72d59e80707164da07243dc80.1418229671.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540b071b56bdc3b72d59e80707164da07243dc80.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> Subject: [PATCH 05/10] IPoIB: change init sequence ordering
> 
> In preparation for using per device work queues, we need to move the
> start of the neighbor thread task to after ipoib_ib_dev_init and move
> the destruction of the neighbor task to before ipoib_ib_dev_cleanup.
> Otherwise we will end up freeing our workqueue with work possibly still
> on it.
> 
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 58b5aa3b6f2..2cf81ef5141 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1262,15 +1262,13 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device
> *ca, int port)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> 
> -	if (ipoib_neigh_hash_init(priv) < 0)
> -		goto out;
>  	/* Allocate RX/TX "rings" to hold queued skbs */
>  	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
>  				GFP_KERNEL);
>  	if (!priv->rx_ring) {
>  		printk(KERN_WARNING "%s: failed to allocate RX ring (%d entries)\n",
>  		       ca->name, ipoib_recvq_size);
> -		goto out_neigh_hash_cleanup;
> +		goto out;
>  	}
> 
>  	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
> @@ -1285,16 +1283,24 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device
> *ca, int port)
>  	if (ipoib_ib_dev_init(dev, ca, port))
>  		goto out_tx_ring_cleanup;
> 
> +	/*
> +	 * Must be after ipoib_ib_dev_init so we can allocate a per
> +	 * device wq there and use it here
> +	 */
> +	if (ipoib_neigh_hash_init(priv) < 0)
> +		goto out_dev_uninit;
> +
>  	return 0;
> 
> +out_dev_uninit:
> +	ipoib_ib_dev_cleanup();
> +
>  out_tx_ring_cleanup:
>  	vfree(priv->tx_ring);
> 
>  out_rx_ring_cleanup:
>  	kfree(priv->rx_ring);
> 
> -out_neigh_hash_cleanup:
> -	ipoib_neigh_hash_uninit(dev);
>  out:
>  	return -ENOMEM;
>  }
> @@ -1317,6 +1323,12 @@ void ipoib_dev_cleanup(struct net_device *dev)
>  	}
>  	unregister_netdevice_many(&head);
> 
> +	/*
> +	 * Must be before ipoib_ib_dev_cleanup or we delete an in use
> +	 * work queue
> +	 */
> +	ipoib_neigh_hash_uninit(dev);
> +
>  	ipoib_ib_dev_cleanup(dev);
> 
>  	kfree(priv->rx_ring);
> @@ -1324,8 +1336,6 @@ void ipoib_dev_cleanup(struct net_device *dev)
> 
>  	priv->rx_ring = NULL;
>  	priv->tx_ring = NULL;
> -
> -	ipoib_neigh_hash_uninit(dev);
>  }
> 
>  static const struct header_ops ipoib_header_ops = {
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
