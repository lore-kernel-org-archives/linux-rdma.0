From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC for accelerated IPoIB 00/27] Enhanced mode for IPoIB driver
Date: Wed,  1 Mar 2017 16:02:08 +0200
Message-ID: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

    The IPoIB protocol encapsulates IP packets over Infiniband datagrams.
    As a direct RDMA Upper Layer Protocol (ULP), IPoIB cannot support HW
    features that are specific to the IP protocol stack.

    Nevertheless, RDMA interfaces have been extended to support some of the
    prominent IP offload features, such as TCP/UDP checksum and TSO.
    This provided reasonable performance gain for IPoIB but is still
    insufficient to cope with the increasing network bandwidth demand.

    However, New features are exisiting in common network interfaces that
    are very hard to implement in IPoIB interfaces while it uses the RDMA
    layer, examples include TSS and RSS, tunneling offloads, and XDP.
    Rather than continuously porting IP network interface developments into
    the RDMA stack, we propose adding an abstract network data-path interfaces
    to RDMA devices.

    In order to present a consistent interface to users, the IPoIB ULP
    continues to represent the network device to the IP stack.
    The common code also manages the IPoIB control plane, such as resolving
    path queries and registering to multicast groups.
    Data path operations are forwarded to devices that implement the new
    API, or fallback to the standard implementation otherwise.
    Using the forgoing approach, we show how IPoIB closes the performance
    gap compared to state-of-the-art Ethernet network interfaces.

    The implementation idea is to expose a set of functions that are used for
    network interfaces, like create, delete, init hw resources, send, and
    attach/detach multicast to qp.
    That set of functions encapsulates in new struct, and this struct can or
    can't be given by the specific HW layer.

    The IPoIB code will be adapted to enable the option of accelerating the
    network interface, but the code will work as before if the HW below
    doesn't support the acceleration.
    Each HW vendor can supply the acceleration for the IPoIB or to leave
    IPoIB to work as before.

    The flow is as the following:

    /* default accelerating functions, same as before */
    struct ib_ipoib_accel_ops default_ipoib_accel_ops = {
            .ib_dev_init = ipoib_dev_init_default,
            .ib_dev_cleanup = ipoib_dev_uninit_default,
            .ib_dev_open = ipoib_ib_dev_open_default,
            .ib_dev_stop = ipoib_ib_dev_stop_default,
            .send = ipoib_send,
            .create_netdev = ipoib_create_netdev_default,
            .attach_mcast = ipoib_mcast_attach,
            .dettach_mcast = ipoib_mcast_dettach,
    };

        /* checks if the ib core layer supports the accelerations via
         * new verb get_ipoib_accel_ops, if the response is not NULL
         * IPoIB will
         * use it
         */
        cur_ipoib_accel_ops = ib_get_ipoib_accel_ops(hca);
        if (!cur_ipoib_accel_ops) {
        /*
         * IPoIB has a default acceleration set of
         * functions that does the same code that it
         * does before,
         * so if the under layer doesn't support
         * acceleration the code looks and feels the
         * same way
         */
                pr_debug("default ipoib_ops for %s\n", hca->name);
                cur_ipoib_accel_ops = &default_ipoib_accel_ops;
        }

        /* create netdev device */
        ipoib_accel_ops->create_netdev(hca, name, ipoib_setup_common);

        /* Creating resources */
        priv->ipoib_accel_ops->ib_dev_init(dev, &priv->qp_num);

        /* open device */
        ipoib_accel_ops->ib_dev_open(dev);

        /* attach multicast */
        ipoib_accel_ops->attach_mcast(dev, gid, mlid);

        /* send traffic */
        ipoib_accel_ops->send(dev, skb, ah, rqpn);

Erez Shitrit (27):
  IB/ipoib: Separate control and data related initializations
  IB/ipoib: separate control from HW operation on ipoib_open/stop ndo
  IB/ipoib: Rename qpn to dqpn in ipoib_send and post_send functions
  IB/verb: Add ipoib_options struct and API
  IB/ipoib: Support ipoib acceleration options callbacks
  IB/ipoib: Add context to ipoib to be used in acceleration layer
  hw/mlx5: Add New bit to check over QP creation
  linux/mlx5/mlx5_ifc.h: Add underlay_qpn field to PRM objects
  net/mlx5e: Refactor EN code to support IB link
  net/mlx5e: Creating and Destroying flow-steering tables for IB link
  mlx5_en: Support netdevice creation for IB link type
  mlx5_en: Refactor attach_netdev API
  mlx5_en: Use underlay_qpn in tis creation
  mlx5_en: Export resource creation function to be used in IB link
  mlx5_core: Enable flow-steering for IB link
  mlx5_core/en: Enhanced flow table creation to support ETH and IB
    links.
  mlx5_en: Change cleanup API in order to enable IB link
  mlx5_en: Change mlx5e_open_locked and mlx5e_close_locked api
  mlx5_en: Export open/close api for IB link
  include/linux/mlx5: Add  mlx5_wqe_eth_pad and enhanced-ipoib-qp-mode
  mlx5_en: Refactor TX send flow
  mlx5_en: Export send function for IB link type
  mlx5_en: New function pointer for build_rx_skb is
  mlx5_en: Change the function that checks the packet type
  mlx5_en: Add support for build_rx_skb for packet from IB type
  mlx5_ib: skeleton for mlx5_ib to support ipoib_ops
  RFC: cover letter

 drivers/infiniband/hw/mlx5/Makefile                |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   3 +
 drivers/infiniband/hw/mlx5/mlx5_ipoib_ops.c        | 289 ++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c                    |   5 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |  26 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            | 275 ++++++-------
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 187 +++++++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  13 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |  52 +--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  66 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 435 ++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  70 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 292 +++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   9 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  77 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   3 +-
 include/linux/mlx5/driver.h                        |  17 +
 include/linux/mlx5/fs.h                            |  16 +-
 include/linux/mlx5/mlx5_ifc.h                      |  11 +-
 include/linux/mlx5/qp.h                            |   8 +
 include/rdma/ib_ipoib_accel_ops.h                  |  71 ++++
 include/rdma/ib_verbs.h                            |   9 +
 30 files changed, 1545 insertions(+), 504 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/mlx5_ipoib_ops.c
 create mode 100644 include/rdma/ib_ipoib_accel_ops.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
