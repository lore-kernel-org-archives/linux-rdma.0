From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 00/10] IPoIB uninit
Date: Sun, 29 Jul 2018 11:34:50 +0300
Message-ID: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

IP link was broken due to the changes in IPoIB for the rdma_netdev
support after commit cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks").

This patchset restores IPoIB pkey creation and removal using rtnetlink.

It is completely rewritten variant of
https://marc.info/?l=linux-rdma&m=151553425830918&w=2 patch series.

Thanks

Erez Shitrit (2):
  IB/ipoib: Use cancel_delayed_work_sync for neigh-clean task
  IB/ipoib: Make ipoib_neigh_hash_uninit fully fence its work

Jason Gunthorpe (8):
  IB/ipoib: Get rid of IPOIB_FLAG_GOING_DOWN
  IB/ipoib: Move all uninit code into ndo_uninit
  IB/ipoib: Move init code to ndo_init
  RDMA/netdev: Use priv_destructor for netdev cleanup
  IB/ipoib: Get rid of the sysfs_mutex
  IB/ipoib: Do not remove child devices from within the ndo_uninit
  IB/ipoib: Maintain the child_intfs list from ndo_init/uninit
  IB/ipoib: Consolidate checking of the proposed child interface

 drivers/infiniband/hw/mlx5/main.c                  |  10 -
 drivers/infiniband/ulp/ipoib/ipoib.h               |  16 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  14 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 419 ++++++++++++---------
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |  23 --
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          | 259 +++++++------
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  37 +-
 include/linux/mlx5/driver.h                        |   3 -
 include/rdma/ib_verbs.h                            |   6 +-
 9 files changed, 428 insertions(+), 359 deletions(-)
