From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v3 00/14] Verbs flow counters support
Date: Thu, 31 May 2018 16:43:27 +0300
Message-ID: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v2->v3:
 * Change function mlx5_fc_query signature to hide the details of
   internal core driver struct mlx5_fc
 * Add commen to data[] field at struct mlx5_ib_flow_counters_data (mlx5-abi.h)
 * Use array of struct mlx5_ib_flow_counters_desc to clarify the output
v1->v2:
 * Removed conversion from struct mlx5_fc* to void*
 * Fixed one place with double space in it
 * Balanced release of hardware handler in case of counters allocation failure
 * Added Tested-by
 * Minimize time spent holding mutex lock
 * Fixed deadlock caused by nested lock in error path
 * Protect from handler pointer derefence in the error paths

Not changed: mlx5-abi.h

v0->v1:
 * Decouple from DevX submission
 * Use uverbs_attr_get_obj at counters read method
 * Added define for max read buffer size (MAX_COUNTERS_BUFF_SIZE)
 * Removed the struct mlx5_ib_flow_counter basic_flow_cnts and
   the related structs used, used define instead
 * Took Matan's patch from DevX
 * uverbs_free_counters removed void* casting
 * Added check to bound ncounters value (added define
 * Changed user supplied data buffer structure to be array of
   struct <desc,index> pair (applied this change to user space also)

Not changed:
 * UAPI files
 * Addition of uhw to flow

Thanks

----------------------------------------------------------------------
>From Raed:

This series comes to allow user space applications to monitor real time
traffic activity and events of the verbs objects it manages, e.g.:
ibv_qp, ibv_wq, ibv_flow.

This API enables generic counters creation and define mapping
to association with a verbs object, current mlx5 driver using
this API for flow counters.

With this API, an application can monitor the entire life cycle of
object activity, defined here as a static counters attachment.
This API also allows dynamic counters monitoring of measurement points
for a partial period in the verbs object life cycle.

In addition it presents the implementation of the generic counters interface.

This will be achieved by extending flow creation by adding a new flow count
specification type which allows the user to associate a previously created
flow counters using the generic verbs counters interface to the created flow,
once associated the user could read statistics by using the read function of
the generic counters interface.

The API includes:
1. create and destroyed API of a new counters objects
2. read the counters values from HW

Note:
Attaching API to allow application to define the measurement points per objects
is a user space only API and this data is passed to kernel when the counted
object (e.g. flow) is created with the counters object.

Thanks

Matan Barak (2):
  IB/uverbs: Add an ib_uobject getter to ioctl() infrastructure
  IB/core: Support passing uhw for create_flow

Or Gerlitz (1):
  net/mlx5: Use flow counter pointer as input to the query function

Raed Salem (11):
  net/mlx5: Export flow counter related API
  IB/core: Introduce counters object and its create/destroy
  IB/uverbs: Add create/destroy counters support
  IB/core: Introduce counters read verb
  IB/uverbs: Add read counters support
  IB/core: Add support for flow counters
  IB/uverbs: Add support for flow counters
  IB/mlx5: Add counters create and destroy support
  IB/mlx5: Add flow counters binding support
  IB/mlx5: Add flow counters read support
  IB/mlx5: Add counters read support

 drivers/infiniband/core/Makefile                   |   2 +-
 drivers/infiniband/core/uverbs.h                   |   2 +
 drivers/infiniband/core/uverbs_cmd.c               |  88 +++++-
 drivers/infiniband/core/uverbs_std_types.c         |   3 +-
 .../infiniband/core/uverbs_std_types_counters.c    | 157 +++++++++++
 drivers/infiniband/core/uverbs_std_types_cq.c      |  23 +-
 .../infiniband/core/uverbs_std_types_flow_action.c |   4 +-
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/mlx4/main.c                  |   6 +-
 drivers/infiniband/hw/mlx5/main.c                  | 305 ++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  36 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   2 -
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   7 +-
 include/linux/mlx5/fs.h                            |   4 +
 include/rdma/ib_verbs.h                            |  43 ++-
 include/rdma/uverbs_ioctl.h                        |  11 +
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  21 ++
 include/uapi/rdma/ib_user_verbs.h                  |  13 +
 include/uapi/rdma/mlx5-abi.h                       |  24 ++
 20 files changed, 712 insertions(+), 56 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_counters.c
