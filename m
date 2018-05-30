From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Tue, 29 May 2018 17:19:52 -0700
Message-ID: <20180530001954.12000-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi, 

The following series is for mlx5-next tree [1], it adds the support of two
new device events, from Ilan Tayari:

1. High temperature warnings.
2. FPGA QP error event.

In case of no objection this series will be applied to mlx5-next tree
and will be sent later as a pull request to both rdma and net trees.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next

Thanks,
Saeed.

Ilan Tayari (2):
  net/mlx5: Add temperature warning event to log
  net/mlx5: Add FPGA QP error event

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 28 +++++++++++++++++++-
 include/linux/mlx5/device.h                  |  8 ++++++
 include/linux/mlx5/mlx5_ifc.h                |  3 ++-
 include/linux/mlx5/mlx5_ifc_fpga.h           | 16 +++++++++++
 4 files changed, 53 insertions(+), 2 deletions(-)

-- 
2.17.0
