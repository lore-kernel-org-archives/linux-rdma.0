From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: net/mlx4_en: Add DCB PFC support through CEE netlink commands
Date: Sat, 25 Jun 2016 01:03:36 +0300
Message-ID: <20160624220312.GA6570@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ranas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Rana Shahout,

The patch af7d51852631: "net/mlx4_en: Add DCB PFC support through CEE
netlink commands" from Jun 21, 2016, leads to the following static
checker warning:

	drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c:164 mlx4_en_dcbnl_set_all()
	warn: signedness bug returning '(-22)'

drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c
   156  static u8 mlx4_en_dcbnl_set_all(struct net_device *netdev)

This is a u8 function.  It's called twice but it looks like the
important caller is dcbnl_setall() from net/dcb/dcbnl.c.  I dont' think
we're returning the right values but I'm not sure what's expected.

   157  {
   158          struct mlx4_en_priv *priv = netdev_priv(netdev);
   159          struct mlx4_en_dev *mdev = priv->mdev;
   160          struct mlx4_en_cee_config *dcb_cfg = &priv->cee_params.dcb_cfg;
   161          int err = 0;
   162  
   163          if (!(priv->cee_params.dcbx_cap & DCB_CAP_DCBX_VER_CEE))
   164                  return -EINVAL;
                        ^^^^^^^^^^^^^^
   165  
   166          if (dcb_cfg->pfc_state) {
   167                  int tc;
   168  
   169                  priv->prof->rx_pause = 0;
   170                  priv->prof->tx_pause = 0;
   171                  for (tc = 0; tc < CEE_DCBX_MAX_PRIO; tc++) {
   172                          u8 tc_mask = 1 << tc;
   173  
   174                          switch (dcb_cfg->tc_config[tc].dcb_pfc) {
   175                          case pfc_disabled:
   176                                  priv->prof->tx_ppp &= ~tc_mask;
   177                                  priv->prof->rx_ppp &= ~tc_mask;
   178                                  break;
   179                          case pfc_enabled_full:
   180                                  priv->prof->tx_ppp |= tc_mask;
   181                                  priv->prof->rx_ppp |= tc_mask;
   182                                  break;
   183                          case pfc_enabled_tx:
   184                                  priv->prof->tx_ppp |= tc_mask;
   185                                  priv->prof->rx_ppp &= ~tc_mask;
   186                                  break;
   187                          case pfc_enabled_rx:
   188                                  priv->prof->tx_ppp &= ~tc_mask;
   189                                  priv->prof->rx_ppp |= tc_mask;
   190                                  break;
   191                          default:
   192                                  break;
   193                          }
   194                  }
   195                  en_dbg(DRV, priv, "Set pfc on\n");
   196          } else {
   197                  priv->prof->rx_pause = 1;
   197                  priv->prof->rx_pause = 1;
   198                  priv->prof->tx_pause = 1;
   199                  en_dbg(DRV, priv, "Set pfc off\n");
   200          }
   201  
   202          err = mlx4_SET_PORT_general(mdev->dev, priv->port,
   203                                      priv->rx_skb_size + ETH_FCS_LEN,
   204                                      priv->prof->tx_pause,
   205                                      priv->prof->tx_ppp,
   206                                      priv->prof->rx_pause,
   207                                      priv->prof->rx_ppp);
   208          if (err)
   209                  en_err(priv, "Failed setting pause params\n");
   210          return err;
                ^^^^^^^^^^
This is negatives as well.

   211  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
