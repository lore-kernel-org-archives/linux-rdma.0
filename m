From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/mlx5: Extend query_device/port to support RoCE
Date: Fri, 8 Jan 2016 16:23:24 +0300
Message-ID: <20160108132324.GA7683@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Achiad Shochat,

The patch 3f89a643eb29: "IB/mlx5: Extend query_device/port to support
RoCE" from Dec 23, 2015, leads to the following static checker
warning:

	drivers/infiniband/hw/mlx5/main.c:149 mlx5_query_port_roce()
	warn: passing casted pointer '&props->qkey_viol_cntr' to 'mlx5_query_nic_vport_qkey_viol_cntr()' 32 vs 16.

drivers/infiniband/hw/mlx5/main.c
   129  static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
   130                                  struct ib_port_attr *props)
   131  {
   132          struct mlx5_ib_dev *dev = to_mdev(device);
   133          struct net_device *ndev;
   134          enum ib_mtu ndev_ib_mtu;
   135  
   136          memset(props, 0, sizeof(*props));
   137  
   138          props->port_cap_flags  |= IB_PORT_CM_SUP;
   139          props->port_cap_flags  |= IB_PORT_IP_BASED_GIDS;
   140  
   141          props->gid_tbl_len      = MLX5_CAP_ROCE(dev->mdev,
   142                                                  roce_address_table_size);
   143          props->max_mtu          = IB_MTU_4096;
   144          props->max_msg_sz       = 1 << MLX5_CAP_GEN(dev->mdev, log_max_msg);
   145          props->pkey_tbl_len     = 1;
   146          props->state            = IB_PORT_DOWN;
   147          props->phys_state       = 3;
   148  
   149          mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev,
   150                                              (u16 *)&props->qkey_viol_cntr);
                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This will break on big endian systems.

   151  
   152          ndev = mlx5_ib_get_netdev(device, port_num);
   153          if (!ndev)
   154                  return 0;
   155  

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
