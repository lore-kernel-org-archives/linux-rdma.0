From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 1/1] RDMA/core: create struct ib_port_cache
Date: Tue, 17 Jan 2017 13:24:27 +0200
Message-ID: <20170117112426.GL32481@mtr-leonro.local>
References: <CAMGffEn-fOOe7s2rniqwcaocoV+jxkeJDHZ6WYJkkXi+CBQbEA@mail.gmail.com>
 <b1fdf011-dc25-ad63-b223-0700f6e90bc6@profitbricks.com>
 <20170113150103.GP20392@mtr-leonro.local>
 <2617abae-686e-c8c6-799a-8742156fcd08@profitbricks.com>
 <20170115085014.GB20392@mtr-leonro.local>
 <f08926e7-54c1-fa48-2105-308f82ddcc23@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+9faIjRurCDpBc7U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f08926e7-54c1-fa48-2105-308f82ddcc23-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+9faIjRurCDpBc7U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 17, 2017 at 10:11:12AM +0100, Jack Wang wrote:
>
>
> As Jason suggested, we have 4 elements for per port arrays,
> it's better to have a separate structure to represent them.
>
> It simplifies code a bit, ~ 30 lines of code less :)

The commit message should be descriptive.
You really NEED to read SubmittingPatches before sending patches.
http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L106

106 2) Describe your changes
107 ------------------------
108
109 Describe your problem.  Whether your patch is a one-line bug fix or
110 5000 lines of a new feature, there must be an underlying problem that
111 motivated you to do this work.  Convince the reviewer that there is a
112 problem worth fixing and that it makes sense for them to read past the
113 first paragraph.

And if I read email headers correctly, you still didn't use "git send-email" to send the patch.

Thanks

>
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
> v3..v2:
> - rebase to Doug's for-4.11 branch
> - change subject with RDMA prefix instead of IB prefix
>
>  drivers/infiniband/core/cache.c | 134 +++++++++++++++-------------------------
>  include/rdma/ib_verbs.h         |  12 ++--
>  2 files changed, 59 insertions(+), 87 deletions(-)
>
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
> index f91886b..2e52021 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -314,14 +314,13 @@ static void make_default_gid(struct  net_device *dev, union ib_gid *gid)
>  int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
>  		     union ib_gid *gid, struct ib_gid_attr *attr)
>  {
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	struct ib_gid_table *table;
>  	int ix;
>  	int ret = 0;
>  	struct net_device *idev;
>  	int empty;
>
> -	table = ports_table[port - rdma_start_port(ib_dev)];
> +	table = ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;
>
>  	if (!memcmp(gid, &zgid, sizeof(*gid)))
>  		return -EINVAL;
> @@ -369,11 +368,10 @@ int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
>  int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
>  		     union ib_gid *gid, struct ib_gid_attr *attr)
>  {
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	struct ib_gid_table *table;
>  	int ix;
>
> -	table = ports_table[port - rdma_start_port(ib_dev)];
> +	table = ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;
>
>  	mutex_lock(&table->lock);
>  	write_lock_irq(&table->rwlock);
> @@ -399,12 +397,11 @@ int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
>  int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
>  				     struct net_device *ndev)
>  {
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	struct ib_gid_table *table;
>  	int ix;
>  	bool deleted = false;
>
> -	table  = ports_table[port - rdma_start_port(ib_dev)];
> +	table = ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;
>
>  	mutex_lock(&table->lock);
>  	write_lock_irq(&table->rwlock);
> @@ -428,10 +425,9 @@ int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
>  static int __ib_cache_gid_get(struct ib_device *ib_dev, u8 port, int index,
>  			      union ib_gid *gid, struct ib_gid_attr *attr)
>  {
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	struct ib_gid_table *table;
>
> -	table = ports_table[port - rdma_start_port(ib_dev)];
> +	table = ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;
>
>  	if (index < 0 || index >= table->sz)
>  		return -EINVAL;
> @@ -455,14 +451,13 @@ static int _ib_cache_gid_table_find(struct ib_device *ib_dev,
>  				    unsigned long mask,
>  				    u8 *port, u16 *index)
>  {
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	struct ib_gid_table *table;
>  	u8 p;
>  	int local_index;
>  	unsigned long flags;
>
>  	for (p = 0; p < ib_dev->phys_port_cnt; p++) {
> -		table = ports_table[p];
> +		table = ib_dev->cache.ports[p].gid;
>  		read_lock_irqsave(&table->rwlock, flags);
>  		local_index = find_gid(table, gid, val, false, mask, NULL);
>  		if (local_index >= 0) {
> @@ -503,7 +498,6 @@ int ib_find_cached_gid_by_port(struct ib_device *ib_dev,
>  			       u16 *index)
>  {
>  	int local_index;
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	struct ib_gid_table *table;
>  	unsigned long mask = GID_ATTR_FIND_MASK_GID |
>  			     GID_ATTR_FIND_MASK_GID_TYPE;
> @@ -514,7 +508,7 @@ int ib_find_cached_gid_by_port(struct ib_device *ib_dev,
>  	    port > rdma_end_port(ib_dev))
>  		return -ENOENT;
>
> -	table = ports_table[port - rdma_start_port(ib_dev)];
> +	table = ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;
>
>  	if (ndev)
>  		mask |= GID_ATTR_FIND_MASK_NETDEV;
> @@ -562,21 +556,18 @@ static int ib_cache_gid_find_by_filter(struct ib_device *ib_dev,
>  				       void *context,
>  				       u16 *index)
>  {
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	struct ib_gid_table *table;
>  	unsigned int i;
>  	unsigned long flags;
>  	bool found = false;
>
> -	if (!ports_table)
> -		return -EOPNOTSUPP;
>
>  	if (port < rdma_start_port(ib_dev) ||
>  	    port > rdma_end_port(ib_dev) ||
>  	    !rdma_protocol_roce(ib_dev, port))
>  		return -EPROTONOSUPPORT;
>
> -	table = ports_table[port - rdma_start_port(ib_dev)];
> +	table = ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;
>
>  	read_lock_irqsave(&table->rwlock, flags);
>  	for (i = 0; i < table->sz; i++) {
> @@ -668,14 +659,13 @@ void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
>  				  unsigned long gid_type_mask,
>  				  enum ib_cache_gid_default_mode mode)
>  {
> -	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  	union ib_gid gid;
>  	struct ib_gid_attr gid_attr;
>  	struct ib_gid_attr zattr_type = zattr;
>  	struct ib_gid_table *table;
>  	unsigned int gid_type;
>
> -	table  = ports_table[port - rdma_start_port(ib_dev)];
> +	table = ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;
>
>  	make_default_gid(ndev, &gid);
>  	memset(&gid_attr, 0, sizeof(gid_attr));
> @@ -766,71 +756,64 @@ static int gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
>  static int _gid_table_setup_one(struct ib_device *ib_dev)
>  {
>  	u8 port;
> -	struct ib_gid_table **table;
> +	struct ib_gid_table *table;
>  	int err = 0;
>
> -	table = kcalloc(ib_dev->phys_port_cnt, sizeof(*table), GFP_KERNEL);
> -	if (!table)
> -		return -ENOMEM;
> -
>  	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
>  		u8 rdma_port = port + rdma_start_port(ib_dev);
>
> -		table[port] =
> +		table =
>  			alloc_gid_table(
>  				ib_dev->port_immutable[rdma_port].gid_tbl_len);
> -		if (!table[port]) {
> +		if (!table) {
>  			err = -ENOMEM;
>  			goto rollback_table_setup;
>  		}
>
>  		err = gid_table_reserve_default(ib_dev,
>  						port + rdma_start_port(ib_dev),
> -						table[port]);
> +						table);
>  		if (err)
>  			goto rollback_table_setup;
> +		ib_dev->cache.ports[port].gid = table;
>  	}
>
> -	ib_dev->cache.gid_cache = table;
>  	return 0;
>
>  rollback_table_setup:
>  	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
> +		table = ib_dev->cache.ports[port].gid;
> +
>  		cleanup_gid_table_port(ib_dev, port + rdma_start_port(ib_dev),
> -				       table[port]);
> -		release_gid_table(table[port]);
> +				       table);
> +		release_gid_table(table);
>  	}
>
> -	kfree(table);
>  	return err;
>  }
>
>  static void gid_table_release_one(struct ib_device *ib_dev)
>  {
> -	struct ib_gid_table **table = ib_dev->cache.gid_cache;
> +	struct ib_gid_table *table;
>  	u8 port;
>
> -	if (!table)
> -		return;
> -
> -	for (port = 0; port < ib_dev->phys_port_cnt; port++)
> -		release_gid_table(table[port]);
> -
> -	kfree(table);
> -	ib_dev->cache.gid_cache = NULL;
> +	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
> +		table = ib_dev->cache.ports[port].gid;
> +		release_gid_table(table);
> +		ib_dev->cache.ports[port].gid = NULL;
> +	}
>  }
>
>  static void gid_table_cleanup_one(struct ib_device *ib_dev)
>  {
> -	struct ib_gid_table **table = ib_dev->cache.gid_cache;
> +	struct ib_gid_table *table;
>  	u8 port;
>
> -	if (!table)
> -		return;
> -
> -	for (port = 0; port < ib_dev->phys_port_cnt; port++)
> +	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
> +		table = ib_dev->cache.ports[port].gid;
>  		cleanup_gid_table_port(ib_dev, port + rdma_start_port(ib_dev),
> -				       table[port]);
> +				       table);
> +	}
>  }
>
>  static int gid_table_setup_one(struct ib_device *ib_dev)
> @@ -860,12 +843,12 @@ int ib_get_cached_gid(struct ib_device *device,
>  {
>  	int res;
>  	unsigned long flags;
> -	struct ib_gid_table **ports_table = device->cache.gid_cache;
> -	struct ib_gid_table *table = ports_table[port_num - rdma_start_port(device)];
> +	struct ib_gid_table *table;
>
>  	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
>  		return -EINVAL;
>
> +	table = device->cache.ports[port_num - rdma_start_port(device)].gid;
>  	read_lock_irqsave(&table->rwlock, flags);
>  	res = __ib_cache_gid_get(device, port_num, index, gid, gid_attr);
>  	read_unlock_irqrestore(&table->rwlock, flags);
> @@ -917,7 +900,7 @@ int ib_get_cached_pkey(struct ib_device *device,
>
>  	read_lock_irqsave(&device->cache.lock, flags);
>
> -	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
> +	cache = device->cache.ports[port_num - rdma_start_port(device)].pkey;
>
>  	if (index < 0 || index >= cache->table_len)
>  		ret = -EINVAL;
> @@ -946,7 +929,7 @@ int ib_find_cached_pkey(struct ib_device *device,
>
>  	read_lock_irqsave(&device->cache.lock, flags);
>
> -	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
> +	cache = device->cache.ports[port_num - rdma_start_port(device)].pkey;
>
>  	*index = -1;
>
> @@ -986,7 +969,7 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
>
>  	read_lock_irqsave(&device->cache.lock, flags);
>
> -	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
> +	cache = device->cache.ports[port_num - rdma_start_port(device)].pkey;
>
>  	*index = -1;
>
> @@ -1014,7 +997,7 @@ int ib_get_cached_lmc(struct ib_device *device,
>  		return -EINVAL;
>
>  	read_lock_irqsave(&device->cache.lock, flags);
> -	*lmc = device->cache.lmc_cache[port_num - rdma_start_port(device)];
> +	*lmc = device->cache.ports[port_num - rdma_start_port(device)].lmc;
>  	read_unlock_irqrestore(&device->cache.lock, flags);
>
>  	return ret;
> @@ -1032,7 +1015,8 @@ int ib_get_cached_port_state(struct ib_device   *device,
>  		return -EINVAL;
>
>  	read_lock_irqsave(&device->cache.lock, flags);
> -	*port_state = device->cache.port_state_cache[port_num - rdma_start_port(device)];
> +	*port_state = device->cache.ports[port_num
> +		- rdma_start_port(device)].port_state;
>  	read_unlock_irqrestore(&device->cache.lock, flags);
>
>  	return ret;
> @@ -1051,14 +1035,13 @@ static void ib_cache_update(struct ib_device *device,
>  	int                        i;
>  	int                        ret;
>  	struct ib_gid_table	  *table;
> -	struct ib_gid_table	 **ports_table = device->cache.gid_cache;
>  	bool			   use_roce_gid_table =
>  					rdma_cap_roce_gid_table(device, port);
>
>  	if (port < rdma_start_port(device) || port > rdma_end_port(device))
>  		return;
>
> -	table = ports_table[port - rdma_start_port(device)];
> +	table = device->cache.ports[port - rdma_start_port(device)].gid;
>
>  	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
>  	if (!tprops)
> @@ -1110,9 +1093,10 @@ static void ib_cache_update(struct ib_device *device,
>
>  	write_lock_irq(&device->cache.lock);
>
> -	old_pkey_cache = device->cache.pkey_cache[port - rdma_start_port(device)];
> +	old_pkey_cache = device->cache.ports[port -
> +		rdma_start_port(device)].pkey;
>
> -	device->cache.pkey_cache[port - rdma_start_port(device)] = pkey_cache;
> +	device->cache.ports[port - rdma_start_port(device)].pkey = pkey_cache;
>  	if (!use_roce_gid_table) {
>  		write_lock(&table->rwlock);
>  		for (i = 0; i < gid_cache->table_len; i++) {
> @@ -1122,8 +1106,8 @@ static void ib_cache_update(struct ib_device *device,
>  		write_unlock(&table->rwlock);
>  	}
>
> -	device->cache.lmc_cache[port - rdma_start_port(device)] = tprops->lmc;
> -	device->cache.port_state_cache[port - rdma_start_port(device)] =
> +	device->cache.ports[port - rdma_start_port(device)].lmc = tprops->lmc;
> +	device->cache.ports[port - rdma_start_port(device)].port_state =
>  		tprops->state;
>
>  	write_unlock_irq(&device->cache.lock);
> @@ -1177,26 +1161,17 @@ int ib_cache_setup_one(struct ib_device *device)
>
>  	rwlock_init(&device->cache.lock);
>
> -	device->cache.pkey_cache =
> -		kzalloc(sizeof *device->cache.pkey_cache *
> +	device->cache.ports =
> +		kzalloc(sizeof(*device->cache.ports) *
>  			(rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KERNEL);
> -	device->cache.lmc_cache = kmalloc(sizeof *device->cache.lmc_cache *
> -					  (rdma_end_port(device) -
> -					   rdma_start_port(device) + 1),
> -					  GFP_KERNEL);
> -	device->cache.port_state_cache = kmalloc(sizeof *device->cache.port_state_cache *
> -					  (rdma_end_port(device) -
> -					   rdma_start_port(device) + 1),
> -					  GFP_KERNEL);
> -	if (!device->cache.pkey_cache || !device->cache.port_state_cache ||
> -	    !device->cache.lmc_cache) {
> +	if (!device->cache.ports) {
>  		err = -ENOMEM;
> -		goto free;
> +		goto out;
>  	}
>
>  	err = gid_table_setup_one(device);
>  	if (err)
> -		goto free;
> +		goto out;
>
>  	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
>  		ib_cache_update(device, p + rdma_start_port(device));
> @@ -1211,10 +1186,7 @@ int ib_cache_setup_one(struct ib_device *device)
>
>  err:
>  	gid_table_cleanup_one(device);
> -free:
> -	kfree(device->cache.pkey_cache);
> -	kfree(device->cache.lmc_cache);
> -	kfree(device->cache.port_state_cache);
> +out:
>  	return err;
>  }
>
> @@ -1228,15 +1200,11 @@ void ib_cache_release_one(struct ib_device *device)
>  	 * all the device's resources when the cache could no
>  	 * longer be accessed.
>  	 */
> -	if (device->cache.pkey_cache)
> -		for (p = 0;
> -		     p <= rdma_end_port(device) - rdma_start_port(device); ++p)
> -			kfree(device->cache.pkey_cache[p]);
> +	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
> +		kfree(device->cache.ports[p].pkey);
>
>  	gid_table_release_one(device);
> -	kfree(device->cache.pkey_cache);
> -	kfree(device->cache.lmc_cache);
> -	kfree(device->cache.port_state_cache);
> +	kfree(device->cache.ports);
>  }
>
>  void ib_cache_cleanup_one(struct ib_device *device)
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index fafa988..e55afec 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1775,13 +1775,17 @@ enum ib_mad_result {
>
>  #define IB_DEVICE_NAME_MAX 64
>
> +struct ib_port_cache {
> +	struct ib_pkey_cache  *pkey;
> +	struct ib_gid_table   *gid;
> +	u8                     lmc;
> +	enum ib_port_state     port_state;
> +};
> +
>  struct ib_cache {
>  	rwlock_t                lock;
>  	struct ib_event_handler event_handler;
> -	struct ib_pkey_cache  **pkey_cache;
> -	struct ib_gid_table   **gid_cache;
> -	u8                     *lmc_cache;
> -	enum ib_port_state     *port_state_cache;
> +	struct ib_port_cache   *ports;
>  };
>
>  struct ib_dma_mapping_ops {
> --
> 2.7.4

--+9faIjRurCDpBc7U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh9/uoACgkQ5GN7iDZy
WKd9nRAAg37t6OHeGd7g9/tDGBwn8zNMdVjyhzTZm8+9fd9e/Brr3+aYi68mW+OR
Xqa0T7pU41w3jhPLb8RFBBf9QbLBs9sx4IiFe/CXCIswplCNrS8TfCU9yqGIKHh7
C9D+QvbRm7iyxuKnbI+h95P5H5+onyDz0QIviO5Dswo/TZAJgzriIerTnqNBOiF2
4wLkztALkEBTk/lLxX9layyqw0Uowc5yaav6JfBX/yIxYbLvWQYBG5nKBUJosFm/
WwCUDIhZDbFerfy9c1Ip/V/YioiQj5W0zS6WnBOxG5eUsJnALp1Jw6pG1FHFsvQ3
1XUQ8/PQ770cWVZEH/tPS18NxyPLR+g/dvTf9Qvs7NUnM5BAZ8NDqnf39W/hH6N6
AlUkqW6gkNXXJLqcdKCa/4+D1rzQeiFafK7WKVPa31l3FnJx5LXSPuWVItcypMqb
sUYsoDcoede/vQ6qqqSSQo2E+3xEeF2LtLW0SKkBVTgrmC1fol4GLgRfpHj3n8/3
PjPPopmaEPLDZcl30eDD5fQyWrClSJ8ohkFYApRXDD7atuEUs8Td/aVGmhsaZD1e
eg2jjjCUYRj8fJqJoxLt3lEG8ypYg2WwNO8ANtA6wNfl/5ufG8e5DEd7J8segAza
K8F+9vYe60+X8kmLU8NPOnA01Tp7LxZWnMNP8RiVAacxCk2bKic=
=aK+P
-----END PGP SIGNATURE-----

--+9faIjRurCDpBc7U--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
