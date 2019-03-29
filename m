From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/14] Mellanox, mlx5 next updates 2019-03-29
Date: Fri, 29 Mar 2019 15:37:50 -0700
Message-ID: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

This series includes some misc shared code updates for mlx5-next branch.

>From Maxim, Remove un-used macros and spinlock from mlx5 code.

>From Aya, Expose Management PCIE info register layout and add rate limit
print macros.

>From Tariq, Compilation warning fix in fs_core.c

>From Vu, Huy and Saeed, Improve mlx5 initialization flow:
The goal is to provide a better logical separation of mlx5 core
device initialization flow and will help to seamlessly support
creating different mlx5 device types such as PF, VF and SF
mlx5 sub-function virtual devices.

Mlx5_core driver needs to separate HCA resources from pci resources.
Its initialize/load/unload will be broken into stages:
1. Initialize common data structures
2. Setup function which initializes pci resources (for PF/VF)
   or some other specific resources for virtual device
3. Initialize software objects according to hardware capabilities
4. Load all mlx5_core components

It is also necessary to detach mlx5_core mdev name/message from pci
device mdev->pdev name/message for a clearer report/debug of
different mlx5 device types.

Thanks,
Saeed.

---

Aya Levin (2):
  net/mlx5: Add rate limit print macros
  net/mlx5: Expose MPEIN (Management PCIE INfo) register layout

Huy Nguyen (4):
  net/mlx5: Make mlx5_core messages independent from mdev->pdev
  net/mlx5: Use dev->priv.name instead of dev_name
  net/mlx5: Replace dev_err/warn/info by mlx5_core_err/warn/info
  net/mlx5: Add explicit bar address field

Maxim Mikityanskiy (2):
  net/mlx5: Remove unused MLX5_*_DOORBELL_LOCK macros
  net/mlx5: Remove spinlock support from mlx5_write64

Saeed Mahameed (5):
  net/mlx5: Remove redundant init functions parameter
  net/mlx5: Split mdev init and pci init
  net/mlx5: Move health and page alloc init to mdev_init
  net/mlx5: Function setup/teardown procedures
  net/mlx5: Break load_one into three stages

Tariq Toukan (1):
  net/mlx5: Fix false compilation warning

 drivers/infiniband/hw/mlx5/cmd.c              |   4 +-
 drivers/infiniband/hw/mlx5/main.c             |   8 +-
 drivers/infiniband/hw/mlx5/mr.c               |   3 +-
 drivers/infiniband/hw/mlx5/qp.c               |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  22 +-
 .../mlx5/core/diag/fw_tracer_tracepoint.h     |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  44 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 473 ++++++++++--------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c |   2 +-
 include/linux/mlx5/cq.h                       |   2 +-
 include/linux/mlx5/doorbell.h                 |  39 +-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 |  51 +-
 18 files changed, 398 insertions(+), 315 deletions(-)

-- 
2.20.1
