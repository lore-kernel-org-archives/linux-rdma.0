From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 0/4] mlx5 core CQE API and misc updates
Date: Tue,  4 Dec 2018 18:02:59 -0800
Message-ID: <20181205020303.16318-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi

This patchset is for mlx5-next shared branch, and will be applied there
once the review is done.

Patches 1,2,3 are trivial improvements to CQE API
1. return CQE pointer instead of void pointer in get_cqe function
2. helper function for retrieving the CQE opcode, used in rdma and netdev

Patch 4, Move flow counters data structures definition to c file.

Thanks,
Saeed.

---

Daniel Jurgens (1):
  net/mlx5: When fetching CQEs return CQE instead of void pointer

Saeed Mahameed (1):
  net/mlx5: Move flow counters data structures from flow steering header

Tariq Toukan (2):
  net/mlx5: Use helper to get CQE opcode
  IB/mlx5: Use helper to get CQE opcode

 drivers/infiniband/hw/mlx5/cq.c               |  8 +++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 10 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.h | 23 -------------------
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 23 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/wq.h  |  2 +-
 include/linux/mlx5/device.h                   |  5 ++++
 8 files changed, 40 insertions(+), 35 deletions(-)

-- 
2.19.2
