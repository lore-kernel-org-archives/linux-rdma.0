From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/12] mlx5 core generic EQ API for RDMA ODP
Date: Fri, 16 Nov 2018 13:58:49 -0800
Message-ID: <20181116215901.5874-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patchset is for mlx5-next shared branch, and will be applied there
once the review is done.

This patchset introduces mostly refactoring work and EQ related code updates to
allow moving the ODP rdma only logic from mlx5_core into mlx5 ib where it
belongs, and will allow future updates and optimizations for the rdma ODP
(On Demand Paging) feature to go only to rdma tree.

Patch #1: Fixes the offsets of stored irq affinity hints inside mlx5
irq info array.

Patch #2,3,4: Remove unused fields, code and logic

Patch #5: Move all EQ related logic from main.c to eq.c to allow clear
and seamless refactoring for creating generic EQ management API.

Patch #6: Create mlx5 core EQs in one place, in order to have one entry
point to call from main file.

Patch #7,8: Move EQ related structures into eq_table mlx5 structure and
make eq_table fields and logic private to eq.c file.

Patch #9,10: Create one generic EQ struct and use it in different
EQ types (usages) e.g. (Async, Command, FW pages, completion and ODP)
Introduce generic EQ API to allow creating Generic EQs regardless of
their types, will be uesd to create all mlx5 core EQs in mlx5_core and
ODP EQ in mlx5_ib.

Patch #11: Move ODP logic out from mlx5_core eq.c into mlx5 rdma driver.
odp.c file.

Patch #12: Make the trivial EQE access methods inline.

Thanks,
Saeed.

---
 
Saeed Mahameed (12):
  net/mlx5: EQ, Use the right place to store/read IRQ affinity hint
  net/mlx5: EQ, Remove unused fields and structures
  net/mlx5: EQ, No need to store eq index as a field
  net/mlx5: EQ, Remove redundant completion EQ list lock
  net/mlx5: EQ, Move all EQ logic to eq.c
  net/mlx5: EQ, Create all EQs in one place
  net/mlx5: EQ, irq_info and rmap belong to eq_table
  net/mlx5: EQ, Privatize eq_table and friends
  net/mlx5: EQ, Different EQ types
  net/mlx5: EQ, Generic EQ
  {net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA
  net/mlx5: EQ, Make EQE access methods inline

 drivers/infiniband/hw/mlx5/main.c             |  15 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  15 +-
 drivers/infiniband/hw/mlx5/odp.c              | 281 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  15 +-
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  11 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  34 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 968 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  93 ++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 287 +-----
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  23 -
 include/linux/mlx5/cq.h                       |   2 +-
 include/linux/mlx5/driver.h                   | 151 +--
 include/linux/mlx5/eq.h                       |  60 ++
 17 files changed, 1081 insertions(+), 901 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
 create mode 100644 include/linux/mlx5/eq.h

-- 
2.19.1
