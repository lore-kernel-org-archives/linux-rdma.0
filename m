From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 0/8] Mellanox, mlx5 updates 2018-07-16
Date: Mon, 16 Jul 2018 18:35:29 -0700
Message-ID: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

This series includes mlx5 core infrastructure updates and fixes
aimed for mlx5-next branch.

In case of no objections, below patches will be applied to mlx5-next branch
and next mlx5 net-next pull request will start with a merge commit
pointing to the last patch in this series.

>From Eran:
 - Add MPEGC (Management PCIe General Configuration) registers and btis
 - Fix tristate and description for MLX5 module

>From Feras:
 - Add hardware structures for the firmware tracer

>From Jainbo:
 - Core support for double vlan push/pop steering action

>From Max:
 - Add XRQ commands definitions

>From Noa:
 - Add missing SET_DRIVER_VERSION command translation

>From Roi:
 - Use ERR_CAST() instead of coding it

>From Tariq:
 - Better return types for CQE API

Thanks,
Saeed

--- 

Eran Ben Elisha (2):
  net/mlx5: Expose MPEGC (Management PCIe General Configuration)
    structures
  net/mlx5: Fix tristate and description for MLX5 module

Feras Daoud (1):
  net/mlx5: FW tracer, add hardware structures

Jianbo Liu (1):
  net/mlx5: Add core support for double vlan push/pop steering action

Max Gurtovoy (1):
  net/mlx5: Add XRQ commands definitions

Noa Osherovich (1):
  net/mlx5: Add missing SET_DRIVER_VERSION command translation

Roi Dayan (1):
  net/mlx5: Use ERR_CAST() instead of coding it

Tariq Toukan (1):
  net/mlx5: Better return types for CQE API

 drivers/infiniband/hw/mlx5/Kconfig            |  2 +-
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  9 ++
 .../mellanox/mlx5/core/diag/fs_tracepoint.h   |  2 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |  6 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 12 ++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  6 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  2 +-
 include/linux/mlx5/device.h                   |  8 +-
 include/linux/mlx5/driver.h                   |  5 +
 include/linux/mlx5/fs.h                       |  4 +-
 include/linux/mlx5/mlx5_ifc.h                 | 93 ++++++++++++++++++-
 12 files changed, 133 insertions(+), 22 deletions(-)

-- 
2.17.0
