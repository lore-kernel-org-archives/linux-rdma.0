From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/6] RDMA/cma: Protect ifindex access during
 IPv6 route lookup
Date: Tue, 23 Jan 2018 08:07:48 -0700
Message-ID: <20180123150748.GA30619@mellanox.com>
References: <20180109135859.7676-1-leon@kernel.org>
 <20180109135859.7676-6-leon@kernel.org>
 <20180122183820.GM14358@mellanox.com>
 <20180123085014.GO1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180123085014.GO1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 10:50:14AM +0200, Leon Romanovsky wrote:

> > For instance if the ifindex is changed due to dev_change_net_namespace()
> > then you have this:
> >
> > 	dev_net_set(dev, net);
> > 	if (__dev_get_by_index(net, dev->ifindex))
> > 		dev->ifindex = dev_new_index(net);
> >
> > Racing with this:
> >
> > 	rt = rt6_lookup(dev_net(net_dev), &dst_addr->sin6_addr,
> > 			&src_addr->sin6_addr, net_dev->ifindex,
> > 			strict);
> >
> > And we will get a racy incoherent result for dev_net(net_dev) and
> > net_dev->ifindex.
> 
> I think that rcu_derefence over net_dev will solve the race.

Nope, net_dev is a stack pointer, it is not RCU protected.

> > It kind of looks to me like the locking scheme in the netdev side
> > shuts down the netdev while moving it. So the RCU protected test
> > should be if the netdev is DOWN ?
> 
> It is not the case for ipv6 tunnel interface, they use RCU protection
> for live netdevs too.

Pointer? Doesn't mean it is right :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
