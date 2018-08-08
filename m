From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 0/6] Mellanox, mlx5 next updates 2018-08-09
Date: Wed,  8 Aug 2018 16:23:47 -0700
Message-ID: <20180808232353.15514-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi All,

This series includes mlx5 core driver updates and mostly simple
cleanups.

>From Denis: Use max #EQs reported by firmware to request MSIX vectors.

>From Eli: Trivial cleanups, unused arguments/functions and reduce
command polling interval when command interface is in polling mode.

>From Eran: Rename vport state enums, to better reflect their actual
usage.

Thanks,
Saeed.

---

Denis Drozdov (1):
  net/mlx5: Use max_num_eqs for calculation of required MSIX vectors

Eli Cohen (4):
  net/mlx5: E-Switch, Remove unused argument when creating legacy FDB
  net/mlx5: Remove unused mlx5_query_vport_admin_state
  net/mlx5: Unexport functions that need not be exported
  net/mlx5: Reduce command polling interval

Eran Ben Elisha (1):
  net/mlx5: Rename modify/query_vport state related enums

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  8 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 14 +++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    | 12 ------------
 include/linux/mlx5/device.h                        |  6 +++---
 include/linux/mlx5/mlx5_ifc.h                      |  9 ++++++---
 include/linux/mlx5/vport.h                         |  2 --
 10 files changed, 31 insertions(+), 40 deletions(-)

-- 
2.17.0
