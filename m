From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 0/7] Mellanox, mlx5e and IPoIB netlink support fixes
Date: Wed, 10 Oct 2018 18:24:37 -0700
Message-ID: <20181011012444.28194-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This series was meant to go to -rc but due to this late submission and the
size/complexity of this patchset, I am submitting to net-next.

This series came to fix a very serious regression in RDMA
IPoIB netlink child creation API, the patcheset contains fixes to two
components and they must come together:
1) IPoIB netllink implementation to allow allocation of the netdev to be done by
the rtnl netdev code
2) mlx5e refactoring and changes to correctly initialize netdevices
created by the rdma stack.

For more details please see tag log below.

Please pull and let me know if there's any problem.

Thanks,
Saeed.

---

The following changes since commit a6deaa99591098a3e558978c6cec0054fd1d3b97:

  Merge branch 'octeontx2-af-Add-RVU-Admin-Function-driver' (2018-10-10 10:09:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5e-updates-2018-10-10

for you to fetch changes up to 779d986d60de51aabc3bec385f92b832089c5c01:

  net/mlx5e: Do not ignore netdevice TX/RX queues number (2018-10-10 17:58:17 -0700)

----------------------------------------------------------------
mlx5e-updates-2018-10-10

IPoIB netlink support and mlx5e pre-allocated netdevice initialization

IP link was broken due to the changes in IPoIB for the rdma_netdev
support after commit cd565b4b51e5
("IB/IPoIB: Support acceleration options callbacks").

This patchset fixes IPoIB pkey creation and removal using rtnetlink by
adding support in both IPoIB ULP layer and mlx5 layer:

>From Jason and Denis:
1) Introduces changes in the RDMA netdev code in order to
   allow allocation of the netdev to be done by the rtnl netdev code.
2) Reworks IPoIB initialization to use the two step rdma_netdev
   creation.

>From Feras and Saeed, mlx5e netdev layer refactoring to allow accepting
pre-allocated netdevs:
3) Adds support to initialize/cleanup netdevs that are not created
   by mlx5 driver.
4) Change mlx5e netdevice layer to accept the pre-allocated netdevice
   queue number.
5) Initialize mlx5e generic structures in one place to be used for all
   netdevs types NIC/representors/IPoIB (both mlx5 allocated and
   pre-allocted).

----------------------------------------------------------------
Denis Drozdov (2):
      RDMA/netdev: Hoist alloc_netdev_mqs out of the driver
      RDMA/netdev: Fix netlink support in IPoIB

Feras Daoud (3):
      net/mlx5e: Gather common netdev init/cleanup functionality in one place
      net/mlx5e: Always initialize update stats delayed work
      net/mlx5e: Do not ignore netdevice TX/RX queues number

Saeed Mahameed (2):
      net/mlx5e: Initialize all netdev common structures in one place
      net/mlx5e: Use non-delayed work for update stats

 drivers/infiniband/core/verbs.c                    |  46 ++++++
 drivers/infiniband/hw/mlx5/main.c                  |  23 ++-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 132 +++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |  23 ++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |  19 +--
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  23 ++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 160 ++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  39 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  | 126 ++++++++--------
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   9 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  18 ++-
 include/linux/mlx5/driver.h                        |  14 +-
 include/rdma/ib_verbs.h                            |  30 +++-
 16 files changed, 410 insertions(+), 270 deletions(-)
