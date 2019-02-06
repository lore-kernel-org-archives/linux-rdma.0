From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v4 00/12] net: Introduce ndo_get_port_parent_id()
Date: Wed,  6 Feb 2019 09:45:34 -0800
Message-ID: <20190206174546.23597-1-f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

Based on discussion with Ido and feedback from Jakub there are clearly
two classes of users that implement SWITCHDEV_ATTR_ID_PORT_PARENT_ID:

- PF/VF drivers which typically only implement return the port's parent
  ID, yet have to implement switchdev_port_attr_get() just for that

- Ethernet switch drivers: mlxsw, ocelot, DSA, etc. which implement more
  attributes which we want to be able to eventually veto in the context
  of the caller, thus making them candidates for using a blocking notifier
  chain

Changes in v4:

- remove superfluous net/switchdev.h inclusions in a few files
- added Jiri's Acked-by where given
- removed err = -EOPNOTSUPP initializations
- changed according to Jiri's suggestion in net/ipv4/ipmr.c

Changes in v3:

- keep ethsw's switchdev_ops assignment
- remove inclusion of net/switchdev.h in netdevsim which is no longer
  necesary

Changes in v2:

- resolved build failures spotted by kbuild test robot
- added helpers functions into the core network device layer:
  dev_get_port_parent_id() and netdev_port_same_parent_id();
- added support for recursion to lower devices

Changes from RFC:

- introduce a ndo_get_port_parent_id() and convert all relevant drivers
  to use it

- get rid of SWITCHDEV_ATTR_ID_PORT_PARENT_ID

A subsequent set of patches will convert switchdev_port_attr_set() to
use a blocking notifier call, and still get rid of
switchdev_port_attr_get() altogether.

Florian Fainelli (12):
  net: Introduce ndo_get_port_parent_id()
  bnxt: Implement ndo_get_port_parent_id()
  liquidio: Implement ndo_get_port_parent_id()
  net/mlx5e: Implement ndo_get_port_parent_id()
  mlxsw: Implement ndo_get_port_parent_id()
  mscc: ocelot: Implement ndo_get_port_parent_id()
  nfp: Implement ndo_get_port_parent_id()
  rocker: Implement ndo_get_port_parent_id()
  netdevsim: Implement ndo_get_port_parent_id()
  staging: fsl-dpaa2: ethsw: Implement ndo_get_port_parent_id()
  net: dsa: Implement ndo_get_port_parent_id()
  net: Get rid of SWITCHDEV_ATTR_ID_PORT_PARENT_ID

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 28 +++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 12 ++--
 .../net/ethernet/cavium/liquidio/lio_main.c   | 22 ++-----
 .../net/ethernet/cavium/liquidio/lio_vf_rep.c | 25 +++-----
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 31 ++++------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 13 +++++
 .../mellanox/mlxsw/spectrum_switchdev.c       |  5 --
 .../net/ethernet/mellanox/mlxsw/switchx2.c    | 37 +++++-------
 drivers/net/ethernet/mscc/ocelot.c            | 33 +++++------
 .../ethernet/netronome/nfp/flower/action.c    |  3 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  4 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.c | 22 ++-----
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  4 +-
 drivers/net/ethernet/rocker/rocker_main.c     | 17 ++++--
 drivers/net/netdevsim/netdev.c                | 23 ++------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 16 ++++--
 include/linux/netdevice.h                     |  9 +++
 include/net/switchdev.h                       | 11 ----
 net/bridge/br_switchdev.c                     |  9 +--
 net/core/dev.c                                | 57 +++++++++++++++++++
 net/core/net-sysfs.c                          | 12 +---
 net/core/rtnetlink.c                          | 12 +---
 net/dsa/slave.c                               | 18 ++++--
 net/ipv4/ipmr.c                               | 13 ++---
 net/switchdev/switchdev.c                     | 20 -------
 30 files changed, 214 insertions(+), 259 deletions(-)

-- 
2.17.1
