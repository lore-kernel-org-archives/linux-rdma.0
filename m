From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/mlx4: Build the port IBoE GID table properly under bonding
Date: Mon, 17 Feb 2014 14:52:35 +0300
Message-ID: <20140217115235.GA27933@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Moni Shoua,

This is a semi-automatic email about new static checker warnings.

The patch ad4885d279b6: "IB/mlx4: Build the port IBoE GID table
properly under bonding" from Feb 5, 2014, leads to the following
Smatch complaint:

drivers/infiniband/hw/mlx4/main.c:1749 mlx4_ib_scan_netdevs()
	 error: we previously assumed 'curr_netdev' could be null (see line 1722)

drivers/infiniband/hw/mlx4/main.c
  1721	
  1722			if (curr_netdev) {
                            ^^^^^^^^^^^
Check.

  1723				port_state = (netif_running(curr_netdev) && netif_carrier_ok(curr_netdev)) ?
  1724							IB_PORT_ACTIVE : IB_PORT_DOWN;
  1725				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
  1726			} else {
  1727				reset_gid_table(ibdev, port);
  1728			}
  1729			/* if using bonding/team and a slave port is down, we don't the bond IP
  1730			 * based gids in the table since flows that select port by gid may get
  1731			 * the down port.
  1732			 */
  1733			if (curr_master && (port_state == IB_PORT_DOWN)) {
  1734				reset_gid_table(ibdev, port);
  1735				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
  1736			}
  1737			/* if bonding is used it is possible that we add it to masters
  1738			 * only after IP address is assigned to the net bonding
  1739			 * interface.
  1740			*/
  1741			if (curr_master && (old_master != curr_master)) {
  1742				reset_gid_table(ibdev, port);
  1743				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
  1744				mlx4_ib_get_dev_addr(curr_master, ibdev, port);
  1745			}
  1746	
  1747			if (!curr_master && (old_master != curr_master)) {
  1748				reset_gid_table(ibdev, port);
  1749				mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
                                                               ^^^^^^^^^^^
Dereferenced without checking.

  1750				mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
  1751			}

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
