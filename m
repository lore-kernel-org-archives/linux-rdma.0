From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH rdma-next 00/18] Flow actions to mutate packets
Date: Mon, 16 Jul 2018 11:22:47 +0300
Message-ID: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series from Mark is marked as RFC due to the fact that it is under
final stages of internal review - commit messages, patch reordering and
internal agreement if "{net, RDMA}/mlx5: Rename encap to reformat packet"
is needed.

Because the main logic and functionality are not expected to change, we
would like to post it the mailing list and gather broader feedback than
we can achieve internally.

We will resubmit it without RFC tag once review will complete.

Thanks

------------------------------------------------------------------------
>From Mark:
This series exposes the ability to create flow actions which can
mutate packet headers. We do that by exposing two new verbs:
 * modify header - can change existing packet headers. packet
 * reformat - can encapsulate or decapsulate a packet.
              Once created a flow action must be attached to a steering
              rule for it to take effect.

Thanks

Mark Bloch (18):
  net/mlx5: Add proper NIC TX steering flow tables support
  net/mlx5: Export modify header alloc/dealloc functions
  net/mlx5: Add support for more namespaces when allocating modify
    header
  net/mlx5: Break encap/decap into two separated flags
  net/mlx5: Move header encap type to IFC header file
  {net, RDMA}/mlx5: Rename encap to reformat packet
  net/mlx5: Expose new packet reformat capabilities
  net/mlx5: Allow passing a namespace on packet reformat allocation
  net/mlx5: Export packet reformat alloc/dealloc functions
  RDMA/mlx5: Add NIC TX steering support
  RDMA/mlx5: Add a new flow action verb, modify header
  RDMA/mlx5: Enable attaching modify header to steering flows
  RDMA/mlx5: Enable decap and packet reformat on flow tables
  RDMA/uverbs: Add generic function to fill in flow action object
  RDMA/mlx5: Add new flow action verb, packet reformat
  RDMA/mlx5: Enable attaching DECAP action to steering flows
  RDMA/mlx5: Extend packet reformat verbs
  RDMA/mlx5: Enable attaching packet reformat action to steering flows

 .../infiniband/core/uverbs_std_types_flow_action.c |   7 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   6 +-
 drivers/infiniband/hw/mlx5/flow.c                  | 280 +++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c                  |  65 +++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  14 ++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.h        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  54 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  87 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  57 +++--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  11 -
 include/linux/mlx5/device.h                        |   6 +
 include/linux/mlx5/fs.h                            |  20 +-
 include/linux/mlx5/mlx5_ifc.h                      |  71 ++++--
 include/rdma/uverbs_std_types.h                    |  12 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  18 ++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h          |  12 +
 21 files changed, 591 insertions(+), 154 deletions(-)
