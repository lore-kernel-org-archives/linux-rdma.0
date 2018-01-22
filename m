From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/6] RDMA/cma: Protect ifindex access during
 IPv6 route lookup
Date: Mon, 22 Jan 2018 11:38:20 -0700
Message-ID: <20180122183820.GM14358@mellanox.com>
References: <20180109135859.7676-1-leon@kernel.org>
 <20180109135859.7676-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109135859.7676-6-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 03:58:58PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Netdev ifindex can change while performing IPv6 rt6_lookup().
> Therefore access ifindex under rcu lock.
> This ensures that ifindex won't change while lookup is in progress.
> 
> Fixes: f887f2ac87c2 ("IB/cma: Validate routing of incoming requests")
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  drivers/infiniband/core/cma.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 90dead30de4c..690ed4238d72 100644
> +++ b/drivers/infiniband/core/cma.c
> @@ -1333,11 +1333,15 @@ static bool validate_ipv6_net_dev(struct net_device *net_dev,
>  #if IS_ENABLED(CONFIG_IPV6)
>  	const int strict = ipv6_addr_type(&dst_addr->sin6_addr) &
>  			   IPV6_ADDR_LINKLOCAL;
> -	struct rt6_info *rt = rt6_lookup(dev_net(net_dev), &dst_addr->sin6_addr,
> -					 &src_addr->sin6_addr, net_dev->ifindex,
> -					 strict);
> +	struct rt6_info *rt;
>  	bool ret;
>  
> +	rcu_read_lock();
> +	rt = rt6_lookup(dev_net(net_dev), &dst_addr->sin6_addr,
> +			&src_addr->sin6_addr, net_dev->ifindex,
> +			strict);
> +	rcu_read_unlock();

This doesn't make sense to me.

rcu is not supposed to be used in cases where two variables can change
concurrently.

For instance if the ifindex is changed due to dev_change_net_namespace()
then you have this:

	dev_net_set(dev, net);
	if (__dev_get_by_index(net, dev->ifindex))
		dev->ifindex = dev_new_index(net);

Racing with this:

	rt = rt6_lookup(dev_net(net_dev), &dst_addr->sin6_addr,
			&src_addr->sin6_addr, net_dev->ifindex,
			strict);

And we will get a racy incoherent result for dev_net(net_dev) and
net_dev->ifindex.

Same comment for the next patch too.

It kind of looks to me like the locking scheme in the netdev side
shuts down the netdev while moving it. So the RCU protected test
should be if the netdev is DOWN ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
