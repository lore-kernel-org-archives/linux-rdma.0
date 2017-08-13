From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-next v1 00/22] RDMA core, drivers and IPoIB fixes
Date: Sun, 13 Aug 2017 13:17:54 +0300
Message-ID: <20170813101816.3120-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This is bunch of fixes to the RDMA stack which we found during code review,
static checkers cleanups and by various code inspections.

There is one exception to this batch - patch from Feras to add
statistics support to SRIOV VF in IPoIB.

However, the diff stat of that change is so small and I didn't find
other batch to attach it.
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 1 file changed, 1 insertion(+)

Thanks

Changelog v0->v1:
 * Patch 20: Reused memchr_inv function instead of open-coded variant
 * Added Dennis's ROB tags

----------------------------------------------------------------
The following changes since commit d0d62c34fb746eaf68df5b3d6f4877c7d1e6320c:

  Merge branch 'rdma-netlink' into k.o/merge-test (2017-08-10 14:34:18 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-08-13

for you to fetch changes up to 4fa57c9c077d8a81e169f19fc411b1da041fc49f:

  IB/ipoib: Add get statistics support to SRIOV VF (2017-08-13 13:13:04 +0300)

----------------------------------------------------------------
RDMA core, drivers and IPoIB fixes

----------------------------------------------------------------
Erez Shitrit (1):
      IB/ipoib: Sync between remove_one to sysfs calls that use rtnl_lock

Feras Daoud (1):
      IB/ipoib: Add get statistics support to SRIOV VF

Guy Levi (4):
      IB/mlx4: Fix RSS QP type in creation verb
      IB/mlx4: Fix struct mlx4_ib_create_wq alignment
      IB/mlx4: Remove redundant attribute in mlx4_ib_create_qp_rss struct
      IB/mlx4: Check that reserved fields in mlx4_ib_create_qp_rss are zero

Leon Romanovsky (11):
      IB/cma: Fix erroneous validation of supported default GID type
      RDMA/mlx4: Don't use uninitialized variable
      RDMA/(core,ulp): Convert register/unregister event handler to be void
      RDMA/core: Cleanup device capability enum
      RDMA/core: Remove unimplemented node_types and node transport
      RDMA/core: Delete BUG() from unreachable flow
      RDMA/core: Refactor get link layer wrapper
      RDMA/mlx4: Remove gfp_mask argument from acquire_group call
      RDMA/usnic: Fix remove address space warning
      RDMA/mthca: Make explicit conversion to 64bit value
      RDMA/hns: Remove empty functions

Maor Gottlieb (2):
      RDMA/mlx4: Fix create qp command alignment
      IB/mlx5: Add necessary delay drop assignment

Parav Pandit (1):
      IB/uverbs: Introduce and use helper functions to copy ah attributes

Talat Batheesh (2):
      IB/mlx4: Fix some spelling mistakes
      IB/mlx5: Fix some spelling mistakes

 drivers/infiniband/core/cache.c                 |  23 ++---
 drivers/infiniband/core/cma.c                   |   4 +-
 drivers/infiniband/core/device.c                |   8 +-
 drivers/infiniband/core/sa_query.c              |   3 +-
 drivers/infiniband/core/sysfs.c                 |   3 -
 drivers/infiniband/core/uverbs_cmd.c            | 124 ++++++++++--------------
 drivers/infiniband/core/uverbs_main.c           |  13 +--
 drivers/infiniband/core/verbs.c                 |  32 ++----
 drivers/infiniband/hw/hns/hns_roce_main.c       |  14 ---
 drivers/infiniband/hw/mlx4/alias_GUID.c         |   2 +-
 drivers/infiniband/hw/mlx4/cq.c                 |   2 +-
 drivers/infiniband/hw/mlx4/mcg.c                |   9 +-
 drivers/infiniband/hw/mlx4/qp.c                 |  16 +--
 drivers/infiniband/hw/mlx5/cq.c                 |   2 +-
 drivers/infiniband/hw/mlx5/mad.c                |   2 +-
 drivers/infiniband/hw/mlx5/main.c               |   2 +
 drivers/infiniband/hw/mthca/mthca_cmd.c         |   2 +-
 drivers/infiniband/hw/usnic/usnic_fwd.c         |  12 +--
 drivers/infiniband/hw/usnic/usnic_fwd.h         |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c     |  10 +-
 drivers/infiniband/ulp/ipoib/ipoib.h            |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c         |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |  16 ++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c       |  22 ++++-
 drivers/infiniband/ulp/iser/iser_verbs.c        |   6 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |   7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c           |   5 +-
 include/rdma/ib_verbs.h                         |  26 +++--
 include/uapi/rdma/mlx4-abi.h                    |   6 +-
 29 files changed, 153 insertions(+), 229 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
