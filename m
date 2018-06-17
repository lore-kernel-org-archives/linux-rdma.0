From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 00/20] Introduce mlx5 DEVX interface
Date: Sun, 17 Jun 2018 12:59:46 +0300
Message-ID: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v1->v2:
 * Rebase on top of v4.18-rc1
v0 -> v1:
 * Dropped few validation/debug patches from the KABI part as of Jason's comments.
 * Use kvmalloc/kvfree instead of kmalloc/kfree to prevent higher order allocation under user control.
 * Cleaned up a dependency of CONFIG_INFINIBAND_USER_ACCESS from the uverbs layer.
 * Moved to white list command mode.
 * Serialize access to DEVX object - odify/read new methods were added
   with the appropriate IDR lock.
 * Block DEVX on IB port as of SELinux.
 * Improve uverbs_cleanup_ucontext algorithm to support two objects from the same type.
 * Fix mlx5_ifc.h to use reserved_at_xxx.
 * Enforce devx_uid existence upon DEVX methods.

>From Yishai:
----------------------------------------------------------------------
This DEVX series enables direct access from the user space area to the
mlx5 device driver by using the KABI mechanism.

The main purpose here is to make the user space driver as independent as
possible from the kernel so that future device functionality and commands
can be activated with minimal to none kernel changes.

The series keeps the same level of user process security/isolation as
provided today by the kernel IB verbs by using a user id returned from
the firmware upon context creation.

This user id is put by the kernel code in all firmware command from the
DEVX interface so that the isolation/security will be enforced by the
firmware based on that id.

Below kernel services are exposed to let the above work:

1) Expose a DEVX object that represent some underlay firmware object,
the input command to create it is some raw data given by the user
application which should match the device specification.

2) Expose a UMEM DEVX object for user memory registration for DMA:
The driver provides an API to register user memory, getting as input the
user address, length and access flags, and provides to the user as output
an ID (UMEM ID) returned by the firmware to this registered memory.

The user will use that UMEM ID in device direct commands that use this
memory instead of the physical addresses list.

3) Expose device general command API:
The driver provides an API to issue some general command except than
create and destroy.

4) UAR mapping:
Returns a device UAR ID for a given user index by using the kernel
context information.

This is safe from security point of view as described in details in the
relevant patch in the series.

5) EQ mapping:
Returns the matching device EQN for a given user vector number via the
DEVX interface.

6) Process resources cleanup:
This is achieved by the existing kernel KABI logic, upon DEVX object
creation the kernel builds the FW destroy command inbox in the KABI
object and uses it upon cleanup.

7) Future device commands:
This will be supported by some general command type (create, destroy)
that the DEVX code embeds as part of its code and is going to be
used from now on by the firmware.

At the beginning of this series there are some KABI infra-structures
improvements and fixes to enable the above DEVX functionality in a
cleaner way.

More details appear as part of the commit logs of the series and as part
of the comments in the code itself.

Thanks

Leon Romanovsky (2):
  drm/i915: Move u64-to-ptr helpers to general header
  kernel.h: Reuse u64_to_ptr macro to cast __user pointers

Matan Barak (5):
  IB/uverbs: Export uverbs idr and fd types
  IB/uverbs: Refactor uverbs_finalize_objects
  IB/uverbs: Add PTR_IN attributes that are allocated/copied
    automatically
  IB/uverbs: Add a macro to define a type with no kernel known size
  IB/uverbs: Allow an empty namespace in ioctl() framework

Yishai Hadas (13):
  net/mlx5_core: Prevent warns in dmesg upon firmware commands
  IB/core: Improve uverbs_cleanup_ucontext algorithm
  net/mlx5: Expose DEVX ifc structures
  IB/mlx5: Introduce DEVX
  IB/core: Introduce DECLARE_UVERBS_GLOBAL_METHODS
  IB: Expose ib_ucontext from a given ib_uverbs_file
  IB/mlx5: Add support for DEVX general command
  IB/mlx5: Add obj create and destroy functionality
  IB/mlx5: Add DEVX support for modify and query commands
  IB/mlx5: Add support for DEVX query UAR
  IB/mlx5: Add DEVX support for memory registration
  IB/mlx5: Add DEVX query EQN support
  IB/mlx5: Expose DEVX tree

 drivers/gpu/drm/i915/i915_utils.h                  |   12 +-
 drivers/infiniband/core/rdma_core.c                |  138 +--
 drivers/infiniband/core/rdma_core.h                |   10 +-
 drivers/infiniband/core/uverbs_ioctl.c             |  104 +-
 drivers/infiniband/core/uverbs_main.c              |    6 +
 drivers/infiniband/core/uverbs_std_types.c         |   26 +-
 .../infiniband/core/uverbs_std_types_counters.c    |    2 +-
 drivers/infiniband/core/uverbs_std_types_cq.c      |    2 +-
 drivers/infiniband/core/uverbs_std_types_dm.c      |    3 +-
 .../infiniband/core/uverbs_std_types_flow_action.c |    2 +-
 drivers/infiniband/core/uverbs_std_types_mr.c      |    3 +-
 drivers/infiniband/hw/mlx5/Makefile                |    1 +
 drivers/infiniband/hw/mlx5/devx.c                  | 1106 ++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c                  |   31 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   19 +
 drivers/infiniband/hw/mlx5/qp.c                    |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   24 +-
 include/linux/kernel.h                             |   11 +-
 include/linux/mlx5/device.h                        |    3 +
 include/linux/mlx5/mlx5_ifc.h                      |   71 +-
 include/rdma/ib_verbs.h                            |    4 +-
 include/rdma/uverbs_ioctl.h                        |   27 +
 include/rdma/uverbs_named_ioctl.h                  |    4 +
 include/rdma/uverbs_std_types.h                    |    2 -
 include/rdma/uverbs_types.h                        |   11 +-
 include/uapi/rdma/mlx5-abi.h                       |    3 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |   73 ++
 27 files changed, 1548 insertions(+), 159 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/devx.c
