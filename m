From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: mlx4: Add support for promiscuous mode in the new steering model.
Date: Tue, 3 May 2016 15:39:54 +0300
Message-ID: <20160503123953.GA4653@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Yevgeny Petrilin,

The patch b12d93d63c32: "mlx4: Add support for promiscuous mode in
the new steering model." from Mar 22, 2011, leads to the following
static checker warning:

	drivers/net/ethernet/mellanox/mlx4/mcg.c:1191 mlx4_qp_attach_common()
	error: uninitialized symbol 'index'.

drivers/net/ethernet/mellanox/mlx4/mcg.c
  1097  int mlx4_qp_attach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
  1098                            int block_mcast_loopback, enum mlx4_protocol prot,
                                                                               ^^^^
prot comes from the caller.

  1099                            enum mlx4_steer_type steer)
  1100  {
  1101          struct mlx4_priv *priv = mlx4_priv(dev);
  1102          struct mlx4_cmd_mailbox *mailbox;
  1103          struct mlx4_mgm *mgm;
  1104          u32 members_count;
  1105          int index, prev;
                    ^^^^^
index not initialized.

  1106          int link = 0;
  1107          int i;
  1108          int err;
  1109          u8 port = gid[5];
  1110          u8 new_entry = 0;
                   ^^^^^^^^^
new_entry is false.

  1111  
  1112          mailbox = mlx4_alloc_cmd_mailbox(dev);
  1113          if (IS_ERR(mailbox))
  1114                  return PTR_ERR(mailbox);
  1115          mgm = mailbox->buf;
  1116  
  1117          mutex_lock(&priv->mcg_table.mutex);
  1118          err = find_entry(dev, port, gid, prot,
  1119                           mailbox, &prev, &index);
  1120          if (err)

find_entry() fails so index is still not initialized.

  1121                  goto out;

[ snip ]

  1183  out:
  1184          if (prot == MLX4_PROT_ETH) {
  1185                  /* manage the steering entry for promisc mode */
  1186                  if (new_entry)
  1187                          err = new_steering_entry(dev, port, steer,
  1188                                                   index, qp->qpn);
  1189                  else
  1190                          err = existing_steering_entry(dev, port, steer,
  1191                                                        index, qp->qpn);
                                                              ^^^^^
Uninitialized.

  1192          }
  1193          if (err && link && index != -1) {
  1194                  if (index < dev->caps.num_mgms)
  1195                          mlx4_warn(dev, "Got AMGM index %d < %d\n",
  1196                                    index, dev->caps.num_mgms);
  1197                  else
  1198                          mlx4_bitmap_free(&priv->mcg_table.bitmap,
  1199                                           index - dev->caps.num_mgms, MLX4_USE_RR);
  1200          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
