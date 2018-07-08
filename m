From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/9] Support mlx5 flow steering with RAW data
Date: Sun,  8 Jul 2018 13:24:36 +0300
Message-ID: <20180708102445.25496-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

>From Yishai:

This series introduces vendor create and destroy flow methods on the
uverbs flow object by using the KABI infra-structure.

It's done in a way that enables the driver to get its specific device
attributes in a raw data to match its underlay specification while still
using the generic ib_flow object for cleanup and code sharing.

In addition, a specific mlx5 matcher object and its create/destroy
methods were introduced. This object matches the underlay flow steering
mask specification and is used as part of mlx5 create flow input data.

This series supports IB_QP/TIR as its flow steering destination as
applicable today via the ib_create_flow API, however, it adds also an
option to work with DEVX object which its destination can be both TIR
and flow table.

Few changes were done in the mlx5 core layer to support forward
compatible for the device specification raw data and to support flow
table when the DEVX destination is used.

As part of this series the default IB destroy handler
(i.e. uverbs_destroy_def_handler()) was exposed from IB core to be
used by the drivers and existing code was refactored to use it.

Thanks

Yishai Hadas (9):
  net/mlx5: Add forward compatible support for the FTE match data
  net/mlx5: Add support for flow table destination number
  IB: Enable uverbs_destroy_def_handler to be used by drivers
  IB/mlx5: Introduce flow steering matcher object
  IB: Consider ib_flow creation by the KABI infrastructure
  IB/mlx5: Introduce vendor create and destroy flow methods
  IB/mlx5: Support adding flow steering rule by raw data
  IB/mlx5: Add support for a flow table destination
  IB/mlx5: Expose vendor flow trees

 drivers/infiniband/core/uverbs.h                   |   3 -
 drivers/infiniband/core/uverbs_cmd.c               |   4 +
 drivers/infiniband/core/uverbs_std_types.c         |   6 +-
 drivers/infiniband/hw/mlx5/Makefile                |   1 +
 drivers/infiniband/hw/mlx5/devx.c                  |  40 ++--
 drivers/infiniband/hw/mlx5/flow.c                  | 249 +++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c                  | 230 +++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  31 +++
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  81 +------
 include/linux/mlx5/fs.h                            |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   1 +
 include/rdma/ib_verbs.h                            |  18 ++
 include/rdma/uverbs_named_ioctl.h                  |  29 ++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  50 ++++-
 16 files changed, 633 insertions(+), 135 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/flow.c
