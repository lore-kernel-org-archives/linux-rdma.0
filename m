From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 0/6] mlx5 updates for shared branch 2018-12-12
Date: Wed, 12 Dec 2018 19:11:35 -0800
Message-ID: <20181213031141.12783-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

This series includes updates to mlx5 core driver for the shared
mlx5-next branch.

1) From Mark Bloch, Unify e-switch representors load approach in mlx5_ib
2) From Shahar Klein, Flow counters affinity bits for lag
3) From Roy Dayan, Lag affinity log and cleanup
4) From Saeed Mahameed, A cleanup patch for mlx5_ifc.h

Thanks,
Saeed.

---

Mark Bloch (1):
  IB/mlx5: Unify e-switch representors load approach between uplink and
    VFs

Roi Dayan (2):
  net/mlx5: Split the activate lag function into two routines
  net/mlx5: Add lag affinity info to log

Saeed Mahameed (1):
  net/mlx5: Use lowercase 'X' for hex values

Shahar Klein (2):
  net/mlx5: E-Switch, Introduce flow counter affinity
  net/mlx5: Fold the modify lag code into function

 drivers/infiniband/hw/mlx5/ib_rep.c           | 11 +++-
 drivers/infiniband/hw/mlx5/main.c             | 29 +++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 59 +++++++++++++------
 include/linux/mlx5/mlx5_ifc.h                 | 24 +++++---
 5 files changed, 74 insertions(+), 50 deletions(-)

-- 
2.19.2
