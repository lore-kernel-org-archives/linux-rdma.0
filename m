From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] net/mlx5: Separate between E-Switch and MPFS
Date: Wed, 9 Aug 2017 16:18:59 +0300
Message-ID: <20170809131859.6bsjlch2exjfq5p5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Saeed Mahameed,

The patch eeb66cdb6826: "net/mlx5: Separate between E-Switch and
MPFS" from Jun 4, 2017, leads to the following static checker warning:

	drivers/net/ethernet/mellanox/mlx5/core/en_fs.c:390 mlx5e_execute_l2_action()
	error: dereferencing freed memory 'hn'

drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
   364  static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
   365                                      struct mlx5e_l2_hash_node *hn)
   366  {
   367          u8 action = hn->action;
   368          int l2_err = 0;
   369  
   370          switch (action) {
   371          case MLX5E_ACTION_ADD:
   372                  mlx5e_add_l2_flow_rule(priv, &hn->ai, MLX5E_FULLMATCH);
   373                  if (!is_multicast_ether_addr(hn->ai.addr)) {
   374                          l2_err = mlx5_mpfs_add_mac(priv->mdev, hn->ai.addr);
   375                          hn->mpfs = !l2_err;
   376                  }
   377                  hn->action = MLX5E_ACTION_NONE;
   378                  break;
   379  
   380          case MLX5E_ACTION_DEL:
   381                  if (!is_multicast_ether_addr(hn->ai.addr) && hn->mpfs)
   382                          l2_err = mlx5_mpfs_del_mac(priv->mdev, hn->ai.addr);
   383                  mlx5e_del_l2_flow_rule(priv, &hn->ai);
   384                  mlx5e_del_l2_from_hash(hn);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^
Freed.

   385                  break;
   386          }
   387  
   388          if (l2_err)
   389                  netdev_warn(priv->netdev, "MPFS, failed to %s mac %pM, err(%d)\n",
   390                              action == MLX5E_ACTION_ADD ? "add" : "del", hn->ai.addr, l2_err);
                                                                                ^^^^^^^^^^^
Patch adds new dereference after free.

   391  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
