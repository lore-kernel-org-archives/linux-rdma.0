From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/3] RDMA/cma: Introduce API to read GIDs for
 multiple transports
Date: Mon, 15 Jan 2018 15:22:15 -0700
Message-ID: <20180115222215.GA18795@ziepe.ca>
References: <20180109111058.29534-1-leon@kernel.org>
 <20180109111058.29534-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109111058.29534-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 01:10:57PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch introduces an API that allows legacy applications to query
> GIDs for a rdma_cm_id which is used during connection establishment.
> 
> GIDs are stored and created differently for IB, RoCE and iWARP transports.
> Therefore rdma_read_gids() returns GID for all the transports hiding
> such internal details to caller. It is usable for client side and server
> side connections.
> 
> The rdma_read_gids() should not be used by any new ULPs.

This is weird statement. Why can't we change the few callers to do
whatever is correct now?

> +void rdma_read_gids(struct rdma_cm_id *cm_id, union ib_gid *sgid,
> +		    union ib_gid *dgid)
> +{
> +	struct rdma_addr *addr = &cm_id->route.addr;
> +
> +	if (!cm_id->device)
> +		return;

Nope. I looked at only one caller and saw this return leaks uninited
kernel stack memory to userspace. Probably best to zero the sgid/dgid
in the error case??

> diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
> index fa809a7b48e7..edb1cdf2a892 100644
> +++ b/include/rdma/ib_addr.h
> @@ -165,6 +165,9 @@ static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
>  
>  static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
>  {
> +	if (!gid)
> +		return 0;
> +
>  	switch (addr->sa_family) {
>  	case AF_INET:
>  		ipv6_addr_set_v4mapped(((struct sockaddr_in *)
> @@ -205,6 +208,9 @@ static inline void rdma_gid2ip(struct sockaddr *out, const union ib_gid *gid)
>  static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr,
>  				      union ib_gid *gid)
>  {
> +	if (!gid)
> +		return;

I think it would be clearer to put this test in the rdma_read_gids.
It makes no sense to have a function with one output where the output
is optional. Particularly when it is inlined..

And the prior patch makes a bit more sense after looking here, but the
series seems in the wrong order -> the patch to break
rdma_addr_get_sgid should go after the only rocee code path in ucma is
switched to use rdma_read_gids which hopefully does something similar
to what it did before?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
