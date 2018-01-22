From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] RDMA/cma: Check existence of netdevice
 during port validation
Date: Mon, 22 Jan 2018 13:48:14 -0700
Message-ID: <20180122204814.GU14358@mellanox.com>
References: <20180109135859.7676-1-leon@kernel.org>
 <20180109135859.7676-2-leon@kernel.org>
 <20180122184807.GN14358@mellanox.com>
 <VI1PR0502MB30080B452158077BBA9C9EE4D1EC0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30080B452158077BBA9C9EE4D1EC0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 22, 2018 at 01:39:19PM -0700, Parav Pandit wrote:

> > > -	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port))
> > > +	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port)) {
> > >  		ndev = dev_get_by_index(&init_net, bound_if_index);
> > 
> > Why are we using indexes as a long term handle to netdevs? Is there some
> > reason for this you know of?

> I am not sure why index was used instead of netdev pointer in
> beginning.  I do prefer pointer. Sometime back I tried to look at
> this code but dropped the idea due to convoluted code of
> rdma_translate_ip() and rdma_copy_addr().

I think we should change it.

I tried to convince myself these patches were right, and that net and
bound_if_index are actually coherent and it was far too hard in
general.

The best I could do was to convince myself that the listen/accept path
was probably OK..

This whole thing seems so baroque these days, and now that ifindexes
can be aliased across net namespaces, and even changed during a single
netdevice lifetime, it seems dangerous..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
