From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 07/12] IB/core: Add RoCE table bonding support
Date: Thu, 11 Jun 2015 00:18:18 -0600
Message-ID: <20150611061818.GB22369@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1433772735-22416-8-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433772735-22416-8-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 05:12:10PM +0300, Matan Barak wrote:

> +static enum bonding_slave_state is_eth_active_slave_of_bonding(struct net_device *idev,
> +							       struct net_device *upper)
> +{
> +	if (upper && IS_NETDEV_BONDING_MASTER(upper)) {
> +		struct net_device *pdev;
> +
> +		rcu_read_lock();
> +		pdev = bond_option_active_slave_get_rcu(netdev_priv(upper));
> +		rcu_read_unlock();
> +		if (pdev)
> +			return idev == pdev ? BONDING_SLAVE_STATE_ACTIVE :
> +				BONDING_SLAVE_STATE_INACTIVE;

This isn't buggy as written, but I think, it doesn't re-enforce the
rules for how rcu critical sections should work.

The only reason this is not buggy is because it is a pointer compare
and it works out that is OK in this particular case. But, it is subtle
and it might trip up someone down the road.

Keeping with the idomatic RCU pattern is better:

 enum bonding_slave_state res = BONDING_SLAVE_STATE_INACTIVE;;

 rcu_read_lock();
 pdev = bond_option_active_slave_get_rcu(netdev_priv(upper));
 if (pdev && pdev == idev)
   res = BONDING_SLAVE_STATE_ACTIVE;
 rcu_read_unlock();

 return res;

ie don't leak pdev out of the critical section unless a ref is taken
on it.

Same comment applies to other similar places in this series.

> +static bool is_upper_dev_rcu(struct net_device *dev, struct net_device *upper)
> +{
> +	struct net_device *_upper = NULL;
> +	struct list_head *iter;
> +
> +	rcu_read_lock();

A _rcu function should *always* be called with rcu_read_lock held.

It makes no sense to take it again in the body.

Change the name, or fix the one call site that doesn't hold the lock.

I see callers that hold the lock and callers that don't hold the lock,
shouldn't be both kinds.

>  static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
>  				 struct net_device *idev, void *cookie)
>  {
> -	struct net_device *rdev;
> -	struct net_device *mdev;
> -	struct net_device *ndev = (struct net_device *)cookie;
> +	return _is_eth_port_of_netdev(ib_dev, port, idev, cookie,
> +				      BONDING_SLAVE_STATE_ACTIVE |
> +				      BONDING_SLAVE_STATE_NA);
> +}

Why wrapper _is_eth_port_of_netdev with is_eth_port_of_netdev? There
is only one caller to _is_eth_port_of_netdev? Please look at all the
other small functions, there are quite a few..

> +static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
> +			    struct net_device *ndev)
> +{
> +	enum_netdev_ipv4_ips(ib_dev, port, ndev);
> +#if IS_ENABLED(CONFIG_IPV6)
> +	enum_netdev_ipv6_ips(ib_dev, port, ndev);
> +#endif
> +}

Did you try the 'if (IS_ENABLED(CONFIG_IPV6))' version I suggested a
few versions ago?

> +static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
> +				void *cookie,
> +				void (*handle_netdev)(struct ib_device *ib_dev,
> +						      u8 port,
> +						      struct
> net_device *ndev))
[..]

> +	LIST_HEAD(upper_list);
> +
> +	rcu_read_lock();
> +	netdev_for_each_all_upper_dev_rcu(ndev, upper, iter) {
> +		struct upper_list *entry = kmalloc(sizeof(*entry),
> +						   GFP_ATOMIC);
> +
> +		if (!entry) {
> +			pr_info("roce_gid_mgmt: couldn't allocate entry to delete ndev\n");
> +			continue;
> +		}
> +
> +		list_add_tail(&entry->list, &upper_list);
> +		dev_hold(upper);
> +		entry->upper = upper;

Everytime I see copying refs onto a stack list I really start to
wonder..

handle_netdev absolutely cannot be called with rcu_read_lock held? Is
that a wise design?

> @@ -309,11 +548,24 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
>  {
>  	static const struct netdev_event_work_cmd add_cmd = {
>  		.cb = add_netdev_ips, .filter = is_eth_port_of_netdev};
> +	static const struct netdev_event_work_cmd add_cmd_upper_ips = {
> +		.cb = add_netdev_upper_ips, .filter = is_eth_port_of_netdev};
>  	static const struct netdev_event_work_cmd del_cmd = {
>  		.cb = del_netdev_ips, .filter = pass_all_filter};
> +	static const struct netdev_event_work_cmd bonding_default_del_cmd_join = {
> +		.cb = del_netdev_default_ips_join, .filter = is_eth_port_inactive_slave};
> +	static const struct netdev_event_work_cmd bonding_default_del_cmd = {
> +		.cb = del_netdev_default_ips, .filter = is_eth_port_inactive_slave};
> +	static const struct netdev_event_work_cmd default_del_cmd = {
> +		.cb = del_netdev_default_ips, .filter = pass_all_filter};
> +	static const struct netdev_event_work_cmd bonding_event_ips_del_cmd = {
> +		.cb = del_netdev_upper_ips, .filter = bonding_slaves_filter};
> +	static const struct netdev_event_work_cmd upper_ips_del_cmd = {
> +		.cb = del_netdev_upper_ips, .filter =
>  upper_device_filter};

I also wonder about all this. Can you talk about why the work queue is
needed at this level, and is this a wise design? Is it the same reason
we can't call handle_netdev with rcu read lock held?

I'm just guessing, but is it because the driver modify_gid callback is
allowed to sleep? Would it make more sense to drive only modify_gid
from a work q and leave the rest of this to run inline with the
notifier? That would save alot of code..

> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index 4df2894..c4fe29a8 100644
> +++ b/drivers/net/bonding/bond_options.c

Woah, Woah, this should be a dedicated patch, needs to be approved by
netdev.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
