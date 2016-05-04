From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/IPoIB: Allow setting the device address
Date: Wed, 4 May 2016 12:41:05 -0600
Message-ID: <20160504184105.GB20554@obsidianresearch.com>
References: <1462340207-16174-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462340207-16174-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 08:36:47AM +0300, Leon Romanovsky wrote:
> +static int ipoib_set_mac(struct net_device *dev, void *addr)
> +{
> +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> +	struct sockaddr_storage *ss = addr;
> +
> +	set_base_guid(priv, (union ib_gid *)(ss->__data + 4), 0);

Hurm, this should also check that the QPN and reserved in the provided
20 byte LLADDR match the current state of the device's LLADDR since
those cannot be changed.

It is should also be illegal to try and change the GID prefix, so it
must also match the current value.

Did these checks from eth_prepare_mac_addr_change get included?

         if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
                 return -EBUSY;

As well as basic sanity checks on the formation of GUID - can't be 0,
and must be unicast.

> +	if (test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
> +		priv->local_gid.global.subnet_prefix =
> +			cpu_to_be64(port_attr.subnet_prefix);
> +		memcpy(dev->dev_addr + 4, priv->local_gid.raw,
> +		       sizeof(union ib_gid));

Seems strange - why is the subnet prefix being treated differently in
this one case?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
