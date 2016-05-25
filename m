From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [rdma-next,V3] IB/IPoIB: Allow setting the device address
Date: Wed, 25 May 2016 13:15:02 +0000
Message-ID: <VI1PR05MB139136EF3C46570069764F35D2400@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1463578963-14956-1-git-send-email-markb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463578963-14956-1-git-send-email-markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Are you planning to take this one? Do you have issues I need to address?

I've fixed Jason's comments, but no further input
was given besides that.

Mark

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Mark Bloch
> Sent: Wednesday, May 18, 2016 4:43 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Subject: [rdma-next,V3] IB/IPoIB: Allow setting the device address
> 
> In IB networks, and specifically in IPoIB/rdmacm traffic, the device
> address of an IPoIB interface is used as a means to exchange information
> between nodes needed for communication.
> 
> Currently an IPoIB interface will always be created with a device
> address based on its node GUID without a way to change that.
> 
> This change adds the ability to set the device address of an IPoIB
> interface by value. We use the set mac address ndo to do that.
> 
> The flow should be broken down to two:
> 1) The GID value is already in the GID table,
>    in this case the interface will be able to set carrier up.
> 
> 2) The GID value is not yet in the GID table,
>    in this case the interface won't try to join the multicast group
>    and will wait (listen on GID_CHANGE event) until the GID is inserted.
> 
> In order to track those changes, we add a new flag:
> * IPOIB_FLAG_DEV_ADDR_SET.
> 
> When set, it means the dev_addr is a based on a value in the gid
> table. this bit will be cleared upon a dev_addr change triggered
> by the user and set after validation.
> 
> Per IB spec the port GUID can't change if the module is loaded.
> port GUID is the basis for GID at index 0 which is the basis for
> the default device address of a ipoib interface.
> 
> The issue is that there are devices that don't follow the spec,
> they change the port GUID while HCA is powered on, so in order
> not to break userspace applications. We need to check if the
> user wanted to control the device address and we assume that
> if he sets the device address back to be based on GID index 0,
> he no longer wishs to control it.
> 
> In order to track this, we add an additional flag:
> * IPOIB_FLAG_DEV_ADDR_CTRL
> 
> When setting the device address, there is no validation of the upper
> twelve bytes of the device address (flags, qpn, subnet prefix) as those
> bytes are not under the control of the user.
> 
> Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> Changes from V0:
>  * Add basic sanity/validation checks on the LLADDR.
>  * Update the subnet prefix upon GID_CHNAGE_EVENT.
> Changes from v1:
>  * Add a check to see if the inerface is running,
>    don't allow changing the device address if it is.
> Changes from V2:
>  * Fix handling of child devices.
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h           |   2 +
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 109
> ++++++++++++++++++++++++-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      |  67 +++++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  10 ++-
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   3 +
>  drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   2 +
>  6 files changed, 187 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
> b/drivers/infiniband/ulp/ipoib/ipoib.h
> index caec8e9..7830bde 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -92,6 +92,8 @@ enum {
>  	IPOIB_FLAG_UMCAST	  = 10,
>  	IPOIB_STOP_NEIGH_GC	  = 11,
>  	IPOIB_NEIGH_TBL_FLUSH	  = 12,
> +	IPOIB_FLAG_DEV_ADDR_SET	  = 13,
> +	IPOIB_FLAG_DEV_ADDR_CTRL  = 14,
> 
>  	IPOIB_MAX_BACKOFF_SECONDS = 16,
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index da5f28c..7e9a770 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -997,6 +997,106 @@ static inline int update_child_pkey(struct
> ipoib_dev_priv *priv)
>  	return 0;
>  }
> 
> +/*
> + * returns true if the device address of the ipoib interface has changed and
> the
> + * new address is a valid one (i.e in the gid table), return false otherwise.
> + */
> +static bool ipoib_dev_addr_changed_valid(struct ipoib_dev_priv *priv)
> +{
> +	union ib_gid search_gid;
> +	union ib_gid gid0;
> +	union ib_gid *netdev_gid;
> +	int err;
> +	u16 index;
> +	u8 port;
> +	bool ret = false;
> +
> +	netdev_gid = (union ib_gid *)(priv->dev->dev_addr + 4);
> +	if (ib_query_gid(priv->ca, priv->port, 0, &gid0, NULL))
> +		return false;
> +
> +	netif_addr_lock(priv->dev);
> +
> +	/* The subnet prefix may have changed, update it now so we won't
> have
> +	 * to do it later
> +	 */
> +	priv->local_gid.global.subnet_prefix = gid0.global.subnet_prefix;
> +	netdev_gid->global.subnet_prefix = gid0.global.subnet_prefix;
> +	search_gid.global.subnet_prefix = gid0.global.subnet_prefix;
> +
> +	search_gid.global.interface_id = priv->local_gid.global.interface_id;
> +
> +	netif_addr_unlock(priv->dev);
> +
> +	err = ib_find_gid(priv->ca, &search_gid, IB_GID_TYPE_IB,
> +			  priv->dev, &port, &index);
> +
> +	netif_addr_lock(priv->dev);
> +
> +	if (search_gid.global.interface_id !=
> +	    priv->local_gid.global.interface_id)
> +		/* There was a change while we were looking up the gid, bail
> +		 * here and let the next work sort this out
> +		 */
> +		goto out;
> +
> +	/* The next section of code needs some background:
> +	 * Per IB spec the port GUID can't change if the HCA is powered on.
> +	 * port GUID is the basis for GID at index 0 which is the basis for
> +	 * the default device address of a ipoib interface.
> +	 *
> +	 * so it seems the flow should be:
> +	 * if user_changed_dev_addr && gid in gid tbl
> +	 *	set bit dev_addr_set
> +	 *	return true
> +	 * else
> +	 *	return false
> +	 *
> +	 * The issue is that there are devices that don't follow the spec,
> +	 * they change the port GUID when the HCA is powered, so in order
> +	 * not to break userspace applications, We need to check if the
> +	 * user wanted to control the device address and we assume that
> +	 * if he sets the device address back to be based on GID index 0,
> +	 * he no longer wishs to control it.
> +	 *
> +	 * If the user doesn't control the the device address,
> +	 * IPOIB_FLAG_DEV_ADDR_SET is set and ib_find_gid failed it means
> +	 * the port GUID has changed and GID at index 0 has changed
> +	 * so we need to change priv->local_gid and priv->dev->dev_addr
> +	 * to reflect the new GID.
> +	 */
> +	if (!test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
> +		if (!err && port == priv->port) {
> +			set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
> +			if (index == 0)
> +				clear_bit(IPOIB_FLAG_DEV_ADDR_CTRL,
> +					  &priv->flags);
> +			else
> +				set_bit(IPOIB_FLAG_DEV_ADDR_CTRL,
> &priv->flags);
> +			ret = true;
> +		} else {
> +			ret = false;
> +		}
> +	} else {
> +		if (!err && port == priv->port) {
> +			ret = true;
> +		} else {
> +			if (!test_bit(IPOIB_FLAG_DEV_ADDR_CTRL, &priv-
> >flags)) {
> +				memcpy(&priv->local_gid, &gid0,
> +				       sizeof(priv->local_gid));
> +				memcpy(priv->dev->dev_addr + 4, &gid0,
> +				       sizeof(priv->local_gid));
> +				ret = true;
> +			}
> +		}
> +	}
> +
> +out:
> +	netif_addr_unlock(priv->dev);
> +
> +	return ret;
> +}
> +
>  static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>  				enum ipoib_flush_level level,
>  				int nesting)
> @@ -1018,6 +1118,9 @@ static void __ipoib_ib_dev_flush(struct
> ipoib_dev_priv *priv,
> 
>  	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags) &&
>  	    level != IPOIB_FLUSH_HEAVY) {
> +		/* Make sure the dev_addr is set even if not flushing */
> +		if (level == IPOIB_FLUSH_LIGHT)
> +			ipoib_dev_addr_changed_valid(priv);
>  		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not
> set.\n");
>  		return;
>  	}
> @@ -1029,7 +1132,8 @@ static void __ipoib_ib_dev_flush(struct
> ipoib_dev_priv *priv,
>  				update_parent_pkey(priv);
>  			else
>  				update_child_pkey(priv);
> -		}
> +		} else if (level == IPOIB_FLUSH_LIGHT)
> +			ipoib_dev_addr_changed_valid(priv);
>  		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_ADMIN_UP not
> set.\n");
>  		return;
>  	}
> @@ -1081,7 +1185,8 @@ static void __ipoib_ib_dev_flush(struct
> ipoib_dev_priv *priv,
>  	if (test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)) {
>  		if (level >= IPOIB_FLUSH_NORMAL)
>  			ipoib_ib_dev_up(dev);
> -		ipoib_mcast_restart_task(&priv->restart_task);
> +		if (ipoib_dev_addr_changed_valid(priv))
> +			ipoib_mcast_restart_task(&priv->restart_task);
>  	}
>  }
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 80807d6..e624c03 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -99,6 +99,7 @@ static struct net_device
> *ipoib_get_net_dev_by_params(
>  		struct ib_device *dev, u8 port, u16 pkey,
>  		const union ib_gid *gid, const struct sockaddr *addr,
>  		void *client_data);
> +static int ipoib_set_mac(struct net_device *dev, void *addr);
> 
>  static struct ib_client ipoib_client = {
>  	.name   = "ipoib",
> @@ -1649,6 +1650,7 @@ static const struct net_device_ops
> ipoib_netdev_ops_pf = {
>  	.ndo_get_vf_config	 = ipoib_get_vf_config,
>  	.ndo_get_vf_stats	 = ipoib_get_vf_stats,
>  	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
> +	.ndo_set_mac_address	 = ipoib_set_mac,
>  };
> 
>  static const struct net_device_ops ipoib_netdev_ops_vf = {
> @@ -1771,6 +1773,70 @@ int ipoib_add_umcast_attr(struct net_device
> *dev)
>  	return device_create_file(&dev->dev, &dev_attr_umcast);
>  }
> 
> +static void set_base_guid(struct ipoib_dev_priv *priv, union ib_gid *gid)
> +{
> +	struct ipoib_dev_priv *child_priv;
> +	struct net_device *netdev = priv->dev;
> +
> +	netif_addr_lock(netdev);
> +
> +	memcpy(&priv->local_gid.global.interface_id,
> +	       &gid->global.interface_id,
> +	       sizeof(gid->global.interface_id));
> +	memcpy(netdev->dev_addr + 4, &priv->local_gid, sizeof(priv-
> >local_gid));
> +	clear_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
> +
> +	netif_addr_unlock(netdev);
> +
> +	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
> +		down_read(&priv->vlan_rwsem);
> +		list_for_each_entry(child_priv, &priv->child_intfs, list)
> +			set_base_guid(child_priv, gid);
> +		up_read(&priv->vlan_rwsem);
> +	}
> +}
> +
> +static int ipoib_check_lladdr(struct net_device *dev,
> +			      struct sockaddr_storage *ss)
> +{
> +	union ib_gid *gid = (union ib_gid *)(ss->__data + 4);
> +	int ret = 0;
> +
> +	netif_addr_lock(dev);
> +
> +	/* Make sure the QPN, reserved and subnet prefix match the
> current
> +	 * lladdr, it also makes sure the lladdr is unicast.
> +	 */
> +	if (memcmp(dev->dev_addr, ss->__data,
> +		   4 + sizeof(gid->global.subnet_prefix)) ||
> +	    gid->global.interface_id == 0)
> +		ret = -EINVAL;
> +
> +	netif_addr_unlock(dev);
> +
> +	return ret;
> +}
> +
> +static int ipoib_set_mac(struct net_device *dev, void *addr)
> +{
> +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> +	struct sockaddr_storage *ss = addr;
> +	int ret;
> +
> +	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) &&
> netif_running(dev))
> +		return -EBUSY;
> +
> +	ret = ipoib_check_lladdr(dev, ss);
> +	if (ret)
> +		return ret;
> +
> +	set_base_guid(priv, (union ib_gid *)(ss->__data + 4));
> +
> +	queue_work(ipoib_workqueue, &priv->flush_light);
> +
> +	return 0;
> +}
> +
>  static ssize_t create_child(struct device *dev,
>  			    struct device_attribute *attr,
>  			    const char *buf, size_t count)
> @@ -1894,6 +1960,7 @@ static struct net_device *ipoib_add_port(const char
> *format,
>  		goto device_init_failed;
>  	} else
>  		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw,
> sizeof (union ib_gid));
> +	set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
> 
>  	result = ipoib_dev_init(priv->dev, hca, port);
>  	if (result < 0) {
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 2588931..c4b9339 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -570,11 +570,13 @@ void ipoib_mcast_join_task(struct work_struct
> *work)
>  		return;
>  	}
>  	priv->local_lid = port_attr.lid;
> +	netif_addr_lock(dev);
> 
> -	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid, NULL))
> -		ipoib_warn(priv, "ib_query_gid() failed\n");
> -	else
> -		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw,
> sizeof (union ib_gid));
> +	if (!test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
> +		netif_addr_unlock(dev);
> +		return;
> +	}
> +	netif_addr_unlock(dev);
> 
>  	spin_lock_irq(&priv->lock);
>  	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> index b809c37..1e7cbba 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> @@ -307,5 +307,8 @@ void ipoib_event(struct ib_event_handler *handler,
>  		queue_work(ipoib_workqueue, &priv->flush_normal);
>  	} else if (record->event == IB_EVENT_PKEY_CHANGE) {
>  		queue_work(ipoib_workqueue, &priv->flush_heavy);
> +	} else if (record->event == IB_EVENT_GID_CHANGE &&
> +		   !test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
> +		queue_work(ipoib_workqueue, &priv->flush_light);
>  	}
>  }
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> index fca1a88..64a3559 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> @@ -68,6 +68,8 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv,
> struct ipoib_dev_priv *priv,
>  	priv->pkey = pkey;
> 
>  	memcpy(priv->dev->dev_addr, ppriv->dev->dev_addr,
> INFINIBAND_ALEN);
> +	memcpy(&priv->local_gid, &ppriv->local_gid, sizeof(priv->local_gid));
> +	set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
>  	priv->dev->broadcast[8] = pkey >> 8;
>  	priv->dev->broadcast[9] = pkey & 0xff;
> 
> --
> 1.8.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
