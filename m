From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 00/12] Move IB representors to single IB device multiple ports
Date: Thu, 28 Mar 2019 15:27:30 +0200
Message-ID: <20190328132742.12070-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

>From Mark,

Hi,

This series starts from two refactoring patches performed in mlx5_core
and they are part of a larger series intended to expose the ability
to insert FDB steering rules by the RDMA side.

They are followed by patches which move IB representors to single IB
device. Currently when moving to switchdev mode an IB device is created
per virtual function (and one for the uplink). While initially this was
right approach, the limitation of this model requires us to change it.

Such limitations includes:
 - Inability to share resources between IB devices.
 - Lack of DEVX to allow more control and device specific functionality.
 - Interacting with the E-Switch.
 - Doesn't work well with namespaces.

In this series we move to a single IB device with multiple ports where
each port represents a different virtual function (port 1 is for the
uplink). All the limitations listed above are now resolved and the
software model exposed to users is more cohesive.

Thanks

Mark Bloch (12):
  net/mlx5: E-Switch, don't use hardcoded values for FDB prios
  net/mlx5: E-Switch, add a new prio to be used by the RDMA side
  RDMA/mlx5: Move netdev info into the port struct
  RDMA/mlx5: Free IB device on remove
  RDMA/mlx5: Move ports allocation to outside of INIT stage
  RDMA/mlx5: Use correct size for device resources
  RDMA/mlx5: Move rep into port struct
  RDMA/mlx5: Move default representors SQ steering to rule to modify QP
  RDMA/mlx5: Refactor netdev affinity code
  RDMA/mlx5: Move SMI caps logic
  RDMA/mlx5: Move to single device multiport ports in switchdev mode
  RDMA/mlx5: Remove VF representor profile

 drivers/infiniband/hw/mlx5/devx.c             |   2 +-
 drivers/infiniband/hw/mlx5/flow.c             |   2 +-
 drivers/infiniband/hw/mlx5/ib_rep.c           | 109 +++++----
 drivers/infiniband/hw/mlx5/ib_rep.h           |  13 +-
 drivers/infiniband/hw/mlx5/main.c             | 207 ++++++++++--------
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  35 +--
 drivers/infiniband/hw/mlx5/mr.c               |   6 +-
 drivers/infiniband/hw/mlx5/qp.c               |  46 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |   5 -
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  12 +-
 include/linux/mlx5/fs.h                       |   6 +
 11 files changed, 239 insertions(+), 204 deletions(-)
