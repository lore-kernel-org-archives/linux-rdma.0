From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 03/12] IB/core: Add RoCE GID population
Date: Wed, 10 Jun 2015 22:18:31 -0600
Message-ID: <20150611041831.GD16599@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1433772735-22416-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433772735-22416-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 05:12:06PM +0300, Matan Barak wrote:
>  drivers/infiniband/core/core_priv.h      |  26 ++
>  drivers/infiniband/core/device.c         |  77 +++++

I wouldn't mind seeing the core portion which consists of adding
the get_netdev be it's own little mini-series of three, adding the
core and the two driver enablement changes.

> +				rcu_read_lock();
> +				if (ib_dev->get_netdev)
> +					idev =
> ib_dev->get_netdev(ib_dev, port);

If it wasn't clear from before, don't hold a rcu_read_lock around a
driver call back, return a net_device that is already dev_hold'd or
null.

> +	down_read(&lists_rwsem);
> +	list_for_each_entry_rcu(dev, &device_list, core_list)

No _rcu

> +void ib_dev_roce_ports_of_netdev(struct ib_device *ib_dev, roce_netdev_filter filter,
> +					 void *filter_cookie, roce_netdev_callback cb,
> +					 void *cookie)
> +{
> +	u8 port;
> +
> +	if (ib_dev->modify_gid)
[..]
> +		if (ib_dev->get_netdev)
> +			idev = ib_dev->get_netdev(ib_dev, port);

Why check modify_gid and then go on to test and call get_netdev? That
seems strange for a general purpose core API.

> +	/* When calling get_netdev, the HW vendor's driver should return the
> +	 * net device of device @device at port @port_num. The function
> +	 * is called in rtnl_lock. The HW vendor's device driver must guarantee
> +	 * to return NULL before the net device has reached
> +	 * NETDEV_UNREGISTER_FINAL state.

rtnl_lock ? That doesn't seem to match what is going on..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
