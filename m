From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 0/8] Support mlx5 flow steering with RAW data
Date: Mon, 23 Jul 2018 15:25:04 +0300
Message-ID: <20180723122512.20967-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v1->v2:
 * Fix matcher to use the correct size.
 * Rephrase commit log of the first patch.
v0->v1:
 * Fixed ADD_UVERBS_ATTRIBUTES_SIMPLE macro to pass the real address.
 Â* Replaced UA_ALLOC_AND_COPY to regular copy_from
 * Added UVERBS_ATTR_NO_DATA new macro for cleaner code.
 * Used ib_dev from uobj when it exists.
 * ib_is_destroy_retryable was replaced by ib_destroy_usecnt

-------------------------------------------------------------------------
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

Yishai Hadas (8):
  net/mlx5: Add forward compatible support for the FTE match data
  net/mlx5: Add support for flow table destination number
  IB/mlx5: Introduce flow steering matcher object
  IB: Consider ib_flow creation by the KABI infrastructure
  IB/mlx5: Introduce vendor create and destroy flow methods
  IB/mlx5: Support adding flow steering rule by raw data
  IB/mlx5: Add support for a flow table destination
  IB/mlx5: Expose vendor flow trees

 drivers/infiniband/core/uverbs_cmd.c               |   4 +
 drivers/infiniband/core/uverbs_std_types.c         |   5 +-
 .../infiniband/core/uverbs_std_types_flow_action.c |   3 +-
 drivers/infiniband/hw/mlx5/Makefile                |   1 +
 drivers/infiniband/hw/mlx5/devx.c                  |  22 ++
 drivers/infiniband/hw/mlx5/flow.c                  | 254 +++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c                  | 230 +++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  31 +++
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  81 +------
 include/linux/mlx5/fs.h                            |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   1 +
 include/rdma/ib_verbs.h                            |  15 ++
 include/rdma/uverbs_ioctl.h                        |   2 +
 include/rdma/uverbs_named_ioctl.h                  |  29 ++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  50 +++-
 17 files changed, 636 insertions(+), 120 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/flow.c
