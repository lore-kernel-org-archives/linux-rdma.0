From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/mlx4: Build the port IBoE GID table properly under bonding
Date: Tue, 18 Feb 2014 17:28:58 +0300
Message-ID: <20140218142858.GN26776@mwanda>
References: <20140217115235.GA27933@elgon.mountain>
 <53036A88.5030306@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53036A88.5030306-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 18, 2014 at 04:13:28PM +0200, Moni Shoua wrote:
> On 2/17/2014 1:52 PM, Dan Carpenter wrote:
> >Hello Moni Shoua,
> >
> >This is a semi-automatic email about new static checker warnings.
> >
> >The patch ad4885d279b6: "IB/mlx4: Build the port IBoE GID table
> >properly under bonding" from Feb 5, 2014, leads to the following
> >Smatch complaint:
> >
> >drivers/infiniband/hw/mlx4/main.c:1749 mlx4_ib_scan_netdevs()
> >	 error: we previously assumed 'curr_netdev' could be null (see line 1722)
> >
> >drivers/infiniband/hw/mlx4/main.c
> >   1721	
> >   1722			if (curr_netdev) {
> >                             ^^^^^^^^^^^
> >Check.
> >
> >   1723				port_state = (netif_running(curr_netdev) && netif_carrier_ok(curr_netdev)) ?
> >   1724							IB_PORT_ACTIVE : IB_PORT_DOWN;
> >   1725				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
> >   1726			} else {
> >   1727				reset_gid_table(ibdev, port);
> >   1728			}
> >   1729			/* if using bonding/team and a slave port is down, we don't the bond IP
> >   1730			 * based gids in the table since flows that select port by gid may get
> >   1731			 * the down port.
> >   1732			 */
> >   1733			if (curr_master && (port_state == IB_PORT_DOWN)) {
> >   1734				reset_gid_table(ibdev, port);
> >   1735				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
> >   1736			}
> >   1737			/* if bonding is used it is possible that we add it to masters
> >   1738			 * only after IP address is assigned to the net bonding
> >   1739			 * interface.
> >   1740			*/
> >   1741			if (curr_master && (old_master != curr_master)) {
> >   1742				reset_gid_table(ibdev, port);
> >   1743				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
> >   1744				mlx4_ib_get_dev_addr(curr_master, ibdev, port);
> >   1745			}
> >   1746	
> >   1747			if (!curr_master && (old_master != curr_master)) {
> >   1748				reset_gid_table(ibdev, port);
> >   1749				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
> >                                                                ^^^^^^^^^^^
> >Dereferenced without checking.
> >
> >   1750				mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
> >   1751			}
> >
> >regards,
> >dan carpenter
> Not really a bug. (curr_master != NULL) implies (curr_netdev != NULL)

Ha ha.  Take another look.  That's what I was just explaining about!  :)
On line 1743 when curr_master is non-NULL then Smatch doesn't complain
because it understands about the relationship between curr_master and
curr_netdev.

But here it is complaining about line 1749 where curr_master is NULL so
the implication doesn't apply.

Nice, huh?

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
