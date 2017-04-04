From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/IPoIB: Support acceleration options
 callbacks
Date: Tue, 4 Apr 2017 13:46:15 -0600
Message-ID: <20170404194615.GA14681@obsidianresearch.com>
References: <20170404191732.31895-1-leon@kernel.org>
 <20170404191732.31895-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404191732.31895-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 04, 2017 at 10:17:32PM +0300, Leon Romanovsky wrote:

> +static struct net_device *ipoib_create_netdev_default(struct ib_device *hca,
> +						      const char *name,
> +						      unsigned char name_assign_type,
> +						      void (*setup)(struct net_device *))
>  {
>  	struct net_device *dev;
> +	struct rdma_netdev *rn;
>  
> -	dev = alloc_netdev((int)sizeof(struct ipoib_dev_priv), name,
> -			   NET_NAME_UNKNOWN, ipoib_setup);
> +	dev = alloc_netdev((int)sizeof(struct rdma_netdev),
> +			   name,
> +			   name_assign_type, setup);
>  	if (!dev)
>  		return NULL;
>  
> -	return netdev_priv(dev);
> +	rn = netdev_priv(dev);
> +
> +	rn->send = ipoib_send;
> +	rn->attach_mcast = ipoib_mcast_attach;
> +	rn->detach_mcast = ipoib_mcast_detach;

This should really set rn->hca as well, don't forget the kref

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
