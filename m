From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Add inline function to validate port
Date: Thu, 26 Jan 2017 10:15:35 +0200
Message-ID: <20170126081534.GC3939@yuval-lap.uk.oracle.com>
References: <1485362497-18723-1-git-send-email-yuval.shaia@oracle.com>
 <20170125165022.GQ6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170125165022.GQ6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 25, 2017 at 06:50:22PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 25, 2017 at 06:41:37PM +0200, Yuval Shaia wrote:
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cache.c  | 18 ++++++++----------
> >  drivers/infiniband/core/cma.c    |  6 ++----
> >  drivers/infiniband/core/device.c |  4 ++--
> >  drivers/infiniband/core/verbs.c  |  3 +--
> >  include/rdma/ib_verbs.h          |  7 +++++++
> >  5 files changed, 20 insertions(+), 18 deletions(-)
> 
> Nice change, however all places are pretended with "!".
> Can we change the name of function to something like
> "rdma_is_port_invalid"?

As a matter of fact this thought cross my mind as usually callers cares more
about 'invalid port' and not 'valid port' because it is used as exit criteria
from a function. But as Bart mentioned in other reply, positive looks
better that negative.

> 
> >
> > diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
> > index ae04826..0718b21 100644
> > --- a/drivers/infiniband/core/cache.c
> > +++ b/drivers/infiniband/core/cache.c
> > @@ -510,8 +510,7 @@ int ib_find_cached_gid_by_port(struct ib_device *ib_dev,
> >  	struct ib_gid_attr val = {.ndev = ndev, .gid_type = gid_type};
> >  	unsigned long flags;
> >
> > -	if (port < rdma_start_port(ib_dev) ||
> > -	    port > rdma_end_port(ib_dev))
> > +	if (!rdma_is_port_valid(ib_dev, port))
> >  		return -ENOENT;
> >
> >  	table = ports_table[port - rdma_start_port(ib_dev)];
> > @@ -571,8 +570,7 @@ static int ib_cache_gid_find_by_filter(struct ib_device *ib_dev,
> >  	if (!ports_table)
> >  		return -EOPNOTSUPP;
> >
> > -	if (port < rdma_start_port(ib_dev) ||
> > -	    port > rdma_end_port(ib_dev) ||
> > +	if (!rdma_is_port_valid(ib_dev, port) ||
> >  	    !rdma_protocol_roce(ib_dev, port))
> >  		return -EPROTONOSUPPORT;
> >
> > @@ -863,7 +861,7 @@ int ib_get_cached_gid(struct ib_device *device,
> >  	struct ib_gid_table **ports_table = device->cache.gid_cache;
> >  	struct ib_gid_table *table = ports_table[port_num - rdma_start_port(device)];
> >
> > -	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port_num))
> >  		return -EINVAL;
> >
> >  	read_lock_irqsave(&table->rwlock, flags);
> > @@ -912,7 +910,7 @@ int ib_get_cached_pkey(struct ib_device *device,
> >  	unsigned long flags;
> >  	int ret = 0;
> >
> > -	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port_num))
> >  		return -EINVAL;
> >
> >  	read_lock_irqsave(&device->cache.lock, flags);
> > @@ -941,7 +939,7 @@ int ib_find_cached_pkey(struct ib_device *device,
> >  	int ret = -ENOENT;
> >  	int partial_ix = -1;
> >
> > -	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port_num))
> >  		return -EINVAL;
> >
> >  	read_lock_irqsave(&device->cache.lock, flags);
> > @@ -981,7 +979,7 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
> >  	int i;
> >  	int ret = -ENOENT;
> >
> > -	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port_num))
> >  		return -EINVAL;
> >
> >  	read_lock_irqsave(&device->cache.lock, flags);
> > @@ -1010,7 +1008,7 @@ int ib_get_cached_lmc(struct ib_device *device,
> >  	unsigned long flags;
> >  	int ret = 0;
> >
> > -	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port_num))
> >  		return -EINVAL;
> >
> >  	read_lock_irqsave(&device->cache.lock, flags);
> > @@ -1037,7 +1035,7 @@ static void ib_cache_update(struct ib_device *device,
> >  	bool			   use_roce_gid_table =
> >  					rdma_cap_roce_gid_table(device, port);
> >
> > -	if (port < rdma_start_port(device) || port > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port))
> >  		return;
> >
> >  	table = ports_table[port - rdma_start_port(device)];
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index e7dcfac..69f37b1 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -269,8 +269,7 @@ struct cma_device *cma_enum_devices_by_ibdev(cma_device_filter	filter,
> >  int cma_get_default_gid_type(struct cma_device *cma_dev,
> >  			     unsigned int port)
> >  {
> > -	if (port < rdma_start_port(cma_dev->device) ||
> > -	    port > rdma_end_port(cma_dev->device))
> > +	if (!rdma_is_port_valid(cma_dev->device, port))
> >  		return -EINVAL;
> >
> >  	return cma_dev->default_gid_type[port - rdma_start_port(cma_dev->device)];
> > @@ -282,8 +281,7 @@ int cma_set_default_gid_type(struct cma_device *cma_dev,
> >  {
> >  	unsigned long supported_gids;
> >
> > -	if (port < rdma_start_port(cma_dev->device) ||
> > -	    port > rdma_end_port(cma_dev->device))
> > +	if (!rdma_is_port_valid(cma_dev->device, port))
> >  		return -EINVAL;
> >
> >  	supported_gids = roce_gid_type_mask_support(cma_dev->device, port);
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index 571974c..f2e4865 100644
> > --- a/drivers/infiniband/core/device.c
> > +++ b/drivers/infiniband/core/device.c
> > @@ -659,7 +659,7 @@ int ib_query_port(struct ib_device *device,
> >  	union ib_gid gid;
> >  	int err;
> >
> > -	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port_num))
> >  		return -EINVAL;
> >
> >  	memset(port_attr, 0, sizeof(*port_attr));
> > @@ -825,7 +825,7 @@ int ib_modify_port(struct ib_device *device,
> >  	if (!device->modify_port)
> >  		return -ENOSYS;
> >
> > -	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, port_num))
> >  		return -EINVAL;
> >
> >  	return device->modify_port(device, port_num, port_modify_mask,
> > diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> > index 71580cc..9b77fbc 100644
> > --- a/drivers/infiniband/core/verbs.c
> > +++ b/drivers/infiniband/core/verbs.c
> > @@ -1205,8 +1205,7 @@ int ib_resolve_eth_dmac(struct ib_device *device,
> >  {
> >  	int           ret = 0;
> >
> > -	if (ah_attr->port_num < rdma_start_port(device) ||
> > -	    ah_attr->port_num > rdma_end_port(device))
> > +	if (!rdma_is_port_valid(device, ah_attr->port_num))
> >  		return -EINVAL;
> >
> >  	if (!rdma_cap_eth_ah(device, ah_attr->port_num))
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 958a24d..81c68e9 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -2275,6 +2275,13 @@ static inline u8 rdma_end_port(const struct ib_device *device)
> >  	return rdma_cap_ib_switch(device) ? 0 : device->phys_port_cnt;
> >  }
> >
> > +static inline int rdma_is_port_valid(const struct ib_device *device,
> > +				     unsigned int port)
> > +{
> > +	return (port >= rdma_start_port(device) &&
> > +		port <= rdma_end_port(device));
> > +}
> > +
> >  static inline bool rdma_protocol_ib(const struct ib_device *device, u8 port_num)
> >  {
> >  	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IB;
> > --
> > 1.8.3.1
> >


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
