From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 00/13] Get rid of switchdev_ops
Date: Fri,  1 Feb 2019 14:06:44 -0800
Message-ID: <20190201220657.30170-1-f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <viv>
List-Id: linux-rdma@vger.kernel.org

Hi all,

This patch series converts SWITCHDEV_PORT_ATTR_{GET,SET} to use a
blocking notifier, similar to how SWITCHDEV_PORT_OBJ_{ADD,DEL} has been
changed recently by Petr.

This was suggested by Ido to help with a particular use case I have
where I want to be able to veto a switchdev bridge attribute from a
driver (multicast_snooping).

Please review since I may not have gotten the driver abstraction right,
especially for mlx5e and nfp since these are *hum* *hum* large drivers.

Florian Fainelli (13):
  switchdev: Add SWITCHDEV_PORT_ATTR_SET, SWITCHDEV_PORT_ATTR_GET
  rocker: Handle SWITCHDEV_PORT_ATTR_GET/SET
  net: dsa: Handle SWITCHDEV_PORT_ATTR_GET/SET
  mlxsw: spectrum_switchdev: Handle SWITCHDEV_PORT_ATTR_GET/SET
  net: mscc: ocelot: Handle SWITCHDEV_PORT_ATTR_GET/SET
  staging: fsl-dpaa2: ethsw: Handle SWITCHDEV_PORT_ATTR_GET/SET
  bnxt: Handle SWITCHDEV_PORT_ATTR_GET event
  liquidio: Handle SWITCHDEV_PORT_ATTR_GET event
  mlxsw: switchx2: Handle SWITCHDEV_PORT_ATTR_GET event
  net/mlx5e: Handle SWITCHDEV_PORT_ATTR_GET event
  nfp: Handle SWITCHDEV_PORT_ATTR_GET event
  netdevsim: Handle SWITCHDEV_PORT_ATTR_GET event
  net: switchdev: Replace port attr get/set SDO with a notification

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  63 ++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h |   8 ++
 .../net/ethernet/cavium/liquidio/lio_main.c   |  53 ++++++++-
 .../net/ethernet/cavium/liquidio/lio_vf_rep.c |  48 +++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  50 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  12 --
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 -
 .../mellanox/mlxsw/spectrum_switchdev.c       |  36 +++---
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |  46 +++++++-
 drivers/net/ethernet/mscc/ocelot.c            |  30 ++++-
 drivers/net/ethernet/netronome/nfp/nfp_main.c |  14 ++-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   3 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  19 +++-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   2 -
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  17 ++-
 drivers/net/ethernet/netronome/nfp/nfp_port.h |   5 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  30 ++++-
 drivers/net/netdevsim/netdev.c                |  46 +++++++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  30 ++++-
 include/linux/netdevice.h                     |   3 -
 include/net/switchdev.h                       |  28 ++---
 net/dsa/slave.c                               |  30 ++++-
 net/switchdev/switchdev.c                     | 107 ++++++------------
 26 files changed, 503 insertions(+), 194 deletions(-)

-- 
2.17.1
