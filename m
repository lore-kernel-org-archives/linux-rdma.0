From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next] IB/IPoIB: Allow setting the device address
Date: Tue, 10 May 2016 15:26:27 +0000
Message-ID: <VI1PR05MB1391263ABAC5F4892DBD69E9D2710@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1462340207-16174-1-git-send-email-leon@kernel.org>
 <20160504184105.GB20554@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504184105.GB20554-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Sorry about  the delay.

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, May 04, 2016 9:41 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mark Bloch
> <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Matan
> Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next] IB/IPoIB: Allow setting the device address
> 
> On Wed, May 04, 2016 at 08:36:47AM +0300, Leon Romanovsky wrote:
> > +static int ipoib_set_mac(struct net_device *dev, void *addr)
> > +{
> > +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> > +	struct sockaddr_storage *ss = addr;
> > +
> > +	set_base_guid(priv, (union ib_gid *)(ss->__data + 4), 0);
> 
> Hurm, this should also check that the QPN and reserved in the provided
> 20 byte LLADDR match the current state of the device's LLADDR since
> those cannot be changed.
> 
> It is should also be illegal to try and change the GID prefix, so it
> must also match the current value.

I didn't think we need those checks as we are taking only the GUID part, but I'll add them.
Better safe than sorry I guess :)

> Did these checks from eth_prepare_mac_addr_change get included?
> 
>          if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) &&
> netif_running(dev))
>                  return -EBUSY;
> 
Why do I need to include that?

> As well as basic sanity checks on the formation of GUID - can't be 0,
> and must be unicast.
I'll add the GUID != 0 check.
The unicast is covered under a previous check, making sure the first 12 bytes are the same.
If dev_addr[4] != 0xff  ->  not multicast, and we start with a none multicast lladdr.

> > +	if (test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
> > +		priv->local_gid.global.subnet_prefix =
> > +			cpu_to_be64(port_attr.subnet_prefix);
> > +		memcpy(dev->dev_addr + 4, priv->local_gid.raw,
> > +		       sizeof(union ib_gid));
> 
> Seems strange - why is the subnet prefix being treated differently in
> this one case?
Just wanted to make sure we are not trying to join a multicast group with the wrong value.
I'll move the copy to: ipoib_dev_addr_changed_valid, this way when a subnet prefix changes
It will be copied both to local_gid and dev_addr.

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
