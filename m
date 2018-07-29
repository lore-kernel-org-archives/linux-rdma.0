From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 00/27] Flow actions to mutate packets
Date: Sun, 29 Jul 2018 15:58:38 +0300
Message-ID: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is PATCH variant of RFC posted in previous week to the ML.
https://patchwork.ozlabs.org/cover/944184/

Changelog:
 RFC -> v0:
  * Patch 1 a new patch which refactors the logic
    when getting a flow namespace.
  * Patch 2 was split into two.
  * Patch 3: Fixed a typo in commit message
  * Patch 5: Updated commit message
  * Patch 7: Updated commit message
    Renamed:
      - MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID to
        MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT
      - packet_reformat_id to reformat_id in struct mlx5_flow_act
      - packet_reformat_id to encap_id in struct mlx5_esw_flow_attr
      - packet_reformat_id to encap_id in struct mlx5e_encap_entry
      - PACKET_REFORMAT to REFORMAT when printing trace points
  * Patch 9: Updated commit message
    Updated function declaration in mlx5_core.h, could of lead
    to compile error on bisection.
  * Patch 11: Disallow egress rules insertion when in switchdev mode
  * Patch 12: A new patch to deal with passing enum values using
    the IOCTL infrastructure.
  * Patch 13: Use new enum value attribute when passing enum
    mlx5_ib_uapi_flow_table_type
  * Patch 15: Don't set encap flags on flow tables if in switchdev mode
  * Patch 17: Use new enum value attribute when passing enum
    mlx5_ib_uapi_flow_table_type and enum
    mlx5_ib_uapi_flow_action_packet_reformat_type
  * Patch 19: Allow creation of both
    MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L3_TUNNEL
    and MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L3_TUNNEL_TO_L2 packet
    reformat actions.
  * Patch 20: A new patch which allows attaching packet reformat
    actions to flow tables on NIC RX.

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

Guy Levi (1):
  IB/uverbs: Add IDRs array attribute type to ioctl() interface

Mark Bloch (26):
  net/mlx5: Cleanup flow namespace getter switch logic
  net/mlx5: Add proper NIC TX steering flow tables support
  net/mlx5: Export modify header alloc/dealloc functions
  net/mlx5: Add support for more namespaces when allocating modify
    header
  net/mlx5: Break encap/decap into two separated flow table creation
    flags
  net/mlx5: Move header encap type to IFC header file
  {net, RDMA}/mlx5: Rename encap to reformat packet
  net/mlx5: Expose new packet reformat capabilities
  net/mlx5: Pass a namespace for packet reformat ID allocation
  net/mlx5: Export packet reformat alloc/dealloc functions
  RDMA/mlx5: Add NIC TX steering support
  RDMA/uverbs: Add UVERBS_ATTR_CONST_IN to the specs language
  RDMA/mlx5: Add a new flow action verb, modify header
  RDMA/mlx5: Enable attaching modify header to steering flows
  RDMA/mlx5: Enable decap and packet reformat on flow tables
  RDMA/uverbs: Add generic function to fill in flow action object
  RDMA/mlx5: Add new flow action verb, packet reformat
  RDMA/mlx5: Enable attaching DECAP action to steering flows
  RDMA/mlx5: Extend packet reformat verbs
  RDMA/mlx5: Enable reformat on NIC RX if supported
  RDMA/mlx5: Enable attaching packet reformat action to steering flows
  RDMA/mlx5: Refactor flow action parsing to be more generic
  RDMA/mlx5: Refactor DEVX flow creation
  RDMA/mlx5: Add flow actions support to DEVX create flow
  RDMA/mlx5: Add NIC TX namespace when getting a flow table
  RDMA/mlx5: Allow creating a matcher for a NIC TX flow table

 drivers/infiniband/core/uverbs_ioctl.c             | 115 ++++++-
 .../infiniband/core/uverbs_std_types_flow_action.c |   7 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   6 +-
 drivers/infiniband/hw/mlx5/flow.c                  | 351 ++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/main.c                  | 140 +++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.h        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  50 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  87 +++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  57 ++--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  11 -
 include/linux/mlx5/device.h                        |   6 +
 include/linux/mlx5/fs.h                            |  20 +-
 include/linux/mlx5/mlx5_ifc.h                      |  70 ++--
 include/rdma/uverbs_ioctl.h                        |  98 +++++-
 include/rdma/uverbs_std_types.h                    |  12 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  20 ++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h          |  12 +
 include/uapi/rdma/rdma_user_ioctl_cmds.h           |   2 +-
 22 files changed, 928 insertions(+), 183 deletions(-)
