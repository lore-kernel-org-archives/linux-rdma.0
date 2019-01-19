From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 0/4] mlx5 next misc updates
Date: Fri, 18 Jan 2019 16:33:09 -0800
Message-ID: <20190119003313.16711-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi all,

This series includes updates to mlx5-next shared branch.

1) from Jason, improve mlx5_cmd_exec_cb async API to be safer
2) from Maxim Mikityanskiy, cleanups for mlx5_write64 doorbell API
3) from Michael Guralnik, Add pci AtomicOps request

Thanks,
Saeed.

---

Jason Gunthorpe (1):
  net/mlx5: Make mlx5_cmd_exec_cb() a safe API

Maxim Mikityanskiy (2):
  net/mlx5: Remove unused MLX5_*_DOORBELL_LOCK macros
  net/mlx5: Remove spinlock support from mlx5_write64

Michael Guralnik (1):
  net/mlx5: Add pci AtomicOps request

 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  2 +
 drivers/infiniband/hw/mlx5/mr.c               | 39 +++----------
 drivers/infiniband/hw/mlx5/qp.c               |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 55 +++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 11 ++--
 include/linux/mlx5/cq.h                       |  2 +-
 include/linux/mlx5/doorbell.h                 | 36 ++----------
 include/linux/mlx5/driver.h                   | 32 +++++++++--
 11 files changed, 105 insertions(+), 83 deletions(-)

-- 
2.20.1
